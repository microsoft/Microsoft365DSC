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
        EXOAntiPhishRule 'ConfigureAntiPhishRule'
        {
            Identity                  = "Test Rule"
            ExceptIfSentToMemberOf    = $null
            ExceptIfSentTo            = $null
            SentTo                    = $null
            ExceptIfRecipientDomainIs = $null
            Comments                  = $null
            AntiPhishPolicy           = "Our Rule"
            RecipientDomainIs         = $null
            Enabled                   = $True
            SentToMemberOf            = @("msteams_bb15d4@contoso.onmicrosoft.com")
            Priority                  = 2 # Updated Property
            Ensure                    = "Present"
            Credential                = $Credscredential
        }
    }
}
