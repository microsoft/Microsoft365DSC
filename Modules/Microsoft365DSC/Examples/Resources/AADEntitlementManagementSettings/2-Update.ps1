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
        AADEntitlementManagementSettings "AADEntitlementManagementSettings"
        {
            ApplicationId                            = $ApplicationId;
            CertificateThumbprint                    = $CertificateThumbprint;
            DaysUntilExternalUserDeletedAfterBlocked = 30;
            ExternalUserLifecycleAction              = "blockSignInAndDelete";
            IsSingleInstance                         = "Yes";
            TenantId                                 = $TenantId;
        }
    }
}
