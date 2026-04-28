---
applyTo: "**/*.ps1,**/*.psm1"
description: "Common patterns and helper functions in Microsoft365DSC"
---

# Common Patterns in Microsoft365DSC

This guide defines the shared logic patterns used throughout the project.

## Connection Handling

## Authentication Requirements

All Microsoft365DSC resources authenticate using `New-M365DSCConnection` from the `MSCloudLoginAssistant` PowerShell module.

Resources must **not** require explicit authentication per resource.
They depend on the global Microsoft365DSC auth session.

Do **not** call Graph or service connections manually.

Helpers location and usage:

- Common helper functions live in `Modules/Microsoft365DSC/Modules/M365DSCUtil` and utility templates in `ResourceGenerator/Module.Template.psm1`.
- Prefer `New-M365DSCConnection` for creating authenticated sessions. Example pattern:

```powershell
...
$null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters
```

Forbidden patterns:

- Do not perform resource-level direct Graph auth (e.g. `Connect-MgGraph` inside each resource) unless a documented exception is provided.
- Do not embed raw secrets, tokens, or credentials in code or telemetry at any time.

## Logging

Use:

- `Write-M365DSCHost` for user output
- `Write-Verbose` for Verbose messages
- Never use `Write-Host` except for interactive scenarios
- **Do not** add extra `Write-Verbose` in catch blocks — only use `New-M365DSCLogEntry` + `throw`
- **Do not** output the results of `Get-TargetResource` to log or console
- **Do not** output status messages for `Test-TargetResource` results — it must only return `$true` or `$false`

## Exception Handling

Use the built-in error helpers with a try/catch block. **Do not** add extra `Write-Verbose` statements in catch blocks. Follow the standard `New-M365DSCLogEntry` + `throw` pattern used across the codebase. Example pattern:

```powershell
New-M365DSCLogEntry -Message 'Error retrieving data:' `
    -Exception $_ `
    -Source $($MyInvocation.MyCommand.Source) `
    -TenantId $TenantId `
    -Credential $Credential

throw
```

## Debugging

- **Do not** add helper methods or functions for debugging purposes. Use the existing logging utilities (`Write-Verbose`, `New-M365DSCLogEntry`, etc.).

## Set-TargetResource Rules

- **Never call `Test-TargetResource` inside `Set-TargetResource`.** The DSC engine handles the Test -> Set flow automatically. The Set function must only implement the configuration changes.

## Endpoint URLs

- **Never hardcode** URLs to Microsoft endpoints (e.g., `https://graph.microsoft.com`, `https://management.azure.com`). Use `Get-MSCloudLoginConnectionProfile` or equivalent helpers to obtain base URLs at runtime. This ensures cloud-agnostic behaviour for GCC, GCC-High, DoD, China, and other sovereign clouds.

## Complex Type Handling

For detailed patterns on working with complex types (CIM instances, embedded objects, nested arrays), including conversion helpers, deep comparison, export serialization, and unit testing, see `m365dsc-complex-types.instructions.md`.

## Drift Detection Patterns

Test-TargetResource must always use the pre-defined comparison block:

```powershell
#region Telemetry
$ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
$CommandName = $MyInvocation.MyCommand
$data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
    -CommandName $CommandName `
    -Parameters $PSBoundParameters
Add-M365DSCTelemetryEvent -Data $data
#endregion

# This block is optional and can be omitted if no customization is required
<#
$postProcessingScript = {
    param($DesiredValues, $CurrentValues, $ValuesToCheck, $ignore)
    # Do something with $DesiredValues, $CurrentValues or $ValuesToCheck
    # ...

    return [System.Tuple[Hashtable, Hashtable, Hashtable]]::new($DesiredValues, $CurrentValues, $ValuesToCheck)
}
#>

$result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
                                        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '')
return $result
```

If the `postProcessingScript` is defined, then the parameter `-PostProcessing` with the value `$postProcessingScript` must be appended to `Test-M365DSCTargetResource`.

## Reverse DSC (Export-TargetResource)

When generating exported configuration:

- Output objects in alphabetical parameter order
- Avoid emitting default values
- **Always include `$Filter` parameter support** for client-side filtering. See `ResourceGenerator/Templates/Module.Template.psm1` for the standard pattern.

It is always the same set of steps. Refer to `ResourceGenerator/Templates/Module.Template.psm1` with the function `Export-TargetResource`.

## Documentation Rules

The documentation is built automatically inside of the pipeline and deployed to the website https://microsoft365dsc.com.

The cmdlet responsible for this is `Update-M365DSCResourceDocumentationPage` and `New-M365DSCCmdletDocumentation` from the module `Modules/Microsoft365DSC/Modules/M365DSCDogGenerator` and `Modules/Microsoft365DSC/Modules/M365DSCUtil`.

Telemetry rules:

- Telemetry must never include PII. Use `Format-M365DSCTelemetryParameters` to normalize events.
- Telemetry helper functions live in `Modules/Microsoft365DSC/Modules/M365DSCUtil` - prefer those helpers instead of ad-hoc telemetry code.
