# EXOClientAccessRule

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the client access rule that you want to modify. | |
| **Action** | Required | String | The Action parameter specifies the action for the client access rule. Valid values for this parameter are AllowAccess and DenyAccess. | `AllowAccess`, `DenyAccess` |
| **AnyOfAuthenticationTypes** | Write | StringArray[] | The AnyOfAuthenticationTypes parameter specifies a condition for the client access rule that is based on the client's authentication type. Valid values for this parameter are AdfsAuthentication, BasicAuthentication, CertificateBasedAuthentication, NonBasicAuthentication, OAuthAuthentication. | `AdfsAuthentication`, `BasicAuthentication`, `CertificateBasedAuthentication`, `NonBasicAuthentication`, `OAuthAuthentication` |
| **AnyOfClientIPAddressesOrRanges** | Write | StringArray[] | The AnyOfClientIPAddressesOrRanges parameter specifies a condition for the client access rule that is based on the client's IP address. Valid values for this parameter are: A single IP address, an IP address range, a CIDR IP. | |
| **AnyOfProtocols** | Write | StringArray[] | The AnyOfProtocols parameter specifies a condition for the client access rule that is based on the client's protocol. Valid values for this parameter are ExchangeActiveSync,ExchangeAdminCenter,ExchangeWebServices,IMAP4,OfflineAddressBook,OutlookAnywhere,OutlookWebApp,POP3,PowerShellWebServices,RemotePowerShell,REST,UniversalOutlook. | `ExchangeActiveSync`, `ExchangeAdminCenter`, `ExchangeWebServices`, `IMAP4`, `OfflineAddressBook`, `OutlookAnywhere`, `OutlookWebApp`, `POP3`, `PowerShellWebServices`, `RemotePowerShell`, `REST`, `UniversalOutlook` |
| **Enabled** | Write | Boolean | The Enabled parameter specifies whether the client access rule is enabled or disabled. Default is $true. | |
| **ExceptAnyOfAuthenticationTypes** | Write | StringArray[] | The ExceptAnyOfAuthenticationTypes parameter specifies an exception for the client access rule that is based on the client's authentication type. Valid values for this parameter are AdfsAuthentication, BasicAuthentication, CertificateBasedAuthentication, NonBasicAuthentication, OAuthAuthentication. | `AdfsAuthentication`, `BasicAuthentication`, `CertificateBasedAuthentication`, `NonBasicAuthentication`, `OAuthAuthentication` |
| **ExceptAnyOfClientIPAddressesOrRanges** | Write | StringArray[] | The ExceptAnyOfClientIPAddressesOrRanges parameter specifies an exception for the client access rule that is based on the client's IP address. Valid values for this parameter are: A single IP address, an IP address range, a CIDR IP. | |
| **ExceptAnyOfProtocols** | Write | StringArray[] | The ExceptAnyOfProtocols parameter specifies an exception for the client access rule that is based on the client's protocol. Valid values for this parameter are ExchangeActiveSync,ExchangeAdminCenter,ExchangeWebServices,IMAP4,OfflineAddressBook,OutlookAnywhere,OutlookWebApp,POP3,PowerShellWebServices,RemotePowerShell,REST,UniversalOutlook. | `ExchangeActiveSync`, `ExchangeAdminCenter`, `ExchangeWebServices`, `IMAP4`, `OfflineAddressBook`, `OutlookAnywhere`, `OutlookWebApp`, `POP3`, `PowerShellWebServices`, `RemotePowerShell`, `REST`, `UniversalOutlook` |
| **ExceptUsernameMatchesAnyOfPatterns** | Write | StringArray[] | The ExceptUsernameMatchesAnyOfPatterns parameter specifies an exception for the client access rule that is based on the user's account name. | |
| **Priority** | Write | UInt32 | The Priority parameter specifies a priority value for the client access rule. A lower integer value indicates a higher priority, and a higher priority rule is evaluated before a lower priority rule. The default value is 1. | |
| **RuleScope** | Write | String | The RuleScope parameter specifies the scope of the client access rule. Valid values are All and Users | `All`, `Users` |
| **UserRecipientFilter** | Write | String | The UserRecipientFilter parameter specifies a condition for the client access rule that uses OPath filter syntax to identify the user. | |
| **UsernameMatchesAnyOfPatterns** | Write | StringArray[] | The UsernameMatchesAnyOfPatterns parameter specifies a condition for the client access rule that is based on the user's account name. | |
| **Ensure** | Write | String | Specifies if this Client Access Rule should exist. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures Client Access sRules.
Client Access Rules help you control access to your organization based
on the properties of the connection.

Note: Not all authentication types are supported for all protocols.

The supported authentication types per protocol can be found here:
https://docs.microsoft.com/en-us/exchange/clients-and-mobile-in-exchange-online/client-access-rules/client-access-rules

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
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOClientAccessRule 'ConfigureClientAccessRule'
        {
            Action                               = "AllowAccess"
            UserRecipientFilter                  = $null
            ExceptAnyOfAuthenticationTypes       = @()
            ExceptUsernameMatchesAnyOfPatterns   = @()
            AnyOfAuthenticationTypes             = @()
            UsernameMatchesAnyOfPatterns         = @()
            Identity                             = "Always Allow Remote PowerShell"
            Priority                             = 1
            AnyOfProtocols                       = @("RemotePowerShell")
            Enabled                              = $True
            ExceptAnyOfProtocols                 = @()
            ExceptAnyOfClientIPAddressesOrRanges = @()
            AnyOfClientIPAddressesOrRanges       = @()
            Ensure                               = "Present"
            Credential                           = $GlobalAdmin
        }
    }
}
```

