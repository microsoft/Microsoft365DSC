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
        EXOMailboxSettings 'OttawaTeamMailboxSettings'
        {
            DisplayName = 'Ottawa Employees'
            TimeZone    = 'Eastern Standard Time'
            Locale      = 'fr-CA'
            Ensure      = 'Present'
            Credential  = $credsGlobalAdmin
        }
    }
}
