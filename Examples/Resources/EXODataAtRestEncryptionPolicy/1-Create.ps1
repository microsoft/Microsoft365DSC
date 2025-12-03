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
        EXODataAtRestEncryptionPolicy "M365DataAtRestEncryptionPolicy-Riyansh_Policy"
        {
            AzureKeyIDs          = @("https://m365dataatrestencryption.vault.azure.net/keys/EncryptionKey","https://m365datariyansh.vault.azure.net/keys/EncryptionRiyansh");
            Description          = "Tenant default policy 1";
            Enabled              = $True;
            Ensure               = "Present";
            Identity             = "Riyansh_Policy";
            Name                 = "Riyansh_Policy";
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
