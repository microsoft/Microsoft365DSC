[CmdletBinding()]
param(
    [Parameter()]
    [string]
    $CmdletModule = (Join-Path -Path $PSScriptRoot `
            -ChildPath "..\Stubs\Microsoft365.psm1" `
            -Resolve)
)
$GenericStubPath = (Join-Path -Path $PSScriptRoot `
    -ChildPath "..\Stubs\Generic.psm1" `
    -Resolve)
Import-Module -Name (Join-Path -Path $PSScriptRoot `
        -ChildPath "..\UnitTestHelper.psm1" `
        -Resolve)
$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "SPOSite" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-MSCloudLogin -MockWith { }

        Mock -CommandName Start-Sleep -MockWith { }

        Mock -CommandName Get-PnPContext -MockWith {
            $context = @{} | Add-Member -MemberType ScriptMethod -Name ExecuteQuery -Value {
            } -PassThru

            return $context
        }

        # Test contexts
        Context -Name "When the site doesn't exist" -Fixture {
            $testParams = @{
                Url                            = "https://contoso.sharepoint.com/sites/TestSite"
                TimeZoneID                     = 10
                Owner                          = "testuser@contoso.com"
                AllowSelfServiceUpgrade        = $True;
                CommentsOnSitePagesDisabled    = $False;
                DefaultLinkPermission          = "None";
                DefaultSharingLinkType         = "None";
                DisableAppViews                = "NotDisabled";
                DisableCompanyWideSharingLinks = "NotDisabled";
                DisableFlows                   = $False;
                Ensure                         = "Present";
                GlobalAdminAccount             = $GlobalAdminAccount;
                LocaleId                       = 1033;
                StorageMaximumLevel            = 26214400;
                StorageWarningLevel            = 25574400;
                Title                          = "CommNik";
                HubUrl                         = "https://contoso.sharepoint.com/sites/hub"
                Template                       = "STS#3";
            }

            Mock -CommandName New-PnPTenantSite -MockWith {
                $global:M365DscSiteCreated = $true
            }

            Mock -CommandName Get-PnPTenantSite -MockWith {
                if ($global:M365DscSiteCreated -eq $false)
                {
                    throw
                }
                else
                {
                    $site = @{
                        Url = "https://contoso.sharepoint.com/sites/TestSite"
                    }| Add-Member -MemberType ScriptMethod -Name Update -Value {
                    } -PassThru

                    return $site
                }
            }

            Mock -CommandName Get-PnPHubSite -MockWith {
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

            Mock -CommandName Set-PnPTenantSite -MockWith { }
            Mock -CommandName Add-PnPHubSiteAssociation -MockWith { }

            $global:M365DscSiteCreated = $false
            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }

            $global:M365DscSiteCreated = $false
            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            $global:M365DscSiteCreated = $false
            It "Creates the site collection in the Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled New-PnPTenantSite
                Assert-MockCalled Add-PnPHubSiteAssociation
                Assert-MockCalled Set-PnPTenantSite
            }
        }

        Context -Name "The site already exists" -Fixture {
            $testParams = @{
                Url                            = "https://contoso.sharepoint.com/sites/TestSite"
                TimeZoneID                     = 10
                Owner                          = "testuser@contoso.com"
                AllowSelfServiceUpgrade        = $True;
                CommentsOnSitePagesDisabled    = $False;
                DefaultLinkPermission          = "None";
                DefaultSharingLinkType         = "None";
                DisableAppViews                = "NotDisabled";
                DisableCompanyWideSharingLinks = "NotDisabled";
                DisableFlows                   = $False;
                Ensure                         = "Present";
                GlobalAdminAccount             = $GlobalAdminAccount;
                LocaleId                       = 1033;
                StorageMaximumLevel            = 26214400;
                StorageWarningLevel            = 25574400;
                Title                          = "CommNik";
                HubUrl                         = "https://contoso.sharepoint.com/sites/hub"
                Template                       = "STS#3";
            }

            Mock -CommandName Get-PnPTenantSite -MockWith {
                $site = @{
                    Url                            = "https://contoso.sharepoint.com/sites/TestSite"
                    OwnerEmail                     = "testuser@contoso.com"
                    TimeZoneId                     = 10
                    AllowSelfServiceUpgrade        = $True;
                    CommentsOnSitePagesDisabled    = $False;
                    DefaultLinkPermission          = "None";
                    DefaultSharingLinkType         = "None";
                    DisableAppViews                = "NotDisabled";
                    DisableCompanyWideSharingLinks = "NotDisabled";
                    DisableFlows                   = "NotDisabled";
                    DisableSharingForNonOwners     = $False;
                    LCID                           = 1033;
                    RestrictedToRegion             = "Unknown";
                    SocialBarOnSitePagesDisabled   = $False;
                    StorageMaximumLevel            = 26214400;
                    StorageWarningLevel            = 25574400;
                    Title                          = "CommNik";
                    Template                       = "STS#3";
                    HubSiteId                      = "fcc3c848-6d2f-4821-a56c-980eea7990c5"
                }| Add-Member -MemberType ScriptMethod -Name Update -Value {
                } -PassThru

                return $site
            }

            Mock -CommandName Get-PnPHubSite -MockWith {
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

        Context -Name "The site already exists, with incorrect settings" -Fixture {
            $testParams = @{
                Url                            = "https://contoso.sharepoint.com/sites/TestSite"
                TimeZoneID                     = 10
                Owner                          = "testuser@contoso.com"
                AllowSelfServiceUpgrade        = $True;
                CommentsOnSitePagesDisabled    = $False;
                DefaultLinkPermission          = "None";
                DefaultSharingLinkType         = "None";
                DisableAppViews                = "NotDisabled";
                DisableCompanyWideSharingLinks = "NotDisabled";
                DisableFlows                   = $False;
                Ensure                         = "Present";
                GlobalAdminAccount             = $GlobalAdminAccount;
                LocaleId                       = 1033;
                StorageMaximumLevel            = 26214400;
                StorageWarningLevel            = 25574400;
                Title                          = "CommNik";
                HubUrl                         = "https://contoso.sharepoint.com/sites/hub"
                Template                       = "STS#3";
            }

            Mock -CommandName Get-PnPTenantSite -MockWith {
                $site = @{
                    Url                            = "https://contoso.sharepoint.com/sites/TestSite"
                    Owner                          = "testuser@contoso.com"
                    TimeZoneId                     = 10
                    AllowSelfServiceUpgrade        = $True;
                    CommentsOnSitePagesDisabled    = $False;
                    DefaultLinkPermission          = "None";
                    DefaultSharingLinkType         = "None";
                    DisableAppViews                = "NotDisabled";
                    DisableCompanyWideSharingLinks = "NotDisabled";
                    DisableFlows                   = "NotDisabled";
                    DisableSharingForNonOwners     = $False;
                    LCID                           = 1033;
                    RestrictedToRegion             = "Unknown";
                    SocialBarOnSitePagesDisabled   = $False;
                    StorageMaximumLevel            = 26214400;
                    StorageWarningLevel            = 25574400;
                    Title                          = "CommNik";
                    Template                       = "SITEPAGEPUBLISHING#0";
                    HubUrl                         = "https://contoso.sharepoint.com/sites/hub"
                }| Add-Member -MemberType ScriptMethod -Name Update -Value {
                } -PassThru

                return $site
            }

            Mock -CommandName Get-PnPHubSite -MockWith {
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

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should return true from the Test method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "The site exists, but association with Hub site will be removed" -Fixture {
            $testParams = @{
                Url                            = "https://contoso.sharepoint.com/sites/TestSite"
                TimeZoneID                     = 10
                Owner                          = "testuser@contoso.com"
                AllowSelfServiceUpgrade        = $True;
                CommentsOnSitePagesDisabled    = $False;
                DefaultLinkPermission          = "None";
                DefaultSharingLinkType         = "None";
                DisableAppViews                = "NotDisabled";
                DisableCompanyWideSharingLinks = "NotDisabled";
                DisableFlows                   = $False;
                Ensure                         = "Present";
                GlobalAdminAccount             = $GlobalAdminAccount;
                LocaleId                       = 1033;
                StorageMaximumLevel            = 26214400;
                StorageWarningLevel            = 25574400;
                Title                          = "CommNik";
                HubUrl                         = "https://contoso.sharepoint.com/sites/hub"
                Template                       = "STS#3";
            }

            Mock -CommandName Get-PnPTenantSite -MockWith {
                $site = @{
                    Url                            = "https://contoso.sharepoint.com/sites/TestSite"
                    OwnerEmail                     = "testuser@contoso.com"
                    TimeZoneId                     = 10
                    AllowSelfServiceUpgrade        = $True;
                    CommentsOnSitePagesDisabled    = $False;
                    DefaultLinkPermission          = "None";
                    DefaultSharingLinkType         = "None";
                    DisableAppViews                = "NotDisabled";
                    DisableCompanyWideSharingLinks = "NotDisabled";
                    DisableFlows                   = "NotDisabled";
                    DisableSharingForNonOwners     = $False;
                    LCID                           = 1033;
                    RestrictedToRegion             = "Unknown";
                    SocialBarOnSitePagesDisabled   = $False;
                    StorageMaximumLevel            = 26214400;
                    StorageWarningLevel            = 25574400;
                    Title                          = "CommNik";
                    Template                       = "SITEPAGEPUBLISHING#0";
                    HubSiteId                          = "fcc3c848-6d2f-4821-a56c-980eea7990c5"
                }| Add-Member -MemberType ScriptMethod -Name Update -Value {
                } -PassThru

                return $site
            }

            Mock -CommandName Get-PnPHubSite -MockWith {
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

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should update settings in Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "Deleted existing site" -Fixture {
            $testParams = @{
                Url                            = "https://contoso.sharepoint.com/sites/TestSite"
                TimeZoneID                     = 10
                Owner                          = "testuser@contoso.com"
                AllowSelfServiceUpgrade        = $True;
                CommentsOnSitePagesDisabled    = $False;
                DefaultLinkPermission          = "None";
                DefaultSharingLinkType         = "None";
                DisableAppViews                = "NotDisabled";
                DisableCompanyWideSharingLinks = "NotDisabled";
                DisableFlows                   = $False;
                Ensure                         = "Present";
                GlobalAdminAccount             = $GlobalAdminAccount;
                LocaleId                       = 1033;
                StorageMaximumLevel            = 26214400;
                StorageWarningLevel            = 25574400;
                Title                          = "CommNik";
                HubUrl                         = "https://contoso.sharepoint.com/sites/hub"
                Template                       = "STS#3";
            }

            Mock -CommandName Get-PnPTenantSite -MockWith {
                $site = @{
                    Url                            = "https://contoso.sharepoint.com/sites/TestSite"
                    OwnerEmail                     = "testuser@contoso.com"
                    TimeZoneId                     = 10
                    AllowSelfServiceUpgrade        = $True;
                    CommentsOnSitePagesDisabled    = $False;
                    DefaultLinkPermission          = "None";
                    DefaultSharingLinkType         = "None";
                    DisableAppViews                = "NotDisabled";
                    DisableCompanyWideSharingLinks = "NotDisabled";
                    DisableFlows                   = "NotDisabled";
                    DisableSharingForNonOwners     = $False;
                    LCID                           = 1033;
                    RestrictedToRegion             = "Unknown";
                    SocialBarOnSitePagesDisabled   = $False;
                    StorageMaximumLevel            = 26214400;
                    StorageWarningLevel            = 25574400;
                    Title                          = "CommNik";
                    Template                       = "SITEPAGEPUBLISHING#0";
                    HubSiteId                          = "fcc3c848-6d2f-4821-a56c-980eea7990c5"
                } | Add-Member -MemberType ScriptMethod -Name Update -Value {
                } -PassThru

                return $site
            }

            Mock -CommandName Get-PnPHubSite -MockWith {
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

            Mock -CommandName Remove-PnPTenantSite -MockWith {
            }

            $global:M365DscSiteCreated = $false
            It "Should find the site" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            $global:M365DscSiteCreated = $false
            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            $global:M365DscSiteCreated = $false
            It "Should delete the site" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
            }

            $CalledOnce = $false
            Mock -CommandName Get-PnPTenantSite -MockWith {
                if (-not $CalledOnce)
                {
                    $CalledOnce = $true
                    return @{
                        Url                            = "https://contoso.sharepoint.com/sites/TestSite"
                        OwnerEmail                     = "testuser@contoso.com"
                        TimeZoneId                     = 10
                        AllowSelfServiceUpgrade        = $True;
                        CommentsOnSitePagesDisabled    = $False;
                        DefaultLinkPermission          = "None";
                        DefaultSharingLinkType         = "None";
                        DisableAppViews                = "NotDisabled";
                        DisableCompanyWideSharingLinks = "NotDisabled";
                        DisableFlows                   = "NotDisabled";
                        DisableSharingForNonOwners     = $False;
                        LCID                           = 1033;
                        RestrictedToRegion             = "Unknown";
                        SocialBarOnSitePagesDisabled   = $False;
                        StorageMaximumLevel            = 26214400;
                        StorageWarningLevel            = 25574400;
                        Title                          = "CommNik";
                        Template                       = "SITEPAGEPUBLISHING#0";
                        HubSiteId                          = "fcc3c848-6d2f-4821-a56c-980eea7990c5"
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
