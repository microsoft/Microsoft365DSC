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
        SPOUserProfileProperty 'ConfigureUserProfileProperty'
        {
            UserName   = "John.Smith@contoso.com"
            Properties = @(
                MSFT_SPOUserProfilePropertyInstance
                {
                    Key   = "MyProperty"
                    Value = "MyValue"
                }
            )
            Ensure     = "Present"
            Credential = $Credscredential
        }
    }
}
