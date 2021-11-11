<#
This example removes an existing Device Compliance Policy for Android Device Owner devices
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneDeviceCompliancePolicyAndroidDeviceOwner 'RemoveAndroidDeviceCompliancePolicyOwner'
        {
            DisplayName          = "DeviceOwner"
            Ensure               = "Absent"
            Credential           = $credsGlobalAdmin
        }
    }
}
