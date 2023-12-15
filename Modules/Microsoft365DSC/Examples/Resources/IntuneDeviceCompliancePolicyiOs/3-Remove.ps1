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
        IntuneDeviceCompliancePolicyiOs 'ConfigureDeviceCompliancePolicyiOS'
        {
            DisplayName                                 = 'Test iOS Device Compliance Policy'
            Ensure                                      = 'Absent'
            Credential                                  = $Credscredential

        }
    }
}
