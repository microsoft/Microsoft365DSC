# EXOSweepRule

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies the name of the Sweep rule. If the value contains spaces, enclose the value in quotation marks. | |
| **Provider** | Write | String | The Provider parameter specifies the provider for the Sweep rule. If the value contains spaces, enclose the value in quotation marks. For Sweep rules that you create in Outlook on the web, the default value is Exchange16. | |
| **DestinationFolder** | Write | String | The DestinationFolder parameter specifies an action for the Sweep rule that moves messages to the specified folder. | |
| **Enabled** | Write | Boolean | The Enabled parameter specifies whether the Sweep rule is enabled or disabled. | |
| **KeepForDays** | Write | UInt32 | The KeepForDays parameter specifies an action for the Sweep rule that specifies the number of days to keep messages that match the conditions of the rule. After the number of days have passed, the messages are moved to the location that's specified by the DestinationFolder parameter (by default, the Deleted Items folder). You can't use this parameter with the KeepLatest parameter and the Sweep rule must contain a KeepForDays or KeepLatest parameter value. | |
| **KeepLatest** | Write | UInt32 | The KeepLatest parameter specifies an action for the Sweep rule that specifies the number of messages to keep that match the conditions of the rule. After the number of messages is exceeded, the oldest messages are moved to the location that's specified by the DestinationFolder parameter (by default, the Deleted Items folder). You can't use this parameter with the KeepForDays parameter and the Sweep rule must contain a KeepForDays or KeepLatest parameter value. | |
| **Mailbox** | Write | String | The Mailbox parameter specifies the mailbox where you want to create the Sweep rule. You can use any value that uniquely identifies the mailbox. | |
| **SenderName** | Write | String | The SenderName parameter specifies a condition for the Sweep rule that looks for the specified sender in messages. For internal senders, you can use any value that uniquely identifies the sender. | |
| **SourceFolder** | Write | String | The SourceFolder parameter specifies a condition for the Sweep rule that looks for messages in the specified folder. | |
| **SystemCategory** | Write | String | The SystemCategory parameter specifies a condition for the sweep rule that looks for messages with the specified system category. System categories are available to all mailboxes in the organization. | |
| **Ensure** | Write | String | Specify if this rule should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

Use this resource to create Sweep rules in mailboxes. Sweep rules run at regular intervals to help keep your Inbox clean.

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
        EXOSweepRule 'MyRule'
        {
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            DestinationFolder     = "Test2:\Deleted Items";
            Enabled               = $True;
            Ensure                = "Present";
            KeepLatest            = 11;
            Mailbox               = "Test2";
            Name                  = "From Michelle";
            Provider              = "Exchange16";
            SenderName            = "michelle@fabrikam.com";
            SourceFolder          = "Test2:\Inbox";
            TenantId              = $TenantId;
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
        EXOSweepRule 'MyRule'
        {
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            DestinationFolder     = "Test2:\Deleted Items";
            Enabled               = $True;
            Ensure                = "Present";
            KeepLatest            = 13; # Drift
            Mailbox               = "Test2";
            Name                  = "From Michelle";
            Provider              = "Exchange16";
            SenderName            = "michelle@fabrikam.com";
            SourceFolder          = "Test2:\Inbox";
            TenantId              = $TenantId;
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
        EXOSweepRule 'MyRule'
        {
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            Enabled               = $True;
            Ensure                = "Absent";
            Mailbox               = "Test2";
            Name                  = "From Michelle";
            TenantId              = $TenantId;
        }
    }
}
```

