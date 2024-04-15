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
    -DscResource 'EXOReportSubmissionRule' -GenericStubModule $GenericStubPath
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

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName New-ReportSubmissionRule -MockWith {
            }

            Mock -CommandName Set-ReportSubmissionRule -MockWith {
            }

            Mock -CommandName Remove-ReportSubmissionRule -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false

            Mock -CommandName Write-Warning -MockWith {
            }
        }

        # Test contexts
        Context -Name 'ReportSubmissionRule creation.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure              = 'Present'
                    Credential          = $Credential
                    IsSingleInstance    = 'Yes'
                    Identity            = "DefaultReportSubmissionRule"
                    Comments            = "This is my default rule"
                    SentTo              = @("submission@contoso.com")
                }


                Mock -CommandName Get-ReportSubmissionRule -MockWith {
                    return $null
                }
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'New-ReportSubmissionRule' -Exactly 1
            }

        }

        Context -Name 'ReportSubmissionRule update not required.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure              = 'Present'
                    Credential          = $Credential
                    IsSingleInstance    = 'Yes'
                    Identity            = "DefaultReportSubmissionRule"
                    Comments            = "This is my default rule"
                    SentTo              = @("submission@contoso.com")
                }

                Mock -CommandName Get-ReportSubmissionRule -MockWith {
                    return @{
                        Ensure              = 'Present'
                        Credential          = $Credential
                        IsSingleInstance    = 'Yes'
                        Identity            = "DefaultReportSubmissionRule"
                        Comments            = "This is my default rule"
                        SentTo              = @("submission@contoso.com")
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'ReportSubmissionRule update needed.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure              = 'Present'
                    Credential          = $Credential
                    IsSingleInstance    = 'Yes'
                    Identity            = "DefaultReportSubmissionRule"
                    Comments            = "This is my default rule"
                    SentTo              = @("submission@contoso.com")
                }

                Mock -CommandName Get-ReportSubmissionRule -MockWith {
                    return @{
                        Ensure              = 'Present'
                        Credential          = $Credential
                        IsSingleInstance    = 'Yes'
                        Identity            = "DefaultReportSubmissionRule"
                        Comments            = "This is my default rule"
                        SentTo              = @("different@contoso.com")
                    }
                }

                Mock -CommandName Set-ReportSubmissionRule -MockWith {
                    return @{

                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Successfully call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Set-ReportSubmissionRule' -Exactly 1
            }
        }

        Context -Name 'ReportSubmissionRule removal.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure              = 'Absent'
                    Credential          = $Credential
                    IsSingleInstance    = 'Yes'
                    Identity            = "DefaultReportSubmissionRule"
                    Comments            = "This is my default rule"
                    SentTo              = @("submission@contoso.com")
                }

                Mock -CommandName Get-ReportSubmissionRule -MockWith {
                    return @{
                        Identity = "DefaultReportSubmissionRule"
                    }
                }

                Mock -CommandName Remove-ReportSubmissionRule -MockWith {
                    return @{

                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the Policy in the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Remove-ReportSubmissionRule' -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-ReportSubmissionRule -MockWith {
                    return @{
                        Identity            = "DefaultReportSubmissionRule"
                        Comments            = "This is my default rule"
                        SentTo              = @("submission@contoso.com")
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
