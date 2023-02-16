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
        TeamsTenantNetworkSubnet 'Example'
        {
            Credential           = $Credscredential
            Description          = "Nik Test";
            Ensure               = "Present";
            Identity             = "192.168.0.0";
            MaskBits             = 24;
            NetworkSiteID        = "Nik";
        }
    }
}
