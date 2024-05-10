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
    -DscResource 'IntuneWindowsAutopilotDeploymentProfileAzureADJoined' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString 'f@kepassword1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgBetaDeviceManagementWindowsAutopilotDeploymentProfile -MockWith {
            }

            Mock -CommandName New-MgBetaDeviceManagementWindowsAutopilotDeploymentProfile -MockWith {
            }

            Mock -CommandName Remove-MgBetaDeviceManagementWindowsAutopilotDeploymentProfile -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Get-MgBetaDeviceManagementWindowsAutopilotDeploymentProfileAssignment -MockWith {
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
        Context -Name 'The IntuneWindowsAutopilotDeploymentProfileAzureADJoined should exist but it DOES NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    Description                    = 'FakeStringValue'
                    DeviceNameTemplate             = 'FakeStringValue'
                    DeviceType                     = 'windowsPc'
                    DisplayName                    = 'FakeStringValue'
                    EnableWhiteGlove               = $True
                    EnrollmentStatusScreenSettings = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsEnrollmentStatusScreenSettings1 -Property @{
                            HideInstallationProgress                         = $True
                            BlockDeviceSetupRetryByUser                      = $True
                            AllowLogCollectionOnInstallFailure               = $True
                            AllowDeviceUseBeforeProfileAndAppInstallComplete = $True
                            InstallProgressTimeoutInMinutes                  = 25
                            CustomErrorMessage                               = 'FakeStringValue'
                            AllowDeviceUseOnInstallFailure                   = $True
                        } -ClientOnly)
                    ExtractHardwareHash            = $True
                    Id                             = 'FakeStringValue'
                    Language                       = 'FakeStringValue'
                    ManagementServiceAppId         = 'FakeStringValue'
                    OutOfBoxExperienceSettings     = (New-CimInstance -ClassName MSFT_MicrosoftGraphoutOfBoxExperienceSettings1 -Property @{
                            HideEULA                  = $True
                            HideEscapeLink            = $True
                            HidePrivacySettings       = $True
                            DeviceUsageType           = 'singleUser'
                            SkipKeyboardSelectionPage = $True
                            UserType                  = 'administrator'
                        } -ClientOnly)
                    Ensure                         = 'Present'
                    Credential                     = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementWindowsAutopilotDeploymentProfile -MockWith {
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
                Should -Invoke -CommandName New-MgBetaDeviceManagementWindowsAutopilotDeploymentProfile -Exactly 1
            }
        }

        Context -Name 'The IntuneWindowsAutopilotDeploymentProfileAzureADJoined exists but it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    Description                    = 'FakeStringValue'
                    DeviceNameTemplate             = 'FakeStringValue'
                    DeviceType                     = 'windowsPc'
                    DisplayName                    = 'FakeStringValue'
                    EnableWhiteGlove               = $True
                    EnrollmentStatusScreenSettings = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsEnrollmentStatusScreenSettings1 -Property @{
                            HideInstallationProgress                         = $True
                            BlockDeviceSetupRetryByUser                      = $True
                            AllowLogCollectionOnInstallFailure               = $True
                            AllowDeviceUseBeforeProfileAndAppInstallComplete = $True
                            InstallProgressTimeoutInMinutes                  = 25
                            CustomErrorMessage                               = 'FakeStringValue'
                            AllowDeviceUseOnInstallFailure                   = $True
                        } -ClientOnly)
                    ExtractHardwareHash            = $True
                    Id                             = 'FakeStringValue'
                    Language                       = 'FakeStringValue'
                    ManagementServiceAppId         = 'FakeStringValue'
                    OutOfBoxExperienceSettings     = (New-CimInstance -ClassName MSFT_MicrosoftGraphoutOfBoxExperienceSettings1 -Property @{
                            HideEULA                  = $True
                            HideEscapeLink            = $True
                            HidePrivacySettings       = $True
                            DeviceUsageType           = 'singleUser'
                            SkipKeyboardSelectionPage = $True
                            UserType                  = 'administrator'
                        } -ClientOnly)
                    Ensure                         = 'Absent'
                    Credential                     = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementWindowsAutopilotDeploymentProfile -MockWith {
                    return @{
                        AdditionalProperties           = @{
                            '@odata.type' = '#microsoft.graph.azureADWindowsAutopilotDeploymentProfile'
                        }
                        Description                    = 'FakeStringValue'
                        DeviceNameTemplate             = 'FakeStringValue'
                        DeviceType                     = 'windowsPc'
                        DisplayName                    = 'FakeStringValue'
                        EnableWhiteGlove               = $True
                        EnrollmentStatusScreenSettings = @{
                            HideInstallationProgress                         = $True
                            BlockDeviceSetupRetryByUser                      = $True
                            AllowLogCollectionOnInstallFailure               = $True
                            AllowDeviceUseBeforeProfileAndAppInstallComplete = $True
                            InstallProgressTimeoutInMinutes                  = 25
                            CustomErrorMessage                               = 'FakeStringValue'
                            AllowDeviceUseOnInstallFailure                   = $True
                        }
                        ExtractHardwareHash            = $True
                        Id                             = 'FakeStringValue'
                        Language                       = 'FakeStringValue'
                        ManagementServiceAppId         = 'FakeStringValue'
                        OutOfBoxExperienceSettings     = @{
                            HideEULA                  = $True
                            HideEscapeLink            = $True
                            HidePrivacySettings       = $True
                            DeviceUsageType           = 'singleUser'
                            SkipKeyboardSelectionPage = $True
                            UserType                  = 'administrator'
                        }

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
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementWindowsAutopilotDeploymentProfile -Exactly 1
            }
        }
        Context -Name 'The IntuneWindowsAutopilotDeploymentProfileAzureADJoined Exists and Values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    Description                    = 'FakeStringValue'
                    DeviceNameTemplate             = 'FakeStringValue'
                    DeviceType                     = 'windowsPc'
                    DisplayName                    = 'FakeStringValue'
                    EnableWhiteGlove               = $True
                    EnrollmentStatusScreenSettings = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsEnrollmentStatusScreenSettings1 -Property @{
                            HideInstallationProgress                         = $True
                            BlockDeviceSetupRetryByUser                      = $True
                            AllowLogCollectionOnInstallFailure               = $True
                            AllowDeviceUseBeforeProfileAndAppInstallComplete = $True
                            InstallProgressTimeoutInMinutes                  = 25
                            CustomErrorMessage                               = 'FakeStringValue'
                            AllowDeviceUseOnInstallFailure                   = $True
                        } -ClientOnly)
                    ExtractHardwareHash            = $True
                    Id                             = 'FakeStringValue'
                    Language                       = 'FakeStringValue'
                    ManagementServiceAppId         = 'FakeStringValue'
                    OutOfBoxExperienceSettings     = (New-CimInstance -ClassName MSFT_MicrosoftGraphoutOfBoxExperienceSettings1 -Property @{
                            HideEULA                  = $True
                            HideEscapeLink            = $True
                            HidePrivacySettings       = $True
                            DeviceUsageType           = 'singleUser'
                            SkipKeyboardSelectionPage = $True
                            UserType                  = 'administrator'
                        } -ClientOnly)
                    Ensure                         = 'Present'
                    Credential                     = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementWindowsAutopilotDeploymentProfile -MockWith {
                    return @{
                        AdditionalProperties           = @{
                            '@odata.type' = '#microsoft.graph.azureADWindowsAutopilotDeploymentProfile'
                        }
                        Description                    = 'FakeStringValue'
                        DeviceNameTemplate             = 'FakeStringValue'
                        DeviceType                     = 'windowsPc'
                        DisplayName                    = 'FakeStringValue'
                        EnableWhiteGlove               = $True
                        EnrollmentStatusScreenSettings = @{
                            HideInstallationProgress                         = $True
                            BlockDeviceSetupRetryByUser                      = $True
                            AllowLogCollectionOnInstallFailure               = $True
                            AllowDeviceUseBeforeProfileAndAppInstallComplete = $True
                            InstallProgressTimeoutInMinutes                  = 25
                            CustomErrorMessage                               = 'FakeStringValue'
                            AllowDeviceUseOnInstallFailure                   = $True
                        }
                        ExtractHardwareHash            = $True
                        Id                             = 'FakeStringValue'
                        Language                       = 'FakeStringValue'
                        ManagementServiceAppId         = 'FakeStringValue'
                        OutOfBoxExperienceSettings     = @{
                            HideEULA                  = $True
                            HideEscapeLink            = $True
                            HidePrivacySettings       = $True
                            DeviceUsageType           = 'singleUser'
                            SkipKeyboardSelectionPage = $True
                            UserType                  = 'administrator'
                        }

                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'The IntuneWindowsAutopilotDeploymentProfileAzureADJoined exists and values are NOT in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    Description                    = 'FakeStringValue'
                    DeviceNameTemplate             = 'FakeStringValue'
                    DeviceType                     = 'windowsPc'
                    DisplayName                    = 'FakeStringValue'
                    EnableWhiteGlove               = $True
                    EnrollmentStatusScreenSettings = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsEnrollmentStatusScreenSettings1 -Property @{
                            HideInstallationProgress                         = $True
                            BlockDeviceSetupRetryByUser                      = $True
                            AllowLogCollectionOnInstallFailure               = $True
                            AllowDeviceUseBeforeProfileAndAppInstallComplete = $True
                            InstallProgressTimeoutInMinutes                  = 25
                            CustomErrorMessage                               = 'FakeStringValue'
                            AllowDeviceUseOnInstallFailure                   = $True
                        } -ClientOnly)
                    ExtractHardwareHash            = $True
                    Id                             = 'FakeStringValue'
                    Language                       = 'FakeStringValue'
                    ManagementServiceAppId         = 'FakeStringValue'
                    OutOfBoxExperienceSettings     = (New-CimInstance -ClassName MSFT_MicrosoftGraphoutOfBoxExperienceSettings1 -Property @{
                            HideEULA                  = $True
                            HideEscapeLink            = $True
                            HidePrivacySettings       = $True
                            DeviceUsageType           = 'singleUser'
                            SkipKeyboardSelectionPage = $True
                            UserType                  = 'administrator'
                        } -ClientOnly)
                    Ensure                         = 'Present'
                    Credential                     = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementWindowsAutopilotDeploymentProfile -MockWith {
                    return @{
                        Description                    = 'FakeStringValue'
                        DeviceNameTemplate             = 'FakeStringValue'
                        DeviceType                     = 'windowsPc'
                        DisplayName                    = 'FakeStringValue'
                        EnrollmentStatusScreenSettings = @{
                            InstallProgressTimeoutInMinutes = 7
                            CustomErrorMessage              = 'FakeStringValue'
                        }
                        Id                             = 'FakeStringValue'
                        Language                       = 'FakeStringValue'
                        ManagementServiceAppId         = 'FakeStringValue'
                        OutOfBoxExperienceSettings     = @{
                            DeviceUsageType = 'singleUser'
                            UserType        = 'administrator'
                        }
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
                Should -Invoke -CommandName Update-MgBetaDeviceManagementWindowsAutopilotDeploymentProfile -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementWindowsAutopilotDeploymentProfile -MockWith {
                    return @{
                        AdditionalProperties           = @{
                            '@odata.type' = '#microsoft.graph.azureADWindowsAutopilotDeploymentProfile'
                        }
                        Description                    = 'FakeStringValue'
                        DeviceNameTemplate             = 'FakeStringValue'
                        DeviceType                     = 'windowsPc'
                        DisplayName                    = 'FakeStringValue'
                        EnableWhiteGlove               = $True
                        EnrollmentStatusScreenSettings = @{
                            HideInstallationProgress                         = $True
                            BlockDeviceSetupRetryByUser                      = $True
                            AllowLogCollectionOnInstallFailure               = $True
                            AllowDeviceUseBeforeProfileAndAppInstallComplete = $True
                            InstallProgressTimeoutInMinutes                  = 25
                            CustomErrorMessage                               = 'FakeStringValue'
                            AllowDeviceUseOnInstallFailure                   = $True
                        }
                        ExtractHardwareHash            = $True
                        Id                             = 'FakeStringValue'
                        Language                       = 'FakeStringValue'
                        ManagementServiceAppId         = 'FakeStringValue'
                        OutOfBoxExperienceSettings     = @{
                            HideEULA                  = $True
                            HideEscapeLink            = $True
                            HidePrivacySettings       = $True
                            DeviceUsageType           = 'singleUser'
                            SkipKeyboardSelectionPage = $True
                            UserType                  = 'administrator'
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
