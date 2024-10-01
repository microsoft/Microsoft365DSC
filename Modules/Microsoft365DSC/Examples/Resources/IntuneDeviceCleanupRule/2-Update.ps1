<#
This example sets the device cleanup rule.
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
        IntuneDeviceCleanupRule 'Example'
        {
            Enabled                                = $true
            IsSingleInstance                       = 'Yes'
            DeviceInactivityBeforeRetirementInDays = 25 # Updated Property
            Ensure                                 = 'Present'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
