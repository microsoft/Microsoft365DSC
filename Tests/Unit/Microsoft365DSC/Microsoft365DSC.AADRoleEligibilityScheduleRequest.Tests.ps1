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
    -DscResource 'AADRoleEligibilityScheduleRequest' -GenericStubModule $GenericStubPath

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

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName New-MgBetaRoleManagementDirectoryRoleEligibilityScheduleRequest -MockWith {
            }

            Mock -CommandName Get-MgUser -MockWith {
                return @{
                    Id = '123456'
                    UserPrincipalName = 'John.Smith@contoso.com'
                }
            }

            Mock -CommandName Get-MgBetaRoleManagementDirectoryRoleDefinition -MockWith {
                return @{
                    DisplayName = 'Teams Communications Administrator'
                    Id          = '12345'
                }
            }
            Mock -CommandName Get-MgBetaRoleManagementDirectoryRoleEligibilitySchedule -MockWith {
                return @{
                    Id          = '12345-12345-12345-12345-12345'
                }
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }
        # Test contexts
        Context -Name 'The instance should exist but it DOES NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    Action               = "AdminAssign";
                    DirectoryScopeId     = "/";
                    Ensure               = "Present";
                    IsValidationOnly     = $False;
                    Principal            = "John.Smith@contoso.com";
                    RoleDefinition       = "Teams Communications Administrator";
                    ScheduleInfo         = New-CimInstance -ClassName MSFT_AADRoleEligibilityScheduleRequestSchedule -Property @{
                            startDateTime             = '2023-09-01T02:40:44Z'
                            expiration = New-CimInstance -ClassName MSFT_AADRoleEligibilityScheduleRequestScheduleExpiration -Property @{
                                endDateTime = '2025-10-31T02:40:09Z'
                                type        = 'afterDateTime'
                            } -ClientOnly
                        } -ClientOnly
                    Credential  = $Credential
                }

                Mock -CommandName Get-MgBetaRoleManagementDirectoryRoleEligibilityScheduleRequest -MockWith {
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
                Should -Invoke -CommandName New-MgBetaRoleManagementDirectoryRoleEligibilityScheduleRequest -Exactly 1
            }
        }

        Context -Name 'The instance exists but it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    Action               = "AdminAssign";
                    DirectoryScopeId     = "/";
                    Ensure               = "Absent";
                    IsValidationOnly     = $False;
                    Principal            = "John.Smith@contoso.com";
                    RoleDefinition       = "Teams Communications Administrator";
                    ScheduleInfo         = New-CimInstance -ClassName MSFT_AADRoleEligibilityScheduleRequestSchedule -Property @{

                            expiration = New-CimInstance -ClassName MSFT_AADRoleEligibilityScheduleRequestScheduleExpiration -Property @{

                                type        = 'afterDateTime'
                            } -ClientOnly
                        } -ClientOnly
                    Credential  = $Credential
                }

                Mock -CommandName Get-MgBetaRoleManagementDirectoryRoleEligibilityScheduleRequest -MockWith {
                    return @{
                        Action               = "AdminAssign";
                        Id                   = '12345-12345-12345-12345-12345'
                        DirectoryScopeId     = "/";
                        IsValidationOnly     = $False;
                        PrincipalId          = "123456";
                        RoleDefinitionId     = "12345";
                        ScheduleInfo         = @{
                            startDateTime             = [System.DateTime]::Parse('2023-09-01T02:40:44Z')
                            expiration                = @{
                                    endDateTime = [System.DateTime]::Parse('2025-10-31T02:40:09Z')
                                    type        = 'afterDateTime'
                                }
                        };
                    }
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
                Should -Invoke -CommandName New-MgBetaRoleManagementDirectoryRoleEligibilityScheduleRequest -Exactly 1
            }
        }
        Context -Name 'The instance Exists and Values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    Action               = "AdminAssign";
                    DirectoryScopeId     = "/";
                    Ensure               = "Present";
                    IsValidationOnly     = $False;
                    Principal            = "John.Smith@contoso.com";
                    RoleDefinition       = "Teams Communications Administrator";
                    ScheduleInfo         = New-CimInstance -ClassName MSFT_AADRoleEligibilityScheduleRequestSchedule -Property @{

                            expiration = New-CimInstance -ClassName MSFT_AADRoleEligibilityScheduleRequestScheduleExpiration -Property @{
                                type        = 'afterDateTime'
                            } -ClientOnly
                        } -ClientOnly
                    Credential  = $Credential
                }

                Mock -CommandName Get-MgBetaRoleManagementDirectoryRoleEligibilityScheduleRequest -MockWith {
                    return @{
                        Action               = "AdminAssign";
                        Id                   = '12345-12345-12345-12345-12345'
                        DirectoryScopeId     = "/";
                        IsValidationOnly     = $False;
                        PrincipalId          = "123456";
                        RoleDefinitionId     = "12345";
                        ScheduleInfo         = @{
                            expiration                = @{
                                    type        = 'afterDateTime'
                                }
                        };
                    }
                }
                Mock -CommandName Get-MgBetaRoleManagementDirectoryRoleEligibilitySchedule -MockWith {
                    return @{
                        Action               = "AdminAssign";
                        Id                   = '12345-12345-12345-12345-12345'
                        DirectoryScopeId     = "/";
                        IsValidationOnly     = $False;
                        PrincipalId          = "123456";
                        RoleDefinitionId     = "12345";
                        ScheduleInfo         = @{
                            expiration                = @{
                                    type        = 'afterDateTime'
                                }
                        };
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
        Context -Name 'The instance Exists and specified Values are NOT in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    Action               = "AdminAssign";
                    DirectoryScopeId     = "/";
                    Ensure               = "Present";
                    IsValidationOnly     = $False;
                    Principal            = "John.Smith@contoso.com";
                    RoleDefinition       = "Teams Communications Administrator";
                    ScheduleInfo         = New-CimInstance -ClassName MSFT_AADRoleEligibilityScheduleRequestSchedule -Property @{

                            expiration = New-CimInstance -ClassName MSFT_AADRoleEligibilityScheduleRequestScheduleExpiration -Property @{

                                type        = 'afterDateTime'
                            } -ClientOnly
                        } -ClientOnly
                    Credential  = $Credential
                }

                Mock -CommandName Get-MgBetaRoleManagementDirectoryRoleEligibilityScheduleRequest -MockWith {
                    return @{
                        Action               = "AdminAssign";
                        Id                   = '12345-12345-12345-12345-12345'
                        DirectoryScopeId     = "/";
                        IsValidationOnly     = $False;
                        PrincipalId          = "123456";
                        RoleDefinitionId     = "12345";
                        ScheduleInfo         = @{
                            startDateTime             = [System.DateTime]::Parse('2023-09-01T02:40:44Z')
                            expiration                = @{
                                    endDateTime = [System.DateTime]::Parse('2025-10-31T02:40:09Z')
                                    type        = 'afterDateTime'
                                }
                        };
                    }
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
                Should -Invoke -CommandName Get-MgBetaRoleManagementDirectoryRoleEligibilityScheduleRequest -Exactly 1
            }
        }
        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaRoleManagementDirectoryRoleEligibilityScheduleRequest -MockWith {
                    return @{
                        Action               = "AdminAssign";
                        Id                   = '12345-12345-12345-12345-12345'
                        DirectoryScopeId     = "/";
                        IsValidationOnly     = $False;
                        PrincipalId          = "123456";
                        RoleDefinitionId     = "12345";
                        ScheduleInfo         = @{
                            startDateTime             = [System.DateTime]::Parse('2023-09-01T02:40:44Z')
                            expiration                = @{
                                    endDateTime = [System.DateTime]::Parse('2025-10-31T02:40:09Z')
                                    type        = 'afterDateTime'
                                }
                        };
                        TargetScheduleId = "12345-12345-12345-12345-12345"
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
