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

$CurrentScriptPath = $PSCommandPath.Split('\')
$CurrentScriptName = $CurrentScriptPath[$CurrentScriptPath.Length -1]
$ResourceName      = $CurrentScriptName.Split('.')[1]
$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource $ResourceName -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            Mock -CommandName Set-InsiderRiskPolicy -MockWith {}
            Mock -CommandName New-InsiderRiskPolicy -MockWith {}
            Mock -CommandName Remove-InsiderRiskPolicy -MockWith {}

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }
        # Test contexts
        Context -Name "The instance should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Anonymization = $false
                    AlertVolume                                   = "Medium";
                    AnalyticsNewInsightEnabled                    = $False;
                    AnalyticsTurnedOffEnabled                     = $False;
                    AnomalyDetections                             = $False;
                    AzureStorageAccountOrContainerDeleted         = $False;
                    CCInappropriateContentSent                    = $False;
                    EnableTeam                                    = $True;
                    InsiderRiskScenario                           = "TenantSetting";
                    Mcas3rdPartyAppDownload                       = $False;
                    Name                                          = "IRM_Tenant_Setting";
                    NotificationDetailsEnabled                    = $True;
                    Ensure                                        = 'Present'
                    Credential                                    = $Credential;
                }

                Mock -CommandName Get-InsiderRiskPolicy -MockWith {
                    return $null
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create a new instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-InsiderRiskPolicy -Exactly 1
            }
        }

        Context -Name "The instance exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Anonymization = $false
                    AlertVolume                                   = "Medium";
                    AnalyticsNewInsightEnabled                    = $False;
                    AnalyticsTurnedOffEnabled                     = $False;
                    AnomalyDetections                             = $False;
                    AzureStorageAccountOrContainerDeleted         = $False;
                    CCInappropriateContentSent                    = $False;
                    EnableTeam                                    = $True;
                    InsiderRiskScenario                           = "TenantSetting";
                    Mcas3rdPartyAppDownload                       = $False;
                    Name                                          = "IRM_Tenant_Setting";
                    NotificationDetailsEnabled                    = $True;
                    Ensure                                        = 'Absent'
                    Credential                                    = $Credential;
                }

                Mock -CommandName Get-InsiderRiskPolicy -MockWith {
                    return @{
                        TenantSetting = @(
                            '{"Region":"WW","IndicatorVersion":"1.1","Indicators":[{"Name":"AnomalyDetections","Enabled":false},{"Name":"CopyToPersonalCloud","Enabled":false},{"Name":"CopyToUSB","Enabled":false},{"Name":"CumulativeExfiltrationDetector","Enabled":true},{"Name":"EmailExternal","Enabled":false},{"Name":"EmployeeAccessedEmployeePatientData","Enabled":false},{"Name":"EmployeeAccessedFamilyData","Enabled":false},{"Name":"EmployeeAccessedHighVolumePatientData","Enabled":false},{"Name":"EmployeeAccessedNeighbourData","Enabled":false},{"Name":"EmployeeAccessedRestrictedData","Enabled":false},{"Name":"EpoBrowseToChildAbuseSites","Enabled":false},{"Name":"EpoBrowseToCriminalActivitySites","Enabled":false},{"Name":"EpoBrowseToCultSites","Enabled":false},{"Name":"EpoBrowseToGamblingSites","Enabled":false},{"Name":"EpoBrowseToHackingSites","Enabled":false},{"Name":"EpoBrowseToHateIntoleranceSites","Enabled":false},{"Name":"EpoBrowseToIllegalSoftwareSites","Enabled":false},{"Name":"EpoBrowseToKeyloggerSites","Enabled":false},{"Name":"EpoBrowseToLlmSites","Enabled":false},{"Name":"EpoBrowseToMalwareSites","Enabled":false},{"Name":"EpoBrowseToPhishingSites","Enabled":false},{"Name":"EpoBrowseToPornographySites","Enabled":false},{"Name":"EpoBrowseToUnallowedDomain","Enabled":false},{"Name":"EpoBrowseToViolenceSites","Enabled":false},{"Name":"EpoCopyToClipboardFromSensitiveFile","Enabled":false},{"Name":"EpoCopyToNetworkShare","Enabled":false},{"Name":"EpoFileArchived","Enabled":false},{"Name":"EpoFileCopiedToRemoteDesktopSession","Enabled":false},{"Name":"EpoFileDeleted","Enabled":false},{"Name":"EpoFileDownloadedFromBlacklistedDomain","Enabled":false},{"Name":"EpoFileDownloadedFromEnterpriseDomain","Enabled":false},{"Name":"EpoFileRenamed","Enabled":false},{"Name":"EpoFileStagedToCentralLocation","Enabled":false},{"Name":"EpoHiddenFileCreated","Enabled":false},{"Name":"EpoRemovableMediaMount","Enabled":false},{"Name":"EpoSensitiveFileRead","Enabled":false},{"Name":"Mcas3rdPartyAppDownload","Enabled":false},{"Name":"Mcas3rdPartyAppFileDelete","Enabled":false},{"Name":"Mcas3rdPartyAppFileSharing","Enabled":false},{"Name":"McasActivityFromInfrequentCountry","Enabled":false},{"Name":"McasImpossibleTravel","Enabled":false},{"Name":"McasMultipleFailedLogins","Enabled":false},{"Name":"McasMultipleStorageDeletion","Enabled":false},{"Name":"McasMultipleVMCreation","Enabled":true},{"Name":"McasMultipleVMDeletion","Enabled":false},{"Name":"McasSuspiciousAdminActivities","Enabled":false},{"Name":"McasSuspiciousCloudCreation","Enabled":false},{"Name":"McasSuspiciousCloudTrailLoggingChange","Enabled":false},{"Name":"McasTerminatedEmployeeActivity","Enabled":false},{"Name":"OdbDownload","Enabled":false},{"Name":"OdbSyncDownload","Enabled":false},{"Name":"PeerCumulativeExfiltrationDetector","Enabled":false},{"Name":"PhysicalAccess","Enabled":false},{"Name":"PotentialHighImpactUser","Enabled":false},{"Name":"Print","Enabled":false},{"Name":"PriorityUserGroupMember","Enabled":false},{"Name":"SecurityAlertDefenseEvasion","Enabled":false},{"Name":"SecurityAlertUnwantedSoftware","Enabled":false},{"Name":"SpoAccessRequest","Enabled":false},{"Name":"SpoApprovedAccess","Enabled":false},{"Name":"SpoDownload","Enabled":false},{"Name":"SpoDownloadV2","Enabled":false},{"Name":"SpoFileAccessed","Enabled":false},{"Name":"SpoFileDeleted","Enabled":false},{"Name":"SpoFileDeletedFromFirstStageRecycleBin","Enabled":false},{"Name":"SpoFileDeletedFromSecondStageRecycleBin","Enabled":false},{"Name":"SpoFileLabelDowngraded","Enabled":false},{"Name":"SpoFileLabelRemoved","Enabled":false},{"Name":"SpoFileSharing","Enabled":true},{"Name":"SpoFolderDeleted","Enabled":false},{"Name":"SpoFolderDeletedFromFirstStageRecycleBin","Enabled":false},{"Name":"SpoFolderDeletedFromSecondStageRecycleBin","Enabled":false},{"Name":"SpoFolderSharing","Enabled":false},{"Name":"SpoSiteExternalUserAdded","Enabled":false},{"Name":"SpoSiteInternalUserAdded","Enabled":false},{"Name":"SpoSiteLabelRemoved","Enabled":false},{"Name":"SpoSiteSharing","Enabled":false},{"Name":"SpoSyncDownload","Enabled":false},{"Name":"TeamsChannelFileSharedExternal","Enabled":false},{"Name":"TeamsChannelMemberAddedExternal","Enabled":false},{"Name":"TeamsChatFileSharedExternal","Enabled":false},{"Name":"TeamsFileDownload","Enabled":false},{"Name":"TeamsFolderSharedExternal","Enabled":false},{"Name":"TeamsMemberAddedExternal","Enabled":false},{"Name":"TeamsSensitiveMessage","Enabled":false},{"Name":"UserHistory","Enabled":false}],"ExtensibleIndicators":[{"Name":"AWSS3BlockPublicAccessDisabled","Enabled":false},{"Name":"AWSS3BucketDeleted","Enabled":false},{"Name":"AWSS3PublicAccessEnabled","Enabled":false},{"Name":"AWSS3ServerLoggingDisabled","Enabled":false},{"Name":"AzureElevateAccessToAllSubscriptions","Enabled":false},{"Name":"AzureResourceThreatProtectionSettingsUpdated","Enabled":false},{"Name":"AzureSQLServerAuditingSettingsUpdated","Enabled":false},{"Name":"AzureSQLServerFirewallRuleDeleted","Enabled":false},{"Name":"AzureSQLServerFirewallRuleUpdated","Enabled":false},{"Name":"AzureStorageAccountOrContainerDeleted","Enabled":false},{"Name":"BoxContentAccess","Enabled":false},{"Name":"BoxContentDelete","Enabled":false},{"Name":"BoxContentDownload","Enabled":false},{"Name":"BoxContentExternallyShared","Enabled":false},{"Name":"CCFinancialRegulatoryRiskyTextSent","Enabled":false},{"Name":"CCInappropriateContentSent","Enabled":false},{"Name":"CCInappropriateImagesSent","Enabled":false},{"Name":"DropboxContentAccess","Enabled":false},{"Name":"DropboxContentDelete","Enabled":false},{"Name":"DropboxContentDownload","Enabled":false},{"Name":"DropboxContentExternallyShared","Enabled":false},{"Name":"GoogleDriveContentAccess","Enabled":false},{"Name":"GoogleDriveContentDelete","Enabled":false},{"Name":"GoogleDriveContentExternallyShared","Enabled":false},{"Name":"PowerBIDashboardsDeleted","Enabled":false},{"Name":"PowerBIReportsDeleted","Enabled":false},{"Name":"PowerBIReportsDownloaded","Enabled":false},{"Name":"PowerBIReportsExported","Enabled":false},{"Name":"PowerBIReportsViewed","Enabled":false},{"Name":"PowerBISemanticModelsDeleted","Enabled":false},{"Name":"PowerBISensitivityLabelDowngradedForArtifacts","Enabled":false},{"Name":"PowerBISensitivityLabelRemovedFromArtifacts","Enabled":false}],"TimeSpan":{"InScopeTimeSpan":"30","HistoricTimeSpan":"89","FutureTerminationWindow":"5","PastTerminationWindow":"5","PostTerminationActivity":"False"},"IntelligentDetections":{"FileVolCutoffLimits":"59","AlertVolume":"Medium"},"FeatureSettings":{"Anonymization":"false","DLPUserRiskSync":"true","OptInIRMDataExport":"true","RaiseAuditAlert":"true","EnableTeam":"true"},"NotificationPreferences":null,"DynamicRiskPreventionSettings":null,"InterpretedSettings":null}'
                        )
                    }
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-InsiderRiskPolicy -Exactly 1
            }
        }

        Context -Name "The instance exists and values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AnomalyDetections                             = $False;
                    InsiderRiskScenario                           = "TenantSetting";
                    Name                                          = "IRM_Tenant_Setting";
                    Ensure                                        = 'Present'
                    Credential                                    = $Credential;
                }

                Mock -CommandName Get-InsiderRiskPolicy -MockWith {
                    return @{
                        Name = "IRM_Tenant_Setting"
                        InsiderRiskScenario = "TenantSetting"
                        TenantSettings = @(
                            '{"Region":"WW","IndicatorVersion":"1.1","Indicators":[{"Name":"AnomalyDetections","Enabled":false},{"Name":"CumulativeExfiltrationDetector","Enabled":true},{"Name":"EmailExternal","Enabled":false},{"Name":"EmployeeAccessedEmployeePatientData","Enabled":false},{"Name":"EmployeeAccessedFamilyData","Enabled":false},{"Name":"EmployeeAccessedHighVolumePatientData","Enabled":false},{"Name":"EmployeeAccessedNeighbourData","Enabled":false},{"Name":"EmployeeAccessedRestrictedData","Enabled":false},{"Name":"EpoBrowseToChildAbuseSites","Enabled":false},{"Name":"EpoBrowseToCriminalActivitySites","Enabled":false},{"Name":"EpoBrowseToCultSites","Enabled":false},{"Name":"EpoBrowseToGamblingSites","Enabled":false},{"Name":"EpoBrowseToHackingSites","Enabled":false},{"Name":"EpoBrowseToHateIntoleranceSites","Enabled":false},{"Name":"EpoBrowseToIllegalSoftwareSites","Enabled":false},{"Name":"EpoBrowseToKeyloggerSites","Enabled":false},{"Name":"EpoBrowseToLlmSites","Enabled":false},{"Name":"EpoBrowseToMalwareSites","Enabled":false},{"Name":"EpoBrowseToPhishingSites","Enabled":false},{"Name":"EpoBrowseToPornographySites","Enabled":false},{"Name":"EpoBrowseToUnallowedDomain","Enabled":false},{"Name":"EpoBrowseToViolenceSites","Enabled":false},{"Name":"EpoCopyToClipboardFromSensitiveFile","Enabled":false},{"Name":"EpoCopyToNetworkShare","Enabled":false},{"Name":"EpoFileArchived","Enabled":false},{"Name":"EpoFileCopiedToRemoteDesktopSession","Enabled":false},{"Name":"EpoFileDeleted","Enabled":false},{"Name":"EpoFileDownloadedFromBlacklistedDomain","Enabled":false},{"Name":"EpoFileDownloadedFromEnterpriseDomain","Enabled":false},{"Name":"EpoFileRenamed","Enabled":false},{"Name":"EpoFileStagedToCentralLocation","Enabled":false},{"Name":"EpoHiddenFileCreated","Enabled":false},{"Name":"EpoRemovableMediaMount","Enabled":false},{"Name":"EpoSensitiveFileRead","Enabled":false},{"Name":"Mcas3rdPartyAppDownload","Enabled":false},{"Name":"Mcas3rdPartyAppFileDelete","Enabled":false},{"Name":"Mcas3rdPartyAppFileSharing","Enabled":false},{"Name":"McasActivityFromInfrequentCountry","Enabled":false},{"Name":"McasImpossibleTravel","Enabled":false},{"Name":"McasMultipleFailedLogins","Enabled":false},{"Name":"McasMultipleStorageDeletion","Enabled":false},{"Name":"McasMultipleVMCreation","Enabled":true},{"Name":"McasMultipleVMDeletion","Enabled":false},{"Name":"McasSuspiciousAdminActivities","Enabled":false},{"Name":"McasSuspiciousCloudCreation","Enabled":false},{"Name":"McasSuspiciousCloudTrailLoggingChange","Enabled":false},{"Name":"McasTerminatedEmployeeActivity","Enabled":false},{"Name":"OdbDownload","Enabled":false},{"Name":"OdbSyncDownload","Enabled":false},{"Name":"PeerCumulativeExfiltrationDetector","Enabled":false},{"Name":"PhysicalAccess","Enabled":false},{"Name":"PotentialHighImpactUser","Enabled":false},{"Name":"Print","Enabled":false},{"Name":"PriorityUserGroupMember","Enabled":false},{"Name":"SecurityAlertDefenseEvasion","Enabled":false},{"Name":"SecurityAlertUnwantedSoftware","Enabled":false},{"Name":"SpoAccessRequest","Enabled":false},{"Name":"SpoApprovedAccess","Enabled":false},{"Name":"SpoDownload","Enabled":false},{"Name":"SpoDownloadV2","Enabled":false},{"Name":"SpoFileAccessed","Enabled":false},{"Name":"SpoFileDeleted","Enabled":false},{"Name":"SpoFileDeletedFromFirstStageRecycleBin","Enabled":false},{"Name":"SpoFileDeletedFromSecondStageRecycleBin","Enabled":false},{"Name":"SpoFileLabelDowngraded","Enabled":false},{"Name":"SpoFileLabelRemoved","Enabled":false},{"Name":"SpoFileSharing","Enabled":true},{"Name":"SpoFolderDeleted","Enabled":false},{"Name":"SpoFolderDeletedFromFirstStageRecycleBin","Enabled":false},{"Name":"SpoFolderDeletedFromSecondStageRecycleBin","Enabled":false},{"Name":"SpoFolderSharing","Enabled":false},{"Name":"SpoSiteExternalUserAdded","Enabled":false},{"Name":"SpoSiteInternalUserAdded","Enabled":false},{"Name":"SpoSiteLabelRemoved","Enabled":false},{"Name":"SpoSiteSharing","Enabled":false},{"Name":"SpoSyncDownload","Enabled":false},{"Name":"TeamsChannelFileSharedExternal","Enabled":false},{"Name":"TeamsChannelMemberAddedExternal","Enabled":false},{"Name":"TeamsChatFileSharedExternal","Enabled":false},{"Name":"TeamsFileDownload","Enabled":false},{"Name":"TeamsFolderSharedExternal","Enabled":false},{"Name":"TeamsMemberAddedExternal","Enabled":false},{"Name":"TeamsSensitiveMessage","Enabled":false},{"Name":"UserHistory","Enabled":false}],"ExtensibleIndicators":[{"Name":"AWSS3BlockPublicAccessDisabled","Enabled":false},{"Name":"AWSS3BucketDeleted","Enabled":false},{"Name":"AWSS3PublicAccessEnabled","Enabled":false},{"Name":"AWSS3ServerLoggingDisabled","Enabled":false},{"Name":"AzureElevateAccessToAllSubscriptions","Enabled":false},{"Name":"AzureResourceThreatProtectionSettingsUpdated","Enabled":false},{"Name":"AzureSQLServerAuditingSettingsUpdated","Enabled":false},{"Name":"AzureSQLServerFirewallRuleDeleted","Enabled":false},{"Name":"AzureSQLServerFirewallRuleUpdated","Enabled":false},{"Name":"AzureStorageAccountOrContainerDeleted","Enabled":false},{"Name":"BoxContentAccess","Enabled":false},{"Name":"BoxContentDelete","Enabled":false},{"Name":"BoxContentDownload","Enabled":false},{"Name":"BoxContentExternallyShared","Enabled":false},{"Name":"CCFinancialRegulatoryRiskyTextSent","Enabled":false},{"Name":"CCInappropriateContentSent","Enabled":false},{"Name":"CCInappropriateImagesSent","Enabled":false},{"Name":"DropboxContentAccess","Enabled":false},{"Name":"DropboxContentDelete","Enabled":false},{"Name":"DropboxContentDownload","Enabled":false},{"Name":"DropboxContentExternallyShared","Enabled":false},{"Name":"GoogleDriveContentAccess","Enabled":false},{"Name":"GoogleDriveContentDelete","Enabled":false},{"Name":"GoogleDriveContentExternallyShared","Enabled":false},{"Name":"PowerBIDashboardsDeleted","Enabled":false},{"Name":"PowerBIReportsDeleted","Enabled":false},{"Name":"PowerBIReportsDownloaded","Enabled":false},{"Name":"PowerBIReportsExported","Enabled":false},{"Name":"PowerBIReportsViewed","Enabled":false},{"Name":"PowerBISemanticModelsDeleted","Enabled":false},{"Name":"PowerBISensitivityLabelDowngradedForArtifacts","Enabled":false},{"Name":"PowerBISensitivityLabelRemovedFromArtifacts","Enabled":false}],"TimeSpan":{"InScopeTimeSpan":"30","HistoricTimeSpan":"89","FutureTerminationWindow":"5","PastTerminationWindow":"5","PostTerminationActivity":"False"},"IntelligentDetections":{"FileVolCutoffLimits":"59","AlertVolume":"Medium"},"FeatureSettings":{"Anonymization":"false","DLPUserRiskSync":"true","OptInIRMDataExport":"true","RaiseAuditAlert":"true","EnableTeam":"true"},"NotificationPreferences":null,"DynamicRiskPreventionSettings":null,"InterpretedSettings":null}'
                        )
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The instance exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Anonymization = $false
                    AlertVolume                                   = "Medium";
                    AnalyticsNewInsightEnabled                    = $False;
                    AnalyticsTurnedOffEnabled                     = $False;
                    AnomalyDetections                             = $False;
                    AzureStorageAccountOrContainerDeleted         = $True; #Drift
                    CCInappropriateContentSent                    = $False;
                    EnableTeam                                    = $True;
                    InsiderRiskScenario                           = "TenantSetting";
                    Mcas3rdPartyAppDownload                       = $False;
                    Name                                          = "IRM_Tenant_Setting";
                    NotificationDetailsEnabled                    = $True;
                    Ensure                                        = 'Present'
                    Credential                                    = $Credential;
                }

                Mock -CommandName Get-InsiderRiskPolicy -MockWith {
                    return @{                    
                        Name = "IRM_Tenant_Setting"
                        InsiderRiskScenario = "TenantSetting"
                        TenantSettings = @(
                            '{"Region":"WW","IndicatorVersion":"1.1","Indicators":[{"Name":"AnomalyDetections","Enabled":false},{"Name":"CopyToPersonalCloud","Enabled":false},{"Name":"CopyToUSB","Enabled":false},{"Name":"CumulativeExfiltrationDetector","Enabled":true},{"Name":"EmailExternal","Enabled":false},{"Name":"EmployeeAccessedEmployeePatientData","Enabled":false},{"Name":"EmployeeAccessedFamilyData","Enabled":false},{"Name":"EmployeeAccessedHighVolumePatientData","Enabled":false},{"Name":"EmployeeAccessedNeighbourData","Enabled":false},{"Name":"EmployeeAccessedRestrictedData","Enabled":false},{"Name":"EpoBrowseToChildAbuseSites","Enabled":false},{"Name":"EpoBrowseToCriminalActivitySites","Enabled":false},{"Name":"EpoBrowseToCultSites","Enabled":false},{"Name":"EpoBrowseToGamblingSites","Enabled":false},{"Name":"EpoBrowseToHackingSites","Enabled":false},{"Name":"EpoBrowseToHateIntoleranceSites","Enabled":false},{"Name":"EpoBrowseToIllegalSoftwareSites","Enabled":false},{"Name":"EpoBrowseToKeyloggerSites","Enabled":false},{"Name":"EpoBrowseToLlmSites","Enabled":false},{"Name":"EpoBrowseToMalwareSites","Enabled":false},{"Name":"EpoBrowseToPhishingSites","Enabled":false},{"Name":"EpoBrowseToPornographySites","Enabled":false},{"Name":"EpoBrowseToUnallowedDomain","Enabled":false},{"Name":"EpoBrowseToViolenceSites","Enabled":false},{"Name":"EpoCopyToClipboardFromSensitiveFile","Enabled":false},{"Name":"EpoCopyToNetworkShare","Enabled":false},{"Name":"EpoFileArchived","Enabled":false},{"Name":"EpoFileCopiedToRemoteDesktopSession","Enabled":false},{"Name":"EpoFileDeleted","Enabled":false},{"Name":"EpoFileDownloadedFromBlacklistedDomain","Enabled":false},{"Name":"EpoFileDownloadedFromEnterpriseDomain","Enabled":false},{"Name":"EpoFileRenamed","Enabled":false},{"Name":"EpoFileStagedToCentralLocation","Enabled":false},{"Name":"EpoHiddenFileCreated","Enabled":false},{"Name":"EpoRemovableMediaMount","Enabled":false},{"Name":"EpoSensitiveFileRead","Enabled":false},{"Name":"Mcas3rdPartyAppDownload","Enabled":false},{"Name":"Mcas3rdPartyAppFileDelete","Enabled":false},{"Name":"Mcas3rdPartyAppFileSharing","Enabled":false},{"Name":"McasActivityFromInfrequentCountry","Enabled":false},{"Name":"McasImpossibleTravel","Enabled":false},{"Name":"McasMultipleFailedLogins","Enabled":false},{"Name":"McasMultipleStorageDeletion","Enabled":false},{"Name":"McasMultipleVMCreation","Enabled":true},{"Name":"McasMultipleVMDeletion","Enabled":false},{"Name":"McasSuspiciousAdminActivities","Enabled":false},{"Name":"McasSuspiciousCloudCreation","Enabled":false},{"Name":"McasSuspiciousCloudTrailLoggingChange","Enabled":false},{"Name":"McasTerminatedEmployeeActivity","Enabled":false},{"Name":"OdbDownload","Enabled":false},{"Name":"OdbSyncDownload","Enabled":false},{"Name":"PeerCumulativeExfiltrationDetector","Enabled":false},{"Name":"PhysicalAccess","Enabled":false},{"Name":"PotentialHighImpactUser","Enabled":false},{"Name":"Print","Enabled":false},{"Name":"PriorityUserGroupMember","Enabled":false},{"Name":"SecurityAlertDefenseEvasion","Enabled":false},{"Name":"SecurityAlertUnwantedSoftware","Enabled":false},{"Name":"SpoAccessRequest","Enabled":false},{"Name":"SpoApprovedAccess","Enabled":false},{"Name":"SpoDownload","Enabled":false},{"Name":"SpoDownloadV2","Enabled":false},{"Name":"SpoFileAccessed","Enabled":false},{"Name":"SpoFileDeleted","Enabled":false},{"Name":"SpoFileDeletedFromFirstStageRecycleBin","Enabled":false},{"Name":"SpoFileDeletedFromSecondStageRecycleBin","Enabled":false},{"Name":"SpoFileLabelDowngraded","Enabled":false},{"Name":"SpoFileLabelRemoved","Enabled":false},{"Name":"SpoFileSharing","Enabled":true},{"Name":"SpoFolderDeleted","Enabled":false},{"Name":"SpoFolderDeletedFromFirstStageRecycleBin","Enabled":false},{"Name":"SpoFolderDeletedFromSecondStageRecycleBin","Enabled":false},{"Name":"SpoFolderSharing","Enabled":false},{"Name":"SpoSiteExternalUserAdded","Enabled":false},{"Name":"SpoSiteInternalUserAdded","Enabled":false},{"Name":"SpoSiteLabelRemoved","Enabled":false},{"Name":"SpoSiteSharing","Enabled":false},{"Name":"SpoSyncDownload","Enabled":false},{"Name":"TeamsChannelFileSharedExternal","Enabled":false},{"Name":"TeamsChannelMemberAddedExternal","Enabled":false},{"Name":"TeamsChatFileSharedExternal","Enabled":false},{"Name":"TeamsFileDownload","Enabled":false},{"Name":"TeamsFolderSharedExternal","Enabled":false},{"Name":"TeamsMemberAddedExternal","Enabled":false},{"Name":"TeamsSensitiveMessage","Enabled":false},{"Name":"UserHistory","Enabled":false}],"ExtensibleIndicators":[{"Name":"AWSS3BlockPublicAccessDisabled","Enabled":false},{"Name":"AWSS3BucketDeleted","Enabled":false},{"Name":"AWSS3PublicAccessEnabled","Enabled":false},{"Name":"AWSS3ServerLoggingDisabled","Enabled":false},{"Name":"AzureElevateAccessToAllSubscriptions","Enabled":false},{"Name":"AzureResourceThreatProtectionSettingsUpdated","Enabled":false},{"Name":"AzureSQLServerAuditingSettingsUpdated","Enabled":false},{"Name":"AzureSQLServerFirewallRuleDeleted","Enabled":false},{"Name":"AzureSQLServerFirewallRuleUpdated","Enabled":false},{"Name":"AzureStorageAccountOrContainerDeleted","Enabled":false},{"Name":"BoxContentAccess","Enabled":false},{"Name":"BoxContentDelete","Enabled":false},{"Name":"BoxContentDownload","Enabled":false},{"Name":"BoxContentExternallyShared","Enabled":false},{"Name":"CCFinancialRegulatoryRiskyTextSent","Enabled":false},{"Name":"CCInappropriateContentSent","Enabled":false},{"Name":"CCInappropriateImagesSent","Enabled":false},{"Name":"DropboxContentAccess","Enabled":false},{"Name":"DropboxContentDelete","Enabled":false},{"Name":"DropboxContentDownload","Enabled":false},{"Name":"DropboxContentExternallyShared","Enabled":false},{"Name":"GoogleDriveContentAccess","Enabled":false},{"Name":"GoogleDriveContentDelete","Enabled":false},{"Name":"GoogleDriveContentExternallyShared","Enabled":false},{"Name":"PowerBIDashboardsDeleted","Enabled":false},{"Name":"PowerBIReportsDeleted","Enabled":false},{"Name":"PowerBIReportsDownloaded","Enabled":false},{"Name":"PowerBIReportsExported","Enabled":false},{"Name":"PowerBIReportsViewed","Enabled":false},{"Name":"PowerBISemanticModelsDeleted","Enabled":false},{"Name":"PowerBISensitivityLabelDowngradedForArtifacts","Enabled":false},{"Name":"PowerBISensitivityLabelRemovedFromArtifacts","Enabled":false}],"TimeSpan":{"InScopeTimeSpan":"30","HistoricTimeSpan":"89","FutureTerminationWindow":"5","PastTerminationWindow":"5","PostTerminationActivity":"False"},"IntelligentDetections":{"FileVolCutoffLimits":"59","AlertVolume":"Medium"},"FeatureSettings":{"Anonymization":"false","DLPUserRiskSync":"true","OptInIRMDataExport":"true","RaiseAuditAlert":"true","EnableTeam":"true"},"NotificationPreferences":null,"DynamicRiskPreventionSettings":null,"InterpretedSettings":null}'
                        )
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
                Should -Invoke -CommandName Set-InsiderRiskPolicy -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential  = $Credential;
                }

                Mock -CommandName Get-InsiderRiskPolicy -MockWith {
                    return @{
                        Name = "IRM_Tenant_Setting"
                        InsiderRiskScenario = "TenantSetting"
                        TenantSettings = @(
                            '{"Region":"WW","IndicatorVersion":"1.1","Indicators":[{"Name":"AnomalyDetections","Enabled":false},{"Name":"CopyToPersonalCloud","Enabled":false},{"Name":"CopyToUSB","Enabled":false},{"Name":"CumulativeExfiltrationDetector","Enabled":true},{"Name":"EmailExternal","Enabled":false},{"Name":"EmployeeAccessedEmployeePatientData","Enabled":false},{"Name":"EmployeeAccessedFamilyData","Enabled":false},{"Name":"EmployeeAccessedHighVolumePatientData","Enabled":false},{"Name":"EmployeeAccessedNeighbourData","Enabled":false},{"Name":"EmployeeAccessedRestrictedData","Enabled":false},{"Name":"EpoBrowseToChildAbuseSites","Enabled":false},{"Name":"EpoBrowseToCriminalActivitySites","Enabled":false},{"Name":"EpoBrowseToCultSites","Enabled":false},{"Name":"EpoBrowseToGamblingSites","Enabled":false},{"Name":"EpoBrowseToHackingSites","Enabled":false},{"Name":"EpoBrowseToHateIntoleranceSites","Enabled":false},{"Name":"EpoBrowseToIllegalSoftwareSites","Enabled":false},{"Name":"EpoBrowseToKeyloggerSites","Enabled":false},{"Name":"EpoBrowseToLlmSites","Enabled":false},{"Name":"EpoBrowseToMalwareSites","Enabled":false},{"Name":"EpoBrowseToPhishingSites","Enabled":false},{"Name":"EpoBrowseToPornographySites","Enabled":false},{"Name":"EpoBrowseToUnallowedDomain","Enabled":false},{"Name":"EpoBrowseToViolenceSites","Enabled":false},{"Name":"EpoCopyToClipboardFromSensitiveFile","Enabled":false},{"Name":"EpoCopyToNetworkShare","Enabled":false},{"Name":"EpoFileArchived","Enabled":false},{"Name":"EpoFileCopiedToRemoteDesktopSession","Enabled":false},{"Name":"EpoFileDeleted","Enabled":false},{"Name":"EpoFileDownloadedFromBlacklistedDomain","Enabled":false},{"Name":"EpoFileDownloadedFromEnterpriseDomain","Enabled":false},{"Name":"EpoFileRenamed","Enabled":false},{"Name":"EpoFileStagedToCentralLocation","Enabled":false},{"Name":"EpoHiddenFileCreated","Enabled":false},{"Name":"EpoRemovableMediaMount","Enabled":false},{"Name":"EpoSensitiveFileRead","Enabled":false},{"Name":"Mcas3rdPartyAppDownload","Enabled":false},{"Name":"Mcas3rdPartyAppFileDelete","Enabled":false},{"Name":"Mcas3rdPartyAppFileSharing","Enabled":false},{"Name":"McasActivityFromInfrequentCountry","Enabled":false},{"Name":"McasImpossibleTravel","Enabled":false},{"Name":"McasMultipleFailedLogins","Enabled":false},{"Name":"McasMultipleStorageDeletion","Enabled":false},{"Name":"McasMultipleVMCreation","Enabled":true},{"Name":"McasMultipleVMDeletion","Enabled":false},{"Name":"McasSuspiciousAdminActivities","Enabled":false},{"Name":"McasSuspiciousCloudCreation","Enabled":false},{"Name":"McasSuspiciousCloudTrailLoggingChange","Enabled":false},{"Name":"McasTerminatedEmployeeActivity","Enabled":false},{"Name":"OdbDownload","Enabled":false},{"Name":"OdbSyncDownload","Enabled":false},{"Name":"PeerCumulativeExfiltrationDetector","Enabled":false},{"Name":"PhysicalAccess","Enabled":false},{"Name":"PotentialHighImpactUser","Enabled":false},{"Name":"Print","Enabled":false},{"Name":"PriorityUserGroupMember","Enabled":false},{"Name":"SecurityAlertDefenseEvasion","Enabled":false},{"Name":"SecurityAlertUnwantedSoftware","Enabled":false},{"Name":"SpoAccessRequest","Enabled":false},{"Name":"SpoApprovedAccess","Enabled":false},{"Name":"SpoDownload","Enabled":false},{"Name":"SpoDownloadV2","Enabled":false},{"Name":"SpoFileAccessed","Enabled":false},{"Name":"SpoFileDeleted","Enabled":false},{"Name":"SpoFileDeletedFromFirstStageRecycleBin","Enabled":false},{"Name":"SpoFileDeletedFromSecondStageRecycleBin","Enabled":false},{"Name":"SpoFileLabelDowngraded","Enabled":false},{"Name":"SpoFileLabelRemoved","Enabled":false},{"Name":"SpoFileSharing","Enabled":true},{"Name":"SpoFolderDeleted","Enabled":false},{"Name":"SpoFolderDeletedFromFirstStageRecycleBin","Enabled":false},{"Name":"SpoFolderDeletedFromSecondStageRecycleBin","Enabled":false},{"Name":"SpoFolderSharing","Enabled":false},{"Name":"SpoSiteExternalUserAdded","Enabled":false},{"Name":"SpoSiteInternalUserAdded","Enabled":false},{"Name":"SpoSiteLabelRemoved","Enabled":false},{"Name":"SpoSiteSharing","Enabled":false},{"Name":"SpoSyncDownload","Enabled":false},{"Name":"TeamsChannelFileSharedExternal","Enabled":false},{"Name":"TeamsChannelMemberAddedExternal","Enabled":false},{"Name":"TeamsChatFileSharedExternal","Enabled":false},{"Name":"TeamsFileDownload","Enabled":false},{"Name":"TeamsFolderSharedExternal","Enabled":false},{"Name":"TeamsMemberAddedExternal","Enabled":false},{"Name":"TeamsSensitiveMessage","Enabled":false},{"Name":"UserHistory","Enabled":false}],"ExtensibleIndicators":[{"Name":"AWSS3BlockPublicAccessDisabled","Enabled":false},{"Name":"AWSS3BucketDeleted","Enabled":false},{"Name":"AWSS3PublicAccessEnabled","Enabled":false},{"Name":"AWSS3ServerLoggingDisabled","Enabled":false},{"Name":"AzureElevateAccessToAllSubscriptions","Enabled":false},{"Name":"AzureResourceThreatProtectionSettingsUpdated","Enabled":false},{"Name":"AzureSQLServerAuditingSettingsUpdated","Enabled":false},{"Name":"AzureSQLServerFirewallRuleDeleted","Enabled":false},{"Name":"AzureSQLServerFirewallRuleUpdated","Enabled":false},{"Name":"AzureStorageAccountOrContainerDeleted","Enabled":false},{"Name":"BoxContentAccess","Enabled":false},{"Name":"BoxContentDelete","Enabled":false},{"Name":"BoxContentDownload","Enabled":false},{"Name":"BoxContentExternallyShared","Enabled":false},{"Name":"CCFinancialRegulatoryRiskyTextSent","Enabled":false},{"Name":"CCInappropriateContentSent","Enabled":false},{"Name":"CCInappropriateImagesSent","Enabled":false},{"Name":"DropboxContentAccess","Enabled":false},{"Name":"DropboxContentDelete","Enabled":false},{"Name":"DropboxContentDownload","Enabled":false},{"Name":"DropboxContentExternallyShared","Enabled":false},{"Name":"GoogleDriveContentAccess","Enabled":false},{"Name":"GoogleDriveContentDelete","Enabled":false},{"Name":"GoogleDriveContentExternallyShared","Enabled":false},{"Name":"PowerBIDashboardsDeleted","Enabled":false},{"Name":"PowerBIReportsDeleted","Enabled":false},{"Name":"PowerBIReportsDownloaded","Enabled":false},{"Name":"PowerBIReportsExported","Enabled":false},{"Name":"PowerBIReportsViewed","Enabled":false},{"Name":"PowerBISemanticModelsDeleted","Enabled":false},{"Name":"PowerBISensitivityLabelDowngradedForArtifacts","Enabled":false},{"Name":"PowerBISensitivityLabelRemovedFromArtifacts","Enabled":false}],"TimeSpan":{"InScopeTimeSpan":"30","HistoricTimeSpan":"89","FutureTerminationWindow":"5","PastTerminationWindow":"5","PostTerminationActivity":"False"},"IntelligentDetections":{"FileVolCutoffLimits":"59","AlertVolume":"Medium"},"FeatureSettings":{"Anonymization":"false","DLPUserRiskSync":"true","OptInIRMDataExport":"true","RaiseAuditAlert":"true","EnableTeam":"true"},"NotificationPreferences":null,"DynamicRiskPreventionSettings":null,"InterpretedSettings":null}'
                        )
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
