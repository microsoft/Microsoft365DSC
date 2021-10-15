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
        IntuneDeviceCompliancePolicyAndroidDeviceOwner f7d82525-b7c0-475c-9d5e-16fafdfa487a
        {
            DisplayName          = "DeviceOwner"
            Ensure               = "Absent"
            Credential           = $credsGlobalAdmin;
        }
    }
}
