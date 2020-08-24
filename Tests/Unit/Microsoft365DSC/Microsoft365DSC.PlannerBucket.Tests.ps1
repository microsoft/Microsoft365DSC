[CmdletBinding()]
param(
)
$M365DSCTestFolder = Join-Path -Path $PSScriptRoot `
                        -ChildPath "..\..\Unit" `
                        -Resolve
$CmdletModule = (Join-Path -Path $M365DSCTestFolder `
            -ChildPath "\Stubs\Microsoft365.psm1" `
            -Resolve)
$GenericStubPath = (Join-Path -Path $M365DSCTestFolder `
    -ChildPath "\Stubs\Generic.psm1" `
    -Resolve)
Import-Module -Name (Join-Path -Path $M365DSCTestFolder `
        -ChildPath "\UnitTestHelper.psm1" `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "PlannerBucket" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString "Pass@word1" -AsPlainText -Force
            $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

            Mock -CommandName Connect-Graph -MockWith {
            }

            Mock -CommandName New-MGPlannerBucket -MockWith {
            }

            Mock -CommandName Update-MGPlannerBucket -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
            }
        }

        # Test contexts
        Context -Name "When the Bucket doesn't exist but it should" -Fixture {
            BeforeAll {
                $testParams = @{
                    PlanId                = "1234567890"
                    Name                 = "Contoso Bucket"
                    Ensure                = "Present"
                    ApplicationId         = "1234567890"
                    TenantId              = "1234567890"
                    CertificateThumbprint = "1234567890"
                }

                Mock -CommandName Get-MgPlannerPlanBucket -MockWith {
                    return $null
                }
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should create the Task in the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MGPlannerBucket -Exactly 1
            }
        }

        Context -Name "Bucket exists and is NOT in the Desired State" -Fixture {
            BeforeAll {
                $testParams = @{
                    PlanId                = "1234567890"
                    Name                 = "Contoso Bucket"
                    Ensure                = "Present"
                    ApplicationId         = "1234567890"
                    TenantId              = "1234567890"
                    CertificateThumbprint = "1234567890"
                }

                Mock -CommandName Get-MgPlannerPlanBucket -MockWith {
                    return @{
                        PlanId  = "1234567890"
                        Id      = "12345"
                        Name    = "Contoso Bucket"
                    }
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }

        Context -Name "Task exists and is IN the Desired State" -Fixture {
            BeforeAll {
                $testParams = @{
                    PlanId                = "1234567890"
                    Name                 = "Contoso Bucket"
                    Ensure                = "Present"
                    ApplicationId         = "1234567890"
                    TenantId              = "1234567890"
                    CertificateThumbprint = "1234567890"
                }

                Mock -CommandName Get-MgPlannerPlanBucket -MockWith {
                    return @{
                        PlanId  = "1234567890"
                        Id      = "12345"
                        Name    = "Contoso Bucket"
                    }
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It "Should return true from the Set method" {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "Task exists but it should not" -Fixture {
            BeforeAll {
                $testParams = @{
                    PlanId                = "1234567890"
                    Name                 = "Contoso Bucket"
                    Ensure                = "Absent"
                    ApplicationId         = "1234567890"
                    TenantId              = "1234567890"
                    CertificateThumbprint = "1234567890"
                }

                Mock -CommandName Get-MgPlannerPlanBucket -MockWith {
                    return @{
                        PlanId  = "1234567890"
                        Id      = "12345"
                        Name    = "Contoso Bucket"
                    }
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It "Should return false from the Set method" {
                Test-TargetResource @testParams | Should -Be $False
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    ApplicationId         = "1234567890"
                    TenantId              = "1234567890"
                    CertificateThumbprint = "1234567890"
                }

                Mock -CommandName Get-MgPlannerPlanBucket -MockWith {
                    return @{
                        PlanId  = "1234567890"
                        Id      = "12345"
                        Name    = "Contoso Bucket"
                    }
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
