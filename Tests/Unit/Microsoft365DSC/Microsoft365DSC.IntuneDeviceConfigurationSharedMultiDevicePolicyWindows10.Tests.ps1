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
    -DscResource "IntuneDeviceConfigurationSharedMultiDevicePolicyWindows10" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Update-MgBetaDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName New-MgBetaDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName Remove-MgBetaDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }
            Mock -CommandName Update-DeviceConfigurationPolicyAssignment -MockWith {
            }
            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false

            Mock -CommandName Get-MgBetaDeviceManagementDeviceConfigurationAssignment -MockWith {
            }

        }
        # Test contexts
        Context -Name "The IntuneDeviceConfigurationSharedMultiDevicePolicyWindows10 should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    accountManagerPolicy = (New-CimInstance -ClassName MSFT_MicrosoftGraphsharedPCAccountManagerPolicy -Property @{
                        inactiveThresholdDays = 25
                        cacheAccountsAboveDiskFreePercentage = 25
                        accountDeletionPolicy = "immediate"
                        removeAccountsBelowDiskFreePercentage = 25
                    } -ClientOnly)
                    allowedAccounts = "notConfigured"
                    allowLocalStorage = $True
                    description = "FakeStringValue"
                    disableAccountManager = $True
                    disableEduPolicies = $True
                    disablePowerPolicies = $True
                    disableSignInOnResume = $True
                    displayName = "FakeStringValue"
                    enabled = $True
                    fastFirstSignIn = "notConfigured"
                    id = "FakeStringValue"
                    idleTimeBeforeSleepInSeconds = 25
                    kioskAppDisplayName = "FakeStringValue"
                    kioskAppUserModelId = "FakeStringValue"
                    localStorage = "notConfigured"
                    maintenanceStartTime = "00:00:00"
                    setAccountManager = "notConfigured"
                    setEduPolicies = "notConfigured"
                    setPowerPolicies = "notConfigured"
                    signInOnResume = "notConfigured"
                    Ensure = "Present"
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
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
                Should -Invoke -CommandName New-MgBetaDeviceManagementDeviceConfiguration -Exactly 1
            }
        }

        Context -Name "The IntuneDeviceConfigurationSharedMultiDevicePolicyWindows10 exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    accountManagerPolicy = (New-CimInstance -ClassName MSFT_MicrosoftGraphsharedPCAccountManagerPolicy -Property @{
                        inactiveThresholdDays = 25
                        cacheAccountsAboveDiskFreePercentage = 25
                        accountDeletionPolicy = "immediate"
                        removeAccountsBelowDiskFreePercentage = 25
                    } -ClientOnly)
                    allowedAccounts = "notConfigured"
                    allowLocalStorage = $True
                    description = "FakeStringValue"
                    disableAccountManager = $True
                    disableEduPolicies = $True
                    disablePowerPolicies = $True
                    disableSignInOnResume = $True
                    displayName = "FakeStringValue"
                    enabled = $True
                    fastFirstSignIn = "notConfigured"
                    id = "FakeStringValue"
                    idleTimeBeforeSleepInSeconds = 25
                    kioskAppDisplayName = "FakeStringValue"
                    kioskAppUserModelId = "FakeStringValue"
                    localStorage = "notConfigured"
                    maintenanceStartTime = "00:00:00"
                    setAccountManager = "notConfigured"
                    setEduPolicies = "notConfigured"
                    setPowerPolicies = "notConfigured"
                    signInOnResume = "notConfigured"
                    Ensure = 'Absent'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            kioskAppDisplayName = "FakeStringValue"
                            fastFirstSignIn = "notConfigured"
                            disableEduPolicies = $True
                            disableAccountManager = $True
                            accountManagerPolicy = @{
                                inactiveThresholdDays = 25
                                cacheAccountsAboveDiskFreePercentage = 25
                                accountDeletionPolicy = "immediate"
                                removeAccountsBelowDiskFreePercentage = 25
                            }
                            signInOnResume = "notConfigured"
                            setAccountManager = "notConfigured"
                            disableSignInOnResume = $True
                            localStorage = "notConfigured"
                            setEduPolicies = "notConfigured"
                            maintenanceStartTime = "00:00:00"
                            allowedAccounts = "notConfigured"
                            setPowerPolicies = "notConfigured"
                            '@odata.type' = "#microsoft.graph.sharedPCConfiguration"
                            allowLocalStorage = $True
                            kioskAppUserModelId = "FakeStringValue"
                            idleTimeBeforeSleepInSeconds = 25
                            disablePowerPolicies = $True
                            enabled = $True
                        }
                        description = "FakeStringValue"
                        displayName = "FakeStringValue"
                        id = "FakeStringValue"

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
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementDeviceConfiguration -Exactly 1
            }
        }
        Context -Name "The IntuneDeviceConfigurationSharedMultiDevicePolicyWindows10 Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    accountManagerPolicy = (New-CimInstance -ClassName MSFT_MicrosoftGraphsharedPCAccountManagerPolicy -Property @{
                        inactiveThresholdDays = 25
                        cacheAccountsAboveDiskFreePercentage = 25
                        accountDeletionPolicy = "immediate"
                        removeAccountsBelowDiskFreePercentage = 25
                    } -ClientOnly)
                    allowedAccounts = "notConfigured"
                    allowLocalStorage = $True
                    description = "FakeStringValue"
                    disableAccountManager = $True
                    disableEduPolicies = $True
                    disablePowerPolicies = $True
                    disableSignInOnResume = $True
                    displayName = "FakeStringValue"
                    enabled = $True
                    fastFirstSignIn = "notConfigured"
                    id = "FakeStringValue"
                    idleTimeBeforeSleepInSeconds = 25
                    kioskAppDisplayName = "FakeStringValue"
                    kioskAppUserModelId = "FakeStringValue"
                    localStorage = "notConfigured"
                    maintenanceStartTime = "00:00:00"
                    setAccountManager = "notConfigured"
                    setEduPolicies = "notConfigured"
                    setPowerPolicies = "notConfigured"
                    signInOnResume = "notConfigured"
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            kioskAppDisplayName = "FakeStringValue"
                            fastFirstSignIn = "notConfigured"
                            disableEduPolicies = $True
                            disableAccountManager = $True
                            accountManagerPolicy = @{
                                inactiveThresholdDays = 25
                                cacheAccountsAboveDiskFreePercentage = 25
                                accountDeletionPolicy = "immediate"
                                removeAccountsBelowDiskFreePercentage = 25
                            }
                            signInOnResume = "notConfigured"
                            setAccountManager = "notConfigured"
                            disableSignInOnResume = $True
                            localStorage = "notConfigured"
                            setEduPolicies = "notConfigured"
                            maintenanceStartTime = "00:00:00"
                            allowedAccounts = "notConfigured"
                            setPowerPolicies = "notConfigured"
                            '@odata.type' = "#microsoft.graph.sharedPCConfiguration"
                            allowLocalStorage = $True
                            kioskAppUserModelId = "FakeStringValue"
                            idleTimeBeforeSleepInSeconds = 25
                            disablePowerPolicies = $True
                            enabled = $True
                        }
                        description = "FakeStringValue"
                        displayName = "FakeStringValue"
                        id = "FakeStringValue"

                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The IntuneDeviceConfigurationSharedMultiDevicePolicyWindows10 exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    accountManagerPolicy = (New-CimInstance -ClassName MSFT_MicrosoftGraphsharedPCAccountManagerPolicy -Property @{
                        inactiveThresholdDays = 25
                        cacheAccountsAboveDiskFreePercentage = 25
                        accountDeletionPolicy = "immediate"
                        removeAccountsBelowDiskFreePercentage = 25
                    } -ClientOnly)
                    allowedAccounts = "notConfigured"
                    allowLocalStorage = $True
                    description = "FakeStringValue"
                    disableAccountManager = $True
                    disableEduPolicies = $True
                    disablePowerPolicies = $True
                    disableSignInOnResume = $True
                    displayName = "FakeStringValue"
                    enabled = $True
                    fastFirstSignIn = "notConfigured"
                    id = "FakeStringValue"
                    idleTimeBeforeSleepInSeconds = 25
                    kioskAppDisplayName = "FakeStringValue"
                    kioskAppUserModelId = "FakeStringValue"
                    localStorage = "notConfigured"
                    maintenanceStartTime = "00:00:00"
                    setAccountManager = "notConfigured"
                    setEduPolicies = "notConfigured"
                    setPowerPolicies = "notConfigured"
                    signInOnResume = "notConfigured"
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            maintenanceStartTime = "00:00:00"
                            idleTimeBeforeSleepInSeconds = 7
                            signInOnResume = "notConfigured"
                            '@odata.type' = "#microsoft.graph.sharedPCConfiguration"
                            setPowerPolicies = "notConfigured"
                            allowedAccounts = "notConfigured"
                            kioskAppUserModelId = "FakeStringValue"
                            setEduPolicies = "notConfigured"
                            accountManagerPolicy = @{
                                inactiveThresholdDays = 7
                                cacheAccountsAboveDiskFreePercentage = 7
                                accountDeletionPolicy = "immediate"
                                removeAccountsBelowDiskFreePercentage = 7
                            }
                            kioskAppDisplayName = "FakeStringValue"
                            fastFirstSignIn = "notConfigured"
                            localStorage = "notConfigured"
                            setAccountManager = "notConfigured"
                        }
                        description = "FakeStringValue"
                        displayName = "FakeStringValue"
                        id = "FakeStringValue"
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
                Should -Invoke -CommandName Update-MgBetaDeviceManagementDeviceConfiguration -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            kioskAppDisplayName = "FakeStringValue"
                            fastFirstSignIn = "notConfigured"
                            disableEduPolicies = $True
                            disableAccountManager = $True
                            accountManagerPolicy = @{
                                inactiveThresholdDays = 25
                                cacheAccountsAboveDiskFreePercentage = 25
                                accountDeletionPolicy = "immediate"
                                removeAccountsBelowDiskFreePercentage = 25
                            }
                            signInOnResume = "notConfigured"
                            setAccountManager = "notConfigured"
                            disableSignInOnResume = $True
                            localStorage = "notConfigured"
                            setEduPolicies = "notConfigured"
                            maintenanceStartTime = "00:00:00"
                            allowedAccounts = "notConfigured"
                            setPowerPolicies = "notConfigured"
                            '@odata.type' = "#microsoft.graph.sharedPCConfiguration"
                            allowLocalStorage = $True
                            kioskAppUserModelId = "FakeStringValue"
                            idleTimeBeforeSleepInSeconds = 25
                            disablePowerPolicies = $True
                            enabled = $True
                        }
                        description = "FakeStringValue"
                        displayName = "FakeStringValue"
                        id = "FakeStringValue"

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
