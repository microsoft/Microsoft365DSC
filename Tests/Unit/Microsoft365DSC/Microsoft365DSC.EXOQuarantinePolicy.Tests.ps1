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
    -DscResource "EXOQuarantinePolicy" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {

            }

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            Mock -CommandName Get-PSSession -MockWith {

            }

            Mock -CommandName Remove-PSSession -MockWith {

            }

            Mock -CommandName New-MalwareFilterPolicy -MockWith {

            }

            Mock -CommandName Set-MalwareFilterPolicy -MockWith {

            }

            Mock -CommandName Remove-MalwareFilterPolicy -MockWith {

            }
        }

        # Test contexts
        Context -Name "QuarantinePolicy creation." -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                            = 'Present'
                    Credential                        = $Credential
                    Identity                          = "DefaultFullAccessPolicy";
                    OrganizationBrandingEnabled       = $False;
                    ESNEnabled                        = $False;
                }


                Mock -CommandName Get-QuarantinePolicy -MockWith {
                    return @{
                        Identity = 'SomeOtherQuarantinePolicy'
                    }
                }
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be "Absent"
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }

        }

        Context -Name "QuarantinePolicy update not required." -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                            = 'Present'
                    Credential                        = $Credential
                    Identity                          = "DefaultFullAccessPolicy";
                    OrganizationBrandingEnabled       = $True;
                    ESNEnabled                        = $False;
                }

                Mock -CommandName Get-QuarantinePolicy -MockWith {
                    return @{
                    Ensure                            = 'Present'
                    Credential                        = $Credential
                    Identity                          = "DefaultFullAccessPolicy";
                    OrganizationBrandingEnabled       = $True;
                    ESNEnabled                        = $False;
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "QuarantinePolicy update needed." -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                            = 'Present'
                    Credential                        = $Credential
                    Identity                          = "DefaultFullAccessPolicy";
                    OrganizationBrandingEnabled       = $True;
                    ESNEnabled                        = $True;
                }

                Mock -CommandName Get-QuarantinePolicy -MockWith {
                    return @{
                    Ensure                            = 'Present'
                    Credential                        = $Credential
                    Identity                          = "DefaultFullAccessPolicy";
                    OrganizationBrandingEnabled       = $False;
                    ESNEnabled                        = $False;
                    }
                }

                Mock -CommandName Set-QuarantinePolicy -MockWith {
                    return @{

                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should Successfully call the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "QuarantinePolicy removal." -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure     = 'Absent'
                    Credential = $Credential
                    Identity   = 'TestQuarantinePolicy'
                }

                Mock -CommandName Get-QuarantinePolicy -MockWith {
                    return @{
                        Identity = 'TestQuarantinePolicy'
                    }
                }

                Mock -CommandName Remove-QuarantinePolicy -MockWith {
                    return @{

                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should Remove the Policy in the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $testParams = @{
                    Credential = $Credential
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
