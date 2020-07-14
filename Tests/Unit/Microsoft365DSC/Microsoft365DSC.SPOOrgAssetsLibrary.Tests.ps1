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
    -DscResource "SPOOrgAssetsLibrary" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
            $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin@contoso.com", $secpasswd)
            $global:tenantName = $GlobalAdminAccount.UserName.Split('@')[1].Split('.')[0]

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }

            Mock -CommandName Get-PSSession -MockWith {

            }
            Mock -CommandName Remove-PSSession -MockWith {

            }

            Mock -CommandName Remove-PNPOrgAssetsLibrary -MockWith {

            }

            Mock -CommandName Add-PnPOrgAssetsLibrary -MockWith {

            }

            Mock -CommandName Get-M365TenantName -MockWith {
                return 'contoso'
            }
        }

        # Test contexts
        Context -Name "The site assets org library should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    LibraryUrl         = "https://contoso.sharepoint.com/sites/m365dsc/Branding"
                    CdnType            = "Public"
                    GlobalAdminAccount = $GlobalAdminAccount;
                    Ensure             = "Present"
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName Get-PnPTenantCdnEnabled -MockWith {
                    return @{ Value = "true" }
                }

                Mock -CommandName Get-PNPOrgAssetsLibrary -MockWith {
                    return $null
                }
            }
            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
                Should -Invoke -CommandName "Get-PNPOrgAssetsLibrary" -Exactly 1
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should Create the site assets org libary from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName "Add-PNPOrgAssetsLibrary" -Exactly 1
            }
        }

        Context -Name "The site assets org library exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    LibraryUrl         = "https://contoso.sharepoint.com/sites/m365dsc/Branding"
                    CdnType            = "Public"
                    GlobalAdminAccount = $GlobalAdminAccount;
                    Ensure             = "Absent"
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName Get-PnPTenantCdnEnabled -MockWith {
                    return @{ Value = "true" }
                }

                Mock -CommandName Get-PNPOrgAssetsLibrary -MockWith {
                    return @{
                        OrgAssetsLibraries = @{
                            LibraryUrl = @{
                                decodedurl = "sites/m365dsc/Branding"
                            }
                        }
                        CdnType            = "Public"
                    }
                }
            }

            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
                Should -Invoke -CommandName "Get-PNPOrgAssetsLibrary" -Exactly 1
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the site assets org library from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName "Remove-PNPOrgAssetsLibrary" -Exactly 1
            }
        }
        Context -Name "The site assets org library Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    LibraryUrl         = "https://contoso.sharepoint.com/sites/m365dsc/Branding"
                    CdnType            = "Public"
                    GlobalAdminAccount = $GlobalAdminAccount;
                    Ensure             = "Present"
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName Get-M365TenantName -MockWith {
                    return 'contoso'
                }

                Mock -CommandName Get-PnPTenantCdnEnabled -MockWith {
                    return @{ Value = "true" }
                }

                Mock -CommandName Get-PNPOrgAssetsLibrary -MockWith {
                    return @{
                        OrgAssetsLibraries = @{
                            LibraryUrl = @{
                                decodedurl = "sites/m365dsc/Branding"
                            }
                        }
                        CdnType            = "Public"
                    }
                }
            }

            It "Should return Values from the Get method" {
                Get-TargetResource @testParams
                Should -Invoke -CommandName "Get-PNPOrgAssetsLibrary" -Exactly 1
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The site assets org library exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    LibraryUrl         = "https://contoso.sharepoint.com/sites/m365dsc/Branding"
                    CdnType            = "Public"
                    GlobalAdminAccount = $GlobalAdminAccount;
                    Ensure             = "Present"
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName Get-PNPOrgAssetsLibrary -MockWith {
                    return @{
                        OrgAssetsLibraries = @{
                            LibraryUrl = @{
                                decodedurl = "sites/m365dsc/Missing"
                            }
                        }
                        CdnType            = "Public"
                        GlobalAdminAccount = $GlobalAdminAccount;
                        Ensure             = "Present"
                    }
                }

                Mock -CommandName Get-PnPTenantCdnEnabled -MockWith {
                    return @{ Value = "True" }
                }
            }

            It "Should return Values from the Get method" {
                Get-TargetResource @testParams
                Should -Invoke -CommandName "Get-PNPOrgAssetsLibrary" -Exactly 1
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Add-PNPOrgAssetsLibrary' -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName Get-M365TenantName -MockWith {
                    return 'contoso'
                }

                Mock -CommandName Get-PnPTenantCdnEnabled -MockWith {
                    return @{ Value = "true" }
                }

                Mock -CommandName Get-PNPOrgAssetsLibrary -MockWith {
                    return @{
                        LibraryUrl = "https://contoso.sharepoint.com/sites/m365dsc/Branding"
                        CdnType    = "Private"
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
