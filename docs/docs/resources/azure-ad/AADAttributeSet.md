# AADAttributeSet

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Key | String | Identifier for the attribute set that is unique within a tenant. Can be up to 32 characters long and include Unicode characters. Cannot contain spaces or special characters. Cannot be changed later. Case insensitive | |
| **Description** | Write | String | Identifier for the attribute set that is unique within a tenant. Can be up to 32 characters long and include Unicode characters. Cannot contain spaces or special characters. Cannot be changed later. Case insensitive | |
| **MaxAttributesPerSet** | Write | UInt32 | Maximum number of custom security attributes that can be defined in this attribute set. Default value is null. If not specified, the administrator can add up to the maximum of 500 active attributes per tenant. Can be changed later. | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present` |
| **Credential** | Write | PSCredential | Credentials of the Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

Represents a group of related custom security attribute definitions.

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

    - CustomSecAttributeDefinition.Read.All

- **Update**

    - CustomSecAttributeDefinition.ReadWrite.All

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
        $credsCredential
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADAttributeSet "AADAttributeSetTest"
        {
            Credential           = $credsCredential;
            Description          = "Attribute set with 420 attributes";
            Ensure               = "Present";
            Id                   = "TestAttributeSet";
            MaxAttributesPerSet  = 420;
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
        $credsCredential
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADAttributeSet "AADAttributeSetTest"
        {
            Credential           = $credsCredential;
            Description          = "Attribute set with 420 attributes";
            Ensure               = "Present";
            Id                   = "TestAttributeSet";
            MaxAttributesPerSet  = 300; # Updated Property
        }
    }
}
```

