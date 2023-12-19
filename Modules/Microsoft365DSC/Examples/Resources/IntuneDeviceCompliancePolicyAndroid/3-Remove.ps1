<#
This example creates a new Device Compliance Policy for Android devices
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
        IntuneDeviceCompliancePolicyAndroid 'AddDeviceCompliancePolicy'
        {
            DisplayName                                        = 'Test Policy'
            Ensure                                             = 'Absent'
            Credential                                         = $Credscredential
        }
    }
}
