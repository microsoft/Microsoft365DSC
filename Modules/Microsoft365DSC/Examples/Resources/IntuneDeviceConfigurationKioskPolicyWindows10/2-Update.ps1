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
        IntuneDeviceConfigurationKioskPolicyWindows10 'Example'
        {
            Assignments                         = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allLicensedUsersAssignmentTarget'
                }
            );
            Credential                          = $Credscredential;
            DisplayName                         = "kiosk";
            EdgeKioskEnablePublicBrowsing       = $False; # Updated Property
            Ensure                              = "Present";
            KioskBrowserBlockedUrlExceptions    = @();
            KioskBrowserBlockedURLs             = @();
            KioskBrowserDefaultUrl              = "http://bing.com";
            KioskBrowserEnableEndSessionButton  = $False;
            KioskBrowserEnableHomeButton        = $True;
            KioskBrowserEnableNavigationButtons = $False;
            KioskProfiles                       = @(
                MSFT_MicrosoftGraphwindowsKioskProfile{
                    ProfileId = '17f9e980-3435-4bd5-a7a1-ca3c06d0bf2c'
                    UserAccountsConfiguration = @(
                        MSFT_MicrosoftGraphWindowsKioskUser{
                            odataType = '#microsoft.graph.windowsKioskAutologon'
                        }
                    )
                    ProfileName = 'profile'
                    AppConfiguration = MSFT_MicrosoftGraphWindowsKioskAppConfiguration{
                        Win32App = MSFT_MicrosoftGraphWindowsKioskWin32App{
                            EdgeNoFirstRun = $True
                            EdgeKiosk = 'https://domain.com'
                            ClassicAppPath = 'msedge.exe'
                            AutoLaunch = $False
                            StartLayoutTileSize = 'hidden'
                            AppType = 'unknown'
                            EdgeKioskType = 'publicBrowsing'
                        }
                        odataType = '#microsoft.graph.windowsKioskSingleWin32App'
                    }
                }
            );
            WindowsKioskForceUpdateSchedule     = MSFT_MicrosoftGraphwindowsKioskForceUpdateSchedule{
                RunImmediatelyIfAfterStartDateTime = $False
                StartDateTime = '2023-04-15T23:00:00.0000000+00:00'
                DayofMonth = 1
                Recurrence = 'daily'
                DayofWeek = 'sunday'
            };
        }
    }
}
