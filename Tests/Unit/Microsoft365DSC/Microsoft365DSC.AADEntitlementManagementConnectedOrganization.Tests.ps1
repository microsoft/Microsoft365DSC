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
    -DscResource "AADEntitlementManagementConnectedOrganization" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ("tenantadmin@mydomain.com", $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgEntitlementManagementConnectedOrganization -MockWith {
            }

            Mock -CommandName New-MgEntitlementManagementConnectedOrganization -MockWith {
            }

            Mock -CommandName Remove-MgEntitlementManagementConnectedOrganization -MockWith {
            }

            Mock -CommandName New-MgEntitlementManagementConnectedOrganizationExternalSponsorByRef -MockWith {
            }

            Mock -CommandName New-MgEntitlementManagementConnectedOrganizationInternalSponsorByRef -MockWith {
            }

            Mock -CommandName Remove-MgEntitlementManagementConnectedOrganizationExternalSponsorByRef -MockWith {
            }

            Mock -CommandName Remove-MgEntitlementManagementConnectedOrganizationInternalSponsorByRef -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }
        # Test contexts
        Context -Name "The AADEntitlementManagementConnectedOrganization should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                        Description = "ConnectedOrganzition_Description"
                        DisplayName = "ConnectedOrganzition_DisplayName"
                        ExternalSponsors =@("12345678-1234-1234-1234-123456789012")
                        Id = "ConnectedOrganization_Id"
                        IdentitySources =@(
                            (New-CimInstance -ClassName MSFT_AADEntitlementManagementConnectedOrganizationIdentitySource -Property @{
                                ExternalTenantId = "IdentitySource_TenantId"
                                odataType = "#microsoft.graph.azureActiveDirectoryTenant"
                                displayName = "IdentitySource_DisplayName"
                            } -ClientOnly)
                        )
                        InternalSponsors =@("12345678-1234-1234-1234-123456789012")
                        State = "configured"

                    Ensure                        = "Present"
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-MgEntitlementManagementConnectedOrganization -MockWith {
                    return $null
                }
                Mock -CommandName Get-MgEntitlementManagementConnectedOrganizationExternalSponsor -MockWith {
                    return @()
                }
                Mock -CommandName Get-MgEntitlementManagementConnectedOrganizationInternalSponsor -MockWith {
                    return @()
                }
                Mock -CommandName Get-MgDirectoryObject -MockWith {
                    return @{
                        Id="12345678-1234-1234-1234-123456789012"
                        AdditionalProperties=@{
                            "@odata.type" = "#microsoft.graph.user"
                        }
                    }
                }
                Mock -CommandName New-MgEntitlementManagementConnectedOrganization -MockWith {
                    return @{
                        Id="12345678-1234-1234-1234-123456789012"
                    }
                }
            }
            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should Create the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgEntitlementManagementConnectedOrganization -Exactly 1
                Should -Invoke -CommandName New-MgEntitlementManagementConnectedOrganizationExternalSponsorByRef -Exactly 1
                Should -Invoke -CommandName New-MgEntitlementManagementConnectedOrganizationInternalSponsorByRef -Exactly 1
            }
        }

        Context -Name "The AADEntitlementManagementConnectedOrganization exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Description = "ConnectedOrganization_Description"
                    DisplayName = "ConnectedOrganization_DisplayName"
                    ExternalSponsors =@("12345678-1234-1234-1234-123456789012")
                    Id = "ConnectedOrganization_Id"
                    IdentitySources =@(
                        (New-CimInstance -ClassName MSFT_AADEntitlementManagementConnectedOrganizationIdentitySource -Property @{
                            ExternalTenantId = "IdentitySource_TenantId"
                            odataType = "#microsoft.graph.azureActiveDirectoryTenant"
                            displayName = "IdentitySource_DisplayName"
                        } -ClientOnly)
                    )
                    InternalSponsors =@("12345678-1234-1234-1234-123456789012")
                    State = "configured"
                    Ensure                        = "Absent"
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-MgEntitlementManagementConnectedOrganization -MockWith {
                    return @{
                        Description = "ConnectedOrganization_Description"
                        DisplayName = "ConnectedOrganization_DisplayName"
                        Id = "ConnectedOrganization_Id"
                        IdentitySources =@(
                            @{
                                AdditionalProperties=@{
                                    "@odata.type" = "#microsoft.graph.azureActiveDirectoryTenant"
                                    tenantId = "IdentitySource_TenantId"
                                    displayName = "IdentitySource_DisplayName"
                                }
                            }
                        )
                        State = "configured"

                    }
                }
                Mock -CommandName Get-MgEntitlementManagementConnectedOrganizationExternalSponsor -MockWith {
                    return @(
                        @{
                            Id="12345678-1234-1234-1234-123456789012"
                        }
                    )
                }
                Mock -CommandName Get-MgEntitlementManagementConnectedOrganizationInternalSponsor -MockWith {
                    return @(
                        @{
                            Id="12345678-1234-1234-1234-123456789012"
                        }
                    )
                }
            }

            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgEntitlementManagementConnectedOrganization -Exactly 1
            }
        }
        Context -Name "The AADEntitlementManagementConnectedOrganization Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Description = "ConnectedOrganization_Description"
                    DisplayName = "ConnectedOrganization_DisplayName"
                    ExternalSponsors =@("12345678-1234-1234-1234-123456789012")
                    Id = "12345678-1234-1234-1234-123456789012"
                    IdentitySources =@(
                        (New-CimInstance -ClassName MSFT_AADEntitlementManagementConnectedOrganizationIdentitySource -Property @{
                            ExternalTenantId = "IdentitySource_TenantId"
                            odataType = "#microsoft.graph.azureActiveDirectoryTenant"
                            displayName = "IdentitySource_DisplayName"
                        } -ClientOnly)
                    )
                    InternalSponsors =@("12345678-1234-1234-1234-123456789012")
                    State = "configured"
                    Ensure                        = "Present"
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-MgEntitlementManagementConnectedOrganization -MockWith {
                    return @{
                        Description = "ConnectedOrganization_Description"
                        DisplayName = "ConnectedOrganization_DisplayName"
                        Id = "12345678-1234-1234-1234-123456789012"
                        IdentitySources =@(
                            @{
                                AdditionalProperties=@{
                                    "@odata.type" = "#microsoft.graph.azureActiveDirectoryTenant"
                                    tenantId = "IdentitySource_TenantId"
                                    displayName = "IdentitySource_DisplayName"
                                }
                            }
                        )
                        State = "configured"
                    }
                }
                Mock -CommandName Get-MgEntitlementManagementConnectedOrganizationExternalSponsor -MockWith {
                    return @(
                        @{
                            Id="12345678-1234-1234-1234-123456789012"
                        }
                    )
                }
                Mock -CommandName Get-MgEntitlementManagementConnectedOrganizationInternalSponsor -MockWith {
                    return @(
                        @{
                            Id="12345678-1234-1234-1234-123456789012"
                        }
                    )
                }
            }
            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The AADEntitlementManagementConnectedOrganization exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Description = "ConnectedOrganization_Description"
                    DisplayName = "ConnectedOrganization_DisplayName"
                    ExternalSponsors =@("12345678-1234-1234-1234-123456789012")
                    Id = "12345678-1234-1234-1234-123456789012"
                    IdentitySources =@(
                        (New-CimInstance -ClassName MSFT_AADEntitlementManagementConnectedOrganizationIdentitySource -Property @{
                            ExternalTenantId = "IdentitySource_TenantId"
                            odataType = "#microsoft.graph.azureActiveDirectoryTenant"
                            displayName = "IdentitySource_DisplayName"
                        } -ClientOnly)
                    )
                    InternalSponsors =@("12345678-1234-1234-1234-123456789012")
                    State = "configured"

                    Ensure                        = "Present"
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-MgEntitlementManagementConnectedOrganization -MockWith {
                    return @{
                        Description = "ConnectedOrganization_Description"
                        DisplayName = "ConnectedOrganization_DisplayName"
                        Id = "12345678-1234-1234-1234-123456789012"
                        IdentitySources =@(
                            @{
                                AdditionalProperties=@{
                                    "@odata.type" = "#microsoft.graph.azureActiveDirectoryTenant"
                                    tenantId = "IdentitySource_TenantId"
                                    displayName = "IdentitySource_DisplayName"
                                }
                            }
                        )
                        State = "configured"
                    }
                }
                Mock -CommandName Get-MgEntitlementManagementConnectedOrganizationExternalSponsor -MockWith {
                    return @(
                        @{
                            Id="12345678-1234-1234-1234-123456789012"
                        },
                        @{
                            Id="12345678-1234-1234-1234-234567890123" #Drift
                        }
                    )
                }
                Mock -CommandName Get-MgEntitlementManagementConnectedOrganizationInternalSponsor -MockWith {
                    return @(
                        @{
                            Id="12345678-1234-1234-1234-123456789012"
                        }
                    )
                }
            }

            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgEntitlementManagementConnectedOrganization -Exactly 1
                Should -Invoke -CommandName Remove-MgEntitlementManagementConnectedOrganizationExternalSponsorByRef -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgEntitlementManagementConnectedOrganization -MockWith {
                    return @{
                        Description = "ConnectedOrganization_Description"
                        DisplayName = "ConnectedOrganization_DisplayName"
                        Id = "ConnectedOrganization_Id"
                        IdentitySources =@(
                            @{
                                AdditionalProperties=@{
                                    "@odata.type" = "#microsoft.graph.azureActiveDirectoryTenant"
                                    tenantId = "IdentitySource_TenantId"
                                    displayName = "IdentitySource_DisplayName"
                                }
                            }
                        )
                        State = "configured"

                    }
                }
                Mock -CommandName Get-MgEntitlementManagementConnectedOrganizationExternalSponsor -MockWith {
                    return @(
                        @{
                            Id="12345678-1234-1234-1234-123456789012"
                        }
                    )
                }
                Mock -CommandName Get-MgEntitlementManagementConnectedOrganizationInternalSponsor -MockWith {
                    return @(
                        @{
                            Id="12345678-1234-1234-1234-123456789012"
                        }
                    )
                }
            }
            It "Should Reverse Engineer resource from the Export method" {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
