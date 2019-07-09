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
    -DscResource "EXOHostedOutboundSpamFilterPolicy"
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

        Mock -CommandName Get-HostedOutboundSpamFilterPolicy -MockWith {

        }

        Mock -CommandName Set-HostedOutboundSpamFilterPolicy -MockWith {

        }

        # Test contexts
        Context -Name "HostedOutboundSpamFilterPolicy update not required." -Fixture {
            $testParams = @{
                IsSingleInstance                          = 'Yes'
                Ensure                                    = 'Present'
                Identity                                  = 'Default'
                GlobalAdminAccount                        = $GlobalAdminAccount
                AdminDisplayName                          = 'Default Outbound Spam Filter Policy'
                BccSuspiciousOutboundMail                 = $true
                BccSuspiciousOutboundAdditionalRecipients = @()
                NotifyOutboundSpam                        = $true
                NotifyOutboundSpamRecipients              = @()
            }

            Mock -CommandName Get-HostedOutboundSpamFilterPolicy -MockWith {
                return @{
                    IsSingleInstance                          = 'Yes'
                    Ensure                                    = 'Present'
                    Identity                                  = 'Default'
                    GlobalAdminAccount                        = $GlobalAdminAccount
                    AdminDisplayName                          = 'Default Outbound Spam Filter Policy'
                    BccSuspiciousOutboundMail                 = $true
                    BccSuspiciousOutboundAdditionalRecipients = @()
                    NotifyOutboundSpam                        = $true
                    NotifyOutboundSpamRecipients              = @()
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

        Context -Name "HostedOutboundSpamFilterPolicy update needed." -Fixture {
            $testParams = @{
                IsSingleInstance                          = 'Yes'
                Ensure                                    = 'Present'
                Identity                                  = 'Default'
                GlobalAdminAccount                        = $GlobalAdminAccount
                AdminDisplayName                          = 'Default Outbound Spam Filter Policy'
                BccSuspiciousOutboundMail                 = $true
                BccSuspiciousOutboundAdditionalRecipients = @('admin@contoso.com')
                NotifyOutboundSpam                        = $true
                NotifyOutboundSpamRecipients              = @('supervisor@contoso.com')
            }
            Mock -CommandName Get-HostedOutboundSpamFilterPolicy -MockWith {
                return @{
                    IsSingleInstance                          = 'Yes'
                    Ensure                                    = 'Present'
                    Identity                                  = 'Default'
                    GlobalAdminAccount                        = $GlobalAdminAccount
                    AdminDisplayName                          = $null
                    BccSuspiciousOutboundMail                 = $false
                    BccSuspiciousOutboundAdditionalRecipients = @()
                    NotifyOutboundSpam                        = $false
                    NotifyOutboundSpamRecipients              = @()
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

            Mock -CommandName Get-HostedOutboundSpamFilterPolicy -MockWith {
                return @{
                    Identity                                  = 'Default'
                    AdminDisplayName                          = 'Default Outbound Spam Filter Policy'
                    BccSuspiciousOutboundMail                 = $true
                    BccSuspiciousOutboundAdditionalRecipients = @()
                    NotifyOutboundSpam                        = $true
                    NotifyOutboundSpamRecipients              = @()
                }
            }

            It 'Should Reverse Engineer resource from the Export method' {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
