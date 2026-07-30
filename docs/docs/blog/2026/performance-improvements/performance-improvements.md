# Under the Hood: How We Make Microsoft365DSC Exports Faster

<img src="../../../images/FabienTschanz.jpg" style="width:75px;border-radius:50%;border:3px solid black;float:left;" />
<div style="position:inherit;padding-top:15px;"><span style="float:left;padding-left:15px;"><b>by <a href="https://www.linkedin.com/in/fabien-tschanz">Fabien Tschanz</a><br />
July 23rd, 2026</b></span></div>

<br/>
<br/>

## Table of contents

1. [Introduction](#introduction)
2. [The problem: hundreds of resources, one tenant](#the-problem-hundreds-of-resources-one-tenant)
3. [Pre-fetching and aggregating in Intune](#pre-fetching-and-aggregating-in-intune)
4. [Dispatching to resources](#dispatching-to-resources)
5. [Parallel export](#parallel-export)
6. [Internal caching](#internal-caching)
7. [Compiled C# code vs. PowerShell native](#compiled-c-code-vs-powershell-native)
8. [Sharing C# assemblies across runspaces](#sharing-c-assemblies-across-runspaces)
9. [Putting it all together](#putting-it-all-together)
10. [Wrapping up](#wrapping-up)

## Introduction

Microsoft365DSC covers 533 resource types (on July 22nd, 2026) across a dozen workloads, and a full tenant export touches every one of them. That is a lot of API surface to walk, and if every resource fended for itself, an export would spend most of its time waiting on the network instead of doing useful work. In this post, I want to walk through some of the measures we take under the hood to keep exports and monitoring running fast, specifically around Intune, with parallelism, caching, and how we handle the compiled parts of the module.

None of these are one big fix. They are several smaller, targeted changes that add up, and they are worth explaining individually to give you an impression of the efforts we take to give you the fastest experience possible.

## The problem: hundreds of resources, one tenant

When doing exports, Microsoft365DSC walks through every resource type and calls the corresponding `Export-TargetResource` function for each one. Each resource is responsible for fetching its own data from the underlying API. AAD and Intune almost exclusively target the Graph API, EXO and SC target the Exchange Online PowerShell, SharePoint uses the PnP.PowerShell module, and Teams uses the Teams PowerShell module. Each of those APIs has its own rate limits, and each resource has its own logic for how to fetch the data it needs. Some resources share the same underlying data source, and if each of them fetches that data independently, you end up with a lot of redundant round trips across the network.

A good example is Intune. Configuration policies (the ones using the Settings Catalog in the background) in Intune are backed by templates, and Microsoft365DSC exposes roughly forty different resources that all resolve to the same underlying Graph call, `Get-MgBetaDeviceManagementConfigurationPolicy`, filtered afterwards by `templateId`. Historically, each of those forty resources called that endpoint independently inside its own `Export-TargetResource` function. Technically that is correct and was the way it was designed, but it means a subset of the same data is fetched forty times, many network calls are made for data that could be fetched once, and the export is dominated by waiting on the network instead of doing actual work.

Multiply that pattern across other workloads with similarly-shaped resources, and you can imagine how much time that can take.

Btw, this not only affects exports, but also monitoring. The function `Assert-M365DSCBlueprint` does an export of the current configuration and compares it against a blueprint. If the export is slow, the monitoring is slow too.

## Pre-fetching and aggregating in Intune

Specifically for Intune and the mentioned configuration policies, one of the fixes we apply is to pre-fetch. Instead of letting each of the forty resources issue its own request, we fetch the full set of configuration policies for the tenant once, up front, and aggregate the results in memory before any individual resource ever runs:

```powershell
# Pulled once, ahead of any individual resource's Export-TargetResource
$allRequestedConfigurationPolicies = Get-MgBetaDeviceManagementConfigurationPolicy -All

# Fetch settings and settingDefinitions
$batchRequests = @()
foreach ($policy in $allRequestedConfigurationPolicies)
{
    ...
}
...

# Populate the cache with the aggregated results, keyed by templateId
[Microsoft365DSC.Intune.ConfigurationPolicyCache]::Populate($allRequestedConfigurationPolicies, [System.Func[System.Object, System.String]]{ param($policy) $policy.templateReference.templateId })
```

That single call replaces what used to be forty. The aggregation step groups the results by `templateId`, which is the same key each resource already uses internally to decide whether a given policy belongs to it.
The C# code to store and retrieve the aggregated results plays an important role, but more on that a bit later. The important part is that the forty resources that share the same underlying data source now get their data from a single, pre-fetched set instead of each fetching it independently, drastically reducing the number of network requests and the time spent waiting on them.

## Dispatching to resources

Once the data is aggregated, it needs to reach the resources that actually own it, without those resources needing to know that pre-fetching happened at all. We dispatch the relevant slice of the aggregated set to each resource's `Export-TargetResource`, keyed by template:

```powershell
# Inside of Export-TargetResource for a given resource
# Get the pre-fetched, aggregated set of configuration policies from the cache
[array]$getValue = Get-M365DSCExportCachedConfigurationPolicies `
    -TemplateId $policyTemplateID `
    -Filter $Filter
```

This keeps the change contained. Each resource's export logic still looks the same from the outside; it just receives instances instead of retrieving them itself when a pre-fetch has already happened upstream. It also means new template-based resources can opt into the same pattern without any special-casing. One single file mapping the template id to the resource type is all that is needed to make the dispatching work, and that mapping is maintained in a single place.

## Parallel export

Pre-fetching cuts down on redundant calls, but a lot of an export's time is still spent waiting on independent, unrelated resources: a SharePoint site here, a Teams policy there. Those are natural candidates for running in parallel rather than sequentially, and this is where PowerShell runspaces (or rather the awesome [PSParallelPipeline module](https://github.com/santisq/PSParallelPipeline)) come in. This module is a better implementation than `ForEach-Object -Parallel` that allows us to run multiple resources in parallel, while still working in Windows PowerShell 5.1. The `-Parallel` switch on `Foreach-Object` is only available in PowerShell 7+, while Microsoft365DSC has to support both Windows PowerShell 5.1 and PowerShell 7+.

By default, Microsoft365DSC exports sequentially. You can opt in to the parallel export using `Export-M365DSCConfiguration <...> -Parallel`, which will then run the export using multiple runspaces in a pool. It is worth being upfront that this isn't free: parallel execution is more memory- and compute-intensive than sequential execution, and it does not automatically guarantee a faster export, especially once you are bound by Graph or Exchange Online throttling rather than by CPU. Where it earns its keep is on resources with many independent instances (large tenants with hundreds of SharePoint sites, for example), running concurrently, so the export isn't purely serial and can overlap waiting on the network with doing actual work.

Of course the parallel export is available to `Assert-M365DSCBlueprint` as well, so monitoring can benefit from the same performance improvements.

## Internal caching

Not every duplicate call is as obvious as the Intune example above. Plenty of resources touch shared, slow-changing context, tenant details, group memberships, license SKUs, that gets requested over and over across unrelated resources during a single run. We cache some of that data internally for the lifetime of an export, so the second, third, and x-th resource that needs it reads from memory instead of issuing another request.

The cache is deliberately scoped to a single export run. We are optimizing for not re-asking the same question twice during one pass over a tenant, not for serving stale data across separate invocations. Some of the data however is requested resource by resource to make sure there is no stale data at all present. Worst thing that can happen is a resource getting exported with an incorrect value because someone in the meantime made a change.

## Compiled C# code vs PowerShell native

Microsoft365DSC is a hybrid module. Some of the code is written in C# and compiled into assemblies, while some of it is written in PowerShell and interpreted at runtime. The C# code is used for performance-critical parts, like caching, lookups, drift comparison, CPU-heavy tasks and other performance-sensitive areas while the PowerShell code is used for resource logic and orchestration. We don't want to rewrite all of Microsoft365DSC in C#, but we do want to make sure the parts that matter most for performance are compiled and optimized, rather than interpreted at runtime. PowerShell is a great language, but it is also not the fastest one out there. Because we are many contributors to the project and want to keep the barrier to entry low, we want to keep most of the code in PowerShell.

## Sharing C# assemblies across runspaces

The last piece is less about network calls and more about process startup cost. During parallel exports, Microsoft365DSC's compiled assemblies get loaded once per process, not once per runspace. Since the runspace pool behind the parallel export is created once in the process and all runspaces in the pool run in the same process, we can leverage assemblies that are loaded into the process to share data across several runspaces. We only found that out after trying to improve the performance of parallel logins in the `MSCloudLoginAssistant` module, where we first failed miserably integrating the `ExchangeOnlineManagement` module. It kept throwing errors and telling us that we needed to call `Connect-ExchangeOnline` in every runspace, despite calling it repeatedly. The reason was that the runspaces started overwriting each other's session state, and the only way to avoid that was to put a guard lock around the login and keeping track of one single authenticated session for all runspaces. That is exactly what we adapted for the pre-fetching in Microsoft365DSC, and it works very well. The shared data is stored in the assemblies, and the runspaces can access it without having to re-fetch it or re-authenticate.

## Some Export Benchmark numbers

Benchmarks were performed on Azure Devops with a tenant with a broad footprint across Intune, Exchange Online, Purview and Teams. Other workloads benefit too, but not as much as Intune.
The used runner image is the `windows-latest` image on a Standard D2as v5 (2 vCPUs, 8 GB memory) VM.

All benchmark times are averaged over several runs, and the numbers are rounded to the nearest 5 seconds. The export was run with `Export-M365DSCConfiguration -Parallel` for the parallel export, and without `-Parallel` for the sequential export. The pre-fetching and parallel export benchmark was run with version 1.26.722.1 of Microsoft365DSC, where those changes were introduced. The sequential export was benchmarked with version 1.26.715.1, the previous release.

| Workload | Sequential Export | Sequential with Pre-fetching | Parallel Export |
| -------- | ----------------- | ---------------------------- | --------------- |
| Intune | 4m 25s | 2m 10s | 1m 30s |
| Exchange Online | 1m 05s | - | 45s |
| Purview | 7m 55s | - | 4m 45s |
| Teams | 1m 05s | - | 40s |

As we can see, the pre-fetching and parallel export changes have a significant impact on the overall export time, especially for workloads with many resources like Intune and Purview. The improvements are less pronounced for workloads with fewer resources, but they still contribute to a faster overall export. If there are several very slow resources in a workload, it is still possible for the export to be dominated by those resources. However, you should still see a (potentially huge) improvement in the overall export time.

## Putting it all together

None of these measures fix the same problem twice, and that is intentional:

- **Pre-fetching and aggregating** cuts down on redundant Graph calls for resources that share an underlying data source.
- **Dispatching** gets that pre-fetched data to the right resource without changing how the resource itself is written.
- **Parallel export** overlaps independent, unrelated work so the export isn't purely serial.
- **Internal caching** avoids re-fetching shared, slow-changing context within a single run.
- **Compiled C# code** makes sure the performance-critical parts of the module are optimized and not interpreted at runtime.
- **Shared C# assemblies** cut fixed startup cost out of every parallel runspace.

Individually, each of these shaves time off a specific part of an export. Together, on a tenant with a broad footprint across Intune, SharePoint, and Teams, they change an export from something dominated by redundant, sequential round trips into something much closer to "as fast as the APIs themselves allow."

## Wrapping up

Performance work like this rarely comes from a single big rewrite. It comes from noticing a specific, repeated pattern, like forty resources calling the same endpoint, and fixing that pattern directly. If you run large exports and want to help us find the next one, the best thing you can do is open an issue with details about which resources or workloads are slow for your tenant, and we'll dig in from there.

Thank you for using Microsoft365DSC!
