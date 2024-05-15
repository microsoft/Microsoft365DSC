# TeamsEmergencyCallRoutingPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Identity of the Teams Emergency Call Routing Policy. | |
| **Description** | Write | String | Description of the Teams Emergency Call Routing Policy. | |
| **EmergencyNumbers** | Write | MSFT_TeamsEmergencyNumber[] | Emergency number(s) associated with the policy. | |
| **AllowEnhancedEmergencyServices** | Write | Boolean | Flag to enable Enhanced Emergency Services | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Teams Admin. | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

### MSFT_TeamsEmergencyNumber

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **EmergencyDialString** | Write | String | Specifies the emergency phone number. | |
| **EmergencyDialMask** | Write | String | For each Teams emergency number, you can specify zero or more emergency dial masks. A dial mask is a number that you want to translate into the value of the emergency dial number value when it is dialed. | |
| **OnlinePSTNUsage** | Write | String | Specify the online public switched telephone network (PSTN) usage | |


## Description

This resource configures the Teams Emergency Call Routing Policies.

More information: https://docs.microsoft.com/en-us/microsoftteams/manage-emergency-call-routing-policies

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

This example adds a new Teams Emergency Call Routing Policy.

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
        TeamsEmergencyCallRoutingPolicy 'EmergencyCallRoutingPolicyExample'
        {
            Identity                       = "Unit Test"
            AllowEnhancedEmergencyServices = $False
            Description                    = "Description"
            EmergencyNumbers               = @(
                MSFT_TeamsEmergencyNumber
                {
                    EmergencyDialString = '123456'
                    EmergencyDialMask   = '123'
                    OnlinePSTNUsage     = ''
                }
            )
            Ensure                         = "Present"
            Credential                     = $Credscredential
        }
    }
}
```

