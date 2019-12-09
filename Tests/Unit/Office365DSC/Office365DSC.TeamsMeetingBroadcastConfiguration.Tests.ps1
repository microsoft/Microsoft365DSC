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
    -DscResource "TeamsMeetingBroadcastConfiguration"

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "Pass@word1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-MSCloudLogin -MockWith {
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

        # Test contexts
        Context -Name "When settings are correctly set" -Fixture {
            $testParams = @{
                AllowSdnProviderForBroadcastMeeting = $True;
                Identity                            = "Global";
                SdnApiTemplateUrl                   = "https://api.contosoprovider.com/v1/Template";
                SdnApiToken                         = $ConfigurationData.Settings.SdnApiToken;
                SdnLicenseId                        = "123456-123456-123456-123456";
                SdnProviderName                     = "ContosoProvider";
                GlobalAdminAccount                  = $GlobalAdminAccount;
            }

            It "Should the SdnName property from the Get method" {
                (Get-TargetResource @testParams).SdnName | Should Be 'ContosoProvider'
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should Be $true
            }
        }

        Context -Name "When settings are NOT correctly set" -Fixture {
            $testParams = @{
                AllowSdnProviderForBroadcastMeeting = $True;
                Identity                            = "Global";
                SdnApiTemplateUrl                   = "https://api.contosoprovider.com/v1/Template";
                SdnApiToken                         = $ConfigurationData.Settings.SdnApiToken;
                SdnLicenseId                        = "123456-111111-111111-123456"; #Variant
                SdnName                             = "ContosoProvider";
                GlobalAdminAccount                  = $GlobalAdminAccount;
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Updates the settings in the Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled Set-CsTeamsMeetingBroadcastConfiguration
            }
        }


        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
