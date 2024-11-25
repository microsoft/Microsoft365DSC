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
    -DscResource 'IntuneAndroidManagedStoreAppConfiguration' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {
            $secpasswd = ConvertTo-SecureString ((New-Guid).ToString()) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Update-MgBetaDeviceAppManagementMobileAppConfiguration -MockWith {
            }

            Mock -CommandName New-MgBetaDeviceAppManagementMobileAppConfiguration -MockWith {
            }

            Mock -CommandName Remove-MgBetaDeviceAppManagementMobileAppConfiguration -MockWith {
            }

            Mock -CommandName Get-MgBetaDeviceManagementDeviceCompliancePolicyAssignment -MockWith {

                return @()
            }
            Mock -CommandName Update-DeviceConfigurationPolicyAssignment -MockWith {
            }
            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name "When the Android Managed Store App Configuration Policy doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName                                 = 'Test Android Managed Store App Configuration Policy'
                    Description                                 = 'Test Android Managed Store App Configuration Policy Description'
                    targetedMobileApps            = "{FakeStringValue}"
                    permissionActions                      = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_androidPermissionAction -Property @{
                            permission = "android.permission.READ_SMS"
                            action = "prompt"
                        } -ClientOnly)
                    )
                    appSupportsOemConfig                        = $False
                    connectedAppsEnabled                        = $False
                    packageId                                   = "app:org.mozilla.firefox"
                    payloadJson                                 = ""
                    profileApplicability                        = "androidDeviceOwner"
                    Ensure                                      = 'Present'
                    Credential                                  = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceAppManagementMobileAppConfiguration -MockWith {
                    return $null
                }
            }

            It 'Should return absent from the Get method' {
                    (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create the Android Managed Store App Configuration Policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'New-MgBetaDeviceAppManagementMobileAppConfiguration' -Exactly 1
            }
        }

        Context -Name 'When the Android Managed Store App Configuration Policy already exists and is NOT in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName                                 = 'Test Android Managed Store App Configuration Policy'
                    Description                                 = 'Test Android Managed Store App Configuration Policy Description'
                    targetedMobileApps                          = "{FakeStringValue}"
                    permissionActions                           = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_androidPermissionAction -Property @{
                            permission = "android.permission.READ_SMS"
                            action = "prompt"
                        } -ClientOnly)
                    )
                    appSupportsOemConfig                        = $False
                    connectedAppsEnabled                        = $False
                    packageId                                   = "app:org.mozilla.firefox"
                    payloadJson                                 = ""
                    profileApplicability                        = "androidDeviceOwner"
                    Ensure                                      = 'Present'
                    Credential                                  = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceAppManagementMobileAppConfiguration -MockWith {
                    return @{
                        DisplayName                      = 'Test Android Managed Store App Configuration Policy'
                        Description                      = 'Different Value'
                        Id                               = 'e30954ac-a65e-4dcb-ab79-91d45f3c52b4'
                        targetedMobileApps               = "{FakeStringValue}"
                        AdditionalProperties             = @{
                            permissionActions = @(
                               @{
                                    permission      = "android.permission.READ_SMS"
                                    action          = "prompt"

                                }
                            )
                            appSupportsOemConfig      = $False
                            connectedAppsEnabled      = $False
                            packageId                 = "app:org.mozilla.firefox"
                            payloadJson               = ""
                            profileApplicability      = "androidDeviceOwner"
                            '@odata.type'             = '#microsoft.graph.androidManagedStoreAppConfiguration'
                        }
                    }
                }
            }

            It 'Should return Present from the Get method' {
                    (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update the Android Managed Store App Configuration Policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgBetaDeviceAppManagementMobileAppConfiguration -Exactly 1
               
            }
        }

        Context -Name 'When the policy already exists and IS in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName                                 = 'Test Android Managed Store App Configuration Policy'
                    Description                                 = 'Test Android Managed Store App Configuration Policy Description'
                    targetedMobileApps                          = "{FakeStringValue}"
                    permissionActions                           = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_androidPermissionAction -Property @{
                            permission = "android.permission.READ_SMS"
                            action = "prompt"
                        } -ClientOnly)
                    )
                    appSupportsOemConfig                        = $False
                    connectedAppsEnabled                        = $False
                    packageId                                   = "app:org.mozilla.firefox"
                    payloadJson                                 = ""
                    profileApplicability                        = "androidDeviceOwner"
                    Ensure                                      = 'Present'
                    Credential                                  = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceAppManagementMobileAppConfiguration -MockWith {
                    return @{
                        DisplayName                             = 'Test Android Managed Store App Configuration Policy'
                        Description                             = 'Test Android Managed Store App Configuration Policy Description'
                        Id                                      = 'e30954ac-a65e-4dcb-ab79-91d45f3c52b4'
                        targetedMobileApps                      = "{FakeStringValue}"
                        AdditionalProperties             = @{
                            permissionActions = @(
                               @{
                                    permission      = "android.permission.READ_SMS"
                                    action          = "prompt"
                                }
                            )
                            appSupportsOemConfig      = $False
                            connectedAppsEnabled      = $False
                            packageId                 = "app:org.mozilla.firefox"
                            payloadJson               = ""
                            profileApplicability      = "androidDeviceOwner"
                            '@odata.type'             = '#microsoft.graph.androidManagedStoreAppConfiguration'
                        }
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'When the policy exists and it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName                                 = 'Test Android Managed Store App Configuration Policy'
                    Description                                 = 'Test Android Managed Store App Configuration Policy Description'
                    targetedMobileApps                          = "{FakeStringValue}"
                    permissionActions                           = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_androidPermissionAction -Property @{
                            permission = "android.permission.READ_SMS"
                            action = "prompt"
                        } -ClientOnly)
                    )
                    appSupportsOemConfig                        = $False
                    connectedAppsEnabled                        = $False
                    packageId                                   = "app:org.mozilla.firefox"
                    payloadJson                                 = ""
                    profileApplicability                        = "androidDeviceOwner"
                    Ensure                                      = 'Absent'
                    Credential                                  = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceAppManagementMobileAppConfiguration -MockWith {
                    return @{
                        DisplayName          = 'Test Android Managed Store App Configuration Policy'
                        Description          = 'Test Android Managed Store App Configuration Policy Description'
                        Id                   = 'e30954ac-a65e-4dcb-ab79-91d45f3c52b4'
                        AdditionalProperties             = @{
                            permissionActions = @(
                               @{
                                    permission      = "android.permission.READ_SMS"
                                    action          = "prompt"

                                }
                            )
                            appSupportsOemConfig      = $False
                            connectedAppsEnabled      = $False
                            packageId                 = "app:org.mozilla.firefox"
                            payloadJson               = ""
                            profileApplicability      = "androidDeviceOwner"
                            '@odata.type'             = '#microsoft.graph.androidManagedStoreAppConfiguration'
                        }
                    }
                }
            }

            It 'Should return Present from the Get method' {
                    (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the Android Managed Store App Configuration Policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgBetaDeviceAppManagementMobileAppConfiguration -Exactly 1
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
                        DisplayName                   = 'Test Android Managed Store App Configuration Policy'
                        Description                   = 'Test Android Managed Store App Configuration Policy Description'
                        Id                            = 'e30954ac-a65e-4dcb-ab79-91d45f3c52b4'
                        targetedMobileApps            = "{FakeStringValue}"
                        AdditionalProperties          = @{
                            permissionActions = @(
                               @{
                                    permission        = "android.permission.READ_SMS"
                                    action            = "prompt"

                                }
                            )
                            appSupportsOemConfig      = $False
                            connectedAppsEnabled      = $False
                            packageId                 = "app:org.mozilla.firefox"
                            payloadJson               = ""
                            profileApplicability      = "androidDeviceOwner"
                            '@odata.type'             = '#microsoft.graph.androidManagedStoreAppConfiguration'
                        }
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