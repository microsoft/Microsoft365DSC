# Introduction to Microsoft365DSC

This article is a complete guide to installing, deploying and using Microsoft365DSC. Microsoft365DSC is an open-source solution that is available for free on [GitHub](https://github.com/Microsoft/Microsoft365DSC). It is led by Microsoft engineers and maintained by the community. Official documentation for the solution is available on the official [Microsoft365DSC site](https://Microsoft365DSC.com).

Microsoft365DSC is the declarative form of a Microsoft 365 tenant configuration. It is to Microsoft 365 what Azure Resource Manager templates (ARM) are to Azure.  It allows you to represent the configuration of your tenant in code (Configuration-as-Code) leveraging [PowerShell Desired State Configuration (DSC)](https://docs.microsoft.com/en-us/powershell/dsc/overview/dscforengineers?view=dsc-1.1). Use it to automatically configure your Microsoft tenants in the described state, take snapshots of existing tenants into DSC declarative code, generate reports out of those snapshots, continuously monitor all your Microsoft 365 tenants for configuration drifts and be alerted when drifts are detected, clone the configuration of an existing tenant onto another and compare the configuration between one or multiple tenants.

## Topics

* [Prerequisites](../get-started/prerequisites.md)
* [Authentication and Permissions](../get-started/authentication-and-permissions.md)
* [How to Install](../get-started/how-to-install.md)
* [Taking a Snapshot of Existing Tenant](../get-started/snapshot-of-existing-tenant.md)
* [Deploying Configurations](../get-started/deploying-configurations.md)
* [Securing your Compiled Configuration](../get-started/securing-configurations.md)
* [Monitoring for Configuration Drifts](../get-started/monitoring-drifts.md)
* [Cloning Tenant's Configuration](../get-started/cloning-tenants.md)
* [Generating Reports from Configurations](../get-started/generating-reports.md)
* [Comparing Configurations](../get-started/comparing-configurations.md)
* [Integrating with Azure DevOPS](../get-started/integrating-with-azure-devops.md)
* [Support](../get-started/support.md)
* [Telemetry](../get-started/telemetry.md)
