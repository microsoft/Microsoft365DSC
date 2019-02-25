<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration TeamsMemberSettingsConfig
{
    Import-DSCResource -ModuleName Office365DSC
    $credsGlobalAdmin = Get-Credential -UserName "derek@smaystate.onmicrosoft.com" -Message "Global Admin"
    Node localhost
    {
        TeamsMemberSettings MyTeamMemberSettings
        {
            TeamName                          = "Sample3"
            AllowCreateUpdateChannels         = $False
            AllowDeleteChannels               = $False
            AllowAddRemoveApps                = $False
            AllowCreateUpdateRemoveTabs       = $False
            AllowCreateUpdateRemoveConnectors = $False
            Ensure                            = "Present"
            GlobalAdminAccount                = $credsGlobalAdmin
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

TeamsMemberSettingsConfig -ConfigurationData $configData
