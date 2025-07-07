<#
This example creates a new Azure AD Terms of Use Agreement.
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
            IsViewingBeforeAcceptanceRequired    = $true
            IsPerDeviceAcceptanceRequired        = $false
            UserReacceptRequiredFrequency        = "P90D"
            AcceptanceStatement                  = "I accept the terms of use"
            FileData                             = "<h1>Company Terms of Use</h1><p>These are the terms and conditions for using our company resources...</p>"
            FileName                             = "CompanyToU.html"
            Language                             = "en-US"
            Ensure                               = "Present"
            ApplicationId                    = $ApplicationId
            TenantId                         = $TenantId
            CertificateThumbprint            = $CertificateThumbprint
        }
    }
}