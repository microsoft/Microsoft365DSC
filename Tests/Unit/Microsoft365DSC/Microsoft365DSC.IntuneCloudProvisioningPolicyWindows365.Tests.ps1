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
    -DscResource "IntuneCloudProvisioningPolicyWindows365" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -ModuleName M365DSCUtil -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-MSCloudLoginConnectionProfile -MockWith {
            }

            Mock -CommandName Reset-MSCloudLoginConnectionProfileContext -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgBetaDeviceManagementVirtualEndpointProvisioningPolicy -MockWith {
            }

            Mock -CommandName New-MgBetaDeviceManagementVirtualEndpointProvisioningPolicy -MockWith {
            }

            Mock -CommandName Remove-MgBetaDeviceManagementVirtualEndpointProvisioningPolicy -MockWith {
            }

            Mock -CommandName Get-MgBetaDeviceManagementVirtualEndpointProvisioningPolicy -MockWith {
                return @{
                    Assignments = @(
                        @{
                            id = "12345-12345-12345-12345-12345"
                            target = @{
                                '@odata.type' = '#microsoft.graph.cloudPcManagementGroupAssignmentTarget'
                                groupId = "42a638ec-2bf2-47a8-8f5f-176ce2124b7b"
                            }
                        }
                    )
                    AlternateResourceUrl = "FakeStringValue"
                    Autopatch = @{
                        AutopatchGroupId = "FakeStringValue"
                    }
                    AutopilotConfiguration = $null
                    CloudPcGroupDisplayName = "FakeStringValue"
                    CloudPcNamingTemplate = "FakeStringValue"
                    CreatedBy = "FakeStringValue"
                    Description = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    DomainJoinConfigurations = @(
                        @{
                            OnPremisesConnectionId = $null
                            RegionGroup = "default"
                            RegionName = "FakeStringValue"
                            DomainJoinType = "azureADJoin"
                            Type = "azureADJoin"
                        }
                    )
                    EnableSingleSignOn = $True
                    GracePeriodInHours = 25
                    Id = "FakeStringValue"
                    ImageDisplayName = "FakeStringValue"
                    ImageId = "FakeStringValue"
                    ImageType = "gallery"
                    LastModifiedBy = "FakeStringValue"
                    LocalAdminEnabled = $True
                    ManagedBy = "windows365"
                    MicrosoftManagedDesktop = @{
                        ManagedType = "notManaged"
                        Profile = ""
                        Type = "notManaged"
                    }
                    ProvisioningType = "dedicated"
                    ScopeIds = @("FakeStringValue")
                    UserExperienceType = "cloudPc"
                    WindowsSetting = @{
                        Locale = "en-US"
                    }
                    WindowsSettings = @{
                        Language = "en-US"
                    }
                }
            }

            Mock -CommandName Update-DeviceConfigurationPolicyAssignment -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            # Mock Write-M365DSCHost to hide output during the tests
            Mock -CommandName Write-M365DSCHost -MockWith {
            }
            $Script:exportedInstance = $null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name "The IntuneCloudProvisioningPolicyWindows365 should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            dataType = "#microsoft.graph.cloudPcManagementGroupAssignmentTarget"
                            groupId = "42a638ec-2bf2-47a8-8f5f-176ce2124b7b"
                        } -ClientOnly)
                    )
                    Autopatch = (New-CimInstance -ClassName MSFT_MicrosoftGraphcloudPcProvisioningPolicyAutopatch -Property @{
                        AutopatchGroupId = "FakeStringValue"
                    } -ClientOnly)
                    CloudPcNamingTemplate = "FakeStringValue"
                    Description = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    DomainJoinConfigurations = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphcloudPcDomainJoinConfiguration -Property @{
                            RegionGroup = "default"
                            RegionName = "FakeStringValue"
                            DomainJoinType = "azureADJoin"
                            Type = "azureADJoin"
                        } -ClientOnly)
                    )
                    EnableSingleSignOn = $True
                    Id = "FakeStringValue"
                    ImageDisplayName = "FakeStringValue"
                    ImageId = "FakeStringValue"
                    ImageType = "gallery"
                    LocalAdminEnabled = $True
                    ProvisioningType = "dedicated"
                    RoleScopeTagIds = @("FakeStringValue")
                    WindowsSetting = (New-CimInstance -ClassName MSFT_MicrosoftGraphcloudPcWindowsSetting -Property @{
                        Locale = "en-US"
                    } -ClientOnly)
                    WindowsSettings = (New-CimInstance -ClassName MSFT_MicrosoftGraphcloudPcWindowsSettings -Property @{
                        Language = "en-US"
                    } -ClientOnly)
                    Ensure = "Present"
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementVirtualEndpointProvisioningPolicy -MockWith {
                    return $null
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
                Should -Invoke -CommandName New-MgBetaDeviceManagementVirtualEndpointProvisioningPolicy -Exactly 1
            }
        }

        Context -Name "The IntuneCloudProvisioningPolicyWindows365 exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            dataType = "#microsoft.graph.cloudPcManagementGroupAssignmentTarget"
                            groupId = "42a638ec-2bf2-47a8-8f5f-176ce2124b7b"
                        } -ClientOnly)
                    )
                    Autopatch = (New-CimInstance -ClassName MSFT_MicrosoftGraphcloudPcProvisioningPolicyAutopatch -Property @{
                        AutopatchGroupId = "FakeStringValue"
                    } -ClientOnly)
                    CloudPcNamingTemplate = "FakeStringValue"
                    Description = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    DomainJoinConfigurations = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphcloudPcDomainJoinConfiguration -Property @{
                            RegionGroup = "default"
                            RegionName = "FakeStringValue"
                            DomainJoinType = "azureADJoin"
                            Type = "azureADJoin"
                        } -ClientOnly)
                    )
                    EnableSingleSignOn = $True
                    Id = "FakeStringValue"
                    ImageDisplayName = "FakeStringValue"
                    ImageId = "FakeStringValue"
                    ImageType = "gallery"
                    LocalAdminEnabled = $True
                    ProvisioningType = "dedicated"
                    RoleScopeTagIds = @("FakeStringValue")
                    WindowsSetting = (New-CimInstance -ClassName MSFT_MicrosoftGraphcloudPcWindowsSetting -Property @{
                        Locale = "en-US"
                    } -ClientOnly)
                    WindowsSettings = (New-CimInstance -ClassName MSFT_MicrosoftGraphcloudPcWindowsSettings -Property @{
                        Language = "en-US"
                    } -ClientOnly)
                    Ensure = "Absent"
                    Credential = $Credential;
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementVirtualEndpointProvisioningPolicy -Exactly 1
            }
        }

        Context -Name "The IntuneCloudProvisioningPolicyWindows365 Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            dataType = "#microsoft.graph.cloudPcManagementGroupAssignmentTarget"
                            groupId = "42a638ec-2bf2-47a8-8f5f-176ce2124b7b"
                        } -ClientOnly)
                    )
                    Autopatch = (New-CimInstance -ClassName MSFT_MicrosoftGraphcloudPcProvisioningPolicyAutopatch -Property @{
                        AutopatchGroupId = "FakeStringValue"
                    } -ClientOnly)
                    CloudPcNamingTemplate = "FakeStringValue"
                    Description = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    DomainJoinConfigurations = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphcloudPcDomainJoinConfiguration -Property @{
                            RegionGroup = "default"
                            RegionName = "FakeStringValue"
                            DomainJoinType = "azureADJoin"
                            Type = "azureADJoin"
                        } -ClientOnly)
                    )
                    EnableSingleSignOn = $True
                    Id = "FakeStringValue"
                    ImageDisplayName = "FakeStringValue"
                    ImageId = "FakeStringValue"
                    ImageType = "gallery"
                    LocalAdminEnabled = $True
                    ProvisioningType = "dedicated"
                    RoleScopeTagIds = @("FakeStringValue")
                    WindowsSetting = (New-CimInstance -ClassName MSFT_MicrosoftGraphcloudPcWindowsSetting -Property @{
                        Locale = "en-US"
                    } -ClientOnly)
                    WindowsSettings = (New-CimInstance -ClassName MSFT_MicrosoftGraphcloudPcWindowsSettings -Property @{
                        Language = "en-US"
                    } -ClientOnly)
                    Ensure = "Present"
                    Credential = $Credential;
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The IntuneCloudProvisioningPolicyWindows365 exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            dataType = "#microsoft.graph.cloudPcManagementGroupAssignmentTarget"
                            groupId = "42a638ec-2bf2-47a8-8f5f-176ce2124b7b"
                        } -ClientOnly)
                    )
                    Autopatch = (New-CimInstance -ClassName MSFT_MicrosoftGraphcloudPcProvisioningPolicyAutopatch -Property @{
                        AutopatchGroupId = "FakeStringValue"
                    } -ClientOnly)
                    CloudPcNamingTemplate = "FakeStringValue"
                    Description = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    DomainJoinConfigurations = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphcloudPcDomainJoinConfiguration -Property @{
                            RegionGroup = "default"
                            RegionName = "FakeStringValue"
                            DomainJoinType = "azureADJoin"
                            Type = "azureADJoin"
                        } -ClientOnly)
                    )
                    EnableSingleSignOn = $False # Drift
                    Id = "FakeStringValue"
                    ImageDisplayName = "FakeStringValue"
                    ImageId = "FakeStringValue"
                    ImageType = "gallery"
                    LocalAdminEnabled = $True
                    ProvisioningType = "dedicated"
                    RoleScopeTagIds = @("FakeStringValue")
                    WindowsSetting = (New-CimInstance -ClassName MSFT_MicrosoftGraphcloudPcWindowsSetting -Property @{
                        Locale = "en-US"
                    } -ClientOnly)
                    WindowsSettings = (New-CimInstance -ClassName MSFT_MicrosoftGraphcloudPcWindowsSettings -Property @{
                        Language = "en-US"
                    } -ClientOnly)
                    Ensure = "Present"
                    Credential = $Credential;
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
                Should -Invoke -CommandName Update-MgBetaDeviceManagementVirtualEndpointProvisioningPolicy -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
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
