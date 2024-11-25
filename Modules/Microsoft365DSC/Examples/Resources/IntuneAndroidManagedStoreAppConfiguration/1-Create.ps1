<#
This example creates a new Intune Mobile App Configuration Policy for iOs devices
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
    Import-DscResource -ModuleName 'Microsoft365DSC'

    Node localhost
    {
        IntuneAndroidManagedStoreAppConfiguration "ConfigureIntuneAndroidManagedStoreAppConfiguration"
        {
            Description           = "IntuneAndroidManagedStoreAppConfiguration Description";
            DisplayName           = "IntuneAndroidManagedStoreAppConfiguration DisplayName";
            Ensure                = "Present";
            appSupportsOemConfig  = $False;
            connectedAppsEnabled  = $False;
            packageId             = "app:org.mozilla.firefox";
            payloadJson           = "";
	    permissionActions     = @(
                MSFT_androidPermissionAction{
                    permission = 'android.permission.RECEIVE_SMS'
                }
                MSFT_androidPermissionAction{
                    permission = 'android.permission.READ_SMS'
                }
                MSFT_androidPermissionAction{
                    permission = 'android.permission.RECEIVE_WAP_PUSH'
                }
            );
            profileApplicability  = "androidDeviceOwner";
            targetedMobileApps    = @("30ab8f7a-14fb-4a05-befa-ea7f51141ad9");
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}