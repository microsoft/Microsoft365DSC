<#
This example shows how to update ActiveSync organization settings with different values.
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
        EXOActiveSyncOrganizationSettings 'ActiveSyncOrgSettings'
        {
            IsSingleInstance                       = 'Yes'
            DefaultAccessLevel                     = 'Block'
            AllowAccessForUnSupportedPlatform      = $false
            AllowRMSSupportForUnenlightenedApps    = $false
            UserMailInsert                         = 'Your device has been blocked by the administrator.'
            OtaNotificationMailInsert              = 'A device has been blocked.'
            DeviceFiltering                        = 'BlockList'
            ApplicationId                          = $ApplicationId
            TenantId                              = $TenantId
            CertificateThumbprint                 = $CertificateThumbprint
        }
    }
}