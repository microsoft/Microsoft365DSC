<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param
    (
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
        IntuneApplicationControlPolicyWindows10 'ConfigureApplicationControlPolicyWindows10'
        {
            DisplayName                      = 'Windows 10 Desktops'
            Description                      = 'All windows 10 Desktops'
            AppLockerApplicationControl      = 'enforceComponentsAndStoreApps'
            SmartScreenBlockOverrideForFiles = $False # Updated Property
            SmartScreenEnableInShell         = $True
            Ensure                           = 'Present'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
