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
    -DscResource "IntuneMobileAppsLobAppAndroid" -GenericStubModule $GenericStubPath
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

            Mock -CommandName Remove-MgBetaDeviceAppManagementMobileApp -MockWith {
            }

            Mock -CommandName Invoke-MgGraphRequest -MockWith {
                return @{
                    AdditionalProperties = @{
                        packageId = "FakeStringValue"
                        '@odata.type' = "#microsoft.graph.androidLobApp"
                        minimumSupportedOperatingSystem = @{
                            v4_3 = $True
                            v7_0 = $True
                            v15_0 = $True
                            v10_0 = $True
                            v14_0 = $True
                            v12_0 = $True
                            v9_0 = $True
                            v4_0 = $True
                            v6_0 = $True
                            v5_0 = $True
                            v4_0_3 = $True
                            v13_0 = $True
                            v4_2 = $True
                            v8_0 = $True
                            v7_1 = $True
                            v4_1 = $True
                            v5_1 = $True
                            v11_0 = $True
                            v8_1 = $True
                            v4_4 = $True
                        }
                        fileName = "FakeStringValue.apk"
                        committedContentVersion = "FakeStringValue"
                        targetedPlatforms = "androidDeviceAdministrator"
                        versionName = "FakeStringValue"
                        versionCode = "FakeStringValue"
                    }
                    Categories = @(
                        @{
                            Id = "FakeStringValue"
                            DisplayName = "FakeStringValue"
                        }
                    )
                    dependentAppCount = 25
                    description = "FakeStringValue"
                    developer = "FakeStringValue"
                    displayName = "FakeStringValue"
                    Id = "FakeStringValue"
                    informationUrl = "FakeStringValue"
                    isFeatured = $True
                    LargeIcon = @{
                        Type = "FakeStringValue"
                        Value = [System.Convert]::FromBase64String("VGVzdA==")
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

            Mock -CommandName Get-MgBetaDeviceAppManagementMobileApp -MockWith {
                return @{
                    AdditionalProperties = @{
                        packageId = "FakeStringValue"
                        '@odata.type' = "#microsoft.graph.androidLobApp"
                        minimumSupportedOperatingSystem = @{
                            v4_3 = $True
                            v7_0 = $True
                            v15_0 = $True
                            v10_0 = $True
                            v14_0 = $True
                            v12_0 = $True
                            v9_0 = $True
                            v4_0 = $True
                            v6_0 = $True
                            v5_0 = $True
                            v4_0_3 = $True
                            v13_0 = $True
                            v4_2 = $True
                            v8_0 = $True
                            v7_1 = $True
                            v4_1 = $True
                            v5_1 = $True
                            v11_0 = $True
                            v8_1 = $True
                            v4_4 = $True
                        }
                        fileName = "FakeStringValue.apk"
                        committedContentVersion = "FakeStringValue"
                        targetedPlatforms = "androidDeviceAdministrator"
                        versionName = "FakeStringValue"
                        versionCode = "FakeStringValue"
                    }
                    Categories = @(
                        @{
                            Id = "FakeStringValue"
                            DisplayName = "FakeStringValue"
                        }
                    )
                    dependentAppCount = 25
                    description = "FakeStringValue"
                    developer = "FakeStringValue"
                    displayName = "FakeStringValue"
                    Id = "FakeStringValue"
                    informationUrl = "FakeStringValue"
                    isFeatured = $True
                    LargeIcon = @{
                        Type = "FakeStringValue"
                        Value = [System.Convert]::FromBase64String("VGVzdA==")
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
                            AdditionalProperties = @{
                                "@odata.type" = "#microsoft.graph.groupAssignmentTarget"
                                groupId = "26d60dd1-fab6-47bf-8656-358194c1a49d"
                            }
                            "deviceAndAppManagementAssignmentFilterId" = '12345-12345-12345-12345-12345'
                            "deviceAndAppManagementAssignmentFilterType" = "none"
                        }
                    }
                )
            }
        }

        # Test contexts
        Context -Name "The IntuneMobileAppsLobAppAndroid should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementMobileAppAssignment -Property @{
                            Id = "12345-12345-12345-12345-12345"
                            Intent = "required"
                            DeviceAndAppManagementAssignmentFilterType = "none"
                            dataType = "#microsoft.graph.groupAssignmentTarget"
                            GroupId = "26d60dd1-fab6-47bf-8656-358194c1a49d"
                        } -ClientOnly)
                    )
                    Categories = [CimInstance[]]@((New-CimInstance -ClassName MSFT_DeviceManagementMobileAppCategory -Property @{
                        Id = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                    } -ClientOnly))
                    description = "FakeStringValue"
                    developer = "FakeStringValue"
                    displayName = "FakeStringValue"
                    fileName = "FakeStringValue.apk"
                    Id = "FakeStringValue"
                    informationUrl = "FakeStringValue"
                    isFeatured = $True
                    LargeIcon = (New-CimInstance -ClassName MSFT_MicrosoftGraphmimeContent -Property @{
                        Type = "FakeStringValue"
                        Value = "VGVzdA==" # Base64 encoded string for "Test"
                    } -ClientOnly)
                    minimumSupportedOperatingSystem = (New-CimInstance -ClassName MSFT_MicrosoftGraphAndroidMinimumOperatingSystem -Property @{
                        v4_3 = $True
                        v7_0 = $True
                        v15_0 = $True
                        v10_0 = $True
                        v14_0 = $True
                        v12_0 = $True
                        v9_0 = $True
                        v4_0 = $True
                        v6_0 = $True
                        v5_0 = $True
                        v4_0_3 = $True
                        v13_0 = $True
                        v4_2 = $True
                        v8_0 = $True
                        v7_1 = $True
                        v4_1 = $True
                        v5_1 = $True
                        v11_0 = $True
                        v8_1 = $True
                        v4_4 = $True
                    } -ClientOnly)
                    Notes = "FakeStringValue"
                    Owner = "FakeStringValue"
                    packageId = "FakeStringValue"
                    PrivacyInformationUrl = "FakeStringValue"
                    Publisher = "FakeStringValue"
                    RoleScopeTagIds = @("FakeStringValue")
                    targetedPlatforms = "androidDeviceAdministrator"
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

        Context -Name "The IntuneMobileAppsLobAppAndroid exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementMobileAppAssignment -Property @{
                            Id = "12345-12345-12345-12345-12345"
                            Intent = "required"
                            DeviceAndAppManagementAssignmentFilterType = "none"
                            dataType = "#microsoft.graph.groupAssignmentTarget"
                            GroupId = "26d60dd1-fab6-47bf-8656-358194c1a49d"
                        } -ClientOnly)
                    )
                    Categories = [CimInstance[]]@((New-CimInstance -ClassName MSFT_DeviceManagementMobileAppCategory -Property @{
                        Id = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                    } -ClientOnly))
                    description = "FakeStringValue"
                    developer = "FakeStringValue"
                    displayName = "FakeStringValue"
                    fileName = "FakeStringValue.apk"
                    Id = "FakeStringValue"
                    informationUrl = "FakeStringValue"
                    isFeatured = $True
                    LargeIcon = (New-CimInstance -ClassName MSFT_MicrosoftGraphmimeContent -Property @{
                        Type = "FakeStringValue"
                        Value = "VGVzdA==" # Base64 encoded string for "Test"
                    } -ClientOnly)
                    minimumSupportedOperatingSystem = (New-CimInstance -ClassName MSFT_MicrosoftGraphAndroidMinimumOperatingSystem -Property @{
                        v4_3 = $True
                        v7_0 = $True
                        v15_0 = $True
                        v10_0 = $True
                        v14_0 = $True
                        v12_0 = $True
                        v9_0 = $True
                        v4_0 = $True
                        v6_0 = $True
                        v5_0 = $True
                        v4_0_3 = $True
                        v13_0 = $True
                        v4_2 = $True
                        v8_0 = $True
                        v7_1 = $True
                        v4_1 = $True
                        v5_1 = $True
                        v11_0 = $True
                        v8_1 = $True
                        v4_4 = $True
                    } -ClientOnly)
                    Notes = "FakeStringValue"
                    Owner = "FakeStringValue"
                    packageId = "FakeStringValue"
                    PrivacyInformationUrl = "FakeStringValue"
                    Publisher = "FakeStringValue"
                    RoleScopeTagIds = @("FakeStringValue")
                    targetedPlatforms = "androidDeviceAdministrator"
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

        Context -Name "The IntuneMobileAppsLobAppAndroid Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementMobileAppAssignment -Property @{
                            Id = "12345-12345-12345-12345-12345"
                            Intent = "required"
                            dataType = "#microsoft.graph.groupAssignmentTarget"
                            DeviceAndAppManagementAssignmentFilterType = "none"
                            GroupId = "26d60dd1-fab6-47bf-8656-358194c1a49d"
                        } -ClientOnly)
                    )
                    Categories = [CimInstance[]]@((New-CimInstance -ClassName MSFT_DeviceManagementMobileAppCategory -Property @{
                        Id = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                    } -ClientOnly))
                    description = "FakeStringValue"
                    developer = "FakeStringValue"
                    displayName = "FakeStringValue"
                    fileName = "FakeStringValue.apk"
                    Id = "FakeStringValue"
                    informationUrl = "FakeStringValue"
                    isFeatured = $True
                    LargeIcon = (New-CimInstance -ClassName MSFT_MicrosoftGraphmimeContent -Property @{
                        Type = "FakeStringValue"
                        Value = "VGVzdA==" # Base64 encoded string for "Test"
                    } -ClientOnly)
                    minimumSupportedOperatingSystem = (New-CimInstance -ClassName MSFT_MicrosoftGraphAndroidMinimumOperatingSystem -Property @{
                        v4_3 = $True
                        v7_0 = $True
                        v15_0 = $True
                        v10_0 = $True
                        v14_0 = $True
                        v12_0 = $True
                        v9_0 = $True
                        v4_0 = $True
                        v6_0 = $True
                        v5_0 = $True
                        v4_0_3 = $True
                        v13_0 = $True
                        v4_2 = $True
                        v8_0 = $True
                        v7_1 = $True
                        v4_1 = $True
                        v5_1 = $True
                        v11_0 = $True
                        v8_1 = $True
                        v4_4 = $True
                    } -ClientOnly)
                    Notes = "FakeStringValue"
                    Owner = "FakeStringValue"
                    packageId = "FakeStringValue"
                    PrivacyInformationUrl = "FakeStringValue"
                    Publisher = "FakeStringValue"
                    RoleScopeTagIds = @("FakeStringValue")
                    targetedPlatforms = "androidDeviceAdministrator"
                    Ensure = "Present"
                    Credential = $Credential;
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The IntuneMobileAppsLobAppAndroid exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementMobileAppAssignment -Property @{
                            Id = "12345-12345-12345-12345-12345"
                            Intent = "required"
                            DeviceAndAppManagementAssignmentFilterType = "none"
                            dataType = "#microsoft.graph.groupAssignmentTarget"
                            GroupId = "26d60dd1-fab6-47bf-8656-358194c1a49d"
                        } -ClientOnly)
                    )
                    Categories = [CimInstance[]]@((New-CimInstance -ClassName MSFT_DeviceManagementMobileAppCategory -Property @{
                        Id = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                    } -ClientOnly))
                    description = "FakeStringValue"
                    developer = "FakeStringValue"
                    displayName = "FakeStringValue"
                    fileName = "FakeStringValue.apk"
                    Id = "FakeStringValue"
                    informationUrl = "FakeStringValue"
                    isFeatured = $True
                    LargeIcon = (New-CimInstance -ClassName MSFT_MicrosoftGraphmimeContent -Property @{
                        Type = "FakeStringValue"
                        Value = "VGVzdA==" # Base64 encoded string for "Test"
                    } -ClientOnly)
                    minimumSupportedOperatingSystem = (New-CimInstance -ClassName MSFT_MicrosoftGraphAndroidMinimumOperatingSystem -Property @{
                        v4_3 = $True
                        v7_0 = $True
                        v15_0 = $True
                        v10_0 = $True
                        v14_0 = $True
                        v12_0 = $True
                        v9_0 = $True
                        v4_0 = $True
                        v6_0 = $True
                        v5_0 = $True
                        v4_0_3 = $True
                        v13_0 = $False # Drift
                        v4_2 = $True
                        v8_0 = $True
                        v7_1 = $True
                        v4_1 = $True
                        v5_1 = $True
                        v11_0 = $True
                        v8_1 = $True
                        v4_4 = $True
                    } -ClientOnly)
                    Notes = "FakeStringValue"
                    Owner = "FakeStringValue"
                    packageId = "FakeStringValue"
                    PrivacyInformationUrl = "FakeStringValue"
                    Publisher = "FakeStringValue"
                    RoleScopeTagIds = @("FakeStringValue")
                    targetedPlatforms = "androidDeviceAdministrator"
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
