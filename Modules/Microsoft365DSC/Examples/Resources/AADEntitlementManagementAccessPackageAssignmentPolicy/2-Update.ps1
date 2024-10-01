<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADEntitlementManagementAccessPackageAssignmentPolicy "myAssignments"
        {
            AccessPackageId         = "Integration Package";
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
            DurationInDays          = 180; # Updated Property
            RequestApprovalSettings = MSFT_MicrosoftGraphapprovalsettings{
                ApprovalMode = 'NoApproval'
                IsRequestorJustificationRequired = $False
                IsApprovalRequired = $False
                IsApprovalRequiredForExtension = $False
            };
            Ensure                     = "Present"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
