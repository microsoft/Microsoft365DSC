# EXOFocusedInbox

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the mailbox that you want to modify. | |
| **FocusedInboxOn** | Write | Boolean | The FocusedInboxOn parameter enables or disables Focused Inbox for the mailbox. | |
| **FocusedInboxOnLastUpdateTime** | Write | DateTime | Gets the last updated time on focused inbox | |
| **Ensure** | Write | String | Specify if the AcceptedDomain should exist or not. | `Present` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


# EXOFocusedInbox 

## Description
Manage the Focused Inbox configuration for mailboxes in your organization.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Organization Management, Recipient Management

#### Role Groups

- Organization Management, Help Desk

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
        EXOFocusedInbox "EXOFocusedInbox-Test"
        {
            Ensure                       = "Present";
            FocusedInboxOn               = $False; # Updated Property
            FocusedInboxOnLastUpdateTime = "1/1/0001 12:00:00 AM";
            Identity                     = "admin@$TenantId";
            ApplicationId                = $ApplicationId;
            TenantId                     = $TenantId;
            CertificateThumbprint        = $CertificateThumbprint;
        }
        
    }
}
```

