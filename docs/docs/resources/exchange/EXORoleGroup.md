# EXORoleGroup

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies the name of the role. The maximum length of the name is 64 characters. | |
| **Description** | Write | String | The Description parameter specifies the description that's displayed when the role group is viewed using the Get-RoleGroup cmdlet. Enclose the description in quotation marks | |
| **Members** | Write | StringArray[] | The Members parameter specifies the mailboxes or mail-enabled USGs to add as a member of the role group. You can identify the user or group by the name, DN, or primary SMTP address value. You can specify multiple members separated by commas (Value1,Value2,...ValueN). If the value contains spaces, enclose the value in quotation marks | |
| **Roles** | Write | StringArray[] | The Roles parameter specifies the management roles to assign to the role group when it's created. If a role name contains spaces, enclose the name in quotation marks. If you want to assign more that one role, separate the role names with commas. | |
| **Ensure** | Write | String | Specify if the Role Group should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures Role Groups in Exchange Online.

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
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXORoleGroup 'ConfigureRoleGroup'
        {
            Name                      = "Contoso Role Group"
            Description               = "Address Lists Role for Exchange Administrators"
            Members                   = @("Exchange Administrator")
            Roles                     = @("Address Lists")
            Ensure                    = "Present"
            Credential                = $Credscredential
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
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXORoleGroup 'ConfigureRoleGroup'
        {
            Name                      = "Contoso Role Group"
            Description               = "Address Lists Role for Exchange Administrators. Updated" # Updated Property
            Members                   = @("Exchange Administrator")
            Roles                     = @("Address Lists")
            Ensure                    = "Present"
            Credential                = $Credscredential
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
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXORoleGroup 'ConfigureRoleGroup'
        {
            Name                      = "Contoso Role Group"
            Members                   = @("Exchange Administrator")
            Roles                     = @("Address Lists")
            Ensure                    = "Absent"
            Credential                = $Credscredential
        }
    }
}
```

