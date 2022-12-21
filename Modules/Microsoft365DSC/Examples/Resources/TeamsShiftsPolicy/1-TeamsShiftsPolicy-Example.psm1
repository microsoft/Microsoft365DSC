<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credentials
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        TeamsShiftsPolicy 'Example'
        {
            AccessGracePeriodMinutes       = 15;
            AccessType                     = "UnrestrictedAccess_TeamsApp";
            EnableScheduleOwnerPermissions = $False;
            EnableShiftPresence            = $False;
            Identity                       = "Global";
            ShiftNoticeFrequency           = "Never";
            ShiftNoticeMessageType         = "DefaultMessage";
            Ensure                         = "Present"
            Credential                     = $credentials
        }
    }
}
