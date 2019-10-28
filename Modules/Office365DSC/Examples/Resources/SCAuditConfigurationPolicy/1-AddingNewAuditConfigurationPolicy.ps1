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
    Import-DscResource -ModuleName Office365DSC

    node localhost
    {
        SCAuditConfigurationPolicy ExchangeAuditPolicy
        {
            Workload           = "Exchange"
            Ensure             = "Present"
            GlobalAdminAccount = $credsGlobalAdmin
        }

        SCAuditConfigurationPolicy SharePointAuditPolicy
        {
            Workload           = "OneDriveForBusiness"
            Ensure             = "Present"
            GlobalAdminAccount = $credsGlobalAdmin
        }

        SCAuditConfigurationPolicy SharePointAuditPolicy
        {
            Workload           = "SharePoint"
            Ensure             = "Present"
            GlobalAdminAccount = $credsGlobalAdmin
        }
    }
}
