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
    -DscResource 'AzureRoleAssignmentScheduleRequest' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {
            $Global:CurrentModeIsExport = $false
            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)
            $Script:exportedInstances = $null
            $Script:ExportMode = $null
            Mock -CommandName Add-M365DSCTelemetryEvent -MockWith {
            }

            Mock -ModuleName M365DSCUtil -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName New-AzRoleAssignmentScheduleRequest -MockWith {
            }

            Mock -CommandName Get-AzADUser -MockWith {
                return @{
                    Id = '123456'
                    UserPrincipalName = 'John.Smith@contoso.com'
                }
            }

            Mock -CommandName Get-AzRoleDefinition -MockWith {
                return @{
                    Name = 'Owner'
                    Id   = '12345'
                }
            }

            Mock -CommandName Get-AzRoleAssignmentSchedule -MockWith {
                return @{
                    Name             = '12345-12345-12345-12345-12345'
                    RoleDefinitionId = '/subscriptions/12345678-1234-1234-1234-123456789012/providers/Microsoft.Authorization/roleDefinitions/12345'
                    Scope            = '/subscriptions/12345678-1234-1234-1234-123456789012'
                    PrincipalId      = '123456'
                    PrincipalType    = 'User'
                    StartDateTime    = [System.DateTime]::Parse('2023-09-01T02:40:44Z')
                    EndDateTime      = [System.DateTime]::Parse('2025-10-31T02:40:09Z')
                }
            }

            # Mock Write-M365DSCHost to hide output during the tests
            Mock -CommandName Write-M365DSCHost -MockWith {
            }
            $Script:exportedInstances = $null
            $Script:ExportMode = $false
            $Script:PrincipalByNameCache = $null
            $Script:PrincipalByIdCache = $null
            $Script:RoleDefinitions = $null
            $Script:AllSchedules = $null
        }
        # Test contexts
        Context -Name 'The instance should exist but it DOES NOT' -Fixture {
            BeforeAll {
                $Script:RoleDefinitions = $null
                $Script:AllSchedules = $null
                $testParams = @{
                    DirectoryScopeId     = "/subscriptions/12345678-1234-1234-1234-123456789012";
                    Ensure               = "Present";
                    Principal            = "John.Smith@contoso.com";
                    PrincipalType        = "User"
                    RoleDefinition       = "Owner";
                    ScheduleInfo         = New-CimInstance -ClassName MSFT_AzureRoleAssignmentScheduleRequestSchedule -Property @{
                        startDateTime   = '2023-09-01T02:40:44Z'
                        expiration = New-CimInstance -ClassName MSFT_AzureRoleAssignmentScheduleRequestScheduleExpiration -Property @{
                            endDateTime = '2025-10-31T02:40:09Z'
                            type        = 'afterDateTime'
                        } -ClientOnly
                    } -ClientOnly
                    Credential  = $Credential
                }

                Mock -CommandName Get-AzRoleAssignmentSchedule -MockWith {
                    return $null
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should Create the instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-AzRoleAssignmentScheduleRequest -Exactly 1
            }
        }

        Context -Name 'The instance exists but it SHOULD NOT' -Fixture {
            BeforeAll {
                $Script:RoleDefinitions = $null
                $Script:AllSchedules = $null
                $testParams = @{
                    DirectoryScopeId     = "/subscriptions/12345678-1234-1234-1234-123456789012";
                    Ensure               = "Absent";
                    PrincipalType        = "User"
                    Principal            = "John.Smith@contoso.com";
                    RoleDefinition       = "Owner";
                    ScheduleInfo         = New-CimInstance -ClassName MSFT_AzureRoleAssignmentScheduleRequestSchedule -Property @{
                        startDateTime   = '2023-09-01T02:40:44Z'
                        expiration = New-CimInstance -ClassName MSFT_AzureRoleAssignmentScheduleRequestScheduleExpiration -Property @{
                            endDateTime = '2025-10-31T02:40:09Z'
                            type        = 'afterDateTime'
                        } -ClientOnly
                    } -ClientOnly
                    Credential  = $Credential
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-AzRoleAssignmentScheduleRequest -Exactly 1
            }
        }
        Context -Name 'The instance Exists and Values are already in the desired state' -Fixture {
            BeforeAll {
                $Script:RoleDefinitions = $null
                $Script:AllSchedules = $null
                $testParams = @{
                    DirectoryScopeId     = "/subscriptions/12345678-1234-1234-1234-123456789012";
                    Ensure               = "Present";
                    PrincipalType        = "User"
                    Principal            = "John.Smith@contoso.com";
                    RoleDefinition       = "Owner";
                    ScheduleInfo         = New-CimInstance -ClassName MSFT_AzureRoleAssignmentScheduleRequestSchedule -Property @{
                        startDateTime   = '2023-09-01T02:40:44Z'
                        expiration = New-CimInstance -ClassName MSFT_AzureRoleAssignmentScheduleRequestScheduleExpiration -Property @{
                            type        = 'afterDateTime'
                        } -ClientOnly
                    } -ClientOnly
                    Credential  = $Credential
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }
        Context -Name 'The instance Exists and specified Values are NOT in the desired state' -Fixture {
            BeforeAll {
                $Script:RoleDefinitions = $null
                $Script:AllSchedules = $null
                $testParams = @{
                    DirectoryScopeId     = "/subscriptions/12345678-1234-1234-1234-123456789012";
                    Ensure               = "Present";
                    PrincipalType        = "User"
                    Principal            = "John.Smith@contoso.com";
                    RoleDefinition       = "Owner";
                    ScheduleInfo         = New-CimInstance -ClassName MSFT_AzureRoleAssignmentScheduleRequestSchedule -Property @{
                        startDateTime   = '2025-09-01T02:40:44Z'
                        expiration = New-CimInstance -ClassName MSFT_AzureRoleAssignmentScheduleRequestScheduleExpiration -Property @{
                            endDateTime = (Get-Date).AddYears(1).ToString("yyyy-MM-ddTHH:mm:ssZ") # Drift
                            type        = 'afterDateTime'
                        } -ClientOnly
                    } -ClientOnly
                    Credential  = $Credential
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set to Update the instance' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-AzRoleAssignmentScheduleRequest -Exactly 1
            }
        }
        Context -Name 'Set-TargetResource should throw when Role Definition is not found' -Fixture {
            BeforeAll {
                $Script:RoleDefinitions = $null
                $Script:AllSchedules = $null
                $testParams = @{
                    DirectoryScopeId     = "/subscriptions/12345678-1234-1234-1234-123456789012";
                    Ensure               = "Present";
                    Principal            = "John.Smith@contoso.com";
                    PrincipalType        = "User"
                    RoleDefinition       = "NonExistentRole";
                    ScheduleInfo         = New-CimInstance -ClassName MSFT_AzureRoleAssignmentScheduleRequestSchedule -Property @{
                        startDateTime   = '2023-09-01T02:40:44Z'
                        expiration = New-CimInstance -ClassName MSFT_AzureRoleAssignmentScheduleRequestScheduleExpiration -Property @{
                            endDateTime = '2025-10-31T02:40:09Z'
                            type        = 'afterDateTime'
                        } -ClientOnly
                    } -ClientOnly
                    Credential  = $Credential
                }

                Mock -CommandName Get-AzRoleAssignmentSchedule -MockWith {
                    return $null
                }

                Mock -CommandName Get-AzRoleDefinition -MockWith {
                    return $null
                }
            }

            It 'Should throw when Role Definition lookup fails' {
                { Set-TargetResource @testParams } | Should -Throw -ExpectedMessage "*Couldn't find Role Definition*"
            }
        }

        Context -Name 'Set-TargetResource should throw when Principal is not found' -Fixture {
            BeforeAll {
                $Script:RoleDefinitions = $null
                $Script:AllSchedules = $null
                $testParams = @{
                    DirectoryScopeId     = "/subscriptions/12345678-1234-1234-1234-123456789012";
                    Ensure               = "Present";
                    Principal            = "NonExistent@contoso.com";
                    PrincipalType        = "User"
                    RoleDefinition       = "Owner";
                    ScheduleInfo         = New-CimInstance -ClassName MSFT_AzureRoleAssignmentScheduleRequestSchedule -Property @{
                        startDateTime   = '2023-09-01T02:40:44Z'
                        expiration = New-CimInstance -ClassName MSFT_AzureRoleAssignmentScheduleRequestScheduleExpiration -Property @{
                            endDateTime = '2025-10-31T02:40:09Z'
                            type        = 'afterDateTime'
                        } -ClientOnly
                    } -ClientOnly
                    Credential  = $Credential
                }

                Mock -CommandName Get-AzRoleAssignmentSchedule -MockWith {
                    return $null
                }

                Mock -CommandName Get-AzADUser -MockWith {
                    return $null
                }
            }

            It 'Should throw when Principal lookup fails' {
                { Set-TargetResource @testParams } | Should -Throw -ExpectedMessage "*Couldn't find Principal*"
            }
        }

        Context -Name 'Management Group scope - The instance should exist but it DOES NOT' -Fixture {
            BeforeAll {
                $Script:RoleDefinitions = $null
                $Script:AllSchedules = $null
                $testParams = @{
                    DirectoryScopeId     = "/providers/Microsoft.Management/managementGroups/MyManagementGroup";
                    Ensure               = "Present";
                    Principal            = "John.Smith@contoso.com";
                    PrincipalType        = "User"
                    RoleDefinition       = "Reader";
                    ScheduleInfo         = New-CimInstance -ClassName MSFT_AzureRoleAssignmentScheduleRequestSchedule -Property @{
                        startDateTime   = '2023-09-01T02:40:44Z'
                        expiration = New-CimInstance -ClassName MSFT_AzureRoleAssignmentScheduleRequestScheduleExpiration -Property @{
                            endDateTime = (Get-Date).AddYears(1).ToString("yyyy-MM-ddTHH:mm:ssZ")
                            type        = 'afterDateTime'
                        } -ClientOnly
                    } -ClientOnly
                    Credential  = $Credential
                }

                Mock -CommandName Get-AzRoleAssignmentSchedule -MockWith {
                    return $null
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should Create the instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-AzRoleAssignmentScheduleRequest -Exactly 1
            }
        }

        Context -Name 'Root Management Group scope - The instance Exists and Values are already in the desired state' -Fixture {
            BeforeAll {
                $Script:RoleDefinitions = $null
                $Script:AllSchedules = $null
                $testParams = @{
                    DirectoryScopeId     = "/providers/Microsoft.Management/managementGroups/rootGroup";
                    Ensure               = "Present";
                    PrincipalType        = "User"
                    Principal            = "John.Smith@contoso.com";
                    RoleDefinition       = "Owner";
                    ScheduleInfo         = New-CimInstance -ClassName MSFT_AzureRoleAssignmentScheduleRequestSchedule -Property @{
                        startDateTime   = '2023-09-01T02:40:44Z'
                        expiration = New-CimInstance -ClassName MSFT_AzureRoleAssignmentScheduleRequestScheduleExpiration -Property @{
                            type        = 'afterDateTime'
                        } -ClientOnly
                    } -ClientOnly
                    Credential  = $Credential
                }

                Mock -CommandName Get-AzRoleAssignmentSchedule -MockWith {
                    return @{
                        Name             = '12345-12345-12345-12345-12345'
                        RoleDefinitionId = '/providers/Microsoft.Management/managementGroups/rootGroup/providers/Microsoft.Authorization/roleDefinitions/12345'
                        Scope            = '/providers/Microsoft.Management/managementGroups/rootGroup'
                        PrincipalId      = '123456'
                        PrincipalType    = 'User'
                        StartDateTime    = [System.DateTime]::Parse('2023-09-01T02:40:44Z')
                        EndDateTime      = [System.DateTime]::Parse('2025-10-31T02:40:09Z')
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

        Context -Name 'Group principal with noExpiration - The instance should exist but it DOES NOT' -Fixture {
            BeforeAll {
                $Script:RoleDefinitions = $null
                $Script:AllSchedules = $null
                $testParams = @{
                    DirectoryScopeId     = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rg-production";
                    Ensure               = "Present";
                    Principal            = "SecurityGroup";
                    PrincipalType        = "Group"
                    RoleDefinition       = "Contributor";
                    ScheduleInfo         = New-CimInstance -ClassName MSFT_AzureRoleAssignmentScheduleRequestSchedule -Property @{
                        startDateTime = '2024-01-01T00:00:00Z'
                        expiration = New-CimInstance -ClassName MSFT_AzureRoleAssignmentScheduleRequestScheduleExpiration -Property @{
                            type = 'noExpiration'
                        } -ClientOnly
                    } -ClientOnly
                    Credential  = $Credential
                }

                Mock -CommandName Get-AzADGroup -MockWith {
                    return @{
                        Id          = '654321'
                        DisplayName = 'SecurityGroup'
                    }
                }

                Mock -CommandName Get-AzRoleDefinition -MockWith {
                    return @{
                        Name = 'Contributor'
                        Id   = '67890'
                    }
                }

                Mock -CommandName Get-AzRoleAssignmentSchedule -MockWith {
                    return $null
                }
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Create the instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-AzRoleAssignmentScheduleRequest -Exactly 1
            }
        }

        Context -Name 'noExpiration with root management group - The instance Exists and Values are already in the desired state' -Fixture {
            BeforeAll {
                $Script:RoleDefinitions = $null
                $Script:AllSchedules = $null
                $testParams = @{
                    DirectoryScopeId     = "/providers/Microsoft.Management/managementGroups/rootGroup";
                    Ensure               = "Present";
                    PrincipalType        = "User"
                    Principal            = "John.Smith@contoso.com";
                    RoleDefinition       = "Owner";
                    ScheduleInfo         = New-CimInstance -ClassName MSFT_AzureRoleAssignmentScheduleRequestSchedule -Property @{
                        expiration = New-CimInstance -ClassName MSFT_AzureRoleAssignmentScheduleRequestScheduleExpiration -Property @{
                            type = 'noExpiration'
                        } -ClientOnly
                    } -ClientOnly
                    Credential  = $Credential
                }

                Mock -CommandName Get-AzRoleAssignmentSchedule -MockWith {
                    return @{
                        Name             = '12345-12345-12345-12345-12345'
                        RoleDefinitionId = '/providers/Microsoft.Management/managementGroups/rootGroup/providers/Microsoft.Authorization/roleDefinitions/12345'
                        Scope            = '/providers/Microsoft.Management/managementGroups/rootGroup'
                        PrincipalId      = '123456'
                        PrincipalType    = 'User'
                        StartDateTime    = [System.DateTime]::Parse('2021-09-01T14:30:00Z')
                        EndDateTime      = $null
                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Should format PM StartDateTime with 24-hour format' {
                $result = Get-TargetResource @testParams
                $result.ScheduleInfo.StartDateTime | Should -Be '2021-09-01T14:30:00Z'
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Script:RoleDefinitions = $null
                $Script:AllSchedules = $null
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-AzManagementGroup -MockWith {
                    return @()
                }

                Mock -CommandName Get-AzSubscription -MockWith {
                    return @()
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
