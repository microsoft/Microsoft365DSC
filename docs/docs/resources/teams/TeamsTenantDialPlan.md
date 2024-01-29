# TeamsTenantDialPlan

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter is a unique identifier that designates the name of the tenant dial plan. Identity is an alphanumeric string that cannot exceed 49 characters. Valid characters are alphabetic or numeric characters, hyphen (-) and dot (.). The value should not begin with a (.). | |
| **Description** | Write | String | The Description parameter describes the tenant dial plan - what it's for, what type of user it applies to and any other information that helps to identify the purpose of the tenant dial plan. Maximum characters: 512. | |
| **NormalizationRules** | Write | MSFT_TeamsVoiceNormalizationRule[] | List of normalization rules that are applied to this dial plan. | |
| **ExternalAccessPrefix** | Write | String | The ExternalAccessPrefix parameter is a number (or set of numbers) that designates the call as external to the organization. (For example, to tenant-dial an outside line, first press 9.) This prefix is ignored by the normalization rules, although these rules are applied to the remainder of the number. The OptimizeDeviceDialing parameter must be set to True for this value to take effect. This parameter must match the regular expression [0-9]{1,4}: that is, it must be a value 0 through 9 and one to four digits in length. The default value is 9. | |
| **OptimizeDeviceDialing** | Write | Boolean | Specifies if the dial plan should optimize device dialing or not. | |
| **SimpleName** | Write | String | The SimpleName parameter is a display name for the tenant dial plan. This name must be unique among all tenant dial plans within the Skype for Business Server deployment.This string can be up to 49 characters long. Valid characters are alphabetic or numeric characters, hyphen (-), dot (.) and parentheses (()). | |
| **Ensure** | Write | String | Specify if this dial plan should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Teams Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

### MSFT_TeamsVoiceNormalizationRule

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Write | String | A unique identifier for the rule. The Identity specified must include the scope followed by a slash and then the name; for example: site:Redmond/Rule1, where site:Redmond is the scope and Rule1 is the name. The name portion will automatically be stored in the Name property. You cannot specify values for Identity and Name in the same command. | |
| **Priority** | Write | UInt32 | The order in which rules are applied. A phone number might match more than one rule. This parameter sets the order in which the rules are tested against the number. | |
| **Description** | Write | String | A friendly description of the normalization rule. | |
| **Pattern** | Write | String | A regular expression that the dialed number must match in order for this rule to be applied. | |
| **Translation** | Write | String | The regular expression pattern that will be applied to the number to convert it to E.164 format. | |
| **IsInternalExtension** | Write | Boolean | If True, the result of applying this rule will be a number internal to the organization. If False, applying the rule results in an external number. This value is ignored if the value of the OptimizeDeviceDialing property of the associated dial plan is set to False. | |

## Description

This resource is used to configure the tenant-wide dial plans for Microsoft Teams.

More information: https://docs.microsoft.com/en-us/microsoftteams/create-and-manage-dial-plans

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

    - Organization.Read.All, User.Read.All, Group.ReadWrite.All, AppCatalog.ReadWrite.All, TeamSettings.ReadWrite.All, Channel.Delete.All, ChannelSettings.ReadWrite.All, ChannelMember.ReadWrite.All

- **Update**

    - Organization.Read.All, User.Read.All, Group.ReadWrite.All, AppCatalog.ReadWrite.All, TeamSettings.ReadWrite.All, Channel.Delete.All, ChannelSettings.ReadWrite.All, ChannelMember.ReadWrite.All

## Examples

### Example 1

This example configures the Teams Guest Calling Configuration.

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
        TeamsTenantDialPlan 'ConfigureTenantDialPlan'
        {
            Identity              = 'DemoPlan'
            Description           = 'This is a demo dial plan'
            NormalizationRules    = @(
                MSFT_TeamsVoiceNormalizationRule
                {
                    Pattern             = '^00(\d+)$'
                    Description         = 'LB International Dialing Rule'
                    Identity            = 'LB Intl Dialing'
                    Translation         = '+$1'
                    Priority            = 0
                    IsInternalExtension = $False
                }
            )
            OptimizeDeviceDialing = $true
            SimpleName            = 'DemoPlan'
            Ensure                = 'Present'
            Credential            = $Credscredential
        }
    }
}
```

