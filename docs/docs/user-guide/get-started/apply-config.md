Microsoft365DSC is a [PowerShell Desired State Configuration](https://docs.microsoft.com/en-us/powershell/scripting/dsc/overview/overview?view=powershell-7) (DSC) module. Just like for any DSC configuration, Microsoft365DSC configurations need to be compiled into a .MOF file before they can be applied.

To compile the configuration file, do the following:

1. Move to the location where the extracted files reside for example:

```powershell
cd C:\Microsoft365DSC\
```

2. Execute the ps1 file within PowerShell:

```powershell
 .\M365TenantConfig.ps1
```

3. Provide the Tenant Admin password.

A .mof file will be compiled and will represent the Microsoft 365 tenant for example localhost.mof. This localhost.mof file can be re-run against a different tenant and will automatically sync all the configurations that were extracted to the new tenant. The mof file will be located in its own folder and this folder will be named based on the Configuration name within the .ps1 configuration file. In order to apply the compiled configuration against your Microsoft 365 tenant, you will need to call into the **Start-DSCConfiguration** PowerShell cmdlet. For example, if your configuration was named M365TenantConfig, you can apply the configuration by running the following command:

```powershell
Start-DSCConfiguration M365TenantConfig -Wait -Verbose -Force
```
