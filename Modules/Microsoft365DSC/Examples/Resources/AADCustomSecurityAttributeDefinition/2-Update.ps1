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
        AADCustomSecurityAttributeDefinition "AADCustomSecurityAttributeDefinition-ShoeSize"
        {
            ApplicationId           = $ApplicationId;
            AttributeSet            = "TestAttributeSet";
            CertificateThumbprint   = $CertificateThumbprint;
            Ensure                  = "Present";
            IsCollection            = $False;
            IsSearchable            = $True;
            Name                    = "ShoeSize";
            Status                  = "Available";
            TenantId                = $TenantId;
            Type                    = "String";
            UsePreDefinedValuesOnly = $False;
            Description             = "What size of shoe is the person wearing? Drifted" # Drift
        }
    }
}
