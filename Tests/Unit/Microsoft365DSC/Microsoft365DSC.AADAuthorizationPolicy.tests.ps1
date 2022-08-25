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
    -DscResource "AADAuthorizationPolicy" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {
            $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

            $Global:PartialExportFileName = "c:\TestPath"
            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {
                return "FakeDSCContent"
            }
            Mock -CommandName Save-M365DSCPartialExport -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {

            }

            Mock -CommandName Remove-PSSession -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }
        }

        # Test contexts
        # NB The Authorization Policy always exists and cannot be removed or a new one added

        Context -Name "The role definition exists and values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance = 'Yes'
                    DisplayName = 'Authorization Policy'
                    Description = 'something'
                    allowedToSignUpEmailBasedSubscriptions = $true
                    allowedToUseSSPR = $true
                    allowEmailVerifiedUsersToJoinOrganization = $true
                    AllowInvitesFrom = "Everyone"
                    blockMsolPowerShell = $false
                    DefaultuserRoleAllowedToCreateApps = $true
                    DefaultUserRoleAllowedToCreateSecurityGroups = $true
                    DefaultUserRoleAllowedToReadOtherUsers = $true
                    PermissionGrantPolicyIdsAssignedToDefaultUserRole = [string[]]@()
                    GuestUserRole    = 'Guest'
                    Ensure           = "Present"
                    Credential       = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }
                Mock -CommandName Get-MgPolicyAuthorizationPolicy -MockWith {
                    $AADAuthPol = [pscustomobject]@{
                        Id = "authorizationPolicy"
                        DisplayName = 'Authorization Policy'
                        Description = 'something'
                        allowedToSignUpEmailBasedSubscriptions = $true
                        allowedToUseSSPR = $true
                        allowEmailVerifiedUsersToJoinOrganization = $true
                        AllowInvitesFrom = "Everyone"
                        blockMsolPowerShell = $false
                        defaultUserRolePermissions = [pscustomobject]@{
                                allowedToCreateApps = $true
                                allowedToCreateSecurityGroups = $true
                                allowedToReadOtherUsers = $true
                                PermissionGrantPoliciesAssigned = [string[]]@()
                            }
                        GuestUserRoleId = '10dae51f-b6af-4016-8d66-8c2a99b929b3' # Guest
                    }
                    return $AADAuthPol
                }
            }

            It "Should return Values from the get method" {
                Get-TargetResource @testParams
                Should -Invoke -CommandName "Get-MgPolicyAuthorizationPolicy" -Exactly 1
            }

            It 'Should return true from the test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "Values are not in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance = 'Yes'
                    DisplayName = 'Authorization Policy'
                    Description = 'something'
                    allowedToSignUpEmailBasedSubscriptions = $False
                    allowedToUseSSPR = $false
                    allowEmailVerifiedUsersToJoinOrganization = $false
                    AllowInvitesFrom = 'AdminsAndGuestInviters'
                    blockMsolPowerShell = $false
                    DefaultuserRoleAllowedToCreateApps = $true
                    DefaultUserRoleAllowedToCreateSecurityGroups = $true
                    DefaultUserRoleAllowedToReadOtherUsers = $true
                    PermissionGrantPolicyIdsAssignedToDefaultUserRole = [string[]]@()
                    GuestUserRole = 'RestrictedGuest'
                    Ensure          = "Present"
                    Credential      = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName Get-MgPolicyAuthorizationPolicy -MockWith {
                    $AADAuthPol = [pscustomobject]@{
                        Id = "authorizationPolicy"
                        DisplayName = 'Authorization Policy'
                        Description = 'something'
                        allowedToSignUpEmailBasedSubscriptions = $true
                        allowedToUseSSPR = $true
                        allowEmailVerifiedUsersToJoinOrganization = $true
                        AllowInvitesFrom = "Everyone"
                        blockMsolPowerShell = $false
                        defaultUserRolePermissions = [pscustomobject]@{
                                allowedToCreateApps = $true
                                allowedToCreateSecurityGroups = $true
                                allowedToReadOtherUsers = $true
                                PermissionGrantPoliciesAssigned = [string[]]@()
                            }
                        GuestUserRoleId = '10dae51f-b6af-4016-8d66-8c2a99b929b3' # Guest
                    }
                    return $AADAuthPol
                }


                Mock -CommandName Update-MgPolicyAuthorizationPolicy -MockWith {
                }

            }

            It "Should return values from the get method" {
                Get-TargetResource @testParams
                Should -Invoke -CommandName "Get-MgPolicyAuthorizationPolicy" -Exactly 1
            }

            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should call the set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Update-MgPolicyAuthorizationPolicy' -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName Get-MgPolicyAuthorizationPolicy -MockWith {
                    $AADAuthPol = [pscustomobject]@{
                        DisplayName = 'Authorization Policy'
                        Description = 'something'
                        allowedToSignUpEmailBasedSubscriptions = $true
                        allowedToUseSSPR = $true
                        allowEmailVerifiedUsersToJoinOrganization = $true
                        AllowInvitesFrom = "Everyone"
                        blockMsolPowerShell = $false
                        defaultUserRolePermissions = [pscustomobject]@{
                                allowedToCreateApps = $true
                                allowedToCreateSecurityGroups = $true
                                allowedToReadOtherUsers = $true
                                PermissionGrantPoliciesAssigned = [string[]]@()
                            }
                        GuestUserRoleId = '10dae51f-b6af-4016-8d66-8c2a99b929b3' # Guest
                    }
                    return $AADAuthPol
                }
            }

            It "Should reverse engineer resource from the export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
