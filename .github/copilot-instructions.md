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
- **Testing:** Each resource has a corresponding test file in `Tests/Unit/Microsoft365DSC/`. Its name is `Microsoft365DSC.<ResourceName>.Tests.ps1`.
- **Documentation:** Resource documentation is in `docs/` and `README.md`.
- **External Dependencies:**
  - PowerShell modules (e.g., `Microsoft.Graph`, `Pester`).
  - TypeScript dependencies in `generator/package.json`.

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
