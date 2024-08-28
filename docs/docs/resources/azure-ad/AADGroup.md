# AADGroup

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | DisplayName of the Azure Active Directory Group | |
| **MailNickname** | Key | String | Specifies a mail nickname for the group. | |
| **Description** | Write | String | Specifies a description for the group. | |
| **Id** | Write | String | Specifies an ID for the group. | |
| **Owners** | Write | StringArray[] | User Service Principal values for the group's owners. | |
| **Members** | Write | StringArray[] | User Service Principal values for the group's members. | |
| **GroupAsMembers** | Write | StringArray[] | Displayname values for the groups member of the group. | |
| **MemberOf** | Write | StringArray[] | DisplayName values for the groups that this group is a member of. | |
| **GroupTypes** | Write | StringArray[] | Specifies that the group is a dynamic group. To create a dynamic group, specify a value of DynamicMembership. | |
| **MembershipRule** | Write | String | Specifies the membership rule for a dynamic group. | |
| **MembershipRuleProcessingState** | Write | String | Specifies the rule processing state. The acceptable values for this parameter are: On. Process the group rule or Paused. Stop processing the group rule. | `On`, `Paused` |
| **SecurityEnabled** | Required | Boolean | Specifies whether the group is security enabled. For security groups, this value must be $True. | |
| **MailEnabled** | Required | Boolean | Specifies whether this group is mail enabled. Currently, you cannot create mail enabled groups in Azure AD. | |
| **IsAssignableToRole** | Write | Boolean | Specifies whether this group can be assigned a role. Only available when creating a group and can't be modified after group is created. | |
| **AssignedToRole** | Write | StringArray[] | DisplayName values for the roles that the group is assigned to. | |
| **Visibility** | Write | String | This parameter determines the visibility of the group's content and members list. | `Public`, `Private`, `HiddenMembership` |
| **AssignedLicenses** | Write | MSFT_AADGroupLicense[] | List of Licenses assigned to the group. | |
| **Ensure** | Write | String | Specify if the Azure AD Group should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials for the Microsoft Graph delegated permissions. | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

### MSFT_AADGroupLicense

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisabledPlans** | Write | StringArray[] | A collection of the unique identifiers for plans that have been disabled. | |
| **SkuId** | Write | String | The unique identifier for the SKU. | |

## Description

This resource configures an Azure Active Directory group. IMPORTANT: It does not support mail enabled security groups or mail enabled groups that are not unified or dynamic groups.

If using with AADUser, be aware that if AADUser->MemberOf is being specified and the referenced group is configured with AADGroup->Member then a conflict may arise if the two don't match. It is usually best to choose only one of them. See AADUser

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Group.Read.All, ReportSettings.Read.All

- **Update**

    - Group.ReadWrite.All, Organization.Read.All, RoleManagement.ReadWrite.Directory, User.Read.All, ReportSettings.ReadWrite.All

#### Application permissions

- **Read**

    - Group.Read.All, ReportSettings.Read.All

- **Update**

    - Group.Read.All, Group.ReadWrite.All, Organization.Read.All, RoleManagement.Read.Directory, RoleManagement.ReadWrite.Directory, User.Read.All, ReportSettings.ReadWrite.All

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
        AADGroup 'MyGroups'
        {
            DisplayName     = "DSCGroup"
            Description     = "Microsoft DSC Group"
            SecurityEnabled = $True
            MailEnabled     = $True
            GroupTypes      = @("Unified")
            MailNickname    = "M365DSC"
            Members         = @("admin@$TenantId", "AdeleV@$TenantId")
            GroupAsMembers  = @("Group1", "Group2")
            Visibility      = "Private"
            Owners          = @("admin@$TenantId", "AdeleV@$TenantId")
            Ensure          = "Present"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
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
        AADGroup 'MyGroups'
        {
            DisplayName     = "DSCGroup"
            Description     = "Microsoft DSC Group Updated" # Updated Property
            SecurityEnabled = $True
            MailEnabled     = $True
            GroupTypes      = @("Unified")
            MailNickname    = "M365DSC"
            Members         = @("AdeleV@$TenantId")
            GroupAsMembers  = @("Group1")
            Visibility      = "Private"
            Owners          = @("admin@$TenantId", "AdeleV@$TenantId")
            Ensure          = "Present"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
```

### Example 3

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
        AADGroup 'MyGroups'
        {
            MailNickname    = "M365DSC"
            SecurityEnabled = $True
            MailEnabled     = $True
            DisplayName     = "DSCGroup"
            Ensure          = "Absent"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
```

