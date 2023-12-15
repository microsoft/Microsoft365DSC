<#
This example creates a new Device Configuration Policy for iOS.
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
        IntuneDeviceConfigurationPolicyiOS 'ConfigureDeviceConfigurationPolicyiOS'
        {
            DisplayName                                    = 'iOS DSC Policy'
            Ensure                                         = 'Absent'
            Credential                                     = $Credscredential
        }
    }
}
