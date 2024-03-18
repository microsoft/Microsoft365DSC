# EXOPartnerApplication

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies a new name for the partner application. | |
| **ApplicationIdentifier** | Write | String | The ApplicationIdentifier parameter specifies a unique application identifier for the partner application that uses an authorization server. | |
| **AcceptSecurityIdentifierInformation** | Write | Boolean | The AcceptSecurityIdentifierInformation parameter specifies whether Exchange should accept security identifiers (SIDs) from another trusted Active Directory forest for the partner application. | |
| **AccountType** | Write | String | The AccountType parameter specifies the type of Microsoft account that's required for the partner application. | `OrganizationalAccount`, `ConsumerAccount` |
| **Enabled** | Write | Boolean | The Enabled parameter specifies whether the partner application is enabled. | |
| **LinkedAccount** | Write | String | The LinkedAccount parameter specifies a linked Active Directory user account for the application. | |
| **Ensure** | Write | String | Specify if the Partner Application should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures Partner Applications in Exchange Online.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Organization Client Access, View-Only Configuration

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
        EXOPartnerApplication 'ConfigurePartnerApplication'
        {
            Name                                = "HRApp"
            ApplicationIdentifier               = "00000006-0000-0dd1-ac00-000000000000"
            AcceptSecurityIdentifierInformation = $true
            Enabled                             = $True
            Ensure                              = "Present"
            Credential                          = $Credscredential
        }
    }
}
```

### Example 2

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
        EXOPartnerApplication 'ConfigurePartnerApplication'
        {
            Name                                = "HRApp"
            ApplicationIdentifier               = "00000006-0000-0dd1-ac00-000000000000"
            AcceptSecurityIdentifierInformation = $False # Updated Property
            Enabled                             = $True
            Ensure                              = "Present"
            Credential                          = $Credscredential
        }
    }
}
```

### Example 3

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
        EXOPartnerApplication 'ConfigurePartnerApplication'
        {
            Name                                = "HRApp"
            ApplicationIdentifier               = "00000006-0000-0dd1-ac00-000000000000"
            Ensure                              = "Absent"
            Credential                          = $Credscredential
        }
    }
}
```

