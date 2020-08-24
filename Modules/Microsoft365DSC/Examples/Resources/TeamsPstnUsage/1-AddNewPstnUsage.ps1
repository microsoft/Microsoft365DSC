<#
This example adds a new Teams PSTN Usage.
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
        TeamsPstnUsage PstnUsage
        {
            Usage              = 'Long Distance'
            Ensure             = 'Present'
            GlobalAdminAccount = $credsGlobalAdmin
        }
    }
}
