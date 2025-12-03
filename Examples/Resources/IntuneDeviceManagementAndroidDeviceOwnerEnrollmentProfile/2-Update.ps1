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
        IntuneDeviceManagementAndroidDeviceOwnerEnrollmentProfile "IntuneDeviceManagementAndroidDeviceOwnerEnrollmentProfile-MyTestEnrollmentProfile"
        {
            AccountId                 = "8d2ac1fd-0ac9-4047-af2f-f1e6323c9a34e";
            ApplicationId             = $ApplicationId;
            CertificateThumbprint     = $CertificateThumbprint;
            ConfigureWifi             = $True;
            Description               = "This is my enrollment profile";
            DisplayName               = "MyTestEnrollmentProfile";
            EnrollmentMode            = "corporateOwnedDedicatedDevice";
            EnrollmentTokenType       = "default";
            Ensure                    = "Present";
            IsTeamsDeviceProfile      = $False;
            RoleScopeTagIds           = @("0");
            TenantId                  = $TenantId;
            TokenExpirationDateTime   = "10/31/2024 3:59:59 AM";
            WifiHidden                = $True; #Drift
            WifiSecurityType          = "none";
        }
    }
}
