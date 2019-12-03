<#
This example adds a new Teams Calling Policy.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Office365DSC

    node localhost
    {
        TeamsCallingPolicy CallingPolicy
        {
            Identity                   = 'New Calling Policy'
            AllowCalling               = $true
            AllowPrivateCalling        = $false
            AllowVoicemail             = 'UserOverride'
            AllowCallGroups            = $true
            AllowDelegation            = $true
            AllowCallForwardingToUser  = $false
            AllowCallForwardingToPhone = $true
            PreventTollBypass          = $true
            BusyOnBusyEnabledType      = 'Enabled'
            Ensure                     = 'Present'
            GlobalAdminAccount         = $credsGlobalAdmin
        }
    }
}
