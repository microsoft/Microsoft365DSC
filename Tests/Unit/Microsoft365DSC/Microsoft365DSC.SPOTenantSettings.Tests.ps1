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
    -DscResource 'SPOTenantSettings' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            if ($null -eq (Get-Module PnP.PowerShell))
            {
                Import-Module PnP.PowerShell

            }

            $secpasswd = ConvertTo-SecureString 'test@password1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name 'SPO Tenant settings are not configured' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance                              = 'Yes'
                    Credential                                    = $Credential
                    MinCompatibilityLevel                         = 16
                    MaxCompatibilityLevel                         = 16
                    SearchResolveExactEmailOrUPN                  = $false
                    OfficeClientADALDisabled                      = $false
                    LegacyAuthProtocolsEnabled                    = $true
                    SignInAccelerationDomain                      = ''
                    UsePersistentCookiesForExplorerView           = $false
                    UserVoiceForFeedbackEnabled                   = $true
                    PublicCdnEnabled                              = $false
                    PublicCdnAllowedFileTypes                     = 'CSS,EOT,GIF,ICO,JPEG,JPG,JS,MAP,PNG,SVG,TTF,WOFF'
                    UseFindPeopleInPeoplePicker                   = $false
                    NotificationsInSharePointEnabled              = $true
                    OwnerAnonymousNotification                    = $true
                    ApplyAppEnforcedRestrictionsToAdHocRecipients = $true
                    FilePickerExternalImageSearchEnabled          = $true
                    HideDefaultThemes                             = $false
                }

                Mock -CommandName Set-PnPTenant -MockWith {
                    return @{
                        CompatibilityRange                            = '16,16'
                        SearchResolveExactEmailOrUPN                  = $false
                        OfficeClientADALDisabled                      = $false
                        LegacyAuthProtocolsEnabled                    = $true
                        SignInAccelerationDomain                      = ''
                        UsePersistentCookiesForExplorerView           = $false
                        UserVoiceForFeedbackEnabled                   = $true
                        PublicCdnEnabled                              = $false
                        PublicCdnAllowedFileTypes                     = 'CSS,EOT,GIF,ICO,JPEG,JPG,JS,MAP,PNG,SVG,TTF,WOFF'
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
                        CompatibilityRange                            = '16,16'
                        SearchResolveExactEmailOrUPN                  = $false
                        OfficeClientADALDisabled                      = $false
                        LegacyAuthProtocolsEnabled                    = $true
                        SignInAccelerationDomain                      = ''
                        UsePersistentCookiesForExplorerView           = $false
                        UserVoiceForFeedbackEnabled                   = $true
                        PublicCdnEnabled                              = $false
                        PublicCdnAllowedFileTypes                     = 'CSS,EOT,GIF,ICO,JPEG,JPG,JS,MAP,PNG,SVG,TTF,WOFF'
                        UseFindPeopleInPeoplePicker                   = $false
                        NotificationsInSharePointEnabled              = $true
                        OwnerAnonymousNotification                    = $true
                        ApplyAppEnforcedRestrictionsToAdHocRecipients = $true
                        FilePickerExternalImageSearchEnabled          = $true
                        HideDefaultThemes                             = $true
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Sets the tenant AccessControl settings in Set method' {
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
                        CompatibilityRange                            = '16,16'
                        SearchResolveExactEmailOrUPN                  = $false
                        OfficeClientADALDisabled                      = $false
                        LegacyAuthProtocolsEnabled                    = $true
                        SignInAccelerationDomain                      = ''
                        UsePersistentCookiesForExplorerView           = $false
                        UserVoiceForFeedbackEnabled                   = $true
                        PublicCdnEnabled                              = $false
                        PublicCdnAllowedFileTypes                     = 'CSS,EOT,GIF,ICO,JPEG,JPG,JS,MAP,PNG,SVG,TTF,WOFF'
                        UseFindPeopleInPeoplePicker                   = $false
                        NotificationsInSharePointEnabled              = $true
                        OwnerAnonymousNotification                    = $true
                        ApplyAppEnforcedRestrictionsToAdHocRecipients = $true
                        FilePickerExternalImageSearchEnabled          = $true
                        HideDefaultThemes                             = $false
                    }
                } }

            It 'Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }#inmodulescope
}#describe

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
