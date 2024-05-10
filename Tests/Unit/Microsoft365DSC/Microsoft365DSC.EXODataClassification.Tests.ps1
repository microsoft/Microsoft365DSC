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
    -DscResource 'EXODataClassification' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@contoso.onmicrosoft.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Set-DataClassification -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name "Classification doesn't exist and it should" -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential  = $Credential
                    Description = "Detects Australian driver's license number."
                    Ensure      = 'Present'
                    Identity    = '1cbbc8f5-9216-4392-9eb5-5ac2298d1356'
                    IsDefault   = $True
                    Locale      = 'en-US'
                    Name        = "Australia Driver's License Number"
                }

                Mock -CommandName Get-DataClassification -MockWith {
                    return $null
                }
            }

            It 'Should return False from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should call the New- cmdlet' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'Classification already exists and should be updated' -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential  = $Credential
                    Description = "Detects Australian driver's license number."
                    Ensure      = 'Present'
                    Identity    = '1cbbc8f5-9216-4392-9eb5-5ac2298d1356'
                    IsDefault   = $True
                    Locale      = 'en-US'
                    Name        = "Australia Driver's License Number"
                }

                Mock -CommandName Get-DataClassification -MockWith {
                    return @{
                        Description = "Detects Australian driver's license number."
                        Identity    = '1cbbc8f5-9216-4392-9eb5-5ac2298d1356'
                        IsDefault   = $False; #Drift
                        Locale      = 'en-US'
                        Name        = "Australia Driver's License Number"
                    }
                }

                Mock -CommandName Set-DataClassification -MockWith {

                }
            }

            It 'Should return False from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should set Call into the Set-DataClassification command exactly once' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'Classification exists and it should not' -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential  = $Credential
                    Description = "Detects Australian driver's license number."
                    Ensure      = 'Absent'
                    Identity    = '1cbbc8f5-9216-4392-9eb5-5ac2298d1356'
                    IsDefault   = $True
                    Locale      = 'en-US'
                    Name        = "Australia Driver's License Number"
                }

                Mock -CommandName Get-DataClassification -MockWith {
                    return @{
                        Description = "Detects Australian driver's license number."
                        Identity    = '1cbbc8f5-9216-4392-9eb5-5ac2298d1356'
                        IsDefault   = $True
                        Locale      = 'en-US'
                        Name        = "Australia Driver's License Number"
                    }
                }

                Mock -CommandName Remove-DataClassification -MockWith {

                }
            }

            It 'Should return present from the Get-TargetResource function' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should call into the Remove-DataClassification cmdlet once' {
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

                Mock -CommandName Get-DataClassification -MockWith {
                    return @{
                        Description = "Detects Australian driver's license number."
                        Identity    = '1cbbc8f5-9216-4392-9eb5-5ac2298d1356'
                        IsDefault   = $True
                        Locale      = 'en-US'
                        Name        = "Australia Driver's License Number"
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
