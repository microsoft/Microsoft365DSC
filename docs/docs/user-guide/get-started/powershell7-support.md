While Microsoft365DSC supports running PowerShell 7+, there are a few things that need to be put in place before being able to fully leverage it.

## The PnP.PowerShell Module needs Windows PowerShell

The PnP.PowerShell module, which is currently being used by the SharePoint Online and OndeDrive for Business workloads needs to be loaded using Windows PowerShell. In PowerShell 7+, this is done by running the **Import-Module** cmdlet using the **-UseWindowsPowerShell** switch, and requires the modules to be located under C:\Program Files\WindowsPowerShell. In order for Microsoft365DSC to work for SharePoint Online and OneDrive for Business with PowerShell 7, you need to make sure that the PnP.PowerShell module is located under C:\Program Files\WindowsPowerShell\Modules\PnP.PowerShell. This can be achieve =d by either manually moving the module to that location, or by using PowerShell 5.1 to install it using the following line:

```
Install-Module PnP.PowerShell -Force -Scope AllUsers
```

The reason why this module needs to be loaded using WindowsPowerShell is because it tries to load its own version of the System.IdentityModel.Tokens assembly, which conflicts with the one used by the Microsoft.Graph.Authentication module. Microsoft365DSC often requires both modules to be loaded at the same time, which causes a conflict. By using the -UseWindowsPowerShell switch, we load the PnP.PowerShell module into its own separate runspace, which avoids the assembly conflicts.
