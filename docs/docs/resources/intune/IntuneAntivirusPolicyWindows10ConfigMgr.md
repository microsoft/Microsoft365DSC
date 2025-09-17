# IntuneAntivirusPolicyWindows10ConfigMgr

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Description** | Write | String | Policy description | |
| **DisplayName** | Key | String | Policy name | |
| **RoleScopeTagIds** | Write | StringArray[] | List of Scope Tags for this Entity instance. | |
| **Id** | Write | String | The unique identifier for an entity. Read-only. | |
| **AllowArchiveScanning** | Write | SInt32 | Allow Archive Scanning (0: Not allowed. Turns off scanning on archived files., 1: Allowed. Scans the archive files.) | `0`, `1` |
| **AllowBehaviorMonitoring** | Write | SInt32 | Allow Behavior Monitoring (0: Not allowed. Turns off behavior monitoring., 1: Allowed. Turns on real-time behavior monitoring.) | `0`, `1` |
| **AllowCloudProtection** | Write | SInt32 | Allow Cloud Protection (0: Not allowed. Turns off the Microsoft Active Protection Service., 1: Allowed. Turns on the Microsoft Active Protection Service.) | `0`, `1` |
| **AllowEmailScanning** | Write | SInt32 | Allow Email Scanning (0: Not allowed. Turns off email scanning., 1: Allowed. Turns on email scanning.) | `0`, `1` |
| **AllowFullScanOnMappedNetworkDrives** | Write | SInt32 | Allow Full Scan On Mapped Network Drives (0: Not allowed. Disables scanning on mapped network drives., 1: Allowed. Scans mapped network drives.) | `0`, `1` |
| **AllowFullScanRemovableDriveScanning** | Write | SInt32 | Allow Full Scan Removable Drive Scanning (0: Not allowed. Turns off scanning on removable drives., 1: Allowed. Scans removable drives.) | `0`, `1` |
| **AllowIntrusionPreventionSystem** | Write | SInt32 | [Deprecated] Allow Intrusion Prevention System (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **AllowIOAVProtection** | Write | SInt32 | Allow scanning of all downloaded files and attachments (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **AllowRealtimeMonitoring** | Write | SInt32 | Allow Realtime Monitoring (0: Not allowed. Turns off the real-time monitoring service., 1: Allowed. Turns on and runs the real-time monitoring service.) | `0`, `1` |
| **AllowScanningNetworkFiles** | Write | SInt32 | Allow Scanning Network Files (0: Not allowed. Turns off scanning of network files., 1: Allowed. Scans network files.) | `0`, `1` |
| **AllowScriptScanning** | Write | SInt32 | Allow Script Scanning (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **AllowUserUIAccess** | Write | SInt32 | Allow User UI Access (0: Not allowed. Prevents users from accessing UI., 1: Allowed. Lets users access UI.) | `0`, `1` |
| **AvgCPULoadFactor** | Write | SInt32 | Avg CPU Load Factor | |
| **CheckForSignaturesBeforeRunningScan** | Write | SInt32 | Check For Signatures Before Running Scan (0: Disabled, 1: Enabled) | `0`, `1` |
| **CloudBlockLevel** | Write | SInt32 | Cloud Block Level (0: NotConfigured, 2: High, 4: HighPlus, 6: ZeroTolerance) | `0`, `2`, `4`, `6` |
| **CloudExtendedTimeout** | Write | SInt32 | Cloud Extended Timeout | |
| **DaysToRetainCleanedMalware** | Write | SInt32 | Days To Retain Cleaned Malware | |
| **DisableCatchupFullScan** | Write | SInt32 | Disable Catchup Full Scan (0: Enabled, 1: Disabled) | `0`, `1` |
| **DisableCatchupQuickScan** | Write | SInt32 | Disable Catchup Quick Scan (0: Enabled, 1: Disabled) | `0`, `1` |
| **EnableLowCPUPriority** | Write | SInt32 | Enable Low CPU Priority (0: Disabled, 1: Enabled) | `0`, `1` |
| **ExcludedExtensions** | Write | StringArray[] | Excluded Extensions | |
| **ExcludedPaths** | Write | StringArray[] | Excluded Paths | |
| **ExcludedProcesses** | Write | StringArray[] | Excluded Processes | |
| **PUAProtection** | Write | SInt32 | PUA Protection (0: PUA Protection off. Windows Defender will not protect against potentially unwanted applications., 1: PUA Protection on. Detected items are blocked. They will show in history along with other threats., 2: Audit mode. Windows Defender will detect potentially unwanted applications, but take no action. You can review information about the applications Windows Defender would have taken action against by searching for events created by Windows Defender in the Event Viewer.) | `0`, `1`, `2` |
| **RealTimeScanDirection** | Write | SInt32 | Real Time Scan Direction (0: Monitor all files (bi-directional)., 1: Monitor incoming files., 2: Monitor outgoing files.) | `0`, `1`, `2` |
| **ScanParameter** | Write | SInt32 | Scan Parameter (1: Quick scan, 2: Full scan) | `1`, `2` |
| **ScheduleQuickScanTime** | Write | SInt32 | Schedule Quick Scan Time | |
| **ScheduleScanDay** | Write | SInt32 | Schedule Scan Day (0: Every day, 1: Sunday, 2: Monday, 3: Tuesday, 4: Wednesday, 5: Thursday, 6: Friday, 7: Saturday, 8: No scheduled scan) | `0`, `1`, `2`, `3`, `4`, `5`, `6`, `7`, `8` |
| **ScheduleScanTime** | Write | SInt32 | Schedule Scan Time | |
| **SignatureUpdateFallbackOrder** | Write | StringArray[] | Signature Update Fallback Order | |
| **SignatureUpdateFileSharesSources** | Write | StringArray[] | Signature Update File Shares Sources | |
| **SignatureUpdateInterval** | Write | SInt32 | Signature Update Interval | |
| **SubmitSamplesConsent** | Write | SInt32 | Submit Samples Consent (0: Always prompt., 1: Send safe samples automatically., 2: Never send., 3: Send all samples automatically.) | `0`, `1`, `2`, `3` |
| **AllowOnAccessProtection** | Write | SInt32 | Allow On Access Protection (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **HighSeverityThreatDefaultAction** | Write | String | Remediation action for High severity threats - Depends on ThreatSeverityDefaultAction (clean: Clean, quarantine: Quarantine, remove: Remove, allow: Allow, userdefined: UserDefined, block: Block) | `clean`, `quarantine`, `remove`, `allow`, `userdefined`, `block` |
| **SevereThreatDefaultAction** | Write | String | Remediation action for Severe threats - Depends on ThreatSeverityDefaultAction (clean: Clean, quarantine: Quarantine, remove: Remove, allow: Allow, userdefined: UserDefined, block: Block) | `clean`, `quarantine`, `remove`, `allow`, `userdefined`, `block` |
| **LowSeverityThreatDefaultAction** | Write | String | Remediation action for Low severity threats - Depends on ThreatSeverityDefaultAction (clean: Clean, quarantine: Quarantine, remove: Remove, allow: Allow, userdefined: UserDefined, block: Block) | `clean`, `quarantine`, `remove`, `allow`, `userdefined`, `block` |
| **ModerateSeverityThreatDefaultAction** | Write | String | Remediation action for Moderate severity threats - Depends on ThreatSeverityDefaultAction (clean: Clean, quarantine: Quarantine, remove: Remove, allow: Allow, userdefined: UserDefined, block: Block) | `clean`, `quarantine`, `remove`, `allow`, `userdefined`, `block` |
| **DisablePrivacyMode** | Write | SInt32 | Allow users to view the full History results (0: No, 1: Yes) | `0`, `1` |
| **DisableRestorePoint** | Write | SInt32 | Create a system restore point before computers are cleaned. (0: No, 1: Yes) | `0`, `1` |
| **RandomizeScheduleTaskTimes** | Write | SInt32 | Randomize scheduled scan and security intelligence update start times. (0: No, 1: Yes) | `0`, `1` |
| **SecurityIntelligenceLocation** | Write | String | Security Intelligence Location | |
| **Assignments** | Write | MSFT_DeviceManagementConfigurationPolicyAssignments[] | Represents the assignment to the Intune policy. | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

### MSFT_DeviceManagementConfigurationPolicyAssignments

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **dataType** | Write | String | The type of the target assignment. | `#microsoft.graph.groupAssignmentTarget`, `#microsoft.graph.allLicensedUsersAssignmentTarget`, `#microsoft.graph.allDevicesAssignmentTarget`, `#microsoft.graph.exclusionGroupAssignmentTarget`, `#microsoft.graph.configurationManagerCollectionAssignmentTarget` |
| **deviceAndAppManagementAssignmentFilterType** | Write | String | The type of filter of the target assignment i.e. Exclude or Include. Possible values are:none, include, exclude. | `none`, `include`, `exclude` |
| **deviceAndAppManagementAssignmentFilterId** | Write | String | The Id of the filter for the target assignment. | |
| **deviceAndAppManagementAssignmentFilterDisplayName** | Write | String | The display name of the filter for the target assignment. | |
| **groupId** | Write | String | The group Id that is the target of the assignment. | |
| **groupDisplayName** | Write | String | The group Display Name that is the target of the assignment. | |
| **collectionId** | Write | String | The collection Id that is the target of the assignment.(ConfigMgr) | |


## Description

Intune Antivirus Policy for Windows10 Config Mgr

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - DeviceManagementConfiguration.Read.All, Group.Read.All

- **Update**

    - DeviceManagementConfiguration.ReadWrite.All, Group.Read.All

#### Application permissions

- **Read**

    - DeviceManagementConfiguration.Read.All, Group.Read.All

- **Update**

    - DeviceManagementConfiguration.ReadWrite.All, Group.Read.All

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
        IntuneAntivirusPolicyWindows10ConfigMgr "IntuneAntivirusPolicyWindows10ConfigMgr-Windows ConfigMgr - Microsoft Defender Antivirus"
        {
            AllowArchiveScanning                = "1";
            AllowBehaviorMonitoring             = "1";
            AllowCloudProtection                = "1";
            AllowEmailScanning                  = "1";
            AllowFullScanOnMappedNetworkDrives  = "0";
            AllowFullScanRemovableDriveScanning = "1";
            AllowIntrusionPreventionSystem      = "1";
            AllowIOAVProtection                 = "1";
            AllowOnAccessProtection             = "1";
            AllowRealtimeMonitoring             = "1";
            AllowScanningNetworkFiles           = "1";
            AllowScriptScanning                 = "1";
            AllowUserUIAccess                   = "1";
            ApplicationId                       = $ApplicationId;
            Assignments                         = @();
            AvgCPULoadFactor                    = 50;
            CertificateThumbprint               = $CertificateThumbprint;
            CheckForSignaturesBeforeRunningScan = "1";
            CloudBlockLevel                     = "2";
            CloudExtendedTimeout                = 30;
            DaysToRetainCleanedMalware          = 30;
            Description                         = "";
            DisableCatchupFullScan              = "0";
            DisableCatchupQuickScan             = "0";
            DisablePrivacyMode                  = "1";
            DisableRestorePoint                 = "1";
            DisplayName                         = "Windows ConfigMgr - Microsoft Defender Antivirus";
            EnableLowCPUPriority                = "0";
            Ensure                              = "Present";
            ExcludedExtensions                  = @("asdf");
            ExcludedPaths                       = @("asdf");
            ExcludedProcesses                   = @("asdf");
            HighSeverityThreatDefaultAction     = "remove";
            LowSeverityThreatDefaultAction      = "quarantine";
            ModerateSeverityThreatDefaultAction = "quarantine";
            PUAProtection                       = "1";
            RandomizeScheduleTaskTimes          = "1";
            RealTimeScanDirection               = "0";
            RoleScopeTagIds                     = @("0");
            ScanParameter                       = "1";
            ScheduleQuickScanTime               = 60;
            ScheduleScanDay                     = "0";
            ScheduleScanTime                    = 120;
            SecurityIntelligenceLocation        = "Secure Intelligence Location";
            SevereThreatDefaultAction           = "quarantine";
            SignatureUpdateFallbackOrder        = @("asdf");
            SignatureUpdateFileSharesSources    = @("asdf");
            SignatureUpdateInterval             = 8;
            SubmitSamplesConsent                = "1";
            TenantId                            = $TenantId;
        }
    }
}
```

### Example 2

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
        IntuneAntivirusPolicyWindows10ConfigMgr "IntuneAntivirusPolicyWindows10ConfigMgr-Windows ConfigMgr - Microsoft Defender Antivirus"
        {
            AllowArchiveScanning                = "1";
            AllowBehaviorMonitoring             = "1";
            AllowCloudProtection                = "1";
            AllowEmailScanning                  = "1";
            AllowFullScanOnMappedNetworkDrives  = "0";
            AllowFullScanRemovableDriveScanning = "1";
            AllowIntrusionPreventionSystem      = "1";
            AllowIOAVProtection                 = "1";
            AllowOnAccessProtection             = "1";
            AllowRealtimeMonitoring             = "1";
            AllowScanningNetworkFiles           = "1";
            AllowScriptScanning                 = "1";
            AllowUserUIAccess                   = "0"; # Updated property
            ApplicationId                       = $ApplicationId;
            Assignments                         = @();
            AvgCPULoadFactor                    = 50;
            CertificateThumbprint               = $CertificateThumbprint;
            CheckForSignaturesBeforeRunningScan = "1";
            CloudBlockLevel                     = "2";
            CloudExtendedTimeout                = 30;
            DaysToRetainCleanedMalware          = 30;
            Description                         = "";
            DisableCatchupFullScan              = "0";
            DisableCatchupQuickScan             = "0";
            DisablePrivacyMode                  = "1";
            DisableRestorePoint                 = "1";
            DisplayName                         = "Windows ConfigMgr - Microsoft Defender Antivirus";
            EnableLowCPUPriority                = "0";
            Ensure                              = "Present";
            ExcludedExtensions                  = @("asdf");
            ExcludedPaths                       = @("asdf");
            ExcludedProcesses                   = @("asdf");
            HighSeverityThreatDefaultAction     = "remove";
            LowSeverityThreatDefaultAction      = "quarantine";
            ModerateSeverityThreatDefaultAction = "quarantine";
            PUAProtection                       = "1";
            RandomizeScheduleTaskTimes          = "1";
            RealTimeScanDirection               = "0";
            RoleScopeTagIds                     = @("0");
            ScanParameter                       = "1";
            ScheduleQuickScanTime               = 60;
            ScheduleScanDay                     = "0";
            ScheduleScanTime                    = 120;
            SecurityIntelligenceLocation        = "Secure Intelligence Location";
            SevereThreatDefaultAction           = "quarantine";
            SignatureUpdateFallbackOrder        = @("asdf");
            SignatureUpdateFileSharesSources    = @("asdf");
            SignatureUpdateInterval             = 8;
            SubmitSamplesConsent                = "1";
            TenantId                            = $TenantId;
        }
    }
}
```

### Example 3

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
        IntuneAntivirusPolicyWindows10ConfigMgr "IntuneAntivirusPolicyWindows10ConfigMgr-Windows ConfigMgr - Microsoft Defender Antivirus"
        {
            ApplicationId                              = $ApplicationId;
            CertificateThumbprint                      = $CertificateThumbprint;
            DisplayName                                = "Windows ConfigMgr - Microsoft Defender Antivirus";
            Ensure                                     = "Absent";
            TenantId                                   = $TenantId;
        }
    }
}
```

