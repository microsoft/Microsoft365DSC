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
        IntuneManagedInstallerPolicyWindows10 "IntuneManagedInstallerPolicyWindows10-SideCar ManagedInstaller Script"
        {
            DisplayName              = "SideCar ManagedInstaller Script";
            Ensure                   = "Absent";
            ApplicationId            = $ApplicationId;
            CertificateThumbprint    = $CertificateThumbprint;
            TenantId                 = $OrganizationName;
        }
    }
}
