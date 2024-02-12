# EXOManagementRole

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies the name of the role. The maximum length of the name is 64 characters. | |
| **Parent** | Key | String | The Parent parameter specifies the identity of the role to copy. Mandatory for management role creation/update or when Ensure=Present. Non-mandatory for Ensure=Absent | |
| **Description** | Write | String | The Description parameter specifies the description that's displayed when the management role is viewed using the Get-ManagementRole cmdlet. | |
| **Ensure** | Write | String | Specify if the Management Role should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures RBAC Management Roles in Exchange Online.

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
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        EXOManagementRole 'ConfigureManagementRole'
        {
            Name                 = "MyDisplayName"
            Description          = ""
            Parent               = "$Domain\MyProfileInformation"
            Ensure               = "Present"
            Credential           = $Credscredential
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
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        EXOManagementRole 'ConfigureManagementRole'
        {
            Name                 = "MyDisplayName"
            Description          = "Updated Description" # Updated Property
            Parent               = "$Domain\MyProfileInformation"
            Ensure               = "Present"
            Credential           = $Credscredential
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
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOManagementRole 'ConfigureManagementRole'
        {
            Name                 = "MyDisplayName"
            Description          = "Updated Description" # Updated Property
            Parent               = "contoso.onmicrosoft.com\MyProfileInformation"
            Ensure               = "Absent"
            Credential           = $Credscredential
        }
    }
}
```

