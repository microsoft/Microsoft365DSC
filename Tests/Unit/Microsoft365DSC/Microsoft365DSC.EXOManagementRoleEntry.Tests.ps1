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
    -DscResource 'EXOManagementRoleEntry' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            $Global:PartialExportFileName = 'c:\TestPath'

            Mock -CommandName Save-M365DSCPartialExport -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }

            Mock -CommandName Set-ManagementRoleEntry -MockWith {
            }

            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        Context -Name 'Management Role Entry is already in the desired state.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity   = "Information Rights Management\Get-BookingMailbox"
                    Parameters = @("ANR","RecipientTypeDetails", "ResultSize")
                    Credential = $Credential
                }

                Mock -CommandName Get-ManagementRoleEntry -MockWith {
                    return @{
                        Identity        = 'Information Rights Management'
                        Name            = "Get-BookingMailbox"
                        Type            = "Cmdlet"
                        Parameters      = @("ANR", "RecipientTypeDetails", "ResultSize")
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'Management Role Entry is NOT in the desired state.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity   = "Information Rights Management\Get-BookingMailbox"
                    Parameters = @("ANR","RecipientTypeDetails", "ResultSize")
                    Credential = $Credential
                }

                Mock -CommandName Get-ManagementRoleEntry -MockWith {
                    return @{
                        Identity        = 'Information Rights Management'
                        Name            = "Get-BookingMailbox"
                        Type            = "Cmdlet"
                        Parameters      = @("RecipientTypeDetails", "ResultSize") # Drift
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams | Should -Invoke 'Set-ManagementRoleEntry' -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-ManagementRoleEntry -MockWith {
                    return @{
                        Identity        = 'Information Rights Management'
                        Name            = "Get-BookingMailbox"
                        Type            = "Cmdlet"
                        Parameters      = @("ANR", "RecipientTypeDetails", "ResultSize")
                    }
                }
            }

            It 'Should Reverse Engineer resource from the Export method when single' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
