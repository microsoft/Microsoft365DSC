<#
This example creates a new App Configuration Policy.
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
        IntuneAppConfigurationPolicy 'AddAppConfigPolicy'
        {
            DisplayName = 'ContosoNew'
            Description = 'New Contoso Policy'
            Ensure      = 'Present'
            Credential  = $Credscredential
        }
    }
}
