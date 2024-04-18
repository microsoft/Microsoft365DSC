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
    -DscResource 'TeamsComplianceRecordingPolicy' -GenericStubModule $GenericStubPath
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

            Mock -CommandName Set-CsTeamsComplianceRecordingPolicy -MockWith {
            }

            Mock -CommandName New-CsTeamsComplianceRecordingPolicy -MockWith {
            }

            Mock -CommandName Remove-CsTeamsComplianceRecordingPolicy -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'The TeamsComplianceRecordingPolicy should exist but it DOES NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    WarnUserOnRemoval                                   = $True
                    Description                                         = 'FakeStringValue'
                    Enabled                                             = $True
                    DisableComplianceRecordingAudioNotificationForCalls = $True
                    ComplianceRecordingApplications                     = @("123456")
                    Identity                                            = 'FakeStringValue'
                    Ensure                                              = 'Present'
                    Credential                                          = $Credential
                }

                Mock -CommandName Get-CsTeamsComplianceRecordingPolicy -MockWith {
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
                Should -Invoke -CommandName New-CsTeamsComplianceRecordingPolicy -Exactly 1
            }
        }

        Context -Name 'The TeamsComplianceRecordingPolicy exists but it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    WarnUserOnRemoval                                   = $True
                    Description                                         = 'FakeStringValue'
                    Enabled                                             = $True
                    DisableComplianceRecordingAudioNotificationForCalls = $True
                    ComplianceRecordingApplications                     = @('123456')
                    Identity                                            = 'FakeStringValue'
                    Ensure                                              = 'Absent'
                    Credential                                          = $Credential
                }

                Mock -CommandName Get-CsTeamsComplianceRecordingPolicy -MockWith {
                    return @{
                        WarnUserOnRemoval                                   = $True
                        Description                                         = 'FakeStringValue'
                        Enabled                                             = $True
                        DisableComplianceRecordingAudioNotificationForCalls = $True
                        ComplianceRecordingApplications                     = "Microsoft.Teams.Policy.Aministration.Cmdlets.Core.CompianceRecordingApplication"
                        Identity                                            = 'FakeStringValue'
                    }
                }
                Mock -CommandName Get-CsTeamsComplianceRecordingApplication  -MockWith {
                    return @{
                        Identity                                            = 'FakeStringValue/123456'
                        Id                                                  = '123456'
                    }
                }

            }

            It 'Should return Values from the Get method' {
                $Result = (Get-TargetResource @testParams)
                $Result.Ensure | Should -Be 'Present'
                $Result.ComplianceRecordingApplications.Length | Should -Be 1
                $Result.ComplianceRecordingApplications[0] | Should -Be '123456'
                Should -Invoke -CommandName Get-CsTeamsComplianceRecordingPolicy -Exactly 1
                Should -Invoke -CommandName Get-CsTeamsComplianceRecordingApplication -ParameterFilter {$Filter -eq 'FakeStringValue/*'} -Exactly 1

            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-CsTeamsComplianceRecordingPolicy -Exactly 1
            }
        }

        Context -Name 'The TeamsComplianceRecordingPolicy Exists and Values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    WarnUserOnRemoval                                   = $True
                    Description                                         = 'FakeStringValue'
                    Enabled                                             = $True
                    DisableComplianceRecordingAudioNotificationForCalls = $True
                    ComplianceRecordingApplications                     = @('123456')
                    Identity                                            = 'FakeStringValue'
                    Ensure                                              = 'Present'
                    Credential                                          = $Credential
                }

                Mock -CommandName Get-CsTeamsComplianceRecordingPolicy -MockWith {
                    return @{
                        WarnUserOnRemoval                                   = $True
                        Description                                         = 'FakeStringValue'
                        Enabled                                             = $True
                        DisableComplianceRecordingAudioNotificationForCalls = $True
                        ComplianceRecordingApplications                     = "Microsoft.Teams.Policy.Aministration.Cmdlets.Core.CompianceRecordingApplication"
                        Identity                                            = 'FakeStringValue'

                    }
                }
                Mock -CommandName Get-CsTeamsComplianceRecordingApplication  -MockWith {
                    return @{
                        Identity                                            = 'FakeStringValue/123456'
                        Id                                                  = '123456'
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'The TeamsComplianceRecordingPolicy exists and values are NOT in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    WarnUserOnRemoval                                   = $True
                    Description                                         = 'FakeStringValue'
                    Enabled                                             = $True
                    DisableComplianceRecordingAudioNotificationForCalls = $True
                    ComplianceRecordingApplications                     = @('123456')
                    Identity                                            = 'FakeStringValue'
                    Ensure                                              = 'Present'
                    Credential                                          = $Credential
                }

                Mock -CommandName Get-CsTeamsComplianceRecordingPolicy -MockWith {
                    return @{
                        WarnUserOnRemoval                                   = $False
                        Description                                         = 'FakeStringValueDrift' #Drift
                        Enabled                                             = $False
                        DisableComplianceRecordingAudioNotificationForCalls = $False
                        ComplianceRecordingApplications                     = "Microsoft.Teams.Policy.Aministration.Cmdlets.Core.CompianceRecordingApplication"
                        Identity                                            = 'FakeStringValue'
                    }
                }

                Mock -CommandName Get-CsTeamsComplianceRecordingApplication  -MockWith {
                    return @{
                        Identity                                            = 'FakeStringValue/123456Drift'
                        Id                                                  = '123456Drift'  #Drift
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
                Should -Invoke -CommandName Set-CsTeamsComplianceRecordingPolicy -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-CsTeamsComplianceRecordingPolicy -MockWith {
                    return @{
                        WarnUserOnRemoval                                   = $True
                        Description                                         = 'FakeStringValue'
                        Enabled                                             = $True
                        DisableComplianceRecordingAudioNotificationForCalls = $True
                        ComplianceRecordingApplications                     = "Microsoft.Teams.Policy.Aministration.Cmdlets.Core.CompianceRecordingApplication"
                        Identity                                            = 'FakeStringValue'

                    }
                }
                Mock -CommandName Get-CsTeamsComplianceRecordingApplication  -MockWith {
                    return @{
                        Identity                                            = 'FakeStringValue/123456'
                        Id                                                  = '123456'
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
