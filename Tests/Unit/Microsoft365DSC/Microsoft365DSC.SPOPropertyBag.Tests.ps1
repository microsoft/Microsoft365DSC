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
    -DscResource 'SPOPropertyBag' -GenericStubModule $GenericStubPath

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

            Mock -CommandName Set-PnPPropertyBagValue -MockWith {
            }

            Mock -CommandName Remove-PnpPropertyBagValue -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'Need to Configure New Key' -Fixture {
            BeforeAll {
                $testParams = @{
                    Url        = 'https://contoso.sharepoint.com'
                    Key        = 'MyKey'
                    Value      = 'MyValue'
                    Credential = $Credential
                    Ensure     = 'Present'
                }

                Mock -CommandName Get-PnPPropertyBag -MockWith {
                    return $null
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Sets the property in Set method' {
                Set-TargetResource @testParams
            }

            It 'Return ensure is Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
        }

        Context -Name 'Need to remove the Key' -Fixture {
            BeforeAll {
                $testParams = @{
                    Url        = 'https://contoso.sharepoint.com'
                    Key        = 'MyKey'
                    Value      = 'MyValue'
                    Credential = $Credential
                    Ensure     = 'Absent'
                }

                Mock -CommandName Get-PnPPropertyBag -MockWith {
                    return @(
                        @{
                            Key   = 'MyKey'
                            Value = 'MyValue'
                        }
                    )
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Remove the property in Set method' {
                Set-TargetResource @testParams
            }

            It 'Return ensure is Absent from the Get method' {
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

                Mock -CommandName Get-PnPTenantSite -MockWith {
                    return @(
                        @{
                            Url = 'https://contoso.sharepoint.com'
                        }
                    )
                }

                Mock -CommandName Get-PnPPropertyBag -MockWith {
                    return @(
                        [PSCustomObject]@{
                            'Key'   = 'MyKey'
                            'Value' = 'MyValue'
                        }
                    )
                }

                Mock -CommandName Get-PnPPropertyBag -MockWith {
                    return 'MyValue'
                } -ParameterFilter { $Key -eq "MyKey" }

            }

            It 'Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }#inmodulescope
}#describe

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
