# Office365DSC

![DSC Resources Flow](https://github.com/Microsoft/Office365DSC/blob/master/Images/Logo.png?raw=true)

This module allows organizations to automate the deployment,
configuration, and monitoring of Office 365 Tenants via PowerShell
Desired State Configuration. The compiled configuration needs to be
executed from an agent's Local Configuration Manager (LCM) (machine
or container) which can communicate back remotely to Office 365 via
remote API calls (therefore requires internet connectivity)

## Branches

### master

[![Build status](https://ci.appveyor.com/api/projects/status/5a7f2ao7d1mnoqrb/branch/master?svg=true)](https://ci.appveyor.com/project/NikCharlebois/office365dsc/branch/master)

[![codecov](https://codecov.io/gh/PowerShell/SqlServerDsc/branch/master/graph/badge.svg)](https://codecov.io/gh/PowerShell/SqlServerDsc/branch/master)

This is the branch containing the latest release -
no contributions should be made directly to this branch.

### dev

[![Build status](https://ci.appveyor.com/api/projects/status/5a7f2ao7d1mnoqrb?svg=true)](https://ci.appveyor.com/project/NikCharlebois/office365dsc)

[![codecov](https://codecov.io/gh/PowerShell/SqlServerDsc/branch/dev/graph/badge.svg)](https://codecov.io/gh/PowerShell/SqlServerDsc/branch/dev)

This is the development branch
to which contributions should be proposed by contributors as pull requests.
This development branch will periodically be merged to the master branch,
and be released to [PowerShell Gallery](https://www.powershellgallery.com/).

## How to Install

At this current point int time, the Office365DSC module is only
available in Alpha Release. In order to acquire the latest Alpha
bits of the module, you need to make sure you have PowerShellGet
1.6.0 or greater installed on your machine. In order to acquire that
version of the PowerShellGet module simply run the following line of
PowerShell code from a machine that has internet connectivity:

```powershell
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module PowerShellGet -Force
```

You will need to close the PowerShell session and re-open a new one
after installing the latest PowerShellGet version in order to be
allowed to acquire Alpha releases of the Office365DSC module. Once
done, run the following line of PowerShell to acquire the latest
Office365DSC module's alpha release from the PowerShell Gallery:

```powershell
Install-Module -Name Office365DSC -AllowPrerelease -Force
```
