# AADAuthorizationPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Only valid value is 'Yes'. | `Yes` |
| **DisplayName** | Write | String | Display name for this policy. | |
| **Description** | Write | String | Description of this policy. | |
| **AllowedToSignUpEmailBasedSubscriptions** | Write | Boolean | Boolean Indicates whether users can sign up for email based subscriptions. | |
| **AllowedToUseSSPR** | Write | Boolean | Boolean Indicates whether the Self-Serve Password Reset feature can be used by users on the tenant. | |
| **AllowEmailVerifiedUsersToJoinOrganization** | Write | Boolean | Boolean Indicates whether a user can join the tenant by email validation. | |
| **AllowInvitesFrom** | Write | String | Indicates who can invite external users to the organization. Possible values are: None, AdminsAndGuestInviters, AdminsGuestInvitersAndAllMembers, Everyone. Everyone is the default setting for all cloud environments except US Government. | `None`, `AdminsAndGuestInviters`, `AdminsGuestInvitersAndAllMembers`, `Everyone` |
| **BlockMsolPowershell** | Write | Boolean | Boolean To disable the use of MSOL PowerShell, set this property to true. This will also disable user-based access to the legacy service endpoint used by MSOL PowerShell. This does not affect Azure AD Connect or Microsoft Graph. | |
| **DefaultUserRoleAllowedToCreateApps** | Write | Boolean | Boolean Indicates whether the default user role can create applications. | |
| **DefaultUserRoleAllowedToCreateSecurityGroups** | Write | Boolean | Boolean Indicates whether the default user role can create security groups. | |
| **DefaultUserRoleAllowedToReadBitlockerKeysForOwnedDevice** | Write | Boolean | Indicates whether the registered owners of a device can read their own BitLocker recovery keys with default user role. | |
| **DefaultUserRoleAllowedToCreateTenants** | Write | Boolean | Indicates whether the default user role can create tenants. This setting corresponds to the Restrict non-admin users from creating tenants setting in the User settings menu in the Azure portal. When this setting is false, users assigned the Tenant Creator role can still create tenants. | |
| **DefaultUserRoleAllowedToReadOtherUsers** | Write | Boolean | Boolean Indicates whether the default user role can read other users. | |
| **GuestUserRole** | Write | String | The role that should be granted to guest users. Refer to List unifiedRoleDefinitions to find the list of available role templates. Only supported roles today are User, Guest User, and Restricted Guest User (2af84b1e-32c8-42b7-82bc-daa82404023b). | `Guest`, `RestrictedGuest`, `User` |
| **PermissionGrantPolicyIdsAssignedToDefaultUserRole** | Write | StringArray[] | String collection Indicates if user consent to apps is allowed, and if it is, which permission to grant consent and which app consent policy (permissionGrantPolicy) govern the permission for users to grant consent. Value should be in the format managePermissionGrantsForSelf.{id}, where {id} is the id of a built-in or custom app consent policy. An empty list indicates user consent to apps is disabled. | |
| **Ensure** | Write | String | Specify that the Azure Authorization Policy should exist. | `Present` |
| **Credential** | Write | PSCredential | Credentials for the Microsoft Graph delegated permissions. | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures the Azure Active Directory Authorization Policy.

The policy is managed using the BETA API, some properties may have been added in the API but not in the resource

## Azure AD Permissions

To authenticate via Microsoft Graph, this resource required the following Application permissions:

* **Automate**
  * Policy.Read.All
  * Policy.ReadWrite.Authorization

* **Export**
  * Policy.Read.All

NOTE: All permissions listed above require admin consent.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Policy.Read.All

- **Update**

    - Policy.ReadWrite.Authorization

#### Application permissions

- **Read**

    - Policy.Read.All

- **Update**

    - Policy.ReadWrite.Authorization

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADAuthorizationPolicy 'AADAuthPol'
        {
            IsSingleInstance                                  = 'Yes'
            DisplayName                                       = 'Authorization Policy'
            Description                                       = 'Used to manage authorization related settings across the company.'
            AllowEmailVerifiedUsersToJoinOrganization         = $true
            AllowInvitesFrom                                  = 'everyone'
            AllowedToSignUpEmailBasedSubscriptions            = $true
            AllowedToUseSspr                                  = $true
            BlockMsolPowerShell                               = $false
            DefaultUserRoleAllowedToCreateApps                = $true
            DefaultUserRoleAllowedToCreateSecurityGroups      = $true
            DefaultUserRoleAllowedToReadOtherUsers            = $true
            GuestUserRole                                     = 'Guest'
            PermissionGrantPolicyIdsAssignedToDefaultUserRole = @()
            Ensure                                            = 'Present'
            Credential                                        = $Credscredential
        }
    }
}
```

