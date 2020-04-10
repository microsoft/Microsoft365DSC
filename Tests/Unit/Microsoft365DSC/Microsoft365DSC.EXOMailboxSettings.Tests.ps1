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
    -DscResource "EXOMailboxSettings" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-MSCloudLogin -MockWith {

        }

        # Test contexts
        Context -Name "Specified Mailbox doesn't exist" -Fixture {
            $testParams = @{
                DisplayName        = "NonExisting@contoso.com"
                Ensure             = "Present"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-MailboxRegionalConfiguration -MockWith {
                return $null
            }

            It "Should throw an error from the Set method" {
                { Set-TargetResource @testParams } | Should Throw "The specified mailbox {NonExisting@contoso.com} does not exist."
            }

            It "Should return Ensure is absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }

            It "Should return False from the Test method" {
                Test-TargetResource @testParams | Should Be $False
            }
        }

        Context -Name "Specified TimeZone is Invalid" -Fixture {
            $testParams = @{
                DisplayName        = "Admin@contoso.com"
                TimeZone           = "Non-Existing"
                Ensure             = "Present"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-MailboxRegionalConfiguration -MockWith {
                return @{
                    TimeZone = "Eastern Standard Time"
                }
            }

            Mock -CommandName Set-MailboxRegionalConfiguration -MockWith {
                return $null
            }

            It "Should throw an error from the Set method" {
                { Set-TargetResource @testParams } | Should Throw "The specified Time Zone {Non-Existing} is not valid."
            }

            It "Should return the current TimeZone from the Get method" {
                (Get-TargetResource @testParams).TimeZone | Should Be "Eastern Standard Time"
            }

            It "Should return False from the Test method" {
                Test-TargetResource @testParams | Should Be $False
            }
        }

        Context -Name "Specified Parameters are all valid" -Fixture {
            $testParams = @{
                DisplayName        = "Admin@contoso.com"
                TimeZone           = "Eastern Standard Time"
                Locale             = "en-US"
                Ensure             = "Present"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-MailboxRegionalConfiguration -MockWith {
                return @{
                    TimeZone = "Eastern Standard Time"
                    Language = @{
                        Name = "en-US"
                    }
                }
            }

            Mock -CommandName Set-MailboxRegionalConfiguration -MockWith {
                return $null
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }

            It "Should return Ensure is Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should return True from the Test method" {
                Test-TargetResource @testParams | Should Be $True
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-MailboxRegionalConfiguration -MockWith {
                return @{
                    TimeZone = "Eastern Standard Time"
                    Language = @{
                        Name = "en-US"
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
