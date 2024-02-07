While Microsoft365DSC supports running PowerShell 7+, there are a few things that need to be put in place before being able to fully leverage it.

# Module needs to be installed in the Windows PowerShell Repository

Microsoft365DSC currently requires dependencies to be installed under the C:\Program Files\WindowsPowerShell\Modules folders. Having the dependencies installed anywhere else can cause issues loading modules. The recommendation here is to use PowerShell 5.1 to install the Module using:

```
Install-Module Microsoft365DSC -Force
Update-M365DSCModule
```

Then flip to PowerShell 7+ once the prerequesite modules are properly installed under C:\Program Files\WindowsPowerShell\Modules.

## Common Issues When the Modules are Not in the Right Folder

**Export is Throwing Multiple Warnings**

The module that is ensuring the proper encoding of the exported DSC content relies on the Get-DscResource cmdlet to cache information about the resources' properties and is a way to improve performance. If the Microsoft365DSC module is not located under the Windows PowerShell folder, every instance extracted by the Export process will throw the following error:

```
WARNING: There are no modules present in the system with the given module specification.
```

To solve this, make sure the Microsoft365DSC is properly installed under C:\Program Files\WindowsPowerShell\Modules and that you do not have multiple versions of it installed in different locations.

**Issues loading the PnP.PowerShell Module**

The PnP.PowerShell module, which is currently being used by the SharePoint Online and OndeDrive for Business workloads needs to be loaded using Windows PowerShell. In PowerShell 7+, this is done by running the **Import-Module** cmdlet using the **-UseWindowsPowerShell** switch, and requires the modules to be located under C:\Program Files\WindowsPowerShell. In order for Microsoft365DSC to work for SharePoint Online and OneDrive for Business with PowerShell 7, you need to make sure that the PnP.PowerShell module is located under C:\Program Files\WindowsPowerShell\Modules\PnP.PowerShell. This can be achieved by either manually moving the module to that location, or by using PowerShell 5.1 to install it using the following line:

```
Install-Module PnP.PowerShell -Force -Scope AllUsers
```

The reason why this module needs to be loaded using WindowsPowerShell is because it tries to load its own version of the System.IdentityModel.Tokens assembly, which conflicts with the one used by the Microsoft.Graph.Authentication module. Microsoft365DSC often requires both modules to be loaded at the same time, which causes a conflict. By using the -UseWindowsPowerShell switch, we load the PnP.PowerShell module into its own separate runspace, which avoids the assembly conflicts. Having the PnP module installed under any path other than the Windows PowerShell one can result in one of the issues listed below:

```
Exception: Powershell 7+ was detected. We need to load the PnP.PowerShell module using the -UseWindowsPowerShell switch which
requires the module to be installed under C:\Program Files\WindowsPowerShell\Modules. You can either move the module to
that location or use PowerShell 5.1 to install the modules using 'Install-Module Pnp.PowerShell -Force -Scope AllUsers'.

Connect-PnPOnline: Could not load file or assembly 'System.IdentityModel.Tokens.Jwt, Version=6.12.2.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'. Could not find or load a specific file. (0x80131621)
```

# PSDesiredStateConfiguration Needs to be Installed Separately

Starting with PowerShell 7.2, the core Desired State Configuration module (PSdesiredStateConfiguration) has been decoupled from the core PowerShell build and now need to be installed separately. In a PowerShell 7+ console, you can install the module by running the command:

```
Install-Module PSDesiredStateConfiguration -Force
```
