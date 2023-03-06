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
    -DscResource 'IntuneAppProtectionPolicyiOS' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'Pass@word1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName New-MgDeviceAppManagementiosManagedAppProtection -MockWith {
                return @{
                    id = '12345-12345-12345-12345-12345'
                }
            }

            Mock -CommandName Update-MgDeviceAppManagementiosManagedAppProtection -MockWith {
            }

            Mock -CommandName Remove-MgDeviceAppManagementiosManagedAppProtection -MockWith {
            }

            Mock -CommandName Update-IntuneAppProtectionPolicyiOSAssignment -MockWith {
            }

            Mock -CommandName Update-IntuneAppProtectionPolicyiOSApp -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name "When the Policy doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowedDataStorageLocations             = @('sharePoint')
                    AllowedInboundDataTransferSources       = 'managedApps'
                    AllowedOutboundClipboardSharingLevel    = 'managedAppsWithPasteIn'
                    AllowedOutboundDataTransferDestinations = 'managedApps'
                    AppDataEncryptionType                   = 'whenDeviceLocked'
                    Apps                                    = @('com.cisco.jabberimintune.ios', 'com.pervasent.boardpapers.ios', 'com.sharefile.mobile.intune.ios')
                    Assignments                             = @('6ee86c9f-2b3c-471d-ad38-ff4673ed723e')
                    ContactSyncBlocked                      = $False
                    DataBackupBlocked                       = $False
                    Description                             = ''
                    DeviceComplianceRequired                = $True
                    DisplayName                             = 'DSC Policy'
                    Ensure                                  = 'Present'
                    ExcludedGroups                          = @('3eacc231-d77b-4efb-bb5f-310f68bd6198')
                    FaceIdBlocked                           = $False
                    FingerprintBlocked                      = $False
                    Credential                              = $Credential
                    ManagedBrowser                          = 'microsoftEdge'
                    MinimumRequiredAppVersion               = '0.2'
                    MinimumRequiredOSVersion                = '0.2'
                    MinimumRequiredSdkVersion               = '0.1'
                    MinimumWarningAppVersion                = '0.1'
                    MinimumWarningOSVersion                 = '0.1'
                    ManagedBrowserToOpenLinksRequired       = $True
                    MaximumPinRetries                       = 5
                    MinimumPinLength                        = 4
                    OrganizationalCredentialsRequired       = $False
                    PeriodBeforePinReset                    = '90.00:00:00'
                    PeriodOfflineBeforeAccessCheck          = '12:00:00'
                    PeriodOfflineBeforeWipeIsEnforced       = '90.00:00:00'
                    PeriodOnlineBeforeAccessCheck           = '00:30:00'
                    PinCharacterSet                         = 'alphanumericAndSymbol'
                    PinRequired                             = $True
                    DisableAppPinIfDevicePinIsSet           = $False
                    PrintBlocked                            = $False
                    SaveAsBlocked                           = $True
                    SimplePinBlocked                        = $False
                }
                Mock -CommandName Get-MgDeviceAppManagementiosManagedAppProtection -MockWith {
                    return $null
                }
            }

            It 'Should return absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create the Policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'New-MgDeviceAppManagementiosManagedAppProtection' -Exactly 1
            }
        }

        Context -Name 'When the policy already exists and is NOT in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowedDataStorageLocations             = @('sharePoint')
                    AllowedInboundDataTransferSources       = 'managedApps'
                    AllowedOutboundClipboardSharingLevel    = 'managedAppsWithPasteIn'
                    AllowedOutboundDataTransferDestinations = 'managedApps'
                    AppDataEncryptionType                   = 'whenDeviceLocked'
                    Apps                                    = @('com.cisco.jabberimintune.ios', 'com.pervasent.boardpapers.ios', 'com.sharefile.mobile.intune.ios')
                    Assignments                             = @('6ee86c9f-2b3c-471d-ad38-ff4673ed723e')
                    ContactSyncBlocked                      = $False
                    DataBackupBlocked                       = $False
                    Description                             = ''
                    DeviceComplianceRequired                = $True
                    DisplayName                             = 'DSC Policy'
                    Ensure                                  = 'Present'
                    ExcludedGroups                          = @('3eacc231-d77b-4efb-bb5f-310f68bd6198')
                    FaceIdBlocked                           = $False
                    FingerprintBlocked                      = $False
                    Credential                              = $Credential
                    ManagedBrowser                          = 'microsoftEdge'
                    MinimumRequiredAppVersion               = '0.2'
                    MinimumRequiredOSVersion                = '0.2'
                    MinimumRequiredSdkVersion               = '0.1'
                    MinimumWarningAppVersion                = '0.1'
                    MinimumWarningOSVersion                 = '0.1'
                    ManagedBrowserToOpenLinksRequired       = $False; #Drift
                    MaximumPinRetries                       = 5
                    MinimumPinLength                        = 4
                    OrganizationalCredentialsRequired       = $False
                    PeriodBeforePinReset                    = '90.00:00:00'
                    PeriodOfflineBeforeAccessCheck          = '12:00:00'
                    PeriodOfflineBeforeWipeIsEnforced       = '90.00:00:00'
                    PeriodOnlineBeforeAccessCheck           = '00:30:00'
                    PinCharacterSet                         = 'alphanumericAndSymbol'
                    PinRequired                             = $True
                    DisableAppPinIfDevicePinIsSet           = $False
                    PrintBlocked                            = $False
                    SaveAsBlocked                           = $True
                    SimplePinBlocked                        = $False
                    Identity                                = '12345-12345-12345-12345-12345'
                }

                Mock -CommandName Get-MgDeviceAppManagementiosManagedAppProtection -MockWith {
                    return @{
                        '@odata.type'                           = '#microsoft.graph.iosManagedAppProtection'
                        AllowedDataStorageLocations             = @('sharePoint')
                        AllowedInboundDataTransferSources       = 'managedApps'
                        AllowedOutboundClipboardSharingLevel    = 'managedAppsWithPasteIn'
                        AllowedOutboundDataTransferDestinations = 'managedApps'
                        AppDataEncryptionType                   = 'whenDeviceLocked'
                        ContactSyncBlocked                      = $False
                        DataBackupBlocked                       = $False
                        Description                             = ''
                        DeviceComplianceRequired                = $True
                        DisplayName                             = 'DSC Policy'
                        FaceIdBlocked                           = $False
                        FingerprintBlocked                      = $False
                        ManagedBrowser                          = 'microsoftEdge'
                        MinimumRequiredAppVersion               = '0.2'
                        MinimumRequiredOSVersion                = '0.2'
                        MinimumRequiredSdkVersion               = '0.1'
                        MinimumWarningAppVersion                = '0.1'
                        MinimumWarningOSVersion                 = '0.1'
                        ManagedBrowserToOpenLinksRequired       = $True
                        MaximumPinRetries                       = 5
                        MinimumPinLength                        = 4
                        OrganizationalCredentialsRequired       = $False
                        PeriodBeforePinReset                    = '90.00:00:00'
                        PeriodOfflineBeforeAccessCheck          = '12:00:00'
                        PeriodOfflineBeforeWipeIsEnforced       = '90.00:00:00'
                        PeriodOnlineBeforeAccessCheck           = '00:30:00'
                        PinCharacterSet                         = 'alphanumericAndSymbol'
                        PinRequired                             = $True
                        DisableAppPinIfDevicePinIsSet           = $False
                        PrintBlocked                            = $False
                        SaveAsBlocked                           = $True
                        SimplePinBlocked                        = $False
                        id                                      = '12345-12345-12345-12345-12345'
                    }
                }
                Mock -CommandName Get-MgDeviceAppManagementiosManagedAppProtectionApp -MockWith {
                    return @(
                        @{
                            id                  = 'com.cisco.jabberimintune.ios.ios'
                            mobileAppIdentifier = @{
                                additionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.iosMobileAppIdentifier'
                                    bundleId      = 'com.cisco.jabberimintune.ios'
                                }
                            }
                        },
                        @{
                            id                  = 'com.pervasent.boardpapers.ios.ios'
                            mobileAppIdentifier = @{
                                additionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.iosMobileAppIdentifier'
                                    bundleId      = 'com.pervasent.boardpapers.ios'
                                }
                            }
                        },
                        @{
                            id                  = 'com.sharefile.mobile.intune.ios.ios'
                            mobileAppIdentifier = @{
                                additionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.iosMobileAppIdentifier'
                                    bundleId      = 'com.sharefile.mobile.intune.ios'
                                }
                            }
                        }
                    )
                }
                Mock -CommandName Get-IntuneAppProtectionPolicyiOSAssignment -MockWith {
                    return @(
                        @{
                            target = @{
                                '@odata.type' = '#microsoft.graph.groupAssignmentTarget'
                                groupId       = '6ee86c9f-2b3c-471d-ad38-ff4673ed723e'
                            }
                        },
                        @{
                            target = @{
                                '@odata.type' = '#microsoft.graph.exclusionGroupAssignmentTarget'
                                groupId       = '3eacc231-d77b-4efb-bb5f-310f68bd6198'
                            }
                        }
                    )
                }

            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update the App Configuration Policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgDeviceAppManagementiosManagedAppProtection -Exactly 1
            }
        }

        Context -Name 'When the policy already exists and IS in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowedDataStorageLocations             = @('sharePoint')
                    AllowedInboundDataTransferSources       = 'managedApps'
                    AllowedOutboundClipboardSharingLevel    = 'managedAppsWithPasteIn'
                    AllowedOutboundDataTransferDestinations = 'managedApps'
                    AppDataEncryptionType                   = 'whenDeviceLocked'
                    Apps                                    = @('com.cisco.jabberimintune.ios', 'com.pervasent.boardpapers.ios', 'com.sharefile.mobile.intune.ios')
                    Assignments                             = @('6ee86c9f-2b3c-471d-ad38-ff4673ed723e')
                    ContactSyncBlocked                      = $False
                    DataBackupBlocked                       = $False
                    Description                             = ''
                    DeviceComplianceRequired                = $True
                    DisplayName                             = 'DSC Policy'
                    Ensure                                  = 'Present'
                    ExcludedGroups                          = @('3eacc231-d77b-4efb-bb5f-310f68bd6198')
                    FaceIdBlocked                           = $False
                    FingerprintBlocked                      = $False
                    Credential                              = $Credential
                    ManagedBrowser                          = 'microsoftEdge'
                    MinimumRequiredAppVersion               = '0.2'
                    MinimumRequiredOsVersion                = '0.2'
                    MinimumRequiredSdkVersion               = '0.1'
                    MinimumWarningAppVersion                = '0.1'
                    MinimumWarningOsVersion                 = '0.1'
                    ManagedBrowserToOpenLinksRequired       = $True
                    MaximumPinRetries                       = 5
                    MinimumPinLength                        = 4
                    OrganizationalCredentialsRequired       = $False
                    PeriodBeforePinReset                    = '90.00:00:00'
                    PeriodOfflineBeforeAccessCheck          = '12:00:00'
                    PeriodOfflineBeforeWipeIsEnforced       = '90.00:00:00'
                    PeriodOnlineBeforeAccessCheck           = '00:30:00'
                    PinCharacterSet                         = 'alphanumericAndSymbol'
                    PinRequired                             = $True
                    DisableAppPinIfDevicePinIsSet           = $False
                    PrintBlocked                            = $False
                    SaveAsBlocked                           = $True
                    SimplePinBlocked                        = $False
                    Identity                                = '12345-12345-12345-12345-12345'
                }

                Mock -CommandName Get-MgDeviceAppManagementiosManagedAppProtection -MockWith {
                    return @{
                        '@odata.type'                           = '#microsoft.graph.iosManagedAppProtection'
                        AllowedDataStorageLocations             = @('sharePoint')
                        AllowedInboundDataTransferSources       = 'managedApps'
                        AllowedOutboundClipboardSharingLevel    = 'managedAppsWithPasteIn'
                        AllowedOutboundDataTransferDestinations = 'managedApps'
                        AppDataEncryptionType                   = 'whenDeviceLocked'
                        ContactSyncBlocked                      = $False
                        DataBackupBlocked                       = $False
                        Description                             = ''
                        DeviceComplianceRequired                = $True
                        DisplayName                             = 'DSC Policy'
                        FaceIdBlocked                           = $False
                        FingerprintBlocked                      = $False
                        ManagedBrowser                          = 'microsoftEdge'
                        MinimumRequiredAppVersion               = '0.2'
                        MinimumRequiredOsVersion                = '0.2'
                        MinimumRequiredSdkVersion               = '0.1'
                        MinimumWarningAppVersion                = '0.1'
                        MinimumWarningOsVersion                 = '0.1'
                        ManagedBrowserToOpenLinksRequired       = $True
                        MaximumPinRetries                       = 5
                        MinimumPinLength                        = 4
                        OrganizationalCredentialsRequired       = $False
                        PeriodBeforePinReset                    = '90.00:00:00'
                        PeriodOfflineBeforeAccessCheck          = '12:00:00'
                        PeriodOfflineBeforeWipeIsEnforced       = '90.00:00:00'
                        PeriodOnlineBeforeAccessCheck           = '00:30:00'
                        PinCharacterSet                         = 'alphanumericAndSymbol'
                        PinRequired                             = $True
                        DisableAppPinIfDevicePinIsSet           = $False
                        PrintBlocked                            = $False
                        SaveAsBlocked                           = $True
                        SimplePinBlocked                        = $False
                        id                                      = '12345-12345-12345-12345-12345'
                    }
                }
                Mock -CommandName Get-MgDeviceAppManagementiosManagedAppProtectionApp -MockWith {
                    return @(
                        @{
                            id                  = 'com.cisco.jabberimintune.ios.ios'
                            mobileAppIdentifier = @{
                                additionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.iosMobileAppIdentifier'
                                    bundleId      = 'com.cisco.jabberimintune.ios'
                                }
                            }
                        },
                        @{
                            id                  = 'com.pervasent.boardpapers.ios.ios'
                            mobileAppIdentifier = @{
                                additionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.iosMobileAppIdentifier'
                                    bundleId      = 'com.pervasent.boardpapers.ios'
                                }
                            }
                        },
                        @{
                            id                  = 'com.sharefile.mobile.intune.ios.ios'
                            mobileAppIdentifier = @{
                                additionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.iosMobileAppIdentifier'
                                    bundleId      = 'com.sharefile.mobile.intune.ios'
                                }
                            }
                        }
                    )
                }
                Mock -CommandName Get-IntuneAppProtectionPolicyiOSAssignment -MockWith {
                    return @(
                        @{
                            target = @{
                                '@odata.type' = '#microsoft.graph.groupAssignmentTarget'
                                groupId       = '6ee86c9f-2b3c-471d-ad38-ff4673ed723e'
                            }
                        },
                        @{
                            target = @{
                                '@odata.type' = '#microsoft.graph.exclusionGroupAssignmentTarget'
                                groupId       = '3eacc231-d77b-4efb-bb5f-310f68bd6198'
                            }
                        }
                    )
                }

            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'When the policy exists and it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowedDataStorageLocations             = @('sharePoint')
                    AllowedInboundDataTransferSources       = 'managedApps'
                    AllowedOutboundClipboardSharingLevel    = 'managedAppsWithPasteIn'
                    AllowedOutboundDataTransferDestinations = 'managedApps'
                    AppDataEncryptionType                   = 'whenDeviceLocked'
                    Apps                                    = @('com.cisco.jabberimintune.ios', 'com.pervasent.boardpapers.ios', 'com.sharefile.mobile.intune.ios')
                    Assignments                             = @('6ee86c9f-2b3c-471d-ad38-ff4673ed723e')
                    ContactSyncBlocked                      = $False
                    DataBackupBlocked                       = $False
                    Description                             = ''
                    DeviceComplianceRequired                = $True
                    DisplayName                             = 'DSC Policy'
                    Ensure                                  = 'Absent'
                    ExcludedGroups                          = @('3eacc231-d77b-4efb-bb5f-310f68bd6198')
                    FaceIdBlocked                           = $False
                    FingerprintBlocked                      = $False
                    Credential                              = $Credential
                    ManagedBrowser                          = 'microsoftEdge'
                    MinimumRequiredAppVersion               = '0.2'
                    MinimumRequiredOSVersion                = '0.2'
                    MinimumRequiredSdkVersion               = '0.1'
                    MinimumWarningAppVersion                = '0.1'
                    MinimumWarningOSVersion                 = '0.1'
                    ManagedBrowserToOpenLinksRequired       = $True
                    MaximumPinRetries                       = 5
                    MinimumPinLength                        = 4
                    OrganizationalCredentialsRequired       = $False
                    PeriodBeforePinReset                    = '90.00:00:00'
                    PeriodOfflineBeforeAccessCheck          = '12:00:00'
                    PeriodOfflineBeforeWipeIsEnforced       = '90.00:00:00'
                    PeriodOnlineBeforeAccessCheck           = '00:30:00'
                    PinCharacterSet                         = 'alphanumericAndSymbol'
                    PinRequired                             = $True
                    DisableAppPinIfDevicePinIsSet           = $False
                    PrintBlocked                            = $False
                    SaveAsBlocked                           = $True
                    SimplePinBlocked                        = $False
                    Identity                                = '12345-12345-12345-12345-12345'
                }

                Mock -CommandName Get-MgDeviceAppManagementiosManagedAppProtection -MockWith {
                    return @{
                        '@odata.type'                           = '#microsoft.graph.iosManagedAppProtection'
                        AllowedDataStorageLocations             = @('sharePoint')
                        AllowedInboundDataTransferSources       = 'managedApps'
                        AllowedOutboundClipboardSharingLevel    = 'managedAppsWithPasteIn'
                        AllowedOutboundDataTransferDestinations = 'managedApps'
                        AppDataEncryptionType                   = 'whenDeviceLocked'
                        ContactSyncBlocked                      = $False
                        DataBackupBlocked                       = $False
                        Description                             = ''
                        DeviceComplianceRequired                = $True
                        DisplayName                             = 'DSC Policy'
                        FaceIdBlocked                           = $False
                        FingerprintBlocked                      = $False
                        ManagedBrowser                          = 'microsoftEdge'
                        MinimumRequiredAppVersion               = '0.2'
                        MinimumRequiredOSVersion                = '0.2'
                        MinimumRequiredSdkVersion               = '0.1'
                        MinimumWarningAppVersion                = '0.1'
                        MinimumWarningOSVersion                 = '0.1'
                        ManagedBrowserToOpenLinksRequired       = $True
                        MaximumPinRetries                       = 5
                        MinimumPinLength                        = 4
                        OrganizationalCredentialsRequired       = $False
                        PeriodBeforePinReset                    = '90.00:00:00'
                        PeriodOfflineBeforeAccessCheck          = '12:00:00'
                        PeriodOfflineBeforeWipeIsEnforced       = '90.00:00:00'
                        PeriodOnlineBeforeAccessCheck           = '00:30:00'
                        PinCharacterSet                         = 'alphanumericAndSymbol'
                        PinRequired                             = $True
                        DisableAppPinIfDevicePinIsSet           = $False
                        PrintBlocked                            = $False
                        SaveAsBlocked                           = $True
                        SimplePinBlocked                        = $False
                        id                                      = '12345-12345-12345-12345-12345'
                    }
                }
                Mock -CommandName Get-MgDeviceAppManagementiosManagedAppProtectionApp -MockWith {
                    return @(
                        @{
                            id                  = 'com.cisco.jabberimintune.ios.ios'
                            mobileAppIdentifier = @{
                                additionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.iosMobileAppIdentifier'
                                    bundleId      = 'com.cisco.jabberimintune.ios'
                                }
                            }
                        },
                        @{
                            id                  = 'com.pervasent.boardpapers.ios.ios'
                            mobileAppIdentifier = @{
                                additionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.iosMobileAppIdentifier'
                                    bundleId      = 'com.pervasent.boardpapers.ios'
                                }
                            }
                        },
                        @{
                            id                  = 'com.sharefile.mobile.intune.ios.ios'
                            mobileAppIdentifier = @{
                                additionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.iosMobileAppIdentifier'
                                    bundleId      = 'com.sharefile.mobile.intune.ios'
                                }
                            }
                        }
                    )
                }
                Mock -CommandName Get-IntuneAppProtectionPolicyiOSAssignment -MockWith {
                    return @(
                        @{
                            target = @{
                                '@odata.type' = '#microsoft.graph.groupAssignmentTarget'
                                groupId       = '6ee86c9f-2b3c-471d-ad38-ff4673ed723e'
                            }
                        },
                        @{
                            target = @{
                                '@odata.type' = '#microsoft.graph.exclusionGroupAssignmentTarget'
                                groupId       = '3eacc231-d77b-4efb-bb5f-310f68bd6198'
                            }
                        }
                    )
                }

            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the App Configuration Policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgDeviceAppManagementiosManagedAppProtection -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgDeviceAppManagementiosManagedAppProtection -MockWith {
                    return @{
                        '@odata.type'                           = '#microsoft.graph.iosManagedAppProtection'
                        AllowedDataStorageLocations             = @('sharePoint')
                        AllowedInboundDataTransferSources       = 'managedApps'
                        AllowedOutboundClipboardSharingLevel    = 'managedAppsWithPasteIn'
                        AllowedOutboundDataTransferDestinations = 'managedApps'
                        AppDataEncryptionType                   = 'whenDeviceLocked'
                        ContactSyncBlocked                      = $False
                        DataBackupBlocked                       = $False
                        Description                             = ''
                        DeviceComplianceRequired                = $True
                        DisplayName                             = 'DSC Policy'
                        FaceIdBlocked                           = $False
                        FingerprintBlocked                      = $False
                        ManagedBrowser                          = 'microsoftEdge'
                        MinimumRequiredAppVersion               = '0.2'
                        MinimumRequiredOSVersion                = '0.2'
                        MinimumRequiredSdkVersion               = '0.1'
                        MinimumWarningAppVersion                = '0.1'
                        MinimumWarningOSVersion                 = '0.1'
                        ManagedBrowserToOpenLinksRequired       = $True
                        MaximumPinRetries                       = 5
                        MinimumPinLength                        = 4
                        OrganizationalCredentialsRequired       = $False
                        PeriodBeforePinReset                    = '90.00:00:00'
                        PeriodOfflineBeforeAccessCheck          = '12:00:00'
                        PeriodOfflineBeforeWipeIsEnforced       = '90.00:00:00'
                        PeriodOnlineBeforeAccessCheck           = '00:30:00'
                        PinCharacterSet                         = 'alphanumericAndSymbol'
                        PinRequired                             = $True
                        DisableAppPinIfDevicePinIsSet           = $False
                        PrintBlocked                            = $False
                        SaveAsBlocked                           = $True
                        SimplePinBlocked                        = $False
                        id                                      = '12345-12345-12345-12345-12345'
                    }
                }
                Mock -CommandName Get-MgDeviceAppManagementiosManagedAppProtectionApp -MockWith {
                    return @(
                        @{
                            id                  = 'com.cisco.jabberimintune.ios.ios'
                            mobileAppIdentifier = @{
                                additionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.iosMobileAppIdentifier'
                                    bundleId      = 'com.cisco.jabberimintune.ios'
                                }
                            }
                        },
                        @{
                            id                  = 'com.pervasent.boardpapers.ios.ios'
                            mobileAppIdentifier = @{
                                additionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.iosMobileAppIdentifier'
                                    bundleId      = 'com.pervasent.boardpapers.ios'
                                }
                            }
                        },
                        @{
                            id                  = 'com.sharefile.mobile.intune.ios.ios'
                            mobileAppIdentifier = @{
                                additionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.iosMobileAppIdentifier'
                                    bundleId      = 'com.sharefile.mobile.intune.ios'
                                }
                            }
                        }
                    )
                }
                Mock -CommandName Get-IntuneAppProtectionPolicyiOSAssignment -MockWith {
                    return @(
                        @{
                            target = @{
                                '@odata.type' = '#microsoft.graph.groupAssignmentTarget'
                                groupId       = '6ee86c9f-2b3c-471d-ad38-ff4673ed723e'
                            }
                        },
                        @{
                            target = @{
                                '@odata.type' = '#microsoft.graph.exclusionGroupAssignmentTarget'
                                groupId       = '3eacc231-d77b-4efb-bb5f-310f68bd6198'
                            }
                        }
                    )
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
