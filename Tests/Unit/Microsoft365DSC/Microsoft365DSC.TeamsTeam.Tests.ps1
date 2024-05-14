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
    -DscResource 'TeamsTeam' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString ((New-Guid).ToString()) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@contoso.com', $secpasswd)

            $Global:PartialExportFileName = 'c:\TestPath'


            Mock -CommandName Save-M365DSCPartialExport -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Start-Sleep -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'When the Team doesnt exist' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName                       = 'TestTeam'
                    Ensure                            = 'Present'
                    Description                       = 'Test Team'
                    Visibility                        = 'Private'
                    MailNickName                      = 'teamposh'
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
                    GiphyContentRating                = 'Moderate'
                    AllowStickersAndMemes             = $True
                    AllowCustomMemes                  = $True
                    AllowGuestCreateUpdateChannels    = $false
                    AllowGuestDeleteChannels          = $false
                    Owner                             = @('JohnDoe@contoso.com')
                    Credential                        = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-Team -MockWith {
                    return $null
                }

                Mock -CommandName New-Team -MockWith {
                    return @{DisplayName = 'TestTeam' }
                }
            }

            It 'Should return absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Updates the Team fun settings in the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'The Team already exists - Credential' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName = 'TestTeam'
                    Ensure      = 'Present'
                    Visibility  = 'Private'
                    Owner       = @('owner@contoso.com')
                    Credential  = $Credential
                }

                Mock -Command Get-TeamUser -MockWith {
                    return @(
                        @{
                            User = 'owner@contoso.com'
                            Role = 'owner'
                        }
                    )
                }

                Mock -CommandName Get-Team -MockWith {
                    return @(@{
                            DisplayName = 'TestTeam'
                            GroupID     = '1234-1234-1234-1234'
                            Visibility  = 'Private'
                            Archived    = $false
                        })
                }
            }

            It 'Should return present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'The Team already exists and is in the Desired State - ServicePrincipal' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName           = 'TestTeam'
                    Ensure                = 'Present'
                    Visibility            = 'Private'
                    Owner                 = @('owner@contoso.com')
                    ApplicationId         = '12345-12345-12345'
                    TenantId              = '12345-12345-12345'
                    CertificateThumbprint = '123451234512345'
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'ServicePrincipal'
                }

                Mock -Command Get-TeamUser -MockWith {
                    return @(
                        @{
                            User = 'owner@contoso.com'
                            Role = 'owner'
                        }
                    )
                }

                Mock -CommandName Get-Team -MockWith {
                    return @(@{
                            DisplayName = 'TestTeam'
                            GroupID     = '1234-1234-1234-1234'
                            Visibility  = 'Private'
                            Archived    = $false
                        })
                }
            }

            It 'Should return present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'The Team already exists and is NOT in the Desired State - ServicePrincipal' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName           = 'TestTeam'
                    Ensure                = 'Present'
                    Visibility            = 'Public' #Drift
                    Owner                 = @('owner@contoso.com')
                    ApplicationId         = '12345-12345-12345'
                    TenantId              = '12345-12345-12345'
                    CertificateThumbprint = '123451234512345'
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'ServicePrincipal'
                }

                Mock -Command Get-TeamUser -MockWith {
                    return @(
                        @{
                            User = 'owner@contoso.com'
                            Role = 'owner'
                        }
                    )
                }

                Mock -CommandName Set-Team -MockWith {
                    return @{
                        DisplayName = 'Test Team'
                    }
                }

                Mock -CommandName Get-Team -MockWith {
                    return @(@{
                            DisplayName = 'TestTeam'
                            GroupID     = '1234-1234-1234-1234'
                            Visibility  = 'Private'
                            Archived    = $false
                        })
                }
            }

            It 'Should return present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update the values in the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Set-Team' -Exactly 1
            }
        }

        Context -Name 'Update existing team access type' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName = 'Test Team'
                    Ensure      = 'Present'
                    Description = 'Test Team'
                    Visibility  = 'Private'
                    Owner       = @('owner@contoso.com')
                    Credential  = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Set-Team -MockWith {
                    return @{
                        DisplayName = 'Test Team'
                    }
                }

                Mock -Command Get-TeamUser -MockWith {
                    return @{
                        User = 'owner@contoso.com'
                        Role = 'owner'
                    }
                }

                Mock -CommandName Get-Team -MockWith {
                    return @{
                        DisplayName = 'Test Team'
                        GroupID     = '1234-1234-1234-1234'
                        Description = 'Different Description'
                        Visibility  = 'Private'
                        Archived    = $false
                    }
                }
            }

            It 'Should return present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the test method' {
                (Test-TargetResource @testParams) | Should -Be 'False'
            }

            It 'Should set access type in set command' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'Update team visibility' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName  = 'Test Team'
                    Ensure       = 'Present'
                    MailNickName = 'testteam'
                    Visibility   = 'Public'
                    Description  = 'Update description'
                    Credential   = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -Command Get-TeamUser -MockWith {
                    return @(
                        @{
                            User = 'owner@contoso.com'
                            Role = 'owner'
                        }
                    )
                }

                Mock -CommandName Get-Team -MockWith {
                    return @{
                        DisplayName  = 'Test Team'
                        GroupID      = '1234-1234-1234-1234'
                        MailNickName = 'testteam'
                        Visibility   = 'Private'
                        Archived     = $false
                    }
                }

                Mock -CommandName Set-Team -MockWith {
                    return @{
                        DisplayName = 'Test Team'
                        Visibility  = 'Private'
                    }
                }
            }

            It 'Should return present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should update display name and description in set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'Remove the Team' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName = 'Test Team'
                    Ensure      = 'Absent'
                    Credential  = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Remove-Team -MockWith {
                    return $null
                }

                Mock -CommandName Get-Team -MockWith {
                    return @{
                        DisplayName  = 'Test Team'
                        GroupID      = '1234-1234-1234-1234'
                        MailNickName = 'testteam'
                        Visibility   = 'Private'
                        Archived     = $false
                    }
                }

                Mock -Command Get-TeamUser -MockWith {
                    return @(
                        @{
                            User = 'owner@contoso.com'
                            Role = 'owner'
                        }
                    )
                }
            }

            It 'Should return present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should update display name and description in set method' {
                Set-TargetResource @testParams
            }
        }


        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-Team -MockWith {
                    return @{
                        DisplayName = 'Test Team'
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
