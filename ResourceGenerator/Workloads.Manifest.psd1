@{
    Intune = @(
        @{
            ResourceName             = 'IntuneDeviceConfigurationPolicyiOS'
            CmdletNoun               = 'MgDeviceManagementDeviceConfiguration'
            APIVersion               = 'beta'
            SelectionFilter          = @{
                AdditionalPropertiesType = 'iosGeneralDeviceConfiguration'
            }
        },
        @{
            ResourceName             = 'IntuneDeviceConfigurationPolicyWindows10'
            CmdletNoun               = 'MgDeviceManagementDeviceConfiguration'
            APIVersion               = 'beta'
            SelectionFilter          = @{
                AdditionalPropertiesType = 'windows10GeneralConfiguration'
            }
        },
        @{
            ResourceName             = 'IntuneDeviceEnrollmentLimitRestriction'
            CmdletNoun               = 'MgDeviceManagementDeviceEnrollmentConfiguration'
            APIVersion               = 'beta'
            SelectionFilter          = @{
                AdditionalPropertiesType = 'deviceEnrollmentLimitConfiguration'
            }
        },
        @{
            ResourceName             = 'IntuneWifiConfigurationPolicyAndroidEntrepriseDeviceOwner'
            CmdletNoun               = 'MgDeviceManagementDeviceConfiguration'
            APIVersion               = 'beta'
            SelectionFilter          = @{
                AdditionalPropertiesType = 'androidWorkProfileEnterpriseWiFiConfiguration'
            }
        }
    )
    MicrosoftTeams = @(
        @{
            ResourceName             = 'TeamsShiftsPolicy'
            CmdletNoun               = 'CsTeamsShiftsPolicy'
        }
    )
}
