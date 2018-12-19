<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Teams
{
    Import-DSCResource -ModuleName Office365DSC
    $credsGlobalAdmin = Get-Credential -UserName "derek@smaystate.onmicrosoft.com" -Message "Global Admin"
    Node localhost
    {
        TeamsFunSettings MyTeams
        {
            GroupID = "f2d2365d-5e77-49c0-99fa-7c468cce021a"
            AllowGiphy = $true
            AllowStickersAndMemes = $false
            AllowCustomMemes = $false
            GiphyContentRating = "Strict"
            GlobalAdminAccount = $credsGlobalAdmin
        }  
    }
}

$configData = @{
    AllNodes = @(
        @{
            NodeName = "localhost"
            PSDscAllowPlainTextPassword = $true;
            PSDscAllowDomainUser = $true;
    }
    )
}

Teams -ConfigurationData $configData
