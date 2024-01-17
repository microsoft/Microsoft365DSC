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
        AADTokenLifetimePolicy 'CreateTokenLifetimePolicy'
        {
            DisplayName           = "PolicyDisplayName"
            Definition            = @("{`"TokenLifetimePolicy`":{`"Version`":1,`"AccessTokenLifetime`":`"02:00:00`"}}");
            IsOrganizationDefault = $false
            Ensure                = "Present"
            Credential            = $Credscredential
        }
    }
}
