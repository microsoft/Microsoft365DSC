<#
This example updates a device cleanup rule.
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
        IntuneDeviceCleanupRuleV2 'Example'
        {
            DisplayName                            = "Rule 1";
            Description                            = "";
            DeviceCleanupRulePlatformType          = "all";
            DeviceInactivityBeforeRetirementInDays = 25; # Updated Property
            Ensure                                 = 'Present';
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
