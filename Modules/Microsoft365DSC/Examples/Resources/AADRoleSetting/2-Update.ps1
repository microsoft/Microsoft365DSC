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
            ActivationReqJustification                                = $False; # Updated Property
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
            ApprovaltoActivate                                        = $False;
            AssignmentReqJustification                                = $True;
            AssignmentReqMFA                                          = $False;
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
            PermanentActiveAssignmentisExpirationRequired             = $False;
            PermanentEligibleAssignmentisExpirationRequired           = $False;
            Credential                                                = $Credscredential
            Ensure                                                    = 'Present'
        }
    }
}
