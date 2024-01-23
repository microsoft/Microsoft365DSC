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
        EXODkimSigningConfig 'ConfigureDKIMSigning'
        {
            KeySize                = 1024
            Identity               = 'contoso.onmicrosoft.com'
            HeaderCanonicalization = "Relaxed"
            Enabled                = $False # Updated Property
            BodyCanonicalization   = "Relaxed"
            AdminDisplayName       = ""
            Ensure                 = "Present"
            Credential             = $Credscredential
        }
    }
}
