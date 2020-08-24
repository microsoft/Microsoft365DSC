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
    -DscResource "SPOPropertyBag" -GenericStubModule $GenericStubPath

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

            Mock -CommandName Set-PnPPropertyBagValue -MockWith {

            }

            Mock -CommandName Remove-PnpPropertyBagValue -MockWith {

            }
        }

        # Test contexts
        Context -Name "Need to Configure New Key" -Fixture {
            BeforeAll {
                $testParams = @{
                    Url                = "https://contoso.sharepoint.com"
                    Key                = "MyKey"
                    Value              = "MyValue"
                    GlobalAdminAccount = $GlobalAdminAccount
                    Ensure             = 'Present'
                }

                Mock -CommandName Get-PnPPropertyBag -MockWith {
                    return $null
                }
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Sets the property in Set method" {
                Set-TargetResource @testParams
            }

            It "Return ensure is Absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
        }

        Context -Name "Need to remove the Key" -Fixture {
            BeforeAll {
                $testParams = @{
                    Url                = "https://contoso.sharepoint.com"
                    Key                = "MyKey"
                    Value              = "MyValue"
                    GlobalAdminAccount = $GlobalAdminAccount
                    Ensure             = 'Absent'
                }

                Mock -CommandName Get-PnPPropertyBag -MockWith {
                    return @(
                        @{
                            Key   = "MyKey"
                            Value = "MyValue"
                        }
                    )
                }
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Remove the property in Set method" {
                Set-TargetResource @testParams
            }

            It "Return ensure is Absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName Get-PnPTenantSite -MockWith {
                    return @(
                        @{
                            Url = "https://contoso.sharepoint.com"
                        }
                    )
                }

                Mock -CommandName Get-PnPPropertyBag -MockWith {
                    return @(
                        @{
                            Key   = "MyKey"
                            Value = "MyValue"
                        }
                    )
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }#inmodulescope
}#describe

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
