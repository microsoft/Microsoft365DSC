<#
.EXAMPLE
    This example shows how to deploy Access Services 2013 to the local SharePoint farm.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Office365DSC

    node localhost {
        EXOMailboxSettings OttawaTeam
        {
            DisplayName        = "Ottawa Employees"
            TimeZone           = "Eastern Standard Time"
            Locale             = "fr-CA"
            Ensure             = "Present"
            GlobalAdminAccount = $credsGlobalAdmin
        }
    }
}
