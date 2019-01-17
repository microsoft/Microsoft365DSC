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
        <#
        TeamsTeam MyTeam
        {
            #GroupId = "85beae77-0ba7-4af9-833c-4d5211a75a4a"
            DisplayName = "MyTeam"
            Description = "My new team"
            AccessType = "Private"
            Alias = "Myteam"
            GlobalAdminAccount = $credsGlobalAdmin
            Ensure = "Present"
        }              
        
        #>
        <#
        TeamsUser MyTeam {
            GroupID            = "f2d2365d-5e77-49c0-99fa-7c468cce021a"
            User               = "jdoe@dsazure.com"
            Role               = "Member"
            Ensure             = "Present"
            GlobalAdminAccount = $credsGlobalAdmin
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
        #>
        TeamsChannel MyChannel
        {
            GroupID = "f2d2365d-5e77-49c0-99fa-7c468cce021a"
            DisplayName = "PHP Code Review"
            #NewDisplayName = "Channel set from DSC"
            Description = "PHP Code reviews for SPFX"
            Ensure = "Present"
            GlobalAdminAccount = $credsGlobalAdmin
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

Teams -ConfigurationData $configData
