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
    -DscResource "TeamsMeetingBroadcastConfiguration" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString "Pass@word1" -AsPlainText -Force
            $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }
            Mock -CommandName Get-CsTeamsMeetingBroadcastConfiguration -MockWith {
                return @{
                    AllowSdnProviderForBroadcastMeeting = $True;
                    Identity                            = "Global";
                    SdnApiTemplateUrl                   = "https://api.contosoprovider.com/v1/Template";
                    SdnApiToken                         = $ConfigurationData.Settings.SdnApiToken;
                    SdnLicenseId                        = "123456-123456-123456-123456";
                    SdnName                             = "ContosoProvider";
                }
            }
            Mock -CommandName Set-CsTeamsMeetingBroadcastConfiguration -MockWith {
            }
        }

        # Test contexts
        Context -Name "When settings are correctly set" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowSdnProviderForBroadcastMeeting = $True;
                    Identity                            = "Global";
                    SdnApiTemplateUrl                   = "https://api.contosoprovider.com/v1/Template";
                    SdnApiToken                         = $ConfigurationData.Settings.SdnApiToken;
                    SdnLicenseId                        = "123456-123456-123456-123456";
                    SdnProviderName                     = "ContosoProvider";
                    GlobalAdminAccount                  = $GlobalAdminAccount;
                }
            }

            It "Should the SdnProviderName property from the Get method" {
                (Get-TargetResource @testParams).SdnProviderName | Should -Be 'ContosoProvider'
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "When settings are NOT correctly set" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowSdnProviderForBroadcastMeeting = $True;
                    Identity                            = "Global";
                    SdnApiTemplateUrl                   = "https://api.contosoprovider.com/v1/Template";
                    SdnApiToken                         = $ConfigurationData.Settings.SdnApiToken;
                    SdnLicenseId                        = "123456-111111-111111-123456"; #Variant
                    SdnProviderName                     = "ContosoProvider";
                    GlobalAdminAccount                  = $GlobalAdminAccount;
                }
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Updates the settings in the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-CsTeamsMeetingBroadcastConfiguration
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount = $GlobalAdminAccount
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
