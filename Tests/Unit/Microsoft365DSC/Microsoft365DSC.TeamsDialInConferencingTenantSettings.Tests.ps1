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
    -DscResource 'TeamsDialInConferencingTenantSettings' -GenericStubModule $GenericStubPath

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

            Mock -CommandName Set-CsOnlineDialInConferencingTenantSettings -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'When Settings are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowPSTNOnlyMeetingsByDefault   = $False
                    AutomaticallyMigrateUserMeetings = $True
                    AutomaticallyReplaceAcpProvider  = $False
                    AutomaticallySendEmailsToUsers   = $True
                    Credential                       = $Credential
                    EnableDialOutJoinConfirmation    = $False
                    EnableEntryExitNotifications     = $True
                    EntryExitAnnouncementsType       = 'ToneOnly'
                    IsSingleInstance                 = 'Yes'
                    MaskPstnNumbersType              = 'MaskedForExternalUsers'
                    PinLength                        = 8
                }

                Mock -CommandName Get-CsOnlineDialInConferencingTenantSettings -MockWith {
                    return @{
                        AllowPSTNOnlyMeetingsByDefault   = $False
                        AutomaticallyMigrateUserMeetings = $True
                        AutomaticallyReplaceAcpProvider  = $False
                        AutomaticallySendEmailsToUsers   = $True
                        EnableDialOutJoinConfirmation    = $False
                        EnableEntryExitNotifications     = $True
                        EntryExitAnnouncementsType       = 'ToneOnly'
                        MaskPstnNumbersType              = 'MaskedForExternalUsers'
                        PinLength                        = 8
                    }
                }
            }

            It 'Should return absent from the Get method' {
                (Get-TargetResource @testParams).IsSingleInstance | Should -Be 'Yes'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'Settings is not in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowPSTNOnlyMeetingsByDefault   = $False
                    AutomaticallyMigrateUserMeetings = $True
                    AutomaticallyReplaceAcpProvider  = $False
                    AutomaticallySendEmailsToUsers   = $True
                    Credential                       = $Credential
                    EnableDialOutJoinConfirmation    = $False
                    EnableEntryExitNotifications     = $True
                    EntryExitAnnouncementsType       = 'ToneOnly'
                    IsSingleInstance                 = 'Yes'
                    MaskPstnNumbersType              = 'MaskedForExternalUsers'
                    PinLength                        = 8
                }

                Mock -CommandName Get-CsOnlineDialInConferencingTenantSettings -MockWith {
                    return @{
                        AllowPSTNOnlyMeetingsByDefault   = $False
                        AutomaticallyMigrateUserMeetings = $False; #Drift
                        AutomaticallyReplaceAcpProvider  = $False
                        AutomaticallySendEmailsToUsers   = $True
                        EnableDialOutJoinConfirmation    = $False
                        EnableEntryExitNotifications     = $True
                        EntryExitAnnouncementsType       = 'ToneOnly'
                        MaskPstnNumbersType              = 'MaskedForExternalUsers'
                        PinLength                        = 8
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update the settings from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-CsOnlineDialInConferencingTenantSettings -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-CsOnlineDialInConferencingTenantSettings -MockWith {
                    return @{
                        AllowPSTNOnlyMeetingsByDefault   = $False
                        AutomaticallyMigrateUserMeetings = $True
                        AutomaticallyReplaceAcpProvider  = $False
                        AutomaticallySendEmailsToUsers   = $True
                        EnableDialOutJoinConfirmation    = $False
                        EnableEntryExitNotifications     = $True
                        EntryExitAnnouncementsType       = 'ToneOnly'
                        MaskPstnNumbersType              = 'MaskedForExternalUsers'
                        PinLength                        = 8
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
