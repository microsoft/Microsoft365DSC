[CmdletBinding()]
param(
    [Parameter()]
    [string]
    $CmdletModule = (Join-Path -Path $PSScriptRoot `
                                         -ChildPath "..\Stubs\Office365.psm1" `
                                         -Resolve)
)

Import-Module -Name (Join-Path -Path $PSScriptRoot `
                                -ChildPath "..\UnitTestHelper.psm1" `
                                -Resolve)

$Global:DscHelper = New-O365DscUnitTestHelper -StubModule $CmdletModule `
                                                -DscResource "ODSettings"

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "Pass@word1)" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-SPOServiceConnection -MockWith {
        }

        # Test contexts
        Context -Name "Check OneDrive Quota" -Fixture {
            $testParams = @{
                OneDriveStorageQuota = 1024
                CentralAdminUrl = "https://contoso.sharepoint.com"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Set-SPOTenant -MockWith {
                return @{OneDriveStorageQuota = $null}
            }

            Mock -CommandName Get-SPOTenant -MockWith {
                return $null
            }


            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Updates the OneDriveSettings in the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "Set OneDrive Quota" -Fixture {
            $testParams = @{
                OneDriveStorageQuota = 1024
                CentralAdminUrl = "https://contoso.sharepoint.com"
                OrphanedPersonalSitesRetentionPeriod = 60
                OneDriveForGuestsEnabled = $true
                NotifyOwnersWhenInvitationsAccepted = $true
                NotificationsInOneDriveForBusinessEnabled = $true
                ODBMembersCanShare = "On"
                ODBAccessRequests = "On"
                BlockMacSync = $true
                DisableReportProblemDialog = $true
                DomainGuids = "12345-12345-12345-12345-12345"
                ExcludedFileExtensions = @(".asmx")
                GrooveBlockOption = "HardOptIn"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-SPOTenant -MockWith {
                return @{
                    OneDriveStorageQuota = "1024"
                }
            }

            Mock -CommandName Get-SPOTenantSyncClientRestriction -MockWith {
                return @{
                    OptOutOfGrooveBlock = $false
                    OptOutOfGrooveSoftBlock = $false
                    DisableReportProblemDialog = $false
                    BlockMacSync = $true
                    AllowedDomainList = @("")
                    TenantRestrictionEnabled = $true
                    ExcludedFileExtensions = @(".asmx")
                }
            }

            It "Should return Ensure equals to Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should configure OneDrive settings in the Set method" {
                Set-TargetResource @testParams
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                OneDriveStorageQuota = 1024
                CentralAdminUrl = "https://contoso.sharepoint.com"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-SPOTenant -MockWith {
                return @{
                    OneDriveStorageQuota = "1024"
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
