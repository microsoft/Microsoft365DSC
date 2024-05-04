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
    -DscResource 'EXOJournalRule' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@contoso.onmicrosoft.com', $secpasswd)

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
        Context -Name "Rule doesn't exist and it should" -Fixture {
            BeforeAll {
                $testParams = @{
                    Name                = 'TestRule'
                    JournalEmailAddress = 'test@contoso.com'
                    Enabled             = $True
                    RuleScope           = 'Global'
                    Recipient           = 'bob.houle@contoso.com'
                    Ensure              = 'Present'
                    Credential          = $Credential
                }

                Mock -CommandName Get-JournalRule -MockWith {
                    return $null
                }

                Mock -CommandName New-JournalRule -MockWith {

                }
            }

            It 'Should return False from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should call the New-JournalRule cmdlet' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'New-JournalRule' -Exactly 1
            }
        }

        Context -Name 'Journal Rule already exists and should be updated' -Fixture {
            BeforeAll {
                $testParams = @{
                    Name                = 'TestRule'
                    JournalEmailAddress = 'test@contoso.com'
                    Enabled             = $True
                    RuleScope           = 'Global'
                    Recipient           = 'bob.houle@contoso.com'
                    Ensure              = 'Present'
                    Credential          = $Credential
                }

                Mock -CommandName Get-JournalRule -MockWith {
                    return @{
                        Name                = 'TestRule'
                        JournalEmailAddress = 'test@contoso.com'
                        Enabled             = $False #Drift
                        Scope               = 'Global'
                        Recipient           = 'JohnSmith@contoso.com' #Drift
                    }
                }

                Mock -CommandName Set-JournalRule -MockWith {

                }
            }

            It 'Should return False from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should set Call into the Set-JournalRule command exactly once' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Set-JournalRule' -Exactly 1
            }
        }

        Context -Name 'Rule exists and it should not' -Fixture {
            BeforeAll {
                $testParams = @{
                    Name                = 'TestRule'
                    JournalEmailAddress = 'test@contoso.com'
                    Ensure              = 'Absent'
                    Credential          = $Credential
                }

                Mock -CommandName Get-JournalRule -MockWith {
                    return @{
                        Name                = 'TestRule'
                        JournalEmailAddress = 'test@contoso.com'
                        Enabled             = $False
                        Scope               = 'Global'
                        Recipient           = 'JohnSmith@contoso.com'
                    }
                }

                Mock -CommandName Remove-JournalRule -MockWith {

                }
            }

            It 'Should return present from the Get-TargetResource function' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should call into the Remove-JournalRule cmdlet once' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Remove-JournalRule' -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-JournalRule -MockWith {
                    return @{
                        Name                = 'TestRule'
                        JournalEmailAddress = 'test@contoso.com'
                        Enabled             = $False
                        Scope               = 'Global'
                        Recipient           = 'JohnSmith@contoso.com'
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
