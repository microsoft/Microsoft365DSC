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

    Node localhost
    {
        AADRoleSetting 28b253d8-cde5-471f-a331-fe7320023cdd
        {
            ActivateApprover                                          = @();
            ActivationMaxDuration                                     = "PT8H";
            ActivationReqJustification                                = $True;
            ActivationReqMFA                                          = $False;
            ActivationReqTicket                                       = $False;
            ActiveAlertNotificationAdditionalRecipient                = @();
            ActiveAlertNotificationDefaultRecipient                   = $True;
            ActiveAlertNotificationOnlyCritical                       = $False;
            ActiveApproveNotificationAdditionalRecipient              = @();
            ActiveApproveNotificationDefaultRecipient                 = $True;
            ActiveApproveNotificationOnlyCritical                     = $False;
            ActiveAssigneeNotificationAdditionalRecipient             = @();
            ActiveAssigneeNotificationDefaultRecipient                = $True;
            ActiveAssigneeNotificationOnlyCritical                    = $False;
            ApplicationId                                             = $ConfigurationData.NonNodeData.ApplicationId;
            ApprovaltoActivate                                        = $False;
            AssignmentReqJustification                                = $True;
            AssignmentReqMFA                                          = $False;
            CertificateThumbprint                                     = $ConfigurationData.NonNodeData.CertificateThumbprint;
            Displayname                                               = "Application Administrator";
            ElegibilityAssignmentReqJustification                     = $False;
            ElegibilityAssignmentReqMFA                               = $False;
            EligibleAlertNotificationAdditionalRecipient              = @();
            EligibleAlertNotificationDefaultRecipient                 = $True;
            EligibleAlertNotificationOnlyCritical                     = $False;
            EligibleApproveNotificationAdditionalRecipient            = @();
            EligibleApproveNotificationDefaultRecipient               = $True;
            EligibleApproveNotificationOnlyCritical                   = $False;
            EligibleAssigneeNotificationAdditionalRecipient           = @();
            EligibleAssigneeNotificationDefaultRecipient              = $True;
            EligibleAssigneeNotificationOnlyCritical                  = $False;
            EligibleAssignmentAlertNotificationAdditionalRecipient    = @();
            EligibleAssignmentAlertNotificationDefaultRecipient       = $True;
            EligibleAssignmentAlertNotificationOnlyCritical           = $False;
            EligibleAssignmentAssigneeNotificationAdditionalRecipient = @();
            EligibleAssignmentAssigneeNotificationDefaultRecipient    = $True;
            EligibleAssignmentAssigneeNotificationOnlyCritical        = $False;
            ExpireActiveAssignment                                    = "P180D";
            ExpireEligibleAssignment                                  = "P365D";
            Id                                                        = "9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3";
            PermanentActiveAssignmentisExpirationRequired             = $False;
            PermanentEligibleAssignmentisExpirationRequired           = $False;
            TenantId                                                  = $ConfigurationData.NonNodeData.TenantId;
        }
    }
}
