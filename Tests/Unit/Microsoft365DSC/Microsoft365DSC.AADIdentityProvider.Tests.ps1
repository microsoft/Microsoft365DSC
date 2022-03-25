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
    -DscResource "AADIdentityProvider" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)


            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {
            }

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgIdentityProvider -MockWith {
            }

            Mock -CommandName New-MgIdentityProvider -MockWith {
            }

            Mock -CommandName Remove-MgIdentityProvider -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }
        }
        # Test contexts
        Context -Name "The AADIdentityProvider should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                        Type = "FakeStringValue"
                        Name = "FakeStringValue"
                        ClientId = "FakeStringValue"
                        ClientSecret = "FakeStringValue"
                        Id = "FakeStringValue"

                    Ensure                        = "Present"
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-MgIdentityProvider -MockWith {
                    return $null
                }
            }
            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should Create the group from the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name "The AADIdentityProvider exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                                            Type = "FakeStringValue"
                        Name = "FakeStringValue"
                        ClientId = "FakeStringValue"
                        ClientSecret = "FakeStringValue"
                        Id = "FakeStringValue"

                    Ensure                        = "Absent"
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-MgIdentityProvider -MockWith {
                    return @{
                        Type = "FakeStringValue"
                        Name = "FakeStringValue"
                        ClientId = "FakeStringValue"
                        ClientSecret = "FakeStringValue"
                        Id = "FakeStringValue"

                    }
                }
            }

            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the group from the Set method' {
                Set-TargetResource @testParams
            }
        }
        Context -Name "The AADIdentityProvider Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                        Type = "FakeStringValue"
                        Name = "FakeStringValue"
                        ClientId = "FakeStringValue"
                        ClientSecret = "FakeStringValue"
                        Id = "FakeStringValue"

                    Ensure                        = "Present"
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-MgIdentityProvider -MockWith {
                    return @{
                        Type = "FakeStringValue"
                        Name = "FakeStringValue"
                        ClientId = "FakeStringValue"
                        ClientSecret = "FakeStringValue"
                        Id = "FakeStringValue"

                    }
                }
            }

            It "Should return Values from the Get method" {
                Get-TargetResource @testParams
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The AADIdentityProvider exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                        Type = "FakeStringValue"
                        Name = "FakeStringValue"
                        ClientId = "FakeStringValue"
                        ClientSecret = "FakeStringValue"
                        Id = "FakeStringValue"

                    Ensure                = "Present"
                    Credential            = $Credential;
                }

                Mock -CommandName Get-MgIdentityProvider -MockWith {
                    return @{
                        Type = "FakeStringValue"
                        Name = "FakeStringValue"
                        ClientId = "FakeStringValue"
                        ClientSecret = "FakeStringValue"
                        Id = "FakeStringValue"

                    }
                }
            }

            It "Should return Values from the Get method" {
                Get-TargetResource @testParams
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgIdentityProvider -MockWith {
                    return @{
                        Type = "FakeStringValue"
                        Name = "FakeStringValue"
                        ClientId = "FakeStringValue"
                        ClientSecret = "FakeStringValue"
                        Id = "FakeStringValue"

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
