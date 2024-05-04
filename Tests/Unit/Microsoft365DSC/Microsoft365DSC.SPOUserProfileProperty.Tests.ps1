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
    -DscResource 'SPOUserProfileProperty' -GenericStubModule $GenericStubPath

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

            Mock -CommandName Set-PnPUserProfileProperty -MockWith {
                return @{
                }
            }

            Mock -CommandName Get-M365DSCOrganization -MockWith {
                return 'contoso.com'
            }

            Mock -CommandName Invoke-M365DSCCommand -MockWith {
            }

            Mock -CommandName Start-Job -MockWith {
            }

            Mock -CommandName Get-Job -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false

            Mock -CommandName Write-Warning -MockWith {
            }
        }

        # Test contexts
        Context -Name 'Properties are already set' -Fixture {
            BeforeAll {
                $testParams = @{
                    UserName   = 'john.smith@contoso.com'
                    Properties = (New-CimInstance -ClassName MSFT_SPOUserProfileProperty -Property @{
                            Key   = 'MyKey'
                            Value = 'MyValue'
                        } -ClientOnly)
                    Credential = $Credential
                    Ensure     = 'Present'
                }

                Mock -CommandName Get-PnPUserProfileProperty -MockWith {
                    return @{
                        AccountName           = 'john.smith@contoso.com'
                        UserProfileProperties = @{'MyOldKey' = 'MyValue' }
                    }
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }

        Context -Name 'Properties need to be set' -Fixture {
            BeforeAll {
                $testParams = @{
                    UserName   = 'john.smith@contoso.com'
                    Properties = (New-CimInstance -ClassName MSFT_SPOUserProfileProperty -Property @{
                            Key   = 'MyNewKey'
                            Value = 'MyValue'
                        } -ClientOnly)
                    Credential = $Credential
                    Ensure     = 'Present'
                }

                Mock -CommandName Get-PnPUserProfileProperty -MockWith {
                    return @{
                        AccountName           = 'john.smith@contoso.com'
                        UserProfileProperties = @{'MyOldKey' = 'MyValue' }
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Update the settings from the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-PnPUserProfileProperty -MockWith {
                    return @{
                        AccountName           = 'john.smith@contoso.com'
                        UserProfileProperties = @{MyOldKey = 'MyValue' }
                    }
                }

                Mock -CommandName Get-PnPUser -MockWith {
                    return @{
                        PrincipalType = 'User'
                        Email         = 'john.smith@contoso.com'
                    }
                }
            }

            It 'Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }#inmodulescope
}#describe

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
