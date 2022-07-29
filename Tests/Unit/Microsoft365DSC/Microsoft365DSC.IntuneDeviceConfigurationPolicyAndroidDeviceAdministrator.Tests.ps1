[CmdletBinding()]
param(
)
$M365DSCTestFolder = Join-Path -Path $PSScriptRoot `
                        -ChildPath "..\..\Unit" `
                        -Resolve
$CmdletModule = (Join-Path -Path $M365DSCTestFolder `
            -ChildPath "\Stubs\Microsoft365.psm1" `
            -Resolve)
$GenericStubPath = (Join-Path -Path $M365DSCTestFolder `
    -ChildPath "\Stubs\Generic.psm1" `
    -Resolve)
Import-Module -Name (Join-Path -Path $M365DSCTestFolder `
        -ChildPath "\UnitTestHelper.psm1" `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "IntuneDeviceConfigurationPolicyAndroidDeviceAdministrator" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)


            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {
            }

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName New-MgDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName Remove-MgDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }
        }
        # Test contexts
        Context -Name "The IntuneDeviceConfigurationPolicyAndroidDeviceAdministrator should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                        AppsBlockClipboardSharing = $True
                        AppsBlockCopyPaste = $True
                        AppsBlockYouTube = $True
                        BluetoothBlocked = $True
                        CameraBlocked = $True
                        CellularBlockDataRoaming = $True
                        CellularBlockMessaging = $True
                        CellularBlockVoiceRoaming = $True
                        CellularBlockWiFiTethering = $True
                        CompliantAppListType = "none"
                        DateAndTimeBlockChanges = $True
                        Description = "FakeStringValue"
                        DeviceSharingAllowed = $True
                        DiagnosticDataBlockSubmission = $True
                        DisplayName = "FakeStringValue"
                        FactoryResetBlocked = $True
                        GoogleAccountBlockAutoSync = $True
                        GooglePlayStoreBlocked = $True
                        Id = "FakeStringValue"
                        KioskModeBlockSleepButton = $True
                        KioskModeBlockVolumeButtons = $True
                        LocationServicesBlocked = $True
                        NfcBlocked = $True
                        PasswordBlockFingerprintUnlock = $True
                        PasswordBlockTrustAgents = $True
                        PasswordExpirationDays = 25
                        PasswordMinimumLength = 25
                        PasswordMinutesOfInactivityBeforeScreenTimeout = 25
                        PasswordPreviousPasswordBlockCount = 25
                        PasswordRequired = $True
                        PasswordRequiredType = "deviceDefault"
                        PasswordSignInFailureCountBeforeFactoryReset = 25
                        PowerOffBlocked = $True
                        RequiredPasswordComplexity = "none"
                        ScreenCaptureBlocked = $True
                        SecurityRequireVerifyApps = $True
                        StorageBlockGoogleBackup = $True
                        StorageBlockRemovableStorage = $True
                        StorageRequireDeviceEncryption = $True
                        StorageRequireRemovableStorageEncryption = $True
                        VoiceAssistantBlocked = $True
                        VoiceDialingBlocked = $True
                        WebBrowserBlockAutofill = $True
                        WebBrowserBlocked = $True
                        WebBrowserBlockJavaScript = $True
                        WebBrowserBlockPopups = $True
                        WebBrowserCookieSettings = "browserDefault"
                        WiFiBlocked = $True

                    Ensure                        = "Present"
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return $null
                }
            }
            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should Create the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgDeviceManagementDeviceConfiguration -Exactly 1
            }
        }

        Context -Name "The IntuneDeviceConfigurationPolicyAndroidDeviceAdministrator exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                        AppsBlockClipboardSharing = $True
                        AppsBlockCopyPaste = $True
                        AppsBlockYouTube = $True
                        BluetoothBlocked = $True
                        CameraBlocked = $True
                        CellularBlockDataRoaming = $True
                        CellularBlockMessaging = $True
                        CellularBlockVoiceRoaming = $True
                        CellularBlockWiFiTethering = $True
                        CompliantAppListType = "none"
                        DateAndTimeBlockChanges = $True
                        Description = "FakeStringValue"
                        DeviceSharingAllowed = $True
                        DiagnosticDataBlockSubmission = $True
                        DisplayName = "FakeStringValue"
                        FactoryResetBlocked = $True
                        GoogleAccountBlockAutoSync = $True
                        GooglePlayStoreBlocked = $True
                        Id = "FakeStringValue"
                        KioskModeBlockSleepButton = $True
                        KioskModeBlockVolumeButtons = $True
                        LocationServicesBlocked = $True
                        NfcBlocked = $True
                        PasswordBlockFingerprintUnlock = $True
                        PasswordBlockTrustAgents = $True
                        PasswordExpirationDays = 25
                        PasswordMinimumLength = 25
                        PasswordMinutesOfInactivityBeforeScreenTimeout = 25
                        PasswordPreviousPasswordBlockCount = 25
                        PasswordRequired = $True
                        PasswordRequiredType = "deviceDefault"
                        PasswordSignInFailureCountBeforeFactoryReset = 25
                        PowerOffBlocked = $True
                        RequiredPasswordComplexity = "none"
                        ScreenCaptureBlocked = $True
                        SecurityRequireVerifyApps = $True
                        StorageBlockGoogleBackup = $True
                        StorageBlockRemovableStorage = $True
                        StorageRequireDeviceEncryption = $True
                        StorageRequireRemovableStorageEncryption = $True
                        VoiceAssistantBlocked = $True
                        VoiceDialingBlocked = $True
                        WebBrowserBlockAutofill = $True
                        WebBrowserBlocked = $True
                        WebBrowserBlockJavaScript = $True
                        WebBrowserBlockPopups = $True
                        WebBrowserCookieSettings = "browserDefault"
                        WiFiBlocked = $True

                    Ensure                        = "Absent"
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AppsBlockClipboardSharing = $True
                        AppsBlockCopyPaste = $True
                        AppsBlockYouTube = $True
                        BluetoothBlocked = $True
                        CameraBlocked = $True
                        CellularBlockDataRoaming = $True
                        CellularBlockMessaging = $True
                        CellularBlockVoiceRoaming = $True
                        CellularBlockWiFiTethering = $True
                        CompliantAppListType = "none"
                        DateAndTimeBlockChanges = $True
                        Description = "FakeStringValue"
                        DeviceSharingAllowed = $True
                        DiagnosticDataBlockSubmission = $True
                        DisplayName = "FakeStringValue"
                        FactoryResetBlocked = $True
                        GoogleAccountBlockAutoSync = $True
                        GooglePlayStoreBlocked = $True
                        Id = "FakeStringValue"
                        KioskModeBlockSleepButton = $True
                        KioskModeBlockVolumeButtons = $True
                        LocationServicesBlocked = $True
                        NfcBlocked = $True
                        PasswordBlockFingerprintUnlock = $True
                        PasswordBlockTrustAgents = $True
                        PasswordExpirationDays = 25
                        PasswordMinimumLength = 25
                        PasswordMinutesOfInactivityBeforeScreenTimeout = 25
                        PasswordPreviousPasswordBlockCount = 25
                        PasswordRequired = $True
                        PasswordRequiredType = "deviceDefault"
                        PasswordSignInFailureCountBeforeFactoryReset = 25
                        PowerOffBlocked = $True
                        RequiredPasswordComplexity = "none"
                        ScreenCaptureBlocked = $True
                        SecurityRequireVerifyApps = $True
                        StorageBlockGoogleBackup = $True
                        StorageBlockRemovableStorage = $True
                        StorageRequireDeviceEncryption = $True
                        StorageRequireRemovableStorageEncryption = $True
                        VoiceAssistantBlocked = $True
                        VoiceDialingBlocked = $True
                        WebBrowserBlockAutofill = $True
                        WebBrowserBlocked = $True
                        WebBrowserBlockJavaScript = $True
                        WebBrowserBlockPopups = $True
                        WebBrowserCookieSettings = "browserDefault"
                        WiFiBlocked = $True

                    }
                }
            }

            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgDeviceManagementDeviceConfiguration -Exactly 1
            }
        }
        Context -Name "The IntuneDeviceConfigurationPolicyAndroidDeviceAdministrator Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                        AppsBlockClipboardSharing = $True
                        AppsBlockCopyPaste = $True
                        AppsBlockYouTube = $True
                        BluetoothBlocked = $True
                        CameraBlocked = $True
                        CellularBlockDataRoaming = $True
                        CellularBlockMessaging = $True
                        CellularBlockVoiceRoaming = $True
                        CellularBlockWiFiTethering = $True
                        CompliantAppListType = "none"
                        DateAndTimeBlockChanges = $True
                        Description = "FakeStringValue"
                        DeviceSharingAllowed = $True
                        DiagnosticDataBlockSubmission = $True
                        DisplayName = "FakeStringValue"
                        FactoryResetBlocked = $True
                        GoogleAccountBlockAutoSync = $True
                        GooglePlayStoreBlocked = $True
                        Id = "FakeStringValue"
                        KioskModeBlockSleepButton = $True
                        KioskModeBlockVolumeButtons = $True
                        LocationServicesBlocked = $True
                        NfcBlocked = $True
                        PasswordBlockFingerprintUnlock = $True
                        PasswordBlockTrustAgents = $True
                        PasswordExpirationDays = 25
                        PasswordMinimumLength = 25
                        PasswordMinutesOfInactivityBeforeScreenTimeout = 25
                        PasswordPreviousPasswordBlockCount = 25
                        PasswordRequired = $True
                        PasswordRequiredType = "deviceDefault"
                        PasswordSignInFailureCountBeforeFactoryReset = 25
                        PowerOffBlocked = $True
                        RequiredPasswordComplexity = "none"
                        ScreenCaptureBlocked = $True
                        SecurityRequireVerifyApps = $True
                        StorageBlockGoogleBackup = $True
                        StorageBlockRemovableStorage = $True
                        StorageRequireDeviceEncryption = $True
                        StorageRequireRemovableStorageEncryption = $True
                        VoiceAssistantBlocked = $True
                        VoiceDialingBlocked = $True
                        WebBrowserBlockAutofill = $True
                        WebBrowserBlocked = $True
                        WebBrowserBlockJavaScript = $True
                        WebBrowserBlockPopups = $True
                        WebBrowserCookieSettings = "browserDefault"
                        WiFiBlocked = $True

                    Ensure                        = "Present"
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AppsBlockClipboardSharing = $True
                        AppsBlockCopyPaste = $True
                        AppsBlockYouTube = $True
                        BluetoothBlocked = $True
                        CameraBlocked = $True
                        CellularBlockDataRoaming = $True
                        CellularBlockMessaging = $True
                        CellularBlockVoiceRoaming = $True
                        CellularBlockWiFiTethering = $True
                        CompliantAppListType = "none"
                        DateAndTimeBlockChanges = $True
                        Description = "FakeStringValue"
                        DeviceSharingAllowed = $True
                        DiagnosticDataBlockSubmission = $True
                        DisplayName = "FakeStringValue"
                        FactoryResetBlocked = $True
                        GoogleAccountBlockAutoSync = $True
                        GooglePlayStoreBlocked = $True
                        Id = "FakeStringValue"
                        KioskModeBlockSleepButton = $True
                        KioskModeBlockVolumeButtons = $True
                        LocationServicesBlocked = $True
                        NfcBlocked = $True
                        PasswordBlockFingerprintUnlock = $True
                        PasswordBlockTrustAgents = $True
                        PasswordExpirationDays = 25
                        PasswordMinimumLength = 25
                        PasswordMinutesOfInactivityBeforeScreenTimeout = 25
                        PasswordPreviousPasswordBlockCount = 25
                        PasswordRequired = $True
                        PasswordRequiredType = "deviceDefault"
                        PasswordSignInFailureCountBeforeFactoryReset = 25
                        PowerOffBlocked = $True
                        RequiredPasswordComplexity = "none"
                        ScreenCaptureBlocked = $True
                        SecurityRequireVerifyApps = $True
                        StorageBlockGoogleBackup = $True
                        StorageBlockRemovableStorage = $True
                        StorageRequireDeviceEncryption = $True
                        StorageRequireRemovableStorageEncryption = $True
                        VoiceAssistantBlocked = $True
                        VoiceDialingBlocked = $True
                        WebBrowserBlockAutofill = $True
                        WebBrowserBlocked = $True
                        WebBrowserBlockJavaScript = $True
                        WebBrowserBlockPopups = $True
                        WebBrowserCookieSettings = "browserDefault"
                        WiFiBlocked = $True

                    }
                }
            }

            It "Should return Values from the Get method" {
                Get-TargetResource @testParams
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The IntuneDeviceConfigurationPolicyAndroidDeviceAdministrator exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                        AppsBlockClipboardSharing = $True
                        AppsBlockCopyPaste = $True
                        AppsBlockYouTube = $True
                        BluetoothBlocked = $True
                        CameraBlocked = $True
                        CellularBlockDataRoaming = $True
                        CellularBlockMessaging = $True
                        CellularBlockVoiceRoaming = $True
                        CellularBlockWiFiTethering = $True
                        CompliantAppListType = "none"
                        DateAndTimeBlockChanges = $True
                        Description = "FakeStringValue"
                        DeviceSharingAllowed = $True
                        DiagnosticDataBlockSubmission = $True
                        DisplayName = "FakeStringValue"
                        FactoryResetBlocked = $True
                        GoogleAccountBlockAutoSync = $True
                        GooglePlayStoreBlocked = $True
                        Id = "FakeStringValue"
                        KioskModeBlockSleepButton = $True
                        KioskModeBlockVolumeButtons = $True
                        LocationServicesBlocked = $True
                        NfcBlocked = $True
                        PasswordBlockFingerprintUnlock = $True
                        PasswordBlockTrustAgents = $True
                        PasswordExpirationDays = 25
                        PasswordMinimumLength = 25
                        PasswordMinutesOfInactivityBeforeScreenTimeout = 25
                        PasswordPreviousPasswordBlockCount = 25
                        PasswordRequired = $True
                        PasswordRequiredType = "deviceDefault"
                        PasswordSignInFailureCountBeforeFactoryReset = 25
                        PowerOffBlocked = $True
                        RequiredPasswordComplexity = "none"
                        ScreenCaptureBlocked = $True
                        SecurityRequireVerifyApps = $True
                        StorageBlockGoogleBackup = $True
                        StorageBlockRemovableStorage = $True
                        StorageRequireDeviceEncryption = $True
                        StorageRequireRemovableStorageEncryption = $True
                        VoiceAssistantBlocked = $True
                        VoiceDialingBlocked = $True
                        WebBrowserBlockAutofill = $True
                        WebBrowserBlocked = $True
                        WebBrowserBlockJavaScript = $True
                        WebBrowserBlockPopups = $True
                        WebBrowserCookieSettings = "browserDefault"
                        WiFiBlocked = $True

                    Ensure                = "Present"
                    Credential            = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AppsBlockClipboardSharing = $False
                        AppsBlockCopyPaste = $False
                        AppsBlockYouTube = $False
                        BluetoothBlocked = $False
                        CameraBlocked = $False
                        CellularBlockDataRoaming = $False
                        CellularBlockMessaging = $False
                        CellularBlockVoiceRoaming = $False
                        CellularBlockWiFiTethering = $False
                        CompliantAppListType = "none"
                        DateAndTimeBlockChanges = $False
                        Description = "FakeStringValue"
                        DeviceSharingAllowed = $False
                        DiagnosticDataBlockSubmission = $False
                        DisplayName = "FakeStringValue"
                        FactoryResetBlocked = $False
                        GoogleAccountBlockAutoSync = $False
                        GooglePlayStoreBlocked = $False
                        Id = "FakeStringValue"
                        KioskModeBlockSleepButton = $False
                        KioskModeBlockVolumeButtons = $False
                        LocationServicesBlocked = $False
                        NfcBlocked = $False
                        PasswordBlockFingerprintUnlock = $False
                        PasswordBlockTrustAgents = $False
                        PasswordExpirationDays = 7
                        PasswordMinimumLength = 7
                        PasswordMinutesOfInactivityBeforeScreenTimeout = 7
                        PasswordPreviousPasswordBlockCount = 7
                        PasswordRequired = $False
                        PasswordRequiredType = "deviceDefault"
                        PasswordSignInFailureCountBeforeFactoryReset = 7
                        PowerOffBlocked = $False
                        RequiredPasswordComplexity = "none"
                        ScreenCaptureBlocked = $False
                        SecurityRequireVerifyApps = $False
                        StorageBlockGoogleBackup = $False
                        StorageBlockRemovableStorage = $False
                        StorageRequireDeviceEncryption = $False
                        StorageRequireRemovableStorageEncryption = $False
                        VoiceAssistantBlocked = $False
                        VoiceDialingBlocked = $False
                        WebBrowserBlockAutofill = $False
                        WebBrowserBlocked = $False
                        WebBrowserBlockJavaScript = $False
                        WebBrowserBlockPopups = $False
                        WebBrowserCookieSettings = "browserDefault"
                        WiFiBlocked = $False

                    }
                }
            }

            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgDeviceManagementDeviceConfiguration -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AppsBlockClipboardSharing = $True
                        AppsBlockCopyPaste = $True
                        AppsBlockYouTube = $True
                        BluetoothBlocked = $True
                        CameraBlocked = $True
                        CellularBlockDataRoaming = $True
                        CellularBlockMessaging = $True
                        CellularBlockVoiceRoaming = $True
                        CellularBlockWiFiTethering = $True
                        CompliantAppListType = "none"
                        DateAndTimeBlockChanges = $True
                        Description = "FakeStringValue"
                        DeviceSharingAllowed = $True
                        DiagnosticDataBlockSubmission = $True
                        DisplayName = "FakeStringValue"
                        FactoryResetBlocked = $True
                        GoogleAccountBlockAutoSync = $True
                        GooglePlayStoreBlocked = $True
                        Id = "FakeStringValue"
                        KioskModeBlockSleepButton = $True
                        KioskModeBlockVolumeButtons = $True
                        LocationServicesBlocked = $True
                        NfcBlocked = $True
                        PasswordBlockFingerprintUnlock = $True
                        PasswordBlockTrustAgents = $True
                        PasswordExpirationDays = 25
                        PasswordMinimumLength = 25
                        PasswordMinutesOfInactivityBeforeScreenTimeout = 25
                        PasswordPreviousPasswordBlockCount = 25
                        PasswordRequired = $True
                        PasswordRequiredType = "deviceDefault"
                        PasswordSignInFailureCountBeforeFactoryReset = 25
                        PowerOffBlocked = $True
                        RequiredPasswordComplexity = "none"
                        ScreenCaptureBlocked = $True
                        SecurityRequireVerifyApps = $True
                        StorageBlockGoogleBackup = $True
                        StorageBlockRemovableStorage = $True
                        StorageRequireDeviceEncryption = $True
                        StorageRequireRemovableStorageEncryption = $True
                        VoiceAssistantBlocked = $True
                        VoiceDialingBlocked = $True
                        WebBrowserBlockAutofill = $True
                        WebBrowserBlocked = $True
                        WebBrowserBlockJavaScript = $True
                        WebBrowserBlockPopups = $True
                        WebBrowserCookieSettings = "browserDefault"
                        WiFiBlocked = $True

                    }
                }
            }
            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
