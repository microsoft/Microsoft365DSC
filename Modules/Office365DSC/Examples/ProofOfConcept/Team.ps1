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

        TeamsTeam MyTeam
        {
            GroupId = "9f881e8c-ab37-4534-859e-dcf267de1475"
            DisplayName = "Tech Reads"
            #Description = "Updated by dsc again"
            AccessType = "Private"
            #Alias = "CreatedByDSC3"
            GlobalAdminAccount = $credsGlobalAdmin
            Ensure = "Present"
        }              
        
    
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
