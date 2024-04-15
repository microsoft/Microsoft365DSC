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
    -DscResource 'SPOSharingSettings' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'test@password1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PnPTenantSite -MockWith {
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
        Context -Name 'SPOSharing settings are not configured' -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential                                 = $Credential
                    IsSingleInstance                           = 'Yes'
                    SharingCapability                          = 'ExternalUserSharingOnly'
                    ShowEveryoneClaim                          = $false
                    ShowAllUsersClaim                          = $false
                    ShowEveryoneExceptExternalUsersClaim       = $true
                    ProvisionSharedWithEveryoneFolder          = $false
                    EnableGuestSignInAcceleration              = $false
                    BccExternalSharingInvitations              = $false
                    BccExternalSharingInvitationsList          = ''
                    RequireAnonymousLinksExpireInDays          = 730
                    SharingAllowedDomainList                   = @('contoso.com')
                    SharingBlockedDomainList                   = @('contoso.com')
                    SharingDomainRestrictionMode               = 'None'
                    DefaultSharingLinkType                     = 'AnonymousAccess'
                    PreventExternalUsersFromResharing          = $false
                    ShowPeoplePickerSuggestionsForGuestUsers   = $false
                    FileAnonymousLinkType                      = 'Edit'
                    FolderAnonymousLinkType                    = 'Edit'
                    NotifyOwnersWhenItemsReshared              = $true
                    DefaultLinkPermission                      = 'View'
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
                        BccExternalSharingInvitationsList          = ''
                        RequireAnonymousLinksExpireInDays          = 730
                        SharingAllowedDomainList                   = @('contoso.com')
                        SharingBlockedDomainList                   = @('contoso.com')
                        SharingDomainRestrictionMode               = 'None'
                        DefaultSharingLinkType                     = 'AnonymousAccess'
                        PreventExternalUsersFromResharing          = $false
                        ShowPeoplePickerSuggestionsForGuestUsers   = $false
                        FileAnonymousLinkType                      = 'Edit'
                        FolderAnonymousLinkType                    = 'Edit'
                        NotifyOwnersWhenItemsReshared              = $true
                        DefaultLinkPermission                      = 'View'
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
                        BccExternalSharingInvitationsList          = ''
                        RequireAnonymousLinksExpireInDays          = 730
                        SharingAllowedDomainList                   = ''
                        SharingBlockedDomainList                   = ''
                        SharingDomainRestrictionMode               = ''
                        DefaultSharingLinkType                     = 'AnonymousAccess'
                        PreventExternalUsersFromResharing          = $false
                        ShowPeoplePickerSuggestionsForGuestUsers   = $false
                        FileAnonymousLinkType                      = 'Edit'
                        FolderAnonymousLinkType                    = 'Edit'
                        NotifyOwnersWhenItemsReshared              = $true
                        DefaultLinkPermission                      = 'View'
                        RequireAcceptingAccountMatchInvitedAccount = $true
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Sets the tenant sharing settings in Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
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
                        BccExternalSharingInvitationsList          = ''
                        RequireAnonymousLinksExpireInDays          = 730
                        SharingAllowedDomainList                   = @('contoso.com')
                        SharingBlockedDomainList                   = @('contoso.com')
                        SharingDomainRestrictionMode               = 'None'
                        DefaultSharingLinkType                     = 'AnonymousAccess'
                        PreventExternalUsersFromResharing          = $false
                        ShowPeoplePickerSuggestionsForGuestUsers   = $false
                        FileAnonymousLinkType                      = 'Edit'
                        FolderAnonymousLinkType                    = 'Edit'
                        NotifyOwnersWhenItemsReshared              = $true
                        DefaultLinkPermission                      = 'View'
                        RequireAcceptingAccountMatchInvitedAccount = $false
                    }
                }
            }

            It 'Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }#inmodulescope
}#describe

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
