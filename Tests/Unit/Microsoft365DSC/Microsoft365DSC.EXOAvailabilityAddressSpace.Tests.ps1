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
    -DscResource "EXOAvailabilityAddressSpace" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {
            $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
            $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }

            Mock -CommandName Get-PSSession -MockWith {

            }

            Mock -CommandName Remove-PSSession -MockWith {

            }

            Mock -CommandName add-AvailabilityAddressSpace -MockWith {

            }

            Mock -CommandName get-AvailabilityAddressSpace -MockWith {

            }

            Mock -CommandName Remove-AvailabilityAddressSpace -MockWith {

            }
        }

        # Test contexts
        Context -Name "AvailabilityAddressSpace creation." -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount    = $GlobalAdminAccount
                    Ensure                = "Present"
                    Identity              = "contoso.com"
                    AccessMethod          = "OrgWideFB"
                    Credentials           = $Null
                    ForestName            = "contoso.com"
                    TargetAutodiscoverEpr = "http://autodiscover.contoso.com/autodiscover/autodiscover.xml"
                }

                Mock -CommandName Get-AvailabilityAddressSpace -MockWith {
                    return @{
                        Identity = 'SomeOtherConnector'
                    }
                }
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be "Absent"
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "AvailabilityAddressSpace update not required." -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount    = $GlobalAdminAccount
                    Ensure                = "Present"
                    Identity              = "contoso.com"
                    AccessMethod          = "OrgWideFB"
                    Credentials           = $Null
                    ForestName            = "contoso.com"
                    TargetAutodiscoverEpr = "http://autodiscover.contoso.com/autodiscover/autodiscover.xml"
                }

                Mock -CommandName Get-AvailabilityAddressSpace -MockWith {
                    return @{
                        GlobalAdminAccount    = $GlobalAdminAccount
                        Ensure                = "Present"
                        Identity              = "contoso.com"
                        AccessMethod          = "OrgWideFB"
                        Credentials           = $Null
                        ForestName            = "contoso.com"
                        TargetAutodiscoverEpr = "http://autodiscover.contoso.com/autodiscover/autodiscover.xml"
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "AvailabilityAddressSpace update needed." -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount    = $GlobalAdminAccount
                    Ensure                = "Present"
                    Identity              = "contoso.com"
                    AccessMethod          = "OrgWideFB"
                    Credentials           = $Null
                    ForestName            = "contoso.com"
                    TargetAutodiscoverEpr = "http://autodiscover.contoso.com/autodiscover/autodiscover.xml"
                }

                Mock -CommandName Get-AvailabilityAddressSpace -MockWith {
                    return @{
                        GlobalAdminAccount    = $GlobalAdminAccount
                        Ensure                = "Present"
                        Identity              = "contoso.com"
                        AccessMethod          = "PerUserFB"
                        Credentials           = $Null
                        ForestName            = "contoso.com"
                        TargetAutodiscoverEpr = "http://autodiscover.contoso.com/autodiscover/autodiscover.xml"
                    }
                }

                Mock -CommandName Add-AvailabilityAddressSpace -MockWith {
                    return @{

                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should Successfully call the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "AvailabilityAddressSpace removal." -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure             = 'Absent'
                    GlobalAdminAccount = $GlobalAdminAccount
                    Identity           = 'TestAvailabilityAddressSpace'
                }

                Mock -CommandName Get-AvailabilityAddressSpace -MockWith {
                    return @{
                        Identity = 'TestAvailabilityAddressSpace'
                    }
                }

                Mock -CommandName Remove-AvailabilityAddressSpace -MockWith {
                    return @{

                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should Remove the Connector in the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount = $GlobalAdminAccount
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
