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
    -DscResource 'TeamsCallQueue' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-GUID).ToString() -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Set-CsCallQueue -MockWith {
            }

            Mock -CommandName New-CsCallQueue -MockWith {
            }

            Mock -CommandName Remove-CsCallQueue -MockWith {
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
        Context -Name 'The TeamsCallQueue should exist but it DOES NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    AgentAlertTime                             = 114;
                    AllowOptOut                                = $True;
                    AuthorizedUsers                            = @("9abce74d-d108-475f-a2cb-bbb82f484982");
                    ChannelId                                  = "19:Y6MG7XdME2Cf9IRmU8PUXNfA1OtqmjyBgCmCGBN2tzY1@thread.tacv2";
                    ConferenceMode                             = $True;
                    DistributionLists                          = @("36c88f29-faba-4f4a-89a7-e5af29e7095e");
                    EnableOverflowSharedVoicemailTranscription = $False;
                    EnableTimeoutSharedVoicemailTranscription  = $False;
                    LanguageId                                 = "fr-CA";
                    Name                                       = "TestQueue";
                    OverflowAction                             = "Forward";
                    OverflowActionTarget                       = "9abce74d-d108-475f-a2cb-bbb82f484982";
                    OverflowThreshold                          = 50;
                    PresenceBasedRouting                       = $True;
                    RoutingMethod                              = "RoundRobin";
                    TimeoutAction                              = "Forward";
                    TimeoutActionTarget                        = "9abce74d-d108-475f-a2cb-bbb82f484982";
                    TimeoutThreshold                           = 1200;
                    UseDefaultMusicOnHold                      = $False;
                    Ensure                                     = 'Present'
                    Credential                                 = $Credential
                }

                Mock -CommandName Get-CsCallQueue -MockWith {
                    return $null
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Create the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-CsCallQueue -Exactly 1
            }
        }

        Context -Name 'The TeamsCallQueue exists but it should not' -Fixture {
            BeforeAll {
                $testParams = @{
                    AgentAlertTime                             = 114;
                    AllowOptOut                                = $True;
                    AuthorizedUsers                            = @("9abce74d-d108-475f-a2cb-bbb82f484982");
                    ChannelId                                  = "19:Y6MG7XdME2Cf9IRmU8PUXNfA1OtqmjyBgCmCGBN2tzY1@thread.tacv2";
                    ConferenceMode                             = $True;
                    DistributionLists                          = @("36c88f29-faba-4f4a-89a7-e5af29e7095e");
                    EnableOverflowSharedVoicemailTranscription = $False;
                    EnableTimeoutSharedVoicemailTranscription  = $False;
                    LanguageId                                 = "fr-CA";
                    Name                                       = "TestQueue";
                    OverflowAction                             = "Forward";
                    OverflowActionTarget                       = "9abce74d-d108-475f-a2cb-bbb82f484982";
                    OverflowThreshold                          = 50;
                    PresenceBasedRouting                       = $True;
                    RoutingMethod                              = "RoundRobin";
                    TimeoutAction                              = "Forward";
                    TimeoutActionTarget                        = "9abce74d-d108-475f-a2cb-bbb82f484982";
                    TimeoutThreshold                           = 1200;
                    UseDefaultMusicOnHold                      = $False;
                    Ensure                                     = 'Absent'
                    Credential                                 = $Credential
                }

                Mock -CommandName Get-CsCallQueue -MockWith {
                    return @{
                        Id                                         = "12345-12345-12345-12345-12345"
                        AgentAlertTime                             = 114;
                        AllowOptOut                                = $True;
                        AuthorizedUsers                            = @("9abce74d-d108-475f-a2cb-bbb82f484982");
                        ChannelId                                  = "19:Y6MG7XdME2Cf9IRmU8PUXNfA1OtqmjyBgCmCGBN2tzY1@thread.tacv2";
                        ConferenceMode                             = $True;
                        DistributionLists                          = @("36c88f29-faba-4f4a-89a7-e5af29e7095e");
                        EnableOverflowSharedVoicemailTranscription = $False;
                        EnableTimeoutSharedVoicemailTranscription  = $False;
                        LanguageId                                 = "fr-CA";
                        Name                                       = "TestQueue";
                        OverflowAction                             = "Forward";
                        OverflowActionTarget                       = @{Id="9abce74d-d108-475f-a2cb-bbb82f484982"}
                        OverflowThreshold                          = 50;
                        PresenceBasedRouting                       = $True;
                        RoutingMethod                              = "RoundRobin";
                        TimeoutAction                              = "Forward";
                        TimeoutActionTarget                        = @{Id = "9abce74d-d108-475f-a2cb-bbb82f484982"}
                        TimeoutThreshold                           = 1200;
                        UseDefaultMusicOnHold                      = $False;
                        Ensure                                     = 'Present'
                        Credential                                 = $Credential
                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the queue from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-CsCallQueue -Exactly 1
            }
        }

        Context -Name 'The TeamsCallQueue is already in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    AgentAlertTime                             = 114;
                    AllowOptOut                                = $True;
                    AuthorizedUsers                            = @("9abce74d-d108-475f-a2cb-bbb82f484982");
                    ChannelId                                  = "19:Y6MG7XdME2Cf9IRmU8PUXNfA1OtqmjyBgCmCGBN2tzY1@thread.tacv2";
                    ConferenceMode                             = $True;
                    DistributionLists                          = @("36c88f29-faba-4f4a-89a7-e5af29e7095e");
                    EnableOverflowSharedVoicemailTranscription = $False;
                    EnableTimeoutSharedVoicemailTranscription  = $False;
                    LanguageId                                 = "fr-CA";
                    Name                                       = "TestQueue";
                    OverflowAction                             = "Forward";
                    OverflowActionTarget                       = "9abce74d-d108-475f-a2cb-bbb82f484982";
                    OverflowThreshold                          = 50;
                    PresenceBasedRouting                       = $True;
                    RoutingMethod                              = "RoundRobin";
                    TimeoutAction                              = "Forward";
                    TimeoutActionTarget                        = "9abce74d-d108-475f-a2cb-bbb82f484982";
                    TimeoutThreshold                           = 1200;
                    UseDefaultMusicOnHold                      = $False;
                    Ensure                                     = 'Present'
                    Credential                                 = $Credential
                }

                Mock -CommandName Get-CsCallQueue -MockWith {
                    return @{
                        Id                                         = "12345-12345-12345-12345-12345"
                        AgentAlertTime                             = 114;
                        AllowOptOut                                = $True;
                        AuthorizedUsers                            = @("9abce74d-d108-475f-a2cb-bbb82f484982");
                        ChannelId                                  = "19:Y6MG7XdME2Cf9IRmU8PUXNfA1OtqmjyBgCmCGBN2tzY1@thread.tacv2";
                        ConferenceMode                             = $True;
                        DistributionLists                          = @("36c88f29-faba-4f4a-89a7-e5af29e7095e");
                        EnableOverflowSharedVoicemailTranscription = $False;
                        EnableTimeoutSharedVoicemailTranscription  = $False;
                        LanguageId                                 = "fr-CA";
                        Name                                       = "TestQueue";
                        OverflowAction                             = "Forward";
                        OverflowActionTarget                       = @{Id="9abce74d-d108-475f-a2cb-bbb82f484982"}
                        OverflowThreshold                          = 50;
                        PresenceBasedRouting                       = $True;
                        RoutingMethod                              = "RoundRobin";
                        TimeoutAction                              = "Forward";
                        TimeoutActionTarget                        = @{Id = "9abce74d-d108-475f-a2cb-bbb82f484982"}
                        TimeoutThreshold                           = 1200;
                        UseDefaultMusicOnHold                      = $False;
                        Ensure                                     = 'Present'
                        Credential                                 = $Credential
                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'The TeamsCallQueue is NOT in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    AgentAlertTime                             = 114;
                    AllowOptOut                                = $True;
                    AuthorizedUsers                            = @("9abce74d-d108-475f-a2cb-bbb82f484982");
                    ChannelId                                  = "19:Y6MG7XdME2Cf9IRmU8PUXNfA1OtqmjyBgCmCGBN2tzY1@thread.tacv2";
                    ConferenceMode                             = $True;
                    DistributionLists                          = @("36c88f29-faba-4f4a-89a7-e5af29e7095e");
                    EnableOverflowSharedVoicemailTranscription = $False;
                    EnableTimeoutSharedVoicemailTranscription  = $False;
                    LanguageId                                 = "fr-CA";
                    Name                                       = "TestQueue";
                    OverflowAction                             = "Forward";
                    OverflowActionTarget                       = "9abce74d-d108-475f-a2cb-bbb82f484982";
                    OverflowThreshold                          = 50;
                    PresenceBasedRouting                       = $True;
                    RoutingMethod                              = "RoundRobin";
                    TimeoutAction                              = "Forward";
                    TimeoutActionTarget                        = "9abce74d-d108-475f-a2cb-bbb82f484982";
                    TimeoutThreshold                           = 1200;
                    UseDefaultMusicOnHold                      = $False;
                    Ensure                                     = 'Present'
                    Credential                                 = $Credential
                }

                Mock -CommandName Get-CsCallQueue -MockWith {
                    return @{
                        Id                                         = "12345-12345-12345-12345-12345"
                        AgentAlertTime                             = 120; #Drift
                        AllowOptOut                                = $True;
                        AuthorizedUsers                            = @("9abce74d-d108-475f-a2cb-bbb82f484982");
                        ChannelId                                  = "19:Y6MG7XdME2Cf9IRmU8PUXNfA1OtqmjyBgCmCGBN2tzY1@thread.tacv2";
                        ConferenceMode                             = $True;
                        DistributionLists                          = @("36c88f29-faba-4f4a-89a7-e5af29e7095e");
                        EnableOverflowSharedVoicemailTranscription = $False;
                        EnableTimeoutSharedVoicemailTranscription  = $False;
                        LanguageId                                 = "fr-CA";
                        Name                                       = "TestQueue";
                        OverflowAction                             = "Forward";
                        OverflowActionTarget                       = @{Id="9abce74d-d108-475f-a2cb-bbb82f484982"}
                        OverflowThreshold                          = 50;
                        PresenceBasedRouting                       = $True;
                        RoutingMethod                              = "RoundRobin";
                        TimeoutAction                              = "Forward";
                        TimeoutActionTarget                        = @{Id = "9abce74d-d108-475f-a2cb-bbb82f484982"}
                        TimeoutThreshold                           = 1200;
                        UseDefaultMusicOnHold                      = $False;
                        Ensure                                     = 'Present'
                        Credential                                 = $Credential
                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Update the queue from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-CsCallQueue -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-CsCallQueue -MockWith {
                    return @{
                        Id                                         = "12345-12345-12345-12345-12345"
                        AgentAlertTime                             = 120; #Drift
                        AllowOptOut                                = $True;
                        AuthorizedUsers                            = @("9abce74d-d108-475f-a2cb-bbb82f484982");
                        ChannelId                                  = "19:Y6MG7XdME2Cf9IRmU8PUXNfA1OtqmjyBgCmCGBN2tzY1@thread.tacv2";
                        ConferenceMode                             = $True;
                        DistributionLists                          = @("36c88f29-faba-4f4a-89a7-e5af29e7095e");
                        EnableOverflowSharedVoicemailTranscription = $False;
                        EnableTimeoutSharedVoicemailTranscription  = $False;
                        LanguageId                                 = "fr-CA";
                        Name                                       = "TestQueue";
                        OverflowAction                             = "Forward";
                        OverflowActionTarget                       = @{Id="9abce74d-d108-475f-a2cb-bbb82f484982"}
                        OverflowThreshold                          = 50;
                        PresenceBasedRouting                       = $True;
                        RoutingMethod                              = "RoundRobin";
                        TimeoutAction                              = "Forward";
                        TimeoutActionTarget                        = @{Id = "9abce74d-d108-475f-a2cb-bbb82f484982"}
                        TimeoutThreshold                           = 1200;
                        UseDefaultMusicOnHold                      = $False;
                        Ensure                                     = 'Present'
                        Credential                                 = $Credential
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
