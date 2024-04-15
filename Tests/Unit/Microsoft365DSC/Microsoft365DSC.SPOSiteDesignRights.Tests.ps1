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
    -DscResource 'SPOSiteDesignRights' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'Pass@word1)' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            $Global:PartialExportFileName = 'c:\TestPath'

            Mock -CommandName Save-M365DSCPartialExport -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'Check Site Design Rights' -Fixture {
            BeforeAll {
                $testParams = @{
                    SiteDesignTitle = 'Customer List'
                    UserPrincipals  = 'jdoe@dsazure.com'
                    Rights          = 'View'
                    Ensure          = 'Present'
                    Credential      = $Credential
                }

                Mock -CommandName Grant-PnPSiteDesignRights -MockWith {
                    return @{
                        UserPrincipals = $null
                        Rights         = $null
                        Identity       = $null
                    }
                }

                Mock -CommandName Get-PnPSiteDesign -MockWith {
                    return @{
                        SiteDesignTitle = 'Customer List'
                        Id              = '12345-12345-12345-12345-12345'
                    }
                }

                Mock -CommandName Get-PnPSiteDesignRights -MockWith {
                    return $null
                }
            }

            It 'Should return absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
        }

        Context -Name 'Check existing Site Design rights' -Fixture {
            BeforeAll {
                $testParams = @{
                    SiteDesignTitle = 'Customer List'
                    UserPrincipals  = 'jdoe@dsazure.com'
                    Rights          = 'View'
                    Ensure          = 'Present'
                    Credential      = $Credential
                }

                Mock -CommandName Get-PnPSiteDesign -MockWith {
                    return @{
                        Id = '12345-12345-12345-12345-12345'
                    }
                }

                Mock -CommandName Get-PnPSiteDesignRights -MockWith {
                    return @{
                        PrincipalName = 'i:0#.f|membership|jdoe@dsazure.com'
                        Rights        = 'View'
                    }
                }

                Mock -CommandName Grant-PnPSiteDesignRights -MockWith {
                    return $null
                }
            }

            It 'Should return present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Updates the Team fun settings in the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'Adding new user Site Design rights' -Fixture {
            BeforeAll {
                $testParams = @{
                    SiteDesignTitle = 'Customer List'
                    UserPrincipals  = 'jdoe@dsazure.com', 'dsmay@dsazure.com'
                    Rights          = 'View'
                    Ensure          = 'Present'
                    Credential      = $Credential
                }

                Mock -CommandName Get-PnPSiteDesign -MockWith {
                    return @{
                        Id = '12345-12345-12345-12345-12345'
                    }
                }

                Mock -CommandName Get-PnPSiteDesignRights -MockWith {
                    return @{
                        PrincipalName = 'i:0#.f|membership|jdoe@dsazure.com'
                        Rights        = 'View'
                    }
                }

                Mock -CommandName Grant-PnPSiteDesignRights -MockWith {
                    return $null
                }

                Mock -CommandName Revoke-PnPSiteDesignRights -MockWith {
                    return $null
                }
            }

            It 'Should return present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Updates the user design rights in the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'Removing a user Site Design rights' -Fixture {
            BeforeAll {
                $testParams = @{
                    SiteDesignTitle = 'Customer List'
                    UserPrincipals  = 'dsmay@dsazure.com'
                    Rights          = 'View'
                    Ensure          = 'Present'
                    Credential      = $Credential
                }

                Mock -CommandName Get-PnPSiteDesign -MockWith {
                    return @{
                        Id = '12345-12345-12345-12345-12345'
                    }
                }

                Mock -CommandName Get-PnPSiteDesignRights -MockWith {
                    return @{
                        PrincipalName = 'i:0#.f|membership|jdoe@dsazure.com'
                        Rights        = 'View'
                    }
                }

                Mock -CommandName Grant-PnPSiteDesignRights -MockWith {
                    return $null
                }

                Mock -CommandName Revoke-PnPSiteDesignRights -MockWith {
                    return $null
                }
            }

            It 'Should return present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Updates the user design rights in the Set method' {
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

                Mock -CommandName Get-PnPSiteDesign -MockWith {
                    return @{
                        Title = 'Customer List'
                        Id    = '12345-12345-12345-12345-12345'
                    }
                }

                Mock -CommandName Get-PnPSiteDesignRights -MockWith {
                    return @{
                        PrincipalName = 'i:0#.f|membership|john.smith@contoso.com'
                        Rights        = 'View'
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
