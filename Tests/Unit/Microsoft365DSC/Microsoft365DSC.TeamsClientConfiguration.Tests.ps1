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
    -DscResource "TeamsClientConfiguration" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString "Pass@word1)" -AsPlainText -Force
            $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }
            Mock -CommandName Get-CsTeamsClientConfiguration -MockWith {
                return @{
                    AllowBox                         = $True;
                    AllowDropBox                     = $True;
                    AllowEmailIntoChannel            = $True;
                    AllowGoogleDrive                 = $True;
                    AllowGuestUser                   = $True;
                    AllowOrganizationTab             = $True;
                    AllowResourceAccountSendMessage  = $True;
                    AllowScopedPeopleSearchandAccess = $False;
                    AllowShareFile                   = $True;
                    AllowSkypeBusinessInterop        = $True;
                    ContentPin                       = "RequiredOutsideScheduleMeeting";
                    Identity                         = "Global";
                    ResourceAccountContentAccess     = "NoAccess";
                    RestrictedSenderList             = @("john.smith@contoso.com")
                }
            }
            Mock -CommandName Set-CsTeamsClientConfiguration -MockWith {
            }
        }

        # Test contexts
        Context -Name "When settings are correctly set" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowBox                         = $True;
                    AllowDropBox                     = $True;
                    AllowEmailIntoChannel            = $True;
                    AllowGoogleDrive                 = $True;
                    AllowGuestUser                   = $True;
                    AllowOrganizationTab             = $True;
                    AllowResourceAccountSendMessage  = $True;
                    AllowScopedPeopleSearchandAccess = $False;
                    AllowShareFile                   = $True;
                    AllowSkypeBusinessInterop        = $True;
                    ContentPin                       = "RequiredOutsideScheduleMeeting";
                    GlobalAdminAccount               = $GlobalAdminAccount;
                    Identity                         = "Global";
                    ResourceAccountContentAccess     = "NoAccess";
                    RestrictedSenderList             = @("john.smith@contoso.com")
                }
            }

            It "Should return true for the AllowBox property from the Get method" {
                (Get-TargetResource @testParams).AllowBox | Should -Be $True
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should -Be $true
            }

            It "Updates the Team fun settings in the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "When settings are NOT correctly set" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowBox                         = $false;
                    AllowDropBox                     = $True;
                    AllowEmailIntoChannel            = $True;
                    AllowGoogleDrive                 = $True;
                    AllowGuestUser                   = $True;
                    AllowOrganizationTab             = $True;
                    AllowResourceAccountSendMessage  = $True;
                    AllowScopedPeopleSearchandAccess = $False;
                    AllowShareFile                   = $True;
                    AllowSkypeBusinessInterop        = $True;
                    ContentPin                       = "RequiredOutsideScheduleMeeting";
                    GlobalAdminAccount               = $GlobalAdminAccount;
                    Identity                         = "Global";
                    ResourceAccountContentAccess     = "NoAccess";
                    RestrictedSenderList             = @("john.smith@contoso.com", "test@contoso.com")
                }
            }

            It "Should return true for the AllowBox property from the Get method" {
                (Get-TargetResource @testParams).AllowBox | Should -Be $True
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Updates the Teams Client settings in the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-CsTeamsClientConfiguration
            }
        }


        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                It "Should Reverse Engineer resource from the Export method" {
                    Export-TargetResource @testParams
                }
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
