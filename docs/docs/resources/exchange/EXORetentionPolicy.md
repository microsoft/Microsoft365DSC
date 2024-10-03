# EXORetentionPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the name, distinguished name (DN), or GUID of the retention policy. | |
| **IsDefault** | Write | Boolean | The IsDefault switch specifies that this retention policy is the default retention policy. You don't need to specify a value with this switch. | |
| **IsDefaultArbitrationMailbox** | Write | Boolean | The IsDefaultArbitrationMailbox switch configures this policy as the default retention policy for arbitration mailboxes in your Exchange Online organization. You don't need to specify a value with this switch. | |
| **Name** | Write | String | The Name parameter specifies a unique name for the retention policy. | |
| **RetentionId** | Write | String | The RetentionId parameter specifies the identity of the retention policy to make sure mailboxes moved between two Exchange organizations continue to have the same retention policy applied to them. | |
| **RetentionPolicyTagLinks** | Write | StringArray[] | The RetentionPolicyTagLinks parameter specifies the identity of retention policy tags to associate with the retention policy. Mailboxes that get a retention policy applied have retention tags linked with that retention policy. | |
| **Ensure** | Write | String | Specifies if this report submission rule should exist. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

# EXORetentionPolicy  
  
## Description  
  
Use the New-RetentionPolicy cmdlet to create a retention policy and the Set-RetentionPolicy cmdlet to change the properties of an existing retention policy.  

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
        EXORetentionPolicy "EXORetentionPolicy-Test"
        {
            Name                        = "Test Retention Policy";
            Identity                    = "Test Retention Policy";
            IsDefault                   = $False;
            IsDefaultArbitrationMailbox = $False;
            RetentionPolicyTagLinks     = @("6 Month Delete","Personal 5 year move to archive","1 Month Delete","1 Week Delete","Personal never move to archive","Personal 1 year move to archive","Default 2 year move to archive","Deleted Items","Junk Email","Recoverable Items 14 days move to archive","Never Delete");
            Ensure                      = "Present";
            ApplicationId               = $ApplicationId;
            TenantId                    = $TenantId;
            CertificateThumbprint       = $CertificateThumbprint;
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
        EXORetentionPolicy "EXORetentionPolicy-Test"
        {
            Name                        = "Test Retention Policy";
            Identity                    = "Test Retention Policy";
            IsDefault                   = $False;
            IsDefaultArbitrationMailbox = $False;
            RetentionPolicyTagLinks     = @("Personal 5 year move to archive","1 Month Delete","1 Week Delete","Personal never move to archive","Personal 1 year move to archive","Default 2 year move to archive","Deleted Items","Junk Email","Recoverable Items 14 days move to archive","Never Delete"); # drifted property
            Ensure                      = "Present";
            ApplicationId               = $ApplicationId;
            TenantId                    = $TenantId;
            CertificateThumbprint       = $CertificateThumbprint;
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
        EXORetentionPolicy "EXORetentionPolicy-Test"
        {
            Name                        = "Test Retention Policy";
            Identity                    = "Test Retention Policy";
            IsDefault                   = $False;
            IsDefaultArbitrationMailbox = $False;
            RetentionPolicyTagLinks     = @("6 Month Delete","Personal 5 year move to archive","1 Month Delete","1 Week Delete","Personal never move to archive","Personal 1 year move to archive","Default 2 year move to archive","Deleted Items","Junk Email","Recoverable Items 14 days move to archive","Never Delete");
            Ensure                      = "Absent";
            ApplicationId               = $ApplicationId;
            TenantId                    = $TenantId;
            CertificateThumbprint       = $CertificateThumbprint;
        }
        
    }
}
```

