<#
This example removes an existing Device Compliance Policy for MacOS devices
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
        IntuneDeviceCompliancePolicyMacOS 'RemoveDeviceCompliancePolicyMacOS'
        {
            DisplayName          = 'Demo MacOS Device Compliance Policy'
            Ensure               = 'Absent'
            Credential           = $Credscredential
        }
    }
}
