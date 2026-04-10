<#
This example adds a new Teams Voice Route.
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
        TeamsOnlineVOiceUser 'AssignVoiceUser'
        {
            Identity        = 'John.Smith@Contoso.com'
            TelephoneNumber = "1800-555-1234"
            LocationId      = "c7c5a17f-00d7-47c0-9ddb-3383229d606"
            Ensure          = "Present"
            Credential      = $credsCredential
        }
    }
}
