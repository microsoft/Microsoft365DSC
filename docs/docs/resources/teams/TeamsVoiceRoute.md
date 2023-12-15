# TeamsVoiceRoute

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Identity of the Teams Voice Route. | |
| **Description** | Write | String | A description of what this online voice route is for. | |
| **NumberPattern** | Write | String | A regular expression that specifies the phone numbers to which this route applies. Numbers matching this pattern will be routed according to the rest of the routing settings. | |
| **OnlinePstnGatewayList** | Write | StringArray[] | This parameter contains a list of online gateways associated with this online voice route.  Each member of this list must be the service Identity of the online PSTN gateway. | |
| **OnlinePstnUsages** | Write | StringArray[] | A list of online PSTN usages (such as Local, Long Distance, etc.) that can be applied to this online voice route. The PSTN usage must be an existing usage (PSTN usages can be retrieved by calling the Get-CsOnlinePstnUsage cmdlet). | |
| **Priority** | Write | UInt32 | A number could resolve to multiple online voice routes. The priority determines the order in which the routes will be applied if more than one route is possible. | |
| **Ensure** | Write | String | Present ensures the route exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Teams Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |


## Description

This resource configures a Teams Voice Route.

More information: https://docs.microsoft.com/en-us/microsoftteams/direct-routing-voice-routing

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

This example adds a new Teams Voice Route.

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
        TeamsVoiceRoute 'ConfigureVoiceRoute'
        {
            Identity              = 'NewVoiceRoute'
            Description           = 'This is a sample Voice Route'
            NumberPattern         = '^\+1(425|206)(\d{7})'
            OnlinePstnGatewayList = @('sbc1.litwareinc.com', 'sbc2.litwareinc.com')
            OnlinePstnUsages      = @('Long Distance', 'Local', 'Internal')
            Priority              = 10
            Ensure                = 'Present'
            Credential            = $Credscredential
        }
    }
}
```

