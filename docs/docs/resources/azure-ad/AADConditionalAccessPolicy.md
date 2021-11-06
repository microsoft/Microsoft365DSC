# AADConditionalAccessPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | DisplayName of the AAD CA Policy ||
| **Id** | Write | String | Specifies the GUID for the Policy. ||
| **State** | Write | String | Specifies the State of the Policy. |disabled, enabled, enabledForReportingButNotEnforced|
| **IncludeApplications** | Write | StringArray[] | Cloud Apps in scope of the Policy. ||
| **ExcludeApplications** | Write | StringArray[] | Cloud Apps out of scope of the Policy. ||
| **IncludeUserActions** | Write | StringArray[] | User Actions in scope of the Policy. ||
| **IncludeUsers** | Write | StringArray[] | Users in scope of the Policy. ||
| **ExcludeUsers** | Write | StringArray[] | Users out of scope of the Policy. ||
| **IncludeGroups** | Write | StringArray[] | Groups in scope of the Policy. ||
| **ExcludeGroups** | Write | StringArray[] | Groups out of scope of the Policy. ||
| **IncludeRoles** | Write | StringArray[] | AAD Admin Roles in scope of the Policy. ||
| **ExcludeRoles** | Write | StringArray[] | AAD Admin Roles out of scope of the Policy. ||
| **IncludePlatforms** | Write | StringArray[] | Client Device Platforms in scope of the Policy. ||
| **ExcludePlatforms** | Write | StringArray[] | Client Device Platforms out of scope of the Policy. ||
| **IncludeLocations** | Write | StringArray[] | AAD Named Locations in scope of the Policy. ||
| **ExcludeLocations** | Write | StringArray[] | AAD Named Locations out of scope of the Policy. ||
| **IncludeDevices** | Write | StringArray[] | Client Device Compliance states in scope of the Policy. ||
| **ExcludeDevices** | Write | StringArray[] | Client Device Compliance states out of scope of the Policy. ||
| **UserRiskLevels** | Write | StringArray[] | AAD Identity Protection User Risk Levels in scope of the Policy. ||
| **SignInRiskLevels** | Write | StringArray[] | AAD Identity Protection Sign-in Risk Levels in scope of the Policy. ||
| **ClientAppTypes** | Write | StringArray[] | Client App types in scope of the Policy. ||
| **GrantControlOperator** | Write | String | Operator to be used for Grant Controls. |AND, OR|
| **BuiltInControls** | Write | StringArray[] | List of built-in Grant Controls to be applied by the Policy. ||
| **ApplicationEnforcedRestrictionsIsEnabled** | Write | Boolean | Specifies, whether Application Enforced Restrictions are enabled in the Policy. ||
| **CloudAppSecurityIsEnabled** | Write | Boolean | Specifies, whether Cloud App Security is enforced by the Policy. ||
| **CloudAppSecurityType** | Write | String | Specifies, what Cloud App Security control is enforced by the Policy. ||
| **SignInFrequencyValue** | Write | UInt32 | Sign in frequency time in the given unit to be enforced by the policy. ||
| **SignInFrequencyType** | Write | String | Sign in frequency unit (days/hours) to be interpreted by the policy. |Days, Hours, |
| **SignInFrequencyIsEnabled** | Write | Boolean | Specifies, whether sign-in frequency is enforced by the Policy. ||
| **PersistentBrowserIsEnabled** | Write | Boolean | Specifies, whether Browser Persistence is controlled by the Policy. ||
| **PersistentBrowserMode** | Write | String | Specifies, what Browser Persistence control is enforced by the Policy. |Always, Never, |
| **Ensure** | Write | String | Specify if the Azure AD CA Policy should exist or not. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials for the Microsoft Graph delegated permissions. ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **ApplicationSecret** | Write | String | Secret of the Azure Active Directory application to authenticate with. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||

# AADConditionalAccessPolicy

### Description

This resource configures an Azure Active Directory Conditional Access Policy.

## Azure AD Permissions

To authenticate via Azure Active Directory, this resource required the following Application permissions:

* **Automate**
  * Application.Read.All
  * Group.Read.All
  * Directory.Read.All
  * Policy.Read.All
  * Policy.Read.ConditionalAccess
  * Policy.ReadWrite.ConditionalAccess
  * RoleManagement.Read.All
  * RoleManagement.Read.Directory
  * User.Read.All

* **Export**
  * Application.Read.All
  * Group.Read.All
  * Directory.Read.All
  * Policy.Read.All
  * Policy.Read.ConditionalAccess
  * RoleManagement.Read.All
  * RoleManagement.Read.Directory
  * User.Read.All

NOTE: All permisions listed above require admin consent.

Additionally Global Reader Role needs to be assigned, as long as AAD PowerShell is not fully converged to use GRAPH API

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
        AADConditionalAccessPolicy 'Allin-example'
        {
            BuiltInControls            = @("Mfa", "CompliantDevice", "DomainJoinedDevice", "ApprovedApplication", "CompliantApplication")
            ClientAppTypes             = @("ExchangeActiveSync", "Browser", "MobileAppsAndDesktopClients", "Other")
            CloudAppSecurityIsEnabled  = $True
            CloudAppSecurityType       = "MonitorOnly"
            DisplayName                = "Allin-example"
            ExcludeApplications        = @("803ee9ca-3f7f-4824-bd6e-0b99d720c35c", "00000012-0000-0000-c000-000000000000", "00000007-0000-0000-c000-000000000000", "Office365")
            ExcludeDevices             = @("Compliant", "DomainJoined")
            ExcludeGroups              = @()
            ExcludeLocations           = @("Blocked Countries")
            ExcludePlatforms           = @("Windows", "WindowsPhone", "MacOS")
            ExcludeRoles               = @("Company Administrator", "Application Administrator", "Application Developer", "Cloud Application Administrator", "Cloud Device Administrator")
            ExcludeUsers               = @("admin@contoso.com", "AAdmin@contoso.com", "CAAdmin@contoso.com", "AllanD@contoso.com", "AlexW@contoso.com", "GuestsOrExternalUsers")
            GrantControlOperator       = "OR"
            IncludeApplications        = @("All")
            IncludeDevices             = @("All")
            IncludeGroups              = @()
            IncludeLocations           = @("AllTrusted")
            IncludePlatforms           = @("Android", "IOS")
            IncludeRoles               = @("Compliance Administrator")
            IncludeUserActions         = @()
            IncludeUsers               = @("Alexw@contoso.com")
            PersistentBrowserIsEnabled = $false
            PersistentBrowserMode      = ""
            SignInFrequencyIsEnabled   = $True
            SignInFrequencyType        = "Hours"
            SignInFrequencyValue       = 5
            SignInRiskLevels           = @("High", "Medium")
            State                      = "disabled"
            UserRiskLevels             = @("High", "Medium")
            Ensure                     = "Present"
            Credential                 = $credsGlobalAdmin
        }
    }
}
```

