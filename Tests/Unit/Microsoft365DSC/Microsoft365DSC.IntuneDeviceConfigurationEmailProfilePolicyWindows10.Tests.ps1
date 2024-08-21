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
    -DscResource "IntuneDeviceConfigurationEmailProfilePolicyWindows10" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Update-MgBetaDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName New-MgBetaDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName Remove-MgBetaDeviceManagementDeviceConfiguration -MockWith {
            }
            Mock -CommandName Update-DeviceConfigurationPolicyAssignment -MockWith {
            }
            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false

            Mock -CommandName Get-MgBetaDeviceManagementDeviceConfigurationAssignment -MockWith {
            }

        }
        # Test contexts
        Context -Name "The IntuneDeviceConfigurationEmailProfilePolicyWindows10 should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    AccountName = "FakeStringValue"
                    CustomDomainName = "FakeStringValue"
                    Description = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    DurationOfEmailToSync = "userDefined"
                    EmailAddressSource = "userPrincipalName"
                    EmailSyncSchedule = "userDefined"
                    HostName = "FakeStringValue"
                    Id = "FakeStringValue"
                    RequireSsl = $True
                    SyncCalendar = $True
                    SyncContacts = $True
                    SyncTasks = $True
                    UserDomainNameSource = "fullDomainName"
                    UsernameAADSource = "userPrincipalName"
                    UsernameSource = "userPrincipalName"
                    Ensure = "Present"
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
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
                Should -Invoke -CommandName New-MgBetaDeviceManagementDeviceConfiguration -Exactly 1
            }
        }

        Context -Name "The IntuneDeviceConfigurationEmailProfilePolicyWindows10 exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    AccountName = "FakeStringValue"
                    CustomDomainName = "FakeStringValue"
                    Description = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    DurationOfEmailToSync = "userDefined"
                    EmailAddressSource = "userPrincipalName"
                    EmailSyncSchedule = "userDefined"
                    HostName = "FakeStringValue"
                    Id = "FakeStringValue"
                    RequireSsl = $True
                    SyncCalendar = $True
                    SyncContacts = $True
                    SyncTasks = $True
                    UserDomainNameSource = "fullDomainName"
                    UsernameAADSource = "userPrincipalName"
                    UsernameSource = "userPrincipalName"
                    Ensure = 'Absent'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            requireSsl = $True
                            '@odata.type' = "#microsoft.graph.windows10EasEmailProfileConfiguration"
                            accountName = "FakeStringValue"
                            hostName = "FakeStringValue"
                            syncContacts = $True
                            syncTasks = $True
                            emailSyncSchedule = "userDefined"
                            emailAddressSource = "userPrincipalName"
                            durationOfEmailToSync = "userDefined"
                            syncCalendar = $True
                            customDomainName = "FakeStringValue"
                            userDomainNameSource = "fullDomainName"
                            usernameAADSource = "userPrincipalName"
                            usernameSource = "userPrincipalName"
                        }
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        Id = "FakeStringValue"
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
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementDeviceConfiguration -Exactly 1
            }
        }
        Context -Name "The IntuneDeviceConfigurationEmailProfilePolicyWindows10 Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AccountName = "FakeStringValue"
                    CustomDomainName = "FakeStringValue"
                    Description = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    DurationOfEmailToSync = "userDefined"
                    EmailAddressSource = "userPrincipalName"
                    EmailSyncSchedule = "userDefined"
                    HostName = "FakeStringValue"
                    Id = "FakeStringValue"
                    RequireSsl = $True
                    SyncCalendar = $True
                    SyncContacts = $True
                    SyncTasks = $True
                    UserDomainNameSource = "fullDomainName"
                    UsernameAADSource = "userPrincipalName"
                    UsernameSource = "userPrincipalName"
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            requireSsl = $True
                            '@odata.type' = "#microsoft.graph.windows10EasEmailProfileConfiguration"
                            accountName = "FakeStringValue"
                            hostName = "FakeStringValue"
                            syncContacts = $True
                            syncTasks = $True
                            emailSyncSchedule = "userDefined"
                            emailAddressSource = "userPrincipalName"
                            durationOfEmailToSync = "userDefined"
                            syncCalendar = $True
                            customDomainName = "FakeStringValue"
                            userDomainNameSource = "fullDomainName"
                            usernameAADSource = "userPrincipalName"
                            usernameSource = "userPrincipalName"
                        }
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        Id = "FakeStringValue"
                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The IntuneDeviceConfigurationEmailProfilePolicyWindows10 exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AccountName = "FakeStringValue"
                    CustomDomainName = "FakeStringValue"
                    Description = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    DurationOfEmailToSync = "userDefined"
                    EmailAddressSource = "userPrincipalName"
                    EmailSyncSchedule = "userDefined"
                    HostName = "FakeStringValue"
                    Id = "FakeStringValue"
                    RequireSsl = $True
                    SyncCalendar = $True
                    SyncContacts = $True
                    SyncTasks = $True
                    UserDomainNameSource = "fullDomainName"
                    UsernameAADSource = "userPrincipalName"
                    UsernameSource = "userPrincipalName"
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            '@odata.type' = "#microsoft.graph.windows10EasEmailProfileConfiguration"
                            accountName = "FakeStringValue"
                            hostName = "FakeStringValue"
                            emailSyncSchedule = "userDefined"
                            emailAddressSource = "userPrincipalName"
                            durationOfEmailToSync = "userDefined"
                            customDomainName = "FakeStringValue"
                            userDomainNameSource = "fullDomainName"
                            usernameAADSource = "userPrincipalName"
                            usernameSource = "userPrincipalName"
                        }
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        Id = "FakeStringValue"
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
                Should -Invoke -CommandName Update-MgBetaDeviceManagementDeviceConfiguration -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            requireSsl = $True
                            '@odata.type' = "#microsoft.graph.windows10EasEmailProfileConfiguration"
                            accountName = "FakeStringValue"
                            hostName = "FakeStringValue"
                            syncContacts = $True
                            syncTasks = $True
                            emailSyncSchedule = "userDefined"
                            emailAddressSource = "userPrincipalName"
                            durationOfEmailToSync = "userDefined"
                            syncCalendar = $True
                            customDomainName = "FakeStringValue"
                            userDomainNameSource = "fullDomainName"
                            usernameAADSource = "userPrincipalName"
                            usernameSource = "userPrincipalName"
                        }
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        Id = "FakeStringValue"
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
