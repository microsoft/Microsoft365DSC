# AADGroupsSettings

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Only valid value is 'Yes'. | `Yes` |
| **EnableGroupCreation** | Write | Boolean | The flag indicating whether Office 365 group creation is allowed in the directory by non-admin users. This setting does not require an Azure Active Directory Premium P1 license. | |
| **EnableMIPLabels** | Write | Boolean | Boolean indicating whether or not sensitivity labels can be assigned to M365-groups. | |
| **AllowGuestsToBeGroupOwner** | Write | Boolean | Boolean indicating whether or not a guest user can be an owner of groups. | |
| **AllowGuestsToAccessGroups** | Write | Boolean | Boolean indicating whether or not a guest user can have access to Office 365 groups content. This setting does not require an Azure Active Directory Premium P1 license. | |
| **GuestUsageGuidelinesUrl** | Write | String | The url of a link to the guest usage guidelines. | |
| **GroupCreationAllowedGroupName** | Write | String | Name of the security group for which the members are allowed to create Office 365 groups even when EnableGroupCreation == false. | |
| **AllowToAddGuests** | Write | Boolean | A boolean indicating whether or not is allowed to add guests to this directory. | |
| **UsageGuidelinesUrl** | Write | String | A link to the Group Usage Guidelines. | |
| **Ensure** | Write | String | Specify if the Azure AD Groups Naming Policy should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials for the Microsoft Graph delegated permissions. | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

# AADGroupsNamingPolicy

## Description

This resource configures an Azure Active Directory Groups Settings.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Directory.Read.All, Group.Read.All

- **Update**

    - Directory.Read.All, Directory.ReadWrite.All, Group.Read.All

#### Application permissions

- **Read**

    - Directory.Read.All, Group.Read.All

- **Update**

    - Directory.Read.All, Directory.ReadWrite.All, Group.Read.All

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
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADGroupsSettings 'GeneralGroupsSettings'
        {
            IsSingleInstance              = "Yes"
            AllowGuestsToAccessGroups     = $True
            AllowGuestsToBeGroupOwner     = $True
            AllowToAddGuests              = $True
            EnableGroupCreation           = $True
            GroupCreationAllowedGroupName = "All Company"
            GuestUsageGuidelinesUrl       = "https://contoso.com/guestusage"
            UsageGuidelinesUrl            = "https://contoso.com/usage"
            Ensure                        = "Present"
            Credential                    = $Credscredential
        }
    }
}
```

### Example 2

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADGroupsSettings 'GeneralGroupsSettings'
        {
            IsSingleInstance              = "Yes"
            Ensure                        = "Absent"
            Credential                    = $Credscredential
        }
    }
}
```

