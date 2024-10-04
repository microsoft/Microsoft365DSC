# AADDeviceRegistrationPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Only valid value is 'Yes'. | `Yes` |
| **AzureADJoinIsAdminConfigurable** | Write | Boolean | Determines whether or not administrators can configure Azure AD Join. | |
| **UserDeviceQuota** | Write | UInt32 | Specifies the maximum number of devices that a user can have within your organization before blocking new device registrations. The default value is set to 50. If this property isn't specified during the policy update operation, it's automatically reset to 0 to indicate that users aren't allowed to join any devices. | |
| **AzureADAllowedToJoin** | Write | String | Scope that a device registration policy applies to. | `All`, `Selected`, `None` |
| **AzureADAllowedToJoinUsers** | Write | StringArray[] | List of users that this policy applies to. | |
| **AzureADAllowedToJoinGroups** | Write | StringArray[] | List of groups that this policy applies to. | |
| **MultiFactorAuthConfiguration** | Write | Boolean | Specifies the authentication policy for a user to complete registration using Microsoft Entra join or Microsoft Entra registered within your organization. | |
| **LocalAdminsEnableGlobalAdmins** | Write | Boolean | Indicates whether global administrators are local administrators on all Microsoft Entra-joined devices. This setting only applies to future registrations. Default is true. | |
| **AzureAdJoinLocalAdminsRegisteringMode** | Write | String | Scope that a device registration policy applies to for local admins. | `All`, `Selected`, `None` |
| **AzureAdJoinLocalAdminsRegisteringGroups** | Write | StringArray[] | List of groups that this policy applies to. | |
| **AzureAdJoinLocalAdminsRegisteringUsers** | Write | StringArray[] | List of users that this policy applies to. | |
| **LocalAdminPasswordIsEnabled** | Write | Boolean | Specifies whether this policy scope is configurable by the admin. The default value is false. An admin can set it to true to enable Local Admin Password Solution (LAPS) within their organzation. | |
| **Credential** | Write | PSCredential | Credentials of the Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

Represents the policy scope that controls quota restrictions, additional authentication, and authorization policies to register device identities to your organization.

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

    - Policy.Read.DeviceConfiguration

- **Update**

    - Policy.ReadWrite.DeviceConfiguration

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
        AADDeviceRegistrationPolicy "MyDeviceRegistrationPolicy"
        {
            ApplicationId                           = $ApplicationId;
            AzureADAllowedToJoin                    = "Selected";
            AzureADAllowedToJoinGroups              = @();
            AzureADAllowedToJoinUsers               = @("AlexW@M365x73318397.OnMicrosoft.com");
            AzureAdJoinLocalAdminsRegisteringGroups = @();
            AzureAdJoinLocalAdminsRegisteringMode   = "Selected";
            AzureAdJoinLocalAdminsRegisteringUsers  = @("AllanD@M365x73318397.OnMicrosoft.com");
            CertificateThumbprint                   = $CertificateThumbprint;
            IsSingleInstance                        = "Yes";
            LocalAdminPasswordIsEnabled             = $False;
            LocalAdminsEnableGlobalAdmins           = $True;
            MultiFactorAuthConfiguration            = $False;
            TenantId                                = $TenantId;
            UserDeviceQuota                         = 50;
        }
    }
}
```

