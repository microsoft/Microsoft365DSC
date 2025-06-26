<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
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
        AADAgreement 'CompanyTermsOfUse'
        {
            DisplayName                          = "Company Terms of Use"
            IsPerDeviceAcceptanceRequired        = $false
            IsViewingBeforeAcceptanceRequired    = $true
            UserReacceptRequiredFrequency        = "P90D"
            Files                                = @(
                MSFT_MicrosoftGraphAgreementFileLocalization {
                    DisplayName = "Company Terms of Use"
                    FileName = "terms-of-use.pdf"
                    Language = "en-US"
                    IsDefault = $true
                    IsMajorVersion = $true
                    FileData = "Base64EncodedPDFContent"
                }
            )
            Ensure                               = "Present"
            ApplicationId                        = $ApplicationId
            TenantId                             = $TenantId
            CertificateThumbprint                = $CertificateThumbprint
        }
    }
}