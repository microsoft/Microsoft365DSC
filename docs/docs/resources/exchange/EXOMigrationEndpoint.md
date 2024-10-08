# EXOMigrationEndpoint

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Identity of the migration endpoint. | |
| **AcceptUntrustedCertificates** | Write | Boolean | Specifies whether to accept untrusted certificates. | |
| **AppID** | Write | String | The Application ID used for authentication. | |
| **AppSecretKeyVaultUrl** | Write | String | The URL of the Key Vault that stores the application secret. | |
| **Authentication** | Write | String | The authentication method for the migration endpoint. | |
| **EndpointType** | Write | String | The type of migration endpoint. | `IMAP` |
| **ExchangeServer** | Write | String | The Exchange Server address for the migration endpoint. | |
| **MailboxPermission** | Write | String | The mailbox permission for the migration endpoint. | |
| **MaxConcurrentIncrementalSyncs** | Write | String | The maximum number of concurrent incremental syncs. | |
| **MaxConcurrentMigrations** | Write | String | The maximum number of concurrent migrations. | |
| **NspiServer** | Write | String | The NSPI server for the migration endpoint. | |
| **Port** | Write | String | The port number for the migration endpoint. | |
| **RemoteServer** | Write | String | The remote server for the migration endpoint. | |
| **RemoteTenant** | Write | String | The remote tenant for the migration endpoint. | |
| **RpcProxyServer** | Write | String | The RPC proxy server for the migration endpoint. | |
| **Security** | Write | String | The security level for the migration endpoint. | `None`, `Tls`, `Ssl` |
| **SourceMailboxLegacyDN** | Write | String | The legacy distinguished name of the source mailbox. | |
| **UseAutoDiscover** | Write | Boolean | Specifies whether to use AutoDiscover. | |
| **Ensure** | Write | String | Specifies if the migration endpoint should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

Use this resource to create and monitor migration endpoints in exchange.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Recipient Policies, View-Only Recipients, Mail Recipient Creation, View-Only Configuration, Mail Recipients

#### Role Groups

- Organization Management

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
        EXOMigrationEndpoint "EXOMigrationEndpoint-testIMAP"
        {
            AcceptUntrustedCertificates   = $True;
            Authentication                = "Basic";
            ApplicationId                 = $ApplicationId
            TenantId                      = $TenantId
            CertificateThumbprint         = $CertificateThumbprint
            EndpointType                  = "IMAP";
            Ensure                        = "Present";
            Identity                      = "testIMAP";
            MailboxPermission             = "Admin";
            MaxConcurrentIncrementalSyncs = "10";
            MaxConcurrentMigrations       = "20";
            Port                          = 993;
            RemoteServer                  = "gmail.com";
            Security                      = "Tls";
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
        EXOMigrationEndpoint "EXOMigrationEndpoint-testIMAP"
        {
            AcceptUntrustedCertificates   = $True;
            Authentication                = "Basic";
            ApplicationId                 = $ApplicationId
            TenantId                      = $TenantId
            CertificateThumbprint         = $CertificateThumbprint
            EndpointType                  = "IMAP";
            Ensure                        = "Present";
            Identity                      = "testIMAP";
            MailboxPermission             = "Admin";
            MaxConcurrentIncrementalSyncs = "10";
            MaxConcurrentMigrations       = "20";
            Port                          = 993;
            RemoteServer                  = "gmail.com";
            # value for security updated from Tls to None
            Security                      = "None";
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
        EXOMigrationEndpoint "EXOMigrationEndpoint-testIMAP"
        {
            AcceptUntrustedCertificates   = $True;
            Authentication                = "Basic";
            ApplicationId                 = $ApplicationId
            TenantId                      = $TenantId
            CertificateThumbprint         = $CertificateThumbprint
            EndpointType                  = "IMAP";
            Ensure                        = "Absent";
            Identity                      = "testIMAP";
            MailboxPermission             = "Admin";
            MaxConcurrentIncrementalSyncs = "10";
            MaxConcurrentMigrations       = "20";
            Port                          = 993;
            RemoteServer                  = "gmail.com";
            Security                      = "None";
        }
    }
}
```

