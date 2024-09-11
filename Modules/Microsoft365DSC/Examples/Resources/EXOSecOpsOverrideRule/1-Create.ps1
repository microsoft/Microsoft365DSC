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
        EXOSecOpsOverrideRule "EXOSecOpsOverrideRule-_Exe:SecOpsOverrid:ca3c51ac-925c-49f4-af42-43e26b874245"
        {
            Comment              = "TestComment";
            Ensure               = "Present";
            Identity             = "_Exe:SecOpsOverrid:ca3c51ac-925c-49f4-af42-43e26b874245";
            Policy               = "40528418-717d-4368-a1ae-7912918f8a1f";
        }
    }
}
