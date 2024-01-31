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
    -DscResource EXORecipientPermission -GenericStubModule $GenericStubPath
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

            Mock -CommandName Add-RecipientPermission -MockWith {
            }

            Mock -CommandName Remove-RecipientPermission -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name 'Permission doesnt exist and it should' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure     = 'Present'
                    Credential = $Credential
                    Identity   = 'john.smith'
                    Trustee    = 'john.doe'
                }

                Mock -CommandName Get-RecipientPermission -MockWith {
                    return $null
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should return absent from the Get Method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should add the permission in the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Add-RecipientPermission -Exactly 1
            }
        }

        Context -Name 'Permission exists and is not the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure     = 'Present'
                    Credential = $Credential
                    Identity   = 'john.smith'
                    Trustee    = 'john.doe'
                }

                Mock -CommandName Get-RecipientPermission -MockWith {
                    return $null
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should return present from the Get Method' {
                (Get-TargetResource @testParams).Ensure | Should -Be Absent
            }
        }

        Context -Name 'Permission exist and it should not' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure     = 'Absent'
                    Credential = $Credential
                    Identity   = 'john.smith'
                    Trustee    = 'john.doe'
                }

                Mock -CommandName Get-RecipientPermission -MockWith {
                    return @{
                        Identity            = 'john.smith'
                        Trustee             = 'john.doe'
                        'AccessControlType' = 'Allow'
                        AccessRights        = @('SendAs')
                        IsInherited         = $false
                        InheritanceType     = 'None'
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should return absent from the Get Method' {
                (Get-TargetResource @testParams).Ensure | Should -Be Present
            }

            It 'Should remove the permission in the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-RecipientPermission -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-RecipientPermission -MockWith {
                    return @{
                        Identity            = 'john.smith'
                        Trustee             = 'john.doe'
                        'AccessControlType' = 'Allow'
                        AccessRights        = @('SendAs')
                        IsInherited         = $false
                        InheritanceType     = 'None'
                    }
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
