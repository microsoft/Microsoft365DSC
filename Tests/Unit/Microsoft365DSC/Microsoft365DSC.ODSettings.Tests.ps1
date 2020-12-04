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
    -DscResource "ODSettings" -GenericStubModule $GenericStubPath

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

            Mock -CommandName Set-PnPTenantSyncClientRestriction -MockWith {
            }
        }

        # Test contexts
        Context -Name "Check OneDrive Quota" -Fixture {
            BeforeAll {
                $testParams = @{
                    OneDriveStorageQuota = 1024
                    IsSingleInstance     = "Yes"
                    Ensure               = "Present"
                    GlobalAdminAccount   = $GlobalAdminAccount
                }

                Mock -CommandName Set-PnPTenant -MockWith {
                    return @{OneDriveStorageQuota = $null }
                }

                Mock -CommandName Get-PnPTenant -MockWith {
                    return $null
                }
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Updates the OneDriveSettings in the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "Set OneDrive Quota" -Fixture {
            BeforeAll {
                $testParams = @{
                    OneDriveStorageQuota                      = 1024
                    IsSingleInstance                          = "Yes"
                    OrphanedPersonalSitesRetentionPeriod      = 60
                    OneDriveForGuestsEnabled                  = $true
                    NotifyOwnersWhenInvitationsAccepted       = $true
                    NotificationsInOneDriveForBusinessEnabled = $true
                    ODBMembersCanShare                        = "On"
                    ODBAccessRequests                         = "On"
                    BlockMacSync                              = $true
                    DisableReportProblemDialog                = $true
                    DomainGuids                               = @(New-Guid)
                    ExcludedFileExtensions                    = @(".asmx")
                    GrooveBlockOption                         = "HardOptIn"
                    GlobalAdminAccount                        = $GlobalAdminAccount
                }

                Mock -CommandName Get-PnPTenant -MockWith {
                    return @{
                        OneDriveStorageQuota = "1024"
                    }
                }

                Mock -CommandName Get-PnPTenantSyncClientRestriction -MockWith {
                    return @{
                        OptOutOfGrooveBlock        = $false
                        OptOutOfGrooveSoftBlock    = $false
                        DisableReportProblemDialog = $false
                        BlockMacSync               = $true
                        AllowedDomainList          = @("")
                        TenantRestrictionEnabled   = $true
                        ExcludedFileExtensions     = @(".asmx")
                    }
                }
                Mock -CommandName Set-PnPTenant -MockWith {
                    return @{OneDriveStorageQuota = $null }
                }
            }

            It "Should return Ensure equals to Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }

            It "Should configure OneDrive settings in the Set method" {
                Set-TargetResource @testParams
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName Get-PnPTenant -MockWith {
                    return @{
                        OneDriveStorageQuota = "1024"
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
