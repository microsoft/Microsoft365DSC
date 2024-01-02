<#
This example creates a new Device Comliance Policy for Windows.
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
        IntuneDeviceCompliancePolicyWindows10 'ConfigureDeviceCompliancePolicyWindows10'
        {
            DisplayName                                 = 'Windows 10 DSC Policy'
            Ensure                                      = 'Absent'
            Credential                                  = $Credscredential
        }
    }
}
