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
    -DscResource "IntuneAppProtectionPolicyiOS" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString "Pass@word1" -AsPlainText -Force
            $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }

            Mock -CommandName Set-M365DSCIntuneAppProtectionPolicyiOS -MockWith {
            }
            Mock -CommandName Set-M365DSCIntuneAppProtectionPolicyiOSAssignment -MockWith {
            }
            Mock -CommandName Set-M365DSCIntuneAppProtectionPolicyiOSApps -MockWith {
            }
            Mock -CommandName New-M365DSCIntuneAppProtectionPolicyiOS -MockWith {
            }
            Mock -CommandName Remove-IntuneAppProtectionPolicy -MockWith {
            }
        }

        # Test contexts
        Context -Name "When the Policy doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowedDataStorageLocations             = @("sharePoint");
                    AllowedInboundDataTransferSources       = "managedApps";
                    AllowedOutboundClipboardSharingLevel    = "managedAppsWithPasteIn";
                    AllowedOutboundDataTransferDestinations = "managedApps";
                    AppDataEncryptionType                   = "whenDeviceLocked";
                    Apps                                    = @("com.cisco.jabberimintune.ios", "com.pervasent.boardpapers.ios", "com.sharefile.mobile.intune.ios");
                    Assignments                             = @("6ee86c9f-2b3c-471d-ad38-ff4673ed723e");
                    ContactSyncBlocked                      = $False;
                    DataBackupBlocked                       = $False;
                    Description                             = "";
                    DeviceComplianceRequired                = $True;
                    DisplayName                             = "DSC Policy";
                    Ensure                                  = "Present"
                    ExcludedGroups                          = @("3eacc231-d77b-4efb-bb5f-310f68bd6198");
                    FingerprintBlocked                      = $False;
                    GlobalAdminAccount                      = $GlobalAdminAccount;
                    ManagedBrowserToOpenLinksRequired       = $True;
                    MaximumPinRetries                       = 5;
                    MinimumPinLength                        = 4;
                    OrganizationalCredentialsRequired       = $False;
                    PeriodOfflineBeforeAccessCheck          = "PT12H";
                    PeriodOfflineBeforeWipeIsEnforced       = "P90D";
                    PeriodOnlineBeforeAccessCheck           = "PT30M";
                    PinCharacterSet                         = "alphanumericAndSymbol";
                    PinRequired                             = $True;
                    PrintBlocked                            = $False;
                    SaveAsBlocked                           = $True;
                    SimplePinBlocked                        = $False;
                }
                $Global:count = 0
                Mock -CommandName Get-IntuneAppProtectionPolicy -MockWith {
                    if ($Global:count -lt 3)
                    {
                        $Global:count++
                        return $null
                    }
                    else
                    {
                        return @{
                            displayName   = "DSC Policy"
                            id            = "12345-12345-12345-12345-12345"
                            '@odata.type' = "#microsoft.graph.iosManagedAppProtection"
                        }
                    }
                }

                Mock -CommandName Get-M365DSCIntuneAppProtectionPolicyiOS -MockWith {
                    return $null
                }
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should create the Policy from the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName "New-M365DSCIntuneAppProtectionPolicyiOS" -Exactly 1
            }
        }

        Context -Name "When the policy already exists and is NOT in the Desired State" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowedDataStorageLocations             = @("sharePoint");
                    AllowedInboundDataTransferSources       = "managedApps";
                    AllowedOutboundClipboardSharingLevel    = "managedAppsWithPasteIn";
                    AllowedOutboundDataTransferDestinations = "managedApps";
                    AppDataEncryptionType                   = "whenDeviceLocked";
                    Apps                                    = @("com.cisco.jabberimintune.ios", "com.pervasent.boardpapers.ios", "com.sharefile.mobile.intune.ios");
                    Assignments                             = @("6ee86c9f-2b3c-471d-ad38-ff4673ed723e");
                    ContactSyncBlocked                      = $False;
                    DataBackupBlocked                       = $False;
                    Description                             = "";
                    DeviceComplianceRequired                = $True;
                    DisplayName                             = "DSC Policy";
                    Ensure                                  = "Present"
                    ExcludedGroups                          = @("3eacc231-d77b-4efb-bb5f-310f68bd6198");
                    FingerprintBlocked                      = $False;
                    GlobalAdminAccount                      = $GlobalAdminAccount;
                    ManagedBrowserToOpenLinksRequired       = $False; #Drift
                    MaximumPinRetries                       = 5;
                    MinimumPinLength                        = 4;
                    OrganizationalCredentialsRequired       = $False;
                    PeriodOfflineBeforeAccessCheck          = "PT12H";
                    PeriodOfflineBeforeWipeIsEnforced       = "P90D";
                    PeriodOnlineBeforeAccessCheck           = "PT30M";
                    PinCharacterSet                         = "alphanumericAndSymbol";
                    PinRequired                             = $True;
                    PrintBlocked                            = $False;
                    SaveAsBlocked                           = $True;
                    SimplePinBlocked                        = $False;
                }

                Mock -CommandName Get-IntuneAppProtectionPolicy -MockWith {
                    return @{
                        displayName   = "DSC Policy"
                        id            = "12345-12345-12345-12345-12345"
                        '@odata.type' = "#microsoft.graph.iosManagedAppProtection"
                    }
                }

                Mock -CommandName Get-M365DSCIntuneAppProtectionPolicyiOS -MockWith {
                    return @{
                        '@odata.type'                           = "#microsoft.graph.iosManagedAppProtection"
                        AllowedDataStorageLocations             = @("sharePoint");
                        AllowedInboundDataTransferSources       = "managedApps";
                        AllowedOutboundClipboardSharingLevel    = "managedAppsWithPasteIn";
                        AllowedOutboundDataTransferDestinations = "managedApps";
                        AppDataEncryptionType                   = "whenDeviceLocked";
                        Apps                                    = @(
                            @{
                                id                  = "com.cisco.jabberimintune.ios.ios"
                                mobileAppIdentifier = @{
                                    "@odata.type" = "#microsoft.graph.iosMobileAppIdentifier"
                                    bundleId      = "com.cisco.jabberimintune.ios"
                                }
                            },
                            @{
                                id                  = "com.pervasent.boardpapers.ios.ios"
                                mobileAppIdentifier = @{
                                    "@odata.type" = "#microsoft.graph.iosMobileAppIdentifier"
                                    bundleId      = "com.pervasent.boardpapers.ios"
                                }
                            },
                            @{
                                id                  = "com.sharefile.mobile.intune.ios.ios"
                                mobileAppIdentifier = @{
                                    "@odata.type" = "#microsoft.graph.iosMobileAppIdentifier"
                                    bundleId      = "com.sharefile.mobile.intune.ios"
                                }
                            }
                        )
                        Assignments                             = @(
                            @{
                                target = @{
                                    '@odata.type' = "#microsoft.graph.groupAssignmentTarget"
                                    groupId       = "6ee86c9f-2b3c-471d-ad38-ff4673ed723e"
                                }
                            },
                            @{
                                target = @{
                                    '@odata.type' = "#microsoft.graph.exclusionGroupAssignmentTarget"
                                    groupId       = "3eacc231-d77b-4efb-bb5f-310f68bd6198"
                                }
                            }
                        )
                        ContactSyncBlocked                      = $False;
                        DataBackupBlocked                       = $False;
                        Description                             = "";
                        DeviceComplianceRequired                = $True;
                        DisplayName                             = "DSC Policy";
                        FingerprintBlocked                      = $False;
                        ManagedBrowserToOpenLinksRequired       = $True;
                        MaximumPinRetries                       = 5;
                        MinimumPinLength                        = 4;
                        OrganizationalCredentialsRequired       = $False;
                        PeriodOfflineBeforeAccessCheck          = "PT12H";
                        PeriodOfflineBeforeWipeIsEnforced       = "P90D";
                        PeriodOnlineBeforeAccessCheck           = "PT30M";
                        PinCharacterSet                         = "alphanumericAndSymbol";
                        PinRequired                             = $True;
                        PrintBlocked                            = $False;
                        SaveAsBlocked                           = $True;
                        SimplePinBlocked                        = $False;
                        id                                      = "12345-12345-12345-12345-12345"
                    }
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should update the App Configuration Policy from the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-M365DSCIntuneAppProtectionPolicyiOS -Exactly 1
            }
        }

        Context -Name "When the policy already exists and IS in the Desired State" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowedDataStorageLocations             = @("sharePoint");
                    AllowedInboundDataTransferSources       = "managedApps";
                    AllowedOutboundClipboardSharingLevel    = "managedAppsWithPasteIn";
                    AllowedOutboundDataTransferDestinations = "managedApps";
                    AppDataEncryptionType                   = "whenDeviceLocked";
                    Apps                                    = @("com.cisco.jabberimintune.ios", "com.pervasent.boardpapers.ios", "com.sharefile.mobile.intune.ios");
                    Assignments                             = @("6ee86c9f-2b3c-471d-ad38-ff4673ed723e");
                    ContactSyncBlocked                      = $False;
                    DataBackupBlocked                       = $False;
                    Description                             = "";
                    DeviceComplianceRequired                = $True;
                    DisplayName                             = "DSC Policy";
                    Ensure                                  = "Present"
                    ExcludedGroups                          = @("3eacc231-d77b-4efb-bb5f-310f68bd6198");
                    FingerprintBlocked                      = $False;
                    GlobalAdminAccount                      = $GLobalAdminAccount;
                    ManagedBrowserToOpenLinksRequired       = $True;
                    MaximumPinRetries                       = 5;
                    MinimumPinLength                        = 4;
                    OrganizationalCredentialsRequired       = $False;
                    PeriodOfflineBeforeAccessCheck          = "PT12H";
                    PeriodOfflineBeforeWipeIsEnforced       = "P90D";
                    PeriodOnlineBeforeAccessCheck           = "PT30M";
                    PinCharacterSet                         = "alphanumericAndSymbol";
                    PinRequired                             = $True;
                    PrintBlocked                            = $False;
                    SaveAsBlocked                           = $True;
                    SimplePinBlocked                        = $False;
                }

                Mock -CommandName Get-IntuneAppProtectionPolicy -MockWith {
                    return @{
                        displayName   = "DSC Policy"
                        id            = "12345-12345-12345-12345-12345"
                        '@odata.type' = "#microsoft.graph.iosManagedAppProtection"
                    }
                }

                Mock -CommandName Get-M365DSCIntuneAppProtectionPolicyiOS -MockWith {
                    @{
                        '@odata.type'                           = "#microsoft.graph.iosManagedAppProtection"
                        AllowedDataStorageLocations             = @("sharePoint");
                        AllowedInboundDataTransferSources       = "managedApps";
                        AllowedOutboundClipboardSharingLevel    = "managedAppsWithPasteIn";
                        AllowedOutboundDataTransferDestinations = "managedApps";
                        AppDataEncryptionType                   = "whenDeviceLocked";
                        Apps                                    = @(
                            @{
                                id                  = "com.cisco.jabberimintune.ios.ios"
                                mobileAppIdentifier = @{
                                    "@odata.type" = "#microsoft.graph.iosMobileAppIdentifier"
                                    bundleId      = "com.cisco.jabberimintune.ios"
                                }
                            },
                            @{
                                id                  = "com.pervasent.boardpapers.ios.ios"
                                mobileAppIdentifier = @{
                                    "@odata.type" = "#microsoft.graph.iosMobileAppIdentifier"
                                    bundleId      = "com.pervasent.boardpapers.ios"
                                }
                            },
                            @{
                                id                  = "com.sharefile.mobile.intune.ios.ios"
                                mobileAppIdentifier = @{
                                    "@odata.type" = "#microsoft.graph.iosMobileAppIdentifier"
                                    bundleId      = "com.sharefile.mobile.intune.ios"
                                }
                            }
                        )
                        Assignments                             = @(
                            @{
                                target = @{
                                    '@odata.type' = "#microsoft.graph.groupAssignmentTarget"
                                    groupId       = "6ee86c9f-2b3c-471d-ad38-ff4673ed723e"
                                }
                            },
                            @{
                                target = @{
                                    '@odata.type' = "#microsoft.graph.exclusionGroupAssignmentTarget"
                                    groupId       = "3eacc231-d77b-4efb-bb5f-310f68bd6198"
                                }
                            }
                        )
                        ContactSyncBlocked                      = $False;
                        DataBackupBlocked                       = $False;
                        Description                             = "";
                        DeviceComplianceRequired                = $True;
                        DisplayName                             = "DSC Policy";
                        FingerprintBlocked                      = $False;
                        ManagedBrowserToOpenLinksRequired       = $True;
                        MaximumPinRetries                       = 5;
                        MinimumPinLength                        = 4;
                        OrganizationalCredentialsRequired       = $False;
                        PeriodOfflineBeforeAccessCheck          = "PT12H";
                        PeriodOfflineBeforeWipeIsEnforced       = "P90D";
                        PeriodOnlineBeforeAccessCheck           = "PT30M";
                        PinCharacterSet                         = "alphanumericAndSymbol";
                        PinRequired                             = $True;
                        PrintBlocked                            = $False;
                        SaveAsBlocked                           = $True;
                        SimplePinBlocked                        = $False;
                        id                                      = "12345-12345-12345-12345-12345"
                    }
                }
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "When the policy exists and it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowedDataStorageLocations             = @("sharePoint");
                    AllowedInboundDataTransferSources       = "managedApps";
                    AllowedOutboundClipboardSharingLevel    = "managedAppsWithPasteIn";
                    AllowedOutboundDataTransferDestinations = "managedApps";
                    AppDataEncryptionType                   = "whenDeviceLocked";
                    Apps                                    = @("com.cisco.jabberimintune.ios", "com.pervasent.boardpapers.ios", "com.sharefile.mobile.intune.ios");
                    Assignments                             = @("6ee86c9f-2b3c-471d-ad38-ff4673ed723e");
                    ContactSyncBlocked                      = $False;
                    DataBackupBlocked                       = $False;
                    Description                             = "";
                    DeviceComplianceRequired                = $True;
                    DisplayName                             = "DSC Policy";
                    Ensure                                  = "Absent"
                    ExcludedGroups                          = @("3eacc231-d77b-4efb-bb5f-310f68bd6198");
                    FingerprintBlocked                      = $False;
                    GlobalAdminAccount                      = $GLobalAdminAccount;
                    ManagedBrowserToOpenLinksRequired       = $True;
                    MaximumPinRetries                       = 5;
                    MinimumPinLength                        = 4;
                    OrganizationalCredentialsRequired       = $False;
                    PeriodOfflineBeforeAccessCheck          = "PT12H";
                    PeriodOfflineBeforeWipeIsEnforced       = "P90D";
                    PeriodOnlineBeforeAccessCheck           = "PT30M";
                    PinCharacterSet                         = "alphanumericAndSymbol";
                    PinRequired                             = $True;
                    PrintBlocked                            = $False;
                    SaveAsBlocked                           = $True;
                    SimplePinBlocked                        = $False;
                }

                Mock -CommandName Get-IntuneAppProtectionPolicy -MockWith {
                    return @{
                        displayName   = "DSC Policy"
                        id            = "12345-12345-12345-12345-12345"
                        '@odata.type' = "#microsoft.graph.iosManagedAppProtection"
                    }
                }

                Mock -CommandName Get-M365DSCIntuneAppProtectionPolicyiOS -MockWith {
                    @{
                        '@odata.type'                           = "#microsoft.graph.iosManagedAppProtection"
                        AllowedDataStorageLocations             = @("sharePoint");
                        AllowedInboundDataTransferSources       = "managedApps";
                        AllowedOutboundClipboardSharingLevel    = "managedAppsWithPasteIn";
                        AllowedOutboundDataTransferDestinations = "managedApps";
                        AppDataEncryptionType                   = "whenDeviceLocked";
                        Apps                                    = @(
                            @{
                                id                  = "com.cisco.jabberimintune.ios.ios"
                                mobileAppIdentifier = @{
                                    "@odata.type" = "#microsoft.graph.iosMobileAppIdentifier"
                                    bundleId      = "com.cisco.jabberimintune.ios"
                                }
                            },
                            @{
                                id                  = "com.pervasent.boardpapers.ios.ios"
                                mobileAppIdentifier = @{
                                    "@odata.type" = "#microsoft.graph.iosMobileAppIdentifier"
                                    bundleId      = "com.pervasent.boardpapers.ios"
                                }
                            },
                            @{
                                id                  = "com.sharefile.mobile.intune.ios.ios"
                                mobileAppIdentifier = @{
                                    "@odata.type" = "#microsoft.graph.iosMobileAppIdentifier"
                                    bundleId      = "com.sharefile.mobile.intune.ios"
                                }
                            }
                        )
                        Assignments                             = @(
                            @{
                                target = @{
                                    '@odata.type' = "#microsoft.graph.groupAssignmentTarget"
                                    groupId       = "6ee86c9f-2b3c-471d-ad38-ff4673ed723e"
                                }
                            },
                            @{
                                target = @{
                                    '@odata.type' = "#microsoft.graph.exclusionGroupAssignmentTarget"
                                    groupId       = "3eacc231-d77b-4efb-bb5f-310f68bd6198"
                                }
                            }
                        )
                        ContactSyncBlocked                      = $False;
                        DataBackupBlocked                       = $False;
                        Description                             = "";
                        DeviceComplianceRequired                = $True;
                        DisplayName                             = "DSC Policy";
                        FingerprintBlocked                      = $False;
                        ManagedBrowserToOpenLinksRequired       = $True;
                        MaximumPinRetries                       = 5;
                        MinimumPinLength                        = 4;
                        OrganizationalCredentialsRequired       = $False;
                        PeriodOfflineBeforeAccessCheck          = "PT12H";
                        PeriodOfflineBeforeWipeIsEnforced       = "P90D";
                        PeriodOnlineBeforeAccessCheck           = "PT30M";
                        PinCharacterSet                         = "alphanumericAndSymbol";
                        PinRequired                             = $True;
                        PrintBlocked                            = $False;
                        SaveAsBlocked                           = $True;
                        SimplePinBlocked                        = $False;
                        id                                      = "12345-12345-12345-12345-12345"
                    }
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should remove the App Configuration Policy from the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-IntuneAppProtectionPolicy -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount = $GlobalAdminAccount;
                }

                Mock -CommandName Get-IntuneAppProtectionPolicy -MockWith {
                    return @{
                        displayName   = "DSC Policy"
                        id            = "12345-12345-12345-12345-12345"
                        '@odata.type' = "#microsoft.graph.iosManagedAppProtection"
                    }
                }

                Mock -CommandName Get-M365DSCIntuneAppProtectionPolicyiOS -MockWith {
                    @{
                        '@odata.type'                           = "#microsoft.graph.iosManagedAppProtection"
                        AllowedDataStorageLocations             = @("sharePoint");
                        AllowedInboundDataTransferSources       = "managedApps";
                        AllowedOutboundClipboardSharingLevel    = "managedAppsWithPasteIn";
                        AllowedOutboundDataTransferDestinations = "managedApps";
                        AppDataEncryptionType                   = "whenDeviceLocked";
                        Apps                                    = @(
                            @{
                                id                  = "com.cisco.jabberimintune.ios.ios"
                                mobileAppIdentifier = @{
                                    "@odata.type" = "#microsoft.graph.iosMobileAppIdentifier"
                                    bundleId      = "com.cisco.jabberimintune.ios"
                                }
                            },
                            @{
                                id                  = "com.pervasent.boardpapers.ios.ios"
                                mobileAppIdentifier = @{
                                    "@odata.type" = "#microsoft.graph.iosMobileAppIdentifier"
                                    bundleId      = "com.pervasent.boardpapers.ios"
                                }
                            },
                            @{
                                id                  = "com.sharefile.mobile.intune.ios.ios"
                                mobileAppIdentifier = @{
                                    "@odata.type" = "#microsoft.graph.iosMobileAppIdentifier"
                                    bundleId      = "com.sharefile.mobile.intune.ios"
                                }
                            }
                        )
                        Assignments                             = @(
                            @{
                                target = @{
                                    '@odata.type' = "#microsoft.graph.groupAssignmentTarget"
                                    groupId       = "6ee86c9f-2b3c-471d-ad38-ff4673ed723e"
                                }
                            },
                            @{
                                target = @{
                                    '@odata.type' = "#microsoft.graph.exclusionGroupAssignmentTarget"
                                    groupId       = "3eacc231-d77b-4efb-bb5f-310f68bd6198"
                                }
                            }
                        )
                        ContactSyncBlocked                      = $False;
                        DataBackupBlocked                       = $False;
                        Description                             = "";
                        DeviceComplianceRequired                = $True;
                        DisplayName                             = "DSC Policy";
                        FingerprintBlocked                      = $False;
                        ManagedBrowserToOpenLinksRequired       = $True;
                        MaximumPinRetries                       = 5;
                        MinimumPinLength                        = 4;
                        OrganizationalCredentialsRequired       = $False;
                        PeriodOfflineBeforeAccessCheck          = "PT12H";
                        PeriodOfflineBeforeWipeIsEnforced       = "P90D";
                        PeriodOnlineBeforeAccessCheck           = "PT30M";
                        PinCharacterSet                         = "alphanumericAndSymbol";
                        PinRequired                             = $True;
                        PrintBlocked                            = $False;
                        SaveAsBlocked                           = $True;
                        SimplePinBlocked                        = $False;
                        id                                      = "12345-12345-12345-12345-12345"
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
