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
        O365Group OttawaTeam
        {
            DisplayName        = "Ottawa Employees"
            Description        = "This is only for employees of the Ottawa Office"
            GroupType          = "Office365"
            ManagedBy          = "TenantAdmin@O365DSC1.onmicrosoft.com"
            Members            = @("Bob.Houle", "John.Smith")
            Ensure             = "Present"
            GlobalAdminAccount = $credsGlobalAdmin
        }
    }
}
