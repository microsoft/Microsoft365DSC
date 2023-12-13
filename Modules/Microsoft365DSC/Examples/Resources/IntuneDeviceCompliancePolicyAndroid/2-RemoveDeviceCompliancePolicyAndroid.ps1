<#
This example removes an existing Device Compliance Policy for iOs devices
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
        IntuneDeviceCompliancePolicyAndroid 'RemoveDeviceCompliancePolicyAndroid'
        {
            DisplayName = 'Test Android Device Compliance Policy'
            Ensure      = 'Absent'
            Credential  = $Credscredential
        }
    }
}
