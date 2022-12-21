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
            EnableShiftPresence            = $True
            AccessType                     = "FakeStringValue"
            ShiftNoticeMessageType         = "FakeStringValue"
            ShiftNoticeMessageCustom       = "FakeStringValue"
            AccessGracePeriodMinutes       = 3
            Identity                       = "FakeStringValue"
            ShiftNoticeFrequency           = "FakeStringValue"
            EnableScheduleOwnerPermissions = $True
            Ensure                         = "Present"
            Credential                     = $credentials
        }
    }
}
