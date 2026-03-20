<#
This example creates an Azure PIM role assignment schedule at management group level.
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
        AzureRoleAssignmentScheduleRequest "ManagementGroupReaderAssignment"
        {
            Principal             = "AdeleV@contoso.onmicrosoft.com"
            RoleDefinition        = "Reader"
            DirectoryScopeId      = "/providers/Microsoft.Management/managementGroups/MyManagementGroup"
            PrincipalType         = "User"
            Ensure                = "Present"
            ScheduleInfo          = MSFT_AzureRoleAssignmentScheduleRequestSchedule {
                startDateTime = '2024-01-15T08:00:00Z'
                expiration    = MSFT_AzureRoleAssignmentScheduleRequestScheduleExpiration
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
