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
    -DscResource "SPOSharingSettings" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
            $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }
        }

        # Test contexts
        Context -Name "SPOSharing settings are not configured" -Fixture {
            BeforeAll {
                $testParams = @{
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
                    SharingAllowedDomainList                   = @("contoso.com")
                    SharingBlockedDomainList                   = @("contoso.com")
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

                Mock -CommandName Set-PnPTenant -MockWith {
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
                        SharingAllowedDomainList                   = @("contoso.com")
                        SharingBlockedDomainList                   = @("contoso.com")
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

                Mock -CommandName Get-PnPTenant -MockWith {
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
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Sets the tenant sharing settings in Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName Get-PnPTenant -MockWith {
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
                        SharingAllowedDomainList                   = @("contoso.com")
                        SharingBlockedDomainList                   = @("contoso.com")
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
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }#inmodulescope
}#describe

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
