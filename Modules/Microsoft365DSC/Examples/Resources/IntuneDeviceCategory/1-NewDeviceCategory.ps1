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
        IntuneDeviceCategory Demo
        {
            DisplayName          = "Contoso"
            Description          = "Contoso Category"
            Ensure               = "Present"
            GlobalAdminAccount   = $credsGlobalAdmin;
        }
    }
}
