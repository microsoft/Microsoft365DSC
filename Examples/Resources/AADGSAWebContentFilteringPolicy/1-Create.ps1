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
            DefaultAction         = 'allow'
            Rules                 = @(
                MSFT_AADGSAWebContentFilteringPolicyRule{
                    Name              = 'Block social networking'
                    Priority          = 100
                    Description       = 'Block access to social networking sites'
                    Action            = 'block'
                    Status            = 'enabled'
                    HttpRequestMethod = 'get'
                    SessionType       = 'user'
                    Destinations      = @(
                        MSFT_AADGSAWebContentFilteringPolicyRuleDestination{
                            Type   = 'webFilteringWebCategoryDestination'
                            Values = @('SocialNetworking')
                        }
                        MSFT_AADGSAWebContentFilteringPolicyRuleDestination{
                            Type   = 'webFilteringUrlDestination'
                            Values = @('contoso-social.com')
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
