# O365AdminAuditLogConfig

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Specifies the resource is a single instance, the value must be 'Yes' |Yes|
| **Ensure** | Write | String | 'Present' is the only value accepted. |Present|
| **UnifiedAuditLogIngestionEnabled** | Required | String | Determins if Unified Audit Log Ingestion is enabled |Enabled, Disabled|
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||

# O365AdminAuditLogConfig

### Description

This resource configures Security and Compliance Center Admin Audit Log.

## Parameters

Ensure

- Required: No (Defaults to 'Present')
- Description: `Present` is the only value accepted.
  Configurations using `Ensure = 'Absent'` will throw an Error!

IsSingleInstance

- Required: Yes
- Description: Single instance resource, the value must be 'Yes'

Credential

- Required: Yes
- Description: Credentials of the account to authenticate with

UnifiedAuditLogIngestionEnabled

- Required: Yes
- Description: Determins if Unified Audit Log Ingestion is Enabled or Disabled

## Example

```PowerShell
        O365AdminAuditLogConfig EnableUnifiedAuditLog {
            IsSingleInstance                = 'Yes'
            Ensure                          = 'Present'
            UnifiedAuditLogIngestionEnabled = 'Enabled'
            Credential              = $Credential
        }
```

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
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        O365AdminAuditLogConfig 'AuditLogConfig'
        {
            IsSingleInstance                = "Yes"
            UnifiedAuditLogIngestionEnabled = "Enabled"
            Ensure                          = "Present"
            Credential                      = $credsGlobalAdmin
        }
    }
}
```

