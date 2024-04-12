[CmdletBinding()]
param(
)
$M365DSCTestFolder = Join-Path -Path $PSScriptRoot `
                        -ChildPath '..\..\Unit' `
                        -Resolve
$CmdletModule = (Join-Path -Path $M365DSCTestFolder `
            -ChildPath '\Stubs\Microsoft365.psm1' `
            -Resolve)
$GenericStubPath = (Join-Path -Path $M365DSCTestFolder `
    -ChildPath '\Stubs\Generic.psm1' `
    -Resolve)
Import-Module -Name (Join-Path -Path $M365DSCTestFolder `
        -ChildPath '\UnitTestHelper.psm1' `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "IntuneDeviceConfigurationKioskPolicyWindows10" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString "f@kepassword1" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Update-MgBetaDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName New-MgBetaDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName Remove-MgBetaDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false

            Mock -CommandName Get-MgBetaDeviceManagementDeviceConfigurationAssignment -MockWith {
            }
            Mock -CommandName Update-DeviceConfigurationPolicyAssignment -MockWith {
            }
        }
        # Test contexts
        Context -Name "The IntuneDeviceConfigurationKioskPolicyWindows10 should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    description = "FakeStringValue"
                    displayName = "FakeStringValue"
                    EdgeKioskEnablePublicBrowsing = $True
                    id = "FakeStringValue"
                    KioskBrowserBlockedUrlExceptions = @("FakeStringValue")
                    KioskBrowserBlockedURLs = @("FakeStringValue")
                    KioskBrowserDefaultUrl = "FakeStringValue"
                    KioskBrowserEnableEndSessionButton = $True
                    KioskBrowserEnableHomeButton = $True
                    KioskBrowserEnableNavigationButtons = $True
                    KioskBrowserRestartOnIdleTimeInMinutes = 25
                    kioskProfiles = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsKioskProfile -Property @{
                            profileId = "FakeStringValue"
                            userAccountsConfiguration = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsKioskUser -Property @{
                                    groupId = "FakeStringValue"
                                    userName = "FakeStringValue"
                                    userPrincipalName = "FakeStringValue"
                                    odataType = "#microsoft.graph.windowsKioskActiveDirectoryGroup"
                                    groupName = "FakeStringValue"
                                    userId = "FakeStringValue"
                                    displayName = "FakeStringValue"
                                } -ClientOnly)
                            )
                            profileName = "FakeStringValue"
                            appConfiguration = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsKioskAppConfiguration -Property @{
                                uwpApp = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsKioskUWPApp -Property @{
                                    edgeNoFirstRun = $True
                                    name = "FakeStringValue"
                                    edgeKiosk = "FakeStringValue"
                                    classicAppPath = "FakeStringValue"
                                    appId = "FakeStringValue"
                                    appUserModelId = "FakeStringValue"
                                    edgeKioskIdleTimeoutMinutes = 25
                                    autoLaunch = $True
                                    startLayoutTileSize = "hidden"
                                    appType = "unknown"
                                    edgeKioskType = "publicBrowsing"
                                    containedAppId = "FakeStringValue"
                                    desktopApplicationId = "FakeStringValue"
                                    desktopApplicationLinkPath = "FakeStringValue"
                                    path = "FakeStringValue"
                                    odataType = "#microsoft.graph.windowsKioskDesktopApp"
                                } -ClientOnly)
                                win32App = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsKioskWin32App -Property @{
                                    edgeNoFirstRun = $True
                                    name = "FakeStringValue"
                                    edgeKiosk = "FakeStringValue"
                                    classicAppPath = "FakeStringValue"
                                    edgeKioskIdleTimeoutMinutes = 25
                                    appUserModelId = "FakeStringValue"
                                    appId = "FakeStringValue"
                                    autoLaunch = $True
                                    startLayoutTileSize = "hidden"
                                    appType = "unknown"
                                    edgeKioskType = "publicBrowsing"
                                    containedAppId = "FakeStringValue"
                                    desktopApplicationId = "FakeStringValue"
                                    desktopApplicationLinkPath = "FakeStringValue"
                                    path = "FakeStringValue"
                                    odataType = "#microsoft.graph.windowsKioskDesktopApp"
                                } -ClientOnly)
                                apps = [CimInstance[]]@(
                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsKioskAppBase -Property @{
                                        edgeNoFirstRun = $True
                                        name = "FakeStringValue"
                                        edgeKiosk = "FakeStringValue"
                                        classicAppPath = "FakeStringValue"
                                        appId = "FakeStringValue"
                                        appUserModelId = "FakeStringValue"
                                        edgeKioskIdleTimeoutMinutes = 25
                                        autoLaunch = $True
                                        startLayoutTileSize = "hidden"
                                        appType = "unknown"
                                        edgeKioskType = "publicBrowsing"
                                        containedAppId = "FakeStringValue"
                                        desktopApplicationId = "FakeStringValue"
                                        desktopApplicationLinkPath = "FakeStringValue"
                                        path = "FakeStringValue"
                                        odataType = "#microsoft.graph.windowsKioskDesktopApp"
                                    } -ClientOnly)
                                )
                                allowAccessToDownloadsFolder = $True
                                showTaskBar = $True
                                disallowDesktopApps = $True
                                odataType = "#microsoft.graph.windowsKioskMultipleApps"
                                startMenuLayoutXml = $True
                            } -ClientOnly)
                        } -ClientOnly)
                    )
                    windowsKioskForceUpdateSchedule = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsKioskForceUpdateSchedule -Property @{
                        runImmediatelyIfAfterStartDateTime = $True
                        startDateTime = "2023-01-01T00:00:00.0000000+00:00"
                        dayofMonth = 25
                        recurrence = "none"
                        dayofWeek = "sunday"
                    } -ClientOnly)
                    Ensure = "Present"
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return $null
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should Create the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgBetaDeviceManagementDeviceConfiguration -Exactly 1
            }
        }

        Context -Name "The IntuneDeviceConfigurationKioskPolicyWindows10 exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    description = "FakeStringValue"
                    displayName = "FakeStringValue"
                    EdgeKioskEnablePublicBrowsing = $True
                    id = "FakeStringValue"
                    KioskBrowserBlockedUrlExceptions = @("FakeStringValue")
                    KioskBrowserBlockedURLs = @("FakeStringValue")
                    KioskBrowserDefaultUrl = "FakeStringValue"
                    KioskBrowserEnableEndSessionButton = $True
                    KioskBrowserEnableHomeButton = $True
                    KioskBrowserEnableNavigationButtons = $True
                    KioskBrowserRestartOnIdleTimeInMinutes = 25
                    kioskProfiles = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsKioskProfile -Property @{
                            profileId = "FakeStringValue"
                            userAccountsConfiguration = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsKioskUser -Property @{
                                    groupId = "FakeStringValue"
                                    userName = "FakeStringValue"
                                    userPrincipalName = "FakeStringValue"
                                    odataType = "#microsoft.graph.windowsKioskActiveDirectoryGroup"
                                    groupName = "FakeStringValue"
                                    userId = "FakeStringValue"
                                    displayName = "FakeStringValue"
                                } -ClientOnly)
                            )
                            profileName = "FakeStringValue"
                            appConfiguration = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsKioskAppConfiguration -Property @{
                                uwpApp = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsKioskUWPApp -Property @{
                                    edgeNoFirstRun = $True
                                    name = "FakeStringValue"
                                    edgeKiosk = "FakeStringValue"
                                    classicAppPath = "FakeStringValue"
                                    appId = "FakeStringValue"
                                    appUserModelId = "FakeStringValue"
                                    edgeKioskIdleTimeoutMinutes = 25
                                    autoLaunch = $True
                                    startLayoutTileSize = "hidden"
                                    appType = "unknown"
                                    edgeKioskType = "publicBrowsing"
                                    containedAppId = "FakeStringValue"
                                    desktopApplicationId = "FakeStringValue"
                                    desktopApplicationLinkPath = "FakeStringValue"
                                    path = "FakeStringValue"
                                    odataType = "#microsoft.graph.windowsKioskDesktopApp"
                                } -ClientOnly)
                                win32App = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsKioskWin32App -Property @{
                                    edgeNoFirstRun = $True
                                    name = "FakeStringValue"
                                    edgeKiosk = "FakeStringValue"
                                    classicAppPath = "FakeStringValue"
                                    edgeKioskIdleTimeoutMinutes = 25
                                    appUserModelId = "FakeStringValue"
                                    appId = "FakeStringValue"
                                    autoLaunch = $True
                                    startLayoutTileSize = "hidden"
                                    appType = "unknown"
                                    edgeKioskType = "publicBrowsing"
                                    containedAppId = "FakeStringValue"
                                    desktopApplicationId = "FakeStringValue"
                                    desktopApplicationLinkPath = "FakeStringValue"
                                    path = "FakeStringValue"
                                    odataType = "#microsoft.graph.windowsKioskDesktopApp"
                                } -ClientOnly)
                                apps = [CimInstance[]]@(
                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsKioskAppBase -Property @{
                                        edgeNoFirstRun = $True
                                        name = "FakeStringValue"
                                        edgeKiosk = "FakeStringValue"
                                        classicAppPath = "FakeStringValue"
                                        appId = "FakeStringValue"
                                        appUserModelId = "FakeStringValue"
                                        edgeKioskIdleTimeoutMinutes = 25
                                        autoLaunch = $True
                                        startLayoutTileSize = "hidden"
                                        appType = "unknown"
                                        edgeKioskType = "publicBrowsing"
                                        containedAppId = "FakeStringValue"
                                        desktopApplicationId = "FakeStringValue"
                                        desktopApplicationLinkPath = "FakeStringValue"
                                        path = "FakeStringValue"
                                        odataType = "#microsoft.graph.windowsKioskDesktopApp"
                                    } -ClientOnly)
                                )
                                allowAccessToDownloadsFolder = $True
                                showTaskBar = $True
                                disallowDesktopApps = $True
                                odataType = "#microsoft.graph.windowsKioskMultipleApps"
                                startMenuLayoutXml = $True
                            } -ClientOnly)
                        } -ClientOnly)
                    )
                    windowsKioskForceUpdateSchedule = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsKioskForceUpdateSchedule -Property @{
                        runImmediatelyIfAfterStartDateTime = $True
                        startDateTime = "2023-01-01T00:00:00.0000000+00:00"
                        dayofMonth = 25
                        recurrence = "none"
                        dayofWeek = "sunday"
                    } -ClientOnly)
                    Ensure = 'Absent'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            kioskBrowserBlockedURLs = @("FakeStringValue")
                            kioskBrowserDefaultUrl = "FakeStringValue"
                            '@odata.type' = "#microsoft.graph.windowsKioskConfiguration"
                            kioskBrowserEnableNavigationButtons = $True
                            edgeKioskEnablePublicBrowsing = $True
                            kioskBrowserRestartOnIdleTimeInMinutes = 25
                            kioskBrowserBlockedUrlExceptions = @("FakeStringValue")
                            kioskBrowserEnableHomeButton = $True
                            windowsKioskForceUpdateSchedule = @{
                                runImmediatelyIfAfterStartDateTime = $True
                                startDateTime = "2023-01-01T00:00:00.0000000+00:00"
                                dayofMonth = 25
                                recurrence = "none"
                                dayofWeek = "sunday"
                            }
                            kioskProfiles = @(
                                @{
                                    profileId = "FakeStringValue"
                                    userAccountsConfiguration = @(
                                        @{
                                            groupId = "FakeStringValue"
                                            '@odata.type' = "#microsoft.graph.windowsKioskActiveDirectoryGroup"
                                            userName = "FakeStringValue"
                                            userPrincipalName = "FakeStringValue"
                                            groupName = "FakeStringValue"
                                            userId = "FakeStringValue"
                                            displayName = "FakeStringValue"
                                        }
                                    )
                                    profileName = "FakeStringValue"
                                    appConfiguration = @{
                                        uwpApp = @{
                                            edgeNoFirstRun = $True
                                            name = "FakeStringValue"
                                            edgeKiosk = "FakeStringValue"
                                            classicAppPath = "FakeStringValue"
                                            appId = "FakeStringValue"
                                            appUserModelId = "FakeStringValue"
                                            edgeKioskIdleTimeoutMinutes = 25
                                            autoLaunch = $True
                                            startLayoutTileSize = "hidden"
                                            appType = "unknown"
                                            '@odata.type' = "#microsoft.graph.windowsKioskDesktopApp"
                                            edgeKioskType = "publicBrowsing"
                                            containedAppId = "FakeStringValue"
                                            desktopApplicationId = "FakeStringValue"
                                            desktopApplicationLinkPath = "FakeStringValue"
                                            path = "FakeStringValue"
                                        }
                                        win32App = @{
                                            edgeNoFirstRun = $True
                                            name = "FakeStringValue"
                                            edgeKiosk = "FakeStringValue"
                                            classicAppPath = "FakeStringValue"
                                            edgeKioskIdleTimeoutMinutes = 25
                                            appUserModelId = "FakeStringValue"
                                            appId = "FakeStringValue"
                                            autoLaunch = $True
                                            startLayoutTileSize = "hidden"
                                            appType = "unknown"
                                            '@odata.type' = "#microsoft.graph.windowsKioskDesktopApp"
                                            edgeKioskType = "publicBrowsing"
                                            containedAppId = "FakeStringValue"
                                            desktopApplicationId = "FakeStringValue"
                                            desktopApplicationLinkPath = "FakeStringValue"
                                            path = "FakeStringValue"
                                        }
                                        '@odata.type' = "#microsoft.graph.windowsKioskMultipleApps"
                                        apps = @(
                                            @{
                                                edgeNoFirstRun = $True
                                                name = "FakeStringValue"
                                                edgeKiosk = "FakeStringValue"
                                                classicAppPath = "FakeStringValue"
                                                appId = "FakeStringValue"
                                                appUserModelId = "FakeStringValue"
                                                edgeKioskIdleTimeoutMinutes = 25
                                                autoLaunch = $True
                                                startLayoutTileSize = "hidden"
                                                appType = "unknown"
                                                '@odata.type' = "#microsoft.graph.windowsKioskDesktopApp"
                                                edgeKioskType = "publicBrowsing"
                                                containedAppId = "FakeStringValue"
                                                desktopApplicationId = "FakeStringValue"
                                                desktopApplicationLinkPath = "FakeStringValue"
                                                path = "FakeStringValue"
                                            }
                                        )
                                        allowAccessToDownloadsFolder = $True
                                        showTaskBar = $True
                                        disallowDesktopApps = $True
                                        startMenuLayoutXml = $True
                                    }
                                }
                            )
                            kioskBrowserEnableEndSessionButton = $True
                        }
                        description = "FakeStringValue"
                        displayName = "FakeStringValue"
                        id = "FakeStringValue"

                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementDeviceConfiguration -Exactly 1
            }
        }
        Context -Name "The IntuneDeviceConfigurationKioskPolicyWindows10 Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    description = "FakeStringValue"
                    displayName = "FakeStringValue"
                    EdgeKioskEnablePublicBrowsing = $True
                    id = "FakeStringValue"
                    KioskBrowserBlockedUrlExceptions = @("FakeStringValue")
                    KioskBrowserBlockedURLs = @("FakeStringValue")
                    KioskBrowserDefaultUrl = "FakeStringValue"
                    KioskBrowserEnableEndSessionButton = $True
                    KioskBrowserEnableHomeButton = $True
                    KioskBrowserEnableNavigationButtons = $True
                    KioskBrowserRestartOnIdleTimeInMinutes = 25
                    kioskProfiles = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsKioskProfile -Property @{
                            profileId = "FakeStringValue"
                            userAccountsConfiguration = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsKioskUser -Property @{
                                    groupId = "FakeStringValue"
                                    userName = "FakeStringValue"
                                    userPrincipalName = "FakeStringValue"
                                    odataType = "#microsoft.graph.windowsKioskActiveDirectoryGroup"
                                    groupName = "FakeStringValue"
                                    userId = "FakeStringValue"
                                    displayName = "FakeStringValue"
                                } -ClientOnly)
                            )
                            profileName = "FakeStringValue"
                            appConfiguration = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsKioskAppConfiguration -Property @{
                                uwpApp = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsKioskUWPApp -Property @{
                                    edgeNoFirstRun = $True
                                    name = "FakeStringValue"
                                    edgeKiosk = "FakeStringValue"
                                    classicAppPath = "FakeStringValue"
                                    appId = "FakeStringValue"
                                    appUserModelId = "FakeStringValue"
                                    edgeKioskIdleTimeoutMinutes = 25
                                    autoLaunch = $True
                                    startLayoutTileSize = "hidden"
                                    appType = "unknown"
                                    edgeKioskType = "publicBrowsing"
                                    containedAppId = "FakeStringValue"
                                    desktopApplicationId = "FakeStringValue"
                                    desktopApplicationLinkPath = "FakeStringValue"
                                    path = "FakeStringValue"
                                    odataType = "#microsoft.graph.windowsKioskDesktopApp"
                                } -ClientOnly)
                                win32App = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsKioskWin32App -Property @{
                                    edgeNoFirstRun = $True
                                    name = "FakeStringValue"
                                    edgeKiosk = "FakeStringValue"
                                    classicAppPath = "FakeStringValue"
                                    edgeKioskIdleTimeoutMinutes = 25
                                    appUserModelId = "FakeStringValue"
                                    appId = "FakeStringValue"
                                    autoLaunch = $True
                                    startLayoutTileSize = "hidden"
                                    appType = "unknown"
                                    edgeKioskType = "publicBrowsing"
                                    containedAppId = "FakeStringValue"
                                    desktopApplicationId = "FakeStringValue"
                                    desktopApplicationLinkPath = "FakeStringValue"
                                    path = "FakeStringValue"
                                    odataType = "#microsoft.graph.windowsKioskDesktopApp"
                                } -ClientOnly)
                                apps = [CimInstance[]]@(
                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsKioskAppBase -Property @{
                                        edgeNoFirstRun = $True
                                        name = "FakeStringValue"
                                        edgeKiosk = "FakeStringValue"
                                        classicAppPath = "FakeStringValue"
                                        appId = "FakeStringValue"
                                        appUserModelId = "FakeStringValue"
                                        edgeKioskIdleTimeoutMinutes = 25
                                        autoLaunch = $True
                                        startLayoutTileSize = "hidden"
                                        appType = "unknown"
                                        edgeKioskType = "publicBrowsing"
                                        containedAppId = "FakeStringValue"
                                        desktopApplicationId = "FakeStringValue"
                                        desktopApplicationLinkPath = "FakeStringValue"
                                        path = "FakeStringValue"
                                        odataType = "#microsoft.graph.windowsKioskDesktopApp"
                                    } -ClientOnly)
                                )
                                allowAccessToDownloadsFolder = $True
                                showTaskBar = $True
                                disallowDesktopApps = $True
                                odataType = "#microsoft.graph.windowsKioskMultipleApps"
                                startMenuLayoutXml = $True
                            } -ClientOnly)
                        } -ClientOnly)
                    )
                    windowsKioskForceUpdateSchedule = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsKioskForceUpdateSchedule -Property @{
                        runImmediatelyIfAfterStartDateTime = $True
                        startDateTime = "2023-01-01T00:00:00.0000000+00:00"
                        dayofMonth = 25
                        recurrence = "none"
                        dayofWeek = "sunday"
                    } -ClientOnly)
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            kioskBrowserBlockedURLs = @("FakeStringValue")
                            kioskBrowserDefaultUrl = "FakeStringValue"
                            '@odata.type' = "#microsoft.graph.windowsKioskConfiguration"
                            kioskBrowserEnableNavigationButtons = $True
                            edgeKioskEnablePublicBrowsing = $True
                            kioskBrowserRestartOnIdleTimeInMinutes = 25
                            kioskBrowserBlockedUrlExceptions = @("FakeStringValue")
                            kioskBrowserEnableHomeButton = $True
                            windowsKioskForceUpdateSchedule = @{
                                runImmediatelyIfAfterStartDateTime = $True
                                startDateTime = "2023-01-01T00:00:00.0000000+00:00"
                                dayofMonth = 25
                                recurrence = "none"
                                dayofWeek = "sunday"
                            }
                            kioskProfiles = @(
                                @{
                                    profileId = "FakeStringValue"
                                    userAccountsConfiguration = @(
                                        @{
                                            groupId = "FakeStringValue"
                                            '@odata.type' = "#microsoft.graph.windowsKioskActiveDirectoryGroup"
                                            userName = "FakeStringValue"
                                            userPrincipalName = "FakeStringValue"
                                            groupName = "FakeStringValue"
                                            userId = "FakeStringValue"
                                            displayName = "FakeStringValue"
                                        }
                                    )
                                    profileName = "FakeStringValue"
                                    appConfiguration = @{
                                        uwpApp = @{
                                            edgeNoFirstRun = $True
                                            name = "FakeStringValue"
                                            edgeKiosk = "FakeStringValue"
                                            classicAppPath = "FakeStringValue"
                                            appId = "FakeStringValue"
                                            appUserModelId = "FakeStringValue"
                                            edgeKioskIdleTimeoutMinutes = 25
                                            autoLaunch = $True
                                            startLayoutTileSize = "hidden"
                                            appType = "unknown"
                                            '@odata.type' = "#microsoft.graph.windowsKioskDesktopApp"
                                            edgeKioskType = "publicBrowsing"
                                            containedAppId = "FakeStringValue"
                                            desktopApplicationId = "FakeStringValue"
                                            desktopApplicationLinkPath = "FakeStringValue"
                                            path = "FakeStringValue"
                                        }
                                        win32App = @{
                                            edgeNoFirstRun = $True
                                            name = "FakeStringValue"
                                            edgeKiosk = "FakeStringValue"
                                            classicAppPath = "FakeStringValue"
                                            edgeKioskIdleTimeoutMinutes = 25
                                            appUserModelId = "FakeStringValue"
                                            appId = "FakeStringValue"
                                            autoLaunch = $True
                                            startLayoutTileSize = "hidden"
                                            appType = "unknown"
                                            '@odata.type' = "#microsoft.graph.windowsKioskDesktopApp"
                                            edgeKioskType = "publicBrowsing"
                                            containedAppId = "FakeStringValue"
                                            desktopApplicationId = "FakeStringValue"
                                            desktopApplicationLinkPath = "FakeStringValue"
                                            path = "FakeStringValue"
                                        }
                                        '@odata.type' = "#microsoft.graph.windowsKioskMultipleApps"
                                        apps = @(
                                            @{
                                                edgeNoFirstRun = $True
                                                name = "FakeStringValue"
                                                edgeKiosk = "FakeStringValue"
                                                classicAppPath = "FakeStringValue"
                                                appId = "FakeStringValue"
                                                appUserModelId = "FakeStringValue"
                                                edgeKioskIdleTimeoutMinutes = 25
                                                autoLaunch = $True
                                                startLayoutTileSize = "hidden"
                                                appType = "unknown"
                                                '@odata.type' = "#microsoft.graph.windowsKioskDesktopApp"
                                                edgeKioskType = "publicBrowsing"
                                                containedAppId = "FakeStringValue"
                                                desktopApplicationId = "FakeStringValue"
                                                desktopApplicationLinkPath = "FakeStringValue"
                                                path = "FakeStringValue"
                                            }
                                        )
                                        allowAccessToDownloadsFolder = $True
                                        showTaskBar = $True
                                        disallowDesktopApps = $True
                                        startMenuLayoutXml = $True
                                    }
                                }
                            )
                            kioskBrowserEnableEndSessionButton = $True
                        }
                        description = "FakeStringValue"
                        displayName = "FakeStringValue"
                        id = "FakeStringValue"

                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The IntuneDeviceConfigurationKioskPolicyWindows10 exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    description = "FakeStringValue"
                    displayName = "FakeStringValue"
                    EdgeKioskEnablePublicBrowsing = $True
                    id = "FakeStringValue"
                    KioskBrowserBlockedUrlExceptions = @("FakeStringValue")
                    KioskBrowserBlockedURLs = @("FakeStringValue")
                    KioskBrowserDefaultUrl = "FakeStringValue"
                    KioskBrowserEnableEndSessionButton = $True
                    KioskBrowserEnableHomeButton = $True
                    KioskBrowserEnableNavigationButtons = $True
                    KioskBrowserRestartOnIdleTimeInMinutes = 25
                    kioskProfiles = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsKioskProfile -Property @{
                            profileId = "FakeStringValue"
                            userAccountsConfiguration = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsKioskUser -Property @{
                                    groupId = "FakeStringValue"
                                    userName = "FakeStringValue"
                                    userPrincipalName = "FakeStringValue"
                                    odataType = "#microsoft.graph.windowsKioskActiveDirectoryGroup"
                                    groupName = "FakeStringValue"
                                    userId = "FakeStringValue"
                                    displayName = "FakeStringValue"
                                } -ClientOnly)
                            )
                            profileName = "FakeStringValue"
                            appConfiguration = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsKioskAppConfiguration -Property @{
                                uwpApp = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsKioskUWPApp -Property @{
                                    edgeNoFirstRun = $True
                                    name = "FakeStringValue"
                                    edgeKiosk = "FakeStringValue"
                                    classicAppPath = "FakeStringValue"
                                    appId = "FakeStringValue"
                                    appUserModelId = "FakeStringValue"
                                    edgeKioskIdleTimeoutMinutes = 25
                                    autoLaunch = $True
                                    startLayoutTileSize = "hidden"
                                    appType = "unknown"
                                    edgeKioskType = "publicBrowsing"
                                    containedAppId = "FakeStringValue"
                                    desktopApplicationId = "FakeStringValue"
                                    desktopApplicationLinkPath = "FakeStringValue"
                                    path = "FakeStringValue"
                                    odataType = "#microsoft.graph.windowsKioskDesktopApp"
                                } -ClientOnly)
                                win32App = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsKioskWin32App -Property @{
                                    edgeNoFirstRun = $True
                                    name = "FakeStringValue"
                                    edgeKiosk = "FakeStringValue"
                                    classicAppPath = "FakeStringValue"
                                    edgeKioskIdleTimeoutMinutes = 25
                                    appUserModelId = "FakeStringValue"
                                    appId = "FakeStringValue"
                                    autoLaunch = $True
                                    startLayoutTileSize = "hidden"
                                    appType = "unknown"
                                    edgeKioskType = "publicBrowsing"
                                    containedAppId = "FakeStringValue"
                                    desktopApplicationId = "FakeStringValue"
                                    desktopApplicationLinkPath = "FakeStringValue"
                                    path = "FakeStringValue"
                                    odataType = "#microsoft.graph.windowsKioskDesktopApp"
                                } -ClientOnly)
                                apps = [CimInstance[]]@(
                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsKioskAppBase -Property @{
                                        edgeNoFirstRun = $True
                                        name = "FakeStringValue"
                                        edgeKiosk = "FakeStringValue"
                                        classicAppPath = "FakeStringValue"
                                        appId = "FakeStringValue"
                                        appUserModelId = "FakeStringValue"
                                        edgeKioskIdleTimeoutMinutes = 25
                                        autoLaunch = $True
                                        startLayoutTileSize = "hidden"
                                        appType = "unknown"
                                        edgeKioskType = "publicBrowsing"
                                        containedAppId = "FakeStringValue"
                                        desktopApplicationId = "FakeStringValue"
                                        desktopApplicationLinkPath = "FakeStringValue"
                                        path = "FakeStringValue"
                                        odataType = "#microsoft.graph.windowsKioskDesktopApp"
                                    } -ClientOnly)
                                )
                                allowAccessToDownloadsFolder = $True
                                showTaskBar = $True
                                disallowDesktopApps = $True
                                odataType = "#microsoft.graph.windowsKioskMultipleApps"
                                startMenuLayoutXml = $True
                            } -ClientOnly)
                        } -ClientOnly)
                    )
                    windowsKioskForceUpdateSchedule = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsKioskForceUpdateSchedule -Property @{
                        runImmediatelyIfAfterStartDateTime = $True
                        startDateTime = "2023-01-01T00:00:00.0000000+00:00"
                        dayofMonth = 25
                        recurrence = "none"
                        dayofWeek = "sunday"
                    } -ClientOnly)
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            kioskBrowserBlockedURLs = @("FakeStringValue")
                            kioskBrowserDefaultUrl = "FakeStringValue"
                            '@odata.type' = "#microsoft.graph.windowsKioskConfiguration"
                            kioskBrowserBlockedUrlExceptions = @("FakeStringValue")
                            kioskBrowserRestartOnIdleTimeInMinutes = 7
                            windowsKioskForceUpdateSchedule = @{
                                startDateTime = "2023-01-01T00:00:00.0000000+00:00"
                                dayofMonth = 7
                                recurrence = "none"
                                dayofWeek = "sunday"
                            }
                            kioskProfiles = @(
                                @{
                                    profileId = "FakeStringValue"
                                    userAccountsConfiguration = @(
                                        @{
                                            groupId = "FakeStringValue"
                                            '@odata.type' = "#microsoft.graph.windowsKioskActiveDirectoryGroup"
                                            userName = "FakeStringValue"
                                            userPrincipalName = "FakeStringValue"
                                            groupName = "FakeStringValue"
                                            userId = "FakeStringValue"
                                            displayName = "FakeStringValue"
                                        }
                                    )
                                    profileName = "FakeStringValue"
                                    appConfiguration = @{
                                        apps = @(
                                            @{
                                                name = "FakeStringValue"
                                                edgeKiosk = "FakeStringValue"
                                                classicAppPath = "FakeStringValue"
                                                appId = "FakeStringValue"
                                                appUserModelId = "FakeStringValue"
                                                edgeKioskIdleTimeoutMinutes = 7
                                                startLayoutTileSize = "hidden"
                                                appType = "unknown"
                                                '@odata.type' = "#microsoft.graph.windowsKioskDesktopApp"
                                                edgeKioskType = "publicBrowsing"
                                                containedAppId = "FakeStringValue"
                                                desktopApplicationId = "FakeStringValue"
                                                desktopApplicationLinkPath = "FakeStringValue"
                                                path = "FakeStringValue"
                                            }
                                        )
                                        uwpApp = @{
                                            name = "FakeStringValue"
                                            edgeKiosk = "FakeStringValue"
                                            classicAppPath = "FakeStringValue"
                                            appId = "FakeStringValue"
                                            appUserModelId = "FakeStringValue"
                                            edgeKioskIdleTimeoutMinutes = 7
                                            startLayoutTileSize = "hidden"
                                            appType = "unknown"
                                            '@odata.type' = "#microsoft.graph.windowsKioskDesktopApp"
                                            edgeKioskType = "publicBrowsing"
                                            containedAppId = "FakeStringValue"
                                            desktopApplicationId = "FakeStringValue"
                                            desktopApplicationLinkPath = "FakeStringValue"
                                            path = "FakeStringValue"
                                        }
                                        '@odata.type' = "#microsoft.graph.windowsKioskMultipleApps"
                                        win32App = @{
                                            name = "FakeStringValue"
                                            edgeKiosk = "FakeStringValue"
                                            classicAppPath = "FakeStringValue"
                                            appId = "FakeStringValue"
                                            appUserModelId = "FakeStringValue"
                                            edgeKioskIdleTimeoutMinutes = 7
                                            startLayoutTileSize = "hidden"
                                            appType = "unknown"
                                            '@odata.type' = "#microsoft.graph.windowsKioskDesktopApp"
                                            edgeKioskType = "publicBrowsing"
                                            containedAppId = "FakeStringValue"
                                            desktopApplicationId = "FakeStringValue"
                                            desktopApplicationLinkPath = "FakeStringValue"
                                            path = "FakeStringValue"
                                        }
                                    }
                                }
                            )
                        }
                        description = "FakeStringValue"
                        displayName = "FakeStringValue"
                        id = "FakeStringValue"
                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgBetaDeviceManagementDeviceConfiguration -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            kioskBrowserBlockedURLs = @("FakeStringValue")
                            kioskBrowserDefaultUrl = "FakeStringValue"
                            '@odata.type' = "#microsoft.graph.windowsKioskConfiguration"
                            kioskBrowserEnableNavigationButtons = $True
                            edgeKioskEnablePublicBrowsing = $True
                            kioskBrowserRestartOnIdleTimeInMinutes = 25
                            kioskBrowserBlockedUrlExceptions = @("FakeStringValue")
                            kioskBrowserEnableHomeButton = $True
                            windowsKioskForceUpdateSchedule = @{
                                runImmediatelyIfAfterStartDateTime = $True
                                startDateTime = "2023-01-01T00:00:00.0000000+00:00"
                                dayofMonth = 25
                                recurrence = "none"
                                dayofWeek = "sunday"
                            }
                            kioskProfiles = @(
                                @{
                                    profileId = "FakeStringValue"
                                    userAccountsConfiguration = @(
                                        @{
                                            groupId = "FakeStringValue"
                                            '@odata.type' = "#microsoft.graph.windowsKioskActiveDirectoryGroup"
                                            userName = "FakeStringValue"
                                            userPrincipalName = "FakeStringValue"
                                            groupName = "FakeStringValue"
                                            userId = "FakeStringValue"
                                            displayName = "FakeStringValue"
                                        }
                                    )
                                    profileName = "FakeStringValue"
                                    appConfiguration = @{
                                        uwpApp = @{
                                            edgeNoFirstRun = $True
                                            name = "FakeStringValue"
                                            edgeKiosk = "FakeStringValue"
                                            classicAppPath = "FakeStringValue"
                                            appId = "FakeStringValue"
                                            appUserModelId = "FakeStringValue"
                                            edgeKioskIdleTimeoutMinutes = 25
                                            autoLaunch = $True
                                            startLayoutTileSize = "hidden"
                                            appType = "unknown"
                                            '@odata.type' = "#microsoft.graph.windowsKioskDesktopApp"
                                            edgeKioskType = "publicBrowsing"
                                            containedAppId = "FakeStringValue"
                                            desktopApplicationId = "FakeStringValue"
                                            desktopApplicationLinkPath = "FakeStringValue"
                                            path = "FakeStringValue"
                                        }
                                        win32App = @{
                                            edgeNoFirstRun = $True
                                            name = "FakeStringValue"
                                            edgeKiosk = "FakeStringValue"
                                            classicAppPath = "FakeStringValue"
                                            edgeKioskIdleTimeoutMinutes = 25
                                            appUserModelId = "FakeStringValue"
                                            appId = "FakeStringValue"
                                            autoLaunch = $True
                                            startLayoutTileSize = "hidden"
                                            appType = "unknown"
                                            '@odata.type' = "#microsoft.graph.windowsKioskDesktopApp"
                                            edgeKioskType = "publicBrowsing"
                                            containedAppId = "FakeStringValue"
                                            desktopApplicationId = "FakeStringValue"
                                            desktopApplicationLinkPath = "FakeStringValue"
                                            path = "FakeStringValue"
                                        }
                                        '@odata.type' = "#microsoft.graph.windowsKioskMultipleApps"
                                        apps = @(
                                            @{
                                                edgeNoFirstRun = $True
                                                name = "FakeStringValue"
                                                edgeKiosk = "FakeStringValue"
                                                classicAppPath = "FakeStringValue"
                                                appId = "FakeStringValue"
                                                appUserModelId = "FakeStringValue"
                                                edgeKioskIdleTimeoutMinutes = 25
                                                autoLaunch = $True
                                                startLayoutTileSize = "hidden"
                                                appType = "unknown"
                                                '@odata.type' = "#microsoft.graph.windowsKioskDesktopApp"
                                                edgeKioskType = "publicBrowsing"
                                                containedAppId = "FakeStringValue"
                                                desktopApplicationId = "FakeStringValue"
                                                desktopApplicationLinkPath = "FakeStringValue"
                                                path = "FakeStringValue"
                                            }
                                        )
                                        allowAccessToDownloadsFolder = $True
                                        showTaskBar = $True
                                        disallowDesktopApps = $True
                                        startMenuLayoutXml = $True
                                    }
                                }
                            )
                            kioskBrowserEnableEndSessionButton = $True
                        }
                        description = "FakeStringValue"
                        displayName = "FakeStringValue"
                        id = "FakeStringValue"

                    }
                }
            }
            It 'Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
