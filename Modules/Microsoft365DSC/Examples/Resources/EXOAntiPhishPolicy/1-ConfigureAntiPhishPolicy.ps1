<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
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
            TreatSoftPassAsAuthenticated          = $True
            Enabled                               = $null
            TargetedDomainsToProtect              = $null
            EnableSimilarUsersSafetyTips          = $null
            ExcludedDomains                       = $null
            EnableAuthenticationSafetyTip         = $False
            TargetedDomainActionRecipients        = $null
            EnableMailboxIntelligence             = $null
            EnableSimilarDomainsSafetyTips        = $null
            TargetedDomainProtectionAction        = "NoAction"
            AdminDisplayName                      = ""
            AuthenticationFailAction              = "MoveToJmf"
            TargetedUserProtectionAction          = "NoAction"
            TargetedUsersToProtect                = $null
            EnableTargetedUserProtection          = $null
            ExcludedSenders                       = $null
            EnableAuthenticationSoftPassSafetyTip = $False
            EnableOrganizationDomainsProtection   = $null
            EnableUnusualCharactersSafetyTips     = $null
            TargetedUserActionRecipients          = $null
            EnableAntispoofEnforcement            = $True
            Ensure                                = "Present"
            Credential                            = $credsGlobalAdmin
        }
    }
}
