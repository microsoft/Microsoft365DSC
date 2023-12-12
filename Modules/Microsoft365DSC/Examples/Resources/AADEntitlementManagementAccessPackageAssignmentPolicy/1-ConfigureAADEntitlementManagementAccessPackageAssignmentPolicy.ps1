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
        AADEntitlementManagementAccessPackageAssignmentPolicy "myAssignmentPolicyWithAccessReviewsSettings"
        {
            AccessPackageId         = "5d05114c-b4d9-4ae7-bda6-4bade48e60f2";
            AccessReviewSettings    = MSFT_MicrosoftGraphassignmentreviewsettings{
                IsEnabled = $True
                StartDateTime = '12/17/2022 23:59:59'
                IsAccessRecommendationEnabled = $True
                AccessReviewTimeoutBehavior = 'keepAccess'
                IsApprovalJustificationRequired = $True
                ReviewerType = 'Self'
                RecurrenceType = 'quarterly'
                Reviewers = @()
                DurationInDays = 25
            };
            CanExtend               = $False;
            Description             = "";
            DisplayName             = "External tenant";
            DurationInDays          = 365;
            Id                      = "0ae0bc7c-bae7-4e3b-9ed3-216b767efbb3";
            RequestApprovalSettings = MSFT_MicrosoftGraphapprovalsettings{
                ApprovalMode = 'NoApproval'
                IsRequestorJustificationRequired = $False
                IsApprovalRequired = $False
                IsApprovalRequiredForExtension = $False
            };
            RequestorSettings       = MSFT_MicrosoftGraphrequestorsettings{
                AllowedRequestors = @(
                    MSFT_MicrosoftGraphuserset{
                        IsBackup = $False
                        Id = 'e27eb9b9-27c3-462d-8d65-3bcd763b0ed0'
                        odataType = '#microsoft.graph.connectedOrganizationMembers'
                    }
                )
                AcceptRequests = $True
                ScopeType = 'SpecificConnectedOrganizationSubjects'
            };
            Ensure                     = "Present"
            Credential                 = $Credscredential
        }
    }
}
