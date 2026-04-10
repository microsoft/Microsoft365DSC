<#
This examples configure a TeamsUserPolicyAssignment.
#>

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
