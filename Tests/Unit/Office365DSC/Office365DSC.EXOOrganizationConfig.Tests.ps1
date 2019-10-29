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
                                              -DscResource "EXOOrganizationConfig"
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Close-SessionsAndReturnError -MockWith {

        }

        Mock -CommandName Test-MSCloudLogin -MockWith {

        }

        Mock -CommandName Get-PSSession -MockWith {

        }

        Mock -CommandName Remove-PSSession -MockWith {

        }

        Mock -CommandName Set-OrganizationConfig -MockWith {

        }

        # Test contexts
        Context -Name "Values are already in the desired state" -Fixture {
            $testParams = @{
                IsSingleInstance                                          = "Yes";
                DefaultPublicFolderProhibitPostQuota                      = "2 GB (2,147,483,648 bytes)";
                VisibleMeetingUpdateProperties                            = "Location,AllProperties:15";
                DefaultPublicFolderIssueWarningQuota                      = "1.7 GB (1,825,361,920 bytes)";
                GlobalAdminAccount                                        = $GlobalAdminAccount;
                ConnectorsEnabledForYammer                                = $True;
                DefaultPublicFolderMaxItemSize                            = "Unlimited";
                MailTipsLargeAudienceThreshold                            = 25;
                PublicFoldersEnabled                                      = "Local";
                WebPushNotificationsDisabled                              = $False;
                MailTipsGroupMetricsEnabled                               = $True;
                DefaultPublicFolderMovedItemRetention                     = "7.00:00:00";
                DefaultPublicFolderDeletedItemRetention                   = "30.00:00:00";
                ByteEncoderTypeFor7BitCharsets                            = 0;
                ActivityBasedAuthenticationTimeoutInterval                = "06:00:00";
                DefaultGroupAccessType                                    = "Private";
            }

            Mock -CommandName Get-OrganizationConfig -MockWith {
                return @{
                    DefaultPublicFolderProhibitPostQuota                      = "2 GB (2,147,483,648 bytes)";
                    VisibleMeetingUpdateProperties                            = "Location,AllProperties:15";
                    DefaultPublicFolderIssueWarningQuota                      = "1.7 GB (1,825,361,920 bytes)";
                    ConnectorsEnabledForYammer                                = $True;
                    DefaultPublicFolderMaxItemSize                            = "Unlimited";
                    MailTipsLargeAudienceThreshold                            = 25;
                    PublicFoldersEnabled                                      = "Local";
                    WebPushNotificationsDisabled                              = $False;
                    MailTipsGroupMetricsEnabled                               = $True;
                    DefaultPublicFolderMovedItemRetention                     = "7.00:00:00";
                    DefaultPublicFolderDeletedItemRetention                   = "30.00:00:00";
                    ByteEncoderTypeFor7BitCharsets                            = 0;
                    ActivityBasedAuthenticationTimeoutInterval                = "06:00:00";
                    DefaultGroupAccessType                                    = "Private";
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should Be $true
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled -CommandName 'Set-OrganizationConfig' -Exactly 1
            }

            It "Should return Values from the Get method" {
                Get-TargetResource @testParams
                Assert-MockCalled -CommandName "Get-OrganizationConfig"
            }
        }

        Context -Name "Values are not in the desired state" -Fixture {
            $testParams = @{
                IsSingleInstance                                          = "Yes";
                DefaultPublicFolderProhibitPostQuota                      = "2 GB (2,147,483,648 bytes)";
                VisibleMeetingUpdateProperties                            = "Location,AllProperties:15";
                DefaultPublicFolderIssueWarningQuota                      = "1.7 GB (1,825,361,920 bytes)";
                GlobalAdminAccount                                        = $GlobalAdminAccount;
                ConnectorsEnabledForYammer                                = $False;
                DefaultPublicFolderMaxItemSize                            = "Unlimited";
                MailTipsLargeAudienceThreshold                            = 25;
                PublicFoldersEnabled                                      = "Local";
                WebPushNotificationsDisabled                              = $False;
                MailTipsGroupMetricsEnabled                               = $False;
                DefaultPublicFolderMovedItemRetention                     = "7.00:00:00";
                DefaultPublicFolderDeletedItemRetention                   = "30.00:00:00";
                ByteEncoderTypeFor7BitCharsets                            = 0;
                ActivityBasedAuthenticationTimeoutInterval                = "06:00:00";
                DefaultGroupAccessType                                    = "Public";
            }

            Mock -CommandName Get-OrganizationConfig -MockWith {
                return @{
                    DefaultPublicFolderProhibitPostQuota                      = "2 GB (2,147,483,648 bytes)";
                    VisibleMeetingUpdateProperties                            = "Location,AllProperties:15";
                    DefaultPublicFolderIssueWarningQuota                      = "1.7 GB (1,825,361,920 bytes)";
                    ConnectorsEnabledForYammer                                = $True;
                    DefaultPublicFolderMaxItemSize                            = "Unlimited";
                    MailTipsLargeAudienceThreshold                            = 25;
                    PublicFoldersEnabled                                      = "Local";
                    WebPushNotificationsDisabled                              = $False;
                    MailTipsGroupMetricsEnabled                               = $True;
                    DefaultPublicFolderMovedItemRetention                     = "7.00:00:00";
                    DefaultPublicFolderDeletedItemRetention                   = "30.00:00:00";
                    ByteEncoderTypeFor7BitCharsets                            = 0;
                    ActivityBasedAuthenticationTimeoutInterval                = "06:00:00";
                    DefaultGroupAccessType                                    = "Private";
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled -CommandName 'Set-OrganizationConfig' -Exactly 1
            }

            It "Should return Values from the Get method" {
                Get-TargetResource @testParams
                Assert-MockCalled -CommandName "Get-OrganizationConfig"
            }
        }

        Context -Name "Invalid properties are passed" -Fixture {
            $testParams = @{
                IsSingleInstance                                          = "Yes";
                DefaultPublicFolderProhibitPostQuota                      = "2 GB (2,147,483,648 bytes)";
                VisibleMeetingUpdateProperties                            = "Location,AllProperties:15";
                DefaultPublicFolderIssueWarningQuota                      = "1.7 GB (1,825,361,920 bytes)";
                GlobalAdminAccount                                        = $GlobalAdminAccount;
                ConnectorsEnabledForYammer                                = $False;
                DefaultPublicFolderMaxItemSize                            = "Unlimited";
                MailTipsLargeAudienceThreshold                            = 25;
                PublicFoldersEnabled                                      = "Local";
                WebPushNotificationsDisabled                              = $False;
                MailTipsGroupMetricsEnabled                               = $False;
                DefaultPublicFolderMovedItemRetention                     = "7.00:00:00";
                DefaultPublicFolderDeletedItemRetention                   = "30.00:00:00";
                ByteEncoderTypeFor7BitCharsets                            = 0;
                ActivityBasedAuthenticationTimeoutInterval                = "06:00:00";
                DefaultGroupAccessType                                    = "Public";
                EWSAllowList                                              = @("111");
                EWSBlockList                                              = @("222");
            }

            It "Should call the Set method" {
                {Set-TargetResource @testParams} | Should Throw "You can't specify both EWSAllowList and EWSBlockList properties."
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-OrganizationConfig -MockWith {
                return @{
                    DefaultPublicFolderProhibitPostQuota                      = "2 GB (2,147,483,648 bytes)";
                    VisibleMeetingUpdateProperties                            = "Location,AllProperties:15";
                    DefaultPublicFolderIssueWarningQuota                      = "1.7 GB (1,825,361,920 bytes)";
                    ConnectorsEnabledForYammer                                = $True;
                    DefaultPublicFolderMaxItemSize                            = "Unlimited";
                    MailTipsLargeAudienceThreshold                            = 25;
                    PublicFoldersEnabled                                      = "Local";
                    WebPushNotificationsDisabled                              = $False;
                    MailTipsGroupMetricsEnabled                               = $True;
                    DefaultPublicFolderMovedItemRetention                     = "7.00:00:00";
                    DefaultPublicFolderDeletedItemRetention                   = "30.00:00:00";
                    ByteEncoderTypeFor7BitCharsets                            = 0;
                    ActivityBasedAuthenticationTimeoutInterval                = "06:00:00";
                    DefaultGroupAccessType                                    = "Private";
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
