<#
This example creates a new General Device Configuration Policy for Android WorkProfile .
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
        IntuneDeviceConfigurationPolicyAndroidWorkProfile 97ed22e9-1429-40dc-ab3c-0055e538383b
        {
            DisplayName                                    = 'Android Work Profile - Device Restrictions - Standard'
            Ensure                                         = 'Absent'
            Credential                                     = $Credscredential
        }
    }
}
