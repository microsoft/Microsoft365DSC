<# This example is used to test new resources and showcase the usage of new resources being worked on. It is not meant to use as a production baseline. #>
Configuration Example {
    param(
        [Parameter()]
        [System.String] $ApplicationId,

        [Parameter()]
        [System.String] $TenantId,

        [Parameter()]
        [System.String] $CertificateThumbprint
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost {
        IntuneDerivedCredential "IntuneDerivedCredential-DataManagement" {
            Id                  = "a1fc9fe2-728d-4867-9a72-a61e18f8c606"
            DisplayName         = "Custom Data Management"
            Ensure              = "Present"
            HelpUrl             = "https://www.microsoft.com"
            Issuer              = "DISA Purebred"
            NotificationType    = "Email"
            ThresholdPercentage = 0
            Header              = @(
                [PSCustomObject]@{ Key = 'HeaderKey1'; Value = 'HeaderValue1' }
                [PSCustomObject]@{ Key = 'HeaderKey2'; Value = 'HeaderValue2' }
            )
        }
    }
}
