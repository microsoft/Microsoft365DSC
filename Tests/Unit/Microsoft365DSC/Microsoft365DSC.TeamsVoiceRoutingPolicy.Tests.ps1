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
    -DscResource "TeamsVoiceRoutingPolicy" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "Pass@word1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-MSCloudLogin -MockWith {
        }

        Mock -CommandName New-CsOnlineVoiceRoutingPolicy -MockWith {
        }

        Mock -CommandName Set-CsOnlineVoiceRoutingPolicy -MockWith {
        }

        Mock -CommandName Remove-CsOnlineVoiceRoutingPolicy -MockWith {
        }

        Mock -CommandName Get-CsOnlinePstnUsage -MockWith {
            return New-Object PSObject -Property @{
                Identity               = 'Global'
                Usage                  = @('Local', 'Long Distance')
            }
        }

        # Test contexts
        Context -Name "When the policy doesn't already exist" -Fixture {
            $testParams = @{
                Identity               = 'Test Policy'
                OnlinePstnUsages       = @('Local', 'Long Distance')
                Description            = 'My Test Policy'
                Ensure                 = 'Present'
                GlobalAdminAccount     = $GlobalAdminAccount;
            }

            Mock -CommandName Get-CsOnlineVoiceRoutingPolicy -MockWith {
                return $null
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be 'Absent'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should create the policy from the Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled -CommandName "New-CsOnlineVoiceRoutingPolicy" -Exactly 1
            }
        }

        Context -Name "When the policy already exists and is NOT in the Desired State" -Fixture {
            $testParams = @{
                Identity               = 'Test Policy'
                OnlinePstnUsages       = @('Local', 'Long Distance')
                Description            = 'My Test Policy'
                Ensure                 = 'Present'
                GlobalAdminAccount     = $GlobalAdminAccount;
            }

            Mock -CommandName Get-CsOnlineVoiceRoutingPolicy -MockWith {
                return @{
                    Identity               = 'Test Policy'
                    OnlinePstnUsages       = @('Local') #Drift
                    Description            = 'My Test Policy'
                }
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should update the policy from the Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled Set-CsOnlineVoiceRoutingPolicy -Exactly 1
            }
        }

        Context -Name "When the policy already exists and IS in the Desired State" -Fixture {
            $testParams = @{
                Identity               = 'Test Policy'
                OnlinePstnUsages       = @('Local', 'Long Distance')
                Description            = 'My Test Policy'
                Ensure                 = 'Present'
                GlobalAdminAccount     = $GlobalAdminAccount;
            }

            Mock -CommandName Get-CsOnlineVoiceRoutingPolicy -MockWith {
                return @{
                    Identity               = 'Test Policy'
                    OnlinePstnUsages       = @('Local', 'Long Distance')
                    Description            = 'My Test Policy'
                }
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should Be $true
            }
        }

        Context -Name "When the policy already exists but it SHOULD NOT" -Fixture {
            $testParams = @{
                Identity               = 'Test Policy'
                Ensure                 = 'Absent'
                GlobalAdminAccount     = $GlobalAdminAccount;
            }

            Mock -CommandName Get-CsOnlineVoiceRoutingPolicy -MockWith {
                return @{
                    Identity               = 'Test Policy'
                    OnlinePstnUsages       = @('Local')
                    Description            = 'My Test Policy'
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be 'Present'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should remove the policy from the Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled Remove-CsOnlineVoiceRoutingPolicy -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount     = $GlobalAdminAccount;
            }

            Mock -CommandName Get-CsOnlineVoiceRoutingPolicy -MockWith {
                return @{
                    Identity               = 'Test Policy'
                    OnlinePstnUsages       = @('Local')
                    Description            = 'My Test Policy'
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
