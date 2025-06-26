# AADTermsOfUseAcceptance

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **AgreementId** | Key | String | The identifier of the agreement. | |
| **UserId** | Key | String | The identifier of the user who accepted the agreement. | |
| **AgreementFileId** | Write | String | The identifier of the agreement file accepted by the user. | |
| **UserPrincipalName** | Write | String | UPN of the user when the acceptance was recorded. | |
| **UserDisplayName** | Write | String | Display name of the user when the acceptance was recorded. | |
| **UserEmail** | Write | String | Email of the user when the acceptance was recorded. | |
| **RecordedDateTime** | Write | String | The Timestamp when the acceptance was recorded. | |
| **ExpirationDateTime** | Write | String | The expiration date time of the acceptance. | |
| **State** | Write | String | The current state of the acceptance. | `accepted`, `declined` |
| **DeviceId** | Write | String | The unique identifier of the device used for accepting the agreement. | |
| **DeviceDisplayName** | Write | String | The display name of the device used for accepting the agreement. | |
| **DeviceOSType** | Write | String | The operating system used to accept the agreement. | |
| **DeviceOSVersion** | Write | String | The operating system version of the device used to accept the agreement. | |
| **Ensure** | Write | String | Present ensures the acceptance exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

## Description

Configures the Terms of Use Acceptance in Entra Id.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Agreement.Read.All
    - User.Read.All

- **Update**

    - Agreement.ReadWrite.All
    - User.Read.All

#### Application permissions

- **Read**

    - Agreement.Read.All
    - User.Read.All

- **Update**

    - Agreement.ReadWrite.All
    - User.Read.All

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
        AADTermsOfUseAcceptance 'TermsAcceptance'
        {
            AgreementId           = '12345678-1234-1234-1234-123456789012'
            UserId                = '87654321-4321-4321-4321-210987654321'
            State                 = 'accepted'
            Ensure                = 'Present'
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
```