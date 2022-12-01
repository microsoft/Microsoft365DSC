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
    -DscResource 'AADGroupsSettings' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString 'test@password1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin', $secpasswd)

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {
            }

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgDirectorySetting -MockWith {
            }

            Mock -CommandName Remove-MgDirectorySetting -MockWith {
            }

            Mock -CommandName New-MgDirectorySetting -MockWith {
            }

            Mock -CommandName 'Get-MgGroup' -MockWith {
                return @{
                    ObjectId    = '12345-12345-12345-12345-12345'
                    DisplayName = 'All Company'
                }
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name 'The Policy should exist but it DOES NOT' -Fixture {
            BeforeAll {
                $Script:calledOnceAlready = $false
                $testParams = @{
                    AllowGuestsToAccessGroups     = $True
                    AllowGuestsToBeGroupOwner     = $True
                    AllowToAddGuests              = $True
                    EnableGroupCreation           = $True
                    Ensure                        = 'Present'
                    Credential                    = $Credential
                    GroupCreationAllowedGroupName = 'All Company'
                    GuestUsageGuidelinesUrl       = 'https://contoso.com/guestusage'
                    IsSingleInstance              = 'Yes'
                    UsageGuidelinesUrl            = 'https://contoso.com/usage'
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credential'
                }
            }

            BeforeEach {
                Mock -CommandName Get-MgDirectorySetting -MockWith {
                    if (-not $Script:calledOnceAlready)
                    {
                        $Script:calledOnceAlready = $true
                        return $null
                    }
                    else
                    {
                        return @{
                            DisplayName = 'Group.Unified'
                            Values      = @{
                                PrefixSuffixNamingRequirement = '[Title]Bob[Company][GroupName][Office]Nik'
                                CustomBlockedWordsList        = @('CEO', 'Test')
                            }
                        }
                    }
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
                Should -Invoke -CommandName 'Get-MgDirectorySetting' -Exactly 1
            }

            It 'Should return true from the Test method' {
                $Script:calledOnceAlready = $false
                Test-TargetResource @testParams | Should -Be $false
            }
            BeforeEach {
                Mock -CommandName Get-MgDirectorySetting -MockWith {
                    if (-not $Script:calledOnceAlready)
                    {
                        $Script:calledOnceAlready = $true
                        return $null
                    }
                    else
                    {
                        return @{
                            DisplayName = 'Group.Unified'
                            Values      = @{
                                PrefixSuffixNamingRequirement = '[Title]Bob[Company][GroupName][Office]Nik'
                                CustomBlockedWordsList        = @('CEO', 'Test')
                            }
                        }
                    }
                }
            }
            It 'Should create and set the settings the Set method' {
                $Script:calledOnceAlready = $false
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'New-MgDirectorySetting' -Exactly 1
                Should -Invoke -CommandName 'Update-MgDirectorySetting' -Exactly 1
            }
        }

        Context -Name 'The Policy exists but it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance = 'Yes'
                    Ensure           = 'Absent'
                    Credential       = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credential'
                }

                Mock -CommandName Get-MgDirectorySetting -MockWith {
                    return @{
                        DisplayName = 'Group.Unified'
                        Values      = @(
                            @{
                                Name  = 'GroupCreationAllowedGroupId'
                                Value = ''
                            },
                            @{
                                Name  = 'EnableGroupCreation'
                                Value = $true
                            },
                            @{
                                Name  = 'AllowGuestsToBeGroupOwner'
                                Value = $false
                            },
                            @{
                                Name  = 'AllowGuestsToAccessGroups'
                                Value = $false
                            },
                            @{
                                Name  = 'GuestUsageGuidelinesUrl'
                                Value = ''
                            },
                            @{
                                Name  = 'AllowToAddGuests'
                                Value = $false
                            },
                            @{
                                Name  = 'UsageGuidelinesUrl'
                                Value = ''
                            }
                        )
                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
                Should -Invoke -CommandName 'Get-MgDirectorySetting' -Exactly 1
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Prevent Remove the Policy from the Set method' {
                { Set-TargetResource @testParams } | Should -Throw 'The AADGroupsSettings resource cannot delete existing Directory Setting entries. Please specify Present.'
            }
        }
        Context -Name 'The Policy Exists and Values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowGuestsToAccessGroups     = $True
                    AllowGuestsToBeGroupOwner     = $True
                    AllowToAddGuests              = $True
                    EnableGroupCreation           = $True
                    Ensure                        = 'Present'
                    Credential                    = $Credential
                    GroupCreationAllowedGroupName = 'All Company'
                    GuestUsageGuidelinesUrl       = 'https://contoso.com/guestusage'
                    IsSingleInstance              = 'Yes'
                    UsageGuidelinesUrl            = 'https://contoso.com/usage'
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credential'
                }

                Mock -CommandName Get-MgDirectorySetting -MockWith {
                    return @{
                        DisplayName = 'Group.Unified'
                        Values      = @(
                            @{
                                Name  = 'GroupCreationAllowedGroupId'
                                Value = '12345-12345-12345-12345-12345'
                            },
                            @{
                                Name  = 'EnableGroupCreation'
                                Value = $true
                            },
                            @{
                                Name  = 'AllowGuestsToBeGroupOwner'
                                Value = $true
                            },
                            @{
                                Name  = 'AllowGuestsToAccessGroups'
                                Value = $true
                            },
                            @{
                                Name  = 'GuestUsageGuidelinesUrl'
                                Value = 'https://contoso.com/guestusage'
                            },
                            @{
                                Name  = 'AllowToAddGuests'
                                Value = $true
                            },
                            @{
                                Name  = 'UsageGuidelinesUrl'
                                Value = 'https://contoso.com/usage'
                            }
                        )
                    }
                }

                Mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        Id          = '12345-12345-12345-12345-12345'
                        DisplayName = 'All Company'
                    }
                }
            }

            It 'Should return Values from the Get method' {
                Get-TargetResource @testParams
                Should -Invoke -CommandName 'Get-MgDirectorySetting' -Exactly 1
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'Values are NOT in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowGuestsToAccessGroups     = $True
                    AllowGuestsToBeGroupOwner     = $True
                    AllowToAddGuests              = $True
                    EnableGroupCreation           = $False #Drift
                    Ensure                        = 'Present'
                    Credential                    = $Credential
                    GroupCreationAllowedGroupName = 'All Company'
                    GuestUsageGuidelinesUrl       = 'https://contoso.com/guestusage'
                    IsSingleInstance              = 'Yes'
                    UsageGuidelinesUrl            = 'https://contoso.com/usage'
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credential'
                }

                Mock -CommandName Get-MgDirectorySetting -MockWith {
                    return @{
                        DisplayName = 'Group.Unified'
                        Values      = @{
                            PrefixSuffixNamingRequirement = '[Title]Bob[Company][GroupName][Office]Nik'
                            CustomBlockedWordsList        = @('CEO', 'Test')
                        }
                    }
                }
            }

            It 'Should return Values from the Get method' {
                Get-TargetResource @testParams
                Should -Invoke -CommandName 'Get-MgDirectorySetting' -Exactly 1
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Update-MgDirectorySetting' -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgDirectorySetting -MockWith {
                    return @{
                        DisplayName = 'Group.Unified'
                        Values      = @{
                            PrefixSuffixNamingRequirement = '[Title]Bob[Company][GroupName][Office]Nik'
                            CustomBlockedWordsList        = @('CEO', 'Test')
                        }
                    }
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credential'
                }
            }

            It 'Should Reverse Engineer resource from the Export method' {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
