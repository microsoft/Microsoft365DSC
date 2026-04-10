<#
This example adds a new Teams Events Policy.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsTeamsAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        TeamsEventsPolicy 'ConfigureEventsPolicy'
        {
            Identity             = "My Events Policy";
            Description          = "This is a my Events Policy";
            AllowWebinars        = "Disabled";
            EventAccessType      = "EveryoneInCompanyExcludingGuests";
            Credential           = $credsTeamsAdmin
            Ensure               = "Present";
        }
    }
}
