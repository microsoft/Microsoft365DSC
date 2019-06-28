# Office365DSC

![DSC Resources Flow](https://github.com/microsoft/Office365DSC/blob/master/Modules/Office365DSC/Dependencies/Images/Logo.png?raw=true)

This module allows organizations to automate the deployment,
configuration, and monitoring of Office 365 Tenants via PowerShell
Desired State Configuration. The compiled configuration needs to be
executed from an agent's Local Configuration Manager (LCM) (machine
or container) which can communicate back remotely to Office 365 via
remote API calls (therefore requires internet connectivity)

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
