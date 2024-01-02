<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example {
    param(
        [System.Management.Automation.PSCredential]
        $credsCredential
    )

    Import-DscResource -ModuleName Microsoft365DSC

    Node Localhost
    {
        AADTenantDetails 'ÇonfigureTenantDetails'
        {
            IsSingleInstance                     = 'Yes'
            TechnicalNotificationMails           = "example@contoso.com"
            SecurityComplianceNotificationPhones = "+1123456789"
            SecurityComplianceNotificationMails  = "example@contoso.com"
            MarketingNotificationEmails          = "example@contoso.com"
            Credential                           = $credsCredential
        }
    }
}
