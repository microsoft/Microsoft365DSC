<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
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
        SPOTheme 'ConfigureSharePointTheme'
        {
            Name       = "PSTheme1"
            IsInverted = $false
            Palette    = @(
                MSFT_SPOThemePaletteProperty
                {
                    Property = "themePrimary"
                    Value    = "#0078d4"
                }
                MSFT_SPOThemePaletteProperty
                {
                    Property = "themeLighterAlt"
                    Value    = "#eff6fc"
                }
            )
            Ensure     = "Present"
            Credential = $Credscredential
        }
    }
}
