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
    -DscResource "EXOIntraOrganizationConnector"
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

        Mock -CommandName New-IntraOrganizationConnector -MockWith {

        }

        Mock -CommandName Set-IntraOrganizationConnector -MockWith {

        }

        Mock -CommandName Remove-IntraOrganizationConnector -MockWith {

        }

        # Test contexts
        Context -Name "IntraOrganizationConnector creation." -Fixture {
            $testParams = @{
                Ensure               = 'Present'
                GlobalAdminAccount   = $GlobalAdminAccount
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

        Context -Name "IntraOrganizationConnector update not required." -Fixture {
            $testParams = @{
                Ensure               = 'Present'
                GlobalAdminAccount   = $GlobalAdminAccount
                Identity             = 'TestIntraOrganizationConnector'
                DiscoveryEndpoint    = 'https://ExternalDiscovery.Contoso.com/autodiscover/autodiscover.svc'
                Enabled              = $true
                TargetAddressDomains = @('contoso.com', 'contoso.org')
            }


            Mock -CommandName Get-IntraOrganizationConnector -MockWith {
                return @{
                    Ensure               = 'Present'
                    GlobalAdminAccount   = $GlobalAdminAccount
                    Identity             = 'TestIntraOrganizationConnector'
                    DiscoveryEndpoint    = 'https://ExternalDiscovery.Contoso.com/autodiscover/autodiscover.svc'
                    Enabled              = $true
                    TargetAddressDomains = @('contoso.com', 'contoso.org')
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should Be $true
            }
        }

        Context -Name "IntraOrganizationConnector update needed." -Fixture {
            $testParams = @{
                Ensure               = 'Present'
                GlobalAdminAccount   = $GlobalAdminAccount
                Identity             = 'TestIntraOrganizationConnector'
                DiscoveryEndpoint    = 'https://ExternalDiscovery.Contoso.com/autodiscover/autodiscover.svc'
                Enabled              = $true
                TargetAddressDomains = @('contoso.com', 'contoso.org')
            }

            Mock -CommandName Get-IntraOrganizationConnector -MockWith {
                return @{
                Ensure               = 'Present'
                GlobalAdminAccount   = $GlobalAdminAccount
                Identity             = 'TestIntraOrganizationConnector'
                DiscoveryEndpoint    = 'https://Discovery.Contoso.org/autodiscover/autodiscover.svc'
                Enabled              = $true
                TargetAddressDomains = @('contoso.com', 'contoso.de')                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            Mock -CommandName Set-IntraOrganizationConnector -MockWith {
                return @{
                    Ensure               = 'Present'
                    GlobalAdminAccount   = $GlobalAdminAccount
                    Identity             = 'TestIntraOrganizationConnector'
                    DiscoveryEndpoint    = 'https://ExternalDiscovery.Contoso.com/autodiscover/autodiscover.svc'
                    Enabled              = $true
                    TargetAddressDomains = @('contoso.com', 'contoso.org')
                }
            }

            It "Should Successfully call the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "IntraOrganizationConnector removal." -Fixture {
            $testParams = @{
                Ensure             = 'Absent'
                GlobalAdminAccount = $GlobalAdminAccount
                Identity           = 'TestIntraOrganizationConnector'
            }

            Mock -CommandName Get-IntraOrganizationConnector -MockWith {
                return @{
                    Identity = 'TestIntraOrganizationConnector'
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            Mock -CommandName Remove-IntraOrganizationConnector -MockWith {
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
