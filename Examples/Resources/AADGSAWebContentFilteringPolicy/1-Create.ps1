<#
This example creates a Web Content Filtering Policy in the enabled state.
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
        AADGSAWebContentFilteringPolicy 'ContosoBlockSocialMedia'
        {
            Name                  = 'Block social media websites'
            Description           = 'Policy to block access to social media categories'
            State                 = 'enabled'
            Priority              = 100
            Ensure                = 'Present'
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
