<#
This example removes an Azure PIM role eligibility schedule.
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
        AzureRoleEligibilityScheduleRequest "RemoveEligibility"
        {
            Principal             = "AdeleV@contoso.onmicrosoft.com"
            RoleDefinition        = "Owner"
            DirectoryScopeId      = "/subscriptions/12345678-1234-1234-1234-123456789012"
            PrincipalType         = "User"
            Ensure                = "Absent"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
