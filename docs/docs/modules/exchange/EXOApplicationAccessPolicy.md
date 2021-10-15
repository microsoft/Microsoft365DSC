# EXOApplicationAccessPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the application access policy that you want to modify. ||
| **AccessRight** | Write | String | The AccessRight parameter specifies the permission that you want to assign in the application access policy. |RestrictAccess, DenyAccess|
| **AppID** | Write | StringArray[] | The AppID parameter specifies the GUID of the apps to include in the policy. ||
| **PolicyScopeGroupId** | Write | String | The PolicyScopeGroupID parameter specifies the recipient to define in the policy. You can use any value that uniquely identifies the recipient. ||
| **Description** | Write | String | The Description parameter specifies a description for the policy. ||
| **Ensure** | Write | String | Specify if the Application Access Policy should exist or not. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||

# EXOApplicationAccessPolicy

### Description

This resource configures Applications Access Policies in Exchange Online.


