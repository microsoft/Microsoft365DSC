# EXOEmailTenantSettings

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Only valid value is 'Yes'. | `Yes` |
| **Identity** | Write | String | Identity which indicates the organization name. | |
| **EnablePriorityAccountProtection** | Write | Boolean | Specifies whether priority account protection is enabled. | |
| **IsValid** | Write | Boolean | Specifies whether the migration configuration is valid. | |
| **ObjectState** | Write | String | Specifies the state of the object. | |
| **Name** | Write | String | Specifies the name of the object. | |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

EXOEmailTenantSettings

## Description

This resource allows users to manage email tenant settings.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Organization Management, Security Reader

#### Role Groups

- Organization Management, Security Administrator

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
        EXOEmailTenantSettings "EXOEmailTenantSettings-Test"
        {
            IsSingleInstance                         = "Yes"
            EnablePriorityAccountProtection          = $True;
            Identity                                 = $TenantId;
            IsValid                                  = $True;
            ObjectState                              = "Unchanged"
            Name                                     = "Default"
            TenantId                                 = $TenantId
            CertificateThumbprint                    = $CertificateThumbprint
            ApplicationId                            = $ApplicationId
        }
    }
}
```

