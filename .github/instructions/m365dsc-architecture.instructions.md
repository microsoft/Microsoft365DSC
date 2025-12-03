---
applyTo: "**/*.ps1,**/*.psm1"
description: "Architecture and structure of Microsoft365DSC resources"
---

# Microsoft365DSC Resource Architecture Guide

This guide gives AI agents a deep understanding of how DSC resources inside the Microsoft365DSC module are structured, named, and executed.

## Resource Structure Overview

Each DSC resource has the following files:

- `MSFT_<ResourceName>.schema.mof` - Resource schema definition
- `MSFT_<ResourceName>.psm1` - Resource implementation (Get/Set/Test/Export)
- `Examples/Resources/<ResourceName>/` - Example DSC configuration
- `docs/<Workload>/<ResourceName>.md` - Documentation. Auto-generated during build time.
- `Tests/Unit/Microsoft365DSC/Microsoft365DSC.<ResourceName>.Tests.ps1` - Pester tests

## Function Pattern

Every DSC resource implements:

- Get-TargetResource
- Set-TargetResource
- Test-TargetResource
- Export-TargetResource

Additional functions can be defined as needed.

### Rules:

- Parameter names **must match** the schema.mof exactly.
- Validate schema consistency by ensuring `MSFT_<ResourceName>.psm1` parameter names match `MSFT_<ResourceName>.schema.mof`.
- Agents should run a quick check script or validate manually when creating a resource to avoid schema mismatches.
- `Get-TargetResource` returns a hashtable with all properties.
- `Test-TargetResource` returns strictly `$true` or `$false`.
- `Set-TargetResource` performs the actual configuration changes.
- `Export-TargetResource` supports reverse-DSC generation.

## Naming Conventions

- File names always start with `MSFT_`, e.g. `MSFT_AADAccessReviewDefinition.psm1`, except for Test files, which start with `Microsoft365DSC.`
- Resource names must be PascalCase and reflect the service:
  - `AADConditionalAccessPolicy`
  - `EXOAcceptedDomain`
  - `TeamsAppSetupPolicy`

## External Dependencies

Most resources use:

- Microsoft.Graph SDK
- ExchangeOnlineManagement
- SharePoint / PnP PowerShell
- Teams PowerShell module

Dependency notes:

- Document minimum required versions in each resource's module settings (`Modules/<ModuleName>/settings.json`) under `requiredModules`.
- Prefer Microsoft Graph APIs when they cover the scenario; use workload-specific modules only when required functionality is not available in Graph.

When generating new code, the agent should:
- Prefer Graph where available
- Use existing helper modules
- Follow Microsoft365DSC logging and exception patterns

Templates and references:

- See `ResourceGenerator/Module.Template.psm1` for implementation patterns of the functions.
- Use `ResourceGenerator` scripts to scaffold new resources.
