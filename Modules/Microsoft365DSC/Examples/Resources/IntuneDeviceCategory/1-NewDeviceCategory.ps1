<#
This example creates a new Device Category.
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
        IntuneDeviceCategory 'ConfigureDeviceCategory'
        {
            DisplayName          = "Contoso"
            Description          = "Contoso Category"
            Ensure               = "Present"
            Credential           = $credsGlobalAdmin
        }
    }
}
