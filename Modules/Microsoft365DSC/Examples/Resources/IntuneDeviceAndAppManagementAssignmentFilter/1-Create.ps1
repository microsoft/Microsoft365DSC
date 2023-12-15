<#
This example creates a new Device and App Management Assignment Filter.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $intuneAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneDeviceAndAppManagementAssignmentFilter 'AssignmentFilter'
        {
            DisplayName = 'Test Device Filter'
            Description = 'This is a new Filter'
            Platform    = 'windows10AndLater'
            Rule        = "(device.manufacturer -ne `"Microsoft Corporation`")"
            Ensure      = 'Present'
            Credential  = $intuneAdmin
        }
    }
}
