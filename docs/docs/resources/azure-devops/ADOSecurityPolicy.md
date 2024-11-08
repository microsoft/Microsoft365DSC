# ADOSecurityPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **OrganizationName** | Key | String | The name of the Azure DevOPS Organization. | |
| **DisallowAadGuestUserAccess** | Write | Boolean | Controls the external guest access. | |
| **DisallowOAuthAuthentication** | Write | Boolean | Controls the Third-party application access via OAuth. | |
| **DisallowSecureShell** | Write | Boolean | Controls SSH Authentication. | |
| **LogAuditEvents** | Write | Boolean | Controls Log Audit Events. | |
| **AllowAnonymousAccess** | Write | Boolean | Controls the Allow public projects setting. | |
| **ArtifactsExternalPackageProtectionToken** | Write | Boolean | Controls the Additional protections when using public package registries setting. | |
| **EnforceAADConditionalAccess** | Write | Boolean | Controls the Enable IP Conditional Access policy validation setting. | |
| **AllowTeamAdminsInvitationsAccessToken** | Write | Boolean | Controls the Allow team and project administrators to invite new user setting. | |
| **AllowRequestAccessToken** | Write | Boolean | Controls the Request access setting. | |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

Configures Azure DevOPS Security Policies.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - None

- **Update**

    - None

#### Application permissions

- **Read**

    - None

- **Update**

    - None

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC
    node localhost
    {
        ADOSecurityPolicy "ADOPolicy"
        {
            AllowAnonymousAccess                    = $True;
            AllowRequestAccessToken                 = $False;
            AllowTeamAdminsInvitationsAccessToken   = $True;
            ApplicationId                           = $ApplicationId;
            ArtifactsExternalPackageProtectionToken = $False;
            CertificateThumbprint                   = $CertificateThumbprint;
            DisallowAadGuestUserAccess              = $True;
            DisallowOAuthAuthentication             = $True;
            DisallowSecureShell                     = $False;
            EnforceAADConditionalAccess             = $False;
            LogAuditEvents                          = $True;
            OrganizationName                        = "O365DSC-Dev";
            TenantId                                = $TenantId;
        }
    }
}
```

