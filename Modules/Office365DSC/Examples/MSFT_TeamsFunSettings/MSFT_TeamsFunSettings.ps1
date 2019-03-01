<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration TeamsFunSettingsConfig
{
    Import-DSCResource -ModuleName Office365DSC
    $credsGlobalAdmin = Get-Credential -UserName "TenantAdmin@O365DSC1.onmicrosoft.com" -Message "Global Admin"
    Node localhost
    {
        TeamsFunSettings MyTeamFunSettings
        {
            TeamName              = "Sample3"
            AllowGiphy            = $True
            GiphyContentRating    = "strict"
            AllowStickersAndMemes = $True
            AllowCustomMemes      = $True
            GlobalAdminAccount    = $credsGlobalAdmin
        }
    }
}

$configData = @{
    AllNodes = @(
        @{
            NodeName                    = "localhost"
            PSDscAllowPlainTextPassword = $true;
            PSDscAllowDomainUser        = $true;
        }
    )
}

TeamsFunSettingsConfig -ConfigurationData $configData
