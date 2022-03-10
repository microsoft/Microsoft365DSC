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
    -DscResource "AADDomain" -GenericStubModule $GenericStubPath
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

            Mock -CommandName Update-MgDomain -MockWith {
            }

            Mock -CommandName New-MgDomain -MockWith {
            }

            Mock -CommandName Remove-MgDomain -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }
        }
        # Test contexts
        Context -Name "The AADDomain should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                        Manufacturer = "FakeStringValue"
                        Id = "FakeStringValue"
                        Model = "FakeStringValue"
                        IsInitial = $True
                        IsRoot = $True
                        IsVerified = $True
                        AuthenticationType = "FakeStringValue"
                        IsAdminManaged = $True
                        AvailabilityStatus = "FakeStringValue"
                        PasswordNotificationWindowInDays = 25
                        IsDefault = $True
                        PasswordValidityPeriodInDays = 25

                    Ensure                        = "Present"
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-MgDomain -MockWith {
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

        Context -Name "The AADDomain exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                                            Manufacturer = "FakeStringValue"
                        Id = "FakeStringValue"
                        Model = "FakeStringValue"
                        IsInitial = $True
                        IsRoot = $True
                        IsVerified = $True
                        AuthenticationType = "FakeStringValue"
                        IsAdminManaged = $True
                        AvailabilityStatus = "FakeStringValue"
                        PasswordNotificationWindowInDays = 25
                        IsDefault = $True
                        PasswordValidityPeriodInDays = 25

                    Ensure                        = "Absent"
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-MgDomain -MockWith {
                    return @{
                        Manufacturer = "FakeStringValue"
                        Id = "FakeStringValue"
                        Model = "FakeStringValue"
                        IsInitial = $True
                        IsRoot = $True
                        IsVerified = $True
                        AuthenticationType = "FakeStringValue"
                        IsAdminManaged = $True
                        AvailabilityStatus = "FakeStringValue"
                        PasswordNotificationWindowInDays = 25
                        IsDefault = $True
                        PasswordValidityPeriodInDays = 25

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
        Context -Name "The AADDomain Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                        Manufacturer = "FakeStringValue"
                        Id = "FakeStringValue"
                        Model = "FakeStringValue"
                        IsInitial = $True
                        IsRoot = $True
                        IsVerified = $True
                        AuthenticationType = "FakeStringValue"
                        IsAdminManaged = $True
                        AvailabilityStatus = "FakeStringValue"
                        PasswordNotificationWindowInDays = 25
                        IsDefault = $True
                        PasswordValidityPeriodInDays = 25

                    Ensure                        = "Present"
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-MgDomain -MockWith {
                    return @{
                        Manufacturer = "FakeStringValue"
                        Id = "FakeStringValue"
                        Model = "FakeStringValue"
                        IsInitial = $True
                        IsRoot = $True
                        IsVerified = $True
                        AuthenticationType = "FakeStringValue"
                        IsAdminManaged = $True
                        AvailabilityStatus = "FakeStringValue"
                        PasswordNotificationWindowInDays = 25
                        IsDefault = $True
                        PasswordValidityPeriodInDays = 25

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

        Context -Name "The AADDomain exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                        Manufacturer = "FakeStringValue"
                        Id = "FakeStringValue"
                        Model = "FakeStringValue"
                        IsInitial = $True
                        IsRoot = $True
                        IsVerified = $True
                        AuthenticationType = "FakeStringValue"
                        IsAdminManaged = $True
                        AvailabilityStatus = "FakeStringValue"
                        PasswordNotificationWindowInDays = 25
                        IsDefault = $True
                        PasswordValidityPeriodInDays = 25

                    Ensure                = "Present"
                    Credential            = $Credential;
                }

                Mock -CommandName Get-MgDomain -MockWith {
                    return @{
                        Manufacturer = "FakeStringValue"
                        Id = "FakeStringValue"
                        Model = "FakeStringValue"
                        IsInitial = $False
                        IsRoot = $False
                        IsVerified = $False
                        AuthenticationType = "FakeStringValue"
                        IsAdminManaged = $False
                        AvailabilityStatus = "FakeStringValue"
                        PasswordNotificationWindowInDays = 7
                        IsDefault = $False
                        PasswordValidityPeriodInDays = 7

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

                Mock -CommandName Get-MgDomain -MockWith {
                    return @{
                        Manufacturer = "FakeStringValue"
                        Id = "FakeStringValue"
                        Model = "FakeStringValue"
                        IsInitial = $True
                        IsRoot = $True
                        IsVerified = $True
                        AuthenticationType = "FakeStringValue"
                        IsAdminManaged = $True
                        AvailabilityStatus = "FakeStringValue"
                        PasswordNotificationWindowInDays = 25
                        IsDefault = $True
                        PasswordValidityPeriodInDays = 25

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
