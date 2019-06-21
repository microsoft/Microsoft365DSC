# EXODkimSigningConfig

## Description

This resource configures the DomainKeys Identified Mail (DKIM) signing policy
settings for domains in a cloud-based organization.

## Parameters

Ensure

- Required: No (Defaults to 'Present')
- Description: Specifies whether the configured Dkim Signing Config
  should be Present or Absent.

GlobalAdminAccount

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
                GlobalAdminAccount     = $GlobalAdminAccount
                AdminDisplayName       = 'contoso.com DKIM Config'
                BodyCanonicalization   = 'Relaxed'
                Enabled                = $false
                HeaderCanonicalization = 'Relaxed'
                KeySize                = 1024
        }
```
