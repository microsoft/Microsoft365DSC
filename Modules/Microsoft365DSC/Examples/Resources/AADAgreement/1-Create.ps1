<#
This example creates a new Terms of Use Agreement in Azure Active Directory.
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
        AADAgreement "CompanyTermsOfUse"
        {
            Id                               = "12345-12345-12345-12345-12345"
            DisplayName                      = "Company Terms of Service"
            IsPerDeviceAcceptanceRequired    = $true
            IsViewingBeforeAcceptanceRequired = $true
            UserReacceptRequiredFrequency    = "P30D"
            Ensure                           = "Present"
            ApplicationId                    = $ApplicationId
            TenantId                         = $TenantId
            CertificateThumbprint            = $CertificateThumbprint
        }
    }
}