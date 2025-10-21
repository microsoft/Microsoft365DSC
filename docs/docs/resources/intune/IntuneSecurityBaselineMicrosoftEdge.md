# IntuneSecurityBaselineMicrosoftEdge

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Description** | Write | String | Policy description | |
| **DisplayName** | Key | String | Policy name | |
| **RoleScopeTagIds** | Write | StringArray[] | List of Scope Tags for this Entity instance. | |
| **Id** | Write | String | The unique identifier for an entity. Read-only. | |
| **InternetExplorerIntegrationReloadInIEModeAllowed** | Write | SInt32 | Allow unconfigured sites to be reloaded in Internet Explorer mode (0: Disabled, 1: Enabled) | `0`, `1` |
| **SSLErrorOverrideAllowed** | Write | SInt32 | Allow users to proceed from the HTTPS warning page (0: Disabled, 1: Enabled) | `0`, `1` |
| **InternetExplorerIntegrationZoneIdentifierMhtFileAllowed** | Write | SInt32 | Automatically open downloaded MHT or MHTML files from the web in Internet Explorer mode (0: Disabled, 1: Enabled) | `0`, `1` |
| **edge_DynamicCodeSettings** | Write | SInt32 | Dynamic Code Settings (0: Disabled, 1: Enabled) | `0`, `1` |
| **DynamicCodeSettings_DynamicCodeSettings** | Write | SInt32 | Dynamic Code Settings (Device) - Depends on edge_DynamicCodeSettings (0: Default dynamic code settings, 1: Prevent the browser process from creating dynamic code) | `0`, `1` |
| **ApplicationBoundEncryptionEnabled** | Write | SInt32 | Enable Application Bound Encryption (0: Disabled, 1: Enabled) | `0`, `1` |
| **BrowserLegacyExtensionPointsBlockingEnabled** | Write | SInt32 | Enable browser legacy extension point blocking (0: Disabled, 1: Enabled) | `0`, `1` |
| **SitePerProcess** | Write | SInt32 | Enable site isolation for every site (0: Disabled, 1: Enabled) | `0`, `1` |
| **EdgeEnhanceImagesEnabled** | Write | SInt32 | Enhance images enabled (0: Disabled, 1: Enabled) | `0`, `1` |
| **ExtensionInstallBlocklist** | Write | SInt32 | Control which extensions cannot be installed (0: Disabled, 1: Enabled) | `0`, `1` |
| **ExtensionInstallBlocklistDesc** | Write | StringArray[] | Extension IDs the user should be prevented from installing (or * for all) (Device) - Depends on ExtensionInstallBlocklist | |
| **WebSQLAccess** | Write | SInt32 | Force WebSQL to be enabled (0: Disabled, 1: Enabled) | `0`, `1` |
| **BasicAuthOverHttpEnabled** | Write | SInt32 | Allow Basic authentication for HTTP (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftEdge_HTTPAuthentication_AuthSchemes** | Write | SInt32 | Supported authentication schemes (0: Disabled, 1: Enabled) | `0`, `1` |
| **AuthSchemes_AuthSchemes** | Write | String | Supported authentication schemes (Device) - Depends on MicrosoftEdge_HTTPAuthentication_AuthSchemes | |
| **NativeMessagingUserLevelHosts** | Write | SInt32 | Allow user-level native messaging hosts (installed without admin permissions) (0: Disabled, 1: Enabled) | `0`, `1` |
| **InsecurePrivateNetworkRequestsAllowed** | Write | SInt32 | Specifies whether to allow insecure websites to make requests to more-private network endpoints (0: Disabled, 1: Enabled) | `0`, `1` |
| **InternetExplorerModeToolbarButtonEnabled** | Write | SInt32 | Show the Reload in Internet Explorer mode button in the toolbar (0: Disabled, 1: Enabled) | `0`, `1` |
| **SmartScreenEnabled** | Write | SInt32 | Configure Microsoft Defender SmartScreen (0: Disabled, 1: Enabled) | `0`, `1` |
| **SmartScreenPuaEnabled** | Write | SInt32 | Configure Microsoft Defender SmartScreen to block potentially unwanted apps (0: Disabled, 1: Enabled) | `0`, `1` |
| **PreventSmartScreenPromptOverride** | Write | SInt32 | Prevent bypassing Microsoft Defender SmartScreen prompts for sites (0: Disabled, 1: Enabled) | `0`, `1` |
| **PreventSmartScreenPromptOverrideForFiles** | Write | SInt32 | Prevent bypassing of Microsoft Defender SmartScreen warnings about downloads (0: Disabled, 1: Enabled) | `0`, `1` |
| **SharedArrayBufferUnrestrictedAccessAllowed** | Write | SInt32 | Specifies whether SharedArrayBuffers can be used in a non cross-origin-isolated context (0: Disabled, 1: Enabled) | `0`, `1` |
| **TyposquattingCheckerEnabled** | Write | SInt32 | Configure Edge TyposquattingChecker (0: Disabled, 1: Enabled) | `0`, `1` |
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
| **dataType** | Write | String | The type of the target assignment. | `#microsoft.graph.cloudPcManagementGroupAssignmentTarget`, `#microsoft.graph.groupAssignmentTarget`, `#microsoft.graph.allLicensedUsersAssignmentTarget`, `#microsoft.graph.allDevicesAssignmentTarget`, `#microsoft.graph.exclusionGroupAssignmentTarget`, `#microsoft.graph.configurationManagerCollectionAssignmentTarget` |
| **deviceAndAppManagementAssignmentFilterType** | Write | String | The type of filter of the target assignment i.e. Exclude or Include. Possible values are:none, include, exclude. | `none`, `include`, `exclude` |
| **deviceAndAppManagementAssignmentFilterId** | Write | String | The Id of the filter for the target assignment. | |
| **deviceAndAppManagementAssignmentFilterDisplayName** | Write | String | The display name of the filter for the target assignment. | |
| **groupId** | Write | String | The group Id that is the target of the assignment. | |
| **groupDisplayName** | Write | String | The group Display Name that is the target of the assignment. | |
| **collectionId** | Write | String | The collection Id that is the target of the assignment.(ConfigMgr) | |


## Description

Intune Security Baseline Microsoft Edge

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Group.Read.All, DeviceManagementConfiguration.Read.All

- **Update**

    - Group.Read.All, DeviceManagementConfiguration.ReadWrite.All

#### Application permissions

- **Read**

    - Group.Read.All, DeviceManagementConfiguration.Read.All

- **Update**

    - Group.Read.All, DeviceManagementConfiguration.ReadWrite.All

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

    node localhost
    {
        IntuneSecurityBaselineMicrosoftEdge 'mySecurityBaselineMicrosoftEdge'
        {
            DisplayName           = 'test'
            InsecurePrivateNetworkRequestsAllowed                   = "0";
            InternetExplorerIntegrationReloadInIEModeAllowed        = "0";
            InternetExplorerIntegrationZoneIdentifierMhtFileAllowed = "0";
            InternetExplorerModeToolbarButtonEnabled                = "0";
            Ensure                = 'Present'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
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

    node localhost
    {
        IntuneSecurityBaselineMicrosoftEdge 'mySecurityBaselineMicrosoftEdge'
        {
            DisplayName           = 'test'
            InsecurePrivateNetworkRequestsAllowed                   = "0";
            InternetExplorerIntegrationReloadInIEModeAllowed        = "0";
            InternetExplorerIntegrationZoneIdentifierMhtFileAllowed = "0";
            InternetExplorerModeToolbarButtonEnabled                = "1"; # Drift
            Ensure                = 'Present'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
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

    node localhost
    {
        IntuneSecurityBaselineMicrosoftEdge 'mySecurityBaselineMicrosoftEdge'
        {
            DisplayName           = 'test'
            Ensure                = 'Absent'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

