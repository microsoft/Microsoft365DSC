<#
This example configures the Teams Guest Calling Configuration.
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
        TeamsGuestCallingConfiguration 'ConfigureGuestCalling'
        {
            Identity            = "Global"
            AllowPrivateCalling = $True
            Credential          = $Credscredential
        }
    }
}
