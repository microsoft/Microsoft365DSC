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
            DisplayName      = "DSCGroup"
            Description      = "Microsoft DSC Group with assigned license" # Updated Property
            SecurityEnabled  = $True
            MailEnabled      = $False
            MailNickname     = "M365DSC"
            AssignedLicenses = @(
                MSFT_AADGroupLicense -Property @{
                    SkuId          = 'AAD_PREMIUM_P2'
                }
            )

            Ensure           = "Present"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
