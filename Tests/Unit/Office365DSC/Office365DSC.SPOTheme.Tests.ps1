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
                                                -DscResource "SPOTheme"

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
        Context -Name "The theme doesn't exist" -Fixture {
            $testParams = @{
                Name               = "TestTheme"
                IsInverted         = $false
                Palette            = '{
                                                   "themePrimary": "#0078d4",
                                                   "themeLighterAlt": "#eff6fc",
                                                   "themeLighter": "#deecf9",
                                                   "themeLight": "#c7e0f4",
                                                   "themeTertiary": "#71afe5",
                                                   "themeSecondary": "#2b88d8",
                                                   "themeDarkAlt": "#106ebe",
                                                   "themeDark": "#005a9e",
                                                   "themeDarker": "#004578",
                                                   "neutralLighterAlt": "#f8f8f8",
                                                   "neutralLighter": "#f4f4f4",
                                                   "neutralLight": "#eaeaea",
                                                   "neutralQuaternaryAlt": "#dadada",
                                                   "neutralQuaternary": "#d0d0d0",
                                                   "neutralTertiaryAlt": "#c8c8c8",
                                                   "neutralTertiary": "#c2c2c2",
                                                   "neutralSecondary": "#858585",
                                                   "neutralPrimaryAlt": "#4b4b4b",
                                                   "neutralPrimary": "#333",
                                                   "neutralDark": "#272727",
                                                   "black": "#1d1d1d",
                                                   "white": "#fff",
                                                   "bodyBackground": "#0078d4",
                                                   "bodyText": "#fff"
                                            }'
                CentralAdminUrl    = "https://contoso-admin.sharepoint.com"
                GlobalAdminAccount = $GlobalAdminAccount
                Ensure             = "Absent"
            }

            Mock -CommandName Add-SPOTheme -MockWith {
                return @{Name = $null}
            }

            Mock -CommandName Get-SPOTheme -MockWith {
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

        Context -Name "The theme already exists" -Fixture {
            $testParams = @{
                Name               = "TestTheme"
                IsInverted         = $false
                Palette            = '{
                                           "themePrimary": "#0078d4",
                                           "themeLighterAlt": "#eff6fc",
                                           "themeLighter": "#deecf9",
                                           "themeLight": "#c7e0f4",
                                           "themeTertiary": "#71afe5",
                                           "themeSecondary": "#2b88d8",
                                           "themeDarkAlt": "#106ebe",
                                           "themeDark": "#005a9e",
                                           "themeDarker": "#004578",
                                           "neutralLighterAlt": "#f8f8f8",
                                           "neutralLighter": "#f4f4f4",
                                           "neutralLight": "#eaeaea",
                                           "neutralQuaternaryAlt": "#dadada",
                                           "neutralQuaternary": "#d0d0d0",
                                           "neutralTertiaryAlt": "#c8c8c8",
                                           "neutralTertiary": "#c2c2c2",
                                           "neutralSecondary": "#858585",
                                           "neutralPrimaryAlt": "#4b4b4b",
                                           "neutralPrimary": "#333",
                                           "neutralDark": "#272727",
                                           "black": "#1d1d1d",
                                           "white": "#fff",
                                           "bodyBackground": "#0078d4",
                                           "bodyText": "#fff"
                                    }'
                CentralAdminUrl    = "https://contoso-admin.sharepoint.com"
                GlobalAdminAccount = $GlobalAdminAccount
                Ensure             = "Present"
            }

            Mock -CommandName Get-SPOTheme -MockWith {
                return @{
                    Name               = "TestTheme"
                    IsInverted         = $false
                    Palette            = '{
                                                "themePrimary": "#0078d4",
                                                "themeLighterAlt": "#eff6fc",
                                                "themeLighter": "#deecf9",
                                                "themeLight": "#c7e0f4",
                                                "themeTertiary": "#71afe5",
                                                "themeSecondary": "#2b88d8",
                                                "themeDarkAlt": "#106ebe",
                                                "themeDark": "#005a9e",
                                                "themeDarker": "#004578",
                                                "neutralLighterAlt": "#f8f8f8",
                                                "neutralLighter": "#f4f4f4",
                                                "neutralLight": "#eaeaea",
                                                "neutralQuaternaryAlt": "#dadada",
                                                "neutralQuaternary": "#d0d0d0",
                                                "neutralTertiaryAlt": "#c8c8c8",
                                                "neutralTertiary": "#c2c2c2",
                                                "neutralSecondary": "#858585",
                                                "neutralPrimaryAlt": "#4b4b4b",
                                                "neutralPrimary": "#333",
                                                "neutralDark": "#272727",
                                                "black": "#1d1d1d",
                                                "white": "#fff",
                                                "bodyBackground": "#0078d4",
                                                "bodyText": "#fff"
                                            }'
                    CentralAdminUrl    = "https://contoso-admin.sharepoint.com"
                    GlobalAdminAccount = $GlobalAdminAccount
                    Ensure             = "Present"
                    
                }
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }
        }

        Context -Name "Testing theme removal" -Fixture {
            $testParams = @{
                Name               = "TestTheme"
                IsInverted         = $false
                Palette            = '{
                                        "themePrimary": "#0078d4",
                                        "themeLighterAlt": "#eff6fc",
                                        "themeLighter": "#deecf9",
                                        "themeLight": "#c7e0f4",
                                        "themeTertiary": "#71afe5",
                                        "themeSecondary": "#2b88d8",
                                        "themeDarkAlt": "#106ebe",
                                        "themeDark": "#005a9e",
                                        "themeDarker": "#004578",
                                        "neutralLighterAlt": "#f8f8f8",
                                        "neutralLighter": "#f4f4f4",
                                        "neutralLight": "#eaeaea",
                                        "neutralQuaternaryAlt": "#dadada",
                                        "neutralQuaternary": "#d0d0d0",
                                        "neutralTertiaryAlt": "#c8c8c8",
                                        "neutralTertiary": "#c2c2c2",
                                        "neutralSecondary": "#858585",
                                        "neutralPrimaryAlt": "#4b4b4b",
                                        "neutralPrimary": "#333",
                                        "neutralDark": "#272727",
                                        "black": "#1d1d1d",
                                        "white": "#fff",
                                        "bodyBackground": "#0078d4",
                                        "bodyText": "#fff"
                                    }'
                CentralAdminUrl    = "https://contoso-admin.sharepoint.com"
                GlobalAdminAccount = $GlobalAdminAccount
                Ensure             = "Present"
            }

            Mock -CommandName Get-SPOTheme -MockWith {
                return @{
                    Name = "TestTheme"
                }
            }

            Mock -CommandName Remove-SPOTheme -MockWith {
                return "Theme has been successfully removed"
            }

            It "Should remove the Theme successfully" {
                Remove-SPOTheme -Name $testParams.Name -Confirm:$false | Should Be  "Theme has been successfully removed"
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                Name                = "TestTheme"
                CentralAdminUrl     = "https://contoso-admin.sharepoint.com"
                GlobalAdminAccount  = $GlobalAdminAccount
            }

            Mock -CommandName Get-SPOTheme -MockWith {
                return @{
                    Name               = "TestTheme"
                    IsInverted         = $false
                    Palette            = '{
                                            "themePrimary": "#0078d4",
                                            "themeLighterAlt": "#eff6fc",
                                            "themeLighter": "#deecf9",
                                            "themeLight": "#c7e0f4",
                                            "themeTertiary": "#71afe5",
                                            "themeSecondary": "#2b88d8",
                                            "themeDarkAlt": "#106ebe",
                                            "themeDark": "#005a9e",
                                            "themeDarker": "#004578",
                                            "neutralLighterAlt": "#f8f8f8",
                                            "neutralLighter": "#f4f4f4",
                                            "neutralLight": "#eaeaea",
                                            "neutralQuaternaryAlt": "#dadada",
                                            "neutralQuaternary": "#d0d0d0",
                                            "neutralTertiaryAlt": "#c8c8c8",
                                            "neutralTertiary": "#c2c2c2",
                                            "neutralSecondary": "#858585",
                                            "neutralPrimaryAlt": "#4b4b4b",
                                            "neutralPrimary": "#333",
                                            "neutralDark": "#272727",
                                            "black": "#1d1d1d",
                                            "white": "#fff",
                                            "bodyBackground": "#0078d4",
                                            "bodyText": "#fff"
                                    }'
                    CentralAdminUrl    = "https://contoso-admin.sharepoint.com"
                    GlobalAdminAccount = $GlobalAdminAccount
                    Ensure             = "Present"
                    
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
