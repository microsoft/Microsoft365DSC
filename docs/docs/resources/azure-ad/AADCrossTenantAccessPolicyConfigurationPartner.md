# AADCrossTenantAccessPolicyConfigurationPartner

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **PartnerTenantId** | Key | String | The tenant identifier for the partner Azure Active Directory (Azure AD) organization. | |
| **B2BCollaborationInbound** | Write | MSFT_AADCrossTenantAccessPolicyB2BSetting | Defines your partner-specific configuration for users from other organizations accessing your resources via Azure AD B2B collaboration. | |
| **B2BCollaborationOutbound** | Write | MSFT_AADCrossTenantAccessPolicyB2BSetting | Defines your partner-specific configuration for users in your organization going outbound to access resources in another organization via Azure AD B2B collaboration. | |
| **B2BDirectConnectInbound** | Write | MSFT_AADCrossTenantAccessPolicyB2BSetting | Defines your partner-specific configuration for users from other organizations accessing your resources via Azure AD B2B direct connect. | |
| **B2BDirectConnectOutbound** | Write | MSFT_AADCrossTenantAccessPolicyB2BSetting | Defines your partner-specific configuration for users in your organization going outbound to access resources in another organization via Azure AD B2B direct connect. | |
| **AutomaticUserConsentSettings** | Write | MSFT_AADCrossTenantAccessPolicyAutomaticUserConsentSettings | Determines the partner-specific configuration for accepting trust claims from other tenant invitations. | |
| **InboundTrust** | Write | MSFT_AADCrossTenantAccessPolicyInboundTrust | Determines the partner-specific configuration for trusting other Conditional Access claims from external Azure AD organizations. | |
| **Ensure** | Write | String | Specify if the policy should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

### MSFT_AADCrossTenantAccessPolicyTarget

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Target** | Write | String | The unique identifier of the user, group, or application; one of the following keywords: AllUsers and AllApplications; or for targets that are applications, you may use reserved values. | |
| **TargetType** | Write | String | The type of resource that you want to target. The possible values are: user, group, application, unknownFutureValue. | `user`, `group`, `application`, `unknownFutureValue` |

### MSFT_AADCrossTenantAccessPolicyTargetConfiguration

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **AccessType** | Write | String | Defines whether access is allowed or blocked. The possible values are: allowed, blocked, unknownFutureValue. | `allowed`, `blocked`, `unknownFutureValue` |
| **Targets** | Write | MSFT_AADCrossTenantAccessPolicyTarget[] | Specifies whether to target users, groups, or applications with this rule. | |

### MSFT_AADCrossTenantAccessPolicyB2BSetting

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Applications** | Write | MSFT_AADCrossTenantAccessPolicyTargetConfiguration | The list of applications targeted with your cross-tenant access policy. | |
| **UsersAndGroups** | Write | MSFT_AADCrossTenantAccessPolicyTargetConfiguration | The list of users and groups targeted with your cross-tenant access policy. | |

### MSFT_AADCrossTenantAccessPolicyAutomaticUserConsentSettings

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **InboundAllowed** | Write | Boolean | Specifies whether you want to automatically trust Inbound invitations. | |
| **OutboundAllowed** | Write | Boolean | Specifies whether you want to automatically trust Outbound invitations. | |

### MSFT_AADCrossTenantAccessPolicyInboundTrust

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsCompliantDeviceAccepted** | Write | Boolean | Specifies whether compliant devices from external Azure AD organizations are trusted. | |
| **IsHybridAzureADJoinedDeviceAccepted** | Write | Boolean | Specifies whether hybrid Azure AD joined devices from external Azure AD organizations are trusted. | |
| **IsMfaAccepted** | Write | Boolean | Specifies whether MFA from external Azure AD organizations is trusted. | |


## Description

This resource manages Azure AD Cross Tenant Access Policies Configuration Partner.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Policy.Read.All

- **Update**

    - Policy.ReadWrite.CrossTenantAccess

#### Application permissions

- **Read**

    - Policy.Read.All

- **Update**

    - Policy.ReadWrite.CrossTenantAccess

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
        $credsCredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
        AADCrossTenantAccessPolicyConfigurationPartner "AADCrossTenantAccessPolicyConfigurationPartner"
        {
            PartnerTenantId              = "e7a80bcf-696e-40ca-8775-a7f85fbb3ebc"; # O365DSC.onmicrosoft.com
            AutomaticUserConsentSettings = MSFT_AADCrossTenantAccessPolicyAutomaticUserConsentSettings {
                InboundAllowed           = $True
                OutboundAllowed          = $True
            };
            B2BCollaborationOutbound     = MSFT_AADCrossTenantAccessPolicyB2BSetting {
                Applications = MSFT_AADCrossTenantAccessPolicyTargetConfiguration{
                    AccessType = 'allowed'
                    Targets    = @(
                        MSFT_AADCrossTenantAccessPolicyTarget{
                            Target     = 'AllApplications'
                            TargetType = 'application'
                        }
                    )
                }
                UsersAndGroups = MSFT_AADCrossTenantAccessPolicyTargetConfiguration{
                    AccessType = 'allowed'
                    Targets    = @(
                        MSFT_AADCrossTenantAccessPolicyTarget{
                            Target     = '68bafe64-f86b-4c4e-b33b-9d3eaa11544b' # Office 365
                            TargetType = 'user'
                        }
                    )
                }
            };
            ApplicationId                = 'c6957111-b1a6-479c-a15c-73e01ceb3b99'
            CertificateThumbprint        = 'ACD01315A4EBA42CD2E18EEE443AA280CC0BAB8B'
            TenantId                     = 'M365x35070558.onmicrosoft.com'
            Ensure                       = "Present";
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
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsCredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
        AADCrossTenantAccessPolicyConfigurationPartner "AADCrossTenantAccessPolicyConfigurationPartner"
        {
            PartnerTenantId              = "e7a80bcf-696e-40ca-8775-a7f85fbb3ebc"; # O365DSC.onmicrosoft.com
            AutomaticUserConsentSettings = MSFT_AADCrossTenantAccessPolicyAutomaticUserConsentSettings {
                InboundAllowed           = $False # Updated Property
                OutboundAllowed          = $True
            };
            B2BCollaborationOutbound     = MSFT_AADCrossTenantAccessPolicyB2BSetting {
                Applications = MSFT_AADCrossTenantAccessPolicyTargetConfiguration{
                    AccessType = 'allowed'
                    Targets    = @(
                        MSFT_AADCrossTenantAccessPolicyTarget{
                            Target     = 'AllApplications'
                            TargetType = 'application'
                        }
                    )
                }
                UsersAndGroups = MSFT_AADCrossTenantAccessPolicyTargetConfiguration{
                    AccessType = 'allowed'
                    Targets    = @(
                        MSFT_AADCrossTenantAccessPolicyTarget{
                            Target     = '68bafe64-f86b-4c4e-b33b-9d3eaa11544b' # Office 365
                            TargetType = 'user'
                        }
                    )
                }
            };
            ApplicationId                = 'c6957111-b1a6-479c-a15c-73e01ceb3b99'
            CertificateThumbprint        = 'ACD01315A4EBA42CD2E18EEE443AA280CC0BAB8B'
            TenantId                     = 'M365x35070558.onmicrosoft.com'
            Ensure                       = "Present";
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
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsCredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
        AADCrossTenantAccessPolicyConfigurationPartner "AADCrossTenantAccessPolicyConfigurationPartner"
        {
            Credential               = $Credscredential;
            Ensure                   = "Absent";
            PartnerTenantId          = "12345-12345-12345-12345-12345";
        }
    }
}
```

