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
            Action               = "AdminAssign";
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            DirectoryScopeId     = "/";
            Ensure               = "Absent";
            IsValidationOnly     = $True; # Updated Property
            Principal            = "AdeleV@$TenantId";
            RoleDefinition       = "Teams Communications Administrator";
            ScheduleInfo         = MSFT_AADRoleEligibilityScheduleRequestSchedule {
                startDateTime             = '2023-09-01T02:40:44Z'
                expiration                = MSFT_AADRoleEligibilityScheduleRequestScheduleExpiration
                    {
                        endDateTime = '2025-10-31T02:40:09Z'
                        type        = 'afterDateTime'
                    }
            };
        }
    }
}
