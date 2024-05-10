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
    -DscResource 'AADEntitlementManagementAccessPackageCatalogResource' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName New-MgBetaEntitlementManagementAccessPackageResourceRequest -MockWith {
            }

            Mock -CommandName Get-MgBetaEntitlementManagementAccessPackageCatalog -MockWith {
                return @{
                    id          = 'f34c2d92-9e9d-4703-ba9b-955b6ac8dcb3'
                    displayName = 'MyCatalog'
                }
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
        Context -Name 'The AADEntitlementManagementAccessPackageCatalogResource should exist but it DOES NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    AddedBy             = 'myAdmin'
                    AddedOn             = '25/10/2022 18:47:28'
                    CatalogId           = 'f34c2d92-9e9d-4703-ba9b-955b6ac8dcb3'
                    Description         = 'https://001q1.sharepoint.com/'
                    DisplayName         = 'Communication site'
                    Id                  = '6a636d76-5025-44d4-9a80-78618f00c16d'
                    IsPendingOnboarding = $False
                    ManagedIdentity     = $False
                    OriginId            = 'https://001q1.sharepoint.com/'
                    OriginSystem        = 'SharePointOnline'
                    ResourceType        = 'SharePoint Online Site'
                    Url                 = 'https://001q1.sharepoint.com/'
                    Ensure              = 'Present'
                    Credential          = $Credential
                }

                Mock -CommandName Get-MgBetaEntitlementManagementAccessPackageCatalogAccessPackageResource -MockWith {
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
                Should -Invoke -CommandName New-MgBetaEntitlementManagementAccessPackageResourceRequest -Exactly 1
            }
        }

        Context -Name 'The AADEntitlementManagementAccessPackageCatalogResource exists but it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    AddedBy             = 'myAdmin'
                    AddedOn             = '25/10/2022 18:47:28'
                    CatalogId           = 'f34c2d92-9e9d-4703-ba9b-955b6ac8dcb3'
                    Description         = 'https://001q1.sharepoint.com/'
                    DisplayName         = 'Communication site'
                    Id                  = '6a636d76-5025-44d4-9a80-78618f00c16d'
                    IsPendingOnboarding = $False
                    ManagedIdentity     = $False
                    OriginId            = 'https://001q1.sharepoint.com/'
                    OriginSystem        = 'SharePointOnline'
                    ResourceType        = 'SharePoint Online Site'
                    Url                 = 'https://001q1.sharepoint.com/'
                    Ensure              = 'Absent'
                    Credential          = $Credential
                }

                Mock -CommandName Get-MgBetaEntitlementManagementAccessPackageCatalogAccessPackageResource -MockWith {
                    return @{
                        AddedBy             = 'myAdmin'
                        AddedOn             = '25/10/2022 18:47:28'
                        CatalogId           = 'f34c2d92-9e9d-4703-ba9b-955b6ac8dcb3'
                        Description         = 'https://001q1.sharepoint.com/'
                        DisplayName         = 'Communication site'
                        Id                  = '6a636d76-5025-44d4-9a80-78618f00c16d'
                        IsPendingOnboarding = $False
                        ManagedIdentity     = $False
                        OriginId            = 'https://001q1.sharepoint.com/'
                        OriginSystem        = 'SharePointOnline'
                        ResourceType        = 'SharePoint Online Site'
                        Url                 = 'https://001q1.sharepoint.com/'
                    }

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
                Should -Invoke -CommandName New-MgBetaEntitlementManagementAccessPackageResourceRequest -Exactly 1
            }
        }

        Context -Name 'The AADEntitlementManagementAccessPackageCatalogResource Exists and Values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    AddedBy             = 'myAdmin'
                    AddedOn             = '25/10/2022 18:47:28'
                    CatalogId           = 'f34c2d92-9e9d-4703-ba9b-955b6ac8dcb3'
                    Description         = 'https://001q1.sharepoint.com/'
                    DisplayName         = 'Communication site'
                    Ensure              = 'Present'
                    Id                  = '6a636d76-5025-44d4-9a80-78618f00c16d'
                    IsPendingOnboarding = $False
                    ManagedIdentity     = $False
                    OriginId            = 'https://001q1.sharepoint.com/'
                    OriginSystem        = 'SharePointOnline'
                    ResourceType        = 'SharePoint Online Site'
                    Url                 = 'https://001q1.sharepoint.com/'
                    Credential          = $Credential
                }

                Mock -CommandName Get-MgBetaEntitlementManagementAccessPackageCatalogAccessPackageResource -MockWith {
                    return @{
                        AddedBy             = 'myAdmin'
                        AddedOn             = '25/10/2022 18:47:28'
                        CatalogId           = 'f34c2d92-9e9d-4703-ba9b-955b6ac8dcb3'
                        Description         = 'https://001q1.sharepoint.com/'
                        DisplayName         = 'Communication site'
                        Id                  = '6a636d76-5025-44d4-9a80-78618f00c16d'
                        IsPendingOnboarding = $False
                        ManagedIdentity     = $False
                        OriginId            = 'https://001q1.sharepoint.com/'
                        OriginSystem        = 'SharePointOnline'
                        ResourceType        = 'SharePoint Online Site'
                        Url                 = 'https://001q1.sharepoint.com/'
                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'The AADEntitlementManagementAccessPackageCatalogResource exists and values are NOT in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    AddedBy             = 'myAdmin'
                    AddedOn             = '25/10/2022 18:47:28'
                    CatalogId           = 'f34c2d92-9e9d-4703-ba9b-955b6ac8dcb3'
                    Description         = 'https://001q1.sharepoint.com/'
                    DisplayName         = 'Communication site'
                    Ensure              = 'Present'
                    Id                  = '6a636d76-5025-44d4-9a80-78618f00c16d'
                    IsPendingOnboarding = $False
                    ManagedIdentity     = $False
                    OriginId            = 'https://001q1.sharepoint.com/'
                    OriginSystem        = 'SharePointOnline'
                    ResourceType        = 'SharePoint Online Site'
                    Url                 = 'https://001q1.sharepoint.com/'
                    Credential          = $Credential
                }

                Mock -CommandName Get-MgBetaEntitlementManagementAccessPackageCatalogAccessPackageResource -MockWith {
                    return @{
                        AddedBy             = 'myAdmin'
                        AddedOn             = '25/10/2022 18:47:28'
                        CatalogId           = 'f34c2d92-9e9d-4703-ba9b-955b6ac8dcb3'
                        Description         = 'https://001q1.sharepoint.com/'
                        DisplayName         = 'Communication site - drifted' #Drift
                        Id                  = '6a636d76-5025-44d4-9a80-78618f00c16d'
                        IsPendingOnboarding = $False
                        ManagedIdentity     = $False
                        OriginId            = 'https://001q1.sharepoint.com/'
                        OriginSystem        = 'SharePointOnline'
                        ResourceType        = 'SharePoint Online Site'
                        Url                 = 'https://001q1.sharepoint.com/'
                    }
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
                Should -Invoke -CommandName New-MgBetaEntitlementManagementAccessPackageResourceRequest -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaEntitlementManagementAccessPackageCatalogAccessPackageResource -MockWith {
                    return @{
                        AddedBy             = 'myAdmin'
                        AddedOn             = '25/10/2022 18:47:28'
                        CatalogId           = 'f34c2d92-9e9d-4703-ba9b-955b6ac8dcb3'
                        Description         = 'https://001q1.sharepoint.com/'
                        DisplayName         = 'Communication site'
                        Id                  = '6a636d76-5025-44d4-9a80-78618f00c16d'
                        IsPendingOnboarding = $False
                        ManagedIdentity     = $False
                        OriginId            = 'https://001q1.sharepoint.com/'
                        OriginSystem        = 'SharePointOnline'
                        ResourceType        = 'SharePoint Online Site'
                        Url                 = 'https://001q1.sharepoint.com/'
                    }
                }
                Mock -CommandName Get-MgBetaEntitlementManagementAccessPackageCatalog -MockWith {
                    return @(
                        [PSCustomObject]@{
                            Id = 'f34c2d92-9e9d-4703-ba9b-955b6ac8dcb3'
                            displayName = 'MyCatalog'
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
