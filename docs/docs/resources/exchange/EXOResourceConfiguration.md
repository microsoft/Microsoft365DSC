﻿# EXOResourceConfiguration

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Write | String | The Identity parameter specifies the Perimeter Configuration policy that you want to modify. ||
| **ResourcePropertySchema** | Write | StringArray[] | The ResourcePropertySchema parameter specifies the custom resource property that you want to make available to room or equipment mailboxes. This parameter uses the syntax Room/<Text> or Equipment/<Text> where the <Text> value doesn't contain spaces. For example, Room/Whiteboard or Equipment/Van. ||
| **Ensure** | Write | String | Specifies if this Outbound connector should exist. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||

# EXOResourceConfiguration

### Description

Modify the resource Configuration policy in your cloud-based organization.

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
        EXOResourceConfiguration 'ConfigureResourceConfiguration'
        {
            Identity               = "Global"
            ResourcePropertySchema = @(@{Add = "Room/TV"; Remove = "Equipment/Laptop"})
            Ensure                 = "Present"
            Credential             = $credsGlobalAdmin
        }
    }
}
```

