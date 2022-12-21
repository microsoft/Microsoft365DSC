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
        TeamsShiftsPolicy 'Example'
        {
            AccessGracePeriodMinutes       = 15;
            AccessType                     = "UnrestrictedAccess_TeamsApp";
            Credential                     = $Credscredential;
            EnableScheduleOwnerPermissions = $False;
            EnableShiftPresence            = $False;
            Ensure                         = "Present";
            Identity                       = "Global";
            ShiftNoticeFrequency           = "Never";
            ShiftNoticeMessageCustom       = "";
            ShiftNoticeMessageType         = "DefaultMessage";
        }
    }
}
