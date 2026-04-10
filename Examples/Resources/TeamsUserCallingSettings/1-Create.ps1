<#
This example adds a new Teams Channels Policy.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsCredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        TeamsUserCallingSettings 'AssignCallingSettings'
        {
            CallGroupOrder       = "Simultaneous";
            Credential           = $credsCredential;
            Ensure               = "Present";
            Identity             = "John.Smith@contoso.com";
            UnansweredDelay      = "00:00:20";
        }
    }
}
