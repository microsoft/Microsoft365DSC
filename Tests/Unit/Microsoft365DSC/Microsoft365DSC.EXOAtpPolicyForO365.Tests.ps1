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
    -DscResource 'EXOAtpPolicyForO365' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {
            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@contoso.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Get-AtpPolicyForO365 -MockWith {
            }

            Mock -CommandName Set-AtpPolicyForO365 -MockWith {
            }

            Mock -CommandName Confirm-ImportedCmdletIsAvailable -MockWith {
                return $true
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'AtpPolicyForO365 update not required.' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance        = 'Yes'
                    Ensure                  = 'Present'
                    Identity                = 'Default'
                    Credential              = $Credential
                    AllowSafeDocsOpen       = $false
                    EnableATPForSPOTeamsODB = $true
                }

                Mock -CommandName Get-AtpPolicyForO365 -MockWith {
                    return @{
                        IsSingleInstance        = 'Yes'
                        Ensure                  = 'Present'
                        Identity                = 'Default'
                        Credential              = $Credential
                        AllowSafeDocsOpen       = $false
                        BlockUrls               = @()
                        EnableATPForSPOTeamsODB = $true
                        TrackClicks             = $true
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'AtpPolicyForO365 update needed.' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance        = 'Yes'
                    Ensure                  = 'Present'
                    Identity                = 'Default'
                    Credential              = $Credential
                    AllowSafeDocsOpen       = $false
                    EnableATPForSPOTeamsODB = $true
                }
                Mock -CommandName Get-AtpPolicyForO365 -MockWith {
                    return @{
                        IsSingleInstance        = 'Yes'
                        Ensure                  = 'Present'
                        Identity                = 'Default'
                        Credential              = $Credential
                        AllowSafeDocsOpen       = $true
                        BlockUrls               = @()
                        EnableATPForSPOTeamsODB = $false
                        TrackClicks             = $false
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'AtpPolicyForO365 does not exist' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance        = 'Yes'
                    Ensure                  = 'Present'
                    Identity                = 'Invalid'
                    Credential              = $Credential
                    AllowSafeDocsOpen       = $false
                    EnableATPForSPOTeamsODB = $true
                }
                Mock -CommandName Get-AtpPolicyForO365 -MockWith {
                    return @{
                        Ensure                  = 'Present'
                        Identity                = 'Default2' # Drift
                        AllowSafeDocsOpen       = $false
                        EnableATPForSPOTeamsODB = $false
                        TrackClicks             = $false
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should throw an Error from the Set method' {
                { Set-TargetResource @testParams } | Should -Throw "EXOAtpPolicyForO365 configurations MUST specify Identity value of 'Default'"
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-AtpPolicyForO365 -MockWith {
                    return @{
                        Identity                = 'Default'
                        AllowSafeDocsOpen       = $false
                        BlockUrls               = @()
                        EnableATPForSPOTeamsODB = $false
                        TrackClicks             = $false
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
