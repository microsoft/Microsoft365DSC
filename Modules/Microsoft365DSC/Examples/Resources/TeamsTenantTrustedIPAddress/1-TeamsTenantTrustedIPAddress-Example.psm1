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
        TeamsTenantTrustedIPAddress 'Example'
        {
            Credential           = $Credscredential;
            Ensure               = "Present";
            Identity             = "10.2.34.3";
            MaskBits             = 32;
        }
    }
}
