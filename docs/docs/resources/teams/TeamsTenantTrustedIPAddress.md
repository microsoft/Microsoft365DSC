# TeamsTenantTrustedIPAddress

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Unique identifier for the IP address to be created. | |
| **Description** | Write | String | Provide a description of the trusted IP address to identify purpose of creating it. | |
| **MaskBits** | Write | UInt32 | This parameter determines the length of bits to mask to the subnet. | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |


## Description

As an Admin, you can use the Windows PowerShell command, New-CsTenantTrustedIPAddress to define external subnets and assign them to the tenant. You can define an unlimited number of external subnets for a tenant.

## Permissions

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

    node localhost
    {
        TeamsTenantTrustedIPAddress 'Example'
        {
            Credential           = $Credscredential;
            Ensure               = "Present";
            Identity             = "10.2.34.3";
            MaskBits             = 32;
        }
    }
}
```

