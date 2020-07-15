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
    -DscResource "SPOAccessControlSettings" -GenericStubModule $GenericStubPath

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
        Context -Name "PNP AccessControl settings are not configured" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount           = $GlobalAdminAccount
                    IsSingleInstance             = "Yes"
                    DisplayStartASiteOption      = $false
                    StartASiteFormUrl            = "https://o365dsc1.sharepoint.com"
                    IPAddressEnforcement         = $false
                    #IPAddressAllowList           = "" #would generate an error while writing this resource
                    IPAddressWACTokenLifetime    = 15
                    CommentsOnSitePagesDisabled  = $false
                    SocialBarOnSitePagesDisabled = $false
                    DisallowInfectedFileDownload = $false
                    ExternalServicesEnabled      = $true
                    EmailAttestationRequired     = $false
                    EmailAttestationReAuthDays   = 30
                }

                Mock -CommandName Set-PnPTenant -MockWith {
                    return @{
                        DisplayStartASiteOption      = $false
                        StartASiteFormUrl            = "https://o365dsc1.sharepoint.com"
                        IPAddressEnforcement         = $false
                        #IPAddressAllowList           = "" #would generate an error while writing this resource
                        IPAddressWACTokenLifetime    = 15
                        CommentsOnSitePagesDisabled  = $false
                        SocialBarOnSitePagesDisabled = $false
                        DisallowInfectedFileDownload = $false
                        ExternalServicesEnabled      = $true
                        EmailAttestationRequired     = $false
                        EmailAttestationReAuthDays   = 30
                    }
                }

                Mock -CommandName Get-PnPTenant -MockWith {
                    return @{
                        DisplayStartASiteOption      = $true
                        StartASiteFormUrl            = "https://o365dsc1.sharepoint.com"
                        IPAddressEnforcement         = $false
                        #IPAddressAllowList           = "" #would generate an error while writing this resource
                        IPAddressWACTokenLifetime    = 20
                        CommentsOnSitePagesDisabled  = $true
                        SocialBarOnSitePagesDisabled = $false
                        DisallowInfectedFileDownload = $false
                        ExternalServicesEnabled      = $true
                        EmailAttestationRequired     = $false
                        EmailAttestationReAuthDays   = 29
                    }
                }
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Sets the tenant AccessControl settings in Set method" {
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
                        DisplayStartASiteOption      = $false
                        StartASiteFormUrl            = "https://o365dsc1.sharepoint.com"
                        IPAddressEnforcement         = $false
                        #IPAddressAllowList           = "" #would generate an error while writing this resource
                        IPAddressWACTokenLifetime    = 15
                        CommentsOnSitePagesDisabled  = $false
                        SocialBarOnSitePagesDisabled = $false
                        DisallowInfectedFileDownload = $false
                        ExternalServicesEnabled      = $true
                        EmailAttestationRequired     = $false
                        EmailAttestationReAuthDays   = 30
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
