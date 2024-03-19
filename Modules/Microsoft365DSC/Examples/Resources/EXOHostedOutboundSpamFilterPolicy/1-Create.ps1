<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOHostedOutboundSpamFilterPolicy 'HostedOutboundSpamFilterPolicy'
        {
            Identity                                  = "Integration SFP"
            ActionWhenThresholdReached                = "BlockUserForToday"
            AdminDisplayName                          = ""
            AutoForwardingMode                        = "Automatic"
            BccSuspiciousOutboundAdditionalRecipients = @()
            BccSuspiciousOutboundMail                 = $False
            NotifyOutboundSpam                        = $False
            NotifyOutboundSpamRecipients              = @()
            RecipientLimitExternalPerHour             = 0
            RecipientLimitInternalPerHour             = 0
            RecipientLimitPerDay                      = 0
            Ensure                                    = "Present"
            Credential                                = $Credscredential
        }
    }
}
