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
            GroupID               = "6c1d4863-d0c0-402d-b169-ead1bb6a2f59"
            AllowGiphy            = $True
            GiphyContentRating    = "Strict"
            AllowStickersAndMemes = $True
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
