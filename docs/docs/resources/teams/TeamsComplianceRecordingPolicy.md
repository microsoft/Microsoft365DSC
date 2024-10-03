# TeamsComplianceRecordingPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Unique identifier of the application instance of a policy-based recording application to be retrieved. | |
| **ComplianceRecordingApplications** | Write | MSFT_TeamsComplianceRecordingApplication[] | A list of application instances of policy-based recording applications to assign to this policy. The Id of each of these application instances must be the ObjectId of the application instance as obtained by the Get-CsOnlineApplicationInstance cmdlet. | |
| **Description** | Write | String | Enables administrators to provide explanatory text to accompany a Teams recording policy. For example, the Description might include information about the users the policy should be assigned to. | |
| **DisableComplianceRecordingAudioNotificationForCalls** | Write | Boolean | Setting this attribute to true disables recording audio notifications for 1:1 calls that are under compliance recording. | |
| **Enabled** | Write | Boolean | Controls whether this Teams recording policy is active or not. | |
| **WarnUserOnRemoval** | Write | Boolean | This parameter is reserved for future use. | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

### MSFT_TeamsComplianceRecordingApplication

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Write | String | A name that uniquely identifies the application instance of the policy-based recording application. | |
| **ComplianceRecordingPairedApplications** | Write | StringArray[] | Determines the other policy-based recording applications to pair with this application to achieve application resiliency. Can only have one paired application. | |
| **RequiredBeforeMeetingJoin** | Write | Boolean | Indicates whether the policy-based recording application must be in the meeting before the user is allowed to join the meeting. | |
| **RequiredBeforeCallEstablishment** | Write | Boolean | Indicates whether the policy-based recording application must be in the call before the call is allowed to establish. | |
| **RequiredDuringMeeting** | Write | Boolean | Indicates whether the policy-based recording application must be in the meeting while the user is in the meeting. | |
| **RequiredDuringCall** | Write | Boolean | Indicates whether the policy-based recording application must be in the call while the call is active. | |
| **ConcurrentInvitationCount** | Write | String | Determines the number of invites to send out to the application instance of the policy-based recording application. Can be set to 1 or 2 only. | |


## Description

Creates a new Teams recording policy for governing automatic policy-based recording in your tenant. Automatic policy-based recording is only applicable to Microsoft Teams users.

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

    - Organization.Read.All

- **Update**

    - Organization.Read.All

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
        TeamsComplianceRecordingPolicy "TeamsComplianceRecordingPolicy-Tag:MyTeamsComplianceRecordingPolicy"
        {
            Credential                                          = $credsCredential;
            ComplianceRecordingApplications                     = @(
                MSFT_TeamsComplianceRecordingApplication{
                    Id = '00000000-0000-0000-0000-000000000000'
                    ComplianceRecordingPairedApplications = @('00000000-0000-0000-0000-000000000000')
                    ConcurrentInvitationCount = 1
                    RequiredDuringCall = $True
                    RequiredBeforeMeetingJoin = $True
                    RequiredBeforeCallEstablishment = $True
                    RequiredDuringMeeting = $True
                }
                MSFT_TeamsComplianceRecordingApplication{
                    Id = '12345678-0000-0000-0000-000000000000'
                    ComplianceRecordingPairedApplications = @('87654321-0000-0000-0000-000000000000')
                    ConcurrentInvitationCount = 1
                    RequiredDuringCall = $True
                    RequiredBeforeMeetingJoin = $True
                    RequiredBeforeCallEstablishment = $True
                    RequiredDuringMeeting = $True
                }
            );
            Description                                         = "MyTeamsComplianceRecordingPolicy";
            DisableComplianceRecordingAudioNotificationForCalls = $False;
            Enabled                                             = $True;
            Ensure                                              = "Present";
            Identity                                            = "Tag:MyTeamsComplianceRecordingPolicy";
            WarnUserOnRemoval                                   = $True;
        }
    }
}
```

