<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Teams
{
    Import-DSCResource -ModuleName Office365DSC
    $credsGlobalAdmin = Get-Credential -UserName "TenantAdmin@O365DSC1.onmicrosoft.com" -Message "Global Admin"
    Node localhost
    {
        TeamsTeam MyTeam
        {
            DisplayName = "Sample3"
            Description = "Sample"
            AccessType = "Private"
            Alias = "DSCTeam2"
            GlobalAdminAccount = $credsGlobalAdmin
            Ensure = "Present"
        }
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
