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
        IntuneEndpointDetectionAndResponsePolicyLinux 'myEDRPolicy'
        {
            DisplayName     = 'Edr Policy'
            tags_item_key   = '0'
            tags_item_value = 'tag'
            Assignments     = @()
            Description     = 'My updated description' # Updated Property
            Ensure          = 'Present'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
