This article is a complete guide to installing, deploying and using Microsoft365DSC. Microsoft365DSC is an open-source solution that is available for free on <a href="https://github.com/Microsoft/Microsoft365DSC" target="_blank">GitHub</a>. It is led by Microsoft engineers and maintained by the community. Official documentation for the solution is available on the official <a href="https://Microsoft365DSC.com" target="_blank">Microsoft365DSC site</a>.

Microsoft365DSC is the declarative form of a Microsoft 365 tenant configuration. It is to Microsoft 365 what Azure Resource Manager templates (ARM) are to Azure.  It allows you to represent the configuration of your tenant in code (Configuration-as-Code) leveraging <a href="https://docs.microsoft.com/en-us/powershell/dsc/overview/dscforengineers?view=dsc-1.1" target="_blank">PowerShell Desired State Configuration (DSC)</a>. Use it to automatically configure your Microsoft tenants in the described state, take snapshots of existing tenants into DSC declarative code, generate reports out of those snapshots, continuously monitor all your Microsoft 365 tenants for configuration drifts and be alerted when drifts are detected, clone the configuration of an existing tenant onto another and compare the configuration between one or multiple tenants.

## Topics

- [Prerequisites](../prerequisites)
- [Authentication and Permissions](../authentication-and-permissions)
- [How to Install](../how-to-install)
- [Taking a Snapshot of Existing Tenant](../snapshot-of-existing-tenant)
- [Deploying Configurations](../deploying-configurations)
- [Securing your Compiled Configuration](../securing-configurations)
- [Monitoring for Configuration Drifts](../monitoring-drifts)
- [Cloning Tenant's Configuration](../cloning-tenants)
- [Generating Reports from Configurations](../generating-reports)
- [Comparing Configurations](../comparing-configurations)
- [Integrating with Azure DevOPS](../integrating-with-azure-devops)
- [Support](../support)
- [Telemetry](../telemetry)
