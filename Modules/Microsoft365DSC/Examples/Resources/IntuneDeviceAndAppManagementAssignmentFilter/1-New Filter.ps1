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
            Credential           = $intuneAdmin;
            Description          = "This is a new Filter";
            DisplayName          = "Test Device Filter";
            Ensure               = "Present";
            Platform             = "windows10AndLater";
            Rule                 = "(device.manufacturer -ne `"Microsoft Corporation`")";
        }
    }
}
