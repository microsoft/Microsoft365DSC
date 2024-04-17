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
    -DscResource 'SPOHomeSite' -GenericStubModule $GenericStubPath

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

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'When there should be no home site set' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance = 'Yes'
                    Credential       = $Credential
                    Ensure           = 'Absent'
                }

                Mock -CommandName Get-PnPHomeSite -MockWith {
                    return $null
                }
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'When there is a home site and there should not be' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance = 'Yes'
                    Credential       = $Credential
                    Ensure           = 'Absent'
                }

                Mock -CommandName Get-PnPHomeSite -MockWith {
                    return 'https://contoso.sharepoint.com/sites/homesite'
                }

                Mock -CommandName Remove-PnPHomeSite -MockWith {

                }
            }

            It 'Should return present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call Remove-PnPHomeSite' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-PnPHomeSite -Exactly 1
            }
        }

        Context -Name "When there should be a home site set and there is not or it's the wrong one" -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance = 'Yes'
                    Url              = 'https://contoso.sharepoint.com/sites/homesite'
                    Credential       = $Credential
                    Ensure           = 'Present'
                }

                Mock -CommandName Get-PnPHomeSite -MockWith {
                    return 'https://contoso.sharepoint.com/sites/wrong'
                }

                Mock -CommandName Get-PnPTenantSite -MockWith {
                    throw
                }

                Mock -CommandName Set-PnPHomeSite -MockWith {
                }

                Mock -CommandName New-M365DSCLogEntry -MockWith {
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should throw an error' {
                { Set-TargetResource @testParams } | Should -Throw "The specified Site Collection $($testParams.Url) for SPOHomeSite doesn't exist."
                Should -Invoke -CommandName Get-PnPTenantSite -Exactly 1
                Should -Invoke -CommandName New-M365DSCLogEntry -Exactly 1
            }
        }

        Context -Name 'It should set the home site' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance = 'Yes'
                    Url              = 'https://contoso.sharepoint.com/sites/homesite'
                    Credential       = $Credential
                    Ensure           = 'Present'
                }

                Mock -CommandName Get-PnPHomeSite -MockWith {
                    return 'https://contoso.sharepoint.com/sites/homesite1'
                }

                Mock -CommandName Set-PnPHomeSite -MockWith {
                }

                Mock -CommandName Get-PnPTenantSite -MockWith {

                }
            }

            It 'Should set the correct site' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Get-PnPTenantSite -Exactly 1
                Should -Invoke -CommandName Set-PnPHomeSite -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-PnPHomeSite -MockWith {
                    return 'https://contoso.sharepoint.com/sites/TestSite'
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
