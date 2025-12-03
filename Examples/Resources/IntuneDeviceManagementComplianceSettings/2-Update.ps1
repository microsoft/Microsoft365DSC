<#
This example updates the Device Management Compliance Settings
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
        IntuneDeviceManagementComplianceSettings 'DeviceManagementComplianceSettings'
        {
            DeviceComplianceCheckinThresholdDays = 22;
            IsSingleInstance                     = "Yes";
            SecureByDefault                      = $True;
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
