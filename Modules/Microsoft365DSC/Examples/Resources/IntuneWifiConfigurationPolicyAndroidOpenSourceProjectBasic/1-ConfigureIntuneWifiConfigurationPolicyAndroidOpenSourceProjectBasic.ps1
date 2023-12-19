<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
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
        IntuneWifiConfigurationPolicyAndroidOpenSourceProjectBasic 'myWifiConfigAndroidOpensourcePolicy'
        {
            Id                             = 'fe0a93dc-e9cc-4d4b-8dd6-361c51c70f77'
            DisplayName                    = 'Android Aosp Basic Wi-Fi Profile'
            Assignments                    = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments {
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType                                   = '#microsoft.graph.allDevicesAssignmentTarget'
                }
            )
            ConnectAutomatically           = $False
            ConnectWhenNetworkNameIsHidden = $True
            NetworkName                    = 'Network Name'
            PreSharedKey                   = "ABCDE"
            PreSharedKeyIsSet              = $True
            ProxyExclusionList             = @("Some.Proxy.Name")
            ProxyManualAddress             = "proxy.internal.domain"
            ProxyManualPort                = 8080
            ForcePreSharedKeyUpdate        = $false
            ProxySetting                   = "manual"
            Ssid                           = 'ssid'
            WiFiSecurityType               = 'wep'
            Ensure                         = 'Present'
            Credential                     = $credsGlobalAdmin
        }
    }
}
