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
        EXOATPProtectionPolicyRule "EXOATPProtectionPolicyRule-Strict Preset Security Policy"
        {
            Comments                = "Built-in Strict Preset Security Policy";
            Enabled                 = $False;
            Identity                = "Strict Preset Security Policy";
            Name                    = "Strict Preset Security Policy";
            Priority                = 0;
            SafeAttachmentPolicy    = "Strict Preset Security Policy1725468967835";
            SafeLinksPolicy         = "Strict Preset Security Policy1725468969412";
            Ensure                  = "Present"
            ApplicationId           = $ApplicationId
            TenantId                = $TenantId
            CertificateThumbprint   = $CertificateThumbprint
        }
    }
}
