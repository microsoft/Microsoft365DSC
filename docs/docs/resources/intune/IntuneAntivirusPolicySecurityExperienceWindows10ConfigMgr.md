# IntuneAntivirusPolicySecurityExperienceWindows10ConfigMgr

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Description** | Write | String | Policy description | |
| **DisplayName** | Key | String | Policy name | |
| **RoleScopeTagIds** | Write | StringArray[] | List of Scope Tags for this Entity instance. | |
| **Id** | Write | String | The unique identifier for an entity. Read-only. | |
| **DisableAccountProtectionUI** | Write | SInt32 | Disable Account Protection UI (0: (Disable) The users can see the display of the Account protection area in Windows Defender Security Center., 1: (Enable) The users cannot see the display of the Account protection area in Windows Defender Security Center.) | `0`, `1` |
| **DisableAppBrowserUI** | Write | SInt32 | Disable App Browser UI (0: (Disable) The users can see the display of the app and browser protection area in Windows Defender Security Center., 1: (Enable) The users cannot see the display of the app and browser protection area in Windows Defender Security Center.) | `0`, `1` |
| **DisableClearTpmButton** | Write | SInt32 | Disable Clear Tpm Button (0: (Disabled or not configured) The security processor troubleshooting page shows a button that initiates the process to clear the security processor (TPM)., 1: (Enabled) The security processor troubleshooting page will not show a button to initiate the process to clear the security processor (TPM)) | `0`, `1` |
| **DisableDeviceSecurityUI** | Write | SInt32 | Disable Device Security UI (0: (Disable) The users can see the display of the Device security area in Windows Defender Security Center., 1: (Enable) The users cannot see the display of the Device security area in Windows Defender Security Center.) | `0`, `1` |
| **DisableFamilyUI** | Write | SInt32 | Disable Family UI (0: (Disable) The users can see the display of the family options area in Windows Defender Security Center., 1: (Enable) The users cannot see the display of the family options area in Windows Defender Security Center.) | `0`, `1` |
| **DisableHealthUI** | Write | SInt32 | Disable Health UI (0: (Disable) The users can see the display of the device performance and health area in Windows Defender Security Center., 1: (Enable) The users cannot see the display of the device performance and health area in Windows Defender Security Center.) | `0`, `1` |
| **DisableNetworkUI** | Write | SInt32 | Disable Network UI (0: (Disable) The users can see the display of the firewall and network protection area in Windows Defender Security Center., 1: (Enable) The users cannot see the display of the firewall and network protection area in Windows Defender Security Center.) | `0`, `1` |
| **DisableNotifications** | Write | SInt32 | Disable Notifications (0: (Disable) The users can see the display of Windows Defender Security Center notifications., 1: (Enable) The users cannot see the display of Windows Defender Security Center notifications.) | |
| **DisableEnhancedNotifications** | Write | SInt32 | Disable Enhanced Notifications (0: (Disable) Windows Defender Security Center will display critical and non-critical notifications to users.., 1: (Enable) Windows Defender Security Center only display notifications which are considered critical on clients.) | `0`, `1` |
| **DisableTpmFirmwareUpdateWarning** | Write | SInt32 | Disable Tpm Firmware Update Warning (0: (Disable or Not configured) A warning will be displayed if the firmware of the security processor (TPM) should be updated for TPMs that have a vulnerability., 1: (Enabled) No warning will be displayed if the firmware of the security processor (TPM) should be updated.) | `0`, `1` |
| **DisableVirusUI** | Write | SInt32 | Disable Virus UI (0: (Disable) The users can see the display of the virus and threat protection area in Windows Defender Security Center., 1: (Enable) The users cannot see the display of the virus and threat protection area in Windows Defender Security Center.) | `0`, `1` |
| **HideRansomwareDataRecovery** | Write | SInt32 | Hide Ransomware Data Recovery (0: (Disable or not configured) The Ransomware data recovery area will be visible., 1: (Enable) The Ransomware data recovery area is hidden.) | `0`, `1` |
| **HideWindowsSecurityNotificationAreaControl** | Write | SInt32 | Hide Windows Security Notification Area Control (0: , 1: Enabled) | `0`, `1` |
| **CompanyName** | Write | String | Company Name | |
| **Email** | Write | String | Email | |
| **Phone** | Write | String | Phone | |
| **URL** | Write | String | URL | |
| **TamperProtection** | Write | String | TamperProtection (Device) (1: Offboarding, 0: Onboarding) | `1`, `0` |
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

Intune Antivirus Policy Security Experience for Windows10 Config Mgr

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
        IntuneAntivirusPolicySecurityExperienceWindows10ConfigMgr "IntuneAntivirusPolicySecurityExperienceWindows10ConfigMgr-Windows ConfigMgr - Windows Security experience"
        {
            ApplicationId                              = $ApplicationId;
            Assignments                                = @();
            CertificateThumbprint                      = $CertificateThumbprint;
            CompanyName                                = "contoso";
            Description                                = "";
            DisableAccountProtectionUI                 = "0";
            DisableAppBrowserUI                        = "0";
            DisableClearTpmButton                      = "0";
            DisableDeviceSecurityUI                    = "0";
            DisableEnhancedNotifications               = "0";
            DisableFamilyUI                            = "0";
            DisableHealthUI                            = "0";
            DisableNetworkUI                           = "0";
            DisableNotifications                       = "1";
            DisableTpmFirmwareUpdateWarning            = "0";
            DisableVirusUI                             = "0";
            DisplayName                                = "Windows ConfigMgr - Windows Security experience";
            Email                                      = "dummy@contoso.com";
            Ensure                                     = "Present";
            HideRansomwareDataRecovery                 = "0";
            HideWindowsSecurityNotificationAreaControl = "1";
            Phone                                      = "asdf";
            RoleScopeTagIds                            = @("0");
            TamperProtection                           = "1";
            TenantId                                   = $TenantId;
            URL                                        = "http://asdf";
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
        IntuneAntivirusPolicySecurityExperienceWindows10ConfigMgr "IntuneAntivirusPolicySecurityExperienceWindows10ConfigMgr-Windows ConfigMgr - Windows Security experience"
        {
            ApplicationId                              = $ApplicationId;
            Assignments                                = @();
            CertificateThumbprint                      = $CertificateThumbprint;
            CompanyName                                = "contoso";
            Description                                = "";
            DisableAccountProtectionUI                 = "0";
            DisableAppBrowserUI                        = "1"; # Updated property
            DisableClearTpmButton                      = "0";
            DisableDeviceSecurityUI                    = "0";
            DisableEnhancedNotifications               = "0";
            DisableFamilyUI                            = "0";
            DisableHealthUI                            = "0";
            DisableNetworkUI                           = "0";
            DisableNotifications                       = "1";
            DisableTpmFirmwareUpdateWarning            = "0";
            DisableVirusUI                             = "0";
            DisplayName                                = "Windows ConfigMgr - Windows Security experience";
            Email                                      = "dummy@contoso.com";
            Ensure                                     = "Present";
            HideRansomwareDataRecovery                 = "0";
            HideWindowsSecurityNotificationAreaControl = "1";
            Phone                                      = "asdf";
            RoleScopeTagIds                            = @("0");
            TamperProtection                           = "1";
            TenantId                                   = $TenantId;
            URL                                        = "http://asdf";
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
        IntuneAntivirusPolicySecurityExperienceWindows10ConfigMgr "IntuneAntivirusPolicySecurityExperienceWindows10ConfigMgr-Windows ConfigMgr - Windows Security experience"
        {
            ApplicationId                              = $ApplicationId;
            CertificateThumbprint                      = $CertificateThumbprint;
            DisplayName                                = "Windows ConfigMgr - Windows Security experience";
            Ensure                                     = "Absent";
            TenantId                                   = $TenantId;
        }
    }
}
```

