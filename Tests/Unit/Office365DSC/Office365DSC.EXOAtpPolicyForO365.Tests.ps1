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
    -DscResource "EXOAtpPolicyForO365"
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Close-SessionsAndReturnError -MockWith {

        }

        Mock -CommandName Connect-ExchangeOnline -MockWith {

        }

        Mock -CommandName Get-PSSession -MockWith {

        }

        Mock -CommandName Remove-PSSession -MockWith {

        }

        Mock -CommandName Get-AtpPolicyForO365 -MockWith {

        }

        Mock -CommandName Set-AtpPolicyForO365 -MockWith {

        }

        # Test contexts
        Context -Name "AtpPolicyForO365 update not required." -Fixture {
            $testParams = @{
                IsSingleInstance          = 'Yes'
                Ensure                    = 'Present'
                Identity                  = 'Default'
                GlobalAdminAccount        = $GlobalAdminAccount
                AllowClickThrough         = $false
                BlockUrls                 = @()
                EnableATPForSPOTeamsODB   = $true
                EnableSafeLinksForClients = $true
                TrackClicks               = $true
            }

            Mock -CommandName Get-AtpPolicyForO365 -MockWith {
                return @{
                    IsSingleInstance          = 'Yes'
                    Ensure                    = 'Present'
                    Identity                  = 'Default'
                    GlobalAdminAccount        = $GlobalAdminAccount
                    AllowClickThrough         = $false
                    BlockUrls                 = @()
                    EnableATPForSPOTeamsODB   = $true
                    EnableSafeLinksForClients = $true
                    TrackClicks               = $true
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should Be $true
            }
        }

        Context -Name "AtpPolicyForO365 update needed." -Fixture {
            $testParams = @{
                IsSingleInstance          = 'Yes'
                Ensure                    = 'Present'
                Identity                  = 'Default'
                GlobalAdminAccount        = $GlobalAdminAccount
                AllowClickThrough         = $false
                BlockUrls                 = @()
                EnableATPForSPOTeamsODB   = $true
                EnableSafeLinksForClients = $true
                TrackClicks               = $true
            }
            Mock -CommandName Get-AtpPolicyForO365 -MockWith {
                return @{
                    IsSingleInstance          = 'Yes'
                    Ensure                    = 'Present'
                    Identity                  = 'Default'
                    GlobalAdminAccount        = $GlobalAdminAccount
                    AllowClickThrough         = $false
                    BlockUrls                 = @()
                    EnableATPForSPOTeamsODB   = $false
                    EnableSafeLinksForClients = $false
                    TrackClicks               = $false
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            $testParams = @{
                IsSingleInstance   = 'Yes'
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-AtpPolicyForO365 -MockWith {
                return @{
                    Identity                  = 'Default'
                    AllowClickThrough         = $false
                    BlockUrls                 = @()
                    EnableATPForSPOTeamsODB   = $false
                    EnableSafeLinksForClients = $false
                    TrackClicks               = $false
                }
            }

            It 'Should Reverse Engineer resource from the Export method' {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
