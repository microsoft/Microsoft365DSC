<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration MailTips
{
    Import-DSCResource -ModuleName Office365DSC
    $credsGlobalAdmin = Get-Credential -UserName "TenantAdmin@O365DSC1.onmicrosoft.com" -Message "Global Admin"
    Node localhost
    {
        EXOMailTips OrgWide
        {
            Organization                          = $Organization
            MailTipsAllTipsEnabled                = $True
            MailTipsGroupMetricsEnabled           = $True
            MailTipsLargeAudienceThreshold        = 100
            MailTipsMailboxSourcedTipsEnabled     = $True
            MailTipsExternalRecipientsTipsEnabled = $True
            GlobalAdminAccount                    = $credsGlobalAdmin
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

MailTips -ConfigurationData $configData
