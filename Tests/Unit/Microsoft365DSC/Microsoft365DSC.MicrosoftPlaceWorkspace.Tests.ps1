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
    -DscResource 'MicrosoftPlaceWorkspace' -GenericStubModule $GenericStubPath
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

            Mock -CommandName Invoke-MgGraphRequest -MockWith {
            }

            Mock -CommandName Write-M365DSCHost -MockWith {
            }
            $Script:exportedInstances = $null
            $Script:ExportMode = $false
        }

        Context -Name 'Workspace does not exist but should' -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity    = 'workspace-001'
                    DisplayName = 'Open Collaboration Area'
                    Ensure      = 'Present'
                    Credential  = $Credential
                }

                Mock -CommandName Invoke-MgGraphRequest -MockWith {
                    return $null
                } -ParameterFilter { $Uri -eq "https://graph.microsoft.com/beta/places/workspace-001" }
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create the workspace from the Set method' {
                Mock -CommandName Invoke-MgGraphRequest -MockWith {
                    return @{ id = 'workspace-001' }
                } -ParameterFilter { $Uri -eq "https://graph.microsoft.com/beta/places" -and $Method -eq 'POST' }

                Set-TargetResource @testParams
                Should -Invoke -CommandName Invoke-MgGraphRequest -Exactly 1 -ParameterFilter { $Method -eq 'POST' }
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            It 'Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @Credential
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}