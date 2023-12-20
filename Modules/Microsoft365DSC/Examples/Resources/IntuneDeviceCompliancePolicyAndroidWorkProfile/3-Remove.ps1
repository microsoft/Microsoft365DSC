<#
This example creates a new Device Compliance Policy for iOs devices
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
        IntuneDeviceCompliancePolicyAndroidWorkProfile 'ConfigureAndroidDeviceCompliancePolicyWorkProfile'
        {
            DisplayName                                        = 'Test Policy'
            Ensure                                             = 'Absent'
            Credential                                         = $Credscredential
        }
    }
}
