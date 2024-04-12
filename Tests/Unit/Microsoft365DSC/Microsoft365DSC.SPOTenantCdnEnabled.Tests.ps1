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
    -DscResource 'SPOTenantCdnEnabled' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'test@password1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@contoso.com', $secpasswd)
            $global:tenantName = $Credential.UserName.Split('@')[1].Split('.')[0]

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Set-PnPTenantCdnEnabled -MockWith {
            }

            Mock -CommandName Get-PnPTenantCdnEnabled -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'The tenant CDN Exists and Values are already in the not desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    Enable     = $false
                    CdnType    = 'Public'
                    Credential = $Credential
                    Ensure     = 'Present'
                }

                Mock -CommandName Get-PnPTenantCdnEnabled -MockWith {
                    return @{ Value = 'true' }
                }
            }

            It 'Should return Values from the Get method' {
                Get-TargetResource @testParams
                Should -Invoke -CommandName 'Get-PnPTenantCdnEnabled' -Exactly 1
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the site assets org library from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Set-PnPTenantCdnEnabled' -Exactly 1
            }
        }
        Context -Name 'The tenant CDN Exists and Values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    Enable     = $True
                    CdnType    = 'Public'
                    Credential = $Credential
                    Ensure     = 'Present'
                }

                Mock -CommandName Get-PnPTenantCdnEnabled -MockWith {
                    return @{ Value = 'True' }
                }
            }

            It 'Should return Values from the Get method' {
                Get-TargetResource @testParams
                Should -Invoke -CommandName 'Get-PnPTenantCdnEnabled' -Exactly 1
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-PnPTenantCdnEnabled -MockWith {
                    return @{ Value = 'true' }
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
