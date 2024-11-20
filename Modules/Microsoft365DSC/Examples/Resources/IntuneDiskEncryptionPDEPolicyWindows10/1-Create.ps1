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
        IntuneDiskEncryptionPDEPolicyWindows10 "IntuneDiskEncryptionPDEPolicyWindows10"
        {
            Assignments                  = @();
            Description                  = "test";
            DisplayName                  = "test";
            Ensure                       = "Present";
            EnablePersonalDataEncryption = "1";
            ProtectDesktop               = "0";
            ProtectDocuments             = "0";
            ProtectPictures              = "0";
            RoleScopeTagIds              = @("0");
            ApplicationId                = $ApplicationId;
            TenantId                     = $TenantId;
            CertificateThumbprint        = $CertificateThumbprint;
        }
    }
}
