# AADServicePrincipal

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **AppId** | Key | String | The unique identifier for the associated application. ||
| **ObjectID** | Write | String | The ObjectID of the ServicePrincipal ||
| **DisplayName** | Write | String | Displayname of the ServicePrincipal. ||
| **AlternativeNames** | Write | StringArray[] | The alternative names for this service principal ||
| **AccountEnabled** | Write | Boolean | True if the service principal account is enabled; otherwise, false. ||
| **AppRoleAssignmentRequired** | Write | Boolean | Indicates whether an application role assignment is required. ||
| **ErrorUrl** | Write | String | Specifies the error URL of the ServicePrincipal. ||
| **Homepage** | Write | String | Specifies the homepage of the ServicePrincipal. ||
| **LogoutUrl** | Write | String | Specifies the LogoutURL of the ServicePrincipal. ||
| **PublisherName** | Write | String | Specifies the PublisherName of the ServicePrincipal. ||
| **ReplyUrls** | Write | StringArray[] | The URLs that user tokens are sent to for sign in with the associated application, or the redirect URIs that OAuth 2.0 authorization codes and access tokens are sent to for the associated application. ||
| **SamlMetadataUrl** | Write | String | The URL for the SAML metadata of the ServicePrincipal. ||
| **ServicePrincipalNames** | Write | StringArray[] | Specifies an array of service principal names. Based on the identifierURIs collection, plus the application's appId property, these URIs are used to reference an application's service principal. ||
| **ServicePrincipalType** | Write | String | The type of the service principal. ||
| **Tags** | Write | StringArray[] | Tags linked to this service principal.Note that if you intend for this service principal to show up in the All Applications list in the admin portal, you need to set this value to {WindowsAzureActiveDirectoryIntegratedApp} ||
| **Ensure** | Write | String | Specify if the Azure AD App should exist or not. |Present, Absent|
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||
| **ApplicationSecret** | Write | String | Secret of the Azure Active Directory application to authenticate with. ||
| **Credential** | Write | PSCredential | Credentials of the Azure AD Admin ||

# AADServicePrincipal

### Description

This resource configures an Azure Active Directory ServicePrincipal.

## Azure AD Permissions

To authenticate via Azure Active Directory, this resource required the following Application permissions:

* **Automate**
  * microsoft.directory/servicePrincipals/appRoleAssignedTo/read
  * microsoft.directory/servicePrincipals/appRoleAssignments/read
  * microsoft.directory/servicePrincipals/standard/read
  * microsoft.directory/servicePrincipals/memberOf/read
  * microsoft.directory/servicePrincipals/oAuth2PermissionGrants/read
  * microsoft.directory/servicePrincipals/owners/read
  * microsoft.directory/servicePrincipals/ownedObjects/read
  * microsoft.directory/servicePrincipals/policies/read
  * microsoft.directory/servicePrincipals/synchronizationCredentials/manage

  Alternatively you can also assign the Application the "Directory writers" role.

* **Export**
  * microsoft.directory/servicePrincipals/appRoleAssignedTo/read
  * microsoft.directory/servicePrincipals/appRoleAssignments/read
  * microsoft.directory/servicePrincipals/standard/read
  * microsoft.directory/servicePrincipals/memberOf/read
  * microsoft.directory/servicePrincipals/oAuth2PermissionGrants/read
  * microsoft.directory/servicePrincipals/owners/read
  * microsoft.directory/servicePrincipals/ownedObjects/read
  * microsoft.directory/servicePrincipals/policies/read

  Alternatively you can also assign the Application the "Directory readers" role.

NOTE: All permisions listed above require admin consent.

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADServicePrincipal 'AADServicePrincipal'
        {
            AppId                         = "<AppID GUID>"
            DisplayName                   = "AADAppName"
            AlternativeNames              = "AlternativeName1","AlternativeName2"
            AccountEnabled                = $true
            AppRoleAssignmentRequired     = $false
            ErrorUrl                      = ""
            Homepage                      = "https://AADAppName.contoso.com"
            LogoutUrl                     = "https://AADAppName.contoso.com/logout"
            PublisherName                 = "Contoso"
            ReplyURLs                     = "https://AADAppName.contoso.com"
            SamlMetadataURL               = ""
            ServicePrincipalNames         = "<AppID GUID>", "https://AADAppName.contoso.com"
            ServicePrincipalType          = "Application"
            Tags                          = "{WindowsAzureActiveDirectoryIntegratedApp}"
            Ensure                        = "Present"
            Credential                    = $credsGlobalAdmin
        }
    }
}
```

