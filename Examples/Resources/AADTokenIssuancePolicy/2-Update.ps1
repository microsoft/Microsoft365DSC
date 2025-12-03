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
        AADTokenIssuancePolicy "AADTokenIssuancePolicy-Demo"
        {
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            Definition            = @("{`"TokenResponseSigningPolicy`":`"TokenOnly`",`"SamlTokenVersion`":`"1.1`",`"SigningAlgorithm`":`"http://www.w3.org/2001/04/xmldsig-more#rsa-sha256`",`"Version`":`"1`",`"EmitSAMLNameFormat`":`"true`"}");
            DisplayName           = "DemoPolicy";
            Ensure                = "Present";
            IsOrganizationDefault = $False;
            TenantId              = $TenantId;
        }
    }
}
