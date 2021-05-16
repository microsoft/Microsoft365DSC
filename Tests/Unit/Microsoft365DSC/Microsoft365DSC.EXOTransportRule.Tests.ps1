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
    -DscResource "EXOTransportRule" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Close-SessionsAndReturnError -MockWith {

        }

        Mock -CommandName Test-MSCloudLogin -MockWith {

        }

        Mock -CommandName Get-PSSession -MockWith {

        }

        Mock -CommandName Remove-PSSession -MockWith {

        }

        # Test contexts
        Context -Name "Transport Rule should exist. Transport Rule is missing. Test should fail." -Fixture {
            $testParams = @{
                Name                         = 'Contoso Transport Rule'
                BetweenMemberOf1             = 'Sales Department'
                BetweenMemberOf2             = 'Brokerage Department'
                ExceptIfSubjectContainsWords = 'Press Release'
                RejectMessageReasonText      = 'Messages sent between the Sales and Brokerage departments are strictly prohibited.'
                Ensure                       = 'Present'
                GlobalAdminAccount           = $GlobalAdminAccount
            }

            Mock -CommandName Get-TransportRule -MockWith {
                return @{
                    Name                         = 'Contoso Different Transport Rule'
                    BetweenMemberOf1             = 'Sales Department'
                    BetweenMemberOf2             = 'Marketing Department'
                    ExceptIfSubjectContainsWords = 'Press Release'
                    RejectMessageReasonText      = 'Messages sent between the Sales and Marketing departments are strictly prohibited.'
                    FreeBusyAccessLevel          = 'AvailabilityOnly'
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            Mock -CommandName Set-TransportRule -MockWith {
                return @{
                    Name                         = 'Contoso Different Transport Rule'
                    BetweenMemberOf1             = 'Sales Department'
                    BetweenMemberOf2             = 'Marketing Department'
                    ExceptIfSubjectContainsWords = 'Press Release'
                    RejectMessageReasonText      = 'Messages sent between the Sales and Marketing departments are strictly prohibited.'
                    FreeBusyAccessLevel          = 'AvailabilityOnly'
                    Ensure                       = 'Present'
                    GlobalAdminAccount           = $GlobalAdminAccount
                }
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }

            It "Should return Absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }
        }

        Context -Name "Transport Rule should exist. Transport Rule exists. Test should pass." -Fixture {
            $testParams = @{
                Name                         = 'Contoso Transport Rule'
                BetweenMemberOf1             = 'Sales Department'
                BetweenMemberOf2             = 'Brokerage Department'
                ExceptIfSubjectContainsWords = 'Press Release'
                RejectMessageReasonText      = 'Messages sent between the Sales and Brokerage departments are strictly prohibited.'
                GlobalAdminAccount           = $GlobalAdminAccount
            }

            Mock -CommandName Get-TransportRule -MockWith {
                return @{
                    Name                         = 'Contoso Transport Rule'
                    BetweenMemberOf1             = 'Sales Department'
                    BetweenMemberOf2             = 'Brokerage Department'
                    ExceptIfSubjectContainsWords = 'Press Release'
                    RejectMessageReasonText      = 'Messages sent between the Sales and Brokerage departments are strictly prohibited.'
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should Be $true
            }

            It 'Should return Present from the Get Method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }
        }

        Context -Name "Transport Rule should exist. Transport Rule exists, BetweenMemberOf1 mismatch. Test should fail." -Fixture {
            $testParams = @{
                Name                         = 'Contoso Transport Rule'
                BetweenMemberOf1             = 'Sales Department'
                BetweenMemberOf2             = 'Brokerage Department'
                ExceptIfSubjectContainsWords = 'Press Release'
                RejectMessageReasonText      = 'Messages sent between the Sales and Brokerage departments are strictly prohibited.'
                Ensure                       = 'Present'
                GlobalAdminAccount           = $GlobalAdminAccount
            }

            Mock -CommandName Get-TransportRule -MockWith {
                return @{
                    Name                         = 'Contoso Transport Rule'
                    BetweenMemberOf1             = 'Marketing Department'
                    BetweenMemberOf2             = 'Brokerage Department'
                    ExceptIfSubjectContainsWords = 'Press Release'
                    RejectMessageReasonText      = 'Messages sent between the Sales and Brokerage departments are strictly prohibited.'
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            Mock -CommandName Set-TransportRule -MockWith {
                return @{
                    Name                         = 'Contoso Transport Rule'
                    BetweenMemberOf1             = 'Sales Department'
                    BetweenMemberOf2             = 'Brokerage Department'
                    ExceptIfSubjectContainsWords = 'Press Release'
                    RejectMessageReasonText      = 'Messages sent between the Sales and Brokerage departments are strictly prohibited.'
                    Ensure                       = 'Present'
                    GlobalAdminAccount           = $GlobalAdminAccount
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

            $TransportRule = @{
                Name                         = 'Contoso Transport Rule'
                BetweenMemberOf1             = 'Sales Department'
                BetweenMemberOf2             = 'Brokerage Department'
                ExceptIfSubjectContainsWords = 'Press Release'
                RejectMessageReasonText      = 'Messages sent between the Sales and Brokerage departments are strictly prohibited.'
            }

            It "Should Reverse Engineer resource from the Export method when single" {
                Mock -CommandName Get-TransportRule -MockWith {
                    return $TransportRule
                }

                $exported = Export-TargetResource @testParams
                ([regex]::Matches($exported, " EXOTransportRule " )).Count | Should Be 1
                $exported.Contains("Brokerage") | Should Be $true
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
