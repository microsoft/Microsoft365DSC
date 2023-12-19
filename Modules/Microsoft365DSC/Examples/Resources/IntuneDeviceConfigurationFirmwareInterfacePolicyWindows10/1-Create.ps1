<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
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
        IntuneDeviceConfigurationFirmwareInterfacePolicyWindows10 'Example'
        {
            Assignments                    = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allDevicesAssignmentTarget'
                }
            );
            Bluetooth                      = "notConfigured";
            BootFromBuiltInNetworkAdapters = "notConfigured";
            BootFromExternalMedia          = "notConfigured";
            Cameras                        = "enabled";
            ChangeUefiSettingsPermission   = "notConfiguredOnly";
            Credential                     = $Credscredential;
            DisplayName                    = "firmware";
            Ensure                         = "Present";
            FrontCamera                    = "enabled";
            InfraredCamera                 = "enabled";
            Microphone                     = "notConfigured";
            MicrophonesAndSpeakers         = "enabled";
            NearFieldCommunication         = "notConfigured";
            Radios                         = "enabled";
            RearCamera                     = "enabled";
            SdCard                         = "notConfigured";
            SimultaneousMultiThreading     = "enabled";
            SupportsScopeTags              = $True;
            UsbTypeAPort                   = "notConfigured";
            VirtualizationOfCpuAndIO       = "enabled";
            WakeOnLAN                      = "notConfigured";
            WakeOnPower                    = "notConfigured";
            WiFi                           = "notConfigured";
            WindowsPlatformBinaryTable     = "enabled";
            WirelessWideAreaNetwork        = "notConfigured";
        }
    }
}
