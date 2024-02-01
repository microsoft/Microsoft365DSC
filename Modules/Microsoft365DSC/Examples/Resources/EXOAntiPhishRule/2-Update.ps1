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
        EXOAntiPhishRule 'ConfigureAntiPhishRule'
        {
            Identity                  = "Test Rule"
            Comments                  = "This is an updated comment." # Updated Property
            AntiPhishPolicy           = "Our Rule"
            Enabled                   = $True
            SentToMemberOf            = @("executives@$Domain")
            Ensure                    = "Present"
            Credential                = $Credscredential
        }
    }
}
