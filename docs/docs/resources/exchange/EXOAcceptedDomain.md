﻿# EXOAcceptedDomain

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Specify the Fully Qualified Domain Name for the AcceptedDomain. ||
| **Ensure** | Write | String | Specify if the AcceptedDomain should exist or not. |Present, Absent|
| **DomainType** | Write | String | The type of AcceptedDomain.  Currently the EXOAcceptedDomain DSC Resource accepts a value of 'Authoritative' and 'InternalRelay'. |Authoritative, InternalRelay|
| **MatchSubDomains** | Write | Boolean | The MatchSubDomains parameter must be false on Authoritative domains. The default value is false. ||
| **OutboundOnly** | Write | Boolean | OutboundOnly can only be enabled if the DomainType parameter is set to Authoritative or InternalRelay. The default value is false. ||
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||

# EXOAcceptedDomain

### Description

This resource configures the Accepted Email Domains in Exchange Online.

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

