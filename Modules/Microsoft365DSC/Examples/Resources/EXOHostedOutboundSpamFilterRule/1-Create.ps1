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
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        EXOHostedOutboundSpamFilterRule 'ConfigureHostedOutboundSpamFilterRule'
        {
            Identity                       = "Contoso Executives"
            Comments                       = "Does not apply to Executives"
            Enabled                        = $True
            ExceptIfFrom                   = "AdeleV@$Domain"
            FromMemberOf                   = "Executives@$Domain"
            HostedOutboundSpamFilterPolicy = "Integration SFP"
            Ensure                         = "Present"
            Credential                     = $Credscredential
        }
    }
}
