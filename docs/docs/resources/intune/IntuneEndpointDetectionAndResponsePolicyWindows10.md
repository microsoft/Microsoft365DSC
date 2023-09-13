﻿# IntuneEndpointDetectionAndResponsePolicyWindows10

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Identity of the endpoint detection and response policy for Windows 10. | |
| **DisplayName** | Required | String | Display name of the endpoint detection and response policy for Windows 10. | |
| **Description** | Write | String | Description of the endpoint detection and response policy for Windows 10. | |
| **Assignments** | Write | MSFT_DeviceManagementConfigurationPolicyAssignments[] | Assignments of the endpoint detection and response policy for Windows 10. | |
| **SampleSharing** | Write | String | Return or set Windows Defender Advanced Threat Protection Sample Sharing configuration parameter: 0 - none, 1 - All | `0`, `1` |
| **ConfigurationType** | Write | String | Microsoft Defender for Endpoint endpoint detection and response capabilities provide advanced attack detections that are near real-time and actionable. Security analysts can prioritize alerts effectively, gain visibility into the full scope of a breach, and take response actions to remediate threats. | `AutoFromConnector`, `Onboard`, `Offboard` |
| **ConfigurationBlob** | Write | String | Set Windows Defender Advanced Threat Protection Onboarding blob and initiate onboarding to Windows Defender Advanced Threat Protection | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Intune Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

### MSFT_DeviceManagementConfigurationPolicyAssignments

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **dataType** | Write | String | The type of the target assignment. | `#microsoft.graph.groupAssignmentTarget`, `#microsoft.graph.allLicensedUsersAssignmentTarget`, `#microsoft.graph.allDevicesAssignmentTarget`, `#microsoft.graph.exclusionGroupAssignmentTarget`, `#microsoft.graph.configurationManagerCollectionAssignmentTarget` |
| **deviceAndAppManagementAssignmentFilterType** | Write | String | The type of filter of the target assignment i.e. Exclude or Include. Possible values are:none, include, exclude. | `none`, `include`, `exclude` |
| **deviceAndAppManagementAssignmentFilterId** | Write | String | The Id of the filter for the target assignment. | |
| **groupId** | Write | String | The group Id that is the target of the assignment. | |
| **collectionId** | Write | String | The collection Id that is the target of the assignment.(ConfigMgr) | |


## Description

This resource configures an Intune Endpoint Detection and Response Policy for Windows 10.

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

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneEndpointDetectionAndResponsePolicyWindows10 'myEDRPolicy'
        {
            Identity    = 'f6d1d1bc-d78f-4a5a-8f1b-0d95a60b0bc1'
            DisplayName = 'Edr Policy'
            Assignments = @()
            Description = 'My revised description'
            Ensure      = 'Present'
            Credential  = $credsGlobalAdmin
        }
    }
}
```

