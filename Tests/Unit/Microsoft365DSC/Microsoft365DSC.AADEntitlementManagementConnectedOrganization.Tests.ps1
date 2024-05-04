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
    -DscResource 'AADEntitlementManagementConnectedOrganization' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Update-MgBetaEntitlementManagementConnectedOrganization -MockWith {
            }

            Mock -CommandName New-MgBetaEntitlementManagementConnectedOrganization -MockWith {
            }

            Mock -CommandName Remove-MgBetaEntitlementManagementConnectedOrganization -MockWith {
            }

            Mock -CommandName New-MgBetaEntitlementManagementConnectedOrganizationExternalSponsorByRef -MockWith {
            }

            Mock -CommandName New-MgBetaEntitlementManagementConnectedOrganizationInternalSponsorByRef -MockWith {
            }

            Mock -CommandName Remove-MgBetaEntitlementManagementConnectedOrganizationExternalSponsorDirectoryObjectByRef -MockWith {
            }

            Mock -CommandName Remove-MgBetaEntitlementManagementConnectedOrganizationInternalSponsorDirectoryObjectByRef -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }
            Mock -CommandName Invoke-MgGraphRequest -MockWith {
                return @{}
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false

            Mock -CommandName Get-MgUser -MockWith {
                return @{
                    Id = '12345678-1234-1234-1234-123456789012'
                    UserPrincipalName = 'John.smith@contoso.com'
                }
            }

            Mock -CommandName Get-MgBetaDirectoryObject -MockWith {
                return @{
                    Id                   = '12345678-1234-1234-1234-123456789012'
                    AdditionalProperties = @{
                        '@odata.type' = '#microsoft.graph.user'
                    }
                }
            }
        }
        # Test contexts
        Context -Name 'The AADEntitlementManagementConnectedOrganization should exist but it DOES NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    Description      = 'ConnectedOrganzition_Description'
                    DisplayName      = 'ConnectedOrganzition_DisplayName'
                    ExternalSponsors = @('12345678-1234-1234-1234-123456789012')
                    Id               = 'ConnectedOrganization_Id'
                    IdentitySources  = @(
                            (New-CimInstance -ClassName MSFT_AADEntitlementManagementConnectedOrganizationIdentitySource -Property @{
                            ExternalTenantId = 'IdentitySource_TenantId'
                            odataType        = '#microsoft.graph.azureActiveDirectoryTenant'
                            displayName      = 'IdentitySource_DisplayName'
                        } -ClientOnly)
                    )
                    InternalSponsors = @('12345678-1234-1234-1234-123456789012')
                    State            = 'configured'

                    Ensure           = 'Present'
                    Credential       = $Credential
                }

                Mock -CommandName Get-MgBetaEntitlementManagementConnectedOrganization -MockWith {
                    return $null
                }
                Mock -CommandName Get-MgBetaEntitlementManagementConnectedOrganizationExternalSponsor -MockWith {
                    return @()
                }
                Mock -CommandName Get-MgBetaEntitlementManagementConnectedOrganizationInternalSponsor -MockWith {
                    return @()
                }
                Mock -CommandName New-MgBetaEntitlementManagementConnectedOrganization -MockWith {
                    return @{
                        Id = '12345678-1234-1234-1234-123456789012'
                    }
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should Create the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgBetaEntitlementManagementConnectedOrganization -Exactly 1
                Should -Invoke -CommandName New-MgBetaEntitlementManagementConnectedOrganizationExternalSponsorByRef -Exactly 1
                Should -Invoke -CommandName New-MgBetaEntitlementManagementConnectedOrganizationInternalSponsorByRef -Exactly 1
            }
        }

        Context -Name 'The AADEntitlementManagementConnectedOrganization exists but it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    Description      = 'ConnectedOrganization_Description'
                    DisplayName      = 'ConnectedOrganization_DisplayName'
                    ExternalSponsors = @('12345678-1234-1234-1234-123456789012')
                    Id               = 'ConnectedOrganization_Id'
                    IdentitySources  = @(
                        (New-CimInstance -ClassName MSFT_AADEntitlementManagementConnectedOrganizationIdentitySource -Property @{
                            ExternalTenantId = 'IdentitySource_TenantId'
                            odataType        = '#microsoft.graph.azureActiveDirectoryTenant'
                            displayName      = 'IdentitySource_DisplayName'
                        } -ClientOnly)
                    )
                    InternalSponsors = @('12345678-1234-1234-1234-123456789012')
                    State            = 'configured'
                    Ensure           = 'Absent'
                    Credential       = $Credential
                }

                Mock -CommandName Get-MgBetaEntitlementManagementConnectedOrganization -MockWith {
                    return @{
                        Description     = 'ConnectedOrganization_Description'
                        DisplayName     = 'ConnectedOrganization_DisplayName'
                        Id              = 'ConnectedOrganization_Id'
                        IdentitySources = @(
                            @{
                                AdditionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.azureActiveDirectoryTenant'
                                    tenantId      = 'IdentitySource_TenantId'
                                    displayName   = 'IdentitySource_DisplayName'
                                }
                            }
                        )
                        State           = 'configured'

                    }
                }
                Mock -CommandName Get-MgBetaEntitlementManagementConnectedOrganizationExternalSponsor -MockWith {
                    return @(
                        @{
                            Id = '12345678-1234-1234-1234-123456789012'
                        }
                    )
                }
                Mock -CommandName Get-MgBetaEntitlementManagementConnectedOrganizationInternalSponsor -MockWith {
                    return @(
                        @{
                            Id = '12345678-1234-1234-1234-123456789012'
                        }
                    )
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgBetaEntitlementManagementConnectedOrganization -Exactly 1
            }
        }
        Context -Name 'The AADEntitlementManagementConnectedOrganization Exists and Values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    Description      = 'ConnectedOrganization_Description'
                    DisplayName      = 'ConnectedOrganization_DisplayName'
                    ExternalSponsors = @('John.Smith@contoso.com')
                    Id               = '12345678-1234-1234-1234-123456789012'
                    IdentitySources  = @(
                        (New-CimInstance -ClassName MSFT_AADEntitlementManagementConnectedOrganizationIdentitySource -Property @{
                            ExternalTenantId = 'IdentitySource_TenantId'
                            odataType        = '#microsoft.graph.azureActiveDirectoryTenant'
                            displayName      = 'IdentitySource_DisplayName'
                        } -ClientOnly)
                    )
                    InternalSponsors = @('John.Smith@contoso.com')
                    State            = 'configured'
                    Ensure           = 'Present'
                    Credential       = $Credential
                }

                Mock -CommandName Get-MgBetaEntitlementManagementConnectedOrganization -MockWith {
                    return @{
                        Description     = 'ConnectedOrganization_Description'
                        DisplayName     = 'ConnectedOrganization_DisplayName'
                        Id              = '12345678-1234-1234-1234-123456789012'
                        IdentitySources = @(
                            @{
                                AdditionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.azureActiveDirectoryTenant'
                                    tenantId      = 'IdentitySource_TenantId'
                                    displayName   = 'IdentitySource_DisplayName'
                                }
                            }
                        )
                        State           = 'configured'
                    }
                }
                Mock -CommandName Get-MgBetaEntitlementManagementConnectedOrganizationExternalSponsor -MockWith {
                    return @(
                        @{
                            Id = '12345678-1234-1234-1234-123456789012'
                        }
                    )
                }
                Mock -CommandName Get-MgBetaEntitlementManagementConnectedOrganizationInternalSponsor -MockWith {
                    return @(
                        @{
                            Id = '12345678-1234-1234-1234-123456789012'
                        }
                    )
                }
            }
            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'The AADEntitlementManagementConnectedOrganization exists and values are NOT in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    Description      = 'ConnectedOrganization_Description'
                    DisplayName      = 'ConnectedOrganization_DisplayName'
                    ExternalSponsors = @('John.Smith@contoso.com')
                    Id               = '12345678-1234-1234-1234-123456789012'
                    IdentitySources  = @(
                        (New-CimInstance -ClassName MSFT_AADEntitlementManagementConnectedOrganizationIdentitySource -Property @{
                            ExternalTenantId = 'IdentitySource_TenantId'
                            odataType        = '#microsoft.graph.azureActiveDirectoryTenant'
                            displayName      = 'IdentitySource_DisplayName'
                        } -ClientOnly)
                    )
                    InternalSponsors = @('John.Smith@contoso.com')
                    State            = 'configured'

                    Ensure           = 'Present'
                    Credential       = $Credential
                }

                Mock -CommandName Get-MgBetaEntitlementManagementConnectedOrganization -MockWith {
                    return @{
                        Description     = 'ConnectedOrganization_Description'
                        DisplayName     = 'ConnectedOrganization_DisplayName'
                        Id              = '12345678-1234-1234-1234-123456789012'
                        IdentitySources = @(
                            @{
                                AdditionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.azureActiveDirectoryTenant'
                                    tenantId      = 'IdentitySource_TenantId'
                                    displayName   = 'IdentitySource_DisplayName'
                                }
                            }
                        )
                        State           = 'configured'
                    }
                }
                Mock -CommandName Get-MgBetaEntitlementManagementConnectedOrganizationExternalSponsor -MockWith {
                    return @(
                        @{
                            Id = '12345678-1234-1234-1234-123456789012'
                        },
                        @{
                            Id = '12345678-1234-1234-1234-234567890123' #Drift
                        }
                    )
                }
                Mock -CommandName Get-MgBetaEntitlementManagementConnectedOrganizationInternalSponsor -MockWith {
                    return @(
                        @{
                            Id = '12345678-1234-1234-1234-123456789012'
                        }
                    )
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgBetaEntitlementManagementConnectedOrganization -Exactly 1
                Should -Invoke -CommandName Remove-MgBetaEntitlementManagementConnectedOrganizationExternalSponsorDirectoryObjectByRef -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaEntitlementManagementConnectedOrganization -MockWith {
                    return @{
                        Description     = 'ConnectedOrganization_Description'
                        DisplayName     = 'ConnectedOrganization_DisplayName'
                        Id              = 'ConnectedOrganization_Id'
                        IdentitySources = @(
                            @{
                                AdditionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.azureActiveDirectoryTenant'
                                    tenantId      = 'IdentitySource_TenantId'
                                    displayName   = 'IdentitySource_DisplayName'
                                }
                            }
                        )
                        State           = 'configured'

                    }
                }
                Mock -CommandName Get-MgBetaEntitlementManagementConnectedOrganizationExternalSponsor -MockWith {
                    return @(
                        @{
                            Id = '12345678-1234-1234-1234-123456789012'
                        }
                    )
                }
                Mock -CommandName Get-MgBetaEntitlementManagementConnectedOrganizationInternalSponsor -MockWith {
                    return @(
                        @{
                            Id = '12345678-1234-1234-1234-123456789012'
                        }
                    )
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
