# EXOAvailabilityConfig

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **OrgWideAccount** | Key | String | Specify the OrgWideAccount for the AvailabilityConfig. ||
| **Ensure** | Write | String | Specify if the AvailabilityConfig should exist or not. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||

# EXOAvailabilityConfig

### Description

This resource configures the Availability Config in Exchange Online.

## Parameters

Ensure

- Required: No (Defaults to 'Present')
- Description: Specifies whether the configured AvailabilityConfig
  should be Present or Absent.

Credential

- Required: Yes
- Description: Credentials of the account to authenticate with

OrgWideAccount

- Required: Yes
- Description: The OrgWideAccount parameter specifies an account or security group that has permission to issue proxy Availability service requests on an organization-wide basis.

## Example

```PowerShell
EXOAvailabilityConfig ExampleAvailabilityConfig {
    Ensure              = 'Present'
    OrgWideAccount      = 'johndoe'
    Credential          = $Credential
}
```


