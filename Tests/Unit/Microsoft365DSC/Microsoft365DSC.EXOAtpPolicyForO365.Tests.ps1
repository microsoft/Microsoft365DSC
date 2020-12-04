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
    -DscResource "EXOAtpPolicyForO365" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {
            $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
            $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin@contoso.com", $secpasswd)

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

            Mock -CommandName Get-AtpPolicyForO365 -MockWith {

            }

            Mock -CommandName Set-AtpPolicyForO365 -MockWith {

            }

            Mock -CommandName Confirm-ImportedCmdletIsAvailable -MockWith {
                return $true
            }
        }

        # Test contexts
        Context -Name "AtpPolicyForO365 update not required." -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance              = 'Yes'
                    Ensure                        = 'Present'
                    Identity                      = 'Default'
                    GlobalAdminAccount            = $GlobalAdminAccount
                    AllowClickThrough             = $false
                    BlockUrls                     = @()
                    EnableATPForSPOTeamsODB       = $true
                    EnableSafeLinksForO365Clients = $true
                    TrackClicks                   = $true
                }

                Mock -CommandName Get-AtpPolicyForO365 -MockWith {
                    return @{
                        IsSingleInstance              = 'Yes'
                        Ensure                        = 'Present'
                        Identity                      = 'Default'
                        GlobalAdminAccount            = $GlobalAdminAccount
                        AllowClickThrough             = $false
                        BlockUrls                     = @()
                        EnableATPForSPOTeamsODB       = $true
                        EnableSafeLinksForO365Clients = $true
                        TrackClicks                   = $true
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "AtpPolicyForO365 update needed." -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance              = 'Yes'
                    Ensure                        = 'Present'
                    Identity                      = 'Default'
                    GlobalAdminAccount            = $GlobalAdminAccount
                    AllowClickThrough             = $false
                    BlockUrls                     = @()
                    EnableATPForSPOTeamsODB       = $true
                    EnableSafeLinksForO365Clients = $true
                    TrackClicks                   = $true
                }
                Mock -CommandName Get-AtpPolicyForO365 -MockWith {
                    return @{
                        IsSingleInstance              = 'Yes'
                        Ensure                        = 'Present'
                        Identity                      = 'Default'
                        GlobalAdminAccount            = $GlobalAdminAccount
                        AllowClickThrough             = $false
                        BlockUrls                     = @()
                        EnableATPForSPOTeamsODB       = $false
                        EnableSafeLinksForO365Clients = $false
                        TrackClicks                   = $false
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "AtpPolicyForO365 does not exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance              = 'Yes'
                    Ensure                        = 'Present'
                    Identity                      = 'Invalid'
                    GlobalAdminAccount            = $GlobalAdminAccount
                    AllowClickThrough             = $false
                    BlockUrls                     = @()
                    EnableATPForSPOTeamsODB       = $true
                    EnableSafeLinksForO365Clients = $true
                    TrackClicks                   = $true
                }
                Mock -CommandName Get-AtpPolicyForO365 -MockWith {
                    return @{
                        Ensure                        = 'Present'
                        Identity                      = 'Default2' # Drift
                        AllowClickThrough             = $false
                        BlockUrls                     = @()
                        EnableATPForSPOTeamsODB       = $false
                        EnableSafeLinksForO365Clients = $false
                        TrackClicks                   = $false
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should return Absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It "Should throw an Error from the Set method" {
                { Set-TargetResource @testParams } | Should -Throw "EXOAtpPolicyForO365 configurations MUST specify Identity value of 'Default'"
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName Get-AtpPolicyForO365 -MockWith {
                    return @{
                        Identity                      = 'Default'
                        AllowClickThrough             = $false
                        BlockUrls                     = @()
                        EnableATPForSPOTeamsODB       = $false
                        EnableSafeLinksForO365Clients = $false
                        TrackClicks                   = $false
                    }
                }
            }

            It 'Should Reverse Engineer resource from the Export method' {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
