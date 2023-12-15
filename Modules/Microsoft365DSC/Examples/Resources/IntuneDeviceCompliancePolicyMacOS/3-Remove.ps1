<#
This example creates a new Device Comliance Policy for MacOS.
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
        IntuneDeviceCompliancePolicyMacOS 'ConfigureDeviceCompliancePolicyMacOS'
        {
            DisplayName                                 = 'MacOS DSC Policy'
            Ensure                                      = 'Absent'
            Credential                                  = $Credscredential
        }
    }
}
