# IntuneDeviceAndAppManagementAssignmentFilter

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | DisplayName of the Assignment Filter. ||
| **Identity** | Write | String | Key of the Assignment Filter. ||
| **Description** | Write | String | Description of the Assignment Filter. ||
| **Platform** | Write | String | Platform type of the devices on which the Assignment Filter will be applicable. |android, androidForWork, iOS, macOS, windowsPhone81, windows81AndLater, windows10AndLater, androidWorkProfile, unknown|
| **Rule** | Write | String | Rule definition of the Assignment Filter. ||
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Intune Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com ||
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. ||


# IntuneDeviceAndAppManagementAssignmentFilter

### Description

This resource represents the properties of the Intune Assignment Filter.
For more information: https://docs.microsoft.com/en-us/graph/api/resources/intune-policyset-deviceandappmanagementassignmentfilter?view=graph-rest-beta


## Examples

### Example 1

This example creates a new Device and App Management Assignment Filter.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $intuneAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneDeviceAndAppManagementAssignmentFilter 'AssignmentFilter'
        {
            Credential           = $intuneAdmin;
            Description          = "This is a new Filter";
            DisplayName          = "Test Device Filter";
            Ensure               = "Present";
            Platform             = "windows10AndLater";
            Rule                 = "(device.manufacturer -ne `"Microsoft Corporation`")";
        }
    }
}
```

