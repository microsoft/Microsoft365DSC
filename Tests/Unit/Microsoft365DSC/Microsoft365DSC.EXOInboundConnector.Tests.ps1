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
    -DscResource "EXOInboundConnector" -GenericStubModule $GenericStubPath
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

        Mock -CommandName New-InboundConnector -MockWith {

        }

        Mock -CommandName Set-InboundConnector -MockWith {

        }

        Mock -CommandName Remove-InboundConnector -MockWith {

        }

        # Test contexts
        Context -Name "InboundConnector creation." -Fixture {
            $testParams = @{
                Ensure                       = 'Present'
                GlobalAdminAccount           = $GlobalAdminAccount
                Identity                     = 'TestInboundConnector'
                AssociatedAcceptedDomains    = @('test@contoso.com', 'contoso.org')
                CloudServicesMailEnabled     = $false
                Comment                      = 'Test Inbound connector'
                ConnectorSource              = 'HybridWizard'
                ConnectorType                = 'onPremises'
                Enabled                      = $true
                RequireTls                   = $true
                RestrictDomainsToCertificate = $false
                RestrictDomainsToIPAddresses = $true
                SenderDomains                = @('fabrikam.com', 'contoso.com')
                SenderIPAddresses            = '192.168.2.11'
                TlsSenderCertificateName     = '*.contoso.com'
                TreatMessagesAsInternal      = $true
            }

            Mock -CommandName Get-InboundConnector -MockWith {
                return @{
                    Identity = 'SomeOtherConnector'
                }
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }

        }

        Context -Name "InboundConnector update not required." -Fixture {
            $testParams = @{
                Ensure                       = 'Present'
                GlobalAdminAccount           = $GlobalAdminAccount
                Identity                     = 'TestInboundConnector'
                AssociatedAcceptedDomains    = @('contoso.com', 'contoso.org')
                CloudServicesMailEnabled     = $false
                Comment                      = 'Test Inbound connector'
                ConnectorSource              = 'HybridWizard'
                ConnectorType                = 'OnPremises'
                Enabled                      = $true
                RequireTls                   = $true
                RestrictDomainsToCertificate = $false
                RestrictDomainsToIPAddresses = $true
                SenderDomains                = @('fabrikam.com', 'contoso.com')
                SenderIPAddresses            = @('192.168.2.11')
                TlsSenderCertificateName     = '*.contoso.com'
                TreatMessagesAsInternal      = $true
            }


            Mock -CommandName Get-InboundConnector -MockWith {
                return @{
                    Ensure                       = 'Present'
                    GlobalAdminAccount           = $GlobalAdminAccount
                    Identity                     = 'TestInboundConnector'
                    AssociatedAcceptedDomains    = @('contoso.com', 'contoso.org')
                    CloudServicesMailEnabled     = $false
                    Comment                      = 'Test Inbound connector'
                    ConnectorSource              = 'HybridWizard'
                    ConnectorType                = 'onPremises'
                    Enabled                      = $true
                    RequireTls                   = $true
                    RestrictDomainsToCertificate = $false
                    RestrictDomainsToIPAddresses = $true
                    SenderDomains                = @('fabrikam.com', 'contoso.com')
                    SenderIPAddresses            = @('192.168.2.11')
                    TlsSenderCertificateName     = '*.contoso.com'
                    TreatMessagesAsInternal      = $true
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should Be $true
            }
        }

        Context -Name "InboundConnector update needed." -Fixture {
            $testParams = @{
                Ensure                       = 'Present'
                GlobalAdminAccount           = $GlobalAdminAccount
                Identity                     = 'TestInboundConnector'
                AssociatedAcceptedDomains    = @('test@contoso.com', 'contoso.org')
                CloudServicesMailEnabled     = $false
                Comment                      = 'Test Inbound connector'
                ConnectorSource              = 'HybridWizard'
                ConnectorType                = 'onPremises'
                Enabled                      = $true
                RequireTls                   = $true
                RestrictDomainsToCertificate = $false
                RestrictDomainsToIPAddresses = $true
                SenderDomains                = @('fabrikam.com', 'contoso.com')
                SenderIPAddresses            = '192.168.2.11'
                TlsSenderCertificateName     = '*.contoso.com'
                TreatMessagesAsInternal      = $true

            }

            Mock -CommandName Get-InboundConnector -MockWith {
                return @{
                    Ensure                       = 'Present'
                    GlobalAdminAccount           = $GlobalAdminAccount
                    Identity                     = 'TestInboundConnector'
                    AssociatedAcceptedDomains    = @('test@contoso.com', 'contoso.org')
                    CloudServicesMailEnabled     = $true
                    Comment                      = 'Test Inbound connector'
                    ConnectorSource              = 'HybridWizard'
                    ConnectorType                = 'Partner'
                    Enabled                      = $true
                    RequireTls                   = $true
                    RestrictDomainsToCertificate = $false
                    RestrictDomainsToIPAddresses = $true
                    SenderDomains                = @('fabrikam.com', 'contoso.com')
                    SenderIPAddresses            = '192.168.2.114'
                    TlsSenderCertificateName     = '*.contoso.org'
                    TreatMessagesAsInternal      = $false

                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            Mock -CommandName Set-InboundConnector -MockWith {
                return @{

                }
            }

            It "Should Successfully call the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "InboundConnector removal." -Fixture {
            $testParams = @{
                Ensure             = 'Absent'
                GlobalAdminAccount = $GlobalAdminAccount
                Identity           = 'TestInboundConnector'
            }

            Mock -CommandName Get-InboundConnector -MockWith {
                return @{
                    Identity = 'TestInboundConnector'
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            Mock -CommandName Remove-InboundConnector -MockWith {
                return @{

                }
            }

            It "Should Remove the Connector in the Set method" {
                Set-TargetResource @testParams
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
