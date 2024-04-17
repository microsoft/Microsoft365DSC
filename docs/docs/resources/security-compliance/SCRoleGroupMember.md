# SCRoleGroupMember

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies the name of the role. The maximum length of the name is 64 characters. | |
| **Description** | Write | String | The Description parameter specifies the description that's displayed when the role group is viewed using the Get-RoleGroup cmdlet. Enclose the description in quotation marks | |
| **Members** | Write | StringArray[] | The Members parameter specifies the mailboxes or mail-enabled USGs to add as a member of the role group. You can identify the user or group by the name, DN, or primary SMTP address value. You can specify multiple members separated by commas (Value1,Value2,...ValueN). If the value contains spaces, enclose the value in quotation marks | |
| **Ensure** | Write | String | Specify if the Role Group Members should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |

## Description

This resource manages Role Group members in Security Compliance Center.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - None

- **Update**

    - None

#### Application permissions

- **Read**

    - None

- **Update**

    - None

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        SCRoleGroupMember 'InformationProtectionAnalysts'
        {
            Description = 'Access and manage DLP alerts and activity explorer. View-only access to DLP policies, sensitivity labels and their policies, and all classifier types.'
            Ensure      = 'Present'
            Members     = @('user 1', 'User 2', 'Group1')
            Name        = 'InformationProtectionAnalysts'
            TenantId    = $OrganizationName
            Credential  = $Credscredential
        }
    }
}
```

