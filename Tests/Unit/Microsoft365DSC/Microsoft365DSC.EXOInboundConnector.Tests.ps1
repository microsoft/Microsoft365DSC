[CmdletBinding()]
param(
)
$M365DSCTestFolder = Join-Path -Path $PSScriptRoot `
    -ChildPath '..\..\Unit' `
    -Resolve
$CmdletModule = (Join-Path -Path $M365DSCTestFolder `
        -ChildPath '\Stubs\Microsoft365.psm1' `
        -Resolve)
$GenericStubPath = (Join-Path -Path $M365DSCTestFolder `
        -ChildPath '\Stubs\Generic.psm1' `
        -Resolve)
Import-Module -Name (Join-Path -Path $M365DSCTestFolder `
        -ChildPath '\UnitTestHelper.psm1' `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource 'EXOInboundConnector' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'test@password1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
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

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'InboundConnector creation.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                       = 'Present'
                    Credential                   = $Credential
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
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
            }

        }

        Context -Name 'InboundConnector update not required.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                       = 'Present'
                    Credential                   = $Credential
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
                        Credential                   = $Credential
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
                        SenderDomains                = @('smtp:fabrikam.com;1', 'smtp:contoso.com;1')
                        SenderIPAddresses            = @('192.168.2.11')
                        TlsSenderCertificateName     = '*.contoso.com'
                        TreatMessagesAsInternal      = $true
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'InboundConnector update needed.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                       = 'Present'
                    Credential                   = $Credential
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
                        Credential                   = $Credential
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
                        SenderDomains                = @('smtp:fabrikam.com;1', 'smtp:contoso.com;1')
                        SenderIPAddresses            = '192.168.2.114'
                        TlsSenderCertificateName     = '*.contoso.org'
                        TreatMessagesAsInternal      = $false

                    }
                }

                Mock -CommandName Set-InboundConnector -MockWith {
                    return @{

                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Successfully call the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'InboundConnector removal.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure     = 'Absent'
                    Credential = $Credential
                    Identity   = 'TestInboundConnector'
                }

                Mock -CommandName Get-InboundConnector -MockWith {
                    return @{
                        Identity = 'TestInboundConnector'
                    }
                }

                Mock -CommandName Remove-InboundConnector -MockWith {
                    return @{

                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the Connector in the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-InboundConnector -MockWith {
                    return @{
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
                        SenderDomains                = @('smtp:fabrikam.com;1', 'smtp:contoso.com;1')
                        SenderIPAddresses            = '192.168.2.114'
                        TlsSenderCertificateName     = '*.contoso.org'
                        TreatMessagesAsInternal      = $false

                    }
                }
            }

            It 'Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
