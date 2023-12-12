# IntuneDeviceEnrollmentConfigurationWindows10

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | The display name of the device enrollment configuration | |
| **Id** | Required | String | The unique identifier for an entity. Read-only. | |
| **Description** | Write | String | The description of the device enrollment configuration | |
| **AllowDeviceResetOnInstallFailure** | Write | Boolean | Allow or block device reset on installation failure | |
| **AllowDeviceUseOnInstallFailure** | Write | Boolean | Allow the user to continue using the device on installation failure | |
| **AllowLogCollectionOnInstallFailure** | Write | Boolean | Allow or block log collection on installation failure | |
| **AllowNonBlockingAppInstallation** | Write | Boolean | Install all required apps as non blocking apps during white glove | |
| **BlockDeviceSetupRetryByUser** | Write | Boolean | Allow the user to retry the setup on installation failure | |
| **CustomErrorMessage** | Write | String | Set custom error message to show upon installation failure | |
| **DisableUserStatusTrackingAfterFirstUser** | Write | Boolean | Only show installation progress for first user post enrollment | |
| **InstallProgressTimeoutInMinutes** | Write | UInt32 | Set installation progress timeout in minutes | |
| **InstallQualityUpdates** | Write | Boolean | Allows quality updates installation during OOBE | |
| **SelectedMobileAppIds** | Write | StringArray[] | Selected applications to track the installation status | |
| **ShowInstallationProgress** | Write | Boolean | Show or hide installation progress to user | |
| **TrackInstallProgressForAutopilotOnly** | Write | Boolean | Only show installation progress for Autopilot enrollment scenarios | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |


## Description

Intune Device Enrollment Status Page Configuration for Windows10

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - DeviceManagementConfiguration.Read.All, DeviceManagementServiceConfig.Read.All

- **Update**

    - DeviceManagementConfiguration.ReadWrite.All, DeviceManagementServiceConfig.ReadWrite.All

#### Application permissions

- **Read**

    - DeviceManagementConfiguration.Read.All, DeviceManagementServiceConfig.Read.All

- **Update**

    - DeviceManagementConfiguration.ReadWrite.All, DeviceManagementServiceConfig.ReadWrite.All

## Examples

### Example 1

This example creates a new Device Enrollment Limit Restriction.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneDeviceEnrollmentConfigurationWindows10 '6b43c039-c1d0-4a9f-aab9-48c5531acbd6'
        {
            Id                                      = 'b8258075-8457-4ecf-9aed-82754ec868bf_DefaultWindows10EnrollmentCompletionPageConfiguration'
            DisplayName                             = 'All users and all devices'
            AllowDeviceResetOnInstallFailure        = $false
            AllowDeviceUseOnInstallFailure          = $false
            AllowLogCollectionOnInstallFailure      = $false
            AllowNonBlockingAppInstallation         = $false
            BlockDeviceSetupRetryByUser             = $true
            CustomErrorMessage                      = ''
            Description                             = 'This is the default enrollment status screen configuration applied with the lowest priority to all users and all devices regardless of group membership.'
            DisableUserStatusTrackingAfterFirstUser = $false
            InstallProgressTimeoutInMinutes         = 0
            InstallQualityUpdates                   = $false
            SelectedMobileAppIds                    = @()
            ShowInstallationProgress                = $false
            TrackInstallProgressForAutopilotOnly    = $false
            Ensure                                  = 'Present'
            Credential                              = $Credscredential
        }
    }
}
```

