<#
This example updates an existing Terms of Use Agreement in Azure Active Directory.
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
            DisplayName                      = "Company Terms of Service - Updated"
            IsPerDeviceAcceptanceRequired    = $false
            IsViewingBeforeAcceptanceRequired = $false
            UserReacceptRequiredFrequency    = "P90D"
            Ensure                           = "Present"
            ApplicationId                    = $ApplicationId
            TenantId                         = $TenantId
            CertificateThumbprint            = $CertificateThumbprint
        }
    }
}