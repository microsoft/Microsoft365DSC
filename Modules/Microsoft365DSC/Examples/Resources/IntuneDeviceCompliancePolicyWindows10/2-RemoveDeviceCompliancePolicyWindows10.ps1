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
        IntuneDeviceCompliancePolicyWindows10 'RemoveDeviceCompliancePolicyWindows10'
        {
            DisplayName          = 'Demo Windows 10 Device Compliance Policy'
            Ensure               = 'Absent'
            Credential           = $Credscredential
        }
    }
}
