<#
This example creates an Azure PIM role eligibility schedule at management group level.
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
        AzureRoleEligibilityScheduleRequest "ManagementGroupReaderEligibility"
        {
            Principal             = "AdeleV@contoso.onmicrosoft.com"
            RoleDefinition        = "Reader"
            DirectoryScopeId      = "/providers/Microsoft.Management/managementGroups/MyManagementGroup"
            PrincipalType         = "User"
            Ensure                = "Present"
            ScheduleInfo          = MSFT_AzureRoleEligibilityScheduleRequestSchedule {
                startDateTime = '2024-01-15T08:00:00Z'
                expiration    = MSFT_AzureRoleEligibilityScheduleRequestScheduleExpiration
                {
                    type        = 'afterDateTime'
                    endDateTime = '2025-12-31T23:59:59Z'
                }
            }
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
