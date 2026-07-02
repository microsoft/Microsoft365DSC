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
            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -ModuleName M365DSCUtil -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PnPTenantSite -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            # Mock Write-M365DSCHost to hide output during the tests
            Mock -CommandName Write-M365DSCHost -MockWith {
            }

            Mock -CommandName Write-Warning -MockWith {
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
                        RequireAcceptingAccountMatchInvitedAccount = $false
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
        Context -Name 'My Site Host lookup (perf fix)' -Fixture {
            BeforeAll {
                $optParams = @{
                    Credential       = $Credential
                    IsSingleInstance = 'Yes'
                }

                Mock -CommandName Get-PnPTenantSite -MockWith {
                    if (-not [string]::IsNullOrEmpty($Identity) -and $Identity -like '*-my.*')
                    {
                        return @{
                            Url               = 'https://contoso-my.sharepoint.com/'
                            Template          = 'SPSMSITEHOST#0'
                            SharingCapability = 'Disabled'
                        }
                    }
                    if ($null -ne $Filter)
                    {
                        return @{
                            Url      = 'https://contoso-my.sharepoint.com/'
                            Template = 'SPSMSITEHOST#0'
                        }
                    }
                    return $null
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
                        RequireAcceptingAccountMatchInvitedAccount = $false
                    }
                }
            }

            It 'Resolves the My Site Host with a single -Identity call when the URL can be derived' {
                Mock -CommandName Get-PnPConnection -MockWith {
                    return @{ Url = 'https://contoso.sharepoint.com' }
                }

                $null = Get-TargetResource @optParams

                Should -Invoke -CommandName Get-PnPTenantSite -Times 1 -Exactly `
                    -ParameterFilter { $Identity -like '*-my.*' }
                Should -Invoke -CommandName Get-PnPTenantSite -Times 0 -Exactly `
                    -ParameterFilter { $null -ne $Filter }
            }

            It 'Returns SharingCapability read from the direct -Identity lookup as MySiteSharingCapability' {
                Mock -CommandName Get-PnPConnection -MockWith {
                    return @{ Url = 'https://contoso.sharepoint.com' }
                }

                $result = Get-TargetResource @optParams
                $result.MySiteSharingCapability | Should -Be 'Disabled'
            }

            It 'Falls back to the -Filter enumeration when the My Site Host URL cannot be resolved' {
                Mock -CommandName Get-PnPConnection -MockWith { return @{ Url = $null } }

                $null = Get-TargetResource @optParams

                Should -Invoke -CommandName Get-PnPConnection -Times 1
                Should -Invoke -CommandName Get-PnPTenantSite -Times 1 -Exactly `
                    -ParameterFilter { $null -ne $Filter }
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
