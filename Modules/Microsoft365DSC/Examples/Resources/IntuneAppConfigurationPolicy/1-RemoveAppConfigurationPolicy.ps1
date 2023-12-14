<#
This example removes an existing App Configuration Policy.
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
        IntuneAppConfigurationPolicy 'RemoveAppConfigPolicy'
        {
            DisplayName = 'ContosoOld'
            Description = 'Old Contoso Policy'
            Ensure      = 'Absent'
            Credential  = $Credscredential
        }
    }
}
