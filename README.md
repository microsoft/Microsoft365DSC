# Office365DSC

![DSC Resources Flow](https://github.com/microsoft/Office365DSC/blob/master/Modules/Office365DSC/Dependencies/Images/Logo.png?raw=true)

This module allows organizations to automate the deployment,
configuration, and monitoring of Office 365 Tenants via PowerShell
Desired State Configuration. The compiled configuration needs to be
executed from an agent's Local Configuration Manager (LCM) (machine
or container) which can communicate back remotely to Office 365 via
remote API calls (therefore requires internet connectivity)

For information on how to get started, additional documentation or 
templates, please navigate to the official web site at:

[Office365DSC.com](http://Office365DSC.com)

## Branches

### master

[![Build status](https://ci.appveyor.com/api/projects/status/5a7f2ao7d1mnoqrb/branch/master?svg=true)](https://ci.appveyor.com/project/NikCharlebois/office365dsc/branch/master)
[![codecov](https://codecov.io/gh/Microsoft/office365dsc/branch/master/graph/badge.svg)](https://codecov.io/gh/Microsoft/office365dsc)

This is the branch containing the latest release -
no contributions should be made directly to this branch.

### dev

[![Build status](https://ci.appveyor.com/api/projects/status/5a7f2ao7d1mnoqrb?svg=true)](https://ci.appveyor.com/project/NikCharlebois/office365dsc)
[![codecov](https://codecov.io/gh/microsoft/Office365DSC/branch/Dev/graph/badge.svg)](https://codecov.io/gh/microsoft/Office365DSC)

This is the development branch
to which contributions should be proposed by contributors as pull requests.
This development branch will periodically be merged to the master branch,
and be released to [PowerShell Gallery](https://www.powershellgallery.com/).

## How to Install

In order to acquire the latest
bits of the module from a machine that has internet connectivity,
simply run the following PowerShell line:

```powershell
Install-Module -Name Office365DSC -Force
```

## Telemetry Disclaimer

Office365DSC captures Telemetry data about the names of the resources
in which a configuration drift has been detected, along with the type
of exceptions being thrown by errors in the various modules. While no
sensitive data is ever being captured, App Insights which is used for
the analytics of the Telemetry, does capture information about the city
where the telemetry entries where captured from by default. Users can
opt out to prevent telemetry to be sent back to the Office365DSC team
by running the following command:

```powershell
Set-O365DSCTelemetryOption -Enabled $False
```
