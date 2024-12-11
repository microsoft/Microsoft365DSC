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
    -DscResource "IntuneDeviceManagementComplianceManagementPartner" -GenericStubModule $GenericStubPath
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

            Mock -CommandName Update-MgBetaDeviceManagementComplianceManagementPartner -MockWith {
            }

            Mock -CommandName New-MgBetaDeviceManagementComplianceManagementPartner -MockWith {
            }

            Mock -CommandName Remove-MgBetaDeviceManagementComplianceManagementPartner -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }
        # Test contexts
        Context -Name "The IntuneDeviceManagementComplianceManagementPartner should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    AndroidEnrollmentAssignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_IntunedeviceAndAppManagementAssignmentTarget -Property @{
                            dataType = "#microsoft.graph.configurationManagerCollectionAssignmentTarget"
                            CollectionId = "FakeStringValue"
                        } -ClientOnly)
                    )
                    AndroidOnboarded = $True
                    DisplayName = "FakeStringValue"
                    Id = "FakeStringValue"
                    IosEnrollmentAssignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_IntunedeviceAndAppManagementAssignmentTarget -Property @{
                            dataType = "#microsoft.graph.allDevicesAssignmentTarget"
                            GroupDisplayName = "All devices"
                        } -ClientOnly)
                    )
                    IosOnboarded = $True
                    MacOsEnrollmentAssignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_IntunedeviceAndAppManagementAssignmentTarget -Property @{
                            dataType = "#microsoft.graph.allDevicesAssignmentTarget"
                            GroupDisplayName = "All devices"
                        } -ClientOnly)
                    )
                    MacOsOnboarded = $True
                    PartnerState = "unknown"
                    Ensure = "Present"
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementComplianceManagementPartner -MockWith {
                    return $null
                }

                Mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        DisplayName     = "FakeStringValue"
                        Id              = "FakeIdValue"
                        SecurityEnabled = $true
                    }
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should Create the Management Partner instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgBetaDeviceManagementComplianceManagementPartner -Exactly 1
            }
        }

        Context -Name "The IntuneDeviceManagementComplianceManagementPartner exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    AndroidEnrollmentAssignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_IntunedeviceAndAppManagementAssignmentTarget -Property @{
                            dataType = "#microsoft.graph.allDevicesAssignmentTarget"
                            GroupDisplayName = 'All devices'
                        } -ClientOnly)
                    )
                    AndroidOnboarded = $True
                    DisplayName = "FakeStringValue"
                    Id = "FakeStringValue"
                    IosEnrollmentAssignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_IntunedeviceAndAppManagementAssignmentTarget -Property @{
                            dataType = "#microsoft.graph.allDevicesAssignmentTarget"
                            GroupDisplayName = "All devices"
                        } -ClientOnly)
                    )
                    IosOnboarded = $True
                    MacOsEnrollmentAssignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_IntunedeviceAndAppManagementAssignmentTarget -Property @{
                            dataType = "#microsoft.graph.configurationManagerCollectionAssignmentTarget"
                            CollectionId = "FakeStringValue"
                            DeviceAndAppManagementAssignmentFilterId = "FakeStringValue"
                            DeviceAndAppManagementAssignmentFilterType = "none"
                        } -ClientOnly)
                    )
                    MacOsOnboarded = $True
                    PartnerState = "unknown"
                    Ensure = 'Absent'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementComplianceManagementPartner -MockWith {
                    return @{
                        AdditionalProperties = @{
                            '@odata.type' = "#microsoft.graph.ComplianceManagementPartner"
                        }
                        AndroidEnrollmentAssignments = @(
                            @{
                                Target = @{
                                    '@odata.type' = "#microsoft.graph.allDevicesAssignmentTarget"
                                }
                            }
                        )
                        AndroidOnboarded = $True
                        DisplayName = "FakeStringValue"
                        Id = "FakeStringValue"
                        IosEnrollmentAssignments = @(
                            @{
                                Target = @{
                                    '@odata.type' = "#microsoft.graph.allDevicesAssignmentTarget"
                                }
                            }
                        )
                        IosOnboarded = $True
                        LastHeartbeatDateTime = "2023-01-01T00:00:00.0000000+01:00"
                        MacOsEnrollmentAssignments = @(
                            @{
                                Target = @{
                                    '@odata.type' = "#microsoft.graph.configurationManagerCollectionAssignmentTarget"
                                    collectionId = "FakeStringValue"
                                }
                            }
                        )
                        MacOsOnboarded = $True
                        PartnerState = "unknown"

                    }
                }

                Mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        DisplayName     = "FakeStringValue"
                        Id              = "FakeIdValue"
                        SecurityEnabled = $true
                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the Management Partner instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementComplianceManagementPartner -Exactly 1
            }
        }

        Context -Name "The IntuneDeviceManagementComplianceManagementPartner Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AndroidEnrollmentAssignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_IntunedeviceAndAppManagementAssignmentTarget -Property @{
                            dataType = "#microsoft.graph.allDevicesAssignmentTarget"
                            GroupDisplayName = "All devices"
                        } -ClientOnly)
                    )
                    AndroidOnboarded = $True
                    DisplayName = "FakeStringValue"
                    Id = "FakeStringValue"
                    IosEnrollmentAssignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_IntunedeviceAndAppManagementAssignmentTarget -Property @{
                            GroupDisplayName = "All devices"
                            dataType = "#microsoft.graph.allDevicesAssignmentTarget"
                        } -ClientOnly)
                    )
                    IosOnboarded = $True
                    MacOsEnrollmentAssignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_IntunedeviceAndAppManagementAssignmentTarget -Property @{
                            dataType = "#microsoft.graph.configurationManagerCollectionAssignmentTarget"
                            CollectionId = "FakeStringValue"
                        } -ClientOnly)
                    )
                    MacOsOnboarded = $True
                    PartnerState = "unknown"
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementComplianceManagementPartner -MockWith {
                    return @{
                        AdditionalProperties = @{
                            '@odata.type' = "#microsoft.graph.ComplianceManagementPartner"
                        }
                        AndroidEnrollmentAssignments = @(
                            @{
                                Target = @{
                                    '@odata.type' = "#microsoft.graph.allDevicesAssignmentTarget"
                                }
                            }
                        )
                        AndroidOnboarded = $True
                        DisplayName = "FakeStringValue"
                        Id = "FakeStringValue"
                        IosEnrollmentAssignments = @(
                            @{
                                Target = @{
                                    '@odata.type' = "#microsoft.graph.allDevicesAssignmentTarget"
                                }
                            }
                        )
                        IosOnboarded = $True
                        LastHeartbeatDateTime = "2023-01-01T00:00:00.0000000+01:00"
                        MacOsEnrollmentAssignments = @(
                            @{
                                Target = @{
                                    '@odata.type' = "#microsoft.graph.configurationManagerCollectionAssignmentTarget"
                                    collectionId = "FakeStringValue"
                                }
                            }
                        )
                        MacOsOnboarded = $True
                        PartnerState = "unknown"

                    }
                }

                Mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        DisplayName     = "FakeStringValue"
                        Id              = "FakeIdValue"
                        SecurityEnabled = $true
                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The IntuneDeviceManagementComplianceManagementPartner exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AndroidEnrollmentAssignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_IntunedeviceAndAppManagementAssignmentTarget -Property @{
                            dataType = "#microsoft.graph.allDevicesAssignmentTarget"
                            GroupDisplayName = "All devices"
                        } -ClientOnly)
                    )
                    AndroidOnboarded = $True
                    DisplayName = "FakeStringValue"
                    Id = "FakeStringValue"
                    IosEnrollmentAssignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_IntunedeviceAndAppManagementAssignmentTarget -Property @{
                            dataType = "#microsoft.graph.allDevicesAssignmentTarget"
                            GroupDisplayName = "All devices"
                        } -ClientOnly)
                    )
                    IosOnboarded = $True
                    MacOsEnrollmentAssignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_IntunedeviceAndAppManagementAssignmentTarget -Property @{
                            dataType = "#microsoft.graph.allDevicesAssignmentTarget"
                            GroupDisplayName = "All devices"
                        } -ClientOnly)
                    )
                    MacOsOnboarded = $True
                    PartnerState = "unknown"
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementComplianceManagementPartner -MockWith {
                    return @{
                        AndroidEnrollmentAssignments = @(
                            @{
                                Target = @{
                                    '@odata.type' = "#microsoft.graph.allDevicesAssignmentTarget"
                                }
                            }
                        )
                        DisplayName = "FakeStringValue"
                        Id = "FakeStringValue"
                        IosEnrollmentAssignments = @(
                            @{
                                Target = @{
                                    '@odata.type' = "#microsoft.graph.allDevicesAssignmentTarget"
                                }
                            }
                        )
                        LastHeartbeatDateTime = "2023-01-01T00:00:00.0000000+01:00"
                        MacOsEnrollmentAssignments = @(
                            @{
                                Target = @{
                                    '@odata.type' = "#microsoft.graph.allDevicesAssignmentTarget"
                                }
                            }
                        )
                        PartnerState = "unknown"
                    }
                }

                Mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        DisplayName     = "FakeStringValue"
                        Id              = "FakeIdValue"
                        SecurityEnabled = $true
                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update the Management Partner instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgBetaDeviceManagementComplianceManagementPartner -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementComplianceManagementPartner -MockWith {
                    return @{
                        AdditionalProperties = @{
                            '@odata.type' = "#microsoft.graph.ComplianceManagementPartner"
                        }
                        AndroidEnrollmentAssignments = @(
                            @{
                                Target = @{
                                    '@odata.type' = "#microsoft.graph.allDevicesAssignmentTarget"
                                }
                            }
                        )
                        AndroidOnboarded = $True
                        DisplayName = "FakeStringValue"
                        Id = "FakeStringValue"
                        IosEnrollmentAssignments = @(
                            @{
                                Target = @{
                                    '@odata.type' = "#microsoft.graph.allDevicesAssignmentTarget"
                                }
                            }
                        )
                        IosOnboarded = $True
                        LastHeartbeatDateTime = "2023-01-01T00:00:00.0000000+01:00"
                        MacOsEnrollmentAssignments = @(
                            @{
                                Target = @{
                                    '@odata.type' = "#microsoft.graph.allDevicesAssignmentTarget"
                                }
                            }
                        )
                        MacOsOnboarded = $True
                        PartnerState = "unknown"

                    }
                }

                Mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        DisplayName     = "FakeStringValue"
                        Id              = "FakeIdValue"
                        SecurityEnabled = $true
                    }
                }
            }
            It 'Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
        #>
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
