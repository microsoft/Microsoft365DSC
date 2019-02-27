<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration TeamsMessageSettingsConfig
{
    Import-DSCResource -ModuleName Office365DSC
    $credsGlobalAdmin = Get-Credential -UserName "derek@smaystate.onmicrosoft.com" -Message "Global Admin"
    Node localhost
    {
        TeamsMessageSettings MyTeamMessageSettings
        {
            TeamName                 = "Sample3"
            AllowUserEditMessages    = $false
            AllowUserDeleteMessages  = $false
            AllowOwnerDeleteMessages = $false
            AllowTeamMentions        = $false
            AllowChannelMentions     = $false
            Ensure                   = "Present"
            GlobalAdminAccount       = $credsGlobalAdmin
        }
    }
}

$configData = @{
    AllNodes = @(
        @{
            NodeName                    = "localhost"
            PSDscAllowPlainTextPassword = $true
            PSDscAllowDomainUser        = $true
        }
    )
}

TeamsMessageSettingsConfig -ConfigurationData $configData
