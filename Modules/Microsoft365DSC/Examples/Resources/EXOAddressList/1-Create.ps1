<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOAddressList 'HRUsersAddressList'
        {
            Name                       = "HR Users"
            ConditionalCompany         = "Contoso"
            ConditionalDepartment      = "HR"
            ConditionalStateOrProvince = "US"
            IncludedRecipients         = "AllRecipients"
            Ensure                     = "Present"
            Credential                 = $Credscredential
        }
    }
}