<#
This example configures the Teams Guest Calling Configuration.
#>

Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        TeamsTenantDialPlan 'ConfigureTenantDialPlan'
        {
            Identity              = 'DemoPlan'
            Description           = 'This is a demo dial plan'
            NormalizationRules    = @(
                MSFT_TeamsVoiceNormalizationRule
                {
                    Pattern             = '^00(\d+)$'
                    Description         = 'LB International Dialing Rule'
                    Identity            = 'LB Intl Dialing'
                    Translation         = '+$1'
                    Priority            = 0
                    IsInternalExtension = $False
                }
            )
            OptimizeDeviceDialing = $true
            SimpleName            = 'DemoPlan'
            Ensure                = 'Present'
            Credential            = $Credscredential
        }
    }
}
