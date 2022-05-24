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
        EXOHostedContentFilterRule 'ConfigureHostedContentFilterRule'
        {
            Identity                  = "Contoso Recipients"
            Comments                  = "Applies to all users, except when member of HR group"
            Enabled                   = $True
            ExceptIfSentToMemberOf    = "Contoso Human Resources"
            HostedContentFilterPolicy = "Default"
            Ensure                    = "Present"
            Credential                = $credsGlobalAdmin
        }
    }
}
