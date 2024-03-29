<#
This example adds a new Teams Voice Route.
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
        TeamsVoiceRoute 'ConfigureVoiceRoute'
        {
            Identity              = 'NewVoiceRoute'
            Description           = 'This is a sample Voice Route'
            NumberPattern         = '^\+1(425|206)(\d{7})'
            OnlinePstnGatewayList = @('sbc1.litwareinc.com', 'sbc2.litwareinc.com')
            OnlinePstnUsages      = @('Long Distance', 'Local', 'Internal')
            Priority              = 10
            Ensure                = 'Present'
            Credential            = $Credscredential
        }
    }
}
