# EXOAuthenticationPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the authentication policy you want to view or modify. | |
| **AllowBasicAuthActiveSync** | Write | Boolean | The AllowBasicAuthActiveSync switch specifies whether to allow Basic authentication with Exchange Active Sync. | |
| **AllowBasicAuthAutodiscover** | Write | Boolean | The AllowBasicAuthAutodiscover switch specifies whether to allow Basic authentication with Autodiscover. | |
| **AllowBasicAuthImap** | Write | Boolean | The AllowBasicAuthImap switch specifies whether to allow Basic authentication with IMAP. | |
| **AllowBasicAuthMapi** | Write | Boolean | The AllowBasicAuthMapi switch specifies whether to allow Basic authentication with MAPI. | |
| **AllowBasicAuthOfflineAddressBook** | Write | Boolean | The AllowBasicAuthOfflineAddressBook switch specifies whether to allow Basic authentication with Offline Address Books. | |
| **AllowBasicAuthOutlookService** | Write | Boolean | The AllowBasicAuthOutlookService switch specifies whether to allow Basic authentication with the Outlook service. | |
| **AllowBasicAuthPop** | Write | Boolean | The AllowBasicAuthPop switch specifies whether to allow Basic authentication with POP. | |
| **AllowBasicAuthPowershell** | Write | Boolean | The AllowBasicAuthPowerShell switch specifies whether to allow Basic authentication with PowerShell. | |
| **AllowBasicAuthReportingWebServices** | Write | Boolean | The AllowBasicAuthReporting Web Services switch specifies whether to allow Basic authentication with reporting web services. | |
| **AllowBasicAuthRpc** | Write | Boolean | The AllowBasicAuthRpc switch specifies whether to allow Basic authentication with RPC. | |
| **AllowBasicAuthSmtp** | Write | Boolean | The AllowBasicAuthSmtp switch specifies whether to allow Basic authentication with SMTP. | |
| **AllowBasicAuthWebServices** | Write | Boolean | The AllowBasicAuthWebServices switch specifies whether to allow Basic authentication with Exchange Web Services (EWS). | |
| **Ensure** | Write | String | Specify if the authentication Policy should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures Authentication Policies in Exchange Online.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- View-Only Configuration, Organization Configuration, Recipient Policies

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
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOAuthenticationPolicy 'ConfigureAuthenticationPolicy'
        {
            Identity                            = "Block Basic Auth"
            AllowBasicAuthActiveSync            = $False
            AllowBasicAuthAutodiscover          = $False
            AllowBasicAuthImap                  = $False
            AllowBasicAuthMapi                  = $False
            AllowBasicAuthOfflineAddressBook    = $False
            AllowBasicAuthOutlookService        = $False
            AllowBasicAuthPop                   = $False
            AllowBasicAuthPowerShell            = $False
            AllowBasicAuthReportingWebServices  = $False
            AllowBasicAuthRpc                   = $False
            AllowBasicAuthSmtp                  = $False
            AllowBasicAuthWebServices           = $False
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
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOAuthenticationPolicy 'ConfigureAuthenticationPolicy'
        {
            Identity                            = "Block Basic Auth"
            AllowBasicAuthActiveSync            = $False
            AllowBasicAuthAutodiscover          = $False
            AllowBasicAuthImap                  = $False
            AllowBasicAuthMapi                  = $True # Updated Property
            AllowBasicAuthOfflineAddressBook    = $False
            AllowBasicAuthOutlookService        = $False
            AllowBasicAuthPop                   = $False
            AllowBasicAuthPowerShell            = $False
            AllowBasicAuthReportingWebServices  = $False
            AllowBasicAuthRpc                   = $False
            AllowBasicAuthSmtp                  = $False
            AllowBasicAuthWebServices           = $False
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
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOAuthenticationPolicy 'ConfigureAuthenticationPolicy'
        {
            Identity                            = "Block Basic Auth"
            AllowBasicAuthActiveSync            = $False
            AllowBasicAuthAutodiscover          = $False
            AllowBasicAuthImap                  = $False
            AllowBasicAuthMapi                  = $True # Updated Property
            AllowBasicAuthOfflineAddressBook    = $False
            AllowBasicAuthOutlookService        = $False
            AllowBasicAuthPop                   = $False
            AllowBasicAuthPowerShell            = $False
            AllowBasicAuthReportingWebServices  = $False
            AllowBasicAuthRpc                   = $False
            AllowBasicAuthSmtp                  = $False
            AllowBasicAuthWebServices           = $False
            Ensure                              = "Present"
            Credential                          = $Credscredential
        }
    }
}
```

