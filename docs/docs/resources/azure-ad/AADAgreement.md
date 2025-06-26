# AADAgreement

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Key | String | The Id of the Terms of Use Agreement. | |
| **DisplayName** | Write | String | The display name of the Terms of Use Agreement. | |
| **IsPerDeviceAcceptanceRequired** | Write | Boolean | Indicates whether this terms of use is available for use in multiple languages. | |
| **IsViewingBeforeAcceptanceRequired** | Write | Boolean | Indicates whether the user has to accept this agreement on every device that they are accessing it from. | |
| **TermsOfUseUrl** | Write | String | Content of the terms of use agreement. | |
| **UserReacceptRequiredFrequency** | Write | String | Indicates the frequency with which the terms of use document versions expire, after which it must be re-accepted. The value is represented in ISO 8601 format for durations. | |
| **Ensure** | Write | String | Specify if this Terms of Use Agreement should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

This resource manages Terms of Use Agreements in Azure Active Directory.

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

This example is used to create a new Terms of Use Agreement.

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
        AADAgreement 'MyTermsOfUse'
        {
            Id                               = '12345-12345-12345-12345-12345'
            DisplayName                      = 'Company Terms of Service'
            IsPerDeviceAcceptanceRequired    = $true
            IsViewingBeforeAcceptanceRequired = $true
            UserReacceptRequiredFrequency    = 'P30D'
            Ensure                           = 'Present'
            ApplicationId                    = $ApplicationId
            TenantId                         = $TenantId
            CertificateThumbprint            = $CertificateThumbprint
        }
    }
}
```

### Example 2

This example is used to update an existing Terms of Use Agreement.

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
        AADAgreement 'MyTermsOfUse'
        {
            Id                               = '12345-12345-12345-12345-12345'
            DisplayName                      = 'Company Terms of Service - Updated'
            IsPerDeviceAcceptanceRequired    = $false
            IsViewingBeforeAcceptanceRequired = $false
            UserReacceptRequiredFrequency    = 'P90D'
            Ensure                           = 'Present'
            ApplicationId                    = $ApplicationId
            TenantId                         = $TenantId
            CertificateThumbprint            = $CertificateThumbprint
        }
    }
}
```

### Example 3

This example is used to remove an existing Terms of Use Agreement.

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
        AADAgreement 'MyTermsOfUse'
        {
            Id                               = '12345-12345-12345-12345-12345'
            DisplayName                      = 'Company Terms of Service'
            Ensure                           = 'Absent'
            ApplicationId                    = $ApplicationId
            TenantId                         = $TenantId
            CertificateThumbprint            = $CertificateThumbprint
        }
    }
}
```