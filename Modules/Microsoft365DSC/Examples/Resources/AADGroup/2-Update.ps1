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
            Description      = "Microsoft DSC Group Updated" # Updated Property
            SecurityEnabled  = $True
            MailEnabled      = $True
            GroupTypes       = @("Unified")
            MailNickname     = "M365DSC"
            Members          = @("AdeleV@$TenantId")
            GroupAsMembers   = @("Group1")
            Visibility       = "Private"
            Owners           = @("admin@$TenantId", "AdeleV@$TenantId")
            AssignedLicenses = @(
                MSFT_AADGroupLicense {
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
