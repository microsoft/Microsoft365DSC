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
    -DscResource 'O365OrgCustomizationSetting' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
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
        Context -Name 'When Organization Customization should be enabled' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance = 'Yes'
                    Ensure           = 'Present'
                    Credential       = $Credential
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

            It 'Should return absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                (Test-TargetResource @testParams) | Should -Be $false
            }

            It 'Should enable Organization Customization from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Enable-OrganizationCustomization
            }
        }

        # Test contexts
        Context -Name 'When Organization Config is not available' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance = 'Yes'
                    Ensure           = 'Present'
                    Credential       = $Credential
                }

                Mock -CommandName Get-OrganizationConfig -MockWith {
                    return $null
                }
            }

            It 'Should return absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
        }

        Context -Name 'When Organization Customization is already enabled' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance = 'Yes'
                    Ensure           = 'Present'
                    Credential       = $Credential
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

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }
            }

            It 'Should Reverse Engineer resource from the Export method' {
                Mock -CommandName Get-OrganizationConfig -MockWith {
                    return @{
                        IsDehydrated = $false
                    }
                }
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }

            BeforeEach {
                Mock -CommandName Get-OrganizationConfig -MockWith {
                    return @{
                        IsDehydrated = $true
                    }
                }
            }

            It 'Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @testParams
                $result | Should -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
