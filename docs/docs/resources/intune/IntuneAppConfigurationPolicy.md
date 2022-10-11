﻿# IntuneAppConfigurationPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **dataType** | Write | String | The type of the target assignment. |#microsoft.graph.groupAssignmentTarget, #microsoft.graph.allLicensedUsersAssignmentTarget, #microsoft.graph.allDevicesAssignmentTarget, #microsoft.graph.exclusionGroupAssignmentTarget, #microsoft.graph.configurationManagerCollectionAssignmentTarget|
| **deviceAndAppManagementAssignmentFilterType** | Write | String | The type of filter of the target assignment i.e. Exclude or Include. Possible values are:none, include, exclude. |none, include, exclude|
| **deviceAndAppManagementAssignmentFilterId** | Write | String | The Id of the filter for the target assignment. ||
| **groupId** | Write | String | The group Id that is the target of the assignment. ||
| **collectionId** | Write | String | The collection Id that is the target of the assignment.(ConfigMgr) ||
| **name** | Write | String | Name of the custom setting. ||
| **value** | Write | String | Value of the custom setting. ||
| **DisplayName** | Key | String | Display name of the app configuration policy. ||
| **Description** | Write | String | Description of the app configuration policy. ||
| **Assignments** | Write | InstanceArray[] | Assignments of the Intune Policy. ||
| **CustomSettings** | Write | InstanceArray[] | Custom settings for the app cnfiguration policy. ||
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Intune Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. ||


# IntuneAppConfigurationPolicy

### Description

This resource configures the Intune App configuration policies.

## Examples

### Example 1

This example creates a new App Configuration Policy.

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
        IntuneAppConfigurationPolicy 'AddAppConfigPolicy'
        {
            DisplayName = 'ContosoNew'
            Description = 'New Contoso Policy'
            Ensure      = 'Present'
            Credential  = $credsGlobalAdmin
        }
    }
}
```

### Example 2

This example removes an existing App Configuration Policy.

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
        IntuneAppConfigurationPolicy 'RemoveAppConfigPolicy'
        {
            DisplayName = 'ContosoOld'
            Description = 'Old Contoso Policy'
            Ensure      = 'Absent'
            Credential  = $credsGlobalAdmin
        }
    }
}
```

