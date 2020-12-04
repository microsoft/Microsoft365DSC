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
    -DscResource "SPOHubSite" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
            $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {

            }

            Mock -CommandName Grant-PnPHubSiteRights -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }
            Mock -CommandName New-M365DSCLogEntry -MockWith {}
        }

        # Test contexts
        Context -Name "When the site doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    Url                  = "https://contoso.sharepoint.com/sites/Marketing"
                    Title                = "Marketing Hub"
                    Description          = "Hub for the Marketing division"
                    LogoUrl              = "https://contoso.sharepoint.com/sites/Marketing/SiteAssets/hublogo.png"
                    RequiresJoinApproval = $true
                    AllowedToJoin        = @("admin@contoso.onmicrosoft.com", "superuser@contoso.onmicrosoft.com")
                    SiteDesignId         = "f7eba920-9cca-4de8-b5aa-1da75a2a893c"
                    GlobalAdminAccount   = $GlobalAdminAccount
                    Ensure               = "Present"
                }

                Mock -CommandName Get-PnPTenantSite -MockWith {
                    throw
                }
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be "Absent"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should throw error in the Set method" {
                { Set-TargetResource @testParams } | Should -Throw "The specified Site Collection {$($testParams.Url)} for SPOHubSite doesn't already exist."
            }
        }

        Context -Name "When the site isn't a hub site and shouldn't" -Fixture {
            BeforeAll {
                $testParams = @{
                    Url                = "https://contoso.sharepoint.com/sites/Marketing"
                    GlobalAdminAccount = $GlobalAdminAccount
                    Ensure             = "Absent"
                }

                Mock -CommandName Get-PnPTenantSite -MockWith {
                    return @{
                        IsHubSite = $false
                        Url       = 'https://contoso.hub.com'
                    }
                }
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be "Absent"
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "When the site is a hub site and shouldn't" -Fixture {
            BeforeAll {
                $testParams = @{
                    Url                = "https://contoso.sharepoint.com/sites/Marketing"
                    GlobalAdminAccount = $GlobalAdminAccount
                    Ensure             = "Absent"
                }

                Mock -CommandName Get-PnPTenantSite -MockWith {
                    return @{
                        IsHubSite = $true
                        Url       = 'https://contoso.sharepoint.com'
                    }
                }

                Mock -CommandName Get-PnPHubSite -MockWith {
                    $returnVal = @{
                        Permissions          = @(
                            @{
                                PrincipalName = "i:0#.f|membership|admin@contoso.onmicrosoft.com"
                            },
                            @{
                                PrincipalName = "c:0o.c|federateddirectoryclaimprovider|bfc75218-faac-4202-bf33-3a8ba2e2b4a7"
                            }
                        )
                        LogoUrl              = "https://contoso.sharepoint.com/sites/Marketing/SiteAssets/hublogo.png"
                        Title                = "Marketing Hub"
                        Description          = "Hub for the Marketing division"
                        RequiresJoinApproval = $true
                        SiteDesignId         = "f7eba920-9cca-4de8-b5aa-1da75a2a893c"
                    }
                    return $returnVal
                }

                Mock -CommandName Get-AzureADGroup -MockWith {
                    return @(
                        @{
                            EmailAddress = "group@contoso.onmicrosoft.com"
                        }
                    )
                }

                Mock -CommandName Unregister-PnPHubSite -MockWith { }
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should call mocks in the Set method" {
                Set-TargetResource @testParams
                Should -Invoke Unregister-PnPHubSite -Exactly 1
            }
        }

        Context -Name "When the site should be a hub site and is correctly configured" -Fixture {
            BeforeAll {
                $testParams = @{
                    Url                  = "https://contoso.sharepoint.com/sites/Marketing"
                    Title                = "Marketing Hub"
                    Description          = "Hub for the Marketing division"
                    LogoUrl              = "https://contoso.sharepoint.com/sites/Marketing/SiteAssets/hublogo.png"
                    RequiresJoinApproval = $true
                    AllowedToJoin        = @("admin@contoso.onmicrosoft.com", "group@contoso.onmicrosoft.com")
                    SiteDesignId         = "f7eba920-9cca-4de8-b5aa-1da75a2a893c"
                    GlobalAdminAccount   = $GlobalAdminAccount
                    Ensure               = "Present"
                }

                Mock -CommandName Get-PnPTenantSite -MockWith {
                    return @{
                        IsHubSite = $true
                        Url       = 'https://contoso.sharepoint.com'
                    }
                }

                Mock -CommandName Get-PnPHubSite -MockWith {
                    $returnVal = @{
                        Permissions          = @(
                            @{
                                PrincipalName = "i:0#.f|membership|admin@contoso.onmicrosoft.com"
                            },
                            @{
                                PrincipalName = "c:0o.c|federateddirectoryclaimprovider|bfc75218-faac-4202-bf33-3a8ba2e2b4a7"
                            }
                        )
                        LogoUrl              = "https://contoso.sharepoint.com/sites/Marketing/SiteAssets/hublogo.png"
                        Title                = "Marketing Hub"
                        Description          = "Hub for the Marketing division"
                        RequiresJoinApproval = $true
                        SiteDesignId         = "f7eba920-9cca-4de8-b5aa-1da75a2a893c"
                    }
                    return $returnVal
                }

                Mock -CommandName Get-AzureADGroup -MockWith {
                    return @{
                        EmailAddress = "group@contoso.onmicrosoft.com"
                    }
                }

                Mock -CommandName Unregister-PnPHubSite -MockWith { }
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "When the site should be a hub site, but is incorrectly configured" -Fixture {
            BeforeAll {
                $testParams = @{
                    Url                  = "https://contoso.sharepoint.com/sites/Marketing"
                    Title                = "Marketing Hub"
                    Description          = "Hub for the Marketing division"
                    LogoUrl              = "https://contoso.sharepoint.com/sites/Marketing/SiteAssets/hublogo.png"
                    RequiresJoinApproval = $true
                    AllowedToJoin        = @("admin@contoso.onmicrosoft.com", "group@contoso.onmicrosoft.com")
                    SiteDesignId         = "f7eba920-9cca-4de8-b5aa-1da75a2a893c"
                    GlobalAdminAccount   = $GlobalAdminAccount
                    Ensure               = "Present"
                }

                Mock -CommandName Get-PnPTenantSite -MockWith {
                    return @{
                        IsHubSite = $true
                        Url       = 'https://contoso.sharepoint.com'
                    }
                }

                Mock -CommandName Get-PnPHubSite -MockWith {
                    $returnVal = @{
                        Permissions          = @(
                            @{
                                PrincipalName = "i:0#.f|membership|wrongadmin@contoso.onmicrosoft.com"
                            },
                            @{
                                PrincipalName = "c:0o.c|federateddirectoryclaimprovider|bfc75218-faac-4202-bf33-3a8ba2e2b4a7"
                            }
                        )
                        LogoUrl              = "https://contoso.sharepoint.com/sites/Marketing/SiteAssets/hublogo.png"
                        Title                = "Wrong Title"
                        Description          = "Wrong Description"
                        RequiresJoinApproval = $false
                        SiteDesignId         = "e8eba920-9cca-4de8-b5aa-1da75a2a893c"
                        SiteUrl              = 'https://contoso.hub.sharepoint.com'
                    }
                    return $returnVal
                }

                Mock -CommandName Get-AzureADGroup -MockWith {
                    return @{
                        EmailAddress = "wronggroup@contoso.onmicrosoft.com"
                    }
                }

                Mock -CommandName Set-PnPHubSite -MockWith { }
                Mock -CommandName Grant-PnPHubSiteRights -MockWith { }
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should call mocks in the Set method" {
                Set-TargetResource @testParams
                Should -Invoke Set-PnPHubSite -Exactly 1
                Should -Invoke Grant-PnPHubSiteRights -Exactly 4
            }
        }

        Context -Name "When the site isn't a hub site but should be" -Fixture {
            BeforeAll {
                $testParams = @{
                    Url                  = "https://contoso.sharepoint.com/sites/Marketing"
                    Title                = "Marketing Hub"
                    Description          = "Hub for the Marketing division"
                    LogoUrl              = "https://contoso.sharepoint.com/sites/Marketing/SiteAssets/hublogo.png"
                    RequiresJoinApproval = $true
                    AllowedToJoin        = @("admin@contoso.onmicrosoft.com", "group@contoso.onmicrosoft.com", "SecurityGroup")
                    SiteDesignId         = "f7eba920-9cca-4de8-b5aa-1da75a2a893c"
                    GlobalAdminAccount   = $GlobalAdminAccount
                    Ensure               = "Present"
                }

                Mock -CommandName Get-PnPTenantSite -MockWith {
                    return @{
                        IsHubSite = $false
                        Url       = 'https://contoso.sharepoint.com'
                    }
                }

                Mock -CommandName Get-AzureADGroup -MockWith {
                    return @{
                        DisplayName = "SecurityGroup"
                    }
                }

                Mock -CommandName Register-PnPHubSite -MockWith { }
                Mock -CommandName Set-PnPHubSite -MockWith { }
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be "Absent"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should call mocks in the Set method" {
                Set-TargetResource @testParams
                Should -Invoke Register-PnPHubSite -Exactly 1
                Should -Invoke Set-PnPHubSite -Exactly 1
            }
        }

        Context -Name "When specified AllowedToJoin group doesn't exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    Url                  = "https://contoso.sharepoint.com/sites/Marketing"
                    Title                = "Marketing Hub"
                    Description          = "Hub for the Marketing division"
                    LogoUrl              = "https://contoso.sharepoint.com/sites/Marketing/SiteAssets/hublogo.png"
                    RequiresJoinApproval = $true
                    AllowedToJoin        = @("admin@contoso.onmicrosoft.com", "group@contoso.onmicrosoft.com", "SecurityGroup")
                    SiteDesignId         = "f7eba920-9cca-4de8-b5aa-1da75a2a893c"
                    GlobalAdminAccount   = $GlobalAdminAccount
                    Ensure               = "Present"
                }

                Mock -CommandName Get-PnPTenantSite -MockWith {
                    return @{
                        IsHubSite = $false
                        Url       = 'https://contoso.sharepoint.com'
                    }
                }

                Mock -CommandName Register-PnPHubSite -MockWith { }
                Mock -CommandName Set-PnPHubSite -MockWith { }
            }

            It "Should throw exception the Set method" {
                { Set-TargetResource @testParams } | Should -Throw "*Error for principal*"
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName Get-PnPTenantSite -MockWith {
                    return @{
                        IsHubSite = $true
                        Url       = 'https://contoso.sharepoint.com'
                    }
                }

                Mock -CommandName Get-PnPHubSite -MockWith {
                    $returnVal = @{
                        Permissions          = @(
                            @{
                                PrincipalName = "i:0#.f|membership|wrongadmin@contoso.onmicrosoft.com"
                            },
                            @{
                                PrincipalName = "c:0o.c|federateddirectoryclaimprovider|bfc75218-faac-4202-bf33-3a8ba2e2b4a7"
                            }
                        )
                        LogoUrl              = "https://contoso.sharepoint.com/sites/Marketing/SiteAssets/hublogo.png"
                        Title                = "Wrong Title"
                        Description          = "Wrong Description"
                        RequiresJoinApproval = $false
                        SiteDesignId         = "e8eba920-9cca-4de8-b5aa-1da75a2a893c"
                        SiteUrl              = 'https://contoso.hub.sharepoint.com'
                    }
                    return $returnVal
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
