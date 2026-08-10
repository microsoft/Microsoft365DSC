<#
This example creates a TLS Inspection Policy that bypasses inspection by default.
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
        AADGSATLSInspectionPolicy 'MyTLSInspectionPolicy'
        {
            Name                  = 'Contoso TLS Inspection Policy'
            Description           = 'Default TLS inspection policy for Contoso'
            DefaultAction         = 'bypass'
            Ensure                = 'Present'
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
