# AADB2CAuthenticationMethodsPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Only valid value is 'Yes'. | `Yes` |
| **IsEmailPasswordAuthenticationEnabled** | Write | Boolean | The tenant admin can configure local accounts using email if the email and password authentication method is enabled. | |
| **IsUserNameAuthenticationEnabled** | Write | Boolean | The tenant admin can configure local accounts using username if the username and password authentication method is enabled. | |
| **IsPhoneOneTimePasswordAuthenticationEnabled** | Write | Boolean | The tenant admin can configure local accounts using phone number if the phone number and one-time password authentication method is enabled. | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Absent`, `Present` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

B2C allows tenant admins to choose a mechanism for letting end users register via local accounts.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Policy.Read.All

- **Update**

    - Policy.ReadWrite.AuthenticationMethod

#### Application permissions

- **Read**

    - Policy.Read.All

- **Update**

    - Policy.ReadWrite.AuthenticationMethod

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
        AADB2CAuthenticationMethodsPolicy "AADB2CAuthenticationMethodsPolicy"
        {
            ApplicationId                               = $ApplicationId;
            CertificateThumbprint                       = $CertificateThumbprint;
            Ensure                                      = "Present";
            IsEmailPasswordAuthenticationEnabled        = $True;
            IsPhoneOneTimePasswordAuthenticationEnabled = $True;
            IsSingleInstance                            = "Yes";
            IsUserNameAuthenticationEnabled             = $False;
            TenantId                                    = $TenantId;
        }
    }
}
```

