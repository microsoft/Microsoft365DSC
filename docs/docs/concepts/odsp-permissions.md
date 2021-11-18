# Microsoft365DSC Permissions for SharePoint and OneDrive

The latest version of Microsoft365DSC support both user and AzureAD App principal authentication. It is recommended to use AzureAD app authentication for several reasons. The first is that when granting permission to the AAD App it will ensure it has permissions to all SharePoint and OneDrive resources. The second reason is that most organizations enforce MFA authentication on user account that have roles assigned to them. This will cause issues when monitoring or apply changes to SharePoint or OneDrive as it will prompt for MFA numerous times. AzureAD app and user based authentication both can have passwords stored in compiled MOF files so ensure the are secured. Please refer to following video

<iframe width="560" height="315" src="https://www.youtube.com/embed/SCZv79wZNh0?start=9" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## User based authentication

When using a user account with Microsoft365DSC make sure the account is a cloud only user account for example admin@contoso.onmicrosoft.com. Microsoft365DSC uses account name for determining tenant within the resources so using federate accounts may cause issue when running Microsoft365DSC.

### Roles and permissions

When using user based authentication several of the resources do support the Global reader role. The following resources support global reader:

- SPOApp
- SPOSearchManagedProperty
- SPOSearchResultSource
- SPOStorageEntity
- SPOTenantCdnEnabled
- SPOTenantCdnPolicy
- SPOUserProfileProperty

All SharePoint and OneDrive resources work with the SharePoint Admin role assigned. The SPOSiteGroup resource will error if the account doesn't have site collection admin permissions even if account is has the role of SharePoint admin. This is why we recommend using AAD App permissions. This role does provide full control so it can also be used for pushing configurations to your tenant. Lastly using an account that has Global Admin permissions typically permissions to entire tenant and can be used on all SharePoint and OneDrive resources.

When executing the Export-M365DSCConfiguration cmdlet user name and password should be filled in the following fields:

![User name and Password](../Images/userpwdpng.png 'Username and Password')

## Azure AD app permissions

The best option when using Microsoft365DSC with SharePoint and OneDrive is to use an Azure AD app principal. When using AAD App permission Microsoft365DSC supports 2 different scenarios, certificate path option or installing certificate and using the thumbprint. The permissions required for Azure AD applications are SharePoint Site.FullControl.All scope.

![API Permissions](../Images/APIPermissions.png 'SharePoint Permissions')

### Configure AzureAD app for Microsoft365DSC

The SharePoint PNP team created a cmdlet that simplifies the setup of AzureAD App called [Initialize-PNPPowerShellAuthentication](https://docs.microsoft.com/en-us/powershell/module/sharepoint-pnp/initialize-pnppowershellauthentication?view=sharepoint-ps). The following script can be used to create the AzureAD app permissions needed for Microsoft365DSC

```PowerShell
Initialize-PnPPowerShellAuthentication -ApplicationName TestApp2 -Tenant contoso.onmicrosoft.com -OutPath c:\DSC -CertificatePassword (ConvertTo-SecureString -String "password" -AsPlainText -Force) -store CurrentUser -scopes "SPO.Sites.FullControl.All"
```

This cmdlet will open a dialog box to authenticate to Azure AD and grant admin consent once its created the AzureAD app. It will also install
the certificate in current user store and output a PFX file in the c:\dsc directory. If you plan to use the certificate thumbprint option when using
DSC by default the LCM runs under the system account so easiest option to install in cert store is by using [PSExec](https://docs.microsoft.com/en-us/sysinternals/downloads/psexec). To install certificate under system account using PSExec run the following:

    1. .\PsExec.exe -s -i mmc.exe
    2. File add / remove snapin > Select certificates > MyUser account
    3. Open Certificate - Current User and select Personal
    4. Select import certificate and browse to location from outpath in code from above and select the PFX file

After AzureAD app is created and certificate is installed you need some additional properties before you can use with Microsoft365DSC. Login to
Azure Active Directory and browse to the App registrations page you should see the TestApp2 app created from the script above. We need to copy the following properties:

![Application Id](../Images/AppId.png 'Application ID')

![Certificate Thumbprint](../Images/CertificateThump.png 'Certificate Thumbprint')

### Using Certificate Thumbprint option

When running the export or creating configuration files for resources the following are the required parameters for authentication
when using certificate thumbprint.

    * ApplicationID
    * TenantID  - This must be in format of contoso.onmicrosoft.com
    * CertificateThumbprint

From the Export-M365DSCConfiguration GUI the following fields should be used:

![ExportThumprint](../Images/ExportCertThumb.png 'Export using thumbprint')

### Using Certificate Path option

There are times when using Microsoft365DSC you may need to use the certificate path option. For example using Azure DevOps to monitor tenant for configuration drift you would not have access to install certificates on the build agents. In this scenario using the certificate path option
would be the best solution. The following parameters are required when using certificate path:

    * ApplicationID
    * TenantID  - this must be in format of contoso.onmicrosoft.com
    * CertificatePath - this is path to the PFX certificate on local machine ex: c:\dsc\testapp2.pfx
    * CertificatePassword - password for certificate

From the Export-M365DSCConfiguration GUI the following fields should be used:

![Export using Certificate Path](../Images/CertPath.png){ align=center width=500 }
