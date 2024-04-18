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
    -DscResource 'SCDLPComplianceRule' -GenericStubModule $GenericStubPath
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

            Mock -CommandName Import-PSSession -MockWith {
            }

            Mock -CommandName New-PSSession -MockWith {
            }

            Mock -CommandName Remove-DLPComplianceRule -MockWith {
            }

            Mock -CommandName New-DLPComplianceRule -MockWith {
                return @{

                }
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name "Rule doesn't already exist but should" -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                              = 'Present'
                    Policy                              = 'MyParentPolicy'
                    Comment                             = ''
                    ContentContainsSensitiveInformation = (New-CimInstance -ClassName MSFT_SCDLPContainsSensitiveInformation -Property @{
                            SensitiveInformation = [CIMInstance[]]@(New-CimInstance -ClassName  MSFT_SCDLPSensitiveInformation -Property @{
                                    name           = 'ABA Routing Number'
                                    id             = 'cb353f78-2b72-4c3c-8827-92ebe4f69fdf'
                                    maxconfidence  = '100'
                                    minconfidence  = '75'
                                    classifiertype = 'Content'
                                    mincount       = '1'
                                    maxcount       = '-1'
                                } -ClientOnly)
                        } -ClientOnly)

                    BlockAccess                         = $False
                    Name                                = 'TestPolicy'
                    Credential                          = $Credential
                }
                Mock -CommandName Get-DLPComplianceRule -MockWith {
                    return $null
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name "Rule Group doesn't already exist but should" -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                              = 'Present'
                    Policy                              = 'MyParentPolicy'
                    Comment                             = ''
                    ContentContainsSensitiveInformation = New-CimInstance -ClassName MSFT_SCDLPContainsSensitiveInformation -Property @{
                        Operator = 'And'
                        Groups   = [CIMInstance[]]@(
                            New-CimInstance -ClassName MSFT_SCDLPContainsSensitiveInformationGroup -Property @{
                                Name                 = 'default'
                                operator             = 'and'
                                SensitiveInformation = [CIMInstance[]]@(
                                    New-CimInstance -ClassName MSFT_SCDLPSensitiveInformation -Property @{
                                        name           = 'ABA Routing Number'
                                        id             = 'cb353f78-2b72-4c3c-8827-92ebe4f69fdf'
                                        maxconfidence  = '100'
                                        minconfidence  = '75'
                                        classifiertype = 'Content'
                                        mincount       = '1'
                                        maxcount       = '-1'
                                    } -ClientOnly
                                    New-CimInstance -ClassName MSFT_SCDLPSensitiveInformation -Property @{
                                        name           = 'Argentina Unique Tax Identification Key (CUIT/CUIL)'
                                        id             = '98da3da1-9199-4571-b7c4-b6522980b507'
                                        maxconfidence  = '100'
                                        minconfidence  = '75'
                                        classifiertype = 'Content'
                                        mincount       = '1'
                                        maxcount       = '-1'
                                    } -ClientOnly
                                )
                            } -ClientOnly
                        )
                    } -ClientOnly
                    BlockAccess                         = $False
                    Name                                = 'TestPolicy'
                    Credential                          = $Credential
                }

                Mock -CommandName Get-DLPComplianceRule -MockWith {
                    return $null
                }
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should return Absent from the Get method' {
                    (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'Rule already exists, and should' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                              = 'Present'
                    Policy                              = 'MyParentPolicy'
                    Comment                             = 'New comment'
                    ContentContainsSensitiveInformation = (New-CimInstance -ClassName MSFT_SCDLPContainsSensitiveInformation -Property @{
                            SensitiveInformation = (New-CimInstance -ClassName  MSFT_SCDLPSensitiveInformation -Property @{
                                    name           = 'ABA Routing Number'
                                    id             = 'cb353f78-2b72-4c3c-8827-92ebe4f69fdf'
                                    maxconfidence  = '100'
                                    minconfidence  = '75'
                                    classifiertype = 'Content'
                                    mincount       = '1'
                                    maxcount       = '-1'
                                } -ClientOnly)
                        } -ClientOnly)
                    BlockAccess                         = $False
                    Name                                = 'TestPolicy'
                    Credential                          = $Credential
                }

                Mock -CommandName Get-DLPComplianceRule -MockWith {
                    return @{
                        Name                                = 'TestPolicy'
                        Comment                             = 'New Comment'
                        ParentPolicyName                    = 'MyParentPolicy'
                        ContentContainsSensitiveInformation = @(@{maxconfidence = '100'; id = 'cb353f78-2b72-4c3c-8827-92ebe4f69fdf'; minconfidence = '75'; rulePackId = '00000000-0000-0000-0000-000000000000'; classifiertype = 'Content'; name = 'ABA Routing Number'; mincount = '1'; maxcount = '-1'; })
                        BlockAccess                         = $False
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Should recreate from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Present from the Get method' {
                    (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }

        Context -Name 'Rule should not exist' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure      = 'Absent'
                    Policy      = 'MyParentPolicy'
                    Comment     = ''
                    BlockAccess = $False
                    Name        = 'TestPolicy'
                    Credential  = $Credential
                }

                Mock -CommandName Get-DLPComplianceRule -MockWith {
                    return @{
                        Name                                = 'TestPolicy'
                        ParentPolicyName                    = 'MyParentPolicy'
                        ContentContainsSensitiveInformation = @(@{maxconfidence = '100'; id = 'eefbb00e-8282-433c-8620-8f1da3bffdb2'; minconfidence = '75'; rulePackId = '00000000-0000-0000-0000-000000000000'; classifiertype = 'Content'; name = 'Argentina National Identity (DNI) Number'; mincount = '1'; maxcount = '9'; })
                        Comment                             = ''
                        BlockAccess                         = $False
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should delete from the Set method' {
                Set-TargetResource @testParams
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

                Mock -CommandName Get-DLPComplianceRule -MockWith {
                    return @{
                        Name                                = 'TestPolicy'
                        ParentPolicyName                    = 'MyParentPolicy'
                        ContentContainsSensitiveInformation = @(@{maxconfidence = '100'; id = 'eefbb00e-8282-433c-8620-8f1da3bffdb2'; minconfidence = '75'; rulePackId = '00000000-0000-0000-0000-000000000000'; classifiertype = 'Content'; name = 'Argentina National Identity (DNI) Number'; mincount = '1'; maxcount = '9'; })
                        Comment                             = ''
                        BlockAccess                         = $False
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
