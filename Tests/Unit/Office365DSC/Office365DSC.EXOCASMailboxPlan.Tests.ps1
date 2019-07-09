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
    -DscResource "EXOCASMailboxPlan"
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

        Mock -CommandName Set-CASMailboxPlan -MockWith {

        }

        # Test contexts
        Context -Name "CASMailboxPlan update not required." -Fixture {
            $testParams = @{
                Ensure             = 'Present'
                Identity           = 'ExchangeOnlineEnterprise-6f6c267b-f8db-4020-b441-f7bd966a0ca0'
                GlobalAdminAccount = $GlobalAdminAccount
                ActiveSyncEnabled  = $true
                ImapEnabled        = $true
                OwaMailboxPolicy   = 'OwaMailboxPolicy-Default'
                PopEnabled         = $true
            }

            Mock -CommandName Get-CASMailboxPlan -MockWith {
                return @{
                    Ensure             = 'Present'
                    Identity           = 'ExchangeOnlineEnterprise-6f6c267b-f8db-4020-b441-f7bd966a0ca0'
                    GlobalAdminAccount = $GlobalAdminAccount
                    ActiveSyncEnabled  = $true
                    ImapEnabled        = $true
                    OwaMailboxPolicy   = 'OwaMailboxPolicy-Default'
                    PopEnabled         = $true
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should Be $true
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should not update anything in the Set Method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "CASMailboxPlan update needed." -Fixture {
            $testParams = @{
                Ensure             = 'Present'
                Identity           = 'ExchangeOnlineEnterprise-6f6c267b-f8db-4020-b441-f7bd966a0ca0'
                GlobalAdminAccount = $GlobalAdminAccount
                ActiveSyncEnabled  = $true
                ImapEnabled        = $true
                OwaMailboxPolicy   = 'OwaMailboxPolicy-Default'
                PopEnabled         = $true
            }
            Mock -CommandName Get-CASMailboxPlan -MockWith {
                return @{
                    Ensure             = 'Present'
                    Identity           = 'ExchangeOnlineEnterprise-6f6c267b-f8db-4020-b441-f7bd966a0ca0'
                    GlobalAdminAccount = $GlobalAdminAccount
                    ActiveSyncEnabled  = $false
                    ImapEnabled        = $false
                    OwaMailboxPolicy   = 'OwaMailboxPolicy-Default'
                    PopEnabled         = $false
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
                Identity           = 'ExchangeOnlineEnterprise-6f6c267b-f8db-4020-b441-f7bd966a0ca0'
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-CASMailboxPlan -MockWith {
                return @{
                    Ensure             = 'Present'
                    Identity           = 'ExchangeOnlineEnterprise-6f6c267b-f8db-4020-b441-f7bd966a0ca0'
                    GlobalAdminAccount = $GlobalAdminAccount
                    ActiveSyncEnabled  = $true
                    ImapEnabled        = $true
                    OwaMailboxPolicy   = 'OwaMailboxPolicy-Default'
                    PopEnabled         = $true
                }
            }

            It 'Should Reverse Engineer resource from the Export method' {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
