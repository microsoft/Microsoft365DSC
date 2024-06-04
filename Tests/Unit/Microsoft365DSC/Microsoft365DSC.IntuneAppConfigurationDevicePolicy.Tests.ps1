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
    -DscResource "IntuneAppConfigurationDevicePolicy" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgBetaDeviceAppManagementMobileAppConfiguration -MockWith {
            }

            Mock -CommandName New-MgBetaDeviceAppManagementMobileAppConfiguration -MockWith {
            }

            Mock -CommandName Remove-MgBetaDeviceAppManagementMobileAppConfiguration -MockWith {
            }

            Mock -CommandName Update-DeviceConfigurationPolicyAssignment -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false

            Mock -CommandName Get-MgBetaDeviceAppManagementMobileAppConfigurationAssignment -MockWith {
            }

            Mock -CommandName Get-MgBetaDeviceAppManagementMobileApp -MockWith {
            }

        }
        # Test contexts
        Context -Name "The IntuneAppConfigurationDevicePolicy should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    ConnectedAppsEnabled = $True
                    description = "FakeStringValue"
                    displayName = "FakeStringValue"
                    id = "FakeStringValue"
                    PackageId = "FakeStringValue"
                    PayloadJson = "FakeStringValue"
                    permissionActions = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphandroidPermissionAction -Property @{
                            permission = "FakeStringValue"
                            action = "prompt"
                        } -ClientOnly)
                    )
                    profileApplicability = "default"
                    roleScopeTagIds = @("FakeStringValue")
                    targetedMobileApps = @("FakeStringValue")
                    Ensure = "Present"
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceAppManagementMobileApp -MockWith {
                    return @{
                        Id = "FakeStringValue"
                        AdditionalProperties = @{
                            packageId = "FakeStringValue"
                            '@odata.type' = "#microsoft.graph.androidManagedStoreApp"
                        }
                    }
                }

                Mock -CommandName Get-MgBetaDeviceAppManagementMobileAppConfiguration -MockWith {
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
                Should -Invoke -CommandName New-MgBetaDeviceAppManagementMobileAppConfiguration -Exactly 1
            }
        }

        Context -Name "The IntuneAppConfigurationDevicePolicy exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    ConnectedAppsEnabled = $True
                    description = "FakeStringValue"
                    displayName = "FakeStringValue"
                    id = "FakeStringValue"
                    PackageId = "FakeStringValue"
                    PayloadJson = "FakeStringValue"
                    permissionActions = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphandroidPermissionAction -Property @{
                            permission = "FakeStringValue"
                            action = "prompt"
                        } -ClientOnly)
                    )
                    profileApplicability = "default"
                    roleScopeTagIds = @("FakeStringValue")
                    targetedMobileApps = @("FakeStringValue")
                    Ensure = 'Absent'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceAppManagementMobileApp -MockWith {
                    return @{
                        Id = "FakeStringValue"
                        AdditionalProperties = @{
                            packageId = "FakeStringValue"
                            '@odata.type' = "#microsoft.graph.androidManagedStoreApp"
                        }
                    }
                }

                Mock -CommandName Get-MgBetaDeviceAppManagementMobileAppConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            appSupportsOemConfig = $True
                            '@odata.type' = "#microsoft.graph.androidManagedStoreAppConfiguration"
                            payloadJson = "FakeStringValue"
                            profileApplicability = "default"
                            permissionActions = @(
                                @{
                                    permission = "FakeStringValue"
                                    action = "prompt"
                                }
                            )
                            packageId = "FakeStringValue"
                            connectedAppsEnabled = $True
                        }
                        createdDateTime = "2023-01-01T00:00:00.0000000+01:00"
                        description = "FakeStringValue"
                        displayName = "FakeStringValue"
                        id = "FakeStringValue"
                        lastModifiedDateTime = "2023-01-01T00:00:00.0000000+01:00"
                        roleScopeTagIds = @("FakeStringValue")
                        targetedMobileApps = @("FakeStringValue")
                        version = 25
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
                Should -Invoke -CommandName Remove-MgBetaDeviceAppManagementMobileAppConfiguration -Exactly 1
            }
        }
        Context -Name "The IntuneAppConfigurationDevicePolicy Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    ConnectedAppsEnabled = $True
                    description = "FakeStringValue"
                    displayName = "FakeStringValue"
                    id = "FakeStringValue"
                    PackageId = "FakeStringValue"
                    PayloadJson = "FakeStringValue"
                    permissionActions = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphandroidPermissionAction -Property @{
                            permission = "FakeStringValue"
                            action = "prompt"
                        } -ClientOnly)
                    )
                    profileApplicability = "default"
                    roleScopeTagIds = @("FakeStringValue")
                    targetedMobileApps = @("FakeStringValue")
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceAppManagementMobileApp -MockWith {
                    return @{
                        Id = "FakeStringValue"
                        AdditionalProperties = @{
                            packageId = "FakeStringValue"
                            '@odata.type' = "#microsoft.graph.androidManagedStoreApp"
                        }
                    }
                }

                Mock -CommandName Get-MgBetaDeviceAppManagementMobileAppConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            appSupportsOemConfig = $True
                            '@odata.type' = "#microsoft.graph.androidManagedStoreAppConfiguration"
                            payloadJson = "FakeStringValue"
                            profileApplicability = "default"
                            permissionActions = @(
                                @{
                                    permission = "FakeStringValue"
                                    action = "prompt"
                                }
                            )
                            packageId = "FakeStringValue"
                            connectedAppsEnabled = $True
                        }
                        createdDateTime = "2023-01-01T00:00:00.0000000+01:00"
                        description = "FakeStringValue"
                        displayName = "FakeStringValue"
                        id = "FakeStringValue"
                        lastModifiedDateTime = "2023-01-01T00:00:00.0000000+01:00"
                        roleScopeTagIds = @("FakeStringValue")
                        targetedMobileApps = @("FakeStringValue")
                        version = 25
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The IntuneAppConfigurationDevicePolicy exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = @()
                    ConnectedAppsEnabled = $True
                    description = "FakeStringValue"
                    displayName = "FakeStringValue"
                    id = "FakeStringValue"
                    PackageId = "FakeStringValue"
                    PayloadJson = "FakeStringValue"
                    permissionActions = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphandroidPermissionAction -Property @{
                            permission = "FakeStringValue"
                            action = "prompt"
                        } -ClientOnly)
                    )
                    profileApplicability = "default"
                    roleScopeTagIds = @("FakeStringValue")
                    targetedMobileApps = @("FakeStringValue")
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceAppManagementMobileApp -MockWith {
                    return @{
                        Id = "FakeStringValue"
                        AdditionalProperties = @{
                            packageId = "FakeStringValue"
                            '@odata.type' = "#microsoft.graph.androidManagedStoreApp"
                        }
                    }
                }

                Mock -CommandName Get-MgBetaDeviceAppManagementMobileAppConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            profileApplicability = "default"
                            packageId = "FakeStringValue"
                            permissionActions = @(
                                @{
                                    permission = "FakeStringValue"
                                    action = "prompt"
                                }
                            )
                            payloadJson = "FakeStringValue"
                        }
                        createdDateTime = "2023-01-01T00:00:00.0000000+01:00"
                        description = "FakeStringValue"
                        displayName = "FakeStringValue"
                        id = "FakeStringValue"
                        lastModifiedDateTime = "2023-01-01T00:00:00.0000000+01:00"
                        roleScopeTagIds = @("FakeStringValue")
                        targetedMobileApps = @("FakeStringValue")
                        version = 7
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
                Should -Invoke -CommandName Update-MgBetaDeviceAppManagementMobileAppConfiguration -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceAppManagementMobileAppConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            appSupportsOemConfig = $True
                            '@odata.type' = "#microsoft.graph.androidManagedStoreAppConfiguration"
                            payloadJson = "FakeStringValue"
                            profileApplicability = "default"
                            permissionActions = @(
                                @{
                                    permission = "FakeStringValue"
                                    action = "prompt"
                                }
                            )
                            packageId = "FakeStringValue"
                            connectedAppsEnabled = $True
                        }
                        createdDateTime = "2023-01-01T00:00:00.0000000+01:00"
                        description = "FakeStringValue"
                        displayName = "FakeStringValue"
                        id = "FakeStringValue"
                        lastModifiedDateTime = "2023-01-01T00:00:00.0000000+01:00"
                        roleScopeTagIds = @("FakeStringValue")
                        targetedMobileApps = @("FakeStringValue")
                        version = 25
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
