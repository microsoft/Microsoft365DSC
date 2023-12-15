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
            Ensure      = 'Absent'
            Credential  = $intuneAdmin
        }
    }
}
