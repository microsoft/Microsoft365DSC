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
    -DscResource "SPOSharingSettings"

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-SPOServiceConnection -MockWith {

        }

        # Test contexts 
        Context -Name "SPOSharing settings are not configured" -Fixture {
            $testParams = @{
                CentralAdminUrl                            = "https://o365dsc1-admin.sharepoint.com"
                GlobalAdminAccount                         = $GlobalAdminAccount
                IsSingleInstance                           = "Yes"
                SharingCapability                          = 'ExternalUserSharingOnly'
                ShowEveryoneClaim                          = $false
                ShowAllUsersClaim                          = $false
                ShowEveryoneExceptExternalUsersClaim       = $true
                ProvisionSharedWithEveryoneFolder          = $false
                EnableGuestSignInAcceleration              = $false
                BccExternalSharingInvitations              = $false
                BccExternalSharingInvitationsList          = ""
                RequireAnonymousLinksExpireInDays          = 730
                SharingAllowedDomainList                   = "contoso.com"
                SharingBlockedDomainList                   = "contoso.com"
                SharingDomainRestrictionMode               = "None"
                DefaultSharingLinkType                     = "AnonymousAccess"
                PreventExternalUsersFromResharing          = $false
                ShowPeoplePickerSuggestionsForGuestUsers   = $false
                FileAnonymousLinkType                      = "Edit"
                FolderAnonymousLinkType                    = "Edit"
                NotifyOwnersWhenItemsReshared              = $true
                DefaultLinkPermission                      = "View"
                RequireAcceptingAccountMatchInvitedAccount = $false
            }

            Mock -CommandName Set-SPOTenant -MockWith { 
                return @{
                    SharingCapability                          = 'ExternalUserSharingOnly'
                    ShowEveryoneClaim                          = $false
                    ShowAllUsersClaim                          = $false
                    ShowEveryoneExceptExternalUsersClaim       = $true
                    ProvisionSharedWithEveryoneFolder          = $false
                    EnableGuestSignInAcceleration              = $false
                    BccExternalSharingInvitations              = $false
                    BccExternalSharingInvitationsList          = ""
                    RequireAnonymousLinksExpireInDays          = 730
                    SharingAllowedDomainList                   = "contoso.com"
                    SharingBlockedDomainList                   = "contoso.com"
                    SharingDomainRestrictionMode               = "None"
                    DefaultSharingLinkType                     = "AnonymousAccess"
                    PreventExternalUsersFromResharing          = $false
                    ShowPeoplePickerSuggestionsForGuestUsers   = $false
                    FileAnonymousLinkType                      = "Edit"
                    FolderAnonymousLinkType                    = "Edit"
                    NotifyOwnersWhenItemsReshared              = $true
                    DefaultLinkPermission                      = "View"
                    RequireAcceptingAccountMatchInvitedAccount = $false
                }
            }

            Mock -CommandName Get-SPOTenant -MockWith { 
                return @{
                    SharingCapability                          = 'Disabled'
                    ShowEveryoneClaim                          = $false
                    ShowAllUsersClaim                          = $false
                    ShowEveryoneExceptExternalUsersClaim       = $true
                    ProvisionSharedWithEveryoneFolder          = $false
                    EnableGuestSignInAcceleration              = $false
                    BccExternalSharingInvitations              = $false
                    BccExternalSharingInvitationsList          = ""
                    RequireAnonymousLinksExpireInDays          = 730
                    SharingAllowedDomainList                   = ""
                    SharingBlockedDomainList                   = ""
                    SharingDomainRestrictionMode               = ""
                    DefaultSharingLinkType                     = "AnonymousAccess"
                    PreventExternalUsersFromResharing          = $false
                    ShowPeoplePickerSuggestionsForGuestUsers   = $false
                    FileAnonymousLinkType                      = "Edit"
                    FolderAnonymousLinkType                    = "Edit"
                    NotifyOwnersWhenItemsReshared              = $true
                    DefaultLinkPermission                      = "View"
                    RequireAcceptingAccountMatchInvitedAccount = $true
                }
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Sets the tenant sharing settings in Set method" {
                set-TargetResource @testParams
            }
        }
        
        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                CentralAdminUrl                            = "https://o365dsc1-admin.sharepoint.com"
                GlobalAdminAccount                         = $GlobalAdminAccount
                IsSingleInstance                           = "Yes"
                SharingCapability                          = 'ExternalUserSharingOnly'
                ShowEveryoneClaim                          = $false
                ShowAllUsersClaim                          = $false
                ShowEveryoneExceptExternalUsersClaim       = $true
                ProvisionSharedWithEveryoneFolder          = $false
                EnableGuestSignInAcceleration              = $false
                BccExternalSharingInvitations              = $false
                BccExternalSharingInvitationsList          = ""
                RequireAnonymousLinksExpireInDays          = 730
                SharingAllowedDomainList                   = "contoso.com"
                SharingBlockedDomainList                   = "contoso.com"
                SharingDomainRestrictionMode               = "None"
                DefaultSharingLinkType                     = "AnonymousAccess"
                PreventExternalUsersFromResharing          = $false
                ShowPeoplePickerSuggestionsForGuestUsers   = $false
                FileAnonymousLinkType                      = "Edit"
                FolderAnonymousLinkType                    = "Edit"
                NotifyOwnersWhenItemsReshared              = $true
                DefaultLinkPermission                      = "View"
                RequireAcceptingAccountMatchInvitedAccount = $false
            }

            Mock -CommandName Get-SPOTenant -MockWith { 
                return @{
                    CentralAdminUrl                            = "https://o365dsc1-admin.sharepoint.com"
                    GlobalAdminAccount                         = $GlobalAdminAccount
                    SharingCapability                          = 'ExternalUserSharingOnly'
                    ShowEveryoneClaim                          = $false
                    ShowAllUsersClaim                          = $false
                    ShowEveryoneExceptExternalUsersClaim       = $true
                    ProvisionSharedWithEveryoneFolder          = $false
                    EnableGuestSignInAcceleration              = $false
                    BccExternalSharingInvitations              = $false
                    BccExternalSharingInvitationsList          = ""
                    RequireAnonymousLinksExpireInDays          = 730
                    SharingAllowedDomainList                   = "contoso.com"
                    SharingBlockedDomainList                   = "contoso.com"
                    SharingDomainRestrictionMode               = "None"
                    DefaultSharingLinkType                     = "AnonymousAccess"
                    PreventExternalUsersFromResharing          = $false
                    ShowPeoplePickerSuggestionsForGuestUsers   = $false
                    FileAnonymousLinkType                      = "Edit"
                    FolderAnonymousLinkType                    = "Edit"
                    NotifyOwnersWhenItemsReshared              = $true
                    DefaultLinkPermission                      = "View"
                    RequireAcceptingAccountMatchInvitedAccount = $false
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }#inmodulescope
}#describe

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope