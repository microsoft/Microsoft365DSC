# EXOTenantAllowBlockListItems

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Action** | Key | String | The action (allow/block) to take for this list entry | `Allow`, `Block` |
| **Value** | Key | String | The value that you want to add to the Tenant Allow/Block List based on the ListType parameter value | |
| **ExpirationDate** | Write | DateTime | The expiration date of the entry in Coordinated Universal Time (UTC) | |
| **ListSubType** | Write | String | The subtype for this entry | `AdvancedDelivery`, `Tenant` |
| **ListType** | Key | String | The type of entry to add. | `FileHash`, `Sender`, `Url` |
| **Notes** | Write | String | Additional information about the object | |
| **RemoveAfter** | Write | UInt32 | Number of days after the entry is first used for it to removed | |
| **SubmissionID** | Write | String | Reserved for internal Microsoft use | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |


## Description

Use this resource to manage the Exchange Online Tenant Allow/Block List items.


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
        EXOTenantAllowBlockListItems "Example"
        {
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            TenantId              = $TenantId;
            Action                = "Block";
            Ensure                = "Present";
            ExpirationDate        = "10/11/2024 9:00:00 PM";
            ListSubType           = "Tenant";
            ListType              = "Sender";
            Notes                 = "Test block";
            SubmissionID          = "Non-Submission";
            Value                 = "example.com";
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
        EXOTenantAllowBlockListItems "Example"
        {
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            TenantId              = $TenantId;
            Action                = "Block";
            Ensure                = "Present";
            ExpirationDate        = "10/11/2024 9:00:00 PM";
            ListSubType           = "Tenant";
            ListType              = "Sender";
            Notes                 = "Test block with updated notes";
            SubmissionID          = "Non-Submission";
            Value                 = "example.com";
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
        EXOTenantAllowBlockListItems "Example"
        {
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            TenantId              = $TenantId;
            Action                = "Block";
            Ensure                = "Absent";
            ExpirationDate        = "10/11/2024 9:00:00 PM";
            ListSubType           = "Tenant";
            ListType              = "Sender";
            Notes                 = "Test block";
            SubmissionID          = "Non-Submission";
            Value                 = "example.com";
        }
    }
}
```

