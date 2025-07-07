# AADAgreement

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | The display name of the agreement. | |
| **Id** | Write | String | The unique identifier of the agreement. | |
| **IsViewingBeforeAcceptanceRequired** | Write | Boolean | Whether the user is required to view the agreement document before accepting. | |
| **IsPerDeviceAcceptanceRequired** | Write | Boolean | Whether the agreement is per device or per user. | |
| **UserReacceptRequiredFrequency** | Write | String | Duration after which the user must re-accept the terms of use. Must be in ISO 8601 duration format. | |
| **AcceptanceStatement** | Write | String | The acceptance statement included in the agreement. | |
| **FileData** | Write | String | The content of the agreement file. | |
| **FileName** | Write | String | The name of the agreement file. | |
| **Language** | Write | String | The language of the agreement file. | |
| **Ensure** | Write | String | Specify if the agreement should exist or not. | `Absent`, `Present` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

## Description

This resource configures Azure AD Terms of Use Agreements in Entra ID. Terms of Use agreements allow organizations to present information to users that they must agree to before accessing resources.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Agreement.Read.All

- **Update**

    - Agreement.ReadWrite.All

#### Application permissions

- **Read**

    - Agreement.Read.All

- **Update**

    - Agreement.ReadWrite.All

## Examples

### Example 1

This example creates a new Azure AD Terms of Use Agreement.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADAgreement 'CompanyTermsOfUse'
        {
            DisplayName                          = "Company Terms of Use"
            IsViewingBeforeAcceptanceRequired    = $true
            IsPerDeviceAcceptanceRequired        = $false
            UserReacceptRequiredFrequency        = "P90D"
            AcceptanceStatement                  = "I accept the terms of use"
            FileData                             = "<h1>Company Terms of Use</h1><p>These are the terms and conditions...</p>"
            FileName                             = "CompanyToU.html"
            Language                             = "en-US"
            Ensure                               = "Present"
            Credential                           = $Credential
        }
    }
}
```

### Example 2

This example creates a Terms of Use Agreement that requires re-acceptance every 30 days.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADAgreement 'MonthlyTermsOfUse'
        {
            DisplayName                          = "Monthly Terms of Use"
            IsViewingBeforeAcceptanceRequired    = $true
            IsPerDeviceAcceptanceRequired        = $true
            UserReacceptRequiredFrequency        = "P30D"
            AcceptanceStatement                  = "I have read and accept the terms of use"
            FileData                             = "TERMS OF USE\n\nBy accepting these terms..."
            FileName                             = "monthly_terms.txt"
            Language                             = "en-US"
            Ensure                               = "Present"
            Credential                           = $Credential
        }
    }
}
```

### Example 3

This example removes an existing Azure AD Terms of Use Agreement.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADAgreement 'CompanyTermsOfUse'
        {
            DisplayName = "Company Terms of Use"
            Ensure      = "Absent"
            Credential  = $Credential
        }
    }
}
```