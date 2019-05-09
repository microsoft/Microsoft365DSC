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
                                              -DscResource "SPOSite"

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-SPOServiceConnection -MockWith { }

        Mock -CommandName Connect-SPOService -MockWith { }

        Mock -CommandName Start-Sleep -MockWith { }

        # Test contexts
        Context -Name "When the site doesn't exist" -Fixture {
            $testParams = @{
                Url                                         = "https://contoso.sharepoint.com/sites/TestSite"
                Owner                                       = "testuser@contoso.com"
                StorageQuota                                = 1000
                CentralAdminUrl                             = "https://contoso-admin.sharepoint.com"
                GlobalAdminAccount                          = $GlobalAdminAccount
                Ensure                                      = "Present"
                LocaleId                                    = 1033
                Template                                    = "STS#3"
                CompatibilityLevel                          = 15
                Title                                       = "TestSite"
                DenyAddAndCustomizePages                    = $false
                StorageQuotaWarningLevel                    = 25574400
                LockState                                   = "Unlock"
                SharingCapability                           = "Disabled"
                CommentsOnSitePagesDisabled                 = $false
                SocialBarOnSitePagesDisabled                = $false
                DisableAppViews                             = "NotDisabled"
                DisableCompanyWideSharingLinks              = "NotDisabled"
                DisableFlows                                = "NotDisabled"
                RestrictedToGeo                             = "BlockMoveOnly"
                SharingDomainRestrictionMode                = "None"
                SharingAllowedDomainList                    = ""
                SharingBlockedDomainList                    = ""
                ShowPeoplePickerSuggestionsForGuestUsers    = $false
                DefaultSharingLinkType                      = "None"
                DefaultLinkPermission                       = "None"
                HubUrl                                      = "https://contoso.sharepoint.com/sites/hub"
            }

            Mock -CommandName New-SPOSite -MockWith {
                $global:O365DscSiteCreated = $true
            }

            Mock -CommandName Get-SPOSite -MockWith {
                if ($global:O365DscSiteCreated -eq $false)
                {
                    throw
                }
                else
                {
                    return @{
                        LockState = "NoLock"
                    }
                }
            }

            Mock -CommandName Get-SPOHubSite -MockWith {
                return @(
                    @{
                        ID                   = "fcc3c848-6d2f-4821-a56c-980eea7990c5"
                        Title                = "Hub Site"
                        SiteId               = "fcc3c848-6d2f-4821-a56c-980eea7990c5"
                        SiteUrl              = "https://contoso.sharepoint.com/sites/hub"
                        LogoUrl              = "https://contoso.sharepoint.com/images/logo.png"
                        Description          = "Contoso Hub Site"
                        Permissions          = @(
                            @{
                                DisplayName   = "Contoso Admin"
                                PrincipalName = "i:0#.f|membership|admin@contoso.onmicrosoft.com"
                                Rights        = "Join"
                            },
                            @{
                                DisplayName   = "Contoso Admin Group"
                                PrincipalName = "c:0t.c|tenant|1e78c600-11ce-4e7b-91c2-f3bb053f7682"
                                Rights        = "Join"
                            },
                            @{
                                DisplayName   = "Contoso Admin Office 365 Group"
                                PrincipalName = "c:0o.c|federateddirectoryclaimprovider|bfc75218-faac-4202-bf33-3a8ba2e2b4a7"
                                Rights        = "Join"
                            }
                        )
                        SiteDesignId         = "00000000-0000-0000-0000-000000000000"
                        RequiresJoinApproval = $false
                    }
                )
            }

            Mock -CommandName Set-SPOSite -MockWith { }
            Mock -CommandName Add-SPOHubSiteAssociation -MockWith { }

            $global:O365DscSiteCreated = $false
            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }

            $global:O365DscSiteCreated = $false
            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            $global:O365DscSiteCreated = $false
            It "Creates the site collection in the Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled New-SPOSite
                Assert-MockCalled Add-SPOHubSiteAssociation
                Assert-MockCalled Set-SPOSite
            }
        }

        Context -Name "The site already exists" -Fixture {
            $testParams = @{
                Url                                         = "https://contoso.sharepoint.com/sites/TestSite"
                Owner                                       = "testuser@contoso.com"
                StorageQuota                                = 1000
                CentralAdminUrl                             = "https://contoso-admin.sharepoint.com"
                GlobalAdminAccount                          = $GlobalAdminAccount
                LocaleId                                    = 1033
                Template                                    = "STS#3"
                CompatibilityLevel                          = 15
                Title                                       = "TestSite"
                DenyAddAndCustomizePages                    = $false
                StorageQuotaWarningLevel                    = 25574400
                LockState                                   = "Unlock"
                SharingCapability                           = "Disabled"
                CommentsOnSitePagesDisabled                 = $false
                SocialBarOnSitePagesDisabled                = $false
                DisableAppViews                             = "NotDisabled"
                DisableCompanyWideSharingLinks              = "NotDisabled"
                DisableFlows                                = "NotDisabled"
                RestrictedToGeo                             = "BlockMoveOnly"
                SharingDomainRestrictionMode                = "None"
                SharingAllowedDomainList                    = ""
                SharingBlockedDomainList                    = ""
                ShowPeoplePickerSuggestionsForGuestUsers    = $false
                DefaultSharingLinkType                      = "None"
                DefaultLinkPermission                       = "None"
                HubUrl                                      = "https://contoso.sharepoint.com/sites/hub"
            }

            Mock -CommandName Get-SPOSite -MockWith {
                return @{
                    Url                                         = "https://contoso.sharepoint.com/sites/TestSite"
                    Owner                                       = "testuser@contoso.com"
                    StorageQuota                                = 1000
                    Ensure                                      = "Present"
                    LocaleId                                    = 1033
                    Template                                    = "STS#3"
                    CompatibilityLevel                          = 15
                    Title                                       = "TestSite"
                    DenyAddAndCustomizePages                    = $false
                    StorageQuotaWarningLevel                    = 25574400
                    LockState                                   = "Unlock"
                    SharingCapability                           = "Disabled"
                    CommentsOnSitePagesDisabled                 = $false
                    SocialBarOnSitePagesDisabled                = $false
                    DisableAppViews                             = "NotDisabled"
                    DisableCompanyWideSharingLinks              = "NotDisabled"
                    DisableFlows                                = "NotDisabled"
                    RestrictedToGeo                             = "BlockMoveOnly"
                    SharingDomainRestrictionMode                = "None"
                    SharingAllowedDomainList                    = ""
                    SharingBlockedDomainList                    = ""
                    ShowPeoplePickerSuggestionsForGuestUsers    = $false
                    DefaultSharingLinkType                      = "None"
                    DefaultLinkPermission                       = "None"
                    HubSiteId                                   = "fcc3c848-6d2f-4821-a56c-980eea7990c5"
                }
            }

            Mock -CommandName Get-SPOHubSite -MockWith {
                return @(
                    @{
                        ID                   = "fcc3c848-6d2f-4821-a56c-980eea7990c5"
                        Title                = "Hub Site"
                        SiteId               = "fcc3c848-6d2f-4821-a56c-980eea7990c5"
                        SiteUrl              = "https://contoso.sharepoint.com/sites/hub"
                        LogoUrl              = "https://contoso.sharepoint.com/images/logo.png"
                        Description          = "Contoso Hub Site"
                        Permissions          = @(
                            @{
                                DisplayName   = "Contoso Admin"
                                PrincipalName = "i:0#.f|membership|admin@contoso.onmicrosoft.com"
                                Rights        = "Join"
                            },
                            @{
                                DisplayName   = "Contoso Admin Group"
                                PrincipalName = "c:0t.c|tenant|1e78c600-11ce-4e7b-91c2-f3bb053f7682"
                                Rights        = "Join"
                            },
                            @{
                                DisplayName   = "Contoso Admin Office 365 Group"
                                PrincipalName = "c:0o.c|federateddirectoryclaimprovider|bfc75218-faac-4202-bf33-3a8ba2e2b4a7"
                                Rights        = "Join"
                            }
                        )
                        SiteDesignId         = "00000000-0000-0000-0000-000000000000"
                        RequiresJoinApproval = $false
                    }
                )
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should Be $true
            }
        }

        Context -Name "The site already exists, with incorrect settings but site is set to NoAccess" -Fixture {
            $testParams = @{
                Url                                         = "https://contoso.sharepoint.com/sites/TestSite"
                Owner                                       = "testuser@contoso.com"
                StorageQuota                                = 1000
                CentralAdminUrl                             = "https://contoso-admin.sharepoint.com"
                GlobalAdminAccount                          = $GlobalAdminAccount
                Ensure                                      = "Present"
                LocaleId                                    = 1033
                Template                                    = "STS#3"
                CompatibilityLevel                          = 15
                Title                                       = "TestSite"
                DenyAddAndCustomizePages                    = $false
                StorageQuotaWarningLevel                    = 25574400
                LockState                                   = "NoAccess"
                SharingCapability                           = "Disabled"
                CommentsOnSitePagesDisabled                 = $false
                SocialBarOnSitePagesDisabled                = $false
                DisableAppViews                             = "NotDisabled"
                DisableCompanyWideSharingLinks              = "NotDisabled"
                DisableFlows                                = "NotDisabled"
                RestrictedToGeo                             = "BlockMoveOnly"
                SharingDomainRestrictionMode                = "None"
                SharingAllowedDomainList                    = ""
                SharingBlockedDomainList                    = ""
                ShowPeoplePickerSuggestionsForGuestUsers    = $false
                DefaultSharingLinkType                      = "None"
                DefaultLinkPermission                       = "None"
                HubUrl                                      = "https://contoso.sharepoint.com/sites/hub"
            }

            Mock -CommandName Get-SPOSite -MockWith {
                return @{
                    Url                                         = "https://contoso.sharepoint.com/sites/TestSite"
                    Owner                                       = "testuser@contoso.com"
                    StorageQuota                                = 1000
                    LocaleId                                    = 1033
                    Template                                    = "STS#3"
                    CompatibilityLevel                          = 15
                    Title                                       = "TestSite"
                    DenyAddAndCustomizePages                    = $false
                    StorageQuotaWarningLevel                    = 25574400
                    LockState                                   = "NoAccess"
                    SharingCapability                           = "Disabled"
                    CommentsOnSitePagesDisabled                 = $false
                    SocialBarOnSitePagesDisabled                = $false
                    DisableAppViews                             = "NotDisabled"
                    DisableCompanyWideSharingLinks              = "NotDisabled"
                    DisableFlows                                = "NotDisabled"
                    RestrictedToGeo                             = "BlockMoveOnly"
                    SharingDomainRestrictionMode                = "None"
                    SharingAllowedDomainList                    = ""
                    SharingBlockedDomainList                    = ""
                    ShowPeoplePickerSuggestionsForGuestUsers    = $false
                    DefaultSharingLinkType                      = "None"
                    DefaultLinkPermission                       = "None"
                    HubSiteId                                   = "fcc3c848-6d2f-4821-a56c-980eea7990c5"
                }
            }

            Mock -CommandName Get-SPOHubSite -MockWith {
                return @(
                    @{
                        ID                   = "fcc3c848-6d2f-4821-a56c-980eea7990c5"
                        Title                = "Hub Site"
                        SiteId               = "fcc3c848-6d2f-4821-a56c-980eea7990c5"
                        SiteUrl              = "https://contoso.sharepoint.com/sites/hub"
                        LogoUrl              = "https://contoso.sharepoint.com/images/logo.png"
                        Description          = "Contoso Hub Site"
                        Permissions          = @(
                            @{
                                DisplayName   = "Contoso Admin"
                                PrincipalName = "i:0#.f|membership|admin@contoso.onmicrosoft.com"
                                Rights        = "Join"
                            },
                            @{
                                DisplayName   = "Contoso Admin Group"
                                PrincipalName = "c:0t.c|tenant|1e78c600-11ce-4e7b-91c2-f3bb053f7682"
                                Rights        = "Join"
                            },
                            @{
                                DisplayName   = "Contoso Admin Office 365 Group"
                                PrincipalName = "c:0o.c|federateddirectoryclaimprovider|bfc75218-faac-4202-bf33-3a8ba2e2b4a7"
                                Rights        = "Join"
                            }
                        )
                        SiteDesignId         = "00000000-0000-0000-0000-000000000000"
                        RequiresJoinApproval = $false
                    }
                )
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should Be $true
            }

            It "Should return true from the Test method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "The site already exists, but with incorrect settings" -Fixture {
            $testParams = @{
                Url                                         = "https://contoso.sharepoint.com/sites/TestSite"
                Owner                                       = "testuser@contoso.com"
                StorageQuota                                = 1000
                CentralAdminUrl                             = "https://contoso-admin.sharepoint.com"
                GlobalAdminAccount                          = $GlobalAdminAccount
                LocaleId                                    = 1033
                Template                                    = "STS#3"
                CompatibilityLevel                          = 15
                Title                                       = "TestSite"
                DenyAddAndCustomizePages                    = $false
                StorageQuotaWarningLevel                    = 25574400
                LockState                                   = "Unlock"
                SharingCapability                           = "Disabled"
                CommentsOnSitePagesDisabled                 = $false
                SocialBarOnSitePagesDisabled                = $false
                DisableAppViews                             = "NotDisabled"
                DisableCompanyWideSharingLinks              = "NotDisabled"
                DisableFlows                                = "NotDisabled"
                RestrictedToGeo                             = "BlockMoveOnly"
                SharingDomainRestrictionMode                = "None"
                SharingAllowedDomainList                    = ""
                SharingBlockedDomainList                    = ""
                ShowPeoplePickerSuggestionsForGuestUsers    = $false
                DefaultSharingLinkType                      = "None"
                DefaultLinkPermission                       = "None"
                HubUrl                                      = "https://contoso.sharepoint.com/sites/hub"
            }

            Mock -CommandName Set-SPOSite -MockWith { }

            Mock -CommandName Get-SPOSite -MockWith {
                return @{
                    Url                                         = "https://contoso.sharepoint.com/sites/TestSite"
                    Owner                                       = "testuser2@contoso.com"
                    StorageQuota                                = 1500
                    LocaleId                                    = 1033
                    Template                                    = "STS#3"
                    CompatibilityLevel                          = 15
                    Title                                       = "TestSite2"
                    DenyAddAndCustomizePages                    = $true
                    StorageQuotaWarningLevel                    = 25554400
                    LockState                                   = "Unlock"
                    SharingCapability                           = "ExistingExternalUserSharingOnly"
                    CommentsOnSitePagesDisabled                 = $true
                    SocialBarOnSitePagesDisabled                = $true
                    DisableAppViews                             = "NotDisabled"
                    DisableCompanyWideSharingLinks              = "NotDisabled"
                    DisableFlows                                = "NotDisabled"
                    RestrictedToGeo                             = "BlockMoveOnly"
                    SharingDomainRestrictionMode                = "None"
                    SharingAllowedDomainList                    = ""
                    SharingBlockedDomainList                    = ""
                    ShowPeoplePickerSuggestionsForGuestUsers    = $true
                    DefaultSharingLinkType                      = "None"
                    DefaultLinkPermission                       = "None"
                    HubSiteId                                   = "ecc3c848-6d2f-4821-a56c-980eea7990c6"
                }
            }

            Mock -CommandName Get-SPOHubSite -MockWith {
                return @(
                    @{
                        ID                   = "fcc3c848-6d2f-4821-a56c-980eea7990c5"
                        Title                = "Hub Site"
                        SiteId               = "fcc3c848-6d2f-4821-a56c-980eea7990c5"
                        SiteUrl              = "https://contoso.sharepoint.com/sites/hub"
                        LogoUrl              = "https://contoso.sharepoint.com/images/logo.png"
                        Description          = "Contoso Hub Site"
                        Permissions          = @(
                            @{
                                DisplayName   = "Contoso Admin"
                                PrincipalName = "i:0#.f|membership|admin@contoso.onmicrosoft.com"
                                Rights        = "Join"
                            },
                            @{
                                DisplayName   = "Contoso Admin Group"
                                PrincipalName = "c:0t.c|tenant|1e78c600-11ce-4e7b-91c2-f3bb053f7682"
                                Rights        = "Join"
                            },
                            @{
                                DisplayName   = "Contoso Admin Office 365 Group"
                                PrincipalName = "c:0o.c|federateddirectoryclaimprovider|bfc75218-faac-4202-bf33-3a8ba2e2b4a7"
                                Rights        = "Join"
                            }
                        )
                        SiteDesignId         = "00000000-0000-0000-0000-000000000000"
                        RequiresJoinApproval = $false
                    },
                    @{
                        ID                   = "ecc3c848-6d2f-4821-a56c-980eea7990c6"
                        Title                = "Hub Site"
                        SiteId               = "ecc3c848-6d2f-4821-a56c-980eea7990c6"
                        SiteUrl              = "https://contoso.sharepoint.com/sites/hub2"
                        LogoUrl              = "https://contoso.sharepoint.com/images/logo.png"
                        Description          = "Contoso Hub Site"
                        Permissions          = @(
                            @{
                                DisplayName   = "Contoso Admin"
                                PrincipalName = "i:0#.f|membership|admin@contoso.onmicrosoft.com"
                                Rights        = "Join"
                            },
                            @{
                                DisplayName   = "Contoso Admin Group"
                                PrincipalName = "c:0t.c|tenant|1e78c600-11ce-4e7b-91c2-f3bb053f7682"
                                Rights        = "Join"
                            },
                            @{
                                DisplayName   = "Contoso Admin Office 365 Group"
                                PrincipalName = "c:0o.c|federateddirectoryclaimprovider|bfc75218-faac-4202-bf33-3a8ba2e2b4a7"
                                Rights        = "Join"
                            }
                        )
                        SiteDesignId         = "00000000-0000-0000-0000-000000000000"
                        RequiresJoinApproval = $false
                    }
                )
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should update settings in Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled Set-SPOSite
            }
        }

        Context -Name "The site exists, but association with Hub site will be removed" -Fixture {
            $testParams = @{
                Url                                         = "https://contoso.sharepoint.com/sites/TestSite"
                Owner                                       = "testuser@contoso.com"
                StorageQuota                                = 1000
                CentralAdminUrl                             = "https://contoso-admin.sharepoint.com"
                GlobalAdminAccount                          = $GlobalAdminAccount
                LocaleId                                    = 1033
                Template                                    = "STS#3"
                CompatibilityLevel                          = 15
                Title                                       = "TestSite"
                DenyAddAndCustomizePages                    = $false
                StorageQuotaWarningLevel                    = 25574400
                LockState                                   = "Unlock"
                SharingCapability                           = "Disabled"
                CommentsOnSitePagesDisabled                 = $false
                SocialBarOnSitePagesDisabled                = $false
                DisableAppViews                             = "NotDisabled"
                DisableCompanyWideSharingLinks              = "NotDisabled"
                DisableFlows                                = "NotDisabled"
                RestrictedToGeo                             = "BlockMoveOnly"
                SharingDomainRestrictionMode                = "None"
                SharingAllowedDomainList                    = ""
                SharingBlockedDomainList                    = ""
                ShowPeoplePickerSuggestionsForGuestUsers    = $false
                DefaultSharingLinkType                      = "None"
                DefaultLinkPermission                       = "None"
                HubUrl                                      = ""
            }

            Mock -CommandName Set-SPOSite -MockWith { }

            Mock -CommandName Get-SPOSite -MockWith {
                return @{
                    Url                                         = "https://contoso.sharepoint.com/sites/TestSite"
                    Owner                                       = "testuser2@contoso.com"
                    StorageQuota                                = 1500
                    LocaleId                                    = 1033
                    Template                                    = "STS#3"
                    CompatibilityLevel                          = 15
                    Title                                       = "TestSite2"
                    DenyAddAndCustomizePages                    = $true
                    StorageQuotaWarningLevel                    = 25554400
                    LockState                                   = "Unlock"
                    SharingCapability                           = "ExistingExternalUserSharingOnly"
                    CommentsOnSitePagesDisabled                 = $true
                    SocialBarOnSitePagesDisabled                = $true
                    DisableAppViews                             = "NotDisabled"
                    DisableCompanyWideSharingLinks              = "NotDisabled"
                    DisableFlows                                = "NotDisabled"
                    RestrictedToGeo                             = "BlockMoveOnly"
                    SharingDomainRestrictionMode                = "None"
                    SharingAllowedDomainList                    = ""
                    SharingBlockedDomainList                    = ""
                    ShowPeoplePickerSuggestionsForGuestUsers    = $true
                    DefaultSharingLinkType                      = "None"
                    DefaultLinkPermission                       = "None"
                    HubSiteId                                   = "ecc3c848-6d2f-4821-a56c-980eea7990c6"
                }
            }

            Mock -CommandName Get-SPOHubSite -MockWith {
                return @(
                    @{
                        ID                   = "fcc3c848-6d2f-4821-a56c-980eea7990c5"
                        Title                = "Hub Site"
                        SiteId               = "fcc3c848-6d2f-4821-a56c-980eea7990c5"
                        SiteUrl              = "https://contoso.sharepoint.com/sites/hub"
                        LogoUrl              = "https://contoso.sharepoint.com/images/logo.png"
                        Description          = "Contoso Hub Site"
                        Permissions          = @(
                            @{
                                DisplayName   = "Contoso Admin"
                                PrincipalName = "i:0#.f|membership|admin@contoso.onmicrosoft.com"
                                Rights        = "Join"
                            },
                            @{
                                DisplayName   = "Contoso Admin Group"
                                PrincipalName = "c:0t.c|tenant|1e78c600-11ce-4e7b-91c2-f3bb053f7682"
                                Rights        = "Join"
                            },
                            @{
                                DisplayName   = "Contoso Admin Office 365 Group"
                                PrincipalName = "c:0o.c|federateddirectoryclaimprovider|bfc75218-faac-4202-bf33-3a8ba2e2b4a7"
                                Rights        = "Join"
                            }
                        )
                        SiteDesignId         = "00000000-0000-0000-0000-000000000000"
                        RequiresJoinApproval = $false
                    },
                    @{
                        ID                   = "ecc3c848-6d2f-4821-a56c-980eea7990c6"
                        Title                = "Hub Site"
                        SiteId               = "ecc3c848-6d2f-4821-a56c-980eea7990c6"
                        SiteUrl              = "https://contoso.sharepoint.com/sites/hub2"
                        LogoUrl              = "https://contoso.sharepoint.com/images/logo.png"
                        Description          = "Contoso Hub Site"
                        Permissions          = @(
                            @{
                                DisplayName   = "Contoso Admin"
                                PrincipalName = "i:0#.f|membership|admin@contoso.onmicrosoft.com"
                                Rights        = "Join"
                            },
                            @{
                                DisplayName   = "Contoso Admin Group"
                                PrincipalName = "c:0t.c|tenant|1e78c600-11ce-4e7b-91c2-f3bb053f7682"
                                Rights        = "Join"
                            },
                            @{
                                DisplayName   = "Contoso Admin Office 365 Group"
                                PrincipalName = "c:0o.c|federateddirectoryclaimprovider|bfc75218-faac-4202-bf33-3a8ba2e2b4a7"
                                Rights        = "Join"
                            }
                        )
                        SiteDesignId         = "00000000-0000-0000-0000-000000000000"
                        RequiresJoinApproval = $false
                    }
                )
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should update settings in Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled Set-SPOSite
            }
        }

        Context -Name "Deleted site exists" -Fixture {
            $testParams = @{
                Url                                      = "https://contoso.sharepoint.com/sites/TestSite"
                Owner                                    = "testuser@contoso.com"
                StorageQuota                             = 1000
                CentralAdminUrl                          = "https://contoso-admin.sharepoint.com"
                GlobalAdminAccount                       = $GlobalAdminAccount
                Ensure                                   = "Present"
                LocaleId                                 = 1033
                Template                                 = "STS#3"
                CompatibilityLevel                       = 15
                Title                                    = "TestSite"
                DenyAddAndCustomizePages                 = $false
                StorageQuotaWarningLevel                 = 25574400
                LockState                                = "Unlock"
                SharingCapability                        = "Disabled"
                CommentsOnSitePagesDisabled              = $false
                SocialBarOnSitePagesDisabled             = $false
                DisableAppViews                          = "NotDisabled"
                DisableCompanyWideSharingLinks           = "NotDisabled"
                DisableFlows                             = "NotDisabled"
                RestrictedToGeo                          = "BlockMoveOnly"
                SharingDomainRestrictionMode             = "None"
                SharingAllowedDomainList                 = ""
                SharingBlockedDomainList                 = ""
                ShowPeoplePickerSuggestionsForGuestUsers = $false
                DefaultSharingLinkType                   = "None"
                DefaultLinkPermission                    = "None"
                HubUrl                                   = "https://contoso.sharepoint.com/sites/hub"
            }

            Mock -CommandName Get-SPODeletedSite -MockWith {
                return @{
                    Url = "https://contoso.sharepoint.com/sites/TestSite"
                }
            }

            Mock -CommandName Restore-SPODeletedSite -MockWith {
                $global:O365DscSiteCreated = $true
            }

            Mock -CommandName Get-SPOSite -MockWith {
                if ($global:O365DscSiteCreated -eq $false)
                {
                    return $null
                }
                else
                {
                    return @{
                        Url                                         = "https://contoso.sharepoint.com/sites/TestSite"
                        Owner                                       = "testuser@contoso.com"
                        StorageQuota                                = 1000
                        Ensure                                      = "Present"
                        LocaleId                                    = 1033
                        Template                                    = "STS#3"
                        CompatibilityLevel                          = 15
                        Title                                       = "TestSite"
                        DenyAddAndCustomizePages                    = $false
                        StorageQuotaWarningLevel                    = 25574400
                        LockState                                   = "Unlock"
                        SharingCapability                           = "Disabled"
                        CommentsOnSitePagesDisabled                 = $false
                        SocialBarOnSitePagesDisabled                = $false
                        DisableAppViews                             = "NotDisabled"
                        DisableCompanyWideSharingLinks              = "NotDisabled"
                        DisableFlows                                = "NotDisabled"
                        RestrictedToGeo                             = "BlockMoveOnly"
                        SharingDomainRestrictionMode                = "None"
                        SharingAllowedDomainList                    = ""
                        SharingBlockedDomainList                    = ""
                        ShowPeoplePickerSuggestionsForGuestUsers    = $false
                        DefaultSharingLinkType                      = "None"
                        DefaultLinkPermission                       = "None"
                        HubSiteId                                   = "fcc3c848-6d2f-4821-a56c-980eea7990c5"
                    }
                }
            }

            Mock -CommandName Get-SPOHubSite -MockWith {
                return @(
                    @{
                        ID                   = "fcc3c848-6d2f-4821-a56c-980eea7990c5"
                        Title                = "Hub Site"
                        SiteId               = "fcc3c848-6d2f-4821-a56c-980eea7990c5"
                        SiteUrl              = "https://contoso.sharepoint.com/sites/hub"
                        LogoUrl              = "https://contoso.sharepoint.com/images/logo.png"
                        Description          = "Contoso Hub Site"
                        Permissions          = @(
                            @{
                                DisplayName   = "Contoso Admin"
                                PrincipalName = "i:0#.f|membership|admin@contoso.onmicrosoft.com"
                                Rights        = "Join"
                            },
                            @{
                                DisplayName   = "Contoso Admin Group"
                                PrincipalName = "c:0t.c|tenant|1e78c600-11ce-4e7b-91c2-f3bb053f7682"
                                Rights        = "Join"
                            },
                            @{
                                DisplayName   = "Contoso Admin Office 365 Group"
                                PrincipalName = "c:0o.c|federateddirectoryclaimprovider|bfc75218-faac-4202-bf33-3a8ba2e2b4a7"
                                Rights        = "Join"
                            }
                        )
                        SiteDesignId         = "00000000-0000-0000-0000-000000000000"
                        RequiresJoinApproval = $false
                    }
                )
            }

            $global:O365DscSiteCreated = $false
            It "should find the deleted site" {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }

            $global:O365DscSiteCreated = $false
            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            $global:O365DscSiteCreated = $false
            It "should restore the deleted site from the recycle bin" {
               Set-TargetResource @testParams
               Assert-MockCalled Restore-SPODeletedSite
            }
        }

        Context -Name "Site exists, but should not be" -Fixture {
            $testParams = @{
                Url                                      = "https://contoso.sharepoint.com/sites/TestSite"
                Owner                                    = "testuser@contoso.com"
                StorageQuota                             = 1000
                CentralAdminUrl                          = "https://contoso-admin.sharepoint.com"
                GlobalAdminAccount                       = $GlobalAdminAccount
                Ensure                                   = "Absent"
                LocaleId                                 = 1033
                Template                                 = "STS#3"
                CompatibilityLevel                       = 15
                Title                                    = "TestSite"
                DenyAddAndCustomizePages                 = $false
                StorageQuotaWarningLevel                 = 25574400
                LockState                                = "Unlock"
                SharingCapability                        = "Disabled"
                CommentsOnSitePagesDisabled              = $false
                SocialBarOnSitePagesDisabled             = $false
                DisableAppViews                          = "NotDisabled"
                DisableCompanyWideSharingLinks           = "NotDisabled"
                DisableFlows                             = "NotDisabled"
                RestrictedToGeo                          = "BlockMoveOnly"
                SharingDomainRestrictionMode             = "None"
                SharingAllowedDomainList                 = ""
                SharingBlockedDomainList                 = ""
                ShowPeoplePickerSuggestionsForGuestUsers = $false
                DefaultSharingLinkType                   = "None"
                DefaultLinkPermission                    = "None"
                HubUrl                                   = "https://contoso.sharepoint.com/sites/hub"
            }

            Mock -CommandName Get-SPOSite -MockWith {
                return @{
                    Url                                         = "https://contoso.sharepoint.com/sites/TestSite"
                    Owner                                       = "testuser@contoso.com"
                    StorageQuota                                = 1000
                    Ensure                                      = "Present"
                    LocaleId                                    = 1033
                    Template                                    = "STS#3"
                    CompatibilityLevel                          = 15
                    Title                                       = "TestSite"
                    DenyAddAndCustomizePages                    = $false
                    StorageQuotaWarningLevel                    = 25574400
                    LockState                                   = "Unlock"
                    SharingCapability                           = "Disabled"
                    CommentsOnSitePagesDisabled                 = $false
                    SocialBarOnSitePagesDisabled                = $false
                    DisableAppViews                             = "NotDisabled"
                    DisableCompanyWideSharingLinks              = "NotDisabled"
                    DisableFlows                                = "NotDisabled"
                    RestrictedToGeo                             = "BlockMoveOnly"
                    SharingDomainRestrictionMode                = "None"
                    SharingAllowedDomainList                    = ""
                    SharingBlockedDomainList                    = ""
                    ShowPeoplePickerSuggestionsForGuestUsers    = $false
                    DefaultSharingLinkType                      = "None"
                    DefaultLinkPermission                       = "None"
                    HubSiteId                                   = "00000000-0000-0000-0000-000000000000"
                }
            }


            Mock -CommandName Remove-SPOSite -MockWith { }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "should delete the site" {
                Set-TargetResource @testParams
                Assert-MockCalled Remove-SPOSite
             }
         }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                Url = "https://contoso.com/sites/TestSite"
                CentralAdminUrl = "https://contoso-admin.sharepoint.com"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-SPOSite -MockWith {
                return @{
                    Url                                         = "https://contoso.com/sites/TestSite"
                    Owner                                       = "testuser@contoso.com"
                    StorageQuota                                = 1000
                    Ensure                                      = "Present"
                    LocaleId                                    = 1033
                    Template                                    = "STS#3"
                    CompatibilityLevel                          = 15
                    Title                                       = "TestSite"
                    DenyAddAndCustomizePages                    = $false
                    StorageQuotaWarningLevel                    = 25574400
                    LockState                                   = "Unlock"
                    SharingCapability                           = "Disabled"
                    CommentsOnSitePagesDisabled                 = $false
                    SocialBarOnSitePagesDisabled                = $false
                    DisableAppViews                             = "NotDisabled"
                    DisableCompanyWideSharingLinks              = "NotDisabled"
                    DisableFlows                                = "NotDisabled"
                    RestrictedToGeo                             = "BlockMoveOnly"
                    SharingDomainRestrictionMode                = "None"
                    SharingAllowedDomainList                    = ""
                    SharingBlockedDomainList                    = ""
                    ShowPeoplePickerSuggestionsForGuestUsers    = $false
                    DefaultSharingLinkType                      = "None"
                    DefaultLinkPermission                       = "None"
                    HubSiteId                                   = "cf4d2dbe-1d04-439a-8ba8-77c563a7e630"
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
