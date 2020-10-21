<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADPolicy DSCPolicy1
        {
            DisplayName                   = "PolicyDisplayName"
            AlternativeIdentifier         = ""
            Definition                    = "{{"B2BManagementPolicy":{"InvitationsAllowedAndBlockedDomainsPolicy":{"BlockedDomains":[]},"PreviewPolicy":{"Features":["OneTimePasscode"]},"AutoRedeemPolicy":{"AdminConsentedForUsersIntoTenantIds":[],"NoAADConsentForUsersFromTenantsIds":[]}}}}"
            IsOrganizationDefault         = $false
            KeyCredentials                = {}
            Type                          = "TokenIssuancePolicy"
            Ensure                        = "Present"
            GlobalAdminAccount            = $credsGlobalAdmin
        }
    }
}
