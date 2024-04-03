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

## Roadmap & Backlog

We are using Azure DevOps for project management. You can access our backlog and roadmap by clicking on the status badge below:

[![Board Status](https://dev.azure.com/Microsoft365DSC/c730cd2b-2b5f-4af2-8bce-2b7b3ee6f69b/e58164ef-f760-40e9-bd67-893cf4938bef/_apis/work/boardbadge/84871665-8a0f-46de-8a93-c214ea36b371?columnOptions=1)](https://dev.azure.com/Microsoft365DSC/Backlog/_workitems/)

## Branches

### master

[![codecov](https://codecov.io/gh/Microsoft/Microsoft365DSC/branch/master/graph/badge.svg)](https://codecov.io/gh/Microsoft/Microsoft365DSC)

This is the branch containing the latest release. No contributions should be made directly to this branch.

### dev

[![Code Coverage](https://github.com/microsoft/Microsoft365DSC/actions/workflows/CodeCoverage.yml/badge.svg)](https://github.com/microsoft/Microsoft365DSC/actions/workflows/CodeCoverage.yml)

[![AzureCloud - Full-Circle - EXO](https://github.com/microsoft/Microsoft365DSC/actions/workflows/AzureCloud%20-%20Full-Circle%20-%20EXO.yml/badge.svg)](https://github.com/microsoft/Microsoft365DSC/actions/workflows/AzureCloud%20-%20Full-Circle%20-%20EXO.yml)

[![AzureCloud - Full-Circle - O365](https://github.com/microsoft/Microsoft365DSC/actions/workflows/AzureCloud%20-%20Full-Circle%20-%20O365.yml/badge.svg)](https://github.com/microsoft/Microsoft365DSC/actions/workflows/AzureCloud%20-%20Full-Circle%20-%20O365.yml)

[![AzureCloud - Full-Circle - OD](https://github.com/microsoft/Microsoft365DSC/actions/workflows/AzureCloud%20-%20Full-Circle%20-%20OD.yml/badge.svg)](https://github.com/microsoft/Microsoft365DSC/actions/workflows/AzureCloud%20-%20Full-Circle%20-%20OD.yml)

[![AzureCloud - Full-Circle - PP](https://github.com/microsoft/Microsoft365DSC/actions/workflows/AzureCloud%20-%20Full-Circle%20-%20PP.yml/badge.svg)](https://github.com/microsoft/Microsoft365DSC/actions/workflows/AzureCloud%20-%20Full-Circle%20-%20PP.yml)

[![AzureCloud - Full-Circle - SC](https://github.com/microsoft/Microsoft365DSC/actions/workflows/AzureCloud%20-%20Full-Circle%20-%20SC.yml/badge.svg)](https://github.com/microsoft/Microsoft365DSC/actions/workflows/AzureCloud%20-%20Full-Circle%20-%20SC.yml)

[![AzureCloud - Full-Circle - SPO](https://github.com/microsoft/Microsoft365DSC/actions/workflows/AzureCloud%20-%20Full-Circle%20-%20SPO.yml/badge.svg)](https://github.com/microsoft/Microsoft365DSC/actions/workflows/AzureCloud%20-%20Full-Circle%20-%20SPO.yml)

[![AzureCloud - Full-Circle - TEAMS](https://github.com/microsoft/Microsoft365DSC/actions/workflows/AzureCloud%20-%20Full-Circle%20-%20TEAMS.yml/badge.svg)](https://github.com/microsoft/Microsoft365DSC/actions/workflows/AzureCloud%20-%20Full-Circle%20-%20TEAMS.yml)

[![Global - Integration - AAD](https://github.com/microsoft/Microsoft365DSC/actions/workflows/Global%20-%20Integration%20-%20AAD.yml/badge.svg)](https://github.com/microsoft/Microsoft365DSC/actions/workflows/Global%20-%20Integration%20-%20AAD.yml)

[![Global - Integration - EXO](https://github.com/microsoft/Microsoft365DSC/actions/workflows/Global%20-%20Integration%20-%20EXO.yml/badge.svg)](https://github.com/microsoft/Microsoft365DSC/actions/workflows/Global%20-%20Integration%20-%20EXO.yml)

[![Global - Integration - INTUNE](https://github.com/microsoft/Microsoft365DSC/actions/workflows/Global%20-%20Integration%20-%20INTUNE.yml/badge.svg)](https://github.com/microsoft/Microsoft365DSC/actions/workflows/Global%20-%20Integration%20-%20INTUNE.yml)

[![Unit Tests](https://github.com/microsoft/Microsoft365DSC/actions/workflows/Unit%20Tests.yml/badge.svg)](https://github.com/microsoft/Microsoft365DSC/actions/workflows/Unit%20Tests.yml)

Contributors are encouraged to propose their contributions as pull requests to this development branch.
This branch will periodically be merged to the master branch,
and be released to [PowerShell Gallery](https://www.powershellgallery.com/).

## How to Install

To acquire the latest
bits of the module from a machine that has internet connectivity,
run the following PowerShell lines:

```PowerShell
Install-Module -Name Microsoft365DSC -Force
Update-M365DSCModule
```

## Telemetry Disclaimer

Microsoft365DSC captures Telemetry data about the names of the resources
in which a configuration drift has been detected, along with the type
of exceptions being thrown by errors in the various modules. While no
sensitive data is ever captured, App Insights, which performs
telemetry analytics, captures information about the city
where the telemetry entries were captured by default. Users can
opt-out to prevent telemetry from being sent back to the Microsoft365DSC team
by running the following command:

```PowerShell
Set-M365DSCTelemetryOption -Enabled $False
```
