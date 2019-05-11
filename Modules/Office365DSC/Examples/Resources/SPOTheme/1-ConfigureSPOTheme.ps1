<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
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
        SPOTheme MySPOTheme
        {
            GlobalAdminAccount = $credsGlobalAdmin
            CentralAdminUrl    = "https://o365spoapp-admin.sharepoint.com"
            Name               = "PSTheme1"
            IsInverted         = $false
            Palette            = '{
                "themePrimary": "#0078d4",
                "themeLighterAlt": "#eff6fc",
                "themeLighter": "#deecf9",
                "themeLight": "#c7e0f4",
                "themeTertiary": "#71afe5",
                "themeSecondary": "#2b88d8",
                "themeDarkAlt": "#106ebe",
                "themeDark": "#005a9e",
                "themeDarker": "#004578",
                "neutralLighterAlt": "#f8f8f8",
                "neutralLighter": "#f4f4f4",
                "neutralLight": "#eaeaea",
                "neutralQuaternaryAlt": "#dadada",
                "neutralQuaternary": "#d0d0d0",
                "neutralTertiaryAlt": "#c8c8c8",
                "neutralTertiary": "#c2c2c2",
                "neutralSecondary": "#858585",
                "neutralPrimaryAlt": "#4b4b4b",
                "neutralPrimary": "#333",
                "neutralDark": "#272727",
                "black": "#1d1d1d",
                "white": "#fff",
                "bodyBackground": "#0078d4",
                "bodyText": "#fff"
              }'
            Ensure             = "Present"
        }
    }
}
