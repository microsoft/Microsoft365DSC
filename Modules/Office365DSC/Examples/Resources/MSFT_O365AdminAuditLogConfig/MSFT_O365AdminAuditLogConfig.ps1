<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration AuditLogConfig
{
    Import-DSCResource -ModuleName Office365DSC
    $credsGlobalAdmin = Get-Credential -UserName "TenantAdmin@O365DSC1.onmicrosoft.com" -Message "Global Admin"
    Node localhost
    {
        O365AdminAuditLogConfig Settings
        {
            IsSingleInstance                = "Yes"
            UnifiedAuditLogIngestionEnabled = $true
            Ensure                          = "Present"
            GlobalAdminAccount              = $credsGlobalAdmin
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

O365AdminAuditLogConfig -ConfigurationData $configData
