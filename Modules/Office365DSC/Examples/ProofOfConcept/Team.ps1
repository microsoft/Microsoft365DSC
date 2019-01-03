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

                   
        TeamsRemoveTeam MyTeams
        {
            GroupID = "f690f19c-99eb-4cad-a728-61558569742b"
            GlobalAdminAccount = $credsGlobalAdmin
            Ensure = "Absent"
        }  
        #>
        <# 
        TeamsFunSettings MyTeamFunSettings
        {
            GroupID = "8512d336-542f-436f-b0c3-b174a6ac7f32"
            AllowGiphy = $true
            GiphyContentRating = "Moderate"
            AllowStickersAndMemes = $true 
            AllowCustomMemes = $true
            GlobalAdminAccount = $credsGlobalAdmin
        }  
        
        TeamsChannel MyChannel
        {
            GroupID = "f2d2365d-5e77-49c0-99fa-7c468cce021a"
            CurrentDisplayName = "TestChannel"
            NewDisplayName = "Channel set from DSC"
            Description = "Description set from DSC"
            GlobalAdminAccount = $credsGlobalAdmin
        }
        #>
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
