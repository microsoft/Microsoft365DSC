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
        AADGroup 'DependantGroup'
        {
            DisplayName     = "MyGroup"
            Description     = "Microsoft DSC Group"
            SecurityEnabled = $True
            MailEnabled     = $True
            GroupTypes      = @("Unified")
            MailNickname    = "MyGroup"
            Visibility      = "Private"
            Owners          = @("admin@$TenantId", "AdeleV@$TenantId")
            Ensure          = "Absent"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
        AADEntitlementManagementAccessPackageCatalogResource 'myAccessPackageCatalogResource'
        {
            DisplayName         = 'DSCGroup'
            Ensure              = 'Absent'
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
