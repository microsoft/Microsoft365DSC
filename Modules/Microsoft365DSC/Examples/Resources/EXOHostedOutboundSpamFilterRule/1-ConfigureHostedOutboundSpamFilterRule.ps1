<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOHostedOutboundSpamFilterRule 'ConfigureHostedOutboundSpamFilterRule'
        {
            Identity                       = "Contoso Executives"
            Comments                       = "Does not apply to Executives"
            Enabled                        = $True
            ExceptIfFrom                   = "Elizabeth Brunner"
            HostedOutboundSpamFilterPolicy = "Default"
            Ensure                         = "Present"
            Credential                     = $credsGlobalAdmin
        }
    }
}
