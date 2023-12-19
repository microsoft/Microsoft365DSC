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
        IntuneSettingCatalogCustomPolicyWindows10 'Example'
        {
            Credential                                                                 = $Credscredential
            Assignments           = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allDevicesAssignmentTarget'
                }
            );
            Description           = "";
            Ensure                = "Present";
            Name                  = "Setting Catalog Raw - DSC";
            Platforms             = "windows10";
            Settings              = @(
                MSFT_MicrosoftGraphdeviceManagementConfigurationSetting{
                    SettingInstance = MSFT_MicrosoftGraphDeviceManagementConfigurationSettingInstance{
                        choiceSettingValue = MSFT_MicrosoftGraphDeviceManagementConfigurationChoiceSettingValue{
                            Value = 'device_vendor_msft_policy_config_abovelock_allowcortanaabovelock_1'
                        }
                        SettingDefinitionId = 'device_vendor_msft_policy_config_abovelock_allowcortanaabovelock'
                        odataType = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                    }
                }
                MSFT_MicrosoftGraphdeviceManagementConfigurationSetting{
                    SettingInstance = MSFT_MicrosoftGraphDeviceManagementConfigurationSettingInstance{
                        SettingDefinitionId = 'device_vendor_msft_policy_config_applicationdefaults_defaultassociationsconfiguration'
                        simpleSettingValue = MSFT_MicrosoftGraphDeviceManagementConfigurationSimpleSettingValue{
                            odataType = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
                            StringValue = ''
                        }
                        odataType = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                    }
                }
                MSFT_MicrosoftGraphdeviceManagementConfigurationSetting{
                    SettingInstance = MSFT_MicrosoftGraphDeviceManagementConfigurationSettingInstance{
                        choiceSettingValue = MSFT_MicrosoftGraphDeviceManagementConfigurationChoiceSettingValue{
                            Value = 'device_vendor_msft_policy_config_applicationdefaults_enableappurihandlers_1'
                        }
                        SettingDefinitionId = 'device_vendor_msft_policy_config_applicationdefaults_enableappurihandlers'
                        odataType = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                    }
                }
                MSFT_MicrosoftGraphdeviceManagementConfigurationSetting{
                    SettingInstance = MSFT_MicrosoftGraphDeviceManagementConfigurationSettingInstance{
                        choiceSettingValue = MSFT_MicrosoftGraphDeviceManagementConfigurationChoiceSettingValue{
                            Value = 'device_vendor_msft_policy_config_defender_allowarchivescanning_1'
                        }
                        SettingDefinitionId = 'device_vendor_msft_policy_config_defender_allowarchivescanning'
                        odataType = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                    }
                }
                MSFT_MicrosoftGraphdeviceManagementConfigurationSetting{
                    SettingInstance = MSFT_MicrosoftGraphDeviceManagementConfigurationSettingInstance{
                        choiceSettingValue = MSFT_MicrosoftGraphDeviceManagementConfigurationChoiceSettingValue{
                            Value = 'device_vendor_msft_policy_config_defender_allowbehaviormonitoring_1'
                        }
                        SettingDefinitionId = 'device_vendor_msft_policy_config_defender_allowbehaviormonitoring'
                        odataType = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                    }
                }
                MSFT_MicrosoftGraphdeviceManagementConfigurationSetting{
                    SettingInstance = MSFT_MicrosoftGraphDeviceManagementConfigurationSettingInstance{
                        choiceSettingValue = MSFT_MicrosoftGraphDeviceManagementConfigurationChoiceSettingValue{
                            Value = 'device_vendor_msft_policy_config_defender_allowcloudprotection_1'
                        }
                        SettingDefinitionId = 'device_vendor_msft_policy_config_defender_allowcloudprotection'
                        odataType = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                    }
                }
            );
            Technologies          = "mdm";
        }
    }
}
