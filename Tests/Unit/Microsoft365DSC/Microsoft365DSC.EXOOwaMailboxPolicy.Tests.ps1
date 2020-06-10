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
    -DscResource "EXOOwaMailboxPolicy" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-MSCloudLogin -MockWith {

        }

        Mock -CommandName Get-PSSession -MockWith {

        }

        Mock -CommandName Remove-PSSession -MockWith {

        }

        # Test contexts
        Context -Name "OWA Mailbox Policy should exist. OWA Mailbox Policy is missing. Test should fail." -Fixture {
            $testParams = @{
                Name                    = 'Contoso OWA Mailbox Policy'
                InstantMessagingEnabled = $true
                Ensure                  = 'Present'
                GlobalAdminAccount      = $GlobalAdminAccount
            }

            Mock -CommandName Get-OwaMailboxPolicy -MockWith {
                return @{
                    Name                    = 'Contoso OWA Mailbox Policy Different'
                    InstantMessagingEnabled = $true
                    FreeBusyAccessLevel     = 'AvailabilityOnly'
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            Mock -CommandName Set-OwaMailboxPolicy -MockWith {
                return @{
                    Name                    = 'Contoso OWA Mailbox Policy'
                    InstantMessagingEnabled = $true
                    Ensure                  = 'Present'
                    GlobalAdminAccount      = $GlobalAdminAccount
                }
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }

            It "Should return Absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }
        }

        Context -Name "OWA Mailbox Policy should exist. OWA Mailbox Policy exists. Test should pass." -Fixture {
            $testParams = @{
                Name                    = 'Contoso OWA Mailbox Policy'
                InstantMessagingEnabled = $true
                Ensure                  = 'Present'
                GlobalAdminAccount      = $GlobalAdminAccount
            }

            Mock -CommandName Get-OwaMailboxPolicy -MockWith {
                return @{
                    Name                    = 'Contoso OWA Mailbox Policy'
                    InstantMessagingEnabled = $true
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should Be $true
            }

            It 'Should return Present from the Get Method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }
        }

        Context -Name "OWA Mailbox Policy should exist. OWA Mailbox Policy exists, InstantMessagingEnabled mismatch. Test should fail." -Fixture {
            $testParams = @{
                Name                    = 'Contoso OWA Mailbox Policy'
                InstantMessagingEnabled = $true
                Ensure                  = 'Present'
                GlobalAdminAccount      = $GlobalAdminAccount
            }

            Mock -CommandName Get-OwaMailboxPolicy -MockWith {
                return @{
                    Name                    = 'Contoso OWA Mailbox Policy'
                    InstantMessagingEnabled = $false

                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            Mock -CommandName Set-OwaMailboxPolicy -MockWith {
                return @{
                    Name                    = 'Contoso OWA Mailbox Policy'
                    InstantMessagingEnabled = $true
                    Ensure                  = 'Present'
                    GlobalAdminAccount      = $GlobalAdminAccount
                }
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
            }

            $OwaMailboxPolicy = @{
                Name                    = 'Contoso OWA Mailbox Policy'
                InstantMessagingEnabled = $true
            }

            It "Should Reverse Engineer resource from the Export method when single" {
                Mock -CommandName Get-OwaMailboxPolicy -MockWith {
                    return $OwaMailboxPolicy
                }

                $exported = Export-TargetResource @testParams
                ([regex]::Matches($exported, " EXOOwaMailboxPolicy " )).Count | Should Be 1
                $exported.Contains("Contoso OWA Mailbox Policy") | Should Be $true
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
