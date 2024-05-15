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
        SPOHomeSite 'SetMarketingSiteCollectionAsHomeSite'
        {
            IsSingleInstance = "Yes"
            Url              = "https://contoso.sharepoint.com/sites/Marketing"
            Ensure           = "Present"
            Credential       = $Credscredential
        }
    }
}
