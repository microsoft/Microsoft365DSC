<#
This example removes an existing App Configuration Policy.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneAppConfigurationPolicy DemoRemoveAppConfigPolicy
        {
            DisplayName          = 'Contoso'
            Description          = 'Contoso Category'
            Ensure               = 'Absent'
            GlobalAdminAccount   = $credsGlobalAdmin;
        }
    }
}
