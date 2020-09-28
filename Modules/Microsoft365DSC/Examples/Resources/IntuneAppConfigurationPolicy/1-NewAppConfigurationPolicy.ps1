<#
This example creates a new App Configuration Policy.
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
        IntuneAppConfigurationPolicy AddRemoveAppConfigPolicy
        {
            DisplayName          = 'Contoso'
            Description          = 'Contoso Policy'
            Ensure               = 'Present'
            GlobalAdminAccount   = $credsGlobalAdmin;
        }
    }
}
