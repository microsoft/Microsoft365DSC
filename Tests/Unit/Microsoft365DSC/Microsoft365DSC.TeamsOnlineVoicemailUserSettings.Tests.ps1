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
    -DscResource 'TeamsOnlineVoicemailUserSettings' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'Pass@word1)' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)
            
            $Global:PartialExportFileName = 'c:\TestPath'
            
            Mock -CommandName Save-M365DSCPartialExport -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Set-CsOnlineVoicemailUserSettings -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name 'When no instances exist' -Fixture {
            BeforeAll {
                $testParams = @{
                    CallAnswerRule                           = 'RegularVoicemail'
                    Identity                                 = 'JohnSmith@Contoso.com'
                    OofGreetingEnabled                       = $False
                    OofGreetingFollowAutomaticRepliesEnabled = $False
                    OofGreetingFollowCalendarEnabled         = $False
                    PromptLanguage                           = 'en-US'
                    ShareData                                = $False
                    VoicemailEnabled                         = $True
                    Ensure                                   = 'Present'
                    Credential                               = $Credential
                }

                Mock -CommandName Get-CsOnlineVoicemailUserSettings -MockWith {
                    return $null
                }
            }

            It 'Should return absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should assign settings in the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-CsOnlineVoicemailUserSettings -Exactly 1
            }
        }

        Context -Name 'User exists but is not in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    CallAnswerRule                           = 'RegularVoicemail'
                    Identity                                 = 'JohnSmith@Contoso.com'
                    OofGreetingEnabled                       = $False
                    OofGreetingFollowAutomaticRepliesEnabled = $False
                    OofGreetingFollowCalendarEnabled         = $False
                    PromptLanguage                           = 'en-US'
                    ShareData                                = $False
                    VoicemailEnabled                         = $True
                    Ensure                                   = 'Present'
                    Credential                               = $Credential
                }

                Mock -CommandName Get-CsOnlineVoicemailUserSettings -MockWith {
                    return @{
                        CallAnswerRule                           = 'RegularVoicemail'
                        Identity                                 = 'JohnSmith@Contoso.com'
                        OofGreetingEnabled                       = $False
                        OofGreetingFollowAutomaticRepliesEnabled = $False
                        OofGreetingFollowCalendarEnabled         = $True; #Drift
                        PromptLanguage                           = 'en-US'
                        ShareData                                = $False
                        VoicemailEnabled                         = $True
                    }
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update the settings from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-CsOnlineVoicemailUserSettings -Exactly 1
            }
        }

        Context -Name 'Instance exists and is already in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    CallAnswerRule                           = 'RegularVoicemail'
                    Identity                                 = 'JohnSmith@Contoso.com'
                    OofGreetingEnabled                       = $False
                    OofGreetingFollowAutomaticRepliesEnabled = $False
                    OofGreetingFollowCalendarEnabled         = $False
                    PromptLanguage                           = 'en-US'
                    ShareData                                = $False
                    VoicemailEnabled                         = $True
                    Ensure                                   = 'Present'
                    Credential                               = $Credential
                }

                Mock -CommandName Get-CsOnlineVoicemailUserSettings -MockWith {
                    return @{
                        CallAnswerRule                           = 'RegularVoicemail'
                        Identity                                 = 'JohnSmith@Contoso.com'
                        OofGreetingEnabled                       = $False
                        OofGreetingFollowAutomaticRepliesEnabled = $False
                        OofGreetingFollowCalendarEnabled         = $False
                        PromptLanguage                           = 'en-US'
                        ShareData                                = $False
                        VoicemailEnabled                         = $True
                    }
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgUser -MockWith {
                    return @(
                        @{
                            UserPrincipalName = 'JohnSmith@Contoso.com'
                        }
                    )
                }

                Mock -CommandName Get-CsOnlineVoicemailUserSettings -MockWith {
                    return @{
                        CallAnswerRule                           = 'RegularVoicemail'
                        Identity                                 = 'JohnSmith@Contoso.com'
                        OofGreetingEnabled                       = $False
                        OofGreetingFollowAutomaticRepliesEnabled = $False
                        OofGreetingFollowCalendarEnabled         = $False
                        PromptLanguage                           = 'en-US'
                        ShareData                                = $False
                        VoicemailEnabled                         = $True
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
