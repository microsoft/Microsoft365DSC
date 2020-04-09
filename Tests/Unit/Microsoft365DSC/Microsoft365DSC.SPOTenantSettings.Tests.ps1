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
    -DscResource "SPOTenantSettings" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-MSCloudLogin -MockWith {

        }

        # Test contexts
        Context -Name "SPO Tenant settings are not configured" -Fixture {
            $testParams = @{
                IsSingleInstance                              = "Yes"
                GlobalAdminAccount                            = $GlobalAdminAccount
                MinCompatibilityLevel                         = 16
                MaxCompatibilityLevel                         = 16
                SearchResolveExactEmailOrUPN                  = $false
                OfficeClientADALDisabled                      = $false
                LegacyAuthProtocolsEnabled                    = $true
                RequireAcceptingAccountMatchInvitedAccount    = $true
                SignInAccelerationDomain                      = ""
                UsePersistentCookiesForExplorerView           = $false
                UserVoiceForFeedbackEnabled                   = $true
                PublicCdnEnabled                              = $false
                PublicCdnAllowedFileTypes                     = "CSS,EOT,GIF,ICO,JPEG,JPG,JS,MAP,PNG,SVG,TTF,WOFF"
                UseFindPeopleInPeoplePicker                   = $false
                NotificationsInSharePointEnabled              = $true
                OwnerAnonymousNotification                    = $true
                ApplyAppEnforcedRestrictionsToAdHocRecipients = $true
                FilePickerExternalImageSearchEnabled          = $true
                HideDefaultThemes                             = $false
            }

            Mock -CommandName Set-PnPTenant -MockWith {
                return @{
                    CompatibilityRange                            = "16,16"
                    SearchResolveExactEmailOrUPN                  = $false
                    OfficeClientADALDisabled                      = $false
                    LegacyAuthProtocolsEnabled                    = $true
                    RequireAcceptingAccountMatchInvitedAccount    = $true
                    SignInAccelerationDomain                      = ""
                    UsePersistentCookiesForExplorerView           = $false
                    UserVoiceForFeedbackEnabled                   = $true
                    PublicCdnEnabled                              = $false
                    PublicCdnAllowedFileTypes                     = "CSS,EOT,GIF,ICO,JPEG,JPG,JS,MAP,PNG,SVG,TTF,WOFF"
                    UseFindPeopleInPeoplePicker                   = $false
                    NotificationsInSharePointEnabled              = $true
                    OwnerAnonymousNotification                    = $true
                    ApplyAppEnforcedRestrictionsToAdHocRecipients = $true
                    FilePickerExternalImageSearchEnabled          = $true
                    HideDefaultThemes                             = $true
                }
            }

            Mock -CommandName Get-PnPTenant -MockWith {
                return @{
                    CompatibilityRange                            = "16,16"
                    SearchResolveExactEmailOrUPN                  = $false
                    OfficeClientADALDisabled                      = $false
                    LegacyAuthProtocolsEnabled                    = $true
                    RequireAcceptingAccountMatchInvitedAccount    = $true
                    SignInAccelerationDomain                      = ""
                    UsePersistentCookiesForExplorerView           = $false
                    UserVoiceForFeedbackEnabled                   = $true
                    PublicCdnEnabled                              = $false
                    PublicCdnAllowedFileTypes                     = "CSS,EOT,GIF,ICO,JPEG,JPG,JS,MAP,PNG,SVG,TTF,WOFF"
                    UseFindPeopleInPeoplePicker                   = $false
                    NotificationsInSharePointEnabled              = $true
                    OwnerAnonymousNotification                    = $true
                    ApplyAppEnforcedRestrictionsToAdHocRecipients = $true
                    FilePickerExternalImageSearchEnabled          = $true
                    HideDefaultThemes                             = $true
                }
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Sets the tenant AccessControl settings in Set method" {
                set-TargetResource @testParams
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-PnPTenant -MockWith {
                return @{
                    CompatibilityRange                            = "16,16"
                    SearchResolveExactEmailOrUPN                  = $false
                    OfficeClientADALDisabled                      = $false
                    LegacyAuthProtocolsEnabled                    = $true
                    RequireAcceptingAccountMatchInvitedAccount    = $true
                    SignInAccelerationDomain                      = ""
                    UsePersistentCookiesForExplorerView           = $false
                    UserVoiceForFeedbackEnabled                   = $true
                    PublicCdnEnabled                              = $false
                    PublicCdnAllowedFileTypes                     = "CSS,EOT,GIF,ICO,JPEG,JPG,JS,MAP,PNG,SVG,TTF,WOFF"
                    UseFindPeopleInPeoplePicker                   = $false
                    NotificationsInSharePointEnabled              = $true
                    OwnerAnonymousNotification                    = $true
                    ApplyAppEnforcedRestrictionsToAdHocRecipients = $true
                    FilePickerExternalImageSearchEnabled          = $true
                    HideDefaultThemes                             = $false
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }#inmodulescope
}#describe

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
