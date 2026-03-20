<#
This example creates a new Azure PIM role assignment schedule at subscription level.
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
        AzureRoleAssignmentScheduleRequest "SubscriptionOwnerAssignment"
        {
            Principal             = "AdeleV@contoso.onmicrosoft.com"
            RoleDefinition        = "Owner"
            DirectoryScopeId      = "/subscriptions/12345678-1234-1234-1234-123456789012"
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
