# Copilot Instructions for Microsoft365DSC

This guide enables AI coding agents to be productive in the Microsoft365DSC codebase. It summarizes architecture, workflows, conventions, and integration points specific to this project.

## Architecture Overview

- **Purpose:** Automate deployment, configuration, reporting, and monitoring of Microsoft 365 Tenants using PowerShell Desired State Configuration (DSC).
- **Core Components:**
  - `Modules/Microsoft365DSC`: Contains DSC resources for individual Microsoft 365 services (e.g., Exchange, Teams, SharePoint) and other core modules shared across the Microsoft365DSC module.
    - `Dependencies/`: Contains images for the README files, `Manifest.psd1` for the module dependencies and their versions, and other files.
    - `DSCResources/`: The directory containing all of the DSC resources.
    - `Examples`: The directory containing all of the DSC resource examples.
    - `Modules`: The directory containing all of the shared core modules.
  - `ResourceGenerator/`: Utilities for generating resource definitions.
  - `generator/`: TypeScript/Node.js code for resource generation and supporting scripts.
  - `dev-package/`: Development modules and tests.
  - `Tests/`: PowerShell-based unit and integration tests for DSC resources.
- **Data Flow:** Configurations are compiled and executed by an agent's Local Configuration Manager (LCM), which communicates with Microsoft 365 via remote API calls. Other option is to execute them e.g. with DSCv3s `dsc.exe`.

## Developer Workflows

- **Installation:**
  - Use `Install-Module -Name Microsoft365DSC -Force` to install.
  - Update with `Update-M365DSCModule`.
- **Testing:**
  - Run unit tests in `Tests/Unit/` using VS Code or in PowerShell. Example: `Invoke-Pester -Path Tests/Unit`.
  - CI runs workflows in `.github/workflows/` for code coverage, integration tests, and other checks.
- **Telemetry:**
  - Telemetry is enabled by default. Disable with `Set-M365DSCTelemetryOption -Enabled $False`.
- **Branching:**
  - All contributions start from the `dev` branch. Direct commits to `master` are prohibited. Use a feature branch to develop new features or fixes.

## Project-Specific Conventions

- **Resource Naming:** DSC resources follow the pattern `<Workload><Resource>`, e.g., `EXOGroupSettings`. The schema file name has `.schema.mof` ending. Each file is prefixed with `MSFT_`.
- **Schema Files:** `*.schema.mof` files are **manually authored** — edit them directly to add, remove, or modify resource parameters. `Modules/Microsoft365DSC/SchemaDefinition.json` is **auto-generated** from all `*.schema.mof` files and must **never** be edited by hand.
- **Testing:** Each resource has a corresponding test file in `Tests/Unit/Microsoft365DSC/`. Its name is `Microsoft365DSC.<ResourceName>.Tests.ps1`.
- **Documentation:** Resource documentation is in `docs/` and `README.md`.
- **External Dependencies:**
  - PowerShell modules (e.g., `Microsoft.Graph`, `Pester`).
  - TypeScript dependencies in `generator/package.json`.

## DSC Resource Coding Rules

These rules apply to all DSC resource implementations. Agents **must** follow them:

1. **No helper/debug methods.** Do not add helper functions for debugging purposes. Use existing utilities only.
2. **No status output from Test-TargetResource.** Do not log or display the result of `Test-TargetResource`. It must only return `$true` or `$false`.
3. **No logging Get-TargetResource results.** Do not output `Get-TargetResource` results to log or console.
4. **Export must include `$Filter` support.** Every `Export-TargetResource` must accept and honour a `$Filter` parameter.
5. **Export: use `Add-Member` for DomainId.** Do not use hashtable normalization. Use `Add-Member -NotePropertyName 'DomainId'` instead.
6. **Standard error handling only.** No extra `Write-Verbose` in catch blocks. Use only `New-M365DSCLogEntry` + `throw`.
7. **No `Test-TargetResource` call in `Set-TargetResource`.** DSC handles Test→Set automatically.
8. **Never hardcode endpoint URLs.** Use `Get-MSCloudLoginConnectionProfile` or equivalent helpers for cloud-agnostic URLs.
9. **Increment build version on new schema.mof changes.** If updating a `.schema.mof` not yet in `dev` or `main`, increment its build version.
10. **`Ensure` or `IsSingleInstance` required.** Singleton resources need `[Key] String IsSingleInstance` (`ValueMap{"Yes"}`). Multi-instance resources need `Ensure` (`ValueMap{"Present","Absent"}`). Rare exceptions must be justified.
11. **Unit tests: mock all external functions and add stubs.** Mock all functions from other modules. Add mock stubs to `Tests/Unit/Stubs/` in the correct `#region` (alphabetical order). Create a new region if the module is not yet present.
12. **Prefer non-beta modules and endpoints.** Use GA modules and REST endpoints. Only use beta when functionality is not yet available in GA.
13. **`Get-TargetResource` must always return the key parameter(s) and `Ensure` in all code paths.** Even in the "not found" (null/Absent) return hashtable, the identity key (e.g., `Identity`, `GroupID`) must be included and `Ensure` must be set to `'Absent'`.
14. **Check for `$null` explicitly before accessing properties.** Use `if ($null -ne $object)` rather than letting the `catch` block handle null references. Provide a graceful, descriptive error message.
15. **Use `elseif` for mutually exclusive `Ensure` branches in `Set-TargetResource`.** Pattern: `if ($Ensure -eq 'Present' -and ...) { } elseif ($Ensure -eq 'Absent' -and ...) { }`. Only enter the `Absent` branch when the resource currently exists.
16. **Never nest functions inside other functions.** Helper functions must be defined at module scope, not embedded inside `Get-`, `Set-`, or `Test-TargetResource`.
17. **All helper functions must follow `Verb-Noun` naming.** Use approved PowerShell verbs (e.g., `Get-`, `Set-`, `Test-`, `Convert-`, `Compare-`). No PascalCase-only names.
18. **Use `Write-Verbose -Message "..."` (named parameter).** Always pass the message with the `-Message` parameter, not positionally.
19. **Error messages must be resource-specific.** Never copy-paste error messages from other resources. Each message must reference the current resource's context. When `Ensure = 'Absent'` is unsupported, throw: `"This resource cannot delete [Entity]. Please make sure you set its Ensure value to Present."`.
20. **Every new DSC resource must add an export block to the central export function.** When adding a new resource, ensure `Export-M365DSCConfiguration` (or equivalent) in the core module includes a block for the new resource.
21. **Do not wrap Boolean values in quotes.** Use `$true`/`$false`, never `'true'`/`'false'` or `"true"`/`"false"`, including in example files and test params.
22. **Use `($null -ne $var)` style (null on the left) for all null comparisons.** This is the enforced PowerShell best practice in this codebase (e.g., `($null -ne $Role)` not `($Role -ne $null)`).
23. **Do not remove `Verbose` from `$PSBoundParameters` explicitly.** `Verbose` is never part of `$PSBoundParameters`, so removing it is unnecessary noise.
24. **When creating a new hashtable, create it fresh rather than clearing an existing one.** Do not reuse a hashtable by removing all items; just instantiate a new `@{}`.

## Code Formatting & Style

These formatting rules are enforced during code review. Agents must apply them to all generated or modified PowerShell code:

1. **No trailing or consecutive empty lines.** Remove blank lines at the end of files. Maximum one blank line between logical blocks.
2. **One blank line between top-level function definitions.** Separate each function with exactly one blank line.
3. **Opening `{` on the same line as the statement.** In PowerShell, braces open on the same line (e.g., `if (...) {`), not on a new line.
4. **Align `=` signs in hashtable and parameter blocks.** When constructing hashtables or splatting parameters, align `=` signs vertically for readability.
5. **No trailing semicolons.** Do not add `;` at the end of statements in PowerShell.
6. **Each cmdlet parameter on its own line.** When calling a cmdlet with multiple parameters, place each parameter on its own line.
7. **No double spaces before parameter values.** Ensure single spacing between parameter names and their values.

## Schema (.mof) & Parameter Conventions

1. **Key/Identity parameter must be first in `param()` blocks.** Global parameters like `GlobalAdminAccount` and `CentralAdminUrl` go at the bottom.
2. **Only mandatory parameters in `Export-TargetResource` and `Test-TargetResource` signatures.** Non-mandatory params must not appear in these function signatures.
3. **Every `.schema.mof` parameter must have a `Description` ending with a period `.`.** Descriptions drive auto-generated wiki documentation and must be present and properly punctuated for all parameters.
4. **Resource names in `.schema.mof` must be singular.** e.g., `EXOGroupSetting` not `EXOGroupSettings`, unless the M365 API concept is inherently plural.
5. **Do not use abbreviations in parameter descriptions.** Use full words: `"alternate"` not `"alt"`, correct product names like `"Giphy"` not `"Gilphy"`.
6. **Use third-person phrasing in all descriptions.** Use `"their"` not `"your"` (e.g., `"Manages their SPO tenant settings."` not `"Manages your SPO tenant settings."`).
7. **Descriptions must have a space between sentences.** When a description contains multiple sentences, separate them with a single space after the period.
8. **Use `[ValidateSet()]` for parameters with a known fixed set of values.** Prefer enforcing allowed values in the schema rather than free-text where an enum is available.

## Example File Conventions

1. **Use `Contoso` as the example tenant name.** Do not use personal names or real tenant URLs in examples.
2. **Array parameters must use `@()` syntax.** e.g., `SiteScriptNames = @("Script1", "Script2")` not a bare string.
3. **All URL parameters must have a placeholder value.** Use a fake URL (e.g., `"https://contoso.sharepoint.com"`) rather than leaving the value empty or omitting it.
4. **No trailing semicolons in example files.**
5. **Boolean values in examples must not be wrapped in quotes.** Use `$true`/`$false` directly.

## Integration Points

- **Remote API Calls:** DSC resources interact with Microsoft 365 services via REST/Graph APIs.
- **CI/CD:** GitHub Actions workflows in `.github/workflows/` automate testing and code coverage.
- **PowerShell Gallery:** Releases are published from `master` to the PowerShell Gallery.

## Examples

- **Add a new DSC resource:**
  - Place implementation in `Modules/`.
  - Add tests in `Tests/Unit/Microsoft365DSC/`.
  - Add examples in `Modules/Microsoft365DSC/Examples/`.
- **Run all unit tests:**
  - `Invoke-TestHarness`, loaded from the module `Tests/TestHarness.psm1`.

## References

- [microsoft365dsc.com](https://microsoft365dsc.com)
- [YouTube Channel](https://www.youtube.com/channel/UCveScabVT6pxzqYgGRu17iw)
- [PowerShell Gallery](https://www.powershellgallery.com/packages/Microsoft365DSC)

---
**Feedback:** If any section is unclear or missing, please specify so it can be improved.
