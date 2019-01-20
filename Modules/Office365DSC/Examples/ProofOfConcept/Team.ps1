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
            GroupId = "f51a3df3-14af-4f52-b22b-30be60ca3fc4"
            DisplayName = "DSC Team"
            Description = "My new team"
            AccessType = "Public"
            Alias = "DSCTeam2"
            GlobalAdminAccount = $credsGlobalAdmin
            Ensure = "Present"
        }        
        
        <#
        TeamsTeam MyTeam
        {
            GroupId = "74424c8f-c776-4a28-9d91-52f884313a18"
            DisplayName = "DSC Team"
            GlobalAdminAccount = $credsGlobalAdmin
            Ensure = "Absent"
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
        <#
        TeamsChannel MyChannel
        {
            GroupID = "f2d2365d-5e77-49c0-99fa-7c468cce021a"
            DisplayName = "SQl2 Review teams group"
            #NewDisplayName = "SQl2 Review teams group"
            Description = "SQL Code reviews for SPFX"
            Ensure = "Absent"
            GlobalAdminAccount = $credsGlobalAdmin
        }
        #>
    }
}

$configData = @{
    AllNodes = @(
        @{
            NodeName                    = "localhost"
            PSDscAllowPlainTextPassword = $true;
            PSDscAllowDomainUser        = $true;
            DebugMode = $true;
        }
    )
}


Teams -ConfigurationData $configData
