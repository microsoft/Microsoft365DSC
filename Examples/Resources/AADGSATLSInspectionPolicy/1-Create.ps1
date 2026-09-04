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
            Rules                 = @(
                MSFT_AADGSATLSInspectionPolicyRule{
                    Name         = 'Contoso Inspect Rule'
                    Priority     = 100
                    Description  = 'Inspect traffic to the Contoso domain'
                    Action       = 'inspect'
                    Status       = 'enabled'
                    Destinations = @(
                        MSFT_AADGSATLSInspectionPolicyRuleDestination{
                            Type   = 'tlsInspectionFqdnDestination'
                            Values = @('contoso.com')
                        }
                    )
                }
            )
            Ensure                = 'Present'
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
