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
    -DscResource "IntuneMobileAppsStoreApp" -GenericStubModule $GenericStubPath
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

            Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-DeviceAppManagementAppCategory -MockWith {
            }

            Mock -CommandName Update-DeviceAppManagementPolicyAssignment -MockWith {
            }

            Mock -CommandName Update-MgBetaDeviceAppManagementMobileApp -MockWith {
            }

            Mock -CommandName Invoke-MgGraphRequest -MockWith {
                return @{
                    appStoreUrl = "FakeStringValue"
                    minimumSupportedOperatingSystem = @{
                        v15_0 = $True
                        v12_0 = $True
                        v16_0 = $True
                        v10_0 = $True
                        v11_0 = $True
                        v17_0 = $True
                        v9_0 = $True
                        v18_0 = $True
                        v13_0 = $True
                        v8_0 = $True
                        v14_0 = $True
                    }
                    bundleId = "FakeStringValue"
                    '@odata.type' = "#microsoft.graph.iosStoreApp"
                    applicableDeviceType = @{
                        iPad = $True
                        iPhoneAndIPod = $True
                    }
                    description = "FakeStringValue"
                    developer = "FakeStringValue"
                    displayName = "FakeStringValue"
                    Id = "FakeStringValue"
                    informationUrl = "FakeStringValue"
                    isFeatured = $True
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
                }
            }

            Mock -CommandName Remove-MgBetaDeviceAppManagementMobileApp -MockWith {
            }

            Mock -CommandName Get-MgBetaDeviceAppManagementMobileApp -MockWith {
                return @{
                    appStoreUrl = "FakeStringValue"
                    minimumSupportedOperatingSystem = @{
                        v15_0 = $True
                        v12_0 = $True
                        v16_0 = $True
                        v10_0 = $True
                        v11_0 = $True
                        v17_0 = $True
                        v9_0 = $True
                        v18_0 = $True
                        v13_0 = $True
                        v8_0 = $True
                        v14_0 = $True
                    }
                    bundleId = "FakeStringValue"
                    '@odata.type' = "#microsoft.graph.iosStoreApp"
                    applicableDeviceType = @{
                        iPad = $True
                        iPhoneAndIPod = $True
                    }
                    Categories = @(
                        @{
                            Id = "FakeStringValue"
                            DisplayName = "FakeStringValue"
                        }
                    )
                    description = "FakeStringValue"
                    developer = "FakeStringValue"
                    displayName = "FakeStringValue"
                    Id = "FakeStringValue"
                    informationUrl = "FakeStringValue"
                    isFeatured = $True
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
            }

        }

        # Test contexts
        Context -Name "The IntuneMobileAppsStoreApp should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    applicableDeviceType = (New-CimInstance -ClassName MSFT_MicrosoftGraphiosDeviceType -Property @{
                        iPad = $True
                        iPhoneAndIPod = $True
                    } -ClientOnly)
                    appStoreUrl = "FakeStringValue"
                    bundleId = "FakeStringValue"
                    Categories = [CimInstance[]]@((New-CimInstance -ClassName MSFT_DeviceManagementMobileAppCategory -Property @{
                        Id = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                    } -ClientOnly))
                    description = "FakeStringValue"
                    developer = "FakeStringValue"
                    displayName = "FakeStringValue"
                    Id = "FakeStringValue"
                    informationUrl = "FakeStringValue"
                    isFeatured = $True
                    LargeIcon = (New-CimInstance -ClassName MSFT_MicrosoftGraphmimeContent -Property @{
                        Type = "FakeStringValue"
                        Value = "VGVzdA==" # Base64 encoded string for "Test"
                    } -ClientOnly)
                    minimumSupportedOperatingSystem = (New-CimInstance -ClassName MSFT_MicrosoftGraphiosMinimumOperatingSystem -Property @{
                        v15_0 = $True
                        v12_0 = $True
                        v16_0 = $True
                        v10_0 = $True
                        v11_0 = $True
                        v17_0 = $True
                        v9_0 = $True
                        v18_0 = $True
                        v13_0 = $True
                        v8_0 = $True
                        v14_0 = $True
                    } -ClientOnly)
                    Notes = "FakeStringValue"
                    Owner = "FakeStringValue"
                    PrivacyInformationUrl = "FakeStringValue"
                    Publisher = "FakeStringValue"
                    RoleScopeTagIds = @("FakeStringValue")
                    TargetPlatform = "IOS"
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

        Context -Name "The IntuneMobileAppsStoreApp exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    applicableDeviceType = (New-CimInstance -ClassName MSFT_MicrosoftGraphiosDeviceType -Property @{
                        iPad = $True
                        iPhoneAndIPod = $True
                    } -ClientOnly)
                    appStoreUrl = "FakeStringValue"
                    bundleId = "FakeStringValue"
                    Categories = [CimInstance[]]@((New-CimInstance -ClassName MSFT_DeviceManagementMobileAppCategory -Property @{
                        Id = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                    } -ClientOnly))
                    description = "FakeStringValue"
                    developer = "FakeStringValue"
                    displayName = "FakeStringValue"
                    Id = "FakeStringValue"
                    informationUrl = "FakeStringValue"
                    isFeatured = $True
                    LargeIcon = (New-CimInstance -ClassName MSFT_MicrosoftGraphmimeContent -Property @{
                        Type = "FakeStringValue"
                        Value = "VGVzdA==" # Base64 encoded string for "Test"
                    } -ClientOnly)
                    minimumSupportedOperatingSystem = (New-CimInstance -ClassName MSFT_MicrosoftGraphiosMinimumOperatingSystem -Property @{
                        v15_0 = $True
                        v12_0 = $True
                        v16_0 = $True
                        v10_0 = $True
                        v11_0 = $True
                        v17_0 = $True
                        v9_0 = $True
                        v18_0 = $True
                        v13_0 = $True
                        v8_0 = $True
                        v14_0 = $True
                    } -ClientOnly)
                    Notes = "FakeStringValue"
                    Owner = "FakeStringValue"
                    PrivacyInformationUrl = "FakeStringValue"
                    Publisher = "FakeStringValue"
                    RoleScopeTagIds = @("FakeStringValue")
                    TargetPlatform = "IOS"
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

        Context -Name "The IntuneMobileAppsStoreApp Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    applicableDeviceType = (New-CimInstance -ClassName MSFT_MicrosoftGraphiosDeviceType -Property @{
                        iPad = $True
                        iPhoneAndIPod = $True
                    } -ClientOnly)
                    appStoreUrl = "FakeStringValue"
                    bundleId = "FakeStringValue"
                    Categories = [CimInstance[]]@((New-CimInstance -ClassName MSFT_DeviceManagementMobileAppCategory -Property @{
                        Id = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                    } -ClientOnly))
                    description = "FakeStringValue"
                    developer = "FakeStringValue"
                    displayName = "FakeStringValue"
                    Id = "FakeStringValue"
                    informationUrl = "FakeStringValue"
                    isFeatured = $True
                    LargeIcon = (New-CimInstance -ClassName MSFT_MicrosoftGraphmimeContent -Property @{
                        Type = "FakeStringValue"
                        Value = "VGVzdA==" # Base64 encoded string for "Test"
                    } -ClientOnly)
                    minimumSupportedOperatingSystem = (New-CimInstance -ClassName MSFT_MicrosoftGraphiosMinimumOperatingSystem -Property @{
                        v15_0 = $True
                        v12_0 = $True
                        v16_0 = $True
                        v10_0 = $True
                        v11_0 = $True
                        v17_0 = $True
                        v9_0 = $True
                        v18_0 = $True
                        v13_0 = $True
                        v8_0 = $True
                        v14_0 = $True
                    } -ClientOnly)
                    Notes = "FakeStringValue"
                    Owner = "FakeStringValue"
                    PrivacyInformationUrl = "FakeStringValue"
                    Publisher = "FakeStringValue"
                    RoleScopeTagIds = @("FakeStringValue")
                    TargetPlatform = "IOS"
                    Ensure = "Present"
                    Credential = $Credential;
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The IntuneMobileAppsStoreApp exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    applicableDeviceType = (New-CimInstance -ClassName MSFT_MicrosoftGraphiosDeviceType -Property @{
                        iPad = $True
                        iPhoneAndIPod = $True
                    } -ClientOnly)
                    appStoreUrl = "FakeStringValue"
                    bundleId = "FakeStringValue"
                    Categories = [CimInstance[]]@((New-CimInstance -ClassName MSFT_DeviceManagementMobileAppCategory -Property @{
                        Id = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                    } -ClientOnly))
                    description = "FakeStringValue"
                    developer = "FakeStringValue"
                    displayName = "FakeStringValue"
                    Id = "FakeStringValue"
                    informationUrl = "FakeStringValue"
                    isFeatured = $True
                    LargeIcon = (New-CimInstance -ClassName MSFT_MicrosoftGraphmimeContent -Property @{
                        Type = "FakeStringValue"
                        Value = "VGVzdA==" # Base64 encoded string for "Test"
                    } -ClientOnly)
                    minimumSupportedOperatingSystem = (New-CimInstance -ClassName MSFT_MicrosoftGraphiosMinimumOperatingSystem -Property @{
                        v15_0 = $False # Drift
                        v12_0 = $True
                        v16_0 = $True
                        v10_0 = $True
                        v11_0 = $True
                        v17_0 = $True
                        v9_0 = $True
                        v18_0 = $True
                        v13_0 = $True
                        v8_0 = $True
                        v14_0 = $True
                    } -ClientOnly)
                    Notes = "FakeStringValue"
                    Owner = "FakeStringValue"
                    PrivacyInformationUrl = "FakeStringValue"
                    Publisher = "FakeStringValue"
                    RoleScopeTagIds = @("FakeStringValue")
                    TargetPlatform = "IOS"
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
