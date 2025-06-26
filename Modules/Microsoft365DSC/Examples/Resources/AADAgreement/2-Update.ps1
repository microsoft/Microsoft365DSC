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
            IsPerDeviceAcceptanceRequired        = $true # Updated Property
            IsViewingBeforeAcceptanceRequired    = $true
            UserReacceptRequiredFrequency        = "P180D" # Updated Property
            TermsExpiration                      = MSFT_MicrosoftGraphTermsExpiration {
                StartDateTime = "2024-12-31T23:59:59Z"
                Frequency     = "P365D"
            }
            Files                                = @(
                MSFT_MicrosoftGraphAgreementFileLocalization {
                    DisplayName = "Company Terms of Use v2"
                    FileName = "terms-of-use-v2.pdf"
                    Language = "en-US"
                    IsDefault = $true
                    IsMajorVersion = $true
                    FileData = "Base64EncodedPDFContentV2"
                }
            )
            Ensure                               = "Present"
            ApplicationId                        = $ApplicationId
            TenantId                             = $TenantId
            CertificateThumbprint                = $CertificateThumbprint
        }
    }
}