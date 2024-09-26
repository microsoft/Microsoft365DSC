# AADPasswordRuleSettings

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Only valid value is 'Yes'. | `Yes` |
| **LockoutThreshold** | Write | UInt32 | The number of failed login attempts before the first lockout period begins. | |
| **LockoutDurationInSeconds** | Write | UInt32 | The duration in seconds of the initial lockout period. | |
| **EnableBannedPasswordCheck** | Write | Boolean | Boolean indicating if the banned password check for tenant specific banned password list is turned on or not. | |
| **BannedPasswordList** | Write | StringArray[] | A list of banned words in passwords. | |
| **BannedPasswordCheckOnPremisesMode** | Write | String | How should we enforce password policy check in on-premises system. | |
| **EnableBannedPasswordCheckOnPremises** | Write | Boolean | Boolean indicating if the banned password check is turned on or not for on-premises system. | |
| **Ensure** | Write | String | Specify if the Azure AD Password Rule Settings should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials for the Microsoft Graph delegated permissions. | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

## Description

This resource configures the Azure Active Directory Password Rule Settings.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Directory.Read.All, Group.Read.All

- **Update**

    - Directory.Read.All, Directory.ReadWrite.All

#### Application permissions

- **Read**

    - Directory.Read.All

- **Update**

    - Directory.Read.All, Directory.ReadWrite.All

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
        AADPasswordRuleSettings 'GeneralPasswordRuleSettings'
        {
            IsSingleInstance                    = "Yes"
            LockoutThreshold                    = 6
            LockoutDurationInSeconds            = 30
            BannedPasswordCheckOnPremisesMode   = 'Audit'
            EnableBannedPasswordCheckOnPremises = $false
            EnableBannedPasswordCheck           = $false
            BannedPasswordList                  = $null
            Ensure                              = "Present"
            ApplicationId                       = $ApplicationId
            TenantId                            = $TenantId
            CertificateThumbprint               = $CertificateThumbprint
        }
    }
}
```

