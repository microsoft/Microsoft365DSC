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

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        EXOMailTips 'OrgWideMailTips'
        {
            IsSingleInstance                      = 'Yes'
            MailTipsAllTipsEnabled                = $True
            MailTipsGroupMetricsEnabled           = $False # Updated Property
            MailTipsLargeAudienceThreshold        = 100
            MailTipsMailboxSourcedTipsEnabled     = $True
            MailTipsExternalRecipientsTipsEnabled = $True
            Ensure                                = "Present"
            Credential                            = $Credscredential
        }
    }
}
