
# Office365DSC

![DSC Resources Flow](https://github.com/Microsoft/Office365DSC/blob/master/Images/Logo.png?raw=true)

This module allows organizations to automate the deployment,
configuration, and monitoring of Office 365 Tenants via PowerShell
Desired State Configuration. The compiled configuration needs to be
executed from an agent's Local Configuration Manager (LCM) (machine
or container) which can communicate back remotely to Office 365 via
remote API calls (therefore requires internet connectivity).

# How to Install

At this current point int time, the Office365DSC module is only
available in Alpha Release. In order to acquire the latest Alpha
bits of the module, you need to make sure you have PowerShellGet
1.6.0 or greater installed on your machine. In order to acquire that
version of the PowerShellGet module simply run the following line of
PowerShell code from a machine that has internet connectivity:

Install-Module PowerShellGet -Force

You will need to close the PowerShell session and re-open a new one
after installing the latest PowerShellGet version in order to be
allowed to acquire Alpha releases of the Office365DSC module. Once
done, run the following line of PowerShell to acquire the latest
Office365DSC module's alpha release from the PowerShell Gallery:

Install-Module -Name Office365DSC -AllowPrerelease -Force

# Components

The following screen capture show what resource must be used to
configure the various elements that are available via the Graphical
User Interface of the Office 365 Administration Center.

![Components](https://github.com/Microsoft/Office365DSC/raw/Dev/Images/Navigation.png)
