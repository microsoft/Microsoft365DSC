<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADRoleEligibilityScheduleRequest "MyRequest"
        {
            Action               = "AdminUpdate";
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            DirectoryScopeId     = "/";
            Ensure               = "Present";
            IsValidationOnly     = $False;
            Principal            = "AdeleV@$TenantId";
            RoleDefinition       = "Teams Communications Administrator";
            ScheduleInfo         = MSFT_AADRoleEligibilityScheduleRequestSchedule {
                startDateTime             = '2023-09-01T02:45:44Z' # Updated Property
                expiration                = MSFT_AADRoleEligibilityScheduleRequestScheduleExpiration
                    {
                        endDateTime = '2025-10-31T02:40:09Z'
                        type        = 'afterDateTime'
                    }
            };
        }
    }
}
