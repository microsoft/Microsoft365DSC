<#
This example creates a Microsoft Entra Private Access enterprise application
with two IP segments and assigns it to a connector group.
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
        AADGSAPrivateAccessApplication 'MyPrivateApp'
        {
            DisplayName              = 'ContosoPrivateApp'
            ApplicationType          = 'nonwebapp'
            IsAccessibleViaZTNAClient = $true
            ConnectorGroupName       = 'Private Access ConnectorGroup'
            IsDnsResolutionEnabled   = $false
            Segments                 = @(
                MSFT_AADGSAPrivateAccessApplicationSegment
                {
                    DestinationHost = 'fileserver.contoso.local'
                    DestinationType = 'fqdn'
                    Ports           = @('445-445', '3389-3389')
                    Protocol        = 'tcp'
                }
                MSFT_AADGSAPrivateAccessApplicationSegment
                {
                    DestinationHost = '10.0.0.0/24'
                    DestinationType = 'ipRangeCidr'
                    Ports           = @('443-443', '80-80')
                    Protocol        = 'tcp'
                }
            )
            Ensure                   = 'Present'
            ApplicationId            = $ApplicationId
            TenantId                 = $TenantId
            CertificateThumbprint    = $CertificateThumbprint
        }
    }
}
