# EXODkimSigningConfig

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the DKIM signing policy that you want to modify.  This should be the FQDN.  ||
| **AdminDisplayName** | Write | String | The AdminDisplayName parameter specifies a description for the policy. ||
| **BodyCanonicalization** | Write | String | The BodyCanonicalization parameter specifies the canonicalization algorithm that's used to create and verify the message body part of the DKIM signature. This value effectively controls the sensitivity of DKIM to changes to the message body in transit. Valid values are 'Simple' or 'Relaxed'.  'Relaxed' is the default. |Simple, Relaxed|
| **HeaderCanonicalization** | Write | String | The HeaderCanonicalization parameter specifies the canonicalization algorithm that's used to create and verify the message header part of the DKIM signature. This value effectively controls the sensitivity of DKIM to changes to the message headers in transit. Valid values are 'Simple' or 'Relaxed'.  'Relaxed' is the default. |Simple, Relaxed|
| **KeySize** | Write | UInt16 | The KeySize parameter specifies the size in bits of the public key that's used in the DKIM signing policy. The only available value is 1024. |1024|
| **Enabled** | Write | Boolean | The Enabled parameter specifies whether the DKIM Signing Configuration is enabled or disabled. Default is $true. ||
| **Ensure** | Write | String | Specifies if this Client Access Rule should exist. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||

# EXODkimSigningConfig

### Description

This resource configures the DomainKeys Identified Mail (DKIM) signing policy
settings for domains in a cloud-based organization.

## Parameters

Ensure

- Required: No (Defaults to 'Present')
- Description: Specifies whether the configured Dkim Signing Config
  should be Present or Absent.

Credential

- Required: Yes
- Description: Credentials of the Office 365 Global Admin

Identity

- Required: Yes
- Description: The Identity parameter specifies the Dkim Signing Config
    that you want to modify.
    This should be the FQDN of the domain for this DKIM Signing Config.

AdminDisplayName

- Required: No
- Description: The AdminDisplayName parameter specifies a description
  for the policy.

BodyCanonicalization

- Required: No
- Description: The BodyCanonicalization parameter specifies the
  canonicalization algorithm that's used to create and verify the
  message body part of the DKIM signature. This value effectively controls
  the sensitivity of DKIM to changes to the message body in transit.
  Valid values for this parameter are:
      Simple
      Relaxed (This is the default)

Enabled

- Required: No
- Description: The Enabled parameter specifies whether the
  Dkim Signing Config is enabled or disabled.
  Valid values for this parameter are $true or $false. Default is $true

HeaderCanonicalization

- Required: No
- Description: The HeaderCanonicalization parameter specifies the
  canonicalization algorithm that's used to create and verify the
  message header part of the DKIM signature.
  This value effectively controls the sensitivity of DKIM to changes
  to the message headers in transit.
  Valid values for this parameter are:
      Simple
      Relaxed (This is the default)

KeySize

- Required: No
- Description: The KeySize parameter specifies the size in bits of the
  public key that's used in the DKIM signing policy.
  The only available value is 1024.

## Example

```PowerShell
        EXODkimSigningConfig DkimSigningConfigExample {
                Ensure                 = 'Present'
                Identity               = 'contoso.com'
                Credential             = $Credential
                AdminDisplayName       = 'contoso.com DKIM Config'
                BodyCanonicalization   = 'Relaxed'
                Enabled                = $false
                HeaderCanonicalization = 'Relaxed'
                KeySize                = 1024
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
        EXODkimSigningConfig 'ConfigureDKIMSigning'
        {
            KeySize                = 1024
            Identity               = 'contoso.onmicrosoft.com'
            HeaderCanonicalization = "Relaxed"
            Enabled                = $True
            BodyCanonicalization   = "Relaxed"
            AdminDisplayName       = ""
            Ensure                 = "Present"
            Credential             = $credsGlobalAdmin
        }
    }
}
```

