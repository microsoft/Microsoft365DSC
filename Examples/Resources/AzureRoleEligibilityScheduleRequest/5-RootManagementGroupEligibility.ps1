<#
This example creates an Azure PIM role eligibility schedule at the root management group level.
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
        AzureRoleEligibilityScheduleRequest "RootManagementGroupOwnerEligibility"
        {
            Principal             = "AdeleV@contoso.onmicrosoft.com"
            RoleDefinition        = "Owner"
            DirectoryScopeId      = "/providers/Microsoft.Management/managementGroups/rootGroup"
            PrincipalType         = "User"
            Ensure                = "Present"
            ScheduleInfo          = MSFT_AzureRoleEligibilityScheduleRequestSchedule {
                startDateTime = '2024-01-15T08:00:00Z'
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
