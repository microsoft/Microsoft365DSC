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
    -DscResource 'SCAutoSensitivityLabelRule' -GenericStubModule $GenericStubPath
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

            Mock -CommandName Import-PSSession -MockWith {
            }

            Mock -CommandName New-PSSession -MockWith {
            }

            Mock -CommandName Remove-AutoSensitivityLabelRule -MockWith {
            }

            Mock -CommandName New-AutoSensitivityLabelRule -MockWith {
                return @{

                }
            }

            Mock -CommandName Set-AutoSensitivityLabelRule -MockWith {
                return @{

                }
            }

            Mock -CommandName Get-AutoSensitivityLabelPolicy -MockWith {
                return @{
                    ApplySensitivityLabel = 'TopSecret'
                    Comment               = 'Test'
                    ExchangeLocation      = @('All')
                    Mode                  = 'Enable'
                    Name                  = 'TestPolicy'
                    Priority              = 0
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
                    Comment                             = 'Detects when 1 to 9 credit card numbers are contained in Exchange items'
                    Credential                          = $Credential
                    Disabled                            = $False
                    DocumentIsPasswordProtected         = $False
                    DocumentIsUnsupported               = $False
                    Ensure                              = 'Present'
                    ExceptIfDocumentIsPasswordProtected = $False
                    ExceptIfDocumentIsUnsupported       = $False
                    ExceptIfProcessingLimitExceeded     = $False
                    Name                                = 'TestRule'
                    Policy                              = 'TestPolicy'
                    ProcessingLimitExceeded             = $False
                    ReportSeverityLevel                 = 'Low'
                    Workload                            = 'Exchange'
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
                }

                Mock -CommandName Get-AutoSensitivityLabelRule -MockWith {
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
                Assert-MockCalled -CommandName New-AutoSensitivityLabelRule -Exactly 1
            }
        }

        Context -Name 'Rule already exists and is in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    Comment                             = 'Detects when 1 to 9 credit card numbers are contained in Exchange items'
                    Credential                          = $Credential
                    Disabled                            = $False
                    DocumentIsPasswordProtected         = $False
                    DocumentIsUnsupported               = $False
                    Ensure                              = 'Present'
                    ExceptIfDocumentIsPasswordProtected = $False
                    ExceptIfDocumentIsUnsupported       = $False
                    ExceptIfProcessingLimitExceeded     = $False
                    Name                                = 'TestRule'
                    Policy                              = 'TestPolicy'
                    ProcessingLimitExceeded             = $False
                    ReportSeverityLevel                 = 'Low'
                    Workload                            = 'Exchange'
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
                }

                Mock -CommandName Get-AutoSensitivityLabelRule -MockWith {
                    return @{
                        Comment                             = 'Detects when 1 to 9 credit card numbers are contained in Exchange items'
                        Disabled                            = $False
                        DocumentIsPasswordProtected         = $False
                        DocumentIsUnsupported               = $False
                        ExceptIfDocumentIsPasswordProtected = $False
                        ExceptIfDocumentIsUnsupported       = $False
                        ExceptIfProcessingLimitExceeded     = $False
                        Name                                = 'TestRule'
                        ParentPolicyName                    = 'TestPolicy'
                        ProcessingLimitExceeded             = $False
                        ReportSeverityLevel                 = 'Low'
                        Workload                            = 'Exchange'
                        ContentContainsSensitiveInformation = @(@{maxconfidence = '100'; id = 'cb353f78-2b72-4c3c-8827-92ebe4f69fdf'; minconfidence = '75'; rulePackId = '00000000-0000-0000-0000-000000000000'; classifiertype = 'Content'; name = 'ABA Routing Number'; mincount = '1'; maxcount = '-1'; })
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Should create from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Present from the Get method' {
                    (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }

        Context -Name 'Rule already exists and is NOT in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    Comment                             = 'Detects when 1 to 9 credit card numbers are contained in Exchange items'
                    Credential                          = $Credential
                    Disabled                            = $False
                    DocumentIsPasswordProtected         = $False
                    DocumentIsUnsupported               = $False
                    Ensure                              = 'Present'
                    ExceptIfDocumentIsPasswordProtected = $False
                    ExceptIfDocumentIsUnsupported       = $False
                    ExceptIfProcessingLimitExceeded     = $False
                    Name                                = 'TestRule'
                    Policy                              = 'TestPolicy'
                    ProcessingLimitExceeded             = $False
                    ReportSeverityLevel                 = 'Low'
                    Workload                            = 'Exchange'
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
                }

                Mock -CommandName Get-AutoSensitivityLabelRule -MockWith {
                    return @{
                        Comment                             = 'Detects when 1 to 9 credit card numbers are contained in Exchange items'
                        Disabled                            = $False
                        DocumentIsPasswordProtected         = $False
                        DocumentIsUnsupported               = $False
                        ExceptIfDocumentIsPasswordProtected = $True; # Drift
                        ExceptIfDocumentIsUnsupported       = $False
                        ExceptIfProcessingLimitExceeded     = $False
                        Name                                = 'TestRule'
                        ParentPolicyName                    = 'TestPolicy'
                        ProcessingLimitExceeded             = $False
                        ReportSeverityLevel                 = 'Low'
                        Workload                            = 'Exchange'
                        ContentContainsSensitiveInformation = @(@{maxconfidence = '100'; id = 'cb353f78-2b72-4c3c-8827-92ebe4f69fdf'; minconfidence = '75'; rulePackId = '00000000-0000-0000-0000-000000000000'; classifiertype = 'Content'; name = 'ABA Routing Number'; mincount = '1'; maxcount = '-1'; })
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update from the Set method' {
                Set-TargetResource @testParams
                Assert-MockCalled -CommandName Set-AutoSensitivityLabelRule -Exactly 1
            }

            It 'Should return Present from the Get method' {
                    (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }

        Context -Name 'Rule should not exist' -Fixture {
            BeforeAll {
                $testParams = @{
                    Comment                             = 'Detects when 1 to 9 credit card numbers are contained in Exchange items'
                    Credential                          = $Credential
                    Disabled                            = $False
                    DocumentIsPasswordProtected         = $False
                    DocumentIsUnsupported               = $False
                    Ensure                              = 'Absent'
                    ExceptIfDocumentIsPasswordProtected = $False
                    ExceptIfDocumentIsUnsupported       = $False
                    ExceptIfProcessingLimitExceeded     = $False
                    Name                                = 'TestRule'
                    Policy                              = 'TestPolicy'
                    ProcessingLimitExceeded             = $False
                    ReportSeverityLevel                 = 'Low'
                    Workload                            = 'Exchange'
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
                }

                Mock -CommandName Get-AutoSensitivityLabelRule -MockWith {
                    return @{
                        Comment                             = 'Detects when 1 to 9 credit card numbers are contained in Exchange items'
                        Disabled                            = $False
                        DocumentIsPasswordProtected         = $False
                        DocumentIsUnsupported               = $False
                        ExceptIfDocumentIsPasswordProtected = $False
                        ExceptIfDocumentIsUnsupported       = $False
                        ExceptIfProcessingLimitExceeded     = $False
                        Name                                = 'TestRule'
                        ParentPolicyName                    = 'TestPolicy'
                        ProcessingLimitExceeded             = $False
                        ReportSeverityLevel                 = 'Low'
                        Workload                            = 'Exchange'
                        ContentContainsSensitiveInformation = @(@{maxconfidence = '100'; id = 'cb353f78-2b72-4c3c-8827-92ebe4f69fdf'; minconfidence = '75'; rulePackId = '00000000-0000-0000-0000-000000000000'; classifiertype = 'Content'; name = 'ABA Routing Number'; mincount = '1'; maxcount = '-1'; })
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should delete from the Set method' {
                Set-TargetResource @testParams
                Assert-MockCalled -CommandName Remove-AutoSensitivityLabelRule -Exactly 1
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

                Mock -CommandName Get-AutoSensitivityLabelRule -MockWith {
                    return @{
                        Comment                             = 'Detects when 1 to 9 credit card numbers are contained in Exchange items'
                        Disabled                            = $False
                        DocumentIsPasswordProtected         = $False
                        DocumentIsUnsupported               = $False
                        ExceptIfDocumentIsPasswordProtected = $False
                        ExceptIfDocumentIsUnsupported       = $False
                        ExceptIfProcessingLimitExceeded     = $False
                        Name                                = 'TestRule'
                        ParentPolicyName                    = 'TestPolicy'
                        ProcessingLimitExceeded             = $False
                        ReportSeverityLevel                 = 'Low'
                        LogicalWorkload                     = 'Exchange'
                        ContentContainsSensitiveInformation = @(@{maxconfidence = '100'; id = 'cb353f78-2b72-4c3c-8827-92ebe4f69fdf'; minconfidence = '75'; rulePackId = '00000000-0000-0000-0000-000000000000'; classifiertype = 'Content'; name = 'ABA Routing Number'; mincount = '1'; maxcount = '-1'; })
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
