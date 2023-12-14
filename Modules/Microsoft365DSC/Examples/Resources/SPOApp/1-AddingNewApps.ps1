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
        SPOApp 'ConfigureDemoApp'
        {
            Identity   = "DemoApp"
            Path       = "C:\Demo\DemoApp.sppkg"
            Publish    = $true
            Ensure     = "Present"
            Credential = $Credscredential
        }

        SPOApp 'ConfigureDemoApp2'
        {
            Identity   = "DemoApp2"
            Path       = "C:\Demo\DemoApp2.app"
            Publish    = $true
            Ensure     = "Present"
            Credential = $Credscredential
        }
    }
}
