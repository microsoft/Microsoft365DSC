<#
This example updates the Device Management Compliance Settings
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
        IntuneDeviceManagementComplianceSettings 'DeviceManagementComplianceSettings'
        {
            Credential                           = $Credscredential
            DeviceComplianceCheckinThresholdDays = 22;
            IsSingleInstance                     = "Yes";
            SecureByDefault                      = $True;
        }
    }
}
