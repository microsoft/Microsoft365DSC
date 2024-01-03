# TeamsFeedbackPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Specify the name of the Teams Feedback Policy. | |
| **UserInitiatedMode** | Write | String | Specifies if users are allowed to give feedback. | |
| **ReceiveSurveysMode** | Write | String | Specifies if users are allowed to receive the survey. | `Enabled`, `Disabled`, `EnabledUserOverride` |
| **AllowScreenshotCollection** | Write | Boolean | Specifies if Screenshot Collection is enabled or not. | |
| **AllowEmailCollection** | Write | Boolean | Specifies if Email Collection is enabled or not. | |
| **AllowLogCollection** | Write | Boolean | Specifies if Log Collection is enabled or not. | |
| **EnableFeatureSuggestions** | Write | Boolean | Specifies if users are allowed to provide feature suggestions | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |


## Description


New-CsTeamsFeedbackPolicy [-Identity] <string> [-UserInitiatedMode <string>] [-ReceiveSurveysMode <string>] [-AllowScreenshotCollection <bool>] [-AllowEmailCollection <bool>] [-AllowLogCollection <bool>] [-EnableFeatureSuggestions <bool>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]


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
        TeamsFeedbackPolicy 'Example'
        {
            AllowEmailCollection      = $False;
            AllowLogCollection        = $False;
            AllowScreenshotCollection = $False;
            Credential                = $Credscredential;
            Ensure                    = "Present";
            Identity                  = "Global";
            ReceiveSurveysMode        = "EnabledUserOverride";
            UserInitiatedMode         = "Enabled";
        }
    }
}
```

