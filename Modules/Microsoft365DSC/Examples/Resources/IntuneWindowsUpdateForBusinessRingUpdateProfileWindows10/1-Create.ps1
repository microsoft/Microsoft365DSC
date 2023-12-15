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
        IntuneWindowsUpdateForBusinessRingUpdateProfileWindows10 'Example'
        {
            DisplayName                         = 'WUfB Ring'
            AllowWindows11Upgrade               = $False
            Assignments                         = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments
                {
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType                                   = '#microsoft.graph.allLicensedUsersAssignmentTarget'
                }
            )
            AutomaticUpdateMode                 = 'autoInstallAtMaintenanceTime'
            AutoRestartNotificationDismissal    = 'notConfigured'
            BusinessReadyUpdatesOnly            = 'userDefined'
            DeadlineForFeatureUpdatesInDays     = 1
            DeadlineForQualityUpdatesInDays     = 2
            DeadlineGracePeriodInDays           = 3
            DeliveryOptimizationMode            = 'userDefined'
            Description                         = ''
            DriversExcluded                     = $False
            FeatureUpdatesDeferralPeriodInDays  = 0
            FeatureUpdatesPaused                = $False
            FeatureUpdatesPauseExpiryDateTime   = '0001-01-01T00:00:00.0000000+00:00'
            FeatureUpdatesRollbackStartDateTime = '0001-01-01T00:00:00.0000000+00:00'
            FeatureUpdatesRollbackWindowInDays  = 10
            InstallationSchedule = MSFT_MicrosoftGraphwindowsUpdateInstallScheduleType {
                ActiveHoursStart = '08:00:00'
                ActiveHoursEnd   = '17:00:00'
                odataType        = '#microsoft.graph.windowsUpdateActiveHoursInstall'
            }
            MicrosoftUpdateServiceAllowed       = $True
            PostponeRebootUntilAfterDeadline    = $False
            PrereleaseFeatures                  = 'userDefined'
            QualityUpdatesDeferralPeriodInDays  = 0
            QualityUpdatesPaused                = $False
            QualityUpdatesPauseExpiryDateTime   = '0001-01-01T00:00:00.0000000+00:00'
            QualityUpdatesRollbackStartDateTime = '0001-01-01T00:00:00.0000000+00:00'
            SkipChecksBeforeRestart             = $False
            UpdateNotificationLevel             = 'defaultNotifications'
            UserPauseAccess                     = 'enabled'
            UserWindowsUpdateScanAccess         = 'enabled'
            Ensure                              = 'Present'
            Credential                          = $Credscredential
        }
    }
}
