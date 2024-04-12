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
    -DscResource 'TeamsGuestMeetingConfiguration' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'Pass@word1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            $Global:PartialExportFileName = 'c:\TestPath'


            Mock -CommandName Save-M365DSCPartialExport -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Get-CsTeamsGuestMeetingConfiguration -MockWith {
                return @{
                    Identity                = 'Global'
                    AllowIPVideo            = $true
                    LiveCaptionsEnabledType = 'Disabled'
                    ScreenSharingMode       = 'Disabled'
                    AllowMeetNow            = $false
                    AllowTranscription      = $false
                    Credential              = $Credential
                }
            }

            Mock -CommandName Set-CsTeamsGuestMeetingConfiguration -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'When settings are correctly set' -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity                = 'Global'
                    AllowIPVideo            = $true
                    LiveCaptionsEnabledType = 'Disabled'
                    ScreenSharingMode       = 'Disabled'
                    AllowMeetNow            = $false
                    AllowTranscription      = $false
                    Credential              = $Credential
                }
            }

            It 'Should return true for the AllowIPVideo property from the Get method' {
                (Get-TargetResource @testParams).AllowIPVideo | Should -Be $true
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Updates the settings in the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'When settings are NOT correctly set' -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity                = 'Global'
                    AllowIPVideo            = $false # Drifted
                    LiveCaptionsEnabledType = 'Disabled'
                    ScreenSharingMode       = 'Disabled'
                    AllowMeetNow            = $false
                    Credential              = $Credential
                }
            }

            It 'Should return true for the AllowIPVideo property from the Get method' {
                (Get-TargetResource @testParams).AllowIPVideo | Should -Be $true
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Updates the settings in the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-CsTeamsGuestMeetingConfiguration -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
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
