<#
This example creates a new Device Enrollment Status Page.
#>

Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneDeviceComplianceNotificationMessageTemplate 'IntuneDeviceComplianceNotificationMessageTemplate-Test'
        {
            BrandingOptions               = @("includeCompanyName","includeContactInformation","includeCompanyPortalLink");
            LocalizedNotificationMessages = @(
                MSFT_DeviceManagementNotificationMessageTemplate{
                    MessageTemplate = "Das ist eine Testnachricht für Deutsch."
                    IsDefault = $False # Updated property
                    Subject = "Test Deutsch2"
                    Locale = "de-de"
                }
                MSFT_DeviceManagementNotificationMessageTemplate{
                    MessageTemplate = "This is a message for English (United States)."
                    IsDefault = $True # Updated property
                    Subject = "Test English"
                    Locale = "en-us"
                }
            );
            Description                   = "";
            DisplayName                   = "Test";
            Ensure                        = "Present";
            RoleScopeTagIds               = @("0");
            ApplicationId                 = $ApplicationId;
            TenantId                      = $TenantId;
            CertificateThumbprint         = $CertificateThumbprint;
        }
    }
}
