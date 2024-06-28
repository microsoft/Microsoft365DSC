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
    -DscResource "IntuneDeviceRemediation" -GenericStubModule $GenericStubPath
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

            Mock -CommandName Update-MgBetaDeviceManagementDeviceHealthScript -MockWith {
            }

            Mock -CommandName New-MgBetaDeviceManagementDeviceHealthScript -MockWith {
            }

            Mock -CommandName Remove-MgBetaDeviceManagementDeviceHealthScript -MockWith {
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

            Mock -CommandName Get-MgBetaDeviceManagementDeviceHealthScriptAssignment -MockWith {
                return @(
                    @{
                        Id = "FakeStringValue"
                        RunRemediationScript = $False
                        RunSchedule = @{
                            Interval = 1
                            AdditionalProperties = @{
                                '@odata.type' = "#microsoft.graph.deviceHealthScriptRunOnceSchedule"
                                useUtc = $false
                                time = "01:00:00.0000000"
                                date = "2024-01-01"
                            }
                        }
                        Target = @{
                            AdditionalProperties = @{
                                '@odata.type' = "#microsoft.graph.groupAssignmentTarget"
                                groupId = "FakeStringValue"
                            }
                            "DeviceAndAppManagementAssignmentFilterId" = "FakeStringValue"
                            "DeviceAndAppManagementAssignmentFilterType" = "none"
                        }
                        DeviceHealthScriptId = "FakeStringValue"
                        RoleScopeTagIds = @("FakeStringValue")
                        Ensure = "Present"
                    }
                )
            }
        }
        # Test contexts
        Context -Name "The IntuneDeviceRemediation should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_IntuneDeviceRemediationPolicyAssignments -Property @{
                            RunSchedule = New-CimInstance -ClassName MSFT_IntuneDeviceRemediationRunSchedule -Property @{
                                Date = '2024-01-01'
                                Time = '01:00:00'
                                Interval = 1
                                DataType = '#microsoft.graph.deviceHealthScriptRunOnceSchedule'
                                UseUtc = $False
                            } -ClientOnly
                            RunRemediationScript = $False
                            Assignment = New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                                deviceAndAppManagementAssignmentFilterId = 'FakeStringValue'
                                deviceAndAppManagementAssignmentFilterType = 'none'
                                dataType = '#microsoft.graph.groupAssignmentTarget'
                                groupId = 'FakeStringValue'
                            } -ClientOnly
                        } -ClientOnly)
                    )
                    Description = "FakeStringValue"
                    DetectionScriptContent = "VGVzdA==" # "Test"
                    DetectionScriptParameters = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceHealthScriptParameter -Property @{
                            DefaultValue = $True
                            IsRequired = $True
                            Description = "FakeStringValue"
                            Name = "FakeStringValue"
                            odataType = "#microsoft.graph.deviceHealthScriptBooleanParameter"
                            ApplyDefaultValueWhenNotAssigned = $True
                        } -ClientOnly)
                    )
                    DeviceHealthScriptType = "deviceHealthScript"
                    DisplayName = "FakeStringValue"
                    EnforceSignatureCheck = $True
                    Id = "FakeStringValue"
                    Publisher = "FakeStringValue"
                    RemediationScriptContent = "VGVzdA==" # "Test"
                    RemediationScriptParameters = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceHealthScriptParameter -Property @{
                            DefaultValue = $True
                            IsRequired = $True
                            Description = "FakeStringValue"
                            Name = "FakeStringValue"
                            odataType = "#microsoft.graph.deviceHealthScriptBooleanParameter"
                            ApplyDefaultValueWhenNotAssigned = $True
                        } -ClientOnly)
                    )
                    RoleScopeTagIds = @("FakeStringValue")
                    RunAs32Bit = $True
                    RunAsAccount = "system"
                    Ensure = "Present"
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceHealthScript -MockWith {
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
                Should -Invoke -CommandName New-MgBetaDeviceManagementDeviceHealthScript -Exactly 1
            }
        }

        Context -Name "The IntuneDeviceRemediation exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_IntuneDeviceRemediationPolicyAssignments -Property @{
                            RunSchedule = New-CimInstance -ClassName MSFT_IntuneDeviceRemediationRunSchedule -Property @{
                                Date = '2024-01-01'
                                Time = '01:00:00'
                                Interval = 1
                                DataType = '#microsoft.graph.deviceHealthScriptRunOnceSchedule'
                                UseUtc = $False
                            } -ClientOnly
                            RunRemediationScript = $False
                            Assignment = New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                                deviceAndAppManagementAssignmentFilterId = 'FakeStringValue'
                                deviceAndAppManagementAssignmentFilterType = 'none'
                                dataType = '#microsoft.graph.groupAssignmentTarget'
                                groupId = 'FakeStringValue'
                            } -ClientOnly
                        } -ClientOnly)
                    )
                    Description = "FakeStringValue"
                    DetectionScriptContent = "VGVzdA==" # "Test"
                    DetectionScriptParameters = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceHealthScriptParameter -Property @{
                            DefaultValue = $True
                            IsRequired = $True
                            Description = "FakeStringValue"
                            Name = "FakeStringValue"
                            odataType = "#microsoft.graph.deviceHealthScriptBooleanParameter"
                            ApplyDefaultValueWhenNotAssigned = $True
                        } -ClientOnly)
                    )
                    DeviceHealthScriptType = "deviceHealthScript"
                    DisplayName = "FakeStringValue"
                    EnforceSignatureCheck = $True
                    Id = "FakeStringValue"
                    Publisher = "FakeStringValue"
                    RemediationScriptContent = "VGVzdA==" # "Test"
                    RemediationScriptParameters = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceHealthScriptParameter -Property @{
                            DefaultValue = $True
                            IsRequired = $True
                            Description = "FakeStringValue"
                            Name = "FakeStringValue"
                            odataType = "#microsoft.graph.deviceHealthScriptBooleanParameter"
                            ApplyDefaultValueWhenNotAssigned = $True
                        } -ClientOnly)
                    )
                    RoleScopeTagIds = @("FakeStringValue")
                    RunAs32Bit = $True
                    RunAsAccount = "system"
                    Ensure = 'Absent'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceHealthScript -MockWith {
                    return @{
                        Assignments = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_IntuneDeviceRemediationPolicyAssignments -Property @{
                                RunSchedule = New-CimInstance -ClassName MSFT_IntuneDeviceRemediationRunSchedule -Property @{
                                    Date = '2024-01-01'
                                    Time = '01:00:00'
                                    Interval = 1
                                    DataType = '#microsoft.graph.deviceHealthScriptRunOnceSchedule'
                                    UseUtc = $False
                                } -ClientOnly
                                RunRemediationScript = $False
                                Assignment = New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                                    deviceAndAppManagementAssignmentFilterId = 'FakeStringValue'
                                    deviceAndAppManagementAssignmentFilterType = 'none'
                                    dataType = '#microsoft.graph.groupAssignmentTarget'
                                    groupId = 'FakeStringValue'
                                } -ClientOnly
                            } -ClientOnly)
                        )
                        Description = "FakeStringValue"
                        DetectionScriptContent = [byte[]] @(84, 101, 115, 116)
                        DetectionScriptParameters = @(
                            @{
                                '@odata.type' = "#microsoft.graph.deviceHealthScriptBooleanParameter"
                                DefaultValue = $True
                                IsRequired = $True
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                ApplyDefaultValueWhenNotAssigned = $True
                            }
                        )
                        DeviceHealthScriptType = "deviceHealthScript"
                        DisplayName = "FakeStringValue"
                        EnforceSignatureCheck = $True
                        Id = "FakeStringValue"
                        IsGlobalScript = $False
                        Publisher = "FakeStringValue"
                        RemediationScriptContent = [byte[]] @(84, 101, 115, 116)
                        RemediationScriptParameters = @(
                            @{
                                '@odata.type' = "#microsoft.graph.deviceHealthScriptBooleanParameter"
                                DefaultValue = $True
                                IsRequired = $True
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                ApplyDefaultValueWhenNotAssigned = $True
                            }
                        )
                        RoleScopeTagIds = @("FakeStringValue")
                        RunAs32Bit = $True
                        RunAsAccount = "system"
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
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementDeviceHealthScript -Exactly 1
            }
        }
        Context -Name "The IntuneDeviceRemediation Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_IntuneDeviceRemediationPolicyAssignments -Property @{
                            RunSchedule = New-CimInstance -ClassName MSFT_IntuneDeviceRemediationRunSchedule -Property @{
                                Date = '2024-01-01'
                                Time = '01:00:00'
                                Interval = 1
                                DataType = '#microsoft.graph.deviceHealthScriptRunOnceSchedule'
                                UseUtc = $False
                            } -ClientOnly
                            RunRemediationScript = $False
                            Assignment = New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                                deviceAndAppManagementAssignmentFilterId = 'FakeStringValue'
                                deviceAndAppManagementAssignmentFilterType = 'none'
                                dataType = '#microsoft.graph.groupAssignmentTarget'
                                groupId = 'FakeStringValue'
                            } -ClientOnly
                        } -ClientOnly)
                    )
                    Description = "FakeStringValue"
                    DetectionScriptContent = "VGVzdA==" # "Test"
                    DetectionScriptParameters = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceHealthScriptParameter -Property @{
                            DefaultValue = $True
                            IsRequired = $True
                            Description = "FakeStringValue"
                            Name = "FakeStringValue"
                            odataType = "#microsoft.graph.deviceHealthScriptBooleanParameter"
                            ApplyDefaultValueWhenNotAssigned = $True
                        } -ClientOnly)
                    )
                    DeviceHealthScriptType = "deviceHealthScript"
                    DisplayName = "FakeStringValue"
                    EnforceSignatureCheck = $True
                    Id = "FakeStringValue"
                    Publisher = "FakeStringValue"
                    RemediationScriptContent = "VGVzdA==" # "Test"
                    RemediationScriptParameters = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceHealthScriptParameter -Property @{
                            DefaultValue = $True
                            IsRequired = $True
                            Description = "FakeStringValue"
                            Name = "FakeStringValue"
                            odataType = "#microsoft.graph.deviceHealthScriptBooleanParameter"
                            ApplyDefaultValueWhenNotAssigned = $True
                        } -ClientOnly)
                    )
                    RoleScopeTagIds = @("FakeStringValue")
                    RunAs32Bit = $True
                    RunAsAccount = "system"
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceHealthScript -MockWith {
                    return @{
                        Description = "FakeStringValue"
                        DetectionScriptContent = [byte[]] @(84, 101, 115, 116)
                        DetectionScriptParameters = @(
                            @{
                                '@odata.type' = "#microsoft.graph.deviceHealthScriptBooleanParameter"
                                DefaultValue = $True
                                IsRequired = $True
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                ApplyDefaultValueWhenNotAssigned = $True
                            }
                        )
                        DeviceHealthScriptType = "deviceHealthScript"
                        DisplayName = "FakeStringValue"
                        EnforceSignatureCheck = $True
                        Id = "FakeStringValue"
                        IsGlobalScript = $False
                        Publisher = "FakeStringValue"
                        RemediationScriptContent = [byte[]] @(84, 101, 115, 116)
                        RemediationScriptParameters = @(
                            @{
                                '@odata.type' = "#microsoft.graph.deviceHealthScriptBooleanParameter"
                                DefaultValue = $True
                                IsRequired = $True
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                ApplyDefaultValueWhenNotAssigned = $True
                            }
                        )
                        RoleScopeTagIds = @("FakeStringValue")
                        RunAs32Bit = $True
                        RunAsAccount = "system"
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The IntuneDeviceRemediation exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_IntuneDeviceRemediationPolicyAssignments -Property @{
                            RunSchedule = New-CimInstance -ClassName MSFT_IntuneDeviceRemediationRunSchedule -Property @{
                                Date = '2024-01-01'
                                Time = '01:00:00'
                                Interval = 1
                                DataType = '#microsoft.graph.deviceHealthScriptRunOnceSchedule'
                                UseUtc = $False
                            } -ClientOnly
                            RunRemediationScript = $False
                            Assignment = New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                                deviceAndAppManagementAssignmentFilterId = 'FakeStringValue'
                                deviceAndAppManagementAssignmentFilterType = 'none'
                                dataType = '#microsoft.graph.groupAssignmentTarget'
                                groupId = 'FakeStringValue'
                            } -ClientOnly
                        } -ClientOnly)
                    )
                    Description = "FakeStringValue"
                    DetectionScriptContent = "VGVzdA==" # "Test"
                    DetectionScriptParameters = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceHealthScriptParameter -Property @{
                            DefaultValue = $True
                            IsRequired = $True
                            Description = "FakeStringValue"
                            Name = "FakeStringValue"
                            odataType = "#microsoft.graph.deviceHealthScriptBooleanParameter"
                            ApplyDefaultValueWhenNotAssigned = $True
                        } -ClientOnly)
                    )
                    DeviceHealthScriptType = "deviceHealthScript"
                    DisplayName = "FakeStringValue"
                    EnforceSignatureCheck = $True
                    Id = "FakeStringValue"
                    Publisher = "FakeStringValue"
                    RemediationScriptContent = "VGVzdA==" # "Test"
                    RemediationScriptParameters = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceHealthScriptParameter -Property @{
                            DefaultValue = $True
                            IsRequired = $True
                            Description = "FakeStringValue"
                            Name = "FakeStringValue"
                            odataType = "#microsoft.graph.deviceHealthScriptBooleanParameter"
                            ApplyDefaultValueWhenNotAssigned = $True
                        } -ClientOnly)
                    )
                    RoleScopeTagIds = @("FakeStringValue")
                    RunAs32Bit = $True
                    RunAsAccount = "system"
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceHealthScript -MockWith {
                    return @{
                        Description = "FakeStringValue"
                        DetectionScriptContent = [byte[]] @(84, 101, 115, 116)
                        DetectionScriptParameters = @(
                            @{
                                Name = "FakeStringValue"
                                '@odata.type' = "#microsoft.graph.deviceHealthScriptBooleanParameter"
                                Description = "FakeStringValue"
                            }
                        )
                        DeviceHealthScriptType = "deviceHealthScript"
                        DisplayName = "FakeStringValue"
                        Id = "FakeStringValue"
                        IsGlobalScript = $False
                        Publisher = "FakeStringValue"
                        RemediationScriptContent = [byte[]] @(84, 101, 115, 116)
                        RemediationScriptParameters = @(
                            @{
                                Name = "FakeStringValue"
                                '@odata.type' = "#microsoft.graph.deviceHealthScriptBooleanParameter"
                                Description = "FakeStringValue"
                            }
                        )
                        RoleScopeTagIds = @("FakeStringValue")
                        RunAsAccount = "system"
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
                Should -Invoke -CommandName Update-MgBetaDeviceManagementDeviceHealthScript -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceHealthScript -MockWith {
                    return @{
                        Assignments = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_IntuneDeviceRemediationPolicyAssignments -Property @{
                                RunSchedule = New-CimInstance -ClassName MSFT_IntuneDeviceRemediationRunSchedule -Property @{
                                    Date = '2024-01-01'
                                    Time = '01:00:00'
                                    Interval = 1
                                    DataType = '#microsoft.graph.deviceHealthScriptRunOnceSchedule'
                                    UseUtc = $False
                                } -ClientOnly
                                RunRemediationScript = $False
                                Assignment = New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                                    deviceAndAppManagementAssignmentFilterId = 'FakeStringValue'
                                    deviceAndAppManagementAssignmentFilterType = 'none'
                                    dataType = '#microsoft.graph.groupAssignmentTarget'
                                    groupId = 'FakeStringValue'
                                } -ClientOnly
                            } -ClientOnly)
                        )
                        Description = "FakeStringValue"
                        DetectionScriptContent = [byte[]] @(84, 101, 115, 116)
                        DetectionScriptParameters = @(
                            @{
                                '@odata.type' = "#microsoft.graph.deviceHealthScriptBooleanParameter"
                                DefaultValue = $True
                                IsRequired = $True
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                ApplyDefaultValueWhenNotAssigned = $True
                            }
                        )
                        DeviceHealthScriptType = "deviceHealthScript"
                        DisplayName = "FakeStringValue"
                        EnforceSignatureCheck = $True
                        Id = "FakeStringValue"
                        IsGlobalScript = $False
                        Publisher = "FakeStringValue"
                        RemediationScriptContent = [byte[]] @(84, 101, 115, 116)
                        RemediationScriptParameters = @(
                            @{
                                '@odata.type' = "#microsoft.graph.deviceHealthScriptBooleanParameter"
                                DefaultValue = $True
                                IsRequired = $True
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                ApplyDefaultValueWhenNotAssigned = $True
                            }
                        )
                        RoleScopeTagIds = @("FakeStringValue")
                        RunAs32Bit = $True
                        RunAsAccount = "system"
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
