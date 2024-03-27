# TeamsUserPolicyAssignment

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **User** | Key | String | User Principal Name of the user representing the policy assignments. | |
| **CallingLineIdentity** | Write | String | Name of the Calling Line Policy. | |
| **ExternalAccessPolicy** | Write | String | Name of the External Access Policy. | |
| **OnlineVoicemailPolicy** | Write | String | Name of the Online Voicemail Policy. | |
| **OnlineVoiceRoutingPolicy** | Write | String | Name of the Online VOice Routing Policy. | |
| **TeamsAppPermissionPolicy** | Write | String | Name of the Teams App Permission Policy. | |
| **TeamsAppSetupPolicy** | Write | String | Name of the Teams App Setup Policy. | |
| **TeamsAudioConferencingPolicy** | Write | String | Name of the Teams Audio Conferencing Policy. | |
| **TeamsCallHoldPolicy** | Write | String | Name of the Teams Call Hold Policy. | |
| **TeamsCallingPolicy** | Write | String | Name of the Teams Calling Policy. | |
| **TeamsCallParkPolicy** | Write | String | Name of the Teams Call Park Policy. | |
| **TeamsChannelsPolicy** | Write | String | Name of the Teams Channel Policy. | |
| **TeamsEmergencyCallingPolicy** | Write | String | Name of the Teams Emergency Calling Policy. | |
| **TeamsEmergencyCallRoutingPolicy** | Write | String | Name of the Teams Emergency Call Routing Policy. | |
| **TeamsEnhancedEncryptionPolicy** | Write | String | Name of the Teams Enhanced Encryption Policy. | |
| **TeamsEventsPolicy** | Write | String | Name of the Teams Events Policy. | |
| **TeamsMeetingBroadcastPolicy** | Write | String | Name of the Teams Meeting Broadcast Policy. | |
| **TeamsMeetingPolicy** | Write | String | Name of the Teams Meeting Policy. | |
| **TeamsMessagingPolicy** | Write | String | Name of the Teams Messaging Policy. | |
| **TeamsMobilityPolicy** | Write | String | Name of the Teams Mobility Policy. | |
| **TeamsUpdateManagementPolicy** | Write | String | Name of the Teams Update Management Policy. | |
| **TeamsUpgradePolicy** | Write | String | Name of the Teams Upgrade Policy. | |
| **TenantDialPlan** | Write | String | Name of the Tenant Dial Plan Policy. | |
| **Credential** | Write | PSCredential | Credentials of the Teams Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

# TeamsUserAssignmentPolicy

## Description

This resource is used to assign Teams policy to a specified user.

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

This examples configure a TeamsUserPolicyAssignment.

```powershell
Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsCredential
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        TeamsUserPolicyAssignment 'TeamsPolicyAssignment'
        {
            Credential                      = $Credential
            CallingLineIdentity             = "Test";
            ExternalAccessPolicy            = "Test";
            OnlineVoicemailPolicy           = "Test";
            OnlineVoiceRoutingPolicy        = "Drift";
            TeamsAppPermissionPolicy        = "Test";
            TeamsAppSetupPolicy             = "Test";
            TeamsAudioConferencingPolicy    = "Test";
            TeamsCallHoldPolicy             = "Test";
            TeamsCallingPolicy              = "Test";
            TeamsCallParkPolicy             = "Test";
            TeamsChannelsPolicy             = "Test";
            TeamsEmergencyCallingPolicy     = "Test";
            TeamsEmergencyCallRoutingPolicy = "Test";
            TeamsEnhancedEncryptionPolicy   = "Test";
            TeamsEventsPolicy               = "Test";
            TeamsMeetingBroadcastPolicy     = "Test";
            TeamsMeetingPolicy              = "Test";
            TeamsMessagingPolicy            = "Test";
            TeamsMobilityPolicy             = "Test";
            TeamsUpdateManagementPolicy     = "Test";
            TeamsUpgradePolicy              = "Test";
            TenantDialPlan                  = "DemTestPlan";
            User                            = "john.smith@contoso.com";
        }
    }
}
```

