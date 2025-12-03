<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

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
        SCProtectionAlert 'CustomSuspiciousEmailSendingPatternDetected'
        {
            AggregationType         = "None";
            Category                = "ThreatManagement";
            Comment                 = "User has been detected as sending suspicious messages outside the organization and will be restricted if this activity continues. -V1.0.0.1";
            Credential              = $Credscredential;
            Disabled                = $False;
            Ensure                  = "Present";
            Name                    = "Custom Suspicious email sending patterns detected";
            NotificationEnabled     = $True;
            NotifyUser              = @("admin@contoso.com");
            NotifyUserOnFilterMatch = $False;
            Operation               = @("CompromisedWarningAccount");
            Severity                = "Medium";
        }

        SCProtectionAlert 'CustomEmailMessagesFromAcampaignRemovedAfterDelivery'
        {
            AggregationType         = "None";
            Category                = "ThreatManagement";
            Comment                 = "Emails messages from a campaign were delivered and later removed -V1.0.0.2";
            Credential              = $Credscredential;
            Disabled                = $False;
            Ensure                  = "Present";
            Filter                  = "(Mail.IsMailZAPSuccessful -eq 1) -and Mail.IsCampaignZapped -eq 1 -and (Mail.TenantPolicyFinalVerdictSource -ne 'PhishEdu') -and (Mail.TenantPolicyFinalVerdictSource -ne 'SecOps') -and (Mail.TenantPolicyFinalVerdictSource -ne 'ThirdPartyFiltering')";
            Name                    = "Custom Email messages from a campaign removed after delivery​";
            NotificationEnabled     = $False;
            NotifyUser              = @("TenantAdmins");
            NotifyUserOnFilterMatch = $False;
            Severity                = "Informational";
            ThreatType              = "Malicious";
        }
    }
}
