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
    -DscResource "O365OrgCustomizationSetting" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
            $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }
        }

        # Test contexts
        Context -Name "When Organization Customization should be enabled" -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance   = "Yes"
                    Ensure             = "Present"
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName Get-OrganizationConfig -MockWith {
                    return @{
                        IsDehydrated = $true
                    }
                }

                Mock -CommandName Enable-OrganizationCustomization -MockWith {
                    return $null
                }
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be "Absent"
            }

            It "Should return false from the Test method" {
                (Test-TargetResource @testParams) | Should -Be $false
            }

            It "Should enable Organization Customization from the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Enable-OrganizationCustomization
            }
        }

        # Test contexts
        Context -Name "When Organization Config is not available" -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance   = "Yes"
                    Ensure             = "Present"
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName Get-OrganizationConfig -MockWith {
                    return $null
                }
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be "Absent"
            }
        }

        Context -Name "When Organization Customization is already enabled" -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance   = "Yes"
                    Ensure             = "Present"
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName Get-OrganizationConfig -MockWith {
                    return @{
                        IsDehydrated = $false
                    }
                }

                Mock -CommandName Enable-OrganizationCustomization -MockWith {
                    return $null
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount = $GlobalAdminAccount
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Mock -CommandName Get-OrganizationConfig -MockWith {
                    return @{
                        IsDehydrated = $false
                    }
                }
                Export-TargetResource @testParams
            }

            BeforeEach {
                Mock -CommandName Get-OrganizationConfig -MockWith {
                    return @{
                        IsDehydrated = $true
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
