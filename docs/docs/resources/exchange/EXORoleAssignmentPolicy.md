# EXORoleAssignmentPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies the new name of the assignment policy. The maximum length is 64 characters. ||
| **Description** | Write | String | The Description parameter specifies the description that's displayed when the role assignment policy is viewed using the Get-RoleAssignmentPolicy cmdlet. ||
| **IsDefault** | Write | Boolean | The IsDefault switch makes the assignment policy the default assignment policy. ||
| **Roles** | Write | StringArray[] | The Roles parameter specifies the management roles to assign to the role assignment policy when it's created. ||
| **Ensure** | Write | String | Specify if the Role Assignment Policy should exist or not. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||

# EXORoleAssignmentPolicy

### Description

This resource configures Role Assignment Policies in Exchange Online.


