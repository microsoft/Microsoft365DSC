<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration MSFT_TeamsUser
{
    Import-DSCResource -ModuleName Office365DSC
    $credsGlobalAdmin = Get-Credential -UserName "TenantAdmin@O365DSC1.onmicrosoft.com" -Message "Global Admin"
    Node localhost
    {
        TeamsUser MyTeam
        {
            GroupID            = "6c1d4863-d0c0-402d-b169-ead1bb6a2f59"
            User               = "jdoe@dsazure.com"
            Role               = "Member"
            Ensure             = "Absent"
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
            DebugMode                   = $true;
        }
    )
}


MSFT_TeamsUser -ConfigurationData $configData
