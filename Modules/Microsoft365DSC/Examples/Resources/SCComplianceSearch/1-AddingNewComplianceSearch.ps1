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
        SCComplianceSearch 'ConfigureComplianceSearch'
        {
            Case                                  = "Demo Search"
            HoldNames                             = @()
            Name                                  = "Demo Compliance Search"
            Language                              = "iv"
            AllowNotFoundExchangeLocationsEnabled = $False
            SharePointLocation                    = @("All")
            Credential                            = $Credscredential
            Ensure                                = "Present"
        }
    }
}
