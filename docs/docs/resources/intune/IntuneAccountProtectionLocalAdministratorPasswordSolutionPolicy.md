# IntuneAccountProtectionPolicyLocalAdministratorPasswordSolutionPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Identity of the account protection LAPS policy. | |
| **DisplayName** | Required | String | Display name of the account protection LAPS policy. | |
| **Description** | Write | String | Description of the account protection LAPS policy. | |
| **Assignments** | Write | MSFT_DeviceManagementConfigurationPolicyAssignments[] | Assignments of the Intune Policy. | |
| **BackupDirectory** | Write | UInt32 | Which directory the local admin account password is backed up to. | `0` = Disabled, `1` = Azure AD, `2` = Active Directory |
| **PasswordAgeDays_AAD** | Write | UInt32 | Maximum password age of the managed local administrator account for Azure AD. Only applicable if the BackupDirectory value is equal to `1`. (7, 365) | `7-365` |
| **PasswordAgeDays** | Write | UInt32 | Maximum password age of the managed local administrator account for Active Directory. Only applicable if the BackupDirectory value is equal to `2`. (1, 365) | `1-365` |
| **PasswordExpirationProtectionEnabled** | Write | Boolean | Whether or not the password expiration protection is enabled. Only applicable if the BackupDirectory value is equal to `2`. | `True`, `False`|
| **AdEncryptedPasswordHistorySize** | Write | UInt32 | How many previous encrypted passwords will be remembered in Active Directory. Only applicable if the BackupDirectory value is equal to `2`. (0, 12) | `0-12` |
| **AdPasswordEncryptionEnabled** | Write | Boolean | Whether or not the password is encrypted before being stored in Active Directory. Only applicable if the BackupDirectory value is equal to `2`. | `True`, `False` |
| **AdPasswordEncryptionPrincipal** | Write | String | Name or SID of a user or group that can decrypt the password stored in Active Directory. Only applicable if the BackupDirectory value is equal to `2`. | |
| **AdministratorAccountName** | Write | String | Name of the local administrator account. | |
| **PasswordComplexity** | Write | UInt32 | Password complexity of the local administrator account. | `1` = Large letters, `2` = Large + small letters, `3` = Large + small letters + numbers, `4` = Large + small letters + numbers + special characters |
| **PasswordLength** | Write | UInt32 | Password length of the local administrator account. (8, 64) | `8-64` |
| **PostAuthenticationActions** | Write | UInt32 | actions to take upon expiration of the configured grace period. | `1` = Reset password, `3` = Reset password + log off, `5` = Reset password + reboot |
| **PostAuthenticationResetDelay** | Write | UInt32 | Delay in hours before the post-authentication action is executed. (0, 24) | `1-24` |
| **Ensure** | Write | String | Present ensures the site collection exists, absent ensures it is removed | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Intune Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

### MSFT_DeviceManagementConfigurationPolicyAssignments

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **dataType** | Write | String | The type of the target assignment. | `#microsoft.graph.groupAssignmentTarget`, `#microsoft.graph.allLicensedUsersAssignmentTarget`, `#microsoft.graph.allDevicesAssignmentTarget`, `#microsoft.graph.exclusionGroupAssignmentTarget`, `#microsoft.graph.configurationManagerCollectionAssignmentTarget` |
| **deviceAndAppManagementAssignmentFilterType** | Write | String | The type of filter of the target assignment i.e. Exclude or Include. Possible values are:none, include, exclude. | `none`, `include`, `exclude` |
| **deviceAndAppManagementAssignmentFilterId** | Write | String | The Id of the filter for the target assignment. | |
| **groupId** | Write | String | The group Id that is the target of the assignment. | |
| **collectionId** | Write | String | The collection Id that is the target of the assignment.(ConfigMgr) | |


## Description

This resource configures an Intune Account Protection Local Administrator Password Solution Policy.


## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - DeviceManagementConfiguration.Read.All

- **Update**

    - DeviceManagementConfiguration.ReadWrite.All

#### Application permissions

- **Read**

    - DeviceManagementConfiguration.Read.All

- **Update**

    - DeviceManagementConfiguration.ReadWrite.All

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
        IntuneAccountProtectionLocalAdministratorPasswordSolutionPolicy "My Account Protection LAPS Policy"
        {
            Identity                 = "cb0a561b-7677-46fb-a7f8-635cf64660e9";
            DisplayName              = "Account Protection LAPS Policy";
            Description              = "My revised description";
            Ensure                   = "Present";
            Credential               = $credsGlobalAdmin
            Assignments              = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allLicensedUsersAssignmentTarget'
                }
            );
            BackupDirectory          = "1";
            PasswordAgeDays_AAD      = 10;
            AdministratorAccountName = "Administrator";
            PasswordAgeDays          = 20;
        }
    }
}
```

