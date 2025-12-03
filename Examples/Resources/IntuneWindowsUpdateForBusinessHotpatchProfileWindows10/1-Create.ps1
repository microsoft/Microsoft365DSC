<#
This example creates a device cleanup rule.
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
        IntuneWindowsUpdateForBusinessHotpatchProfileWindows10 'IntuneWindowsUpdateForBusinessHotpatchProfileWindows10-Example'
        {
            DisplayName           = "Example";
            Description           = "";
            HotpatchEnabled       = $True;
            RoleScopeTagIds       = @("0");
            Ensure                = 'Present';
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
