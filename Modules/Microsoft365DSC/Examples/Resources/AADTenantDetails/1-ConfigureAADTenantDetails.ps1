<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example {
    param(
        [System.Management.Automation.PSCredential]
        $GlobalAdmin
    )

    Import-DscResource -ModuleName Microsoft365DSC

    Node Localhost
    {
        AADTenantDetails TenantDetailsg
        {
            TechnicalNotificationMails             = "exapmle@contoso.com"
            SecurityComplianceNotificationPhones   = "+1123456789"
            SecurityComplianceNotificationMails    = "exapmle@contoso.com"
            MarketingNotificationEmails            = "exapmle@contoso.com"
            GlobalAdminAccount                     = $GlobalAdmin
            IsSingleInstance                       = 'Yes'
        }
    }
}
