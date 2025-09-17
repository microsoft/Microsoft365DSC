# IntuneDeviceCleanupRuleV2

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Description** | Write | String | Indicates the description for the device clean up rule. | |
| **DeviceCleanupRulePlatformType** | Write | String | Indicates the managed device platform for which the admin wants to create the device clean up rule. Possible values are: all, androidAOSP, androidDeviceAdministrator, androidDedicatedAndFullyManagedCorporateOwnedWorkProfile, chromeOS, androidPersonallyOwnedWorkProfile, ios, macOS, windows, windowsHolographic, unknownFutureValue, visionOS, tvOS. | `all`, `androidAOSP`, `androidDeviceAdministrator`, `androidDedicatedAndFullyManagedCorporateOwnedWorkProfile`, `chromeOS`, `androidPersonallyOwnedWorkProfile`, `ios`, `macOS`, `windows`, `windowsHolographic`, `unknownFutureValue`, `visionOS`, `tvOS` |
| **DeviceInactivityBeforeRetirementInDays** | Write | UInt32 | Indicates the number of days when the device has not contacted Intune. Valid values 0 to 2147483647 | |
| **DisplayName** | Key | String | Indicates the display name of the device cleanup rule. | |
| **Id** | Write | String | The unique identifier for an entity. Read-only. | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

Intune Device Cleanup Rule V2.

Only one instance of each platform can be configured. Multiple cleanup rules for the same platform are not supported.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - DeviceManagementConfiguration.Read.All

- **Update**

    - DeviceManagementConfiguration.ReadWrite.All

#### Application permissions

- **Read**

    - DeviceManagementConfiguration.Read.All

- **Update**

    - DeviceManagementConfiguration.ReadWrite.All

## Examples

### Example 1

This example creates a device cleanup rule.

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
        IntuneDeviceCleanupRuleV2 'Example'
        {
            DisplayName                            = "Rule 1";
            Description                            = "";
            DeviceCleanupRulePlatformType          = "all";
            DeviceInactivityBeforeRetirementInDays = 30;
            Ensure                                 = 'Present';
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

### Example 2

This example updates a device cleanup rule.

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
        IntuneDeviceCleanupRuleV2 'Example'
        {
            DisplayName                            = "Rule 1";
            Description                            = "";
            DeviceCleanupRulePlatformType          = "all";
            DeviceInactivityBeforeRetirementInDays = 25; # Updated Property
            Ensure                                 = 'Present';
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

### Example 3

This example removes a device cleanup rule.

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
        IntuneDeviceCleanupRuleV2 'Example'
        {
            DisplayName           = "Rule 1";
            Ensure                = 'Absent';
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

