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
        EXOAntiPhishPolicy 'ConfigureAntiphishPolicy'
        {
            Identity                              = "Our Rule"
            MakeDefault                           = $null
            PhishThresholdLevel                   = 1
            EnableTargetedDomainsProtection       = $null
            Enabled                               = $null
            TargetedDomainsToProtect              = $null
            EnableSimilarUsersSafetyTips          = $null
            ExcludedDomains                       = $null
            TargetedDomainActionRecipients        = $null
            EnableMailboxIntelligence             = $null
            EnableSimilarDomainsSafetyTips        = $null
            AdminDisplayName                      = ""
            AuthenticationFailAction              = "MoveToJmf"
            TargetedUserProtectionAction          = "NoAction"
            TargetedUsersToProtect                = $null
            EnableTargetedUserProtection          = $null
            ExcludedSenders                       = $null
            EnableOrganizationDomainsProtection   = $null
            EnableUnusualCharactersSafetyTips     = $null
            TargetedUserActionRecipients          = $null
            Ensure                                = "Present"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
