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
    -DscResource 'TeamsVoiceRoute' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'Pass@word1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)
            $Global:PartialExportFileName = 'c:\TestPath'


            Mock -CommandName Save-M365DSCPartialExport -MockWith {
            }

            Mock -CommandName New-CsOnlineVoiceRoute -MockWith {
            }

            Mock -CommandName Set-CsOnlineVoiceRoute -MockWith {
            }

            Mock -CommandName Remove-CsOnlineVoiceRoute -MockWith {
            }

            Mock -CommandName Get-CsOnlinePstnUsage -MockWith {
                return New-Object PSObject -Property @{
                    Identity = 'Global'
                    Usage    = @('Local', 'Long Distance')
                }
            }

            Mock -CommandName Get-CsOnlinePstnGateway -MockWith {
                return @(
                    New-Object PSObject -Property @{
                        Identity = 'Sbc1.litware.com'
                        Enabled  = $true
                    }
                    New-Object PSObject -Property @{
                        Identity = 'Sbc2.litware.com'
                        Enabled  = $true
                    }
                )
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
        Context -Name "When the voice route doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity              = 'Test Route'
                    Description           = 'My Test Route'
                    NumberPattern         = '^\+1(425|206)(\d{7})'
                    OnlinePstnGatewayList = @('Sbc1.litware.com', 'Sbc2.litware.com')
                    OnlinePstnUsages      = @('Local', 'Long Distance')
                    Priority              = 1
                    Ensure                = 'Present'
                    Credential            = $Credential
                }

                Mock -CommandName Get-CsOnlineVoiceRoute -MockWith {
                    return $null
                }
            }

            It 'Should return absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create the voice route from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'New-CsOnlineVoiceRoute' -Exactly 1
            }
        }

        Context -Name 'When the voice route already exists and is NOT in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity              = 'Test Route'
                    Description           = 'My Test Route'
                    NumberPattern         = '^\+1(425|206)(\d{7})'
                    OnlinePstnGatewayList = @('Sbc1.litware.com', 'Sbc2.litware.com')
                    OnlinePstnUsages      = @('Local', 'Long Distance')
                    Priority              = 1
                    Ensure                = 'Present'
                    Credential            = $Credential
                }

                Mock -CommandName Get-CsOnlineVoiceRoute -MockWith {
                    return @{
                        Identity              = 'Test Route'
                        Description           = 'My Test Route'
                        NumberPattern         = '^\+1(425|206)(\d{7})'
                        OnlinePstnGatewayList = @('Sbc1.litware.com', 'Sbc2.litware.com')
                        OnlinePstnUsages      = @('Local') #Drift
                        Priority              = 10 #Drift
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update the voice route from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-CsOnlineVoiceRoute -Exactly 1
            }
        }

        Context -Name 'When the voice route already exists and IS in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity              = 'Test Route'
                    Description           = 'My Test Route'
                    NumberPattern         = '^\+1(425|206)(\d{7})'
                    OnlinePstnGatewayList = @('Sbc1.litware.com', 'Sbc2.litware.com')
                    OnlinePstnUsages      = @('Local', 'Long Distance')
                    Priority              = 1
                    Ensure                = 'Present'
                    Credential            = $Credential
                }

                Mock -CommandName Get-CsOnlineVoiceRoute -MockWith {
                    return @{
                        Identity              = 'Test Route'
                        Description           = 'My Test Route'
                        NumberPattern         = '^\+1(425|206)(\d{7})'
                        OnlinePstnGatewayList = @('Sbc1.litware.com', 'Sbc2.litware.com')
                        OnlinePstnUsages      = @('Local', 'Long Distance')
                        Priority              = 1
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'When the voice route already exists but it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity   = 'Test Route'
                    Ensure     = 'Absent'
                    Credential = $Credential
                }

                Mock -CommandName Get-CsOnlineVoiceRoute -MockWith {
                    return @{
                        Identity              = 'Test Route'
                        Description           = 'My Test Route'
                        NumberPattern         = '^\+1(425|206)(\d{7})'
                        OnlinePstnGatewayList = @('Sbc1.litware.com', 'Sbc2.litware.com')
                        OnlinePstnUsages      = @('Local', 'Long Distance')
                        Priority              = 1
                    }
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the voice route from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-CsOnlineVoiceRoute -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-CsOnlineVoiceRoute -MockWith {
                    return @{
                        Identity              = 'Test Route'
                        Description           = 'My Test Route'
                        NumberPattern         = '^\+1(425|206)(\d{7})'
                        OnlinePstnGatewayList = @('Sbc1.litware.com', 'Sbc2.litware.com')
                        OnlinePstnUsages      = @('Local', 'Long Distance')
                        Priority              = 1
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
