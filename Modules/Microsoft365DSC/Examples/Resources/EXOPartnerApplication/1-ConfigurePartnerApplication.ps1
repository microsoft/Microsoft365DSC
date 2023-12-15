<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOPartnerApplication 'ConfigurePartnerApplication'
        {
            Name                                = "HRApp"
            ApplicationIdentifier               = "00000006-0000-0dd1-ac00-000000000000"
            AccountType                         = "OrganizationalAccount"
            Enabled                             = $True
            Ensure                              = "Present"
            Credential                          = $Credscredential
        }
    }
}
