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
    -DscResource "TeamsTeam" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString "Pass@word1)" -AsPlainText -Force
            $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin@contoso.com", $secpasswd)

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }
        }

        # Test contexts
        Context -Name "When the Team doesnt exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName                       = "TestTeam"
                    Ensure                            = "Present"
                    Description                       = "Test Team"
                    Visibility                        = "Private"
                    MailNickName                      = "teamposh"
                    AllowUserEditMessages             = $true
                    AllowUserDeleteMessages           = $false
                    AllowOwnerDeleteMessages          = $false
                    AllowTeamMentions                 = $false
                    AllowChannelMentions              = $false
                    AllowCreateUpdateChannels         = $false
                    AllowDeleteChannels               = $false
                    AllowAddRemoveApps                = $false
                    AllowCreateUpdateRemoveTabs       = $false
                    AllowCreateUpdateRemoveConnectors = $false
                    AllowGiphy                        = $True
                    GiphyContentRating                = "Moderate"
                    AllowStickersAndMemes             = $True
                    AllowCustomMemes                  = $True
                    AllowGuestCreateUpdateChannels    = $false
                    AllowGuestDeleteChannels          = $false
                    Owner                             = @("JohnDoe@contoso.com")
                    GlobalAdminAccount                = $GlobalAdminAccount
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName Get-Team -MockWith {
                    return $null
                }

                Mock -CommandName New-Team -MockWith {
                    return @{DisplayName = "TestTeam" }
                }
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be "Absent"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Updates the Team fun settings in the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "The Team already exists - Credential" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName        = "TestTeam"
                    Ensure             = "Present"
                    Visibility         = "Private"
                    Owner              = @("owner@contoso.com")
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -Command Get-TeamUser -MockWith {
                    return @(
                        @{
                            User = "owner@contoso.com"
                            Role = "owner"
                        }
                    )
                }

                Mock -CommandName Get-Team -MockWith {
                    return @(@{
                        DisplayName = "TestTeam"
                        GroupID     = "1234-1234-1234-1234"
                        Visibility  = "Private"
                        Archived    = $false
                    })
                }
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The Team already exists and is in the Desired State - ServicePrincipal" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName           = "TestTeam"
                    Ensure                = "Present"
                    Visibility            = "Private"
                    Owner                 = @("owner@contoso.com")
                    ApplicationId         = "12345-12345-12345"
                    TenantId              = "12345-12345-12345"
                    CertificateThumbprint = "123451234512345"
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "ServicePrincipal"
                }

                Mock -Command Get-TeamUser -MockWith {
                    return @(
                        @{
                            User = "owner@contoso.com"
                            Role = "owner"
                        }
                    )
                }

                Mock -CommandName Get-Team -MockWith {
                    return @(@{
                        DisplayName = "TestTeam"
                        GroupID     = "1234-1234-1234-1234"
                        Visibility  = "Private"
                        Archived    = $false
                    })
                }
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The Team already exists and is NOT in the Desired State - ServicePrincipal" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName           = "TestTeam"
                    Ensure                = "Present"
                    Visibility            = "Public" #Drift
                    Owner                 = @("owner@contoso.com")
                    ApplicationId         = "12345-12345-12345"
                    TenantId              = "12345-12345-12345"
                    CertificateThumbprint = "123451234512345"
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "ServicePrincipal"
                }

                Mock -Command Get-TeamUser -MockWith {
                    return @(
                        @{
                            User = "owner@contoso.com"
                            Role = "owner"
                        }
                    )
                }

                Mock -CommandName Set-Team -MockWith {
                    return @{
                        DisplayName = "Test Team"
                    }
                }

                Mock -CommandName Get-Team -MockWith {
                    return @(@{
                        DisplayName = "TestTeam"
                        GroupID     = "1234-1234-1234-1234"
                        Visibility  = "Private"
                        Archived    = $false
                    })
                }
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should update the values in the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Set-Team' -Exactly 1
            }
        }

        Context -Name "Update existing team access type" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName        = "Test Team"
                    Ensure             = "Present"
                    Description        = "Test Team"
                    Visibility         = "Private"
                    Owner              = @("owner@contoso.com")
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName Set-Team -MockWith {
                    return @{
                        DisplayName = "Test Team"
                    }
                }

                Mock -Command Get-TeamUser -MockWith {
                    return @{
                        User = "owner@contoso.com"
                        Role = "owner"
                    }
                }

                Mock -CommandName Get-Team -MockWith {
                    return @{
                        DisplayName = "Test Team"
                        GroupID     = "1234-1234-1234-1234"
                        Description = "Different Description"
                        Visibility  = "Private"
                        Archived    = $false
                    }
                }
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }

            It "Should return false from the test method" {
                (Test-TargetResource @testParams) | Should -Be "False"
            }

            It "Should set access type in set command" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "Update team visibility" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName        = "Test Team"
                    Ensure             = "Present"
                    MailNickName       = "testteam"
                    Visibility         = "Public"
                    Description        = "Update description"
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -Command Get-TeamUser -MockWith {
                    return @(
                        @{
                            User = "owner@contoso.com"
                            Role = "owner"
                        }
                    )
                }

                Mock -CommandName Get-Team -MockWith {
                    return @{
                        DisplayName  = "Test Team"
                        GroupID      = "1234-1234-1234-1234"
                        MailNickName = "testteam"
                        Visibility   = "Private"
                        Archived     = $false
                    }
                }

                Mock -CommandName Set-Team -MockWith {
                    return @{
                        DisplayName = "Test Team"
                        Visibility  = "Private"
                    }
                }
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }

            It "Should update display name and description in set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "Remove the Team" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName        = "Test Team"
                    Ensure             = "Absent"
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName Remove-Team -MockWith {
                    return $null
                }

                Mock -CommandName Get-Team -MockWith {
                    return @{
                        DisplayName  = "Test Team"
                        GroupID      = "1234-1234-1234-1234"
                        MailNickName = "testteam"
                        Visibility   = "Private"
                        Archived     = $false
                    }
                }

                Mock -Command Get-TeamUser -MockWith {
                    return @(
                        @{
                            User = "owner@contoso.com"
                            Role = "owner"
                        }
                    )
                }
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }

            It "Should update display name and description in set method" {
                Set-TargetResource @testParams
            }
        }


        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName Get-Team -MockWith {
                    return @{
                        DisplayName = "Test Team"
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
