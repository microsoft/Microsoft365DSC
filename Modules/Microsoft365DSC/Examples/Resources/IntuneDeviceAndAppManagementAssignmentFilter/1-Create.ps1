<#
This example creates a new Device and App Management Assignment Filter.
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
        IntuneDeviceAndAppManagementAssignmentFilter 'AssignmentFilter'
        {
            DisplayName = 'Test Device Filter'
            Description = 'This is a new Filter'
            Platform    = 'windows10AndLater'
            Rule        = "(device.manufacturer -ne `"Microsoft Corporation`")"
            Ensure      = 'Present'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
