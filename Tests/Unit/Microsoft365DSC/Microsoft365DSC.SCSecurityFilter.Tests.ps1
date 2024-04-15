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
    -DscResource 'SCSecurityFilter' -GenericStubModule $GenericStubPath
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


            Mock -CommandName Remove-ComplianceSecurityFilter -MockWith {
            }

            Mock -CommandName New-ComplianceSecurityFilter -MockWith {
                return @{

                }
            }

            Mock -CommandName Set-ComplianceSecurityFilter -MockWith {
                return @{

                }
            }

            Mock -CommandName Start-Sleep -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name "Security Filter doesn't already exist but should" -Fixture {
            BeforeAll {
                $testParams = @{
                    Action           = "All"
                    Description      = "My Desc"
                    FilterName       = "MYFILTER"
                    Filters          = @("Mailbox_CountryCode -eq '124'")
                    Region           = "FRA"
                    Users            = @("John.Smith@$Domain")
                    Credential       = $Credential
                    Ensure           = 'Present'
                }

                Mock -CommandName Get-ComplianceSecurityFilter -MockWith {
                    return $null
                }
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the New method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-ComplianceSecurityFilter    -Exactly 1
                Should -Invoke -CommandName Set-ComplianceSecurityFilter    -Exactly 0
                Should -Invoke -CommandName Remove-ComplianceSecurityFilter -Exactly 0
            }
        }

        Context -Name 'Security Filter exists but is not in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    Action           = "All"
                    Description      = "My Desc"
                    FilterName       = "MYFILTER"
                    Filters          = @("Mailbox_CountryCode -eq '124'")
                    Region           = "FRA"
                    Users            = @("John.Smith@$Domain")
                    Credential       = $Credential
                    Ensure           = 'Present'
                }

                Mock -CommandName Get-ComplianceSecurityFilter -MockWith {
                    return @{
                        Action           = "All"
                        Description      = "My Desc"
                        FilterName       = "MYFILTER"
                        Filters          = @("Mailbox_CountryCode -eq '124'")
                        Region           = "AUS" # This is different
                        Users            = @("John.Smith@$Domain")
                        Credential       = $Credential
                        Ensure           = 'Present'
                    }
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-ComplianceSecurityFilter    -Exactly 0
                Should -Invoke -CommandName Set-ComplianceSecurityFilter    -Exactly 1
                Should -Invoke -CommandName Remove-ComplianceSecurityFilter -Exactly 0
            }

        }

        Context -Name 'Security Filter exists and is already in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    Action           = "All"
                    Description      = "My Desc"
                    FilterName       = "MYFILTER"
                    Filters          = @("Mailbox_CountryCode -eq '124'")
                    Region           = "FRA"
                    Users            = @("John.Smith@$Domain")
                    Ensure           = 'Present'
                }

                Mock -CommandName Get-ComplianceSecurityFilter -MockWith {
                    return @{
                        Action           = "All"
                        Description      = "My Desc"
                        FilterName       = "MYFILTER"
                        Filters          = @("Mailbox_CountryCode -eq '124'")
                        Region           = "FRA"
                        Users            = @("John.Smith@$Domain")
                    }
                }
            }

            It 'Should return Present from the Get method' {
                $returnValue = Get-TargetResource @testParams
                $returnValue.Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                $returnValue = Test-TargetResource @testParams
                $returnValue | Should -Be $true
            }

            It 'Should update from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-ComplianceSecurityFilter    -Exactly 0
                Should -Invoke -CommandName Set-ComplianceSecurityFilter    -Exactly 1
                Should -Invoke -CommandName Remove-ComplianceSecurityFilter -Exactly 0
            }

        }

        Context -Name 'Security Filter exists but should not exist' -Fixture {
            BeforeAll {
                $testParams = @{
                    Action           = "All"
                    Description      = "My Desc"
                    FilterName       = "MYFILTER"
                    Filters          = @("Mailbox_CountryCode -eq '124'")
                    Region           = "FRA"
                    Users            = @("John.Smith@$Domain")
                    Credential       = $Credential
                    Ensure           = 'Absent'
                }
            }

            It 'Should return true from the Test method' {

                Mock -CommandName Get-ComplianceSecurityFilter -MockWith {
                    return @{
                        Action           = "All"
                        Description      = "My Desc"
                        FilterName       = "MYFILTER"
                        Filters          = @("Mailbox_CountryCode -eq '124'")
                        Region           = "AUS" # This is different
                        Users            = @("John.Smith@$Domain")
                        }
                }
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should return Present from the Get method' {

                Mock -CommandName Get-ComplianceSecurityFilter -MockWith {
                    return @{
                        Action           = "All"
                        Description      = "My Desc"
                        FilterName       = "MYFILTER"
                        Filters          = @("Mailbox_CountryCode -eq '124'")
                        Region           = "AUS" # This is different
                        Users            = @("John.Smith@$Domain")
                        }
                }
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'

            }

            It 'Should delete from the Set method' {
                Mock -CommandName Get-ComplianceSecurityFilter -MockWith {
                    return @{
                        Action           = "All"
                        Description      = "My Desc"
                        FilterName       = "MYFILTER"
                        Filters          = @("Mailbox_CountryCode -eq '124'")
                        Region           = "AUS" # This is different
                        Users            = @("John.Smith@$Domain")
                    }
                }
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-ComplianceSecurityFilter    -Exactly 0
                Should -Invoke -CommandName Set-ComplianceSecurityFilter    -Exactly 0
                Should -Invoke -CommandName Remove-ComplianceSecurityFilter -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }
                Mock -CommandName Get-ComplianceSecurityFilter -MockWith {
                    return @{
                        FilterName     = 'TestFilter'
                        Action         = 'All'
                    }
                }
            }

            It 'Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
                Should -Invoke -CommandName Get-ComplianceSecurityFilter -Exactly 1
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
