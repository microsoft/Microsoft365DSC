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
    -DscResource 'AADAuthorizationPolicy' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'test@password1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            $Global:PartialExportFileName = 'c:\TestPath'

            Mock -CommandName Save-M365DSCPartialExport -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {

            }

            Mock -CommandName Remove-PSSession -MockWith {

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
        # NB The Authorization Policy always exists and cannot be removed or a new one added

        Context -Name 'The role definition exists and values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance                                  = 'Yes'
                    DisplayName                                       = 'Authorization Policy'
                    Description                                       = 'something'
                    allowedToSignUpEmailBasedSubscriptions            = $true
                    allowedToUseSSPR                                  = $true
                    allowEmailVerifiedUsersToJoinOrganization         = $true
                    AllowInvitesFrom                                  = 'Everyone'
                    blockMsolPowerShell                               = $false
                    DefaultuserRoleAllowedToCreateApps                = $true
                    DefaultUserRoleAllowedToCreateSecurityGroups      = $true
                    DefaultUserRoleAllowedToReadOtherUsers            = $true
                    PermissionGrantPolicyIdsAssignedToDefaultUserRole = [string[]]@()
                    GuestUserRole                                     = 'Guest'
                    Ensure                                            = 'Present'
                    Credential                                        = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }
                Mock -CommandName Get-MgBetaPolicyAuthorizationPolicy -MockWith {
                    $AADAuthPol = [pscustomobject]@{
                        Id                                                  = 'authorizationPolicy'
                        DisplayName                                         = 'Authorization Policy'
                        Description                                         = 'something'
                        AllowedToSignUpEmailBasedSubscriptions              = $true
                        AllowedToUseSspr                                    = $true
                        AllowEmailVerifiedUsersToJoinOrganization           = $true
                        AllowInvitesFrom                                    = 'Everyone'
                        BlockMsolPowerShell                                 = $false
                        PermissionGrantPolicyIdsAssignedToDefaultUserRole   = [string[]]@()
                        DefaultUserRolePermissions                          = [pscustomobject]@{
                        AllowedToCreateApps                    = $true
                        AllowedToCreateSecurityGroups          = $true
                        AllowedToReadOtherUsers                = $true
                        }
                        GuestUserRoleId                                     = '10dae51f-b6af-4016-8d66-8c2a99b929b3' # Guest
                    }
                    return $AADAuthPol
                }
            }

            It 'Should return Values from the get method' {
                Get-TargetResource @testParams
                Should -Invoke -CommandName 'Get-MgBetaPolicyAuthorizationPolicy' -Exactly 1
            }

            It 'Should return true from the test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'Values are not in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance                                  = 'Yes'
                    DisplayName                                       = 'Authorization Policy'
                    Description                                       = 'something'
                    allowedToSignUpEmailBasedSubscriptions            = $False
                    allowedToUseSSPR                                  = $false
                    allowEmailVerifiedUsersToJoinOrganization         = $false
                    AllowInvitesFrom                                  = 'AdminsAndGuestInviters'
                    blockMsolPowerShell                               = $false
                    DefaultuserRoleAllowedToCreateApps                = $true
                    DefaultUserRoleAllowedToCreateSecurityGroups      = $true
                    DefaultUserRoleAllowedToReadOtherUsers            = $true
                    PermissionGrantPolicyIdsAssignedToDefaultUserRole = [string[]]@()
                    GuestUserRole                                     = 'RestrictedGuest'
                    Ensure                                            = 'Present'
                    Credential                                        = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-MgBetaPolicyAuthorizationPolicy -MockWith {
                    $AADAuthPol = [pscustomobject]@{
                        Id                                                  = 'authorizationPolicy'
                        DisplayName                                         = 'Authorization Policy'
                        Description                                         = 'something'
                        allowedToSignUpEmailBasedSubscriptions              = $true
                        allowedToUseSSPR                                    = $true
                        allowEmailVerifiedUsersToJoinOrganization           = $true
                        AllowInvitesFrom                                    = 'Everyone'
                        blockMsolPowerShell                                 = $false
                        PermissionGrantPolicyIdsAssignedToDefaultUserRole   = [string[]]@()
                        defaultUserRolePermissions                          = [pscustomobject]@{
                            allowedToCreateApps             = $true
                            allowedToCreateSecurityGroups   = $true
                            allowedToReadOtherUsers         = $true
                        }
                        GuestUserRoleId                                     = '10dae51f-b6af-4016-8d66-8c2a99b929b3' # Guest
                    }
                    return $AADAuthPol
                }


                Mock -CommandName Update-MgBetaPolicyAuthorizationPolicy -MockWith {
                }

            }

            It 'Should return values from the get method' {
                Get-TargetResource @testParams
                Should -Invoke -CommandName 'Get-MgBetaPolicyAuthorizationPolicy' -Exactly 1
            }

            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Update-MgBetaPolicyAuthorizationPolicy' -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-MgBetaPolicyAuthorizationPolicy -MockWith {
                    $AADAuthPol = [pscustomobject]@{
                        DisplayName                                         = 'Authorization Policy'
                        Description                                         = 'something'
                        allowedToSignUpEmailBasedSubscriptions              = $true
                        allowedToUseSSPR                                    = $true
                        allowEmailVerifiedUsersToJoinOrganization           = $true
                        AllowInvitesFrom                                    = 'Everyone'
                        blockMsolPowerShell                                 = $false
                        PermissionGrantPolicyIdsAssignedToDefaultUserRole   = [string[]]@()
                        defaultUserRolePermissions                          = [pscustomobject]@{
                            allowedToCreateApps             = $true
                            allowedToCreateSecurityGroups   = $true
                            allowedToReadOtherUsers         = $true
                        }
                        GuestUserRoleId                                     = '10dae51f-b6af-4016-8d66-8c2a99b929b3' # Guest
                    }
                    return $AADAuthPol
                }
            }

            It 'Should reverse engineer resource from the export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
