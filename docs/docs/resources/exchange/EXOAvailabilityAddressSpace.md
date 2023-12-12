# EXOAvailabilityAddressSpace

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the AvailabilityAddressSpace you want to modify. | |
| **AccessMethod** | Write | String | The AccessMethod parameter specifies how the free/busy data is accessed. Valid values are:PerUserFB, OrgWideFB, OrgWideFBBasic,InternalProxy | `PerUserFB`, `OrgWideFB`, `OrgWideFBBasic`, `InternalProxy` |
| **Credentials** | Write | String | The Credentials parameter specifies the username and password that's used to access the Availability services in the target forest. | |
| **ForestName** | Write | String | The ForestName parameter specifies the SMTP domain name of the target forest for users whose free/busy data must be retrieved. If your users are distributed among multiple SMTP domains in the target forest, run the Add-AvailabilityAddressSpace command once for each SMTP domain. | |
| **TargetAutodiscoverEpr** | Write | String | The TargetAutodiscoverEpr parameter specifies the Autodiscover URL of Exchange Web Services for the external organization. Exchange uses Autodiscover to automatically detect the correct server endpoint for external requests. | |
| **Ensure** | Write | String | Specifies if this AvailabilityAddressSpace should exist. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

Create a new AvailabilityAddressSpace in your cloud-based organization.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Federated Sharing, Mail Tips, Message Tracking

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
        EXOAvailabilityAddressSpace 'ConfigureAvailabilityAddressSpace'
        {
            Identity              = 'Contoso.com'
            AccessMethod          = 'OrgWideFB'
            ForestName            = 'example.contoso.com'
            TargetAutodiscoverEpr = 'https://contoso.com/autodiscover/autodiscover.xml'
            Ensure                = 'Present'
            Credential            = $Credscredential
        }
    }
}
```

