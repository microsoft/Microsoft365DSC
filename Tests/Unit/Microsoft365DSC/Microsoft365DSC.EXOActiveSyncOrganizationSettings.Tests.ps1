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
    -DscResource 'EXOActiveSyncOrganizationSettings' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {
            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Set-ActiveSyncOrganizationSettings -MockWith {
            }

            Mock -CommandName Get-ActiveSyncOrganizationSettings -MockWith {
                return @{
                    IsSingleInstance                       = 'Yes'
                    DefaultAccessLevel                     = 'Allow'
                    TenantAdminPreference                  = 'Allow'
                    UserMailInsert                         = 'Test user mail insert'
                    AllowAccessForUnSupportedPlatform      = $true
                    EnableMobileMailboxPolicyWhenCAInplace = $false
                    AllowRMSSupportForUnenlightenedApps    = $true
                    AdminMailRecipients                    = @('admin@contoso.com')
                    OtaNotificationMailInsert              = 'Test OTA notification'
                    DeviceFiltering                        = 'AllowList'
                    Identity                               = 'Default'
                    IsIntuneManaged                        = $false
                    HasAzurePremiumSubscription            = $true
                }
            }

            # Mock Write-M365DSCHost to hide output during the tests
            Mock -CommandName Write-M365DSCHost -MockWith {
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {
                return "EXOActiveSyncOrganizationSettings 'TestResource' { IsSingleInstance = 'Yes' }"
            }

            Mock -CommandName Save-M365DSCPartialExport -MockWith {
            }

            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'Configuration needs updating' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance                       = 'Yes'
                    DefaultAccessLevel                     = 'Allow'
                    TenantAdminPreference                  = 'Allow'
                    UserMailInsert                         = 'Test user mail insert'
                    AllowAccessForUnSupportedPlatform      = $true
                    EnableMobileMailboxPolicyWhenCAInplace = $false
                    AllowRMSSupportForUnenlightenedApps    = $true
                    AdminMailRecipients                    = @('admin@contoso.com')
                    OtaNotificationMailInsert              = 'Test OTA notification'
                    DeviceFiltering                        = 'AllowList'
                    Credential                             = $Credential
                }

                Mock -CommandName Get-ActiveSyncOrganizationSettings -MockWith {
                    return @{
                        DefaultAccessLevel                     = 'Block'
                        TenantAdminPreference                  = 'Block'
                        UserMailInsert                         = 'Different user mail insert'
                        AllowAccessForUnSupportedPlatform      = $false
                        EnableMobileMailboxPolicyWhenCAInplace = $true
                        AllowRMSSupportForUnenlightenedApps    = $false
                        AdminMailRecipients                    = @('different@contoso.com')
                        OtaNotificationMailInsert              = 'Different OTA notification'
                        DeviceFiltering                        = 'BlockList'
                        Identity                               = 'Default'
                        IsIntuneManaged                        = $false
                        HasAzurePremiumSubscription            = $true
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-ActiveSyncOrganizationSettings -Exactly 1
            }
        }

        Context -Name 'Update not required.' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance                       = 'Yes'
                    DefaultAccessLevel                     = 'Allow'
                    TenantAdminPreference                  = 'Allow'
                    UserMailInsert                         = 'Test user mail insert'
                    AllowAccessForUnSupportedPlatform      = $true
                    EnableMobileMailboxPolicyWhenCAInplace = $false
                    AllowRMSSupportForUnenlightenedApps    = $true
                    AdminMailRecipients                    = @('admin@contoso.com')
                    OtaNotificationMailInsert              = 'Test OTA notification'
                    DeviceFiltering                        = 'AllowList'
                    Identity                               = 'Default'
                    Credential                             = $Credential
                }

                Mock -CommandName Get-ActiveSyncOrganizationSettings -MockWith {
                    return @{
                        DefaultAccessLevel                     = 'Allow'
                        TenantAdminPreference                  = 'Allow'
                        UserMailInsert                         = 'Test user mail insert'
                        AllowAccessForUnSupportedPlatform      = $true
                        EnableMobileMailboxPolicyWhenCAInplace = $false
                        AllowRMSSupportForUnenlightenedApps    = $true
                        AdminMailRecipients                    = @('admin@contoso.com')
                        OtaNotificationMailInsert              = 'Test OTA notification'
                        DeviceFiltering                        = 'AllowList'
                        Identity                               = 'Default'
                        IsIntuneManaged                        = $false
                        HasAzurePremiumSubscription            = $true
                    }
                }
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

                Mock -CommandName Get-ActiveSyncOrganizationSettings -MockWith {
                    return @{
                        DefaultAccessLevel                     = 'Allow'
                        TenantAdminPreference                  = 'Allow'
                        UserMailInsert                         = 'Test user mail insert'
                        AllowAccessForUnSupportedPlatform      = $true
                        EnableMobileMailboxPolicyWhenCAInplace = $false
                        AllowRMSSupportForUnenlightenedApps    = $true
                        AdminMailRecipients                    = @('admin@contoso.com')
                        OtaNotificationMailInsert              = 'Test OTA notification'
                        DeviceFiltering                        = 'AllowList'
                        Identity                               = 'Default'
                        IsIntuneManaged                        = $false
                        HasAzurePremiumSubscription            = $true
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
