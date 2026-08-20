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
    -DscResource 'AADUser' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -ModuleName M365DSCUtil -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Get-MgUser -MockWith {
            }

            Mock -CommandName Update-MgUser -MockWith {
            }

            Mock -CommandName Get-MgBetaRoleManagementDirectoryRoleAssignment -MockWith {
                return @()
            }

            Mock -CommandName Get-MgUserMemberOfAsGroup -MockWith {
            }

            Mock -CommandName New-MgGroupMemberByRef -MockWith {
            }

            Mock -CommandName Remove-MgGroupMemberDirectoryObjectByRef -MockWith {
            }

            Mock -CommandName Invoke-M365DSCGraphBatchRequest -MockWith {
                return @()
            }

            # Mock Write-M365DSCHost to hide output during the tests
            Mock -CommandName Write-M365DSCHost -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false

            # Base user returned by Get-MgUser. Contexts clone this and modify only the
            # values relevant to the scenario they exercise.
            function Get-BaseMgUser
            {
                return @{
                    Id                = '12345-12345-12345-12345-12345'
                    UserPrincipalName = 'JohnSmith@contoso.onmicrosoft.com'
                    DisplayName       = 'John Smith'
                    GivenName         = 'John'
                    Surname           = 'Smith'
                    UsageLocation     = 'US'
                    PasswordPolicies  = 'NONE'
                    Ensure            = 'Present'
                }
            }
        }

        # Test contexts
        Context -Name "When the user doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    UserPrincipalName = 'JohnSmith@contoso.onmicrosoft.com'
                    DisplayName       = 'John Smith'
                    FirstName         = 'John'
                    LastName          = 'Smith'
                    UsageLocation     = 'US'
                    LicenseAssignment = @('ENTERPRISE_PREMIUM')
                    Password          = $Credential
                    Credential        = $Credential
                }

                Mock -CommandName New-MgUser -MockWith {
                    return @{
                        UserPrincipalName = 'JohnSmith@contoso.onmicrosoft.com'
                    }
                }

                Mock -CommandName Get-MgBetaSubscribedSku -MockWith {
                    return @{
                        SkuPartNumber = 'ENTERPRISE_PREMIUM'
                        SkuID         = '12345-12345-12345-12345-12345'
                    }
                }
            }

            It 'Should return absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create the new User in the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'When the user already exists' -Fixture {
            BeforeAll {
                $testParams = @{
                    UserPrincipalName = 'JohnSmith@contoso.onmicrosoft.com'
                    DisplayName       = 'John Smith'
                    FirstName         = 'John'
                    LastName          = 'Smith'
                    UsageLocation     = 'US'
                    LicenseAssignment = @('ENTERPRISE_PREMIUM')
                    Password          = $Credential
                    Ensure            = 'Present'
                    Credential        = $Credential
                }

                Mock -CommandName Get-MgUser -MockWith {
                    return @{
                        UserPrincipalName = 'JohnSmith@contoso.onmicrosoft.com'
                        DisplayName       = 'John Smith'
                        GivenName         = 'John'
                        Surname           = 'Smith'
                        UsageLocation     = 'US'
                        PasswordPolicies  = 'NONE'
                        Ensure            = 'Present'
                    }
                }

                Mock -CommandName Invoke-M365DSCGraphBatchRequest -MockWith {
                    return @(
                        @{
                            id = "License"
                            body = @{
                                value = @{
                                    SkuPartNumber = 'ENTERPRISE_PREMIUM'
                                }
                            }
                        }

                    )
                }

                Mock -CommandName Get-MgBetaSubscribedSku -MockWith {
                    return @{
                        SkuPartNumber = 'ENTERPRISE_PREMIUM'
                        SkuID         = '12345-12345-12345-12345-12345'
                    }
                }
            }

            It 'Should return present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $True
            }
        }

        Context -Name 'When the user already exists but has a different license assigned' -Fixture {
            BeforeAll {
                $testParams = @{
                    UserPrincipalName    = 'JohnSmith@contoso.onmicrosoft.com'
                    DisplayName          = 'John Smith'
                    FirstName            = 'John'
                    LastName             = 'Smith'
                    UsageLocation        = 'US'
                    LicenseAssignment    = @()
                    Password             = $Credential
                    Ensure               = 'Present'
                    Credential           = $Credential
                }

                Mock -CommandName Get-MgUser -MockWith {
                    return @{
                        UserPrincipalName = 'JohnSmith@contoso.onmicrosoft.com'
                        DisplayName       = 'John Smith'
                        GivenName         = 'John'
                        Surname           = 'Smith'
                        UsageLocation     = 'US'
                        PasswordPolicies  = 'NONE'
                        Ensure            = 'Present'
                    }
                }

                Mock -CommandName Invoke-M365DSCGraphBatchRequest -MockWith {
                    return @(
                        @{
                            id = "License"
                            body = @{
                                value = @{
                                    SkuPartNumber = 'ENTERPRISE_PREMIUM'
                                }
                            }
                        }
                    )
                }

                Mock -CommandName Get-MgBetaSubscribedSku -MockWith {
                    return @{
                        SkuPartNumber = 'ENTERPRISE_PREMIUM'
                        SkuID         = '12345-12345-12345-12345-12345'
                    }
                }
            }

            It 'Should return present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should remove the License Assignment in the Set Method' {
                Set-TargetResource @testParams
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
        }

        Context -Name 'When the user already exists but is not a member of a specified group' -Fixture {
            BeforeAll {
                $testParams = @{
                    UserPrincipalName    = 'JohnSmith@contoso.onmicrosoft.com'
                    DisplayName          = 'John Smith'
                    FirstName            = 'John'
                    LastName             = 'Smith'
                    UsageLocation        = 'US'
                    MemberOf             = 'TestGroup'
                    Password             = $Credential
                    Ensure               = 'Present'
                    Credential           = $Credential
                }

                Mock -CommandName Get-MgUser -MockWith {
                    return @{
                        UserPrincipalName = 'JohnSmith@contoso.onmicrosoft.com'
                        DisplayName       = 'John Smith'
                        GivenName         = 'John'
                        Surname           = 'Smith'
                        UsageLocation     = 'US'
                        PasswordPolicies  = 'NONE'
                    }
                }

                Mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        DisplayName       = 'TestGroup'
                        Id                = '12345-12345-12345-12345-98765'
                        MailNickName      = 'TestGroup'
                        Description       = '<...>'
                        GroupTypes        = @()
                    }
                }

                Mock -CommandName Invoke-M365DSCGraphBatchRequest -MockWith {
                    return @(
                        @{
                            id = "MemberOf"
                            body = @{
                                value = @()
                            }
                        }
                    )
                }
            }

            It 'Should return present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should add the user to the group in the Set Method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'New-MgGroupMemberByRef' -Exactly 1
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
        }

        Context -Name 'When the user already exists and is a member of a group and the property is not specified' -Fixture {
            BeforeAll {
                $testParams = @{
                    UserPrincipalName    = 'JohnSmith@contoso.onmicrosoft.com'
                    DisplayName          = 'John Smith'
                    FirstName            = 'John'
                    LastName             = 'Smith'
                    UsageLocation        = 'US'
                    #MemberOf             = @('TestGroup')
                    Password             = $Credential
                    Ensure               = 'Present'
                    Credential           = $Credential
                }

                Mock -CommandName Get-MgUser -MockWith {
                    return @{
                        UserPrincipalName = 'JohnSmith@contoso.onmicrosoft.com'
                        DisplayName       = 'John Smith'
                        GivenName         = 'John'
                        Surname           = 'Smith'
                        UsageLocation     = 'US'
                        PasswordPolicies  = 'NONE'
                    }
                }

                Mock -CommandName Invoke-M365DSCGraphBatchRequest -MockWith {
                    return @(
                        @{
                            id = "MemberOf"
                            body = @{
                                value = @(
                                    [pscustomobject]@{
                                        DisplayName       = 'TestGroup'
                                        Id                = '12345-12345-12345-12345-12345'
                                        MailNickName      = 'TestGroup'
                                        Description       = '<...>'
                                        GroupTypes        = @()
                                    },
                                    [pscustomobject]@{
                                        DisplayName       = 'DynamicGroup'
                                        Id                = '12345-12345-12345-12345-54321'
                                        MailNickName      = 'DynGroup'
                                        Description       = '<...>'
                                        GroupTypes        = @('DynamicMembership')
                                    }
                                )
                            }
                        }

                    )
                }
            }

            It 'Should return present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should NOT remove the user from the group in the Set Method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Remove-MgGroupMemberDirectoryObjectByRef' -Exactly 0
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'When the user already exists, is a member of a different group than specified' -Fixture {
            BeforeAll {
                $testParams = @{
                    UserPrincipalName    = 'JohnSmith@contoso.onmicrosoft.com'
                    DisplayName          = 'John Smith'
                    FirstName            = 'John'
                    LastName             = 'Smith'
                    UsageLocation        = 'US'
                    MemberOf             = 'TestGroup'
                    Password             = $Credential
                    Ensure               = 'Present'
                    Credential           = $Credential
                }

                Mock -CommandName Get-MgUser -MockWith {
                    return @{
                        UserPrincipalName = 'JohnSmith@contoso.onmicrosoft.com'
                        DisplayName       = 'John Smith'
                        GivenName         = 'John'
                        Surname           = 'Smith'
                        UsageLocation     = 'US'
                        PasswordPolicies  = 'NONE'
                    }
                }

                Mock -CommandName Invoke-M365DSCGraphBatchRequest -MockWith {
                    return @(
                        @{
                            id = "MemberOf"
                            body = @{
                                value = @(
                                    [pscustomobject]@{
                                        DisplayName       = 'DifferentGroup'
                                        Id                = '12345-12345-12345-12345-12345'
                                        MailNickName      = 'DiffGroup'
                                        Description       = '<...>'
                                        GroupTypes        = @()
                                    }
                                )
                            }
                        }
                    )
                }

                Mock -CommandName Get-MgGroup -ParameterFilter { $Filter -eq "DisplayName eq 'TestGroup'" } -MockWith {
                    return @{
                        DisplayName       = 'TestGroup'
                        Id                = '12345-12345-12345-12345-98765'
                        MailNickName      = 'TestGroup'
                        Description       = '<...>'
                        GroupTypes        = @()
                    }
                }

                Mock -CommandName Get-MgGroup -ParameterFilter { $Filter -eq "DisplayName eq 'DifferentGroup'" } -MockWith {
                    return @{
                        DisplayName       = 'DifferentGroup'
                        Id                = '12345-12345-12345-12345-12345'
                        MailNickName      = 'DiffGroup'
                        Description       = '<...>'
                        GroupTypes        = @()
                    }
                }
            }

            It 'Should return present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should remove the user from existing group-membership and add the user to the group in the testParams' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Remove-MgGroupMemberDirectoryObjectByRef' -Exactly 1
                Should -Invoke -CommandName 'New-MgGroupMemberByRef' -Exactly 1
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
        }

        Context -Name 'When the user already exists but has different custom security attributes' -Fixture {
            BeforeAll {
                $testParams = @{
                    UserPrincipalName        = 'JohnSmith@contoso.onmicrosoft.com'
                    DisplayName              = 'John Smith'
                    FirstName                = 'John'
                    LastName                 = 'Smith'
                    UsageLocation            = 'US'
                    Password                 = $Credential
                    Ensure                   = 'Present'
                    Credential               = $Credential
                    CustomSecurityAttributes = @(
                        (New-CimInstance -ClassName MSFT_AADUserAttributeSet -Property @{
                            AttributeSetName = 'Engineering'
                            AttributeValues  = [Microsoft.Management.Infrastructure.CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_AADUserAttributeValue -Property @{
                                    AttributeName    = 'Project'
                                    StringArrayValue = [string[]]@('Baker', 'Cascade')
                                } -ClientOnly)
                                (New-CimInstance -ClassName MSFT_AADUserAttributeValue -Property @{
                                    AttributeName = 'Datacenter'
                                    StringValue   = 'Portland'
                                } -ClientOnly)
                            )
                        } -ClientOnly)
                    )
                }

                Mock -CommandName Get-MgUser -MockWith {
                    # Datacenter differs from the desired 'Portland' value, so the user drifts.
                    $user = Get-BaseMgUser
                    $user.customSecurityAttributes = @{
                        Engineering = @{
                            '@odata.type'           = '#Microsoft.DirectoryServices.CustomSecurityAttributeValue'
                            'Project'               = @('Baker', 'Cascade')
                            'Project@odata.type'    = '#Collection(String)'
                            'Datacenter'            = 'Seattle'
                            'Datacenter@odata.type' = '#String'
                        }
                    }
                    return $user
                }

                Mock -CommandName Get-MSCloudLoginConnectionProfile -MockWith {
                    return @{
                        ResourceUrl = 'https://graph.microsoft.com/'
                    }
                }

                Mock -CommandName Invoke-MgGraphRequest -MockWith {
                }
            }

            It 'Should return present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return the current custom security attributes from the Get method' {
                $result = Get-TargetResource @testParams
                $result.CustomSecurityAttributes.AttributeSetName | Should -Be 'Engineering'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the existing attributes and update them in the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Invoke-MgGraphRequest' -Exactly 1
                Should -Invoke -CommandName 'Update-MgUser' -Exactly 1
            }
        }

        Context -Name 'When the user already exists and has matching custom security attributes' -Fixture {
            BeforeAll {
                $testParams = @{
                    UserPrincipalName        = 'JohnSmith@contoso.onmicrosoft.com'
                    DisplayName              = 'John Smith'
                    FirstName                = 'John'
                    LastName                 = 'Smith'
                    UsageLocation            = 'US'
                    Password                 = $Credential
                    Ensure                   = 'Present'
                    Credential               = $Credential
                    CustomSecurityAttributes = @(
                        (New-CimInstance -ClassName MSFT_AADUserAttributeSet -Property @{
                            AttributeSetName = 'Engineering'
                            AttributeValues  = [Microsoft.Management.Infrastructure.CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_AADUserAttributeValue -Property @{
                                    AttributeName = 'Datacenter'
                                    StringValue   = 'Seattle'
                                } -ClientOnly)
                            )
                        } -ClientOnly)
                    )
                }

                Mock -CommandName Get-MgUser -MockWith {
                    # Matches the desired state exactly, so no drift is reported.
                    $user = Get-BaseMgUser
                    $user.customSecurityAttributes = @{
                        Engineering = @{
                            '@odata.type'           = '#Microsoft.DirectoryServices.CustomSecurityAttributeValue'
                            'Datacenter'            = 'Seattle'
                            'Datacenter@odata.type' = '#String'
                        }
                    }
                    return $user
                }
            }

            It 'Should return present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgUser -MockWith {
                    return @{
                        UserPrincipalName = 'JohnSmith@contoso.onmicrosoft.com'
                        DisplayName       = 'John Smith'
                        GivenName         = 'John'
                        Surname           = 'Smith'
                        UsageLocation     = 'US'
                        PasswordPolicies  = 'NONE'
                        Ensure            = 'Present'
                        customSecurityAttributes = @{
                            Engineering = @{
                                '@odata.type'           = '#Microsoft.DirectoryServices.CustomSecurityAttributeValue'
                                'Datacenter'            = 'Seattle'
                                'Datacenter@odata.type' = '#String'
                            }
                        }
                    }
                }

                Mock -CommandName Invoke-M365DSCGraphBatchRequest -MockWith {
                    return @(
                        @{
                            id = "License"
                            body = @{
                                value = @{
                                    SkuPartNumber = 'ENTERPRISE_PREMIUM'
                                }
                            }
                        },
                        @{
                            id = "MemberOf"
                            body = @{
                                value = @()
                            }
                        }
                    )
                }

                Mock -CommandName Get-MgBetaSubscribedSku -MockWith {
                    return @{
                        SkuPartNumber = 'ENTERPRISE_PREMIUM'
                        SkuID         = '12345-12345-12345-12345-12345'
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
