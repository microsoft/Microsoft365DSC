NOTE
=============
The Office365DSC module is in the process of being rebranded to Microsoft365DSC.
The team is working on a plan to make the transition as smooth as possible.
-------------

# Microsoft365DSC

![DSC Resources Flow](https://github.com/microsoft/Microsoft365DSC/blob/master/Modules/Microsoft365DSC/Dependencies/Images/Logo.png?raw=true)

This module allows organizations to automate the deployment,
configuration, and monitoring of Microsoft 365 Tenants via PowerShell
Desired State Configuration. The compiled configuration needs to be
executed from an agent's Local Configuration Manager (LCM) (machine
or container) which can communicate back remotely to Office 365 via
remote API calls (therefore requires internet connectivity)

For information on how to get started, additional documentation or 
templates, please navigate to the official web site at:

[Microsoft365DSC.com](http://Microsoft365DSC.com)

## Branches

### master

[![Build status](https://ci.appveyor.com/api/projects/status/5a7f2ao7d1mnoqrb/branch/master?svg=true)](https://ci.appveyor.com/project/NikCharlebois/Microsoft365DSC/branch/master)
[![codecov](https://codecov.io/gh/Microsoft/Microsoft365DSC/branch/master/graph/badge.svg)](https://codecov.io/gh/Microsoft/Microsoft365DSC)

This is the branch containing the latest release -
no contributions should be made directly to this branch.

### dev

[![Build status](https://ci.appveyor.com/api/projects/status/5a7f2ao7d1mnoqrb?svg=true)](https://ci.appveyor.com/project/NikCharlebois/Microsoft365DSC)
[![codecov](https://codecov.io/gh/microsoft/Microsoft365DSC/branch/Dev/graph/badge.svg)](https://codecov.io/gh/microsoft/Microsoft365DSC)

This is the development branch
to which contributions should be proposed by contributors as pull requests.
This development branch will periodically be merged to the master branch,
and be released to [PowerShell Gallery](https://www.powershellgallery.com/).

## How to Install

In order to acquire the latest
bits of the module from a machine that has internet connectivity,
simply run the following PowerShell line:

```powershell
Install-Module -Name Microsoft365DSC -Force
```

## Telemetry Disclaimer

Microsoft365DSC captures Telemetry data about the names of the resources
in which a configuration drift has been detected, along with the type
of exceptions being thrown by errors in the various modules. While no
sensitive data is ever being captured, App Insights which is used for
the analytics of the Telemetry, does capture information about the city
where the telemetry entries where captured from by default. Users can
opt out to prevent telemetry to be sent back to the Microsoft365DSC team
by running the following command:

```powershell
Set-M365DSCTelemetryOption -Enabled $False
```
