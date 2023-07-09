@{
    Intune = @(
        @{
            ResourceName             = 'IntuneDeviceConfigurationPolicyiOS'
            CmdletNoun               = 'MgBetaDeviceManagementDeviceConfiguration'
            APIVersion               = 'beta'
            SelectionFilter          = @{
                AdditionalPropertiesType = 'iosGeneralDeviceConfiguration'
            }
        },
        @{
            ResourceName             = 'IntuneDeviceConfigurationPolicyWindows10'
            CmdletNoun               = 'MgBetaDeviceManagementDeviceConfiguration'
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
            ResourceName             = 'IntuneWifiConfigurationPolicyAndroidEnterpriseDeviceOwner'
            CmdletNoun               = 'MgBetaDeviceManagementDeviceConfiguration'
            APIVersion               = 'beta'
            SelectionFilter          = @{
                AdditionalPropertiesType = 'androidWorkProfileEnterpriseWiFiConfiguration'
            }
        }
    )
    MicrosoftTeams = @(
        @{
            ResourceName = 'TeamsFilesPolicy'
            CmdletNoun   = 'CsTeamsFilesPolicy'
        },
        @{
            ResourceName = 'TeamsIPPhonePolicy'
            CmdletNoun ='CsTeamsIPPhonePolicy'
        }
        @{
            ResourceName = 'TeamsShiftsPolicy'
            CmdletNoun   = 'CsTeamsShiftsPolicy'
        }
    )
}
