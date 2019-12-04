[CmdletBinding()]
param(
    [Parameter()]
    [string]
    $CmdletModule = (Join-Path -Path $PSScriptRoot `
            -ChildPath "..\Stubs\Office365.psm1" `
            -Resolve)
)

Import-Module -Name (Join-Path -Path $PSScriptRoot `
        -ChildPath "..\UnitTestHelper.psm1" `
        -Resolve)

$Global:DscHelper = New-O365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "TeamsMessagginPolicy"

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "Pass@word1)" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-MSCloudLogin -MockWith {
        }

        Mock -CommandName New-CsTeamsMessagingPolicy -MockWith {
        }

        Mock -CommandName Set-CsTeamsMessagingPolicy -MockWith {
        }

        Mock -CommandName Remove-CsTeamsMessagingPolicy -MockWith {
        }

        # Test contexts
        Context -Name "When Messaging Policy doesn't exist but should" -Fixture {
            $testParams = @{
                Identity                      = 'SamplePolicy'
                Description                   = "My sample policy"
                ReadReceiptsEnabledType       = "UserPreference"
                AllowImmersiveReader          = $True
                AllowGiphy                    = $True
                AllowMemes                    = $False
                AudioMessageEnabledType       = "ChatsOnly"
                AllowOwnerDeleteMessage       = $False
                ChannelsInChatListEnabledType = "EnabledUserOverride"
                GlobalAdminAccount            = $GlobalAdminAccount
                Ensure                        = "Present"
            }

            Mock -CommandName Get-CsTeamsMessagingPolicy -MockWith {
                return $null
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be 'Absent'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should create the policy in the Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled -CommandName New-CsTeamsMessagingPolicy -Exactly 1
            }
        }

        Context -Name "Message Policy exists but is not in the Desired State" -Fixture {
            $testParams = @{
                Identity                      = 'SamplePolicy'
                Description                   = "My sample policy"
                ReadReceiptsEnabledType       = "UserPreference"
                AllowImmersiveReader          = $True
                AllowGiphy                    = $True
                AllowMemes                    = $False
                AudioMessageEnabledType       = "ChatsOnly"
                AllowOwnerDeleteMessage       = $False
                ChannelsInChatListEnabledType = "EnabledUserOverride"
                GlobalAdminAccount            = $GlobalAdminAccount
                Ensure                        = "Present"
            }

            Mock -CommandName Get-CsTeamsMessagingPolicy -MockWith {
                return @{
                    Identity                      = 'SamplePolicy'
                    Description                   = "My sample policy"
                    ReadReceiptsEnabledType       = "UserPreference"
                    AllowImmersiveReader          = $False
                    AllowGiphy                    = $False
                    AllowMemes                    = $False
                    AudioMessageEnabledType       = "ChatsOnly"
                    AllowOwnerDeleteMessage       = $False
                    ChannelsInChatListEnabledType = "EnabledUserOverride"
                    GlobalAdminAccount            = $GlobalAdminAccount
                    Ensure                        = "Present"
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be 'Present'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should update the settings from the Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled -CommandName Set-CsTeamsMessagingPolicy -Exactly 1
            }
        }

        Context -Name "Message Policy exists and is already in the Desired State" -Fixture {
            $testParams = @{
                Identity                      = 'SamplePolicy'
                Description                   = "My sample policy"
                ReadReceiptsEnabledType       = "UserPreference"
                AllowImmersiveReader          = $True
                AllowGiphy                    = $True
                AllowMemes                    = $False
                AudioMessageEnabledType       = "ChatsOnly"
                AllowOwnerDeleteMessage       = $False
                ChannelsInChatListEnabledType = "EnabledUserOverride"
                GlobalAdminAccount            = $GlobalAdminAccount
                Ensure                        = "Present"
            }

            Mock -CommandName Get-CsTeamsMessagingPolicy -MockWith {
                return @{
                    Identity                      = 'SamplePolicy'
                    Description                   = "My sample policy"
                    ReadReceiptsEnabledType       = "UserPreference"
                    AllowImmersiveReader          = $True
                    AllowGiphy                    = $True
                    AllowMemes                    = $False
                    AudioMessageEnabledType       = "ChatsOnly"
                    AllowOwnerDeleteMessage       = $False
                    ChannelsInChatListEnabledType = "EnabledUserOverride"
                    GlobalAdminAccount            = $GlobalAdminAccount
                    Ensure                        = "Present"
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be 'Present'
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should Be $true
            }
        }

        Context -Name "Policy exists but it should not" -Fixture {
            $testParams = @{
                Identity                      = 'SamplePolicy'
                Description                   = "My sample policy"
                ReadReceiptsEnabledType       = "UserPreference"
                AllowImmersiveReader          = $True
                AllowGiphy                    = $True
                AllowMemes                    = $False
                AudioMessageEnabledType       = "ChatsOnly"
                AllowOwnerDeleteMessage       = $False
                ChannelsInChatListEnabledType = "EnabledUserOverride"
                GlobalAdminAccount            = $GlobalAdminAccount
                Ensure                        = "Absent"
            }

            Mock -CommandName Get-CsTeamsMessagingPolicy -MockWith {
                return @{
                    Identity                      = 'SamplePolicy'
                    Description                   = "My sample policy"
                    ReadReceiptsEnabledType       = "UserPreference"
                    AllowImmersiveReader          = $True
                    AllowGiphy                    = $True
                    AllowMemes                    = $False
                    AudioMessageEnabledType       = "ChatsOnly"
                    AllowOwnerDeleteMessage       = $False
                    ChannelsInChatListEnabledType = "EnabledUserOverride"
                    GlobalAdminAccount            = $GlobalAdminAccount
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be 'Present'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should remove the policy from the Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled -CommandName Remove-CsTeamsMessagingPolicy -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-CsTeamsMessagingPolicy -MockWith {
                return @{
                    Identity                      = 'SamplePolicy'
                    Description                   = "My sample policy"
                    ReadReceiptsEnabledType       = "UserPreference"
                    AllowImmersiveReader          = $True
                    AllowGiphy                    = $True
                    AllowMemes                    = $False
                    AudioMessageEnabledType       = "ChatsOnly"
                    AllowOwnerDeleteMessage       = $False
                    ChannelsInChatListEnabledType = "EnabledUserOverride"
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
