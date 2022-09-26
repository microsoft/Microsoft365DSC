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

            Function Get-DefaultTestParams
            {
                param (
                    [string]$description
                )
                return @{
                    AllowedDataStorageLocations             = @("sharePoint");
                    AllowedInboundDataTransferSources       = "managedApps";
                    AllowedOutboundClipboardSharingLevel    = "managedAppsWithPasteIn";
                    AllowedOutboundDataTransferDestinations = "managedApps";
                    AppGroupType                            = "selectedPublicApps";
                    Apps                                    = @("com.cisco.im.intune", "com.penlink.penpoint", "com.slack.intune");
                    Assignments                             = @("6ee86c9f-2b3c-471d-ad38-ff4673ed723e");
                    ContactSyncBlocked                      = $False;
                    DataBackupBlocked                       = $False;
                    Description                             = 'DSC Policy';
                    DeviceComplianceRequired                = $True;
                    DisplayName                             = "DSC Policy";
                    Ensure                                  = "Present"
                    ExcludedGroups                          = @("3eacc231-d77b-4efb-bb5f-310f68bd6198");
                    FingerprintBlocked                      = $False;
                    Credential                              = $Credential;
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
                    ScreenCaptureBlocked                    = $False;
                    ManagedBrowser                          = "notConfigured";
                    MinimumRequiredAppVersion               = "1.2";
                    MinimumRequiredOSVersion                = "1.1";
                    MinimumRequiredPatchVersion             = "2020-07-13";
                    MinimumWarningAppVersion                = "1.5";
                    MinimumWarningOSVersion                 = "1.5";
                    MinimumWarningPatchVersion              = "2021-07-13";
                    IsAssigned                              = $true;
                }

            }

            Function Get-DefaultReturnObj
            {
                param (
                    [string]$description
                )
                return @{
                    displayName   = "DSC Policy"
                    id            = "12345-12345-12345-12345-12345"
                    '@odata.type' = "#microsoft.graph.androidManagedAppProtection"
                    AllowedDataStorageLocations             = @("sharePoint");
                    AllowedInboundDataTransferSources       = "managedApps";
                    AllowedOutboundClipboardSharingLevel    = "managedAppsWithPasteIn";
                    AllowedOutboundDataTransferDestinations = "managedApps";
                    AppGroupType                            = "selectedPublicApps";
                    Apps                                    = @(
                        [pscustomobject]@{
                            id                  = "com.cisco.im.intune.android"
                            mobileAppIdentifier = @{
                                "AdditionalProperties" = @{
                                    "@odata.type" = "#microsoft.graph.androidMobileAppIdentifier"
                                    "packageid"      = "com.cisco.im.intune"
                                }
                            }
                        },
                        [pscustomobject]@{
                            id                  = "com.penlink.penpoint.android"
                            mobileAppIdentifier = @{
                                "AdditionalProperties" = @{
                                    "@odata.type" = "#microsoft.graph.androidMobileAppIdentifier"
                                    "packageid"      = "com.penlink.penpoint"
                                }
                            }
                        },
                        [pscustomobject]@{
                            id                  = "com.slack.intune.android"
                            mobileAppIdentifier = @{
                                'AdditionalProperties' = @{
                                    "@odata.type" = "#microsoft.graph.androidMobileAppIdentifier"
                                    "packageid"      = "com.slack.intune"
                                }
                            }
                        }
                    )
                    Assignments                             = @(
                        @{
                            id = '6ee86c9f-2b3c-471d-ad38-ff4673ed723e'
                            target = @{
                                'AdditionalProperties' = @{
                                    '@odata.type' = "#microsoft.graph.groupAssignmentTarget"
                                    groupId       = "6ee86c9f-2b3c-471d-ad38-ff4673ed723e"
                                }
                            }
                        },
                        @{
                            id = '3eacc231-d77b-4efb-bb5f-310f68bd6198'
                            target = @{
                                'AdditionalProperties' = @{
                                    '@odata.type' = "#microsoft.graph.exclusionGroupAssignmentTarget"
                                    groupId       = "3eacc231-d77b-4efb-bb5f-310f68bd6198"
                                }
                            }
                        }
                    )
                    ContactSyncBlocked                      = $False;
                    DataBackupBlocked                       = $False;
                    Description                             = 'DSC Policy'
                    DeviceComplianceRequired                = $True;
                    FingerprintBlocked                      = $False;
                    ManagedBrowserToOpenLinksRequired       = $True;
                    MaximumPinRetries                       = 5;
                    MinimumPinLength                        = 4;
                    OrganizationalCredentialsRequired       = $False;
                    PeriodBeforePinReset                    = New-TimeSpan -Days 60;
                    PeriodOfflineBeforeAccessCheck          = New-TimeSpan -Hours 12;
                    PeriodOfflineBeforeWipeIsEnforced       = New-TimeSpan -Days 90;
                    PeriodOnlineBeforeAccessCheck           = New-TimeSpan -Minutes 30;
                    PinCharacterSet                         = "alphanumericAndSymbol";
                    PinRequired                             = $True;
                    DisableAppPinIfDevicePinIsSet           = $False;
                    PrintBlocked                            = $False;
                    SaveAsBlocked                           = $True;
                    SimplePinBlocked                        = $False;
                    ScreenCaptureBlocked                    = $False;
                    ManagedBrowser                          = "notConfigured";
                    MinimumRequiredAppVersion               = "1.2";
                    MinimumRequiredOSVersion                = "1.1";
                    MinimumRequiredPatchVersion             = "2020-07-13";
                    MinimumWarningAppVersion                = "1.5";
                    MinimumWarningOSVersion                 = "1.5";
                    MinimumWarningPatchVersion              = "2021-07-13";
                    IsAssigned                              = $true;
                }
            }

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

            Mock -CommandName New-MgDeviceAppMgtAndroidManagedAppProtection -MockWith {
            }

            Mock -CommandName Update-MgDeviceAppMgtAndroidManagedAppProtection -MockWith {
            }

            Mock -CommandName Invoke-MgTargetDeviceAppMgtTargetedManagedAppConfigurationApp -MockWith {
            }

            Mock -CommandName set-MgDeviceAppMgtTargetedManagedAppConfiguration -MockWith {
            }

            Mock -CommandName Remove-MgDeviceAppManagementAndroidManagedAppProtection -MockWith {
            }
        }

        # Test contexts
        Context -Name "When the Policy doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = get-DefaultTestParams
                $Global:Count = 0
                Mock -CommandName Get-MgDeviceAppManagementAndroidManagedAppProtection -MockWith {
                    if ($Global:Count -eq 0)
                    {
                        $Global:Count++
                        return $null
                    }
                    else
                    {
                        return Get-DefaultReturnObj
                    }
                }
                Mock -CommandName New-MgDeviceAppMgtAndroidManagedAppProtection -MockWith {
                    return Get-DefaultReturnObj
                }
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It "Should return false from the Test method" {
                $Global:Count = 0
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should create the Policy from the Set method" {
                $Global:Count = 0
                Set-TargetResource @testParams
                Should -Invoke -CommandName "New-MgDeviceAppMgtAndroidManagedAppProtection" -Exactly 1
            }
        }

        Context -Name "When the policy already exists and is NOT in the Desired State" -Fixture {
            BeforeAll {
                $testParams = get-DefaultTestParams
                $testParams.ManagedBrowserToOpenLinksRequired       = $False #Drift


                Mock -CommandName Get-MgDeviceAppManagementAndroidManagedAppProtection -MockWith {
                    return Get-DefaultReturnObj
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
                Should -Invoke -CommandName Update-MgDeviceAppMgtAndroidManagedAppProtection -Exactly 1
            }
        }

        Context -Name "When the policy already exists and IS in the Desired State" -Fixture {
            BeforeAll {
                $testParams = get-DefaultTestParams

                Mock -CommandName Get-MgDeviceAppManagementAndroidManagedAppProtection -MockWith {
                    return Get-DefaultReturnObj
                }
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "When the policy exists and it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = get-DefaultTestParams
                $testParams.Ensure = 'Absent'

                Mock -CommandName Get-MgDeviceAppManagementAndroidManagedAppProtection -MockWith {
                    return Get-DefaultReturnObj
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
                $Global:CurrentModeIsExport = $true
                $testParams = @{
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgDeviceAppManagementAndroidManagedAppProtection -MockWith {
                    return Get-DefaultReturnObj
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
