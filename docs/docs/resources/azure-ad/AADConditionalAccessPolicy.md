# AADConditionalAccessPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | DisplayName of the AAD CA Policy | |
| **Id** | Write | String | Specifies the GUID for the Policy. | |
| **State** | Write | String | Specifies the State of the Policy. | `disabled`, `enabled`, `enabledForReportingButNotEnforced` |
| **IncludeApplications** | Write | StringArray[] | Cloud Apps in scope of the Policy. | |
| **ExcludeApplications** | Write | StringArray[] | Cloud Apps out of scope of the Policy. | |
| **IncludeUserActions** | Write | StringArray[] | User Actions in scope of the Policy. | |
| **IncludeUsers** | Write | StringArray[] | Users in scope of the Policy. | |
| **ExcludeUsers** | Write | StringArray[] | Users out of scope of the Policy. | |
| **IncludeGroups** | Write | StringArray[] | Groups in scope of the Policy. | |
| **ExcludeGroups** | Write | StringArray[] | Groups out of scope of the Policy. | |
| **IncludeRoles** | Write | StringArray[] | AAD Admin Roles in scope of the Policy. | |
| **ExcludeRoles** | Write | StringArray[] | AAD Admin Roles out of scope of the Policy. | |
| **IncludeGuestOrExternalUserTypes** | Write | StringArray[] | Represents the Included internal guests or external user types. This is a multi-valued property. Supported values are: b2bCollaborationGuest, b2bCollaborationMember, b2bDirectConnectUser, internalGuest, OtherExternalUser, serviceProvider and unknownFutureValue. | `none`, `internalGuest`, `b2bCollaborationGuest`, `b2bCollaborationMember`, `b2bDirectConnectUser`, `otherExternalUser`, `serviceProvider`, `unknownFutureValue` |
| **IncludeExternalTenantsMembershipKind** | Write | String | Represents the Included Tenants membership kind. The possible values are: all, enumerated, unknownFutureValue. enumerated references an object of conditionalAccessEnumeratedExternalTenants derived type. | ``, `all`, `enumerated`, `unknownFutureValue` |
| **IncludeExternalTenantsMembers** | Write | StringArray[] | Represents the Included collection of tenant ids in the scope of Conditional Access for guests and external users policy targeting. | |
| **ExcludeGuestOrExternalUserTypes** | Write | StringArray[] | Represents the Excluded internal guests or external user types. This is a multi-valued property. Supported values are: b2bCollaborationGuest, b2bCollaborationMember, b2bDirectConnectUser, internalGuest, OtherExternalUser, serviceProvider and unknownFutureValue. | `none`, `internalGuest`, `b2bCollaborationGuest`, `b2bCollaborationMember`, `b2bDirectConnectUser`, `otherExternalUser`, `serviceProvider`, `unknownFutureValue` |
| **ExcludeExternalTenantsMembershipKind** | Write | String | Represents the Excluded Tenants membership kind. The possible values are: all, enumerated, unknownFutureValue. enumerated references an object of conditionalAccessEnumeratedExternalTenants derived type. | ``, `all`, `enumerated`, `unknownFutureValue` |
| **ExcludeExternalTenantsMembers** | Write | StringArray[] | Represents the Excluded collection of tenant ids in the scope of Conditional Access for guests and external users policy targeting. | |
| **IncludePlatforms** | Write | StringArray[] | Client Device Platforms in scope of the Policy. | |
| **ExcludePlatforms** | Write | StringArray[] | Client Device Platforms out of scope of the Policy. | |
| **IncludeLocations** | Write | StringArray[] | AAD Named Locations in scope of the Policy. | |
| **ExcludeLocations** | Write | StringArray[] | AAD Named Locations out of scope of the Policy. | |
| **DeviceFilterMode** | Write | String | Client Device Filter mode of the Policy. | `include`, `exclude` |
| **DeviceFilterRule** | Write | String | Client Device Filter rule of the Policy. | |
| **UserRiskLevels** | Write | StringArray[] | AAD Identity Protection User Risk Levels in scope of the Policy. | |
| **SignInRiskLevels** | Write | StringArray[] | AAD Identity Protection Sign-in Risk Levels in scope of the Policy. | |
| **ClientAppTypes** | Write | StringArray[] | Client App types in scope of the Policy. | |
| **GrantControlOperator** | Write | String | Operator to be used for Grant Controls. | `AND`, `OR` |
| **BuiltInControls** | Write | StringArray[] | List of built-in Grant Controls to be applied by the Policy. | |
| **ApplicationEnforcedRestrictionsIsEnabled** | Write | Boolean | Specifies, whether Application Enforced Restrictions are enabled in the Policy. | |
| **CloudAppSecurityIsEnabled** | Write | Boolean | Specifies, whether Cloud App Security is enforced by the Policy. | |
| **CloudAppSecurityType** | Write | String | Specifies, what Cloud App Security control is enforced by the Policy. | |
| **SignInFrequencyValue** | Write | UInt32 | Sign in frequency time in the given unit to be enforced by the policy. | |
| **TermsOfUse** | Write | String | Display name of the terms of use to assign. | |
| **CustomAuthenticationFactors** | Write | StringArray[] | Custom Controls assigned to the grant property of this policy. | |
| **SignInFrequencyType** | Write | String | Sign in frequency unit (days/hours) to be interpreted by the policy. | `Days`, `Hours`, `` |
| **SignInFrequencyIsEnabled** | Write | Boolean | Specifies, whether sign-in frequency is enforced by the Policy. | |
| **SignInFrequencyInterval** | Write | String | Sign in frequency interval. Possible values are: timeBased, everyTime and unknownFutureValue. | `timeBased`, `everyTime`, `unknownFutureValue` |
| **PersistentBrowserIsEnabled** | Write | Boolean | Specifies, whether Browser Persistence is controlled by the Policy. | |
| **PersistentBrowserMode** | Write | String | Specifies, what Browser Persistence control is enforced by the Policy. | `Always`, `Never`, `` |
| **AuthenticationStrength** | Write | String | Name of the associated authentication strength policy. | |
| **AuthenticationContexts** | Write | StringArray[] | Authentication context class references. | |
| **Ensure** | Write | String | Specify if the Azure AD CA Policy should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials for the Microsoft Graph delegated permissions. | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures an Azure Active Directory Conditional Access Policy.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Agreement.Read.All, Group.Read.All, Policy.Read.All, RoleManagement.Read.Directory, User.Read.All

- **Update**

    - Agreement.Read.All, Group.Read.All, Policy.Read.All, Policy.ReadWrite.ConditionalAccess, RoleManagement.Read.Directory, User.Read.All

#### Application permissions

- **Read**

    - Policy.Read.All

- **Update**

    - Application.Read.All, Policy.ReadWrite.ConditionalAccess

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
        AADConditionalAccessPolicy 'Allin-example'
        {
            DisplayName                          = 'Allin-example'
            BuiltInControls                      = @('Mfa', 'CompliantDevice', 'DomainJoinedDevice', 'ApprovedApplication', 'CompliantApplication')
            ClientAppTypes                       = @('ExchangeActiveSync', 'Browser', 'MobileAppsAndDesktopClients', 'Other')
            CloudAppSecurityIsEnabled            = $True
            CloudAppSecurityType                 = 'MonitorOnly'
            ExcludeApplications                  = @('803ee9ca-3f7f-4824-bd6e-0b99d720c35c', '00000012-0000-0000-c000-000000000000', '00000007-0000-0000-c000-000000000000', 'Office365')
            ExcludeGroups                        = @()
            ExcludeLocations                     = @('Blocked Countries')
            ExcludePlatforms                     = @('Windows', 'WindowsPhone', 'MacOS')
            ExcludeRoles                         = @('Company Administrator', 'Application Administrator', 'Application Developer', 'Cloud Application Administrator', 'Cloud Device Administrator')
            ExcludeUsers                         = @('admin@contoso.com', 'AAdmin@contoso.com', 'CAAdmin@contoso.com', 'AllanD@contoso.com', 'AlexW@contoso.com', 'GuestsOrExternalUsers')
            ExcludeExternalTenantsMembers        = @()
            ExcludeExternalTenantsMembershipKind = 'all'
            ExcludeGuestOrExternalUserTypes      = @('internalGuest', 'b2bCollaborationMember')
            GrantControlOperator                 = 'OR'
            IncludeApplications                  = @('All')
            IncludeGroups                        = @()
            IncludeLocations                     = @('AllTrusted')
            IncludePlatforms                     = @('Android', 'IOS')
            IncludeRoles                         = @('Compliance Administrator')
            IncludeUserActions                   = @()
            IncludeUsers                         = @('Alexw@contoso.com')
            IncludeExternalTenantsMembers        = @('11111111-1111-1111-1111-111111111111')
            IncludeExternalTenantsMembershipKind = 'enumerated'
            IncludeGuestOrExternalUserTypes      = @('b2bCollaborationGuest')
            PersistentBrowserIsEnabled           = $false
            PersistentBrowserMode                = ''
            SignInFrequencyIsEnabled             = $true
            SignInFrequencyType                  = 'Hours'
            SignInFrequencyValue                 = 5
            SignInRiskLevels                     = @('High', 'Medium')
            State                                = 'disabled'
            UserRiskLevels                       = @('High', 'Medium')
            Ensure                               = 'Present'
            Credential                           = $Credscredential
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
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADConditionalAccessPolicy 'Allin-example'
        {
            DisplayName                          = 'Allin-example'
            BuiltInControls                      = @('Mfa', 'CompliantDevice', 'DomainJoinedDevice', 'ApprovedApplication', 'CompliantApplication')
            ClientAppTypes                       = @('ExchangeActiveSync', 'Browser', 'MobileAppsAndDesktopClients', 'Other')
            CloudAppSecurityIsEnabled            = $False # Updated Property
            CloudAppSecurityType                 = 'MonitorOnly'
            ExcludeApplications                  = @('803ee9ca-3f7f-4824-bd6e-0b99d720c35c', '00000012-0000-0000-c000-000000000000', '00000007-0000-0000-c000-000000000000', 'Office365')
            ExcludeGroups                        = @()
            ExcludeLocations                     = @('Blocked Countries')
            ExcludePlatforms                     = @('Windows', 'WindowsPhone', 'MacOS')
            ExcludeRoles                         = @('Company Administrator', 'Application Administrator', 'Application Developer', 'Cloud Application Administrator', 'Cloud Device Administrator')
            ExcludeUsers                         = @('admin@contoso.com', 'AAdmin@contoso.com', 'CAAdmin@contoso.com', 'AllanD@contoso.com', 'AlexW@contoso.com', 'GuestsOrExternalUsers')
            ExcludeExternalTenantsMembers        = @()
            ExcludeExternalTenantsMembershipKind = 'all'
            ExcludeGuestOrExternalUserTypes      = @('internalGuest', 'b2bCollaborationMember')
            GrantControlOperator                 = 'OR'
            IncludeApplications                  = @('All')
            IncludeGroups                        = @()
            IncludeLocations                     = @('AllTrusted')
            IncludePlatforms                     = @('Android', 'IOS')
            IncludeRoles                         = @('Compliance Administrator')
            IncludeUserActions                   = @()
            IncludeUsers                         = @('Alexw@contoso.com')
            IncludeExternalTenantsMembers        = @('11111111-1111-1111-1111-111111111111')
            IncludeExternalTenantsMembershipKind = 'enumerated'
            IncludeGuestOrExternalUserTypes      = @('b2bCollaborationGuest')
            PersistentBrowserIsEnabled           = $false
            PersistentBrowserMode                = ''
            SignInFrequencyIsEnabled             = $true
            SignInFrequencyType                  = 'Hours'
            SignInFrequencyValue                 = 5
            SignInRiskLevels                     = @('High', 'Medium')
            State                                = 'disabled'
            UserRiskLevels                       = @('High', 'Medium')
            Ensure                               = 'Present'
            Credential                           = $Credscredential
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
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADConditionalAccessPolicy 'Allin-example'
        {
            DisplayName                          = 'Allin-example'
            Ensure                               = 'Absent'
            Credential                           = $Credscredential
        }
    }
}
```

