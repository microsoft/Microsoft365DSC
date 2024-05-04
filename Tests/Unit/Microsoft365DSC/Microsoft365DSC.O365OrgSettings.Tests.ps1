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
    -DscResource 'O365OrgSettings' -GenericStubModule $GenericStubPath

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

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false

            Mock -CommandName Get-MgServicePrincipal -MockWith {
            }

            Mock -CommandName Set-DefaultTenantBriefingConfig -MockWith {
            }

            Mock -CommandName Set-DefaultTenantMyAnalyticsFeatureConfig -MockWith {
            }
            Mock -CommandName Invoke-MgGraphRequest -MockWith {
                return @{
                    "@odata.type"         = "#microsoft.graph.adminReportSettings"
                    displayConcealedNames = $true
                }
            }

            Mock -CommandName Get-M365DSCOrgSettingsInstallationOptions -MockWith {
                return @{
                    '@odata.context' = 'https://graph.microsoft.com/beta/$metadata#admin/microsoft365Apps/installationOptions/$entity'
                    updateChannel = 'current'
                    appsForMac = @{
                        isSkypeForBusinessEnabled = $True
                        isMicrosoft365AppsEnabled = $true
                    }
                    appsForWindows = @{
                        isVisioEnabled            = $True
                        isSkypeForBusinessEnabled = $False
                        isMicrosoft365AppsEnabled = $true
                        isProjectEnabled          = $true
                    }
                }
            }

            Mock -CommandName Get-M365DSCO365OrgSettingsPlannerConfig -MockWith {
                return @{
                    allowCalendarSharing = $false
                }
            }
        }

        # Test contexts
        Context -Name 'When Org Settings are already in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    AdminCenterReportDisplayConcealedNames     = $True;
                    IsSingleInstance                           = 'Yes'
                    M365WebEnableUsersToOpenFilesFrom3PStorage = $False;
                    InstallationOptionsAppsForMac              = @('isSkypeForBusinessEnabled', 'isMicrosoft365AppsEnabled')
                    InstallationOptionsAppsForWindows          = @('isVisioEnabled', 'isMicrosoft365AppsEnabled', 'isProjectEnabled')
                    InstallationOptionsUpdateChannel           = 'current'
                    MicrosoftVivaBriefingEmail                   = $True
                    VivaInsightsWebExperience                    = $true
                    VivaInsightsDigestEmail                      = $true
                    VivaInsightsOutlookAddInAndInlineSuggestions = $true
                    VivaInsightsScheduleSendSuggestions          = $true
                    PlannerAllowCalendarSharing                = $False
                    Credential                                 = $Credential
                }

                Mock -CommandName Get-MgServicePrincipal -MockWith {
                    return @{
                        AccountEnabled = $False
                    }
                }

                Mock -CommandName Get-DefaultTenantBriefingConfig -MockWith {
                    return @{
                        IsEnabledByDefault = 'opt-in'
                    }
                }

                Mock -CommandName Get-DefaultTenantMyAnalyticsFeatureConfig -MockWith {
                    return @{
                        IsDashboardEnabled    = $true
                        IsDigestEmailEnabled  = $true
                        IsAddInEnabled        = $true
                        IsScheduleSendEnabled = $true
                    }
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).M365WebEnableUsersToOpenFilesFrom3PStorage | Should -Be $False
            }

            It 'Should return false from the Test method' {
                (Test-TargetResource @testParams) | Should -Be $true
            }
        }

        # Test contexts
        Context -Name 'When Org Settings NOT in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance                             = 'Yes'
                    AdminCenterReportDisplayConcealedNames       = $True;
                    M365WebEnableUsersToOpenFilesFrom3PStorage   = $True
                    MicrosoftVivaBriefingEmail                   = $True
                    VivaInsightsWebExperience                    = $true
                    VivaInsightsDigestEmail                      = $true
                    VivaInsightsOutlookAddInAndInlineSuggestions = $true
                    VivaInsightsScheduleSendSuggestions          = $true
                    Ensure                                       = 'Present'
                    Credential                                   = $Credential
                }

                Mock -CommandName Get-MgServicePrincipal -MockWith {
                    return @{
                        AccountEnabled = $False
                    }
                }

                Mock -CommandName Get-DefaultTenantBriefingConfig -MockWith {
                    return @{
                        IsEnabledByDefault = 'opt-in'
                    }
                }

                Mock -CommandName Get-DefaultTenantMyAnalyticsFeatureConfig -MockWith {
                    return @{
                        IsDashboardEnabled    = $true
                        IsDigestEmailEnabled  = $true
                        IsAddInEnabled        = $true
                        IsScheduleSendEnabled = $true
                    }
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).M365WebEnableUsersToOpenFilesFrom3PStorage | Should -Be $False
            }

            It 'Should return false from the Test method' {
                (Test-TargetResource @testParams) | Should -Be $false
            }

            It 'Should update values from the SET method' {
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
            }

            It 'Should Reverse Engineer resource from the Export method' {
                Mock -CommandName Get-MgServicePrincipal -MockWith {
                    return @{
                        AccountEnabled = $False
                    }
                }

                Mock -CommandName Get-DefaultTenantBriefingConfig -MockWith {
                    return @{
                        IsEnabledByDefault = 'opt-in'
                    }
                }

                Mock -CommandName Get-DefaultTenantMyAnalyticsFeatureConfig -MockWith {
                    return @{
                        IsDashboardEnabled    = $true
                        IsDigestEmailEnabled  = $true
                        IsAddInEnabled        = $true
                        IsScheduleSendEnabled = $true
                    }
                }

                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
