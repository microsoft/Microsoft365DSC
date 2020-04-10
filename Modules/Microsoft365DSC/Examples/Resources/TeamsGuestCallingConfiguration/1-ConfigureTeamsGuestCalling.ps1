<#
This example configures the Teams Guest Calling Configuration.
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
        TeamsGuestCallingConfiguration GuestCallingConfig
        {
            Identity            = "Global";
            AllowPrivateCalling = $True;
            GlobalAdminAccount  = $credsGlobalAdmin;
        }
    }
}
