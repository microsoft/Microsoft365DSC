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
    -DscResource 'SCRetentionEventType' -GenericStubModule $GenericStubPath
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

            Mock -CommandName Import-PSSession -MockWith {
            }

            Mock -CommandName New-PSSession -MockWith {
            }

            Mock -CommandName Remove-ComplianceRetentionEventType -MockWith {
            }

            Mock -CommandName New-ComplianceRetentionEventType -MockWith {
                return @{

                }
            }
            Mock -CommandName Set-ComplianceRetentionEventType -MockWith {
                return @{

                }
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name "Event doesn't already exist but should" -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure     = 'Present'
                    Comment    = 'event comment'
                    Name       = 'TestEvent'
                    Credential = $Credential
                }

                Mock -CommandName Get-ComplianceRetentionEventType -MockWith {
                    return $null
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'Rule already exists, and should' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure     = 'Present'
                    Comment    = 'event comment'
                    Name       = 'TestEvent'
                    Credential = $Credential
                }

                Mock -CommandName Get-ComplianceRetentionEventType -MockWith {
                    return @{
                        Name    = 'TestEvent'
                        Comment = 'event comment'
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Should recreate from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }

        Context -Name 'Rule should not exist' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure     = 'Absent'
                    Comment    = 'event comment'
                    Name       = 'TestEvent'
                    Credential = $Credential
                }

                Mock -CommandName Get-ComplianceRetentionEventType -MockWith {
                    return @{
                        Name = 'TestEvent'
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should delete from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }
                Mock -CommandName Get-ComplianceRetentionEventType  -MockWith {
                    return @{
                        Name = 'TestEvent'
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
