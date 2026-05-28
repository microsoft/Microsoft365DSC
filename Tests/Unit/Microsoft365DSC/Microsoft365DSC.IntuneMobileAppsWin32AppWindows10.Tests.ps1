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
    -DscResource "IntuneMobileAppsWin32AppWindows10" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -ModuleName M365DSCUtil -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-MSCloudLoginConnectionProfile -MockWith {
            }

            Mock -CommandName Reset-MSCloudLoginConnectionProfileContext -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-DeviceAppManagementAppCategory -MockWith {
            }

            Mock -CommandName Update-DeviceAppManagementPolicyAssignment -MockWith {
            }

            Mock -CommandName Update-MgBetaDeviceAppManagementMobileApp -MockWith {
            }

            Mock -CommandName Invoke-M365DSCIntuneMobileAppInitialUpload -MockWith {
            }

            Mock -CommandName Invoke-MgGraphRequest -MockWith {
                return @{
                    '@odata.type' = "#microsoft.graph.win32LobApp"
                    allowedArchitectures = "x86,x64"
                    installCommandLine = "IntuneWinAppUtil.exe -s -t 0"
                    uninstallCommandLine = "IntuneWinAppUtil.exe -s -u -t 0"
                    fileName = "IntuneWinAppUtil.intunewin"
                    installExperience = @{
                        deviceRestartBehavior = "suppress"
                        maxRunTimeInMinutes = 60
                        runAsAccount = "system"
                    }
                    setupFilePath = "IntuneWinAppUtil.exe"
                    minimumSupportedOperatingSystem = @{
                        v8_0 = $False
                        v8_1 = $False
                        v10_0 = $False
                        v10_1607 = $True
                        v10_1703 = $False
                        v10_1709 = $False
                        v10_1803 = $False
                        v10_1809 = $False
                        v10_1903 = $False
                        v10_1909 = $False
                        v10_2004 = $False
                        v10_2H20 = $False
                        v10_21H1 = $False
                    }
                    minimumSupportedWindowsRelease = "1607"
                    msiInformation = @{
                        productCode = "{00000000-0000-0000-0000-000000000000}"
                        productVersion = "1.0.0.0"
                        upgradeCode = "{00000000-0000-0000-0000-000000000000}"
                        requiresReboot = $False
                        packageType = "dualPurpose"
                        productName = "IntuneWinAppUtil"
                        publisher = "FakeStringValue"
                    }
                    displayVersion = "1.0.0.0"
                    allowAvailableUninstall = $False
                    rules = @(
                        @{
                            '@odata.type' = "#microsoft.graph.win32LobAppFileSystemRule"
                            check32BitOn64System = $False
                            operationType = "version"
                            fileOrFolderName = "test.exe"
                            operator = "equal"
                            comparisonValue = "1.0.0.0"
                            path = "C:\Path"
                            ruleType = "detection"
                        }
                        @{
                            '@odata.type' = "#microsoft.graph.win32LobAppFileSystemRule"
                            check32BitOn64System = $False
                            operationType = "exists"
                            fileOrFolderName = "test.exe"
                            operator = "notConfigured"
                            path = "C:\Path"
                            ruleType = "requirement"
                        }
                    )
                    returnCodes = @(
                        @{
                            returnCode = 0
                            type = "success"
                        }
                    )
                    Categories = @(
                        @{
                            Id = "FakeStringValue"
                            DisplayName = "FakeStringValue"
                        }
                    )
                    CommittedContentVersion = "FakeStringValue"
                    DependentAppCount = 25
                    Description = "FakeStringValue"
                    Developer = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    Id = "FakeStringValue"
                    InformationUrl = "FakeStringValue"
                    IsFeatured = $True
                    LargeIcon = @{
                        Type = "FakeStringValue"
                        Value = "VGVzdA=="
                    }
                    Notes = "FakeStringValue"
                    Owner = "FakeStringValue"
                    PrivacyInformationUrl = "FakeStringValue"
                    Publisher = "FakeStringValue"
                    PublishingState = "notPublished"
                    RoleScopeTagIds = @("FakeStringValue")
                    SupersededAppCount = 25
                    SupersedingAppCount = 25
                    UploadState = 25
                }
            }

            Mock -CommandName Remove-MgBetaDeviceAppManagementMobileApp -MockWith {
            }

            Mock -CommandName Get-MgBetaDeviceAppManagementMobileApp -MockWith {
                return @{
                    '@odata.type' = "#microsoft.graph.win32LobApp"
                    allowedArchitectures = "x86,x64"
                    installCommandLine = "IntuneWinAppUtil.exe -s -t 0"
                    uninstallCommandLine = "IntuneWinAppUtil.exe -s -u -t 0"
                    installExperience = @{
                        deviceRestartBehavior = "suppress"
                        maxRunTimeInMinutes = 60
                        runAsAccount = "system"
                    }
                    fileName = "IntuneWinAppUtil.intunewin"
                    setupFilePath = "IntuneWinAppUtil.exe"
                    minimumSupportedOperatingSystem = @{
                        v8_0 = $False
                        v8_1 = $False
                        v10_0 = $False
                        v10_1607 = $True
                        v10_1703 = $False
                        v10_1709 = $False
                        v10_1803 = $False
                        v10_1809 = $False
                        v10_1903 = $False
                        v10_1909 = $False
                        v10_2004 = $False
                        v10_2H20 = $False
                        v10_21H1 = $False
                    }
                    minimumSupportedWindowsRelease = "1607"
                    msiInformation = @{
                        productCode = "{00000000-0000-0000-0000-000000000000}"
                        productVersion = "1.0.0.0"
                        upgradeCode = "{00000000-0000-0000-0000-000000000000}"
                        requiresReboot = $False
                        packageType = "dualPurpose"
                        productName = "IntuneWinAppUtil"
                        publisher = "FakeStringValue"
                    }
                    displayVersion = "1.0.0.0"
                    allowAvailableUninstall = $False
                    rules = @(
                        @{
                            '@odata.type' = "#microsoft.graph.win32LobAppFileSystemRule"
                            check32BitOn64System = $False
                            operationType = "version"
                            fileOrFolderName = "test.exe"
                            operator = "equal"
                            comparisonValue = "1.0.0.0"
                            path = "C:\Path"
                            ruleType = "detection"
                        }
                        @{
                            '@odata.type' = "#microsoft.graph.win32LobAppFileSystemRule"
                            check32BitOn64System = $False
                            operationType = "exists"
                            fileOrFolderName = "test.exe"
                            operator = "notConfigured"
                            path = "C:\Path"
                            ruleType = "requirement"
                        }
                    )
                    returnCodes = @(
                        @{
                            returnCode = 0
                            type = "success"
                        }
                    )
                    Categories = @(
                        @{
                            Id = "FakeStringValue"
                            DisplayName = "FakeStringValue"
                        }
                    )
                    CommittedContentVersion = "FakeStringValue"
                    DependentAppCount = 25
                    Description = "FakeStringValue"
                    Developer = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    Id = "FakeStringValue"
                    InformationUrl = "FakeStringValue"
                    IsFeatured = $True
                    LargeIcon = @{
                        Type = "FakeStringValue"
                        Value = "VGVzdA=="
                    }
                    Notes = "FakeStringValue"
                    Owner = "FakeStringValue"
                    PrivacyInformationUrl = "FakeStringValue"
                    Publisher = "FakeStringValue"
                    PublishingState = "notPublished"
                    RoleScopeTagIds = @("FakeStringValue")
                    SupersededAppCount = 25
                    SupersedingAppCount = 25
                    UploadState = 25
                }
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            # Mock Write-M365DSCHost to hide output during the tests
            Mock -CommandName Write-M365DSCHost -MockWith {
            }
            $Script:exportedInstance = $null
            $Script:ExportMode = $false

            Mock -CommandName Get-MgBetaDeviceAppManagementMobileAppAssignment -MockWith {
                return @(
                    @{
                        Id = "12345-12345-12345-12345-12345"
                        Intent = "required"
                        Source = "direct"
                        SourceId = "12345-12345-12345-12345-12345"
                        Target = @{
                            "@odata.type" = "#microsoft.graph.groupAssignmentTarget"
                            groupId = "26d60dd1-fab6-47bf-8656-358194c1a49d"
                            "deviceAndAppManagementAssignmentFilterId" = '12345-12345-12345-12345-12345'
                            "deviceAndAppManagementAssignmentFilterType" = "none"
                        }
                        Settings = @{
                            "@odata.type" = "#microsoft.graph.win32LobAppAssignmentSettings"
                            notifications = "showAll"
                            deliveryOptimizationPriority = "notConfigured"
                            restartSettings = @{
                                gracePeriodInMinutes = 1440
                                countdownDisplayBeforeRestartInMinutes = 15
                                restartNotificationSnoozeDurationInMinutes = 240
                            }
                        }
                    }
                )
            }
        }

        # Test contexts
        Context -Name "The IntuneMobileAppsWin32AppWindows10 should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowedArchitectures = @("x86", "x64")
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementWin32MobileAppAssignment -Property @{
                            Id = "12345-12345-12345-12345-12345"
                            Intent = "required"
                            DeviceAndAppManagementAssignmentFilterType = "none"
                            GroupId = "26d60dd1-fab6-47bf-8656-358194c1a49d"
                            DataType = "#microsoft.graph.groupAssignmentTarget"
                            assignmentSettings = (New-CimInstance -ClassName MSFT_DeviceManagementWin32MobileAppAssignmentSettings -Property @{
                                Notifications = "showAll"
                                DeliveryOptimizationPriority = "notConfigured"
                                RestartSettings = (New-CimInstance -ClassName MSFT_DeviceManagementWin32MobileAppAssignmentSettingsRestartSettings -Property @{
                                    GracePeriodInMinutes = 1440
                                    CountdownDisplayBeforeRestartInMinutes = 15
                                    RestartNotificationSnoozeDurationInMinutes = 240
                                } -ClientOnly)
                            } -ClientOnly)
                        } -ClientOnly)
                    )
                    Categories = [CimInstance[]]@((New-CimInstance -ClassName MSFT_DeviceManagementMobileAppCategory -Property @{
                        Id = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                    } -ClientOnly))
                    InstallExperience = (New-CimInstance -ClassName MSFT_MicrosoftGraphWin32LobAppInstallExperience -Property @{
                        DeviceRestartBehavior = "suppress"
                        MaxRunTimeInMinutes = 60
                        RunAsAccountType = "system"
                    } -ClientOnly)
                    MsiInformation = (New-CimInstance -ClassName MSFT_MicrosoftGraphWin32LobAppMsiInformation -Property @{
                        ProductCode = "{00000000-0000-0000-0000-000000000000}"
                        ProductVersion = "1.0.0.0"
                        UpgradeCode = "{00000000-0000-0000-0000-000000000000}"
                        RequiresReboot = $False
                        PackageType = "dualPurpose"
                        ProductName = "IntuneWinAppUtil"
                        Publisher = "FakeStringValue"
                    } -ClientOnly)
                    Rules = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphWin32LobAppRule -Property @{
                            Path = "C:\Path"
                            FileOrFolderName = "test.exe"
                            OdataType = "FileSystem"
                            RuleType = "requirement"
                            FileSystemOperationType = "exists"
                            Operator = "notConfigured"
                            Check32BitOn64System = $False
                        } -ClientOnly)
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphWin32LobAppRule -Property @{
                            Path = "C:\Path"
                            FileOrFolderName = "test.exe"
                            OdataType = "FileSystem"
                            RuleType = "detection"
                            FileSystemOperationType = "version"
                            Operator = "equal"
                            ComparisonValue = "1.0.0.0"
                        } -ClientOnly)
                    )
                    ReturnCodes = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphWin32LobAppReturnCode -Property @{
                            ReturnCode = 0
                            Type = "success"
                        } -ClientOnly)
                    )
                    InstallCommandLine = "IntuneWinAppUtil.exe -s -t 0"
                    UninstallCommandLine = "IntuneWinAppUtil.exe -s -u -t 0"
                    FileName = "IntuneWinAppUtil.intunewin"
                    SetupFilePath = "IntuneWinAppUtil.exe"
                    Description = "FakeStringValue"
                    Developer = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    Id = "FakeStringValue"
                    InformationUrl = "FakeStringValue"
                    IsFeatured = $True
                    LargeIcon = (New-CimInstance -ClassName MSFT_MicrosoftGraphmimeContent -Property @{
                        Type = "FakeStringValue"
                        Value = "VGVzdA==" # Base64 encoded string for "Test"
                    } -ClientOnly)
                    Notes = "FakeStringValue"
                    Owner = "FakeStringValue"
                    PrivacyInformationUrl = "FakeStringValue"
                    Publisher = "FakeStringValue"
                    RoleScopeTagIds = @("FakeStringValue")
                    Ensure = "Present"
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceAppManagementMobileApp -MockWith {
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
                Should -Invoke -CommandName Invoke-MgGraphRequest -Exactly 1
            }
        }

        Context -Name "The IntuneMobileAppsWin32AppWindows10 exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowedArchitectures = @("x86", "x64")
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementWin32MobileAppAssignment -Property @{
                            Id = "12345-12345-12345-12345-12345"
                            Intent = "required"
                            DeviceAndAppManagementAssignmentFilterType = "none"
                            GroupId = "26d60dd1-fab6-47bf-8656-358194c1a49d"
                            DataType = "#microsoft.graph.groupAssignmentTarget"
                            assignmentSettings = (New-CimInstance -ClassName MSFT_DeviceManagementWin32MobileAppAssignmentSettings -Property @{
                                Notifications = "showAll"
                                DeliveryOptimizationPriority = "notConfigured"
                                RestartSettings = (New-CimInstance -ClassName MSFT_DeviceManagementWin32MobileAppAssignmentSettingsRestartSettings -Property @{
                                    GracePeriodInMinutes = 1440
                                    CountdownDisplayBeforeRestartInMinutes = 15
                                    RestartNotificationSnoozeDurationInMinutes = 240
                                } -ClientOnly)
                            } -ClientOnly)
                        } -ClientOnly)
                    )
                    Categories = [CimInstance[]]@((New-CimInstance -ClassName MSFT_DeviceManagementMobileAppCategory -Property @{
                        Id = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                    } -ClientOnly))
                    InstallExperience = (New-CimInstance -ClassName MSFT_MicrosoftGraphWin32LobAppInstallExperience -Property @{
                        DeviceRestartBehavior = "suppress"
                        MaxRunTimeInMinutes = 60
                        RunAsAccountType = "system"
                    } -ClientOnly)
                    MsiInformation = (New-CimInstance -ClassName MSFT_MicrosoftGraphWin32LobAppMsiInformation -Property @{
                        ProductCode = "{00000000-0000-0000-0000-000000000000}"
                        ProductVersion = "1.0.0.0"
                        UpgradeCode = "{00000000-0000-0000-0000-000000000000}"
                        RequiresReboot = $False
                        PackageType = "dualPurpose"
                        ProductName = "IntuneWinAppUtil"
                        Publisher = "FakeStringValue"
                    } -ClientOnly)
                    Rules = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphWin32LobAppRule -Property @{
                            Path = "C:\Path"
                            FileOrFolderName = "test.exe"
                            OdataType = "FileSystem"
                            RuleType = "requirement"
                            FileSystemOperationType = "exists"
                            Operator = "notConfigured"
                            Check32BitOn64System = $False
                        } -ClientOnly)
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphWin32LobAppRule -Property @{
                            Path = "C:\Path"
                            FileOrFolderName = "test.exe"
                            OdataType = "FileSystem"
                            RuleType = "detection"
                            FileSystemOperationType = "version"
                            Operator = "equal"
                            ComparisonValue = "1.0.0.0"
                        } -ClientOnly)
                    )
                    ReturnCodes = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphWin32LobAppReturnCode -Property @{
                            ReturnCode = 0
                            Type = "success"
                        } -ClientOnly)
                    )
                    InstallCommandLine = "IntuneWinAppUtil.exe -s -t 0"
                    UninstallCommandLine = "IntuneWinAppUtil.exe -s -u -t 0"
                    FileName = "IntuneWinAppUtil.intunewin"
                    SetupFilePath = "IntuneWinAppUtil.exe"
                    Description = "FakeStringValue"
                    Developer = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    Id = "FakeStringValue"
                    InformationUrl = "FakeStringValue"
                    IsFeatured = $True
                    LargeIcon = (New-CimInstance -ClassName MSFT_MicrosoftGraphmimeContent -Property @{
                        Type = "FakeStringValue"
                        Value = "VGVzdA==" # Base64 encoded string for "Test"
                    } -ClientOnly)
                    Notes = "FakeStringValue"
                    Owner = "FakeStringValue"
                    PrivacyInformationUrl = "FakeStringValue"
                    Publisher = "FakeStringValue"
                    RoleScopeTagIds = @("FakeStringValue")
                    Ensure = "Absent"
                    Credential = $Credential;
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgBetaDeviceAppManagementMobileApp -Exactly 1
            }
        }

        Context -Name "The IntuneMobileAppsWin32AppWindows10 Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowedArchitectures = @("x86", "x64")
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementWin32MobileAppAssignment -Property @{
                            Id = "12345-12345-12345-12345-12345"
                            Intent = "required"
                            DeviceAndAppManagementAssignmentFilterType = "none"
                            GroupId = "26d60dd1-fab6-47bf-8656-358194c1a49d"
                            DataType = "#microsoft.graph.groupAssignmentTarget"
                            assignmentSettings = (New-CimInstance -ClassName MSFT_DeviceManagementWin32MobileAppAssignmentSettings -Property @{
                                Notifications = "showAll"
                                DeliveryOptimizationPriority = "notConfigured"
                                RestartSettings = (New-CimInstance -ClassName MSFT_DeviceManagementWin32MobileAppAssignmentSettingsRestartSettings -Property @{
                                    GracePeriodInMinutes = 1440
                                    CountdownDisplayBeforeRestartInMinutes = 15
                                    RestartNotificationSnoozeDurationInMinutes = 240
                                } -ClientOnly)
                            } -ClientOnly)
                        } -ClientOnly)
                    )
                    Categories = [CimInstance[]]@((New-CimInstance -ClassName MSFT_DeviceManagementMobileAppCategory -Property @{
                        Id = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                    } -ClientOnly))
                    InstallExperience = (New-CimInstance -ClassName MSFT_MicrosoftGraphWin32LobAppInstallExperience -Property @{
                        DeviceRestartBehavior = "suppress"
                        MaxRunTimeInMinutes = 60
                        RunAsAccountType = "system"
                    } -ClientOnly)
                    MsiInformation = (New-CimInstance -ClassName MSFT_MicrosoftGraphWin32LobAppMsiInformation -Property @{
                        ProductCode = "{00000000-0000-0000-0000-000000000000}"
                        ProductVersion = "1.0.0.0"
                        UpgradeCode = "{00000000-0000-0000-0000-000000000000}"
                        RequiresReboot = $False
                        PackageType = "dualPurpose"
                        ProductName = "IntuneWinAppUtil"
                        Publisher = "FakeStringValue"
                    } -ClientOnly)
                    Rules = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphWin32LobAppRule -Property @{
                            Path = "C:\Path"
                            FileOrFolderName = "test.exe"
                            OdataType = "FileSystem"
                            RuleType = "requirement"
                            FileSystemOperationType = "exists"
                            Operator = "notConfigured"
                            Check32BitOn64System = $False
                        } -ClientOnly)
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphWin32LobAppRule -Property @{
                            Path = "C:\Path"
                            FileOrFolderName = "test.exe"
                            OdataType = "FileSystem"
                            RuleType = "detection"
                            FileSystemOperationType = "version"
                            Operator = "equal"
                            ComparisonValue = "1.0.0.0"
                        } -ClientOnly)
                    )
                    ReturnCodes = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphWin32LobAppReturnCode -Property @{
                            ReturnCode = 0
                            Type = "success"
                        } -ClientOnly)
                    )
                    InstallCommandLine = "IntuneWinAppUtil.exe -s -t 0"
                    UninstallCommandLine = "IntuneWinAppUtil.exe -s -u -t 0"
                    FileName = "IntuneWinAppUtil.intunewin"
                    SetupFilePath = "IntuneWinAppUtil.exe"
                    Description = "FakeStringValue"
                    Developer = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    Id = "FakeStringValue"
                    InformationUrl = "FakeStringValue"
                    IsFeatured = $True
                    LargeIcon = (New-CimInstance -ClassName MSFT_MicrosoftGraphmimeContent -Property @{
                        Type = "FakeStringValue"
                        Value = "VGVzdA==" # Base64 encoded string for "Test"
                    } -ClientOnly)
                    Notes = "FakeStringValue"
                    Owner = "FakeStringValue"
                    PrivacyInformationUrl = "FakeStringValue"
                    Publisher = "FakeStringValue"
                    RoleScopeTagIds = @("FakeStringValue")
                    Ensure = "Present"
                    Credential = $Credential;
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The IntuneMobileAppsWin32AppWindows10 exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowedArchitectures = @("x86", "x64")
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementWin32MobileAppAssignment -Property @{
                            Id = "12345-12345-12345-12345-12345"
                            Intent = "required"
                            DeviceAndAppManagementAssignmentFilterType = "none"
                            GroupId = "26d60dd1-fab6-47bf-8656-358194c1a49d"
                            DataType = "#microsoft.graph.groupAssignmentTarget"
                            assignmentSettings = (New-CimInstance -ClassName MSFT_DeviceManagementWin32MobileAppAssignmentSettings -Property @{
                                Notifications = "showAll"
                                DeliveryOptimizationPriority = "notConfigured"
                                RestartSettings = (New-CimInstance -ClassName MSFT_DeviceManagementWin32MobileAppAssignmentSettingsRestartSettings -Property @{
                                    GracePeriodInMinutes = 1440
                                    CountdownDisplayBeforeRestartInMinutes = 30 # Drift
                                    RestartNotificationSnoozeDurationInMinutes = 240
                                } -ClientOnly)
                            } -ClientOnly)
                        } -ClientOnly)
                    )
                    Categories = [CimInstance[]]@((New-CimInstance -ClassName MSFT_DeviceManagementMobileAppCategory -Property @{
                        Id = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                    } -ClientOnly))
                    InstallExperience = (New-CimInstance -ClassName MSFT_MicrosoftGraphWin32LobAppInstallExperience -Property @{
                        DeviceRestartBehavior = "suppress"
                        MaxRunTimeInMinutes = 60
                        RunAsAccountType = "system"
                    } -ClientOnly)
                    MsiInformation = (New-CimInstance -ClassName MSFT_MicrosoftGraphWin32LobAppMsiInformation -Property @{
                        ProductCode = "{00000000-0000-0000-0000-000000000000}"
                        ProductVersion = "1.0.0.0"
                        UpgradeCode = "{00000000-0000-0000-0000-000000000000}"
                        RequiresReboot = $False
                        PackageType = "dualPurpose"
                        ProductName = "IntuneWinAppUtil"
                        Publisher = "FakeStringValue"
                    } -ClientOnly)
                    Rules = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphWin32LobAppRule -Property @{
                            Path = "C:\Path"
                            FileOrFolderName = "test.exe"
                            OdataType = "FileSystem"
                            RuleType = "requirement"
                            FileSystemOperationType = "exists"
                            Operator = "notConfigured"
                            Check32BitOn64System = $False
                        } -ClientOnly)
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphWin32LobAppRule -Property @{
                            Path = "C:\Path"
                            FileOrFolderName = "test.exe"
                            OdataType = "FileSystem"
                            RuleType = "detection"
                            FileSystemOperationType = "version"
                            Operator = "equal"
                            ComparisonValue = "1.0.0.0"
                        } -ClientOnly)
                    )
                    ReturnCodes = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphWin32LobAppReturnCode -Property @{
                            ReturnCode = 0
                            Type = "success"
                        } -ClientOnly)
                    )
                    InstallCommandLine = "IntuneWinAppUtil.exe -s -t 0"
                    UninstallCommandLine = "IntuneWinAppUtil.exe -s -u -t 0"
                    FileName = "IntuneWinAppUtil.intunewin"
                    SetupFilePath = "IntuneWinAppUtil.exe"
                    Description = "FakeStringValue"
                    Developer = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    Id = "FakeStringValue"
                    InformationUrl = "FakeStringValue"
                    IsFeatured = $True
                    LargeIcon = (New-CimInstance -ClassName MSFT_MicrosoftGraphmimeContent -Property @{
                        Type = "FakeStringValue"
                        Value = "VGVzdA==" # Base64 encoded string for "Test"
                    } -ClientOnly)
                    Notes = "FakeStringValue"
                    Owner = "FakeStringValue"
                    PrivacyInformationUrl = "FakeStringValue"
                    Publisher = "FakeStringValue"
                    RoleScopeTagIds = @("FakeStringValue")
                    Ensure = "Present"
                    Credential = $Credential;
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
                Should -Invoke -CommandName Invoke-MgGraphRequest -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
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
