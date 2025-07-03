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
        AADAgreement 'ConfigureAgreement'
        {
            Id                     = "12345678-1234-1234-1234-123456789012"
            DisplayName            = "Sample Terms of Use Agreement"
            IsDefault              = $false
            IsViewingBeforeAcceptanceRequired = $true
            TermsExpiration        = (Get-Date).AddYears(1)
            Ensure                 = "Present"
            ApplicationId          = $ApplicationId
            TenantId               = $TenantId
            CertificateThumbprint  = $CertificateThumbprint
        }
    }
}