# DefenderDeviceAuthenticatedScanDefinition

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | Name of the scan definition. | |
| **Id** | Write | String | Unique identified for the scan definition. | |
| **IntervalInHours** | Write | UInt32 | Interval in hours to run the scan. | |
| **Target** | Write | String | Target of the scan definition. | |
| **IsActive** | Write | Boolean | Determines if the scan definition is active or not. | |
| **ScanType** | Write | String | Type of scan. | |
| **ScannerAgent** | Write | MSFT_DefenderDeviceAuthenticatedScanDefinitionScanAgent | Information about the associated scan agent. | |
| **ScanAuthenticationParams** | Write | MSFT_DefenderDeviceAuthenticatedScanDefinitionAuthenticationParams | Authentication parameters. | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Absent`, `Present` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

### MSFT_DefenderDeviceAuthenticatedScanDefinitionAuthenticationParams

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DataType** | Write | String | Odata type associated with the request. | |
| **Type** | Write | String | Type of scan. | |
| **KeyVaultUrl** | Write | String | An optional property that specifies from which KeyVault the scanner should retrieve credentials. If KeyVault is specified there's no need to specify username, password. | |
| **KeyVaultSecretName** | Write | String | An optional property that specifies KeyVault secret name from which the scanner should retrieve credentials. If KeyVault is specified there's no need to specify username, password. | |
| **Domain** | Write | String | Domain name when using WindowsAuthParams. | |
| **Username** | Write | String | Username when using WindowsAuthParams or the username when choosing SnmpAuthParams with any type other than CommunityString. | |
| **IsGMSAUser** | Write | Boolean | Must be set to true when choosing WindowsAuthParams. | |
| **CommunityString** | Write | String | Community string to use when choosing SnmpAuthParams with CommunityString. | |
| **AuthProtocol** | Write | String | Auth protocol to use with SnmpAuthParams and AuthNoPriv or AuthPriv. Possible values are MD5, SHA1. | |
| **AuthPassword** | Write | String | Auth password to use with SnmpAuthParams and AuthNoPriv or AuthPriv. | |
| **PrivProtocol** | Write | String | Priv protocol to use with SnmpAuthParams and AuthPriv. Possible values are DES, 3DES, AES. | |
| **PrivPassword** | Write | String | Priv password to use with SnmpAuthParams and AuthPriv. | |

### MSFT_DefenderDeviceAuthenticatedScanDefinitionScanAgent

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **id** | Write | String | Unique identified for the scan agent. | |
| **machineId** | Write | String | Id of the machine associated with the agent. | |
| **machineName** | Write | String | Name of the machine associated with the agent. | |


## Description

Configures device authenticated scan definitions in Defender.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - None

- **Update**

    - None

#### Application permissions

- **Read**

    - None

- **Update**

    - None

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
        DefenderDeviceAuthenticatedScanDefinition "DefenderDeviceAuthenticatedScanDefinition-MyScan"
        {
            ApplicationId            = $ApplicationId;
            CertificateThumbprint    = $CertificateThumbprint;
            Ensure                   = "Present";
            IntervalInHours          = 1;
            IsActive                 = $True;
            Name                     = "MyScan";
            ScanAuthenticationParams = MSFT_DefenderDeviceAuthenticatedScanDefinitionAuthenticationParams{
                Type = 'NoAuthNoPriv'
                DataType = '#microsoft.windowsDefenderATP.api.SnmpAuthParams'
            };
            ScannerAgent             = MSFT_DefenderDeviceAuthenticatedScanDefinitionScanAgent{
                machineId = '55c636a37ff1a21a3241437eb6ce15881xxxxxx'
                machineName = 'WIN-XXXXXXXXXX'
                id = 'c819dc6d-f9fe-4d05-8022-88a34766442d_55c636a37ff1a21a3241437eb6ce15881xxxxxxx'
            };
            ScanType                 = "Network";
            Target                   = "172.1.12.1";
            TenantId                 = $TenantId;
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
        DefenderDeviceAuthenticatedScanDefinition "DefenderDeviceAuthenticatedScanDefinition-MyScan"
        {
            ApplicationId            = $ApplicationId;
            CertificateThumbprint    = $CertificateThumbprint;
            Ensure                   = "Present";
            IntervalInHours          = 24; # Drift
            IsActive                 = $True;
            Name                     = "MyScan";
            ScanAuthenticationParams = MSFT_DefenderDeviceAuthenticatedScanDefinitionAuthenticationParams{
                Type = 'NoAuthNoPriv'
                DataType = '#microsoft.windowsDefenderATP.api.SnmpAuthParams'
            };
            ScannerAgent             = MSFT_DefenderDeviceAuthenticatedScanDefinitionScanAgent{
                machineId = '55c636a37ff1a21a3241437eb6ce15881xxxxxx'
                machineName = 'WIN-XXXXXXXXXX'
                id = 'c819dc6d-f9fe-4d05-8022-88a34766442d_55c636a37ff1a21a3241437eb6ce15881xxxxxxx'
            };
            ScanType                 = "Network";
            Target                   = "172.1.12.1";
            TenantId                 = $TenantId;
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
        DefenderDeviceAuthenticatedScanDefinition "DefenderDeviceAuthenticatedScanDefinition-MyScan"
        {
            ApplicationId            = $ApplicationId;
            CertificateThumbprint    = $CertificateThumbprint;
            Ensure                   = "Absent";
            IntervalInHours          = 1;
            IsActive                 = $True;
            Name                     = "MyScan";
            ScanAuthenticationParams = MSFT_DefenderDeviceAuthenticatedScanDefinitionAuthenticationParams{
                Type = 'NoAuthNoPriv'
                DataType = '#microsoft.windowsDefenderATP.api.SnmpAuthParams'
            };
            ScannerAgent             = MSFT_DefenderDeviceAuthenticatedScanDefinitionScanAgent{
                machineId = '55c636a37ff1a21a3241437eb6ce15881xxxxxx'
                machineName = 'WIN-XXXXXXXXXX'
                id = 'c819dc6d-f9fe-4d05-8022-88a34766442d_55c636a37ff1a21a3241437eb6ce15881xxxxxxx'
            };
            ScanType                 = "Network";
            Target                   = "172.1.12.1";
            TenantId                 = $TenantId;
        }
    }
}
```

