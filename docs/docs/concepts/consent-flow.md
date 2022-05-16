# Consent flow

After installing the Microsoft365DSC PowerShell modules, you have to consent the various modules to successfully use Microsoft365DSC.
The PnP and the Microsoft Graph modules require some setting up before using.

## PnP PowerShell

When using PnP PowerShell for the first time you have to consent the PnP Management Shell Multi-Tenant Azure AD Application via the following cmdlet:

```powershell
Register-PnPManagementShellAccess
```

## Microsoft Graph

For the Microsoft Graph PowerShell module you need to specify scopes to make sure you can export the different modules.

We made this a lot easier for you with the `Get-M365DSCCompiledPermissionList` cmdlet. You can enter the module you want to export and it will return the correct scope.

For instance, when you want to export the `AADTenantDetails` module, you can use the following example to get the correct scope(s).

```powershell
Get-M365DSCCompiledPermissionList -ResourceNameList @("AADTenantDetails")
```

This will give you the following response:

```powershell
Name                           Value
----                           -----
ReadPermissions                {Organization.Read.All}
UpdatePermissions              {Organization.ReadWrite.All}
```
