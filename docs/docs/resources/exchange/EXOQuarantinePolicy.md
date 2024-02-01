# EXOQuarantinePolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the QuarantinePolicy you want to modify. | |
| **EndUserQuarantinePermissionsValue** | Write | UInt32 | The EndUserQuarantinePermissionsValue parameter specifies the end-user permissions for the quarantine policy. | |
| **ESNEnabled** | Write | Boolean | The ESNEnabled parameter specifies whether to enable quarantine notifications (formerly known as end-user spam notifications) for the policy. | |
| **MultiLanguageCustomDisclaimer** | Write | StringArray[] | The MultiLanguageCustomDisclaimer parameter specifies the custom disclaimer text to use near the bottom of quarantine notifications. | |
| **MultiLanguageSenderName** | Write | StringArray[] | The MultiLanguageSenderName parameter specifies the email sender's display name to use in quarantine notifications. | |
| **MultiLanguageSetting** | Write | StringArray[] | The MultiLanguageSetting parameter specifies the language of quarantine notifications. | |
| **OrganizationBrandingEnabled** | Write | Boolean | The OrganizationBrandingEnabled parameter enables or disables organization branding in the end-user quarantine notification messages. | |
| **Ensure** | Write | String | Specifies if this QuarantinePolicy should exist. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **EndUserSpamNotificationFrequency** | Write | String | The EndUserSpamNotificationFrequency parameter species how often quarantine notifications are sent to users. Valid values are: 04:00:00 (4 hours),1.00:00:00 (1 day),7.00:00:00 (7 days) | |
| **QuarantinePolicyType** | Write | String | The QuarantinePolicyType parameter filters the results by the specified quarantine policy type. Valid values are: QuarantinePolicy, GlobalQuarantinePolicy | |
| **EndUserSpamNotificationFrequencyInDays** | Write | String | This parameter is reserved for internal Microsoft use. | |
| **CustomDisclaimer** | Write | String | This parameter is reserved for internal Microsoft use. | |
| **EndUserSpamNotificationCustomFromAddress** | Write | String | The EndUserSpamNotificationCustomFromAddress specifies the email address of an existing internal sender to use as the sender for quarantine notifications. To set this parameter back to the default email address quarantine@messaging.microsoft.com, use the value $null. | |
| **EsnCustomSubject** | Write | StringArray[] | The EsnCustomSubject parameter specifies the text to use in the Subject field of quarantine notifications.This setting is available only in the built-in quarantine policy named DefaultGlobalTag that controls global quarantine policy settings. | |

## Description

Create or modify a EXOQuarantinePolicy in your cloud-based organization.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Transport Hygiene, Security Admin, View-Only Configuration, Security Reader

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
    $OrganizationName = $Credscredential.UserName.Split('@')[1]
    Import-DscResource -ModuleName Microsoft365DSC

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        EXOQuarantinePolicy 'ConfigureQuarantinePolicy'
        {
            EndUserQuarantinePermissionsValue = 87;
            ESNEnabled                        = $False;
            Identity                          = "$Domain\DefaultFullAccessPolicy";
            Ensure                            = "Present"
            Credential                        = $Credscredential
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
    $OrganizationName = $Credscredential.UserName.Split('@')[1]
    Import-DscResource -ModuleName Microsoft365DSC

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        EXOQuarantinePolicy 'ConfigureQuarantinePolicy'
        {
            EndUserQuarantinePermissionsValue = 87;
            ESNEnabled                        = $True; # Updated Property
            Identity                          = "$Domain\DefaultFullAccessPolicy";
            Ensure                            = "Present"
            Credential                        = $Credscredential
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
    $OrganizationName = $Credscredential.UserName.Split('@')[1]
    Import-DscResource -ModuleName Microsoft365DSC

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        EXOQuarantinePolicy 'ConfigureQuarantinePolicy'
        {
            Identity                          = "$Domain\DefaultFullAccessPolicy";
            Ensure                            = "Absent"
            Credential                        = $Credscredential
        }
    }
}
```

