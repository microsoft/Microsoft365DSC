<#
This example adds a new Teams Emergency Calling Policy.
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
        TeamsEmergencyCallingPolicy 'ConfigureEmergencyCallingPolicy'
        {
            Description               = "Demo"
            Identity                  = "Demo Emergency Calling Policy"
            NotificationDialOutNumber = "+1234567890"
            NotificationGroup         = 'john.smith@contoso.com'
            NotificationMode          = "NotificationOnly"
            Ensure                    = 'Present'
            Credential                = $Credscredential
        }
    }
}
