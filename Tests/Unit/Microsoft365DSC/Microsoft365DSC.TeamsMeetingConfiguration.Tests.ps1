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
    -DscResource "TeamsMeetingConfiguration" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "Pass@word1)" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-MSCloudLogin -MockWith {
        }
        Mock -CommandName Get-CsTeamsMeetingConfiguration -MockWith {
            return @{
                ClientAppSharingPort        = 50040;
                ClientAppSharingPortRange   = 20;
                ClientAudioPort             = 50000;
                ClientAudioPortRange        = 20;
                ClientMediaPortRangeEnabled = $True;
                ClientVideoPort             = 50020;
                ClientVideoPortRange        = 20;
                CustomFooterText            = $null;
                DisableAnonymousJoin        = $False;
                EnableQoS                   = $False;
                HelpURL                     = $null;
                Identity                    = "Global";
                LegalURL                    = $null;
                LogoURL                     = $null;
            }
        }
        Mock -CommandName Set-CsTeamsMeetingConfiguration -MockWith {
        }

        # Test contexts
        Context -Name "When settings are correctly set" -Fixture {
            $testParams = @{
                ClientAppSharingPort        = 50040;
                ClientAppSharingPortRange   = 20;
                ClientAudioPort             = 50000;
                ClientAudioPortRange        = 20;
                ClientMediaPortRangeEnabled = $True;
                ClientVideoPort             = 50020;
                ClientVideoPortRange        = 20;
                CustomFooterText            = $null;
                DisableAnonymousJoin        = $False;
                EnableQoS                   = $False;
                GlobalAdminAccount          = $GlobalAdminAccount;
                HelpURL                     = $null;
                Identity                    = "Global";
                LegalURL                    = $null;
                LogoURL                     = $null;
            }

            It "Should return 20 for the ClientVideoPortRange property from the Get method" {
                (Get-TargetResource @testParams).ClientVideoPortRange | Should Be 20
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should Be $true
            }
        }

        Context -Name "When settings are NOT correctly set" -Fixture {
            $testParams = @{
                ClientAppSharingPort        = 50040;
                ClientAppSharingPortRange   = 20;
                ClientAudioPort             = 50000;
                ClientAudioPortRange        = 20;
                ClientMediaPortRangeEnabled = $True;
                ClientVideoPort             = 50020;
                ClientVideoPortRange        = 21; #Variant
                CustomFooterText            = $null;
                DisableAnonymousJoin        = $False;
                EnableQoS                   = $False;
                GlobalAdminAccount          = $GlobalAdminAccount;
                HelpURL                     = $null;
                Identity                    = "Global";
                LegalURL                    = $null;
                LogoURL                     = $null;
            }

            It "Should return 20 for the ClientVideoPortRange property from the Get method" {
                (Get-TargetResource @testParams).ClientVideoPortRange | Should Be 20
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Updates the Teams Client settings in the Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled Set-CsTeamsMeetingConfiguration -Exactly 1
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
