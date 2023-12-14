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
    -DscResource 'AADConditionalAccessPolicy' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'Pass@word1)' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName New-MgBetaIdentityConditionalAccessPolicy -MockWith {
            }

            Mock -CommandName Update-MgBetaIdentityConditionalAccessPolicy -MockWith {
            }

            Mock -CommandName Remove-MgBetaIdentityConditionalAccessPolicy -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name "When Conditional Access Policy doesn't exist but should" -Fixture {
            BeforeAll {
                $testParams = @{
                    AuthenticationStrength               = "Phishing-resistant MFA"
                    BuiltInControls                      = @('Mfa', 'CompliantDevice', 'DomainJoinedDevice', 'ApprovedApplication', 'CompliantApplication')
                    ClientAppTypes                       = @('Browser', 'MobileAppsAndDesktopClients')
                    CloudAppSecurityIsEnabled            = $True
                    CloudAppSecurityType                 = 'MonitorOnly'
                    DisplayName                          = 'Allin'
                    Ensure                               = 'Present'
                    ExcludeApplications                  = @('00000012-0000-0000-c000-000000000000', 'Office365')
                    ExcludeGroups                        = @('Group 01')
                    ExcludeLocations                     = 'Contoso LAN'
                    ExcludePlatforms                     = @('Windows', 'WindowsPhone', 'MacOS')
                    ExcludeRoles                         = @('Compliance Administrator')
                    ExcludeUsers                         = 'alexw@contoso.com'
                    ExcludeExternalTenantsMembers        = @()
                    ExcludeExternalTenantsMembershipKind = 'all'
                    ExcludeGuestOrExternalUserTypes      = @('internalGuest', 'b2bCollaborationMember')
                    Credential                           = $Credscredential
                    GrantControlOperator                 = 'AND'
                    Id                                   = 'bcc0cf19-ee89-46f0-8e12-4b89123ee6f9'
                    IncludeApplications                  = @('All')
                    IncludeGroups                        = @('Group 01')
                    IncludeLocations                     = 'AllTrusted'
                    IncludePlatforms                     = @('Android', 'IOS')
                    IncludeRoles                         = @('Compliance Administrator')
                    IncludeUserActions                   = @('urn:user:registersecurityinfo')
                    IncludeUsers                         = 'All'
                    IncludeExternalTenantsMembers        = @('11111111-1111-1111-1111-111111111111')
                    IncludeExternalTenantsMembershipKind = 'enumerated'
                    IncludeGuestOrExternalUserTypes      = @('b2bCollaborationGuest')
                    PersistentBrowserIsEnabled           = $True
                    PersistentBrowserMode                = 'Always'
                    SignInFrequencyIsEnabled             = $True
                    SignInFrequencyType                  = 'Days'
                    SignInFrequencyValue                 = 5
                    SignInRiskLevels                     = @('High')
                    State                                = 'disabled'
                    UserRiskLevels                       = @('High')
                    DeviceFilterMode                     = 'exclude'
                    DeviceFilterRule                     = 'device.isCompliant -eq True -or device.trustType -eq "ServerAD"'
                }

                Mock -CommandName Get-MgBetaIdentityConditionalAccessPolicy -MockWith {
                    return $null
                }
                Mock -CommandName Get-MgUser -MockWith {
                    return @{
                        Id                = '76d3c3f6-8269-462b-9385-37435cb33f1e'
                        UserPrincipalName = 'alexw@contoso.com'
                    }
                }
                Mock -CommandName Get-MGGroup -MockWith {
                    return @{
                        Id          = 'f1eb1a09-c0c2-4df4-9e69-fee01f00db31'
                        DisplayName = 'Group 01'
                    }
                }
                Mock -CommandName Get-MgBetaDirectoryRoleTemplate -MockWith {
                    return @{
                        Id          = '17315797-102d-40b4-93e0-432062caca18'
                        DisplayName = 'Compliance Administrator'
                    }
                }
                Mock -CommandName Get-MgBetaIdentityConditionalAccessNamedLocation -MockWith {
                    return @{
                        Id          = '9e4ca5f3-0ba9-4257-b906-74d3038ac970'
                        DisplayName = 'Contoso LAN'
                    }
                }

                Mock -CommandName Get-MgBetaPolicyAuthenticationStrengthPolicy -MockWith {
                    return @{
                        Id          = "00000000-0000-0000-0000-000000000004"
                        DisplayName = "Phishing-resistant MFA"
                    }
                }
            }

            It 'Should return absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create the policy in the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgBetaIdentityConditionalAccessPolicy -Exactly 1
            }
        }

        Context -Name 'Policy exists but is not in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    ApplicationEnforcedRestrictionsIsEnabled = $True
                    AuthenticationStrength                   = "Phishing-resistant MFA"
                    BuiltInControls                          = @('Mfa', 'CompliantDevice', 'DomainJoinedDevice', 'ApprovedApplication', 'CompliantApplication')
                    ClientAppTypes                           = @('Browser', 'MobileAppsAndDesktopClients')
                    CloudAppSecurityIsEnabled                = $True
                    CloudAppSecurityType                     = 'MonitorOnly'
                    DisplayName                              = 'Allin'
                    Ensure                                   = 'Present'
                    ExcludeApplications                      = @('00000012-0000-0000-c000-000000000000', 'Office365')
                    ExcludeGroups                            = @('Group 01')
                    ExcludeLocations                         = 'Contoso LAN'
                    ExcludePlatforms                         = @('Windows', 'WindowsPhone', 'MacOS')
                    ExcludeRoles                             = @('Compliance Administrator')
                    ExcludeUsers                             = 'alexw@contoso.com'
                    ExcludeExternalTenantsMembers            = @()
                    ExcludeExternalTenantsMembershipKind     = 'all'
                    ExcludeGuestOrExternalUserTypes          = @('internalGuest', 'b2bCollaborationMember')
                    Credential                               = $Credscredential
                    GrantControlOperator                     = 'AND'
                    Id                                       = 'bcc0cf19-ee89-46f0-8e12-4b89123ee6f9'
                    IncludeApplications                      = @('All')
                    IncludeGroups                            = @('Group 01')
                    IncludeLocations                         = 'AllTrusted'
                    IncludePlatforms                         = @('Android', 'IOS')
                    IncludeRoles                             = @('Compliance Administrator')
                    IncludeUserActions                       = @('urn:user:registersecurityinfo')
                    IncludeUsers                             = 'All'
                    IncludeExternalTenantsMembers            = @('11111111-1111-1111-1111-111111111111')
                    IncludeExternalTenantsMembershipKind     = 'enumerated'
                    IncludeGuestOrExternalUserTypes          = @('b2bCollaborationGuest')
                    PersistentBrowserIsEnabled               = $True
                    PersistentBrowserMode                    = 'Always'
                    SignInFrequencyIsEnabled                 = $True
                    SignInFrequencyType                      = 'Days'
                    SignInFrequencyValue                     = 5
                    SignInRiskLevels                         = @('High')
                    State                                    = 'disabled'
                    UserRiskLevels                           = @('High')
                    DeviceFilterMode                         = 'exclude'
                    DeviceFilterRule                         = 'device.isCompliant -eq True -or device.trustType -eq "ServerAD"'
                }

                Mock -CommandName Get-MgBetaPolicyAuthenticationStrengthPolicy -MockWith {
                    return @{
                        Id          = "00000000-0000-0000-0000-000000000004"
                        DisplayName = "Phishing-resistant MFA"
                    }
                }

                Mock -CommandName Get-MgBetaIdentityConditionalAccessPolicy -MockWith {
                    return @{
                        Id              = 'bcc0cf19-ee89-46f0-8e12-4b89123ee6f9'
                        DisplayName     = 'Allin'
                        State           = 'enabled'
                        Conditions      = @{
                            Applications     = @{
                                IncludeApplications = @('All')
                                ExcludeApplications = @('00000012-0000-0000-c000-000000000000', 'Office365')
                                IncludeUserActions  = @('urn:user:registersecurityinfo')
                            }
                            Users            = @{
                                IncludeUsers  = 'All'
                                ExcludeUsers  = '76d3c3f6-8269-462b-9385-37435cb33f1e'
                                IncludeGroups = @('f1eb1a09-c0c2-4df4-9e69-fee01f00db31')
                                ExcludeGroups = @('f1eb1a09-c0c2-4df4-9e69-fee01f00db31')
                                IncludeRoles  = @('17315797-102d-40b4-93e0-432062caca18')
                                ExcludeRoles  = @('17315797-102d-40b4-93e0-432062caca18')
                            }
                            Platforms        = @{
                                IncludePlatforms = @('Android', 'IOS')
                                ExcludePlatforms = @('Windows', 'WindowsPhone', 'MacOS')
                            }
                            Locations        = @{
                                IncludeLocations = 'AllTrusted'
                                ExcludeLocations = '9e4ca5f3-0ba9-4257-b906-74d3038ac970'
                            }
                            Devices          = @{
                                IncludeDevices = @('All')
                                ExcludeDevices = @('Compliant', 'DomainJoined')
                            }
                            ClientAppTypes   = @('Browser', 'MobileAppsAndDesktopClients')
                            SignInRiskLevels = @('High')
                            UserRiskLevels   = @('High')
                        }
                        GrantControls   = @{
                            _Operator       = 'AND'
                            BuiltInControls = @('Mfa', 'CompliantDevice', 'DomainJoinedDevice', 'ApprovedApplication', 'CompliantApplication')
                            AuthenticationStrength = @{
                                Id = "00000000-0000-0000-0000-000000000004"
                            }
                        }
                        SessionControls = @{
                            ApplicationEnforcedRestrictions = @{
                                IsEnabled = $True
                            }
                            CloudAppSecurity                = @{
                                IsEnabled            = $True
                                CloudAppSecurityType = 'MonitorOnly'
                            }
                            SignInFrequency                 = @{
                                IsEnabled = $True
                                Type      = 'Days'
                                Value     = 5
                            }
                            PersistentBrowser               = @{
                                IsEnabled = $True
                                Mode      = 'Always'
                            }
                        }
                    }
                }
                Mock -CommandName Get-MgUser -MockWith {
                    return @{
                        Id                = '76d3c3f6-8269-462b-9385-37435cb33f1e'
                        UserPrincipalName = 'alexw@contoso.com'
                    }
                }
                Mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        Id          = 'f1eb1a09-c0c2-4df4-9e69-fee01f00db31'
                        DisplayName = 'Group 01'
                    }
                }
                Mock -CommandName Get-MgBetaDirectoryRoleTemplate -MockWith {
                    return @{
                        Id          = '17315797-102d-40b4-93e0-432062caca18'
                        DisplayName = 'Compliance Administrator'
                    }
                }
                Mock -CommandName Get-MgBetaIdentityConditionalAccessNamedLocation -MockWith {
                    return @{
                        Id          = '9e4ca5f3-0ba9-4257-b906-74d3038ac970'
                        DisplayName = 'Contoso LAN'
                    }
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update the settings from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgBetaIdentityConditionalAccessPolicy -Exactly 1
            }
        }

        Context -Name 'Policy exists and is already in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    ApplicationEnforcedRestrictionsIsEnabled = $True
                    AuthenticationStrength                   = "Phishing-resistant MFA"
                    BuiltInControls                          = @('Mfa', 'CompliantDevice', 'DomainJoinedDevice', 'ApprovedApplication', 'CompliantApplication')
                    ClientAppTypes                           = @('Browser', 'MobileAppsAndDesktopClients')
                    CloudAppSecurityIsEnabled                = $True
                    CloudAppSecurityType                     = 'MonitorOnly'
                    DisplayName                              = 'Allin'
                    Ensure                                   = 'Present'
                    ExcludeApplications                      = @('00000012-0000-0000-c000-000000000000', 'Office365')
                    ExcludeGroups                            = @('Group 01')
                    ExcludeLocations                         = 'Contoso LAN'
                    ExcludePlatforms                         = @('Windows', 'WindowsPhone', 'MacOS')
                    ExcludeRoles                             = @('Compliance Administrator')
                    ExcludeUsers                             = 'alexw@contoso.com'
                    ExcludeExternalTenantsMembers            = @()
                    ExcludeExternalTenantsMembershipKind     = 'all'
                    ExcludeGuestOrExternalUserTypes          = @('internalGuest', 'b2bCollaborationMember')
                    Credential                               = $Credscredential
                    GrantControlOperator                     = 'AND'
                    Id                                       = 'bcc0cf19-ee89-46f0-8e12-4b89123ee6f9'
                    IncludeApplications                      = @('All')
                    IncludeGroups                            = @('Group 01')
                    IncludeLocations                         = 'AllTrusted'
                    IncludePlatforms                         = @('Android', 'IOS')
                    IncludeRoles                             = @('Compliance Administrator')
                    IncludeUserActions                       = @('urn:user:registersecurityinfo')
                    IncludeUsers                             = 'All'
                    IncludeExternalTenantsMembers            = @('11111111-1111-1111-1111-111111111111')
                    IncludeExternalTenantsMembershipKind     = 'enumerated'
                    IncludeGuestOrExternalUserTypes          = @('b2bCollaborationGuest')
                    PersistentBrowserIsEnabled               = $True
                    PersistentBrowserMode                    = 'Always'
                    SignInFrequencyIsEnabled                 = $True
                    SignInFrequencyType                      = 'Days'
                    SignInFrequencyValue                     = 5
                    SignInRiskLevels                         = @('High')
                    State                                    = 'disabled'
                    UserRiskLevels                           = @('High')
                    DeviceFilterMode                         = 'exclude'
                    DeviceFilterRule                         = 'device.isCompliant -eq True -or device.trustType -eq "ServerAD"'
                }

                Mock -CommandName Get-MgBetaPolicyAuthenticationStrengthPolicy -MockWith {
                    return @{
                        Id          = "00000000-0000-0000-0000-000000000004"
                        DisplayName = "Phishing-resistant MFA"
                    }
                }

                Mock -CommandName Get-MgBetaIdentityConditionalAccessPolicy -MockWith {
                    return @{
                        Id              = 'bcc0cf19-ee89-46f0-8e12-4b89123ee6f9'
                        DisplayName     = 'Allin'
                        State           = 'disabled'
                        Conditions      = @{
                            Applications     = @{
                                IncludeApplications = @('All')
                                ExcludeApplications = @('00000012-0000-0000-c000-000000000000', 'Office365')
                                IncludeUserActions  = @('urn:user:registersecurityinfo')
                            }
                            Users            = @{
                                IncludeUsers                 = 'All'
                                ExcludeUsers                 = '76d3c3f6-8269-462b-9385-37435cb33f1e'
                                IncludeGroups                = @('f1eb1a09-c0c2-4df4-9e69-fee01f00db31')
                                ExcludeGroups                = @('f1eb1a09-c0c2-4df4-9e69-fee01f00db31')
                                IncludeRoles                 = @('17315797-102d-40b4-93e0-432062caca18')
                                ExcludeRoles                 = @('17315797-102d-40b4-93e0-432062caca18')
                                includeGuestsOrExternalUsers = @{
                                    guestOrExternalUserTypes = 'b2bCollaborationGuest'
                                    externalTenants          = @{
                                        membershipKind       = 'enumerated'
                                        AdditionalProperties = @{
                                            members = @('11111111-1111-1111-1111-111111111111')
                                        }
                                    }
                                }
                                excludeGuestsOrExternalUsers = @{
                                    guestOrExternalUserTypes = 'internalGuest,b2bCollaborationMember'
                                    externalTenants          = @{
                                        membershipKind       = 'all'
                                        AdditionalProperties = @{

                                        }
                                    }
                                }
                            }
                            Platforms        = @{
                                IncludePlatforms = @('Android', 'IOS')
                                ExcludePlatforms = @('Windows', 'WindowsPhone', 'MacOS')
                            }
                            Locations        = @{
                                IncludeLocations = 'AllTrusted'
                                ExcludeLocations = '9e4ca5f3-0ba9-4257-b906-74d3038ac970'
                            }
                            Devices          = @{
                                IncludeDevices = @('All')
                                ExcludeDevices = @('Compliant', 'DomainJoined')
                                DeviceFilter   = @{
                                    Mode = @('exclude')
                                    Rule = @('device.isCompliant -eq True -or device.trustType -eq "ServerAD"')
                                }
                            }
                            ClientAppTypes   = @('Browser', 'MobileAppsAndDesktopClients')
                            SignInRiskLevels = @('High')
                            UserRiskLevels   = @('High')
                        }
                        GrantControls   = @{
                            Operator               = 'AND'
                            BuiltInControls        = @('Mfa', 'CompliantDevice', 'DomainJoinedDevice', 'ApprovedApplication', 'CompliantApplication')
                            AuthenticationStrength = @{
                                Id = "00000000-0000-0000-0000-000000000004"
                            }
                        }
                        SessionControls = @{
                            ApplicationEnforcedRestrictions = @{
                                IsEnabled = $True
                            }
                            CloudAppSecurity                = @{
                                IsEnabled            = $True
                                CloudAppSecurityType = 'MonitorOnly'
                            }
                            SignInFrequency                 = @{
                                IsEnabled = $True
                                Type      = 'Days'
                                Value     = 5
                            }
                            PersistentBrowser               = @{
                                IsEnabled = $True
                                Mode      = 'Always'
                            }
                        }
                    }
                }
                Mock -CommandName Get-MgUser -MockWith {
                    return @{
                        Id                = '76d3c3f6-8269-462b-9385-37435cb33f1e'
                        UserPrincipalName = 'alexw@contoso.com'
                    }
                }
                Mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        Id          = 'f1eb1a09-c0c2-4df4-9e69-fee01f00db31'
                        DisplayName = 'Group 01'
                    }
                }
                Mock -CommandName Get-MgBetaDirectoryRoleTemplate -MockWith {
                    return @{
                        Id          = '17315797-102d-40b4-93e0-432062caca18'
                        DisplayName = 'Compliance Administrator'
                    }
                }
                Mock -CommandName Get-MgBetaIdentityConditionalAccessNamedLocation -MockWith {
                    return @{
                        Id          = '9e4ca5f3-0ba9-4257-b906-74d3038ac970'
                        DisplayName = 'Contoso LAN'
                    }
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'Policy exists but it should not' -Fixture {
            BeforeAll {
                $testParams = @{
                    ApplicationEnforcedRestrictionsIsEnabled = $True
                    AuthenticationStrength                   = "Phishing-resistant MFA"
                    BuiltInControls                          = @('Mfa', 'CompliantDevice', 'DomainJoinedDevice', 'ApprovedApplication', 'CompliantApplication')
                    ClientAppTypes                           = @('Browser', 'MobileAppsAndDesktopClients')
                    CloudAppSecurityIsEnabled                = $True
                    CloudAppSecurityType                     = 'MonitorOnly'
                    DisplayName                              = 'Allin'
                    Ensure                                   = 'Absent'
                    ExcludeApplications                      = @('00000012-0000-0000-c000-000000000000', 'Office365')
                    ExcludeGroups                            = @('Group 01')
                    ExcludeLocations                         = 'Contoso LAN'
                    ExcludePlatforms                         = @('Windows', 'WindowsPhone', 'MacOS')
                    ExcludeRoles                             = @('Compliance Administrator')
                    ExcludeUsers                             = 'alexw@contoso.com'
                    Credential                               = $Credscredential
                    GrantControlOperator                     = 'AND'
                    Id                                       = 'bcc0cf19-ee89-46f0-8e12-4b89123ee6f9'
                    IncludeApplications                      = @('All')
                    IncludeGroups                            = @('Group 01')
                    IncludeLocations                         = 'AllTrusted'
                    IncludePlatforms                         = @('Android', 'IOS')
                    IncludeRoles                             = @('Compliance Administrator')
                    IncludeUserActions                       = @('urn:user:registersecurityinfo')
                    IncludeUsers                             = 'All'
                    PersistentBrowserIsEnabled               = $True
                    PersistentBrowserMode                    = 'Always'
                    SignInFrequencyIsEnabled                 = $True
                    SignInFrequencyType                      = 'Days'
                    SignInFrequencyValue                     = 5
                    SignInRiskLevels                         = @('High')
                    State                                    = 'disabled'
                    UserRiskLevels                           = @('High')
                    DeviceFilterMode                         = 'exclude'
                    DeviceFilterRule                         = 'device.isCompliant -eq True -or device.trustType -eq "ServerAD"'
                }

                Mock -CommandName Get-MgBetaPolicyAuthenticationStrengthPolicy -MockWith {
                    return @{
                        Id          = "00000000-0000-0000-0000-000000000004"
                        DisplayName = "Phishing-resistant MFA"
                    }
                }

                Mock -CommandName Get-MgBetaIdentityConditionalAccessPolicy -MockWith {
                    return @{
                        Id              = 'bcc0cf19-ee89-46f0-8e12-4b89123ee6f9'
                        DisplayName     = 'Allin'
                        State           = 'disabled'
                        Conditions      = @{
                            Applications     = @{
                                IncludeApplications = @('All')
                                ExcludeApplications = @('00000012-0000-0000-c000-000000000000', 'Office365')
                                IncludeUserActions  = @('urn:user:registersecurityinfo')
                            }
                            Users            = @{
                                IncludeUsers  = 'All'
                                ExcludeUsers  = '76d3c3f6-8269-462b-9385-37435cb33f1e'
                                IncludeGroups = @('f1eb1a09-c0c2-4df4-9e69-fee01f00db31')
                                ExcludeGroups = @('f1eb1a09-c0c2-4df4-9e69-fee01f00db31')
                                IncludeRoles  = @('17315797-102d-40b4-93e0-432062caca18')
                                ExcludeRoles  = @('17315797-102d-40b4-93e0-432062caca18')
                            }
                            Platforms        = @{
                                IncludePlatforms = @('Android', 'IOS')
                                ExcludePlatforms = @('Windows', 'WindowsPhone', 'MacOS')
                            }
                            Locations        = @{
                                IncludeLocations = 'AllTrusted'
                                ExcludeLocations = '9e4ca5f3-0ba9-4257-b906-74d3038ac970'
                            }
                            Devices          = @{
                                IncludeDevices = @('All')
                                ExcludeDevices = @('Compliant', 'DomainJoined')
                            }
                            ClientAppTypes   = @('Browser', 'MobileAppsAndDesktopClients')
                            SignInRiskLevels = @('High')
                            UserRiskLevels   = @('High')
                        }
                        GrantControls   = @{
                            Operator               = 'AND'
                            BuiltInControls        = @('Mfa', 'CompliantDevice', 'DomainJoinedDevice', 'ApprovedApplication', 'CompliantApplication')
                            AuthenticationStrength = @{
                                Id = "00000000-0000-0000-0000-000000000004"
                            }
                        }
                        SessionControls = @{
                            ApplicationEnforcedRestrictions = @{
                                IsEnabled = $True
                            }
                            CloudAppSecurity                = @{
                                IsEnabled            = $True
                                CloudAppSecurityType = 'MonitorOnly'
                            }
                            SignInFrequency                 = @{
                                IsEnabled = $True
                                Type      = 'Days'
                                Value     = 5
                            }
                            PersistentBrowser               = @{
                                IsEnabled = $True
                                Mode      = 'Always'
                            }
                        }
                    }
                }
                Mock -CommandName Get-MgUser -MockWith {
                    return @{
                        Id                = '76d3c3f6-8269-462b-9385-37435cb33f1e'
                        UserPrincipalName = 'alexw@contoso.com'
                    }
                }
                Mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        Id          = 'f1eb1a09-c0c2-4df4-9e69-fee01f00db31'
                        DisplayName = 'Group 01'
                    }
                }
                Mock -CommandName Get-MgBetaDirectoryRoleTemplate -MockWith {
                    return @{
                        Id          = '17315797-102d-40b4-93e0-432062caca18'
                        DisplayName = 'Compliance Administrator'
                    }
                }
                Mock -CommandName Get-MgBetaIdentityConditionalAccessNamedLocation -MockWith {
                    return @{
                        Id          = '9e4ca5f3-0ba9-4257-b906-74d3038ac970'
                        DisplayName = 'Contoso LAN'
                    }
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgBetaIdentityConditionalAccessPolicy -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaPolicyAuthenticationStrengthPolicy -MockWith {
                    return @{
                        Id          = "00000000-0000-0000-0000-000000000004"
                        DisplayName = "Phishing-resistant MFA"
                    }
                }

                Mock -CommandName Get-MgBetaIdentityConditionalAccessPolicy -MockWith {
                    return @{
                        Id              = 'bcc0cf19-ee89-46f0-8e12-4b89123ee6f9'
                        DisplayName     = 'Allin'
                        State           = 'disabled'
                        Conditions      = @{
                            Applications     = @{
                                IncludeApplications = @('All')
                                ExcludeApplications = @('00000012-0000-0000-c000-000000000000', 'Office365')
                                IncludeUserActions  = @('urn:user:registersecurityinfo')
                            }
                            Users            = @{
                                IncludeUsers  = 'All'
                                ExcludeUsers  = '76d3c3f6-8269-462b-9385-37435cb33f1e'
                                IncludeGroups = @('f1eb1a09-c0c2-4df4-9e69-fee01f00db31')
                                ExcludeGroups = @('f1eb1a09-c0c2-4df4-9e69-fee01f00db31')
                                IncludeRoles  = @('17315797-102d-40b4-93e0-432062caca18')
                                ExcludeRoles  = @('17315797-102d-40b4-93e0-432062caca18')
                            }
                            Platforms        = @{
                                IncludePlatforms = @('Android', 'IOS')
                                ExcludePlatforms = @('Windows', 'WindowsPhone', 'MacOS')
                            }
                            Locations        = @{
                                IncludeLocations = 'AllTrusted'
                                ExcludeLocations = '9e4ca5f3-0ba9-4257-b906-74d3038ac970'
                            }
                            Devices          = @{
                                IncludeDevices = @('All')
                                ExcludeDevices = @('Compliant', 'DomainJoined')
                            }
                            ClientAppTypes   = @('Browser', 'MobileAppsAndDesktopClients')
                            SignInRiskLevels = @('High')
                            UserRiskLevels   = @('High')
                        }
                        GrantControls   = @{
                            _Operator              = 'AND'
                            BuiltInControls        = @('Mfa', 'CompliantDevice', 'DomainJoinedDevice', 'ApprovedApplication', 'CompliantApplication')
                            AuthenticationStrength = @{
                                Id = "00000000-0000-0000-0000-000000000004"
                            }
                        }
                        SessionControls = @{
                            ApplicationEnforcedRestrictions = @{
                                IsEnabled = $True
                            }
                            CloudAppSecurity                = @{
                                IsEnabled            = $True
                                CloudAppSecurityType = 'MonitorOnly'
                            }
                            SignInFrequency                 = @{
                                IsEnabled = $True
                                Type      = 'Days'
                                Value     = 5
                            }
                            PersistentBrowser               = @{
                                IsEnabled = $True
                                Mode      = 'Always'
                            }
                        }
                    }
                }
                Mock -CommandName Get-MgUser -MockWith {
                    return @{
                        Id                = '76d3c3f6-8269-462b-9385-37435cb33f1e'
                        UserPrincipalName = 'alexw@contoso.com'
                    }
                }
                Mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        Id          = 'f1eb1a09-c0c2-4df4-9e69-fee01f00db31'
                        DisplayName = 'Group 01'
                    }
                }
                Mock -CommandName Get-MgBetaDirectoryRoleTemplate -MockWith {
                    return @{
                        Id          = '17315797-102d-40b4-93e0-432062caca18'
                        DisplayName = 'Compliance Administrator'
                    }
                }
                Mock -CommandName Get-MgBetaIdentityConditionalAccessNamedLocation -MockWith {
                    return @{
                        Id          = '9e4ca5f3-0ba9-4257-b906-74d3038ac970'
                        DisplayName = 'Contoso LAN'
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
