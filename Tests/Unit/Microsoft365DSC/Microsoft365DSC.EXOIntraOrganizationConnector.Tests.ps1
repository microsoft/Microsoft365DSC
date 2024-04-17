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
    -DscResource 'EXOIntraOrganizationConnector' -GenericStubModule $GenericStubPath
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

            Mock -CommandName New-IntraOrganizationConnector -MockWith {
            }

            Mock -CommandName Set-IntraOrganizationConnector -MockWith {
            }

            Mock -CommandName Remove-IntraOrganizationConnector -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'IntraOrganizationConnector creation.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure               = 'Present'
                    Credential           = $Credential
                    Identity             = 'TestIntraOrganizationConnector'
                    DiscoveryEndpoint    = 'https://ExternalDiscovery.Contoso.com/autodiscover/autodiscover.svc'
                    Enabled              = $true
                    TargetAddressDomains = @('contoso.com', 'contoso.org')
                }

                Mock -CommandName Get-IntraOrganizationConnector -MockWith {
                    return @{
                        Identity = 'SomeOtherIOConnector'
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

        Context -Name 'IntraOrganizationConnector update not required.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure               = 'Present'
                    Credential           = $Credential
                    Identity             = 'TestIntraOrganizationConnector'
                    DiscoveryEndpoint    = 'https://ExternalDiscovery.Contoso.com/autodiscover/autodiscover.svc'
                    Enabled              = $true
                    TargetAddressDomains = @('contoso.com', 'contoso.org')
                }

                Mock -CommandName Get-IntraOrganizationConnector -MockWith {
                    return @{
                        Ensure               = 'Present'
                        Credential           = $Credential
                        Identity             = 'TestIntraOrganizationConnector'
                        DiscoveryEndpoint    = 'https://ExternalDiscovery.Contoso.com/autodiscover/autodiscover.svc'
                        Enabled              = $true
                        TargetAddressDomains = @('contoso.com', 'contoso.org')
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'IntraOrganizationConnector update needed.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure               = 'Present'
                    Credential           = $Credential
                    Identity             = 'TestIntraOrganizationConnector'
                    DiscoveryEndpoint    = 'https://ExternalDiscovery.Contoso.com/autodiscover/autodiscover.svc'
                    Enabled              = $true
                    TargetAddressDomains = @('contoso.com', 'contoso.org')
                }

                Mock -CommandName Get-IntraOrganizationConnector -MockWith {
                    return @{
                        Ensure               = 'Present'
                        Credential           = $Credential
                        Identity             = 'TestIntraOrganizationConnector'
                        Name                 = 'TestIntraOrganizationConnector'
                        DiscoveryEndpoint    = 'https://Discovery.Contoso.org/autodiscover/autodiscover.svc'
                        Enabled              = $true
                        TargetAddressDomains = @('contoso.com', 'contoso.de')
                    }
                }

                Mock -CommandName Set-IntraOrganizationConnector -MockWith {
                    return @{
                        Ensure               = 'Present'
                        Credential           = $Credential
                        Identity             = 'TestIntraOrganizationConnector'
                        Name                 = 'TestIntraOrganizationConnector'
                        DiscoveryEndpoint    = 'https://ExternalDiscovery.Contoso.com/autodiscover/autodiscover.svc'
                        Enabled              = $true
                        TargetAddressDomains = @('contoso.com', 'contoso.org')
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

        Context -Name 'IntraOrganizationConnector removal.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure            = 'Present'
                    Credential        = $Credential
                    Identity          = 'TestIntraOrganizationConnector'
                    DiscoveryEndpoint = 'https://ExternalDiscovery.Contoso.com/autodiscover/autodiscover.svc'
                }

                Mock -CommandName Get-IntraOrganizationConnector -MockWith {
                    return @{}
                }

                Mock -CommandName Remove-IntraOrganizationConnector -MockWith {
                    return @{}
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

                Mock -CommandName Get-IntraOrganizationConnector -MockWith {
                    return @{
                        Identity             = 'TestIntraOrganizationConnector'
                        DiscoveryEndpoint    = 'https://ExternalDiscovery.Contoso.com/autodiscover/autodiscover.svc'
                        Enabled              = $true
                        TargetAddressDomains = @('contoso.com', 'contoso.org')
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
