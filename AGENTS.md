# Agent Guide for Microsoft365DSC

Purpose: concise, enforceable rules for AI coding agents editing this repository.

- Default branch target: feature branch according to naming standards. Start from `dev` and never modify `master`.
- Workflow: open a todo via `manage_todo_list`, mark `in-progress`, apply focused patches, rethink your changes, present to the user for approval, mark `completed`.
- Always present the changes to the user before marking work completed.
- Never add secrets or credentials to commits; if a change requires secrets, create a placeholder and document required manual steps in the PR.

Generated files (do not edit):

- `Modules/Microsoft365DSC/SchemaDefinition.json` — auto-generated from all `*.schema.mof` files by the build pipeline. **Never modify this file directly.**

Schema files (manually authored):

- `MSFT_*.schema.mof` — DSC resource schema files that **must** be edited directly when adding, removing, or modifying resource parameters. Update the `.schema.mof` for a resource whenever its parameter set changes.

## Coding Rules for DSC Resources

1. **No helper/debug methods.** Do not add helper functions for debugging. Use existing utilities (`Write-Verbose`, `New-M365DSCLogEntry`, etc.).
2. **No status output from Test-TargetResource.** `Test-TargetResource` must return only `$true` or `$false`. Do not output status messages or results for the Test function.
3. **No logging Get-TargetResource results.** Do not write the results of `Get-TargetResource` to the log or console. The caller handles result inspection.
4. **Export must include `$Filter` support.** Every `Export-TargetResource` must accept and honour a `$Filter` parameter for client-side filtering. See `ResourceGenerator/Templates/Module.Template.psm1` for the pattern.
5. **When creating a new hashtable, create it fresh rather than clearing an existing one.** Do not reuse a hashtable by removing all items; just instantiate a new `@{}`.
6. **Standard error handling in catch blocks.** Do not add extra `Write-Verbose` in catch blocks. Use the standard `New-M365DSCLogEntry` + `throw` pattern aligned with other resources. Example:
   ```powershell
   catch
   {
       New-M365DSCLogEntry -Message 'Error retrieving data:' `
           -Exception $_ `
           -Source $($MyInvocation.MyCommand.Source) `
           -TenantId $TenantId `
           -Credential $Credential
       throw
   }
   ```
7. **No `Test-TargetResource` call in `Set-TargetResource`.** The DSC engine calls Test before Set automatically. Do not call `Test-TargetResource` inside `Set-TargetResource`.
8. **Never hardcode Microsoft endpoint URLs.** Use `Get-MSCloudLoginConnectionProfile` or equivalent helpers to obtain base URLs at runtime, ensuring cloud-agnostic behaviour (GCC, GCC-High, DoD, China, etc.).
9. **Increment build version when updating a schema.mof not yet in dev or main.** If you modify a `.schema.mof` file that has not been merged to `dev` or `main`, increment the build (patch) version in the schema.
10. **`Ensure` or `IsSingleInstance` must be present.** Resources that manage singleton configurations must have `[Key] String IsSingleInstance` with `ValueMap{"Yes"}`. Resources that manage multiple instances must have an `Ensure` property (`ValueMap{"Present","Absent"}`). Rare exceptions exist (e.g. `AzureRoleEligibilityScheduleSettings`) but must be explicitly justified.
11. **Unit tests: mock all external functions and add stubs.** When writing unit tests, mock all functions from other modules. Add mock stubs to the correct file under `Tests/Unit/Stubs/` (typically `Microsoft365.psm1`). Place each stub in the correct `#region` that matches the source module name. Regions must be in **alphabetical order**. If a region for the module does not yet exist, create one and insert it in alphabetical order. Stubs within each region should also be in alphabetical order.
12. **Prefer non-beta modules and endpoints.** Use GA (non-beta) PowerShell modules and REST API endpoints whenever possible. Only use beta modules (e.g., `Microsoft.Graph.Beta.*`) or beta REST endpoints (e.g., `/beta/`) when the required functionality is new, not yet released to GA, or only available in preview.
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

Quick checklist:

1. Add a todo and mark `in-progress`.
2. Make minimal `apply_patch` edits.
3. Rethink changes and present to the user.
4. If accepted, mark todo `completed` and summarize results.
