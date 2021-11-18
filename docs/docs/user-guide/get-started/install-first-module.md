Open a PowerShell console (run as Administrator) from any machine. Microsoft365DSC requires that the machine be running at least PowerShell version 4.0+, but we stronly recommend having PowerShell 5.1. In the PowerShell console, run the following command to install the module:

```powershell
Install-Module Microsoft365DSC -Force
```

When this is run, PowerShell is pinging the PowerShell gallery, getting the Microsoft365DSC module and will then download and install it locally on the machine. It will download the required components such as the SharePoint PNP module, Azure Active Directory module, the Exchange Online Management Shell, as well as other dependent modules.

![import-module](../../Images/ImportModule.png)

Note: It is important that the machine that executes the configuration has internet connectivity back to the Microsoft 365 tenant you are trying to configure or extract the configuration from.
