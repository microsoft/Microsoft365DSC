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
    -DscResource 'EXODistributionGroup' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'password' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)
            $Script:ExportMode = $false
            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Set-DistributionGroup -MockWith {
            }

            Mock -CommandName New-DistributionGroup -MockWith {
            }

            Mock -CommandName Remove-DistributionGroup -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false

            Mock -CommandName Get-DistributionGroupMember -MockWith {
            }
        }

        # Test contexts
        Context -Name "Distribution group should exist but it doesn't. CREATE IT." -Fixture {
            BeforeAll {
                $testParams = @{
                    Alias                              = 'demodg'
                    BccBlocked                         = $False
                    BypassNestedModerationEnabled      = $False
                    DisplayName                        = 'My Demo DG'
                    Ensure                             = 'Present'
                    HiddenGroupMembershipEnabled       = $True
                    ManagedBy                          = @('john.smith@contoso.com')
                    MemberDepartRestriction            = 'Open'
                    MemberJoinRestriction              = 'Closed'
                    ModeratedBy                        = @('admin@contoso.com')
                    ModerationEnabled                  = $False
                    Identity                           = 'DemoDG'
                    Name                               = 'DemoDG'
                    OrganizationalUnit                 = 'nampr03a010.prod.outlook.com/Microsoft Exchange Hosted Organizations/contoso.com'
                    PrimarySmtpAddress                 = 'demodg@contoso.com'
                    RequireSenderAuthenticationEnabled = $True
                    SendModerationNotifications        = 'Always'
                    Credential                         = $Credential
                }

                Mock -CommandName Get-DistributionGroup -MockWith {
                    return $null
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'New-DistributionGroup' -Exactly 1
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
        }

        Context -Name 'Distribution group exists but is not in the desired state. UPDATE IT.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Alias                              = 'demodg'
                    BccBlocked                         = $False
                    BypassNestedModerationEnabled      = $False
                    DisplayName                        = 'My Demo DG'
                    Ensure                             = 'Present'
                    HiddenGroupMembershipEnabled       = $True
                    ManagedBy                          = @('john.smith@contoso.com')
                    MemberDepartRestriction            = 'Open'
                    MemberJoinRestriction              = 'Closed'
                    ModeratedBy                        = @('john.smith@contoso.com')
                    ModerationEnabled                  = $False
                    Identity                           = 'DemoDG'
                    Name                               = 'DemoDG'
                    OrganizationalUnit                 = 'nampr03a010.prod.outlook.com/Microsoft Exchange Hosted Organizations/contoso.com'
                    PrimarySmtpAddress                 = 'demodg@contoso.com'
                    RequireSenderAuthenticationEnabled = $True
                    SendModerationNotifications        = 'Always'
                    Credential                         = $Credential
                }


                Mock -CommandName Get-MgUser -MockWith {
                    return @{
                        UserPrincipalName = 'john.smith@contoso.com'
                    }
                }

                Mock -CommandName Get-DistributionGroup -MockWith {
                    return @{
                        Alias                              = 'demodg'
                        BccBlocked                         = $False
                        BypassNestedModerationEnabled      = $False
                        DisplayName                        = 'My Demo DG'
                        HiddenGroupMembershipEnabled       = $True
                        ManagedBy                          = @('john.smith@contoso.com')
                        MemberDepartRestriction            = 'Open'
                        MemberJoinRestriction              = 'Open' # Drift
                        ModeratedBy                        = @('john.smith@contoso.com')
                        ModerationEnabled                  = $False
                        Identity                           = 'DemoDG'
                        Name                               = 'DemoDG'
                        OrganizationalUnit                 = 'nampr03a010.prod.outlook.com/Microsoft Exchange Hosted Organizations/contoso.com'
                        PrimarySmtpAddress                 = 'demodg@contoso.com'
                        RequireSenderAuthenticationEnabled = $True
                        SendModerationNotifications        = 'Always'
                        GroupType                          = @('Universal')
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Set-DistributionGroup' -Exactly 1
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }

        Context -Name 'Distribution group exists and is already in the desired state. DO NOTHING.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Alias                              = 'demodg'
                    BccBlocked                         = $False
                    BypassNestedModerationEnabled      = $False
                    DisplayName                        = 'My Demo DG'
                    Ensure                             = 'Present'
                    HiddenGroupMembershipEnabled       = $True
                    ManagedBy                          = @('john.smith@contoso.com')
                    MemberDepartRestriction            = 'Open'
                    MemberJoinRestriction              = 'Closed'
                    ModeratedBy                        = @('john.smith@contoso.com')
                    ModerationEnabled                  = $False
                    Identity                           = 'DemoDG'
                    Name                               = 'DemoDG'
                    OrganizationalUnit                 = 'nampr03a010.prod.outlook.com/Microsoft Exchange Hosted Organizations/contoso.com'
                    PrimarySmtpAddress                 = 'demodg@contoso.com'
                    RequireSenderAuthenticationEnabled = $True
                    SendModerationNotifications        = 'Always'
                    Credential                         = $Credential
                }

                Mock -CommandName Get-MgUser -MockWith {
                    return @{
                        UserPrincipalName = 'john.smith@contoso.com'
                    }
                }

                Mock -CommandName Get-DistributionGroup -MockWith {
                    return @{
                        Alias                              = 'demodg'
                        BccBlocked                         = $False
                        BypassNestedModerationEnabled      = $False
                        DisplayName                        = 'My Demo DG'
                        HiddenGroupMembershipEnabled       = $True
                        ManagedBy                          = @('john.smith@contoso.com')
                        MemberDepartRestriction            = 'Open'
                        MemberJoinRestriction              = 'Closed'
                        ModeratedBy                        = @('john.smith@contoso.com')
                        ModerationEnabled                  = $False
                        Identity                           = 'DemoDG'
                        Name                               = 'DemoDG'
                        OrganizationalUnit                 = 'nampr03a010.prod.outlook.com/Microsoft Exchange Hosted Organizations/contoso.com'
                        PrimarySmtpAddress                 = 'demodg@contoso.com'
                        RequireSenderAuthenticationEnabled = $True
                        SendModerationNotifications        = 'Always'
                        GroupType                          = @('Universal')
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }

        Context -Name 'Distribution group exists but should not. REMOVE IT.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Alias                              = 'demodg'
                    BccBlocked                         = $False
                    BypassNestedModerationEnabled      = $False
                    DisplayName                        = 'My Demo DG'
                    Ensure                             = 'Absent'
                    HiddenGroupMembershipEnabled       = $True
                    ManagedBy                          = @('john.smith@contoso.com')
                    MemberDepartRestriction            = 'Open'
                    MemberJoinRestriction              = 'Closed'
                    ModeratedBy                        = @('john.smith@contoso.com')
                    ModerationEnabled                  = $False
                    Identity                           = 'DemoDG'
                    Name                               = 'DemoDG'
                    OrganizationalUnit                 = 'nampr03a010.prod.outlook.com/Microsoft Exchange Hosted Organizations/contoso.com'
                    PrimarySmtpAddress                 = 'demodg@contoso.com'
                    RequireSenderAuthenticationEnabled = $True
                    SendModerationNotifications        = 'Always'
                    Credential                         = $Credential
                }

                Mock -CommandName Get-MgUser -MockWith {
                    return @{
                        UserPrincipalName = 'john.smith@contoso.com'
                    }
                }

                Mock -CommandName Get-DistributionGroup -MockWith {
                    return @{
                        Alias                              = 'demodg'
                        BccBlocked                         = $False
                        BypassNestedModerationEnabled      = $False
                        DisplayName                        = 'My Demo DG'
                        HiddenGroupMembershipEnabled       = $True
                        ManagedBy                          = @('john.smith@contoso.com')
                        MemberDepartRestriction            = 'Open'
                        MemberJoinRestriction              = 'Closed'
                        ModeratedBy                        = @('john.smith@contoso.com')
                        ModerationEnabled                  = $False
                        Identity                           = 'DemoDG'
                        Name                               = 'DemoDG'
                        OrganizationalUnit                 = 'nampr03a010.prod.outlook.com/Microsoft Exchange Hosted Organizations/contoso.com'
                        PrimarySmtpAddress                 = 'demodg@contoso.com'
                        RequireSenderAuthenticationEnabled = $True
                        SendModerationNotifications        = 'Always'
                        GroupType                          = @('Universal')
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Remove-DistributionGroup' -Exactly 1
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
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
                        UserPrincipalName = 'john.smith@contoso.com'
                    }
                }

                Mock -CommandName Get-DistributionGroup -MockWith {
                    return @{
                        Alias                              = 'demodg'
                        BccBlocked                         = $False
                        BypassNestedModerationEnabled      = $False
                        DisplayName                        = 'My Demo DG'
                        HiddenGroupMembershipEnabled       = $True
                        ManagedBy                          = @('john.smith@contoso.com')
                        MemberDepartRestriction            = 'Open'
                        MemberJoinRestriction              = 'Closed'
                        ModeratedBy                        = @('admin@contoso.com')
                        ModerationEnabled                  = $False
                        Identity                           = 'DemoDG'
                        Name                               = 'DemoDG'
                        OrganizationalUnit                 = 'nampr03a010.prod.outlook.com/Microsoft Exchange Hosted Organizations/contoso.com'
                        PrimarySmtpAddress                 = 'demodg@contoso.com'
                        RequireSenderAuthenticationEnabled = $True
                        SendModerationNotifications        = 'Always'
                        GroupType                          = @('Universal')
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
