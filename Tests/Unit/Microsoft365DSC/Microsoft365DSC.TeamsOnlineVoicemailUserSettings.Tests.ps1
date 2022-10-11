[CmdletBinding()]
param(
)
$M365DSCTestFolder = Join-Path -Path $PSScriptRoot `
                        -ChildPath "..\..\Unit" `
                        -Resolve
$CmdletModule = (Join-Path -Path $M365DSCTestFolder `
            -ChildPath "\Stubs\Microsoft365.psm1" `
            -Resolve)
$GenericStubPath = (Join-Path -Path $M365DSCTestFolder `
    -ChildPath "\Stubs\Generic.psm1" `
    -Resolve)
Import-Module -Name (Join-Path -Path $M365DSCTestFolder `
        -ChildPath "\UnitTestHelper.psm1" `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "TeamsOnlineVoicemailUserSettings" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString "Pass@word1)" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)


            $Global:PartialExportFileName = "c:\TestPath"
            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {
                return "FakeDSCContent"
            }
            Mock -CommandName Save-M365DSCPartialExport -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            Mock -CommandName Set-CsOnlineVoicemailUserSettings -MockWith {
            }
        }

        # Test contexts
        Context -Name "When no settings are assigned to a user" -Fixture {
            BeforeAll {
                $testParams = @{
                    CallAnswerRule                           = "RegularVoicemail";
                    Credential                               = $Credential;
                    DefaultGreetingPromptOverwrite           = "Hellow World!";
                    Ensure                                   = "Present";
                    Identity                                 = "John.Smith@contoso.com";
                    OofGreetingEnabled                       = $False;
                    OofGreetingFollowAutomaticRepliesEnabled = $False;
                    OofGreetingFollowCalendarEnabled         = $False;
                    PromptLanguage                           = "en-US";
                    ShareData                                = $False;
                    VoicemailEnabled                         = $True;
                }

                Mock -CommandName Get-CsOnlineVoicemailUserSettings -MockWith {
                    return $null
                }
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should assign settings in the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-CsOnlineVoicemailUserSettings -Exactly 1
            }
        }

        Context -Name "Settings exists but is not in the Desired State" -Fixture {
            BeforeAll {
                $testParams = @{
                    CallAnswerRule                           = "RegularVoicemail";
                    Credential                               = $Credential;
                    DefaultGreetingPromptOverwrite           = "Hellow World!";
                    Ensure                                   = "Present";
                    Identity                                 = "John.Smith@contoso.com";
                    OofGreetingEnabled                       = $False;
                    OofGreetingFollowAutomaticRepliesEnabled = $False;
                    OofGreetingFollowCalendarEnabled         = $False;
                    PromptLanguage                           = "en-US";
                    ShareData                                = $False;
                    VoicemailEnabled                         = $True;
                }

                Mock -CommandName Get-CsOnlineVoicemailUserSettings -MockWith {
                    return @{
                        CallAnswerRule                           = "RegularVoicemail";
                        DefaultGreetingPromptOverwrite           = "Hellow World!";
                        Identity                                 = "John.Smith@contoso.com";
                        OofGreetingEnabled                       = $False;
                        OofGreetingFollowAutomaticRepliesEnabled = $True; #Drift
                        OofGreetingFollowCalendarEnabled         = $False;
                        PromptLanguage                           = "en-US";
                        ShareData                                = $False;
                        VoicemailEnabled                         = $True;
                    }
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should update the settings from the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-CsOnlineVoicemailUserSettings -Exactly 1
            }
        }

        Context -Name "Settings exists and is already in the Desired State" -Fixture {
            BeforeAll {
                $testParams = @{
                    CallAnswerRule                           = "RegularVoicemail";
                    Credential                               = $Credential;
                    DefaultGreetingPromptOverwrite           = "Hellow World!";
                    Ensure                                   = "Present";
                    Identity                                 = "John.Smith@contoso.com";
                    OofGreetingEnabled                       = $False;
                    OofGreetingFollowAutomaticRepliesEnabled = $False;
                    OofGreetingFollowCalendarEnabled         = $False;
                    PromptLanguage                           = "en-US";
                    ShareData                                = $False;
                    VoicemailEnabled                         = $True;
                }

                Mock -CommandName Get-CsOnlineVoicemailUserSettings -MockWith {
                    return @{
                        CallAnswerRule                           = "RegularVoicemail";
                        DefaultGreetingPromptOverwrite           = "Hellow World!";
                        Identity                                 = "John.Smith@contoso.com";
                        OofGreetingEnabled                       = $False;
                        OofGreetingFollowAutomaticRepliesEnabled = $False;
                        OofGreetingFollowCalendarEnabled         = $False;
                        PromptLanguage                           = "en-US";
                        ShareData                                = $False;
                        VoicemailEnabled                         = $True;
                    }
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-CsOnlineVoicemailUserSettings -MockWith {
                    return @{
                        CallAnswerRule                           = "RegularVoicemail";
                        DefaultGreetingPromptOverwrite           = "Hellow World!";
                        Identity                                 = "John.Smith@contoso.com";
                        OofGreetingEnabled                       = $False;
                        OofGreetingFollowAutomaticRepliesEnabled = $False;
                        OofGreetingFollowCalendarEnabled         = $False;
                        PromptLanguage                           = "en-US";
                        ShareData                                = $False;
                        VoicemailEnabled                         = $True;
                    }
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
