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
    -DscResource "AADCrossTenantAccessPolicyConfigurationDefault" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Update-MgBetaPolicyCrossTenantAccessPolicyDefault -MockWith {
            }

            Mock -CommandName Get-MgUser -MockWith {
                return @{
                    UserPrincipalName = 'John.Smith@contoso.com'
                    Id                = "12345-12345-12345-12345-12345"
                }
            }
            Mock -CommandName Get-MgGroup -MockWith {
                return @{
                    DisplayName = 'My Test Group'
                    Id          = "12345-12345-12345-12345-12345"
                }
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }
        # Test contexts
        Context -Name "The policy is already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                B2BCollaborationOutbound = (New-CimInstance -ClassName MSFT_AADCrossTenantAccessPolicyB2BSetting -Property @{
                        Applications = (New-CimInstance -ClassName MSFT_AADCrossTenantAccessPolicyTargetConfiguration -Property @{
                            AccessType = 'allowed'
                            Targets    = [CimInstance[]]@((New-CimInstance -ClassName MSFT_AADCrossTenantAccessPolicyTarget -Property @{
                                    Target     = 'AllApplications'
                                    TargetType = 'application'
                                } -ClientOnly))
                        } -ClientOnly)
                        UsersAndGroups = (New-CimInstance -ClassName MSFT_AADCrossTenantAccessPolicyTargetConfiguration -Property @{
                            AccessType = 'allowed'
                            Targets    = [CimInstance[]]@((New-CimInstance -ClassName MSFT_AADCrossTenantAccessPolicyTarget -Property @{
                                    Target     = 'My Test Group'
                                    TargetType = 'group'
                                } -ClientOnly))
                        } -ClientOnly)
                    } -ClientOnly)
                    B2BDirectConnectInbound  = (New-CimInstance -ClassName MSFT_AADCrossTenantAccessPolicyB2BSetting -Property @{
                        Applications = (New-CimInstance -ClassName MSFT_AADCrossTenantAccessPolicyTargetConfiguration -Property @{
                            AccessType = 'blocked'
                            Targets    = [CimInstance[]]@((New-CimInstance -ClassName MSFT_AADCrossTenantAccessPolicyTarget -Property @{
                                    Target     = 'AllApplications'
                                    TargetType = 'application'
                                } -ClientOnly))
                        } -ClientOnly)
                        UsersAndGroups = (New-CimInstance -ClassName MSFT_AADCrossTenantAccessPolicyTargetConfiguration -Property @{
                            AccessType = 'blocked'
                            Targets    = [CimInstance[]]@((New-CimInstance -ClassName MSFT_AADCrossTenantAccessPolicyTarget -Property @{
                                    Target     = 'John.Smith@contoso.com'
                                    TargetType = 'user'
                                } -ClientOnly))
                        } -ClientOnly)
                    } -ClientOnly)
                    B2BCollaborationInbound  = (New-CimInstance -ClassName MSFT_AADCrossTenantAccessPolicyB2BSetting -Property @{
                        Applications = (New-CimInstance -ClassName MSFT_AADCrossTenantAccessPolicyTargetConfiguration -Property @{
                            AccessType = 'allowed'
                            Targets    = [CimInstance[]]@((New-CimInstance -ClassName MSFT_AADCrossTenantAccessPolicyTarget -Property @{
                                    Target     = 'Office365'
                                    TargetType = 'application'
                                } -ClientOnly))
                        } -ClientOnly)
                        UsersAndGroups = (New-CimInstance -ClassName MSFT_AADCrossTenantAccessPolicyTargetConfiguration -Property @{
                            AccessType = 'allowed'
                            Targets    = [CimInstance[]]@((New-CimInstance -ClassName MSFT_AADCrossTenantAccessPolicyTarget -Property @{
                                    Target     = 'AllUsers'
                                    TargetType = 'user'
                                } -ClientOnly))
                        } -ClientOnly)
                    } -ClientOnly)
                    Credential               = $Credential;
                    Ensure                   = "Present";
                    IsSingleInstance         = "Yes";
                }

                Mock -CommandName Get-MgBetaPolicyCrossTenantAccessPolicyDefault -MockWith {
                    return @{
                        B2BCollaborationInbound = @{
                            applications = @{
                                accessType = 'allowed'
                                targets    = @(
                                    @{
                                        target     = 'Office365'
                                        targetType = 'application'
                                    }
                                )
                            }
                            usersAndGroups = @{
                                accessType = 'allowed'
                                targets    = @(
                                    @{
                                        target     = 'AllUsers'
                                        targetType = 'user'
                                    }
                                )
                            }
                        }
                        B2BCollaborationOutbound = @{
                            Applications = @{
                                accessType = 'allowed'
                                targets    = @(
                                    @{
                                        target     = 'AllApplications'
                                        targetType = 'application'
                                    }
                                )
                            }
                            usersAndGroups = @{
                                accessType = 'allowed'
                                targets    = @(
                                    @{
                                        target     = 'My Test Group'
                                        targetType = 'group'
                                    }
                                )
                            }
                        }
                        B2BDirectConnectInbound  = @{
                            applications = @{
                                accessType = 'blocked'
                                targets    = @(
                                    @{
                                        target     = 'AllApplications'
                                        targetType = 'application'
                                    }
                                )
                            }
                            usersAndGroups = @{
                                accessType = 'blocked'
                                targets    = @(
                                    @{
                                        target     = 'John.Smith@contoso.com'
                                        targetType = 'user'
                                    }
                                )
                            }
                        }
                    }
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The policy is NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                B2BCollaborationOutbound = (New-CimInstance -ClassName MSFT_AADCrossTenantAccessPolicyB2BSetting -Property @{
                        Applications = (New-CimInstance -ClassName MSFT_AADCrossTenantAccessPolicyTargetConfiguration -Property @{
                            AccessType = 'allowed'
                            Targets    = [CimInstance[]]@((New-CimInstance -ClassName MSFT_AADCrossTenantAccessPolicyTarget -Property @{
                                    Target     = 'AllApplications'
                                    TargetType = 'application'
                                } -ClientOnly))
                        } -ClientOnly)
                        UsersAndGroups = (New-CimInstance -ClassName MSFT_AADCrossTenantAccessPolicyTargetConfiguration -Property @{
                            AccessType = 'allowed'
                            Targets    = [CimInstance[]]@((New-CimInstance -ClassName MSFT_AADCrossTenantAccessPolicyTarget -Property @{
                                    Target     = 'My Test Group'
                                    TargetType = 'group'
                                } -ClientOnly))
                        } -ClientOnly)
                    } -ClientOnly)
                    B2BDirectConnectInbound  = (New-CimInstance -ClassName MSFT_AADCrossTenantAccessPolicyB2BSetting -Property @{
                        Applications = (New-CimInstance -ClassName MSFT_AADCrossTenantAccessPolicyTargetConfiguration -Property @{
                            AccessType = 'blocked'
                            Targets    = [CimInstance[]]@((New-CimInstance -ClassName MSFT_AADCrossTenantAccessPolicyTarget -Property @{
                                    Target     = 'AllApplications'
                                    TargetType = 'application'
                                } -ClientOnly))
                        } -ClientOnly)
                        UsersAndGroups = (New-CimInstance -ClassName MSFT_AADCrossTenantAccessPolicyTargetConfiguration -Property @{
                            AccessType = 'blocked'
                            Targets    = [CimInstance[]]@((New-CimInstance -ClassName MSFT_AADCrossTenantAccessPolicyTarget -Property @{
                                    Target     = 'John.Smith@contoso.com'
                                    TargetType = 'user'
                                } -ClientOnly))
                        } -ClientOnly)
                    } -ClientOnly)
                    B2BCollaborationInbound  = (New-CimInstance -ClassName MSFT_AADCrossTenantAccessPolicyB2BSetting -Property @{
                        Applications = (New-CimInstance -ClassName MSFT_AADCrossTenantAccessPolicyTargetConfiguration -Property @{
                            AccessType = 'allowed'
                            Targets    = [CimInstance[]]@((New-CimInstance -ClassName MSFT_AADCrossTenantAccessPolicyTarget -Property @{
                                    Target     = 'Office365'
                                    TargetType = 'application'
                                } -ClientOnly))
                        } -ClientOnly)
                        UsersAndGroups = (New-CimInstance -ClassName MSFT_AADCrossTenantAccessPolicyTargetConfiguration -Property @{
                            AccessType = 'allowed'
                            Targets    = [CimInstance[]]@((New-CimInstance -ClassName MSFT_AADCrossTenantAccessPolicyTarget -Property @{
                                    Target     = 'AllUsers'
                                    TargetType = 'user'
                                } -ClientOnly))
                        } -ClientOnly)
                    } -ClientOnly)
                    Credential               = $Credential;
                    Ensure                   = "Present";
                    IsSingleInstance         = "Yes";
                }

                Mock -CommandName Get-MgBetaPolicyCrossTenantAccessPolicyDefault -MockWith {
                    return @{
                        B2BCollaborationInbound = @{
                            applications = @{
                                accessType = 'allowed'
                                targets    = @(
                                    @{
                                        target     = 'DriftApp' #Drift
                                        targetType = 'application'
                                    }
                                )
                            }
                            usersAndGroups = @{
                                accessType = 'allowed'
                                targets    = @(
                                    @{
                                        target     = 'AllUsers'
                                        targetType = 'user'
                                    }
                                )
                            }
                        }
                        B2BCollaborationOutbound = @{
                            Applications = @{
                                accessType = 'allowed'
                                targets    = @(
                                    @{
                                        target     = 'AllApplications'
                                        targetType = 'application'
                                    }
                                )
                            }
                            usersAndGroups = @{
                                accessType = 'allowed'
                                targets    = @(
                                    @{
                                        target     = 'My Drift Group' # Drift
                                        targetType = 'group'
                                    }
                                )
                            }
                        }
                        B2BDirectConnectInbound  = @{
                            applications = @{
                                accessType = 'blocked'
                                targets    = @(
                                    @{
                                        target     = 'AllApplications'
                                        targetType = 'application'
                                    }
                                )
                            }
                            usersAndGroups = @{
                                accessType = 'blocked'
                                targets    = @(
                                    @{
                                        target     = 'John.Smith@contoso.com'
                                        targetType = 'user'
                                    }
                                )
                            }
                        }
                    }
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should update the instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgBetaPolicyCrossTenantAccessPolicyDefault -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaPolicyCrossTenantAccessPolicyDefault -MockWith {
                    return @{
                        B2BCollaborationInbound = @{
                            applications = @{
                                accessType = 'allowed'
                                targets    = @(
                                    @{
                                        target     = 'Office365'
                                        targetType = 'application'
                                    }
                                )
                            }
                            usersAndGroups = @{
                                accessType = 'allowed'
                                targets    = @(
                                    @{
                                        target     = 'AllUsers'
                                        targetType = 'user'
                                    }
                                )
                            }
                        }
                        B2BCollaborationOutbound = @{
                            Applications = @{
                                accessType = 'allowed'
                                targets    = @(
                                    @{
                                        target     = 'AllApplications'
                                        targetType = 'application'
                                    }
                                )
                            }
                            usersAndGroups = @{
                                accessType = 'allowed'
                                targets    = @(
                                    @{
                                        target     = 'My Test Group'
                                        targetType = 'group'
                                    },
                                    @{
                                        target     = 'Bob.Houle@contoso.com'
                                        targetType = 'user'
                                    }
                                )
                            }
                        }
                        B2BDirectConnectInbound  = @{
                            applications = @{
                                accessType = 'blocked'
                                targets    = @(
                                    @{
                                        target     = 'AllApplications'
                                        targetType = 'application'
                                    }
                                )
                            }
                            usersAndGroups = @{
                                accessType = 'blocked'
                                targets    = @(
                                    @{
                                        target     = 'John.Smith@contoso.com'
                                        targetType = 'user'
                                    }
                                )
                            }
                        }
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
