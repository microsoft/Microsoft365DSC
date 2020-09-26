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
    -DscResource "SPOTheme" -GenericStubModule $GenericStubPath

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

            Mock -CommandName Add-PnPTenantTheme -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }
        }

        # Test contexts
        Context -Name "The theme doesn't exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    Name               = "TestTheme"
                    IsInverted         = $false
                    Palette            = (New-CimInstance -ClassName MSFT_SPOThemePaletteProperty -Property @{
                            Property = "themePrimary"
                            Value    = "#eff6fc"
                        } -ClientOnly)
                    GlobalAdminAccount = $GlobalAdminAccount
                    Ensure             = "Present"
                }

                Mock -CommandName Add-PnPTenantTheme -MockWith {
                    return @{
                        Name = $null
                    }
                }

                Mock -CommandName Get-PnPTenantTheme -MockWith {
                    return $null
                }
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be "Absent"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Creates the theme in the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "The theme already exists" -Fixture {
            BeforeAll {
                $testParams = @{
                    Name               = "TestTheme"
                    IsInverted         = $false
                    Palette            = (New-CimInstance -ClassName MSFT_SPOThemePaletteProperty -Property @{
                            Property = "themePrimary"
                            Value    = "#eff6fc"
                        } -ClientOnly)
                    GlobalAdminAccount = $GlobalAdminAccount
                    Ensure             = "Present"
                }

                Mock -CommandName Get-PnPTenantTheme -MockWith {
                    return @{
                        Name       = "TestTheme"
                        IsInverted = $true
                        Palette    = @{
                            "themePrimary"         = "#0078d4";
                            "themeLighterAlt"      = "#eff6fc";
                            "themeLighter"         = "#deecf9";
                            "themeLight"           = "#c7e0f4";
                            "themeTertiary"        = "#71afe5";
                            "themeSecondary"       = "#2b88d8";
                            "themeDarkAlt"         = "#106ebe";
                            "themeDark"            = "#005a9e";
                            "themeDarker"          = "#004578";
                            "neutralLighterAlt"    = "#f8f8f8";
                            "neutralLighter"       = "#f4f4f4";
                            "neutralLight"         = "#eaeaea";
                            "neutralQuaternaryAlt" = "#dadada";
                            "neutralQuaternary"    = "#d0d0d0";
                            "neutralTertiaryAlt"   = "#c8c8c8";
                            "neutralTertiary"      = "#c2c2c2";
                            "neutralSecondary"     = "#858585";
                            "neutralPrimaryAlt"    = "#4b4b4b";
                            "neutralPrimary"       = "#333";
                            "neutralDark"          = "#272727";
                            "black"                = "#1d1d1d";
                            "white"                = "#fff";
                            "bodyBackground"       = "#0078d4";
                            "bodyText"             = "#fff";
                        }
                    }
                }
            }

            It "Should update the Theme from the Set method" {
                Set-TargetResource @testParams
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }
        }

        Context -Name "Testing theme removal" -Fixture {
            BeforeAll {
                $testParams = @{
                    Name               = "TestTheme"
                    IsInverted         = $false
                    Palette            = (New-CimInstance -ClassName MSFT_SPOThemePaletteProperty -Property @{
                            Property = "themePrimary"
                            Value    = "#eff6fc"
                        } -ClientOnly)
                    GlobalAdminAccount = $GlobalAdminAccount
                    Ensure             = "Present"
                }

                Mock -CommandName Get-PnPTenantTheme -MockWith {
                    return @{
                        Name       = "TestTheme"
                        IsInverted = $true
                        Palette    = @{
                            "themePrimary"         = "#0078d4";
                            "themeLighterAlt"      = "#eff6fc";
                            "themeLighter"         = "#deecf9";
                            "themeLight"           = "#c7e0f4";
                            "themeTertiary"        = "#71afe5";
                            "themeSecondary"       = "#2b88d8";
                            "themeDarkAlt"         = "#106ebe";
                            "themeDark"            = "#005a9e";
                            "themeDarker"          = "#004578";
                            "neutralLighterAlt"    = "#f8f8f8";
                            "neutralLighter"       = "#f4f4f4";
                            "neutralLight"         = "#eaeaea";
                            "neutralQuaternaryAlt" = "#dadada";
                            "neutralQuaternary"    = "#d0d0d0";
                            "neutralTertiaryAlt"   = "#c8c8c8";
                            "neutralTertiary"      = "#c2c2c2";
                            "neutralSecondary"     = "#858585";
                            "neutralPrimaryAlt"    = "#4b4b4b";
                            "neutralPrimary"       = "#333";
                            "neutralDark"          = "#272727";
                            "black"                = "#1d1d1d";
                            "white"                = "#fff";
                            "bodyBackground"       = "#0078d4";
                            "bodyText"             = "#fff";
                        }
                    }
                }

                Mock -CommandName Remove-PnPTenantTheme -MockWith {
                    return "Theme has been successfully removed"
                }
            }

            It "Should remove the Theme successfully" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName Get-PnPTenantTheme -MockWith {
                    return @{
                        Name               = "TestTheme"
                        IsInverted         = $false
                        Palette            = @{
                            "themePrimary"         = "#0078d4";
                            "themeLighterAlt"      = "#eff6fc";
                            "themeLighter"         = "#deecf9";
                            "themeLight"           = "#c7e0f4";
                            "themeTertiary"        = "#71afe5";
                            "themeSecondary"       = "#2b88d8";
                            "themeDarkAlt"         = "#106ebe";
                            "themeDark"            = "#005a9e";
                            "themeDarker"          = "#004578";
                            "neutralLighterAlt"    = "#f8f8f8";
                            "neutralLighter"       = "#f4f4f4";
                            "neutralLight"         = "#eaeaea";
                            "neutralQuaternaryAlt" = "#dadada";
                            "neutralQuaternary"    = "#d0d0d0";
                            "neutralTertiaryAlt"   = "#c8c8c8";
                            "neutralTertiary"      = "#c2c2c2";
                            "neutralSecondary"     = "#858585";
                            "neutralPrimaryAlt"    = "#4b4b4b";
                            "neutralPrimary"       = "#333";
                            "neutralDark"          = "#272727";
                            "black"                = "#1d1d1d";
                            "white"                = "#fff";
                            "bodyBackground"       = "#0078d4";
                            "bodyText"             = "#fff";
                        }
                        GlobalAdminAccount = $GlobalAdminAccount
                        Ensure             = "Present"
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
