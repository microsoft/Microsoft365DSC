# EXOPerimeterConfiguration

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Write | String | The Identity parameter specifies the Perimeter Configuration policy that you want to modify. ||
| **GatewayIPAddresses** | Write | StringArray[] | Use the GatewayIPAddresses parameter to create or modify a list of gateway server IP addresses to add to IP safelists. ||
| **Ensure** | Write | String | Specifies if this Outbound connector should exist. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||

# EXOPerimeterConfiguration

### Description

Modify the perimeter Configuration policy in your cloud-based organization.

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
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOPerimeterConfiguration 'ConfigurePerimeterConfiguration'
        {
            Identity             = "Global"
            GatewayIPAddresses   = "123.0.0.1"
            Ensure               = "Present"
            Credential           = $credsGlobalAdmin
        }
    }
}
```

