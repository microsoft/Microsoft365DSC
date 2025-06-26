# AADAgreement

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | Display name of the agreement. The display name is used for internal tracking of the agreement but isn't shown to end users who view the agreement. | |
| **Id** | Write | String | The unique identifier of the agreement. | |
| **IsPerDeviceAcceptanceRequired** | Write | Boolean | Indicates whether end users are required to accept this agreement on every device that they access it from. | |
| **IsViewingBeforeAcceptanceRequired** | Write | Boolean | Indicates whether the user has to expand the agreement before accepting. | |
| **TermsExpiration** | Write | MSFT_MicrosoftGraphTermsExpiration | Expiration schedule and frequency of agreement for all users. | |
| **UserReacceptRequiredFrequency** | Write | String | The duration after which the user must reaccept the terms of use. The value is represented in ISO 8601 format for durations. | |
| **Files** | Write | MSFT_MicrosoftGraphAgreementFileLocalization[] | Files containing the terms of use. This property is being deprecated. Use file property instead. | |
| **Ensure** | Write | String | Specify if the Azure AD Agreement should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials for the Microsoft Graph delegated permissions. | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

### MSFT_MicrosoftGraphTermsExpiration

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Duration** | Write | String | The duration after which the terms expire, after its first acceptance. The value is represented in ISO 8601 format for durations. | |
| **StartDateTime** | Write | String | The date time when the agreement expires for all users. The timestamp type represents date and time information using ISO 8601 format and is always in UTC time. | |
| **Frequency** | Write | String | The frequency at which the terms will expire, after its first acceptance. The value is represented in ISO 8601 format for durations. | |

### MSFT_MicrosoftGraphAgreementFileLocalization

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **CreatedDateTime** | Write | String | The date time when the agreement file was created. The timestamp type represents date and time information using ISO 8601 format and is always in UTC time. | |
| **DisplayName** | Write | String | Localized display name of the policy file of an agreement. | |
| **FileData** | Write | String | Data that represents the terms of use PDF document. | |
| **FileName** | Write | String | Name of the agreement file. | |
| **Language** | Write | String | The language of the agreement file in the format languagecode2-country/regioncode2. | |
| **IsDefault** | Write | Boolean | Indicates whether the agreement file is the default file if none of the culture matches the client preference. | |
| **IsMajorVersion** | Write | Boolean | Indicates whether the agreement file is a major version update. | |
| **Id** | Write | String | Read-only. The unique identifier of the entity. | |


## Description

This resource configures Azure Active Directory Terms of Use Agreements. Terms of Use agreements are legal documents that users must accept before accessing applications or resources in your Azure AD tenant.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Agreement.Read.All

- **Update**

    - Agreement.Read.All, Agreement.ReadWrite.All

#### Application permissions

- **Read**

    - Agreement.Read.All

- **Update**

    - Agreement.Read.All, Agreement.ReadWrite.All

## Examples

### Example 1

This example creates a new Terms of Use agreement.

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
        AADAgreement 'CompanyTermsOfUse'
        {
            DisplayName                          = "Company Terms of Use"
            IsPerDeviceAcceptanceRequired        = $false
            IsViewingBeforeAcceptanceRequired    = $true
            UserReacceptRequiredFrequency        = "P90D"
            Files                                = @(
                MSFT_MicrosoftGraphAgreementFileLocalization {
                    DisplayName = "Company Terms of Use"
                    FileName = "terms-of-use.pdf"
                    Language = "en-US"
                    IsDefault = $true
                    IsMajorVersion = $true
                    FileData = "Base64EncodedPDFContent"
                }
            )
            Ensure                               = "Present"
            ApplicationId                        = $ApplicationId
            TenantId                             = $TenantId
            CertificateThumbprint                = $CertificateThumbprint
        }
    }
}
```

### Example 2

This example updates an existing Terms of Use agreement.

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
        AADAgreement 'CompanyTermsOfUse'
        {
            DisplayName                          = "Company Terms of Use"
            IsPerDeviceAcceptanceRequired        = $true # Updated Property
            IsViewingBeforeAcceptanceRequired    = $true
            UserReacceptRequiredFrequency        = "P180D" # Updated Property
            TermsExpiration                      = MSFT_MicrosoftGraphTermsExpiration {
                StartDateTime = "2024-12-31T23:59:59Z"
                Frequency     = "P365D"
            }
            Files                                = @(
                MSFT_MicrosoftGraphAgreementFileLocalization {
                    DisplayName = "Company Terms of Use v2"
                    FileName = "terms-of-use-v2.pdf"
                    Language = "en-US"
                    IsDefault = $true
                    IsMajorVersion = $true
                    FileData = "Base64EncodedPDFContentV2"
                }
            )
            Ensure                               = "Present"
            ApplicationId                        = $ApplicationId
            TenantId                             = $TenantId
            CertificateThumbprint                = $CertificateThumbprint
        }
    }
}
```

### Example 3

This example removes a Terms of Use agreement.

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
        AADAgreement 'CompanyTermsOfUse'
        {
            DisplayName                          = "Company Terms of Use"
            Ensure                               = "Absent"
            ApplicationId                        = $ApplicationId
            TenantId                             = $TenantId  
            CertificateThumbprint                = $CertificateThumbprint
        }
    }
}
```