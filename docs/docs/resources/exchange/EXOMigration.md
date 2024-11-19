# EXOMigration

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter identifies the name of the current migration batch. | |
| **NotificationEmails** | Write | StringArray[] | The NotificationEmails parameter specifies one or more email addresses that migration status reports are sent to. | |
| **CompleteAfter** | Write | String | The CompleteAfter parameter specifies a delay before the batch is completed. | |
| **AddUsers** | Write | Boolean | The AddUsers parameter controls whether additional users can be dynamically added to an existing migration batch after it has been created. | |
| **BadItemLimit** | Write | String | The BadItemLimit parameter specifies the maximum number of bad items that are allowed before the migration request fails. | |
| **LargeItemLimit** | Write | String | The LargeItemLimit parameter specifies the maximum number of large items that are allowed before the migration request fails. | |
| **MoveOptions** | Write | StringArray[] | The MoveOptions parameter specifies the stages of the migration that you want to skip for debugging purposes. | |
| **SkipMerging** | Write | StringArray[] | The SkipMerging parameter specifies the stages of the migration that you want to skip for debugging purposes. | |
| **StartAfter** | Write | String | The StartAfter parameter specifies a delay before the data migration for the users within the batch is started. | |
| **Update** | Write | Boolean | The Update switch sets the Update flag on the migration batch. | |
| **Status** | Write | String | The Status parameter returns information about migration users that have the specified status state. | |
| **MigrationUsers** | Write | StringArray[] | Migration Users states the list of the users/mailboxes that are part of a migration batch that are to be migrated. | |
| **SourceEndpoint** | Write | String | The SourceEndpoint parameter specifies the migration endpoint to use for the source of the migration batch. | |
| **TargetDeliveryDomain** | Write | String | The TargetDeliveryDomain parameter specifies the FQDN of the external email address created in the source forest for the mail-enabled user when the migration batch is complete. | |
| **Ensure** | Write | String | Specifies if the migration endpoint should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

# EXOMigrationBatch

## Description

Use the MigrationBatch cmdlets to create and update a migration request for a batch of users.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- User Options, Data Loss Prevention, Transport Rules, View-Only Configuration, Mail Recipients

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
        EXOMigration "EXOMigration-test"
        {
            AddUsers             = $False;
            BadItemLimit         = "";
            CompleteAfter        = "12/31/9999 11:59:59 PM";
            Ensure               = "Present";
            Identity             = "test";
            LargeItemLimit       = "";
            MoveOptions          = @();
            NotificationEmails   = @("eac_admin@bellred.org");
            SkipMerging          = @();
            Status               = "Completed";
            Update               = $False;
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
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
        EXOMigration "EXOMigration-test"
        {
            AddUsers             = $True;  #Updated Property
            BadItemLimit         = "";
            CompleteAfter        = "12/31/9999 11:59:59 PM";
            Ensure               = "Present";
            Identity             = "test";
            LargeItemLimit       = "";
            MoveOptions          = @();
            NotificationEmails   = @("eac_admin@bellred.org");
            SkipMerging          = @();
            Status               = "Completed";
            Update               = $False;
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
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
        EXOMigration "EXOMigration-test"
        {
            AddUsers             = $False;
            BadItemLimit         = "";
            CompleteAfter        = "12/31/9999 11:59:59 PM";
            Ensure               = "Absent";
            Identity             = "test";
            LargeItemLimit       = "";
            MoveOptions          = @();
            NotificationEmails   = @("eac_admin@bellred.org");
            SkipMerging          = @();
            Status               = "Completed";
            Update               = $False;
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
```

