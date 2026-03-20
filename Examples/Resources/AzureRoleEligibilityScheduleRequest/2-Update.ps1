<#
This example updates an existing Azure PIM role eligibility schedule.
#>

Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credential
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AzureRoleEligibilityScheduleRequest "ResourceGroupContributorEligibility"
        {
            Principal             = "SecurityGroup@contoso.onmicrosoft.com"
            RoleDefinition        = "Contributor"
            DirectoryScopeId      = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rg-production"
            PrincipalType         = "Group"
            Ensure                = "Present"
            ScheduleInfo          = MSFT_AzureRoleEligibilityScheduleRequestSchedule {
                startDateTime = '2024-01-01T00:00:00Z'
                expiration    = MSFT_AzureRoleEligibilityScheduleRequestScheduleExpiration
                {
                    type        = 'noExpiration'
                }
            }
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
