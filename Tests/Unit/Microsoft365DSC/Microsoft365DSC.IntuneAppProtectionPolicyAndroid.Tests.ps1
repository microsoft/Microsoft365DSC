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
    -DscResource "IntuneAppProtectionPolicyAndroid" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString "Pass@word1" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {

            }

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            Mock -CommandName Set-M365DSCIntuneAppProtectionPolicyAndroid -MockWith {
            }
            Mock -CommandName Set-M365DSCIntuneAppProtectionPolicyAndroidAssignment -MockWith {
            }
            Mock -CommandName Set-M365DSCIntuneAppProtectionPolicyAndroidApps -MockWith {
            }
            Mock -CommandName New-M365DSCIntuneAppProtectionPolicyAndroid -MockWith {
            }
            Mock -CommandName Remove-IntuneAppProtectionPolicy -MockWith {
            }
            Mock -CommandName Remove-MgDeviceAppManagementAndroidManagedAppProtection -MockWith {
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
                    AppGroupType                            = "selectedPublicApps";
                    Apps                                    = @("com.cisco.im.intune.android", "com.penlink.penpoint.android", "com.slack.intune.android");
                    Assignments                             = @("6ee86c9f-2b3c-471d-ad38-ff4673ed723e");
                    ContactSyncBlocked                      = $False;
                    DataBackupBlocked                       = $False;
                    Description                             = "";
                    DeviceComplianceRequired                = $True;
                    DisplayName                             = "DSC Policy";
                    Ensure                                  = "Present"
                    ExcludedGroups                          = @("3eacc231-d77b-4efb-bb5f-310f68bd6198");
                    FingerprintBlocked                      = $False;
                    Credential                      = $Credential;
                    ManagedBrowserToOpenLinksRequired       = $True;
                    MaximumPinRetries                       = 5;
                    MinimumPinLength                        = 4;
                    OrganizationalCredentialsRequired       = $False;
                    PeriodBeforePinReset                    = "P60D";
                    PeriodOfflineBeforeAccessCheck          = "PT12H";
                    PeriodOfflineBeforeWipeIsEnforced       = "P90D";
                    PeriodOnlineBeforeAccessCheck           = "PT30M";
                    PinCharacterSet                         = "alphanumericAndSymbol";
                    PinRequired                             = $True;
                    DisableAppPinIfDevicePinIsSet           = $False;
                    PrintBlocked                            = $False;
                    SaveAsBlocked                           = $True;
                    SimplePinBlocked                        = $False;
                }
                $Global:Count = 0
                Mock -CommandName Get-MgDeviceAppManagementAndroidManagedAppProtection -MockWith {
                    if ($Global:Count -eq 0)
                    {
                        $Global:Count++
                        return $null
                    }
                    else
                    {
                        return @{
                            displayName   = "DSC Policy"
                            id            = "12345-12345-12345-12345-12345"
                            '@odata.type' = "#microsoft.graph.androidManagedAppProtection"
                        }
                    }
                }
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should create the Policy from the Set method" {
                $Global:Count = 0
                Set-TargetResource @testParams
                Should -Invoke -CommandName "New-M365DSCIntuneAppProtectionPolicyAndroid" -Exactly 1
            }
        }

        Context -Name "When the policy already exists and is NOT in the Desired State" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowedDataStorageLocations             = @("sharePoint");
                    AllowedInboundDataTransferSources       = "managedApps";
                    AllowedOutboundClipboardSharingLevel    = "managedAppsWithPasteIn";
                    AllowedOutboundDataTransferDestinations = "managedApps";
                    AppGroupType                            = "selectedPublicApps";
                    Apps                                    = @("com.cisco.im.intune.android", "com.penlink.penpoint.android", "com.slack.intune.android");
                    Assignments                             = @("6ee86c9f-2b3c-471d-ad38-ff4673ed723e");
                    ContactSyncBlocked                      = $False;
                    DataBackupBlocked                       = $False;
                    Description                             = "";
                    DeviceComplianceRequired                = $True;
                    DisplayName                             = "DSC Policy";
                    Ensure                                  = "Present"
                    ExcludedGroups                          = @("3eacc231-d77b-4efb-bb5f-310f68bd6198");
                    FingerprintBlocked                      = $False;
                    Credential                      = $Credential;
                    ManagedBrowserToOpenLinksRequired       = $False; #Drift
                    MaximumPinRetries                       = 5;
                    MinimumPinLength                        = 4;
                    OrganizationalCredentialsRequired       = $False;
                    PeriodBeforePinReset                    = "P60D";
                    PeriodOfflineBeforeAccessCheck          = "PT12H";
                    PeriodOfflineBeforeWipeIsEnforced       = "P90D";
                    PeriodOnlineBeforeAccessCheck           = "PT30M";
                    PinCharacterSet                         = "alphanumericAndSymbol";
                    PinRequired                             = $True;
                    DisableAppPinIfDevicePinIsSet           = $False;
                    PrintBlocked                            = $False;
                    SaveAsBlocked                           = $True;
                    SimplePinBlocked                        = $False;
                }

                Mock -CommandName Get-MgDeviceAppManagementAndroidManagedAppProtection -MockWith {
                    return @{
                        displayName   = "DSC Policy"
                        id            = "12345-12345-12345-12345-12345"
                        '@odata.type' = "#microsoft.graph.androidManagedAppProtection"
                    }
                }

                Mock -CommandName Get-M365DSCIntuneAppProtectionPolicyAndroid -MockWith {
                    return @{
                        '@odata.type'                           = "#microsoft.graph.androidManagedAppProtection"
                        AllowedDataStorageLocations             = @("sharePoint");
                        AllowedInboundDataTransferSources       = "managedApps";
                        AllowedOutboundClipboardSharingLevel    = "managedAppsWithPasteIn";
                        AllowedOutboundDataTransferDestinations = "managedApps";
                        AppGroupType                            = "selectedPublicApps";
                        Apps                                    = @(
                            @{
                                id                  = "com.cisco.im.intune.android.android"
                                mobileAppIdentifier = @{
                                    "@odata.type" = "#microsoft.graph.androidMobileAppIdentifier"
                                    packageid      = "com.cisco.im.intune.android"
                                }
                            },
                            @{
                                id                  = "com.penlink.penpoint.android.android"
                                mobileAppIdentifier = @{
                                    "@odata.type" = "#microsoft.graph.androidMobileAppIdentifier"
                                    packageid      = "com.penlink.penpoint.android"
                                }
                            },
                            @{
                                id                  = "com.slack.intune.android.android"
                                mobileAppIdentifier = @{
                                    "@odata.type" = "#microsoft.graph.androidMobileAppIdentifier"
                                    packageid      = "com.slack.intune.android"
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
                        PeriodBeforePinReset                    = "P60D";
                        PeriodOfflineBeforeAccessCheck          = "PT12H";
                        PeriodOfflineBeforeWipeIsEnforced       = "P90D";
                        PeriodOnlineBeforeAccessCheck           = "PT30M";
                        PinCharacterSet                         = "alphanumericAndSymbol";
                        PinRequired                             = $True;
                        DisableAppPinIfDevicePinIsSet           = $False;
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
                Should -Invoke -CommandName Set-M365DSCIntuneAppProtectionPolicyAndroid -Exactly 1
            }
        }

        Context -Name "When the policy already exists and IS in the Desired State" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowedDataStorageLocations             = @("sharePoint");
                    AllowedInboundDataTransferSources       = "managedApps";
                    AllowedOutboundClipboardSharingLevel    = "managedAppsWithPasteIn";
                    AllowedOutboundDataTransferDestinations = "managedApps";
                    AppGroupType                            = "selectedPublicApps";
                    Apps                                    = @("com.cisco.im.intune.android", "com.penlink.penpoint.android", "com.slack.intune.android");
                    Assignments                             = @("6ee86c9f-2b3c-471d-ad38-ff4673ed723e");
                    ContactSyncBlocked                      = $False;
                    DataBackupBlocked                       = $False;
                    Description                             = "";
                    DeviceComplianceRequired                = $True;
                    DisplayName                             = "DSC Policy";
                    Ensure                                  = "Present"
                    ExcludedGroups                          = @("3eacc231-d77b-4efb-bb5f-310f68bd6198");
                    FingerprintBlocked                      = $False;
                    Credential                      = $Credential;
                    ManagedBrowserToOpenLinksRequired       = $True;
                    MaximumPinRetries                       = 5;
                    MinimumPinLength                        = 4;
                    OrganizationalCredentialsRequired       = $False;
                    PeriodBeforePinReset                    = "P60D";
                    PeriodOfflineBeforeAccessCheck          = "PT12H";
                    PeriodOfflineBeforeWipeIsEnforced       = "P90D";
                    PeriodOnlineBeforeAccessCheck           = "PT30M";
                    PinCharacterSet                         = "alphanumericAndSymbol";
                    PinRequired                             = $True;
                    DisableAppPinIfDevicePinIsSet           = $False;
                    PrintBlocked                            = $False;
                    SaveAsBlocked                           = $True;
                    SimplePinBlocked                        = $False;
                }

                Mock -CommandName Get-MgDeviceAppManagementAndroidManagedAppProtection -MockWith {
                    return @{
                        displayName   = "DSC Policy"
                        id            = "12345-12345-12345-12345-12345"
                        '@odata.type' = "#microsoft.graph.androidManagedAppProtection"
                    }
                }

                Mock -CommandName Get-M365DSCIntuneAppProtectionPolicyAndroid -MockWith {
                    @{
                        '@odata.type'                           = "#microsoft.graph.androidManagedAppProtection"
                        AllowedDataStorageLocations             = @("sharePoint");
                        AllowedInboundDataTransferSources       = "managedApps";
                        AllowedOutboundClipboardSharingLevel    = "managedAppsWithPasteIn";
                        AllowedOutboundDataTransferDestinations = "managedApps";
                        AppGroupType                            = "selectedPublicApps";
                        Apps                                    = @(
                            @{
                                id                  = "com.cisco.im.intune.android.android"
                                mobileAppIdentifier = @{
                                    "@odata.type" = "#microsoft.graph.androidMobileAppIdentifier"
                                    packageid      = "com.cisco.im.intune.android"
                                }
                            },
                            @{
                                id                  = "com.penlink.penpoint.android.android"
                                mobileAppIdentifier = @{
                                    "@odata.type" = "#microsoft.graph.androidMobileAppIdentifier"
                                    packageid      = "com.penlink.penpoint.android"
                                }
                            },
                            @{
                                id                  = "com.slack.intune.android.android"
                                mobileAppIdentifier = @{
                                    "@odata.type" = "#microsoft.graph.androidMobileAppIdentifier"
                                    packageid      = "com.slack.intune.android"
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
                        PeriodBeforePinReset                    = "P60D";
                        PeriodOfflineBeforeAccessCheck          = "PT12H";
                        PeriodOfflineBeforeWipeIsEnforced       = "P90D";
                        PeriodOnlineBeforeAccessCheck           = "PT30M";
                        PinCharacterSet                         = "alphanumericAndSymbol";
                        PinRequired                             = $True;
                        DisableAppPinIfDevicePinIsSet           = $False;
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
                    AppGroupType                            = "selectedPublicApps";
                    Apps                                    = @("com.cisco.im.intune.android", "com.penlink.penpoint.android", "com.slack.intune.android");
                    Assignments                             = @("6ee86c9f-2b3c-471d-ad38-ff4673ed723e");
                    ContactSyncBlocked                      = $False;
                    DataBackupBlocked                       = $False;
                    Description                             = "";
                    DeviceComplianceRequired                = $True;
                    DisplayName                             = "DSC Policy";
                    Ensure                                  = "Absent"
                    ExcludedGroups                          = @("3eacc231-d77b-4efb-bb5f-310f68bd6198");
                    FingerprintBlocked                      = $False;
                    Credential                      = $Credential;
                    ManagedBrowserToOpenLinksRequired       = $True;
                    MaximumPinRetries                       = 5;
                    MinimumPinLength                        = 4;
                    OrganizationalCredentialsRequired       = $False;
                    PeriodBeforePinReset                    = "P60D";
                    PeriodOfflineBeforeAccessCheck          = "PT12H";
                    PeriodOfflineBeforeWipeIsEnforced       = "P90D";
                    PeriodOnlineBeforeAccessCheck           = "PT30M";
                    PinCharacterSet                         = "alphanumericAndSymbol";
                    PinRequired                             = $True;
                    DisableAppPinIfDevicePinIsSet           = $False;
                    PrintBlocked                            = $False;
                    SaveAsBlocked                           = $True;
                    SimplePinBlocked                        = $False;
                }

                Mock -CommandName Get-MgDeviceAppManagementAndroidManagedAppProtection -MockWith {
                    return @{
                        displayName   = "DSC Policy"
                        id            = "12345-12345-12345-12345-12345"
                        '@odata.type' = "#microsoft.graph.androidManagedAppProtection"
                    }
                }

                Mock -CommandName Get-M365DSCIntuneAppProtectionPolicyAndroid -MockWith {
                    @{
                        '@odata.type'                           = "#microsoft.graph.androidManagedAppProtection"
                        AllowedDataStorageLocations             = @("sharePoint");
                        AllowedInboundDataTransferSources       = "managedApps";
                        AllowedOutboundClipboardSharingLevel    = "managedAppsWithPasteIn";
                        AllowedOutboundDataTransferDestinations = "managedApps";
                        AppGroupType                            = "selectedPublicApps";
                        Apps                                    = @(
                            @{
                                id                  = "com.cisco.im.intune.android.android"
                                mobileAppIdentifier = @{
                                    "@odata.type" = "#microsoft.graph.androidMobileAppIdentifier"
                                    packageid      = "com.cisco.im.intune.android"
                                }
                            },
                            @{
                                id                  = "com.penlink.penpoint.android.android"
                                mobileAppIdentifier = @{
                                    "@odata.type" = "#microsoft.graph.androidMobileAppIdentifier"
                                    packageid      = "com.penlink.penpoint.android"
                                }
                            },
                            @{
                                id                  = "com.slack.intune.android.android"
                                mobileAppIdentifier = @{
                                    "@odata.type" = "#microsoft.graph.androidMobileAppIdentifier"
                                    packageid      = "com.slack.intune.android"
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
                        PeriodBeforePinReset                    = "P60D";
                        PeriodOfflineBeforeAccessCheck          = "PT12H";
                        PeriodOfflineBeforeWipeIsEnforced       = "P90D";
                        PeriodOnlineBeforeAccessCheck           = "PT30M";
                        PinCharacterSet                         = "alphanumericAndSymbol";
                        PinRequired                             = $True;
                        DisableAppPinIfDevicePinIsSet           = $False;
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
                Should -Invoke -CommandName Remove-MgDeviceAppManagementAndroidManagedAppProtection -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgDeviceAppManagementAndroidManagedAppProtection -MockWith {
                    return @{
                        displayName   = "DSC Policy"
                        id            = "12345-12345-12345-12345-12345"
                        '@odata.type' = "#microsoft.graph.androidManagedAppProtection"
                    }
                }

                Mock -CommandName Get-M365DSCIntuneAppProtectionPolicyAndroid -MockWith {
                    @{
                        '@odata.type'                           = "#microsoft.graph.androidManagedAppProtection"
                        AllowedDataStorageLocations             = @("sharePoint");
                        AllowedInboundDataTransferSources       = "managedApps";
                        AllowedOutboundClipboardSharingLevel    = "managedAppsWithPasteIn";
                        AllowedOutboundDataTransferDestinations = "managedApps";
                        AppGroupType                            = "selectedPublicApps";
                        Apps                                    = @(
                            @{
                                id                  = "com.cisco.im.intune.android.android"
                                mobileAppIdentifier = @{
                                    "@odata.type" = "#microsoft.graph.androidMobileAppIdentifier"
                                    packageid      = "com.cisco.im.intune.android"
                                }
                            },
                            @{
                                id                  = "com.penlink.penpoint.android.android"
                                mobileAppIdentifier = @{
                                    "@odata.type" = "#microsoft.graph.androidMobileAppIdentifier"
                                    packageid      = "com.penlink.penpoint.android"
                                }
                            },
                            @{
                                id                  = "com.slack.intune.android.android"
                                mobileAppIdentifier = @{
                                    "@odata.type" = "#microsoft.graph.androidMobileAppIdentifier"
                                    packageid      = "com.slack.intune.android"
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
                        PeriodBeforePinReset                    = "P60D";
                        PeriodOfflineBeforeAccessCheck          = "PT12H";
                        PeriodOfflineBeforeWipeIsEnforced       = "P90D";
                        PeriodOnlineBeforeAccessCheck           = "PT30M";
                        PinCharacterSet                         = "alphanumericAndSymbol";
                        PinRequired                             = $True;
                        DisableAppPinIfDevicePinIsSet           = $False;
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
