<#
This example adds a new Teams Calling Policy.
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
        TeamsCallingPolicy 'ConfigureCallingPolicy'
        {
            Identity                   = 'New Calling Policy'
            AllowPrivateCalling        = $false
            AllowVoicemail             = 'UserOverride'
            AllowCallGroups            = $true
            AllowDelegation            = $true
            AllowCallForwardingToUser  = $false
            AllowCallForwardingToPhone = $true
            PreventTollBypass          = $true
            BusyOnBusyEnabledType      = 'Enabled'
            Ensure                     = 'Present'
            Credential                 = $Credscredential
        }
    }
}
