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
        EXOEOPProtectionPolicyRule "EXOEOPProtectionPolicyRule-Strict Preset Security Policy"
        {
            Ensure                    = "Present";
            ExceptIfRecipientDomainIs = @("sandrodev.onmicrosoft.com");
            Identity                  = "Strict Preset Security Policy";
            Name                      = "Strict Preset Security Policy";
            Priority                  = 0;
            State                     = "Enabled";
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
