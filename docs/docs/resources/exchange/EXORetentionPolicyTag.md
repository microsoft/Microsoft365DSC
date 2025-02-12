# EXORetentionPolicyTag

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the name of the tag. | |
| **Comment** | Write | String | The Description parameter specifies a comment for the tag. | |
| **AgeLimitForRetention** | Write | String | The AgeLimitForRetention parameter specifies the age at which retention is enforced on an item. The age limit corresponds to the number of days from the date the item was delivered, or the date an item was created if it wasn't delivered. If this parameter isn't present and the RetentionEnabled parameter is set to $true, an error is returned. | |
| **MessageClass** | Write | String | The MessageClass parameter specifies the message type to which the tag applies. If not specified, the default value is set to *. | |
| **MustDisplayCommentEnabled** | Write | Boolean | The MustDisplayCommentEnabled parameter specifies whether the comment can be hidden. The default value is $true. | |
| **RetentionAction** | Write | String | The RetentionAction parameter specifies the action for the retention policy. | |
| **RetentionEnabled** | Write | Boolean | The RetentionEnabled parameter specifies whether the tag is enabled. When set to $false, the tag is disabled, and no retention action is taken on messages that have the tag applied. | |
| **Type** | Write | String | The Type parameter specifies the type of retention tag being created. | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Absent`, `Present` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

Manage Exchange Online retention policy tags.

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
        EXORetentionPolicyTag "RetentionPolicyTag"
        {
            ApplicationId             = $ApplicationId;
            CertificateThumbprint     = $CertificateThumbprint;
            Comment                   = "This is my tag";
            Ensure                    = "Present";
            Identity                  = "MyTag";
            MessageClass              = "*";
            MustDisplayCommentEnabled = $False;
            RetentionAction           = "MoveToArchive";
            RetentionEnabled          = $False;
            TenantId                  = $TenantId;
            Type                      = "Personal";
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
        EXORetentionPolicyTag "RetentionPolicyTag"
        {
            ApplicationId             = $ApplicationId;
            CertificateThumbprint     = $CertificateThumbprint;
            Comment                   = "This is my modified tag"; #Drift
            Ensure                    = "Present";
            Identity                  = "MyTag";
            MessageClass              = "*";
            MustDisplayCommentEnabled = $False;
            RetentionAction           = "MoveToArchive";
            RetentionEnabled          = $False;
            TenantId                  = $TenantId;
            Type                      = "Personal";
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
        EXORetentionPolicyTag "RetentionPolicyTag"
        {
            ApplicationId             = $ApplicationId;
            CertificateThumbprint     = $CertificateThumbprint;
            Comment                   = "This is my tag";
            Ensure                    = "Absent";
            Identity                  = "MyTag";
            MessageClass              = "*";
            MustDisplayCommentEnabled = $False;
            RetentionAction           = "MoveToArchive";
            RetentionEnabled          = $False;
            TenantId                  = $TenantId;
            Type                      = "Personal";
        }
    }
}
```

