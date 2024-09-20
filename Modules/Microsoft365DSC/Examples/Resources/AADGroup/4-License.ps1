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
        AADGroup 'MyGroups'
        {
            DisplayName           = "DSCGroupBasedLicensing"
            Description           = "Microsoft DSC Group with license"
            SecurityEnabled       = $True
            MailNickname          = "M365DSC"
            AssignedLicenses      = @(
                MSFT_AADGroupLicense
                {
                    SkuId         = 'Microsoft 365 E5'
                    DisabledPlans = @('Skype for Business Online (Plan 2)')
                }
            )
            Ensure                = "Present"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
