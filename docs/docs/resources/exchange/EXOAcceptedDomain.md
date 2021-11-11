# EXOAcceptedDomain

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Specify the Fully Qualified Domain Name for the AcceptedDomain. ||
| **Ensure** | Write | String | Specify if the AcceptedDomain should exist or not. |Present, Absent|
| **DomainType** | Write | String | The type of AcceptedDomain.  Currently the EXOAcceptedDomain DSC Resource accepts a value of 'Authoritative' and 'InternalRelay'. |Authoritative, InternalRelay|
| **MatchSubDomains** | Write | Boolean | The MatchSubDomains parameter must be false on Authoritative domains. The default value is false. ||
| **OutboundOnly** | Write | Boolean | The OutboundOnly must be false on Authoritative domains. The default value is false. ||
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||

# EXOAcceptedDomain

### Description

This resource configures the Accepted Email Domains in Exchange Online.

## Parameters

Ensure

- Required: No (Defaults to 'Present')
- Description: `Present` is the only value accepted.
  Configurations using `Ensure = 'Absent'` will throw an Error!

DomainType

- Required: No (Defaults to 'Authoritative')
- Description: The DomainType parameter specifies the accepted domain type.

Credential

- Required: Yes
- Description: Credentials of a Microsoft 365 Admin

Identity

- Required: Yes
- Description: Domain name of the AcceptedDomain

MatchSubDomains

- Required: No
- Description: MatchSubDomains enables mail to be sent by and received
  from users on any subdomain of this accepted domain.
  This value must be false on Authoritative domains.
  The EXOAcceptedDomain DSC Resource only accepts a value of $false
  The default value is false.

OutboundOnly

- Required: No
- Description: OutboundOnly specifies whether this accepted domain is an
  internal relay domain for the on-premises
  deployment for organizations that have coexistence with a cloud-based organization.
  This value must be false on Authoritative domains.
  The EXOAcceptedDomain DSC Resource only accepts a value of $false
  The default value is false.

## Example

```PowerShell
EXOAcceptedDomain ExampleEmailDomain {
    Ensure              = 'Present'
    Identity            = 'example.contoso.com'
    Credential          = $Credential
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
        EXOAcceptedDomain 'O365DSCDomain'
        {
            Identity   = 'contoso.com'
            DomainType = "Authoritative"
            Ensure     = "Present"
            Credential = $credsGlobalAdmin
        }
    }
}
```

