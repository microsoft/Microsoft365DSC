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
    -DscResource "TeamsChannelTab" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString "Pass@word1" -AsPlainText -Force
            $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }

            Mock -CommandName New-M365DSCTeamsChannelTab -MockWith {
            }

            Mock -CommandName Set-M365DSCTeamsChannelTab -MockWith {
            }

            Mock -CommandName Remove-MgTeamChannelTab -MockWith {
            }
        }

        # Test contexts
        Context -Name "When the Tab doesn't exist but should" -Fixture {
            BeforeAll {
                $testParams = @{
                    ApplicationId         = "12345";
                    CertificateThumbprint = "ABCDEF1234567890";
                    ChannelName           = "General";
                    ContentUrl            = "https://contoso.com";
                    DisplayName           = "TestTab"
                    Ensure                = "Present"
                    SortOrderIndex        = "10100";
                    TeamName              = "Contoso Team";
                    TeamsApp              = "com.microsoft.teamspace.tab.web";
                    TenantId              = 'contoso.onmicrosoft.com';
                    WebSiteUrl            = "https://contoso.com";
                }

                Mock -CommandName Get-Team -MockWith {
                    return @{
                        GroupId     = "12345-12345-12345-12345-12345"
                        DisplayName = "Contoso Team"
                    }
                }

                Mock -CommandName Get-MgTeamChannel -MockWith {
                    return @{
                        Id          = "67890-67890-67890-67890-67890"
                        DisplayName = "General"
                    }
                }

                Mock -CommandName Get-M365DSCTeamChannelTab -MockWith {
                    return $null
                }
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should create the tab in the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-M365DSCTeamsChannelTab -Exactly 1
            }
        }

        Context -Name "The tab exists but is not in the Desired State" -Fixture {
            BeforeAll {
                $testParams = @{
                    ApplicationId         = "12345";
                    CertificateThumbprint = "ABCDEF1234567890";
                    ChannelName           = "General";
                    ContentUrl            = "https://contoso.com";
                    DisplayName           = "TestTab"
                    Ensure                = "Present"
                    SortOrderIndex        = "10100";
                    TeamName              = "Contoso Team";
                    TeamsApp              = "com.microsoft.teamspace.tab.web";
                    TenantId              = 'contoso.onmicrosoft.com';
                    WebSiteUrl            = "https://contoso.com";
                }

                Mock -CommandName Get-Team -MockWith {
                    return @{
                        GroupId     = "12345-12345-12345-12345-12345"
                        DisplayName = "Contoso Team"
                    }
                }

                Mock -CommandName Get-MgTeamChannel -MockWith {
                    return @{
                        Id          = "67890-67890-67890-67890-67890"
                        DisplayName = "General"
                    }
                }

                Mock -CommandName Get-MgTeamChannelTab -MockWith {
                    return @{

                    }
                }

                Mock -CommandName Get-M365DSCTeamChannelTab -MockWith {
                    return @{
                        id             = "12345-12345-12345-12345-12345"
                        displayName    = "TestTab"
                        sortOrderIndex = "11100" #Drift
                        webUrl         = "https://contoso.com"
                        configuration  = @{
                            entityId   = $null
                            contentUrl = "https://contoso.com"
                            websiteUrl = "https://contoso.com"
                            removeUrl  = $null
                        }
                        teamsApp       = @{
                            id = "com.microsoft.teamspace.tab.web"
                        }
                    }
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should update the settings from the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-M365DSCTeamsChannelTab -Exactly 1
            }
        }

        Context -Name "The tab exists and is already in the Desired State" -Fixture {
            BeforeAll {
                $testParams = @{
                    ApplicationId         = "12345";
                    CertificateThumbprint = "ABCDEF1234567890";
                    ChannelName           = "General";
                    ContentUrl            = "https://contoso.com";
                    DisplayName           = "TestTab"
                    Ensure                = "Present"
                    SortOrderIndex        = "10100";
                    TeamName              = "Contoso Team";
                    TeamsApp              = "com.microsoft.teamspace.tab.web";
                    TenantId              = 'contoso.onmicrosoft.com';
                    WebSiteUrl            = "https://contoso.com";
                }

                Mock -CommandName Get-Team -MockWith {
                    return @{
                        GroupId     = "12345-12345-12345-12345-12345"
                        DisplayName = "Contoso Team"
                    }
                }

                Mock -CommandName Get-MgTeamChannel -MockWith {
                    return @{
                        Id          = "67890-67890-67890-67890-67890"
                        DisplayName = "General"
                    }
                }

                Mock -CommandName Get-M365DSCTeamChannelTab -MockWith {
                    return @{
                        id             = "12345-12345-12345-12345-12345"
                        displayName    = "TestTab"
                        sortOrderIndex = "10100"
                        webUrl         = "https://contoso.com"
                        configuration  = @{
                            entityId   = $null
                            contentUrl = "https://contoso.com"
                            websiteUrl = "https://contoso.com"
                            removeUrl  = $null
                        }
                        teamsApp       = @{
                            id = "com.microsoft.teamspace.tab.web"
                        }
                    }
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "Policy exists but it should not" -Fixture {
            BeforeAll {
                $testParams = @{
                    ApplicationId         = "12345";
                    CertificateThumbprint = "ABCDEF1234567890";
                    ChannelName           = "General";
                    ContentUrl            = "https://contoso.com";
                    DisplayName           = "TestTab"
                    Ensure                = "Absent"
                    SortOrderIndex        = "10100";
                    TeamName              = "Contoso Team";
                    TeamsApp              = "com.microsoft.teamspace.tab.web";
                    TenantId              = 'contoso.onmicrosoft.com';
                    WebSiteUrl            = "https://contoso.com";
                }

                Mock -CommandName Get-Team -MockWith {
                    return @{
                        GroupId     = "12345-12345-12345-12345-12345"
                        DisplayName = "Contoso Team"
                    }
                }

                Mock -CommandName Get-MgTeamChannel -MockWith {
                    return @{
                        Id          = "67890-67890-67890-67890-67890"
                        DisplayName = "General"
                    }
                }

                Mock -CommandName Get-M365DSCTeamChannelTab -MockWith {
                    return @{
                        id             = "12345-12345-12345-12345-12345"
                        displayName    = "TestTab"
                        sortOrderIndex = "11100" #Drift
                        webUrl         = "https://contoso.com"
                        configuration  = @{
                            entityId   = $null
                            contentUrl = "https://contoso.com"
                            websiteUrl = "https://contoso.com"
                            removeUrl  = $null
                        }
                        teamsApp       = @{
                            id = "com.microsoft.teamspace.tab.web"
                        }
                    }
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should remove the policy from the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgTeamChannelTab -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName Get-Team -MockWith {
                    return @{
                        GroupId     = "12345-12345-12345-12345-12345"
                        DisplayName = "Contoso Team"
                    }
                }

                Mock -CommandName Get-MgTeamChannel -MockWith {
                    return @{
                        Id          = "67890-67890-67890-67890-67890"
                        DisplayName = "General"
                    }
                }

                Mock -CommandName Get-MgTeamChannelTab -MockWith {
                    return @{
                        DisplayName = "General"
                    }
                }

                Mock -CommandName Get-M365DSCTeamChannelTab -MockWith {
                    return @{
                        id             = "12345-12345-12345-12345-12345"
                        displayName    = "TestTab"
                        sortOrderIndex = "11100" #Drift
                        webUrl         = "https://contoso.com"
                        configuration  = @{
                            entityId   = $null
                            contentUrl = "https://contoso.com"
                            websiteUrl = "https://contoso.com"
                            removeUrl  = $null
                        }
                        teamsApp       = @{
                            id = "com.microsoft.teamspace.tab.web"
                        }
                    }
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
