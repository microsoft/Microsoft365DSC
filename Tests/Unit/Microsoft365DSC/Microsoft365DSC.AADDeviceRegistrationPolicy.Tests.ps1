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
    -DscResource "AADDeviceRegistrationPolicy" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Update-MgBetaDirectoryAttributeSet -MockWith {
            }

            Mock -CommandName Remove-MgBetaDirectoryAttributeSet -MockWith {
            }

            Mock -CommandName Get-MgUser -MockWith {
                return @{
                    id = '12345-12345-12345-12345-12345'
                    UserPrincipalName = "john.smith@contoso.com"
                }
            }

            Mock -CommandName Invoke-MgGraphRequest -MockWith {
                return $null
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


        Context -Name "The instance exists and values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AzureADAllowedToJoin                    = "None";
                    AzureADAllowedToJoinGroups              = @();
                    AzureADAllowedToJoinUsers               = @();
                    AzureAdJoinLocalAdminsRegisteringGroups = @();
                    AzureAdJoinLocalAdminsRegisteringMode   = "Selected";
                    AzureAdJoinLocalAdminsRegisteringUsers  = @("john.smith@contoso.com");
                    IsSingleInstance                        = "Yes";
                    LocalAdminPasswordIsEnabled             = $False;
                    LocalAdminsEnableGlobalAdmins           = $True;
                    MultiFactorAuthConfiguration            = $False;
                    UserDeviceQuota                         = 50;
                    Credential                              = $Credential;
                }

                Mock -CommandName Get-MgBetaPolicyDeviceRegistrationPolicy -MockWith {
                    return @{
                        AzureAdJoin = @{
                            IsAdminConfigurable = $true
                            AllowedToJoin = @{
                                "@odata.type" = "#microsoft.graph.allDeviceRegistrationMembership"
                            }
                            LocalAdmins = @{
                                EnableGlobalAdmins = $true
                                RegisteringUsers = @{
                                    AdditionalProperties = @{
                                        "@odata.type" = "#microsoft.graph.enumeratedDeviceRegistrationMembership"
                                        users = @('12345-12345-12345-12345-12345')
                                        groups = @()
                                    }
                                }
                            }
                        }
                        AzureADRegistration = @{
                            IsAdminConfigurable = $false
                            AllowedToRegister = @{
                                "@odata.type" = "#microsoft.graph.allDeviceRegistrationMembership"
                            }
                        }
                        Description = "Tenant-wide policy that manages initial provisioning controls using quota restrictions, additional authentication and authorization checks"
                        DisplayName = "Device Registration Policy"
                        Id = "deviceRegistrationPolicy"
                        LocalAdminPassword = @{
                            IsEnabled = $false
                        }
                        MultiFactorAuthConfiguration = "notRequired"
                        UserDeviceQuota = 50
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The instance exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AzureADAllowedToJoin                    = "Selected";
                    AzureADAllowedToJoinGroups              = @();
                    AzureADAllowedToJoinUsers               = @("john.smith@contoso.com");
                    AzureAdJoinLocalAdminsRegisteringGroups = @();
                    AzureAdJoinLocalAdminsRegisteringMode   = "Selected";
                    AzureAdJoinLocalAdminsRegisteringUsers  = @("john.smith@contoso.com");
                    IsSingleInstance                        = "Yes";
                    LocalAdminPasswordIsEnabled             = $False;
                    LocalAdminsEnableGlobalAdmins           = $False; # drift
                    MultiFactorAuthConfiguration            = $False;
                    UserDeviceQuota                         = 50;
                    Credential                              = $Credential;
                }

                Mock -CommandName Get-MgBetaPolicyDeviceRegistrationPolicy -MockWith {
                    return @{
                        AzureAdJoin = @{
                            IsAdminConfigurable = $true
                            AllowedToJoin = @{
                                "@odata.type" = "#microsoft.graph.allDeviceRegistrationMembership"
                            }
                            LocalAdmins = @{
                                EnableGlobalAdmins = $true
                                RegisteringUsers = @{
                                    users = @()
                                    groups = @()
                                    "@odata.type" = "#microsoft.graph.enumeratedDeviceRegistrationMembership"
                                }
                            }
                        }
                        AzureADRegistration = @{
                            IsAdminConfigurable = $false
                            AllowedToRegister = @{
                                "@odata.type" = "#microsoft.graph.allDeviceRegistrationMembership"
                            }
                        }
                        Description = "Tenant-wide policy that manages initial provisioning controls using quota restrictions, additional authentication and authorization checks"
                        DisplayName = "Device Registration Policy"
                        Id = "deviceRegistrationPolicy"
                        LocalAdminPassword = @{
                            IsEnabled = $false
                        }
                        MultiFactorAuthConfiguration = "notRequired"
                        UserDeviceQuota = 50
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Invoke-MgGraphRequest -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential  = $Credential;
                }

                Mock -CommandName Get-MgBetaPolicyDeviceRegistrationPolicy -MockWith {
                    return @{
                        AzureAdJoin = @{
                            IsAdminConfigurable = $true
                            AllowedToJoin = @{
                                "@odata.type" = "#microsoft.graph.allDeviceRegistrationMembership"
                            }
                            LocalAdmins = @{
                                EnableGlobalAdmins = $true
                                RegisteringUsers = @{
                                    users = @()
                                    groups = @()
                                    "@odata.type" = "#microsoft.graph.enumeratedDeviceRegistrationMembership"
                                }
                            }
                        }
                        AzureADRegistration = @{
                            IsAdminConfigurable = $false
                            AllowedToRegister = @{
                                "@odata.type" = "#microsoft.graph.allDeviceRegistrationMembership"
                            }
                        }
                        Description = "Tenant-wide policy that manages initial provisioning controls using quota restrictions, additional authentication and authorization checks"
                        DisplayName = "Device Registration Policy"
                        Id = "deviceRegistrationPolicy"
                        LocalAdminPassword = @{
                            IsEnabled = $false
                        }
                        MultiFactorAuthConfiguration = "notRequired"
                        UserDeviceQuota = 50
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
