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
        AADApplicationFederatedIdentityCredential 'AADApplicationFederatedIdentityCredential'
        {
            ApplicationDisplayName = 'AppDisplayName'
            Name                   = 'GitHubActionsMain'
            Issuer                 = 'https://token.actions.githubusercontent.com'
            Subject                = 'repo:contoso/app:ref:refs/heads/main'
            Audiences              = @('api://AzureADTokenExchange')
            Description            = 'GitHub Actions main branch'
            Ensure                 = 'Present'
            ApplicationId          = $ApplicationId
            TenantId               = $TenantId
            CertificateThumbprint  = $CertificateThumbprint
        }
    }
}
