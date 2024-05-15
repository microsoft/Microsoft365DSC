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
    -DscResource 'EXOOutboundConnector' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
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

            Mock -CommandName New-OutboundConnector -MockWith {
            }

            Mock -CommandName Set-OutboundConnector -MockWith {
            }

            Mock -CommandName Remove-OutboundConnector -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'OutboundConnector creation.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                        = 'Present'
                    Credential                    = $Credential
                    Identity                      = 'TestOutboundConnector'
                    CloudServicesMailEnabled      = $false
                    Comment                       = 'Test outbound connector'
                    Enabled                       = $true
                    ConnectorSource               = 'Default'
                    ConnectorType                 = 'Partner'
                    IsTransportRuleScoped         = $false
                    RecipientDomains              = @('fabrikam.com', 'contoso.com')
                    RouteAllMessagesViaOnPremises = $false
                    SmartHosts                    = @('mail.contoso.com')
                    TestMode                      = $false
                    TlsDomain                     = '*.contoso.com'
                    TlsSettings                   = 'EncryptionOnly'
                    UseMxRecord                   = $false
                    ValidationRecipients          = @('test@contoso.com', 'contoso.org')
                }

                Mock -CommandName Get-OutboundConnector -MockWith {
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

        Context -Name 'OutboundConnector update not required.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                        = 'Present'
                    Credential                    = $Credential
                    Identity                      = 'TestOutboundConnector'
                    CloudServicesMailEnabled      = $false
                    Comment                       = 'Test outbound connector'
                    Enabled                       = $true
                    ConnectorSource               = 'Default'
                    ConnectorType                 = 'Partner'
                    IsTransportRuleScoped         = $false
                    RecipientDomains              = @('fabrikam.com', 'contoso.com')
                    RouteAllMessagesViaOnPremises = $false
                    SmartHosts                    = @('mail.contoso.com')
                    TestMode                      = $false
                    TlsDomain                     = '*.contoso.com'
                    TlsSettings                   = 'EncryptionOnly'
                    UseMxRecord                   = $false
                    ValidationRecipients          = @('test@contoso.com')
                }

                Mock -CommandName Get-OutboundConnector -MockWith {
                    return @{
                        Ensure                        = 'Present'
                        Identity                      = 'TestOutboundConnector'
                        CloudServicesMailEnabled      = $false
                        Comment                       = 'Test outbound connector'
                        Enabled                       = $true
                        ConnectorSource               = 'Default'
                        ConnectorType                 = 'Partner'
                        IsTransportRuleScoped         = $false
                        RecipientDomains              = @('fabrikam.com', 'contoso.com')
                        RouteAllMessagesViaOnPremises = $false
                        SmartHosts                    = @('mail.contoso.com')
                        TestMode                      = $false
                        TlsDomain                     = '*.contoso.com'
                        TlsSettings                   = 'EncryptionOnly'
                        UseMxRecord                   = $false
                        ValidationRecipients          = @('test@contoso.com')
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'OutboundConnector update needed.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                        = 'Present'
                    Credential                    = $Credential
                    Identity                      = 'TestOutboundConnector'
                    CloudServicesMailEnabled      = $false
                    Comment                       = 'Test outbound connector'
                    Enabled                       = $true
                    ConnectorSource               = 'Default'
                    ConnectorType                 = 'Partner'
                    IsTransportRuleScoped         = $false
                    RecipientDomains              = @('fabrikam.com', 'contoso.com')
                    RouteAllMessagesViaOnPremises = $false
                    SmartHosts                    = @('mail.contoso.com')
                    TestMode                      = $false
                    TlsDomain                     = '*.contoso.com'
                    TlsSettings                   = 'EncryptionOnly'
                    UseMxRecord                   = $false
                    ValidationRecipients          = @('test@contoso.com')
                }

                Mock -CommandName Get-OutboundConnector -MockWith {
                    return @{
                        Identity                      = 'TestOutboundConnector'
                        CloudServicesMailEnabled      = $false
                        Comment                       = 'Test outbound connector'
                        Enabled                       = $false
                        ConnectorSource               = 'Default'
                        ConnectorType                 = 'Partner'
                        IsTransportRuleScoped         = $false
                        RecipientDomains              = @('fabrikam.com', 'contoso.com')
                        RouteAllMessagesViaOnPremises = $false
                        SmartHosts                    = @('mail.contoso.com')
                        TestMode                      = $false
                        TlsDomain                     = '*.contoso.org'
                        TlsSettings                   = 'EncryptionOnly'
                        UseMxRecord                   = $True
                        ValidationRecipients          = @('test@contoso.com')
                    }
                }

                Mock -CommandName Set-OutboundConnector -MockWith {
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

        Context -Name 'OutboundConnector removal.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure     = 'Absent'
                    Credential = $Credential
                    Identity   = 'TestOutboundConnector'
                }

                Mock -CommandName Get-OutboundConnector -MockWith {
                    return @{
                        Identity = 'TestOutboundConnector'
                    }
                }

                Mock -CommandName Remove-OutboundConnector -MockWith {
                    return @{

                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the Policy in the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'Connector Source is AdminUI' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                        = 'Present'
                    Credential                    = $Credential
                    Identity                      = 'TestOutboundConnector'
                    CloudServicesMailEnabled      = $false
                    Comment                       = 'Test outbound connector'
                    Enabled                       = $true
                    ConnectorSource               = 'Default'
                    ConnectorType                 = 'Partner'
                    IsTransportRuleScoped         = $false
                    RecipientDomains              = @('fabrikam.com', 'contoso.com')
                    RouteAllMessagesViaOnPremises = $false
                    SmartHosts                    = @('mail.contoso.com')
                    TestMode                      = $false
                    TlsDomain                     = '*.contoso.com'
                    TlsSettings                   = 'EncryptionOnly'
                    UseMxRecord                   = $false
                    ValidationRecipients          = @('test@contoso.com')
                }

                Mock -CommandName Get-OutboundConnector -MockWith {
                    return @{
                        Ensure                        = 'Present'
                        Identity                      = 'TestOutboundConnector'
                        CloudServicesMailEnabled      = $false
                        Comment                       = 'Test outbound connector'
                        Enabled                       = $true
                        ConnectorSource               = 'AdminUI'
                        ConnectorType                 = 'Partner'
                        IsTransportRuleScoped         = $false
                        RecipientDomains              = @('fabrikam.com', 'contoso.com')
                        RouteAllMessagesViaOnPremises = $false
                        SmartHosts                    = @('mail.contoso.com')
                        TestMode                      = $false
                        TlsDomain                     = '*.contoso.com'
                        TlsSettings                   = 'EncryptionOnly'
                        UseMxRecord                   = $false
                        ValidationRecipients          = @('test@contoso.com')
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Should return Default as the source from the Get method' {
                (Get-TargetResource @testParams).ConnectorSource | Should -Be 'Default'
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-OutboundConnector -MockWith {
                    return @{
                        Identity                      = 'TestOutboundConnector'
                        CloudServicesMailEnabled      = $false
                        Comment                       = 'Test outbound connector'
                        Enabled                       = $true
                        ConnectorSource               = 'AdminUI'
                        ConnectorType                 = 'Partner'
                        IsTransportRuleScoped         = $false
                        RecipientDomains              = @('fabrikam.com', 'contoso.com')
                        RouteAllMessagesViaOnPremises = $false
                        SmartHosts                    = @('mail.contoso.com')
                        TestMode                      = $false
                        TlsDomain                     = '*.contoso.com'
                        TlsSettings                   = 'EncryptionOnly'
                        UseMxRecord                   = $false
                        ValidationRecipients          = @('test@contoso.com')
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
