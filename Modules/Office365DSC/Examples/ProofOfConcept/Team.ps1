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

                     
        TeamsTeam MyTeams
        {
            DisplayName = "Tech Reads"
            Description = "Technical writers description"
            AccessType = "Private"
            GlobalAdminAccount = $credsGlobalAdmin
        }  

        TeamsFunSettings MyTeamFunSettings
        {
            GroupID = "8512d336-542f-436f-b0c3-b174a6ac7f32"
            AllowGiphy = $true
            GiphyContentRating = "Moderate"
            AllowStickersAndMemes = $true 
            AllowCustomMemes = $true
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
