# EXOManagementRoleAssignment

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies a name for the new management role assignment. The maximum length of the name is 64 characters. | |
| **Role** | Key | String | The Role parameter specifies the existing role to assign. You can use any value that uniquely identifies the role. | |
| **App** | Write | String | The App parameter specifies the service principal to assign the management role to. Specifically, the ServiceId GUID value from the output of the Get-ServicePrincipal cmdlet (for example, 6233fba6-0198-4277-892f-9275bf728bcc). | |
| **Policy** | Write | String | The Policy parameter specifies the name of the management role assignment policy to assign the management role to. | |
| **SecurityGroup** | Write | String | The SecurityGroup parameter specifies the name of the management role group or mail-enabled universal security group to assign the management role to. | |
| **User** | Write | String | The User parameter specifies the name or alias of the user to assign the management role to. | |
| **CustomRecipientWriteScope** | Write | String | The CustomRecipientWriteScope parameter specifies the existing recipient-based management scope to associate with this management role assignment. | |
| **CustomResourceScope** | Write | String | The CustomResourceScope parameter specifies the custom management scope to associate with this management role assignment. You can use any value that uniquely identifies the management scope. | |
| **ExclusiveRecipientWriteScope** | Write | String | The ExclusiveConfigWriteScope parameter specifies the exclusive configuration-based management scope to associate with the new role assignment. | |
| **RecipientAdministrativeUnitScope** | Write | String | The RecipientAdministrativeUnitScope parameter specifies the administrative unit to scope the new role assignment to. | |
| **RecipientOrganizationalUnitScope** | Write | String | The RecipientOrganizationalUnitScope parameter specifies the OU to scope the new role assignment to. If you use the RecipientOrganizationalUnitScope parameter, you can't use the CustomRecipientWriteScope or ExclusiveRecipientWriteScope parameters. | |
| **RecipientRelativeWriteScope** | Write | String | The RecipientRelativeWriteScope parameter specifies the type of restriction to apply to a recipient scope. The available types are None, Organization, MyGAL, Self, and MyDistributionGroups. The RecipientRelativeWriteScope parameter is automatically set when the CustomRecipientWriteScope or RecipientOrganizationalUnitScope parameters are used. | |
| **Ensure** | Write | String | Specify if the Management Role Assignment should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

## Description

This resource configures RBAC Management Roles Assignments in Exchange Online.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Role Management, View-Only Configuration

#### Role Groups

- Organization Management

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
        EXOManagementRoleAssignment 'AssignManagementRole'
        {
            Ensure               = "Present";
            Name                 = "MyManagementRoleAssignment";
            Role                 = "UserApplication";
            User                 = "AdeleV@$TenantId";
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
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
        EXOManagementRoleAssignment 'AssignManagementRole'
        {
            Ensure               = "Present";
            Name                 = "MyManagementRoleAssignment";
            Role                 = "UserApplication";
            User                 = "AlexW@$TenantId"; # Updated Property
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
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
        EXOManagementRoleAssignment 'AssignManagementRole'
        {
            Ensure               = "Absent";
            Name                 = "MyManagementRoleAssignment";
            Role                 = "UserApplication";
            User                 = "AlexW@$TenantId"; # Updated Property
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
```

