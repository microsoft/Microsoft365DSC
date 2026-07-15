# Microsoft365DSC

This module allows organizations to automate the deployment,
configuration, reporting and monitoring of Microsoft 365 Tenants via PowerShell
Desired State Configuration. The compiled configuration needs to be
executed from an agent's Local Configuration Manager (LCM) (machine
or container) which can communicate back remotely to Microsoft 365 via
remote API calls (therefore requires internet connectivity)

For information on how to get started, additional documentation or
additional resources, please navigate to the official web site at
[Microsoft365DSC.com](http://Microsoft365DSC.com) and check out the
official YouTube channel
[Microsoft365DSC](https://www.youtube.com/channel/UCveScabVT6pxzqYgGRu17iw).

## Branches

### master

[![codecov](https://codecov.io/gh/Microsoft/Microsoft365DSC/branch/master/graph/badge.svg)](https://codecov.io/gh/Microsoft/Microsoft365DSC)

This is the branch containing the latest release. No contributions should be made directly to this branch.

### dev

[![Unit Tests](https://github.com/microsoft/Microsoft365DSC/actions/workflows/Unit%20Tests.yml/badge.svg)](https://github.com/microsoft/Microsoft365DSC/actions/workflows/Unit%20Tests.yml)

[![Global - Integration - AAD](https://github.com/microsoft/Microsoft365DSC/actions/workflows/Global%20-%20Integration%20-%20AAD.yml/badge.svg)](https://github.com/microsoft/Microsoft365DSC/actions/workflows/Global%20-%20Integration%20-%20AAD.yml)

[![Global - Integration - EXO](https://github.com/microsoft/Microsoft365DSC/actions/workflows/Global%20-%20Integration%20-%20EXO.yml/badge.svg)](https://github.com/microsoft/Microsoft365DSC/actions/workflows/Global%20-%20Integration%20-%20EXO.yml)

[![Global - Integration - INTUNE](https://github.com/microsoft/Microsoft365DSC/actions/workflows/Global%20-%20Integration%20-%20INTUNE.yml/badge.svg)](https://github.com/microsoft/Microsoft365DSC/actions/workflows/Global%20-%20Integration%20-%20INTUNE.yml)

Contributors are encouraged to propose their contributions as pull requests to this development branch.
This branch will periodically be merged to the master branch,
and be released to [PowerShell Gallery](https://www.powershellgallery.com/).

## How to Install

To acquire the latest
bits of the module from a machine that has internet connectivity,
run the following PowerShell lines:

```powershell
Install-Module -Name Microsoft365DSC -Force
Update-M365DSCModule
```

## License Requirements

Some resources in this module — specifically those covering **Defender for Office 365** — require a **Microsoft 365 E5** license, or **Microsoft 365 E3 combined with the Defender for Office 365 Plan 2 add-on**. A standard E3 license only includes **Exchange Online Protection (EOP)**, which supports basic anti-spam/anti-malware settings but not the advanced Defender for Office 365 feature set.

### Affected resources

The following resources require Defender for Office 365 (Plan 2) and will fail against an E3-only tenant:

- `EXOAntiPhishPolicy`
- `EXOSafeAttachmentPolicy`
- `EXOSafeLinksPolicy`
- `EXOAtpPolicyForO365`
- `EXOAtpProtectionPolicyRule`
- `EXOMalwareFilterPolicy`

### Supported vs. unsupported licensing

| License SKU | Includes Defender for Office 365? | Result |
|---|---|---|
| Microsoft 365 E5 | Yes (Plan 2) | Fully supported |
| Microsoft 365 E3 + Defender for Office 365 Plan 2 (add-on) | Yes (Plan 2) | Fully supported |
| Office 365 E5 | Yes (Plan 2) | Fully supported |
| Microsoft 365 E3 | No | Deployment will fail |
| Office 365 E3 | No (EOP only) | Deployment will fail |

### What happens without the required license

Deploying the affected resources against a tenant without Defender for Office 365 will fail with parameter errors rather than a clear licensing message, for example:

```
A parameter cannot be found that matches parameter name 'EnableTargetedDomainsProtection'
A parameter cannot be found that matches parameter name 'PhishThresholdLevel'
```

If you hit errors like these, check your tenant's licensing before assuming it's a configuration or module bug.

### Verifying your license before deploying

**PowerShell (Microsoft Graph):**

```powershell
Connect-MgGraph -Scopes "Organization.Read.All"
Get-MgSubscribedSku | Where-Object { $_.SkuPartNumber -like "*E5*" }
```

**Functional check (Exchange Online):**

```powershell
Connect-ExchangeOnline -AppId <AppId> -CertificateThumbprint <Thumbprint> -Organization <Organization>
Get-AntiPhishPolicy -Identity "Office365 AntiPhish Default" -Advanced
```

If the `-Advanced` parameter succeeds, Defender for Office 365 is active on the tenant.

## Telemetry Disclaimer

Microsoft365DSC captures Telemetry data about the names of the resources
in which a configuration drift has been detected, along with the type
of exceptions being thrown by errors in the various modules. While no
sensitive data is ever captured, App Insights, which performs
telemetry analytics, captures information about the city
where the telemetry entries were captured by default. Users can
opt-out to prevent telemetry from being sent back to the Microsoft365DSC team
by running the following command:

```powershell
Set-M365DSCTelemetryOption -Enabled $False
```
