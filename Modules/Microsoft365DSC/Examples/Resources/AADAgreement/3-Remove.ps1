<#
This example removes an existing Terms of Use Agreement from Azure Active Directory.
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
            Ensure                           = "Absent"
            ApplicationId                    = $ApplicationId
            TenantId                         = $TenantId
            CertificateThumbprint            = $CertificateThumbprint
        }
    }
}