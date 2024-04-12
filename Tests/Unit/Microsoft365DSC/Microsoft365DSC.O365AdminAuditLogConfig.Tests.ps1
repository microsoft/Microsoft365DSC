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
    -DscResource 'O365AdminAuditLogConfig' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'test@password1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'Set-TargetResource When the Unified Audit Log Ingestion is Disabled' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance                = 'Yes'
                    Ensure                          = 'Present'
                    Credential                      = $Credential
                    UnifiedAuditLogIngestionEnabled = 'Enabled'
                }

                Mock -CommandName Get-AdminAuditLogConfig -MockWith {
                    return @{
                        UnifiedAuditLogIngestionEnabled = $false
                    }
                }
            }

            It 'Should return Disabled from the Get method' {
                (Get-TargetResource @testParams).UnifiedAuditLogIngestionEnabled | Should -Be 'Disabled'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Enables UnifiedAuditLogIngestionEnabled in the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'Set-TargetResource When the Unified Audit Log Ingestion is Enabled' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance                = 'Yes'
                    Ensure                          = 'Present'
                    Credential                      = $Credential
                    UnifiedAuditLogIngestionEnabled = 'Disabled'
                }

                Mock -CommandName Get-AdminAuditLogConfig -MockWith {
                    return @{
                        UnifiedAuditLogIngestionEnabled = $true
                    }
                }
            }

            It 'Should return Enabled from the Get method' {
                (Get-TargetResource @testParams).UnifiedAuditLogIngestionEnabled | Should -Be 'Enabled'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Enables UnifiedAuditLogIngestionEnabled in the Set method' {
                Set-TargetResource @testParams
            }
        }


        Context -Name 'Test Passes When the Unified Audit Log Ingestion is Disabled' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance                = 'Yes'
                    Ensure                          = 'Present'
                    Credential                      = $Credential
                    UnifiedAuditLogIngestionEnabled = 'Disabled'
                }

                Mock -CommandName Get-AdminAuditLogConfig -MockWith {
                    return @{
                        UnifiedAuditLogIngestionEnabled = $false
                    }
                }
            }

            It 'Should return Disabled from the Get method' {
                (Get-TargetResource @testParams).UnifiedAuditLogIngestionEnabled | Should -Be 'Disabled'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

        }

        Context -Name 'Test Passes When the Unified Audit Log Ingestion is Enabled' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance                = 'Yes'
                    Ensure                          = 'Present'
                    Credential                      = $Credential
                    UnifiedAuditLogIngestionEnabled = 'Enabled'
                }

                Mock -CommandName Get-AdminAuditLogConfig -MockWith {
                    return @{
                        UnifiedAuditLogIngestionEnabled = $true
                    }
                }
            }

            It 'Should return Enabled from the Get method' {
                (Get-TargetResource @testParams).UnifiedAuditLogIngestionEnabled | Should -Be 'Enabled'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-AdminAuditLogConfig -MockWith {
                    return @{
                        UnifiedAuditLogIngestionEnabled = 'Enabled'
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
