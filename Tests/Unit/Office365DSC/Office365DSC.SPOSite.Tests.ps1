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

        Mock -CommandName Test-SPOServiceConnection -MockWith {

        }

        Mock -CommandName Connect-SPOService -MockWith {
            
        }

        # Test contexts
        Context -Name "When the site doesn't exist" -Fixture {
            $testParams = @{
                Url                                         = "https://contoso.com/sites/TestSite"
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
            }

            Mock -CommandName New-SPOSite -MockWith {
                return @{Url = $null}
            }

            Mock -CommandName Get-SPOSite -MockWith {
                return $null
            }
            Mock -CommandName Set-SPOSiteConfiguration -MockWith {
                return $null
            }
            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }
            It "Creates the site collection in the Set method" {
                #Assert-MockCalled Test-SPOServiceConnection -Exactly 5
                Set-TargetResource @testParams
            }
        }

        Context -Name "The site already exists" -Fixture {
            $testParams = @{
                Url                                         = "https://contoso.com/sites/TestSite"
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
                }
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should Be $true
            }
        }

        Context -Name "Deleted site exists" -Fixture {
            $testParams = @{
                Url                                      = "https://contoso.com/sites/TestSite"
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
            }

            Mock -CommandName Get-SPODeletedSite -MockWith {
                return @{
                    Url = "https://contoso.com/sites/TestSite"
                }
            }

            Mock -CommandName Set-SPOSiteConfiguration -MockWith {
                return "site restored successfully"
            }
            It "should find the deleted site" {
                (Get-SPODeletedSite).url | Should Be "https://contoso.com/sites/TestSite"
            }
            It "should restore the deleted site from the recycle bin" {
               Set-TargetResource @testParams | Should Be "site restored successfully"
            }
        }

        Context -Name "Testing site removal" -Fixture {
            $testParams = @{
                Url                                      = "https://contoso.com/sites/TestSite"
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
            }

            Mock -CommandName Get-SPOSite -MockWith {
                return @{
                    Url = "https://contoso.com/sites/TestSite"
                }
            }

            Mock -CommandName Remove-SPOSite -MockWith {
                return "Site has been successfully removed"
            }

            It "Should remove the site successfully" {
                Remove-SPOSite -Identity $testParams.Url -Confirm:$false | Should Be  "Site has been successfully removed"
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
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
