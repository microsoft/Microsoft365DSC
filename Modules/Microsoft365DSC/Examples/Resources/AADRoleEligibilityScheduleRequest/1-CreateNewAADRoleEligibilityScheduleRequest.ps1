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
        $credsGlobalAdmin
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADRoleEligibilityScheduleRequest "MyRequest"
        {
            Action               = "AdminAssign";
            Credential           = $credsGlobalAdmin;
            DirectoryScopeId     = "/";
            Ensure               = "Present";
            IsValidationOnly     = $False;
            Principal            = "John.Smith@$OrganizationName";
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
