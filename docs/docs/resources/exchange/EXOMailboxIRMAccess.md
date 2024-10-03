# EXOMailboxIRMAccess

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the mailbox that you want to modify | |
| **User** | Key | String | The User parameter specifies the delegate who is blocked from reading IRM-protected messages in the mailbox. | |
| **AccessLevel** | Write | String | The AccessLevel parameter specifies what delegates can do to IRM-protected messages in the mailbox that's specified by the Identity parameter. | `Block` |
| **Ensure** | Write | String | Present ensures the resource exists, absent ensures it is removed | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

Use this resource to set MailboxIRMAccess settings

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Hygiene Management, Compliance Management, Organization Management, View-Only Organization Management

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
        EXOMailboxIRMAccess "EXOMailboxIRMAccess-qwe@testorg.onmicrosoft.com"
        {
            AccessLevel          = "Block";
            Credential           = $Credscredential;
            Ensure               = "Present";
            Identity             = "qwe@$OrganizationName";
            User                 = "admin@$OrganizationName";
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
        
    }
}
```

