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
    -DscResource 'SPOTenantCdnPolicy' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'Pass@word1)' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Set-PnPTenantCDNPolicy -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name 'Update existing Public Policies' -Fixture {
            BeforeAll {
                $testParams = @{
                    CDNType                              = 'Public'
                    ExcludeRestrictedSiteClassifications = @('Sensitive')
                    IncludeFileExtensions                = @('.gif')
                    Credential                           = $Credential
                }

                Mock -CommandName Get-PnPTenantCDNPolicies -MockWith {
                    return @{
                        CDNType                              = 'Public'
                        ExcludeRestrictedSiteClassifications = @('Secured')
                        IncludeFileExtensions                = @('.php')
                    }
                }
            }

            It "Should return $false for the ExcludeIfNoScriptDisabled for the  from the Get method" {
                (Get-TargetResource @testParams).ExcludeRestrictedSiteClassifications | Should -Be @('Secured')
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update the policies from the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'Update existing Private Policies' -Fixture {
            BeforeAll {
                $testParams = @{
                    CDNType                              = 'Private'
                    ExcludeRestrictedSiteClassifications = @('Sensitive')
                    IncludeFileExtensions                = @('.gif')
                    Credential                           = $Credential
                }

                Mock -CommandName Get-PnPTenantCDNPolicies -MockWith {
                    return @{
                        CDNType                              = 'Private'
                        ExcludeIfNoScriptDisabled            = $false
                        ExcludeRestrictedSiteClassifications = @('Secured')
                        IncludeFileExtensions                = @('.php')
                    }
                }
            }

            It "Should return $false for the ExcludeIfNoScriptDisabled for the  from the Get method" {
                (Get-TargetResource @testParams).ExcludeRestrictedSiteClassifications | Should -Be @('Secured')
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update the policies from the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'Policies are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    CDNType                              = 'Public'
                    ExcludeRestrictedSiteClassifications = @('Secured')
                    IncludeFileExtensions                = @('.php')
                    Credential                           = $Credential
                }

                Mock -CommandName Get-PnPTenantCDNPolicies -MockWith {
                    return @{
                        CDNType                              = 'Public'
                        ExcludeIfNoScriptDisabled            = $false
                        ExcludeRestrictedSiteClassifications = @('Secured')
                        IncludeFileExtensions                = @('.php')
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Should not update the policies from the Set method' {
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

                Mock -CommandName Get-PnPTenantCDNPolicies -MockWith {
                    return @{
                        CDNType                              = 'Public'
                        ExcludeIfNoScriptDisabled            = $false
                        ExcludeRestrictedSiteClassifications = @('Secured')
                        IncludeFileExtensions                = @('.php')
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
