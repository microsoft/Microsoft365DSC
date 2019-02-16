<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration MSFT_TeamsFunSettings
{
    Import-DSCResource -ModuleName Office365DSC
    $credsGlobalAdmin = Get-Credential -UserName "TenantAdmin@O365DSC1.onmicrosoft.com" -Message "Global Admin"
    Node localhost
    {
        TeamsFunSettings MyTeamFunSettings
        {
            GroupID               = "f51a3df3-14af-4f52-b22b-30be60ca3fc4"
            AllowGiphy            = $True
            GiphyContentRating    = "strict"
            AllowStickersAndMemes = $False
            AllowCustomMemes      = $False
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
            DebugMode                   = $true;
        }
    )
}


MSFT_TeamsFunSettings -ConfigurationData $configData
