# AADAuthenticationMethodPolicyX509

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **AuthenticationModeConfiguration** | Write | MSFT_MicrosoftGraphx509CertificateAuthenticationModeConfiguration | Defines strong authentication configurations. This configuration includes the default authentication mode and the different rules for strong authentication bindings. | |
| **CertificateUserBindings** | Write | MSFT_MicrosoftGraphx509CertificateUserBinding[] | Defines fields in the X.509 certificate that map to attributes of the Azure AD user object in order to bind the certificate to the user. The priority of the object determines the order in which the binding is carried out. The first binding that matches will be used and the rest ignored. | |
| **ExcludeTargets** | Write | MSFT_AADAuthenticationMethodPolicyX509ExcludeTarget[] | Displayname of the groups of users that are excluded from a policy. | |
| **IncludeTargets** | Write | MSFT_AADAuthenticationMethodPolicyX509IncludeTarget[] | Displayname of the groups of users that are included from a policy. | |
| **State** | Write | String | The state of the policy. Possible values are: enabled, disabled. | `enabled`, `disabled` |
| **Id** | Key | String | The unique identifier for an entity. Read-only. | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

### MSFT_MicrosoftGraphX509CertificateAuthenticationModeConfiguration

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Rules** | Write | MSFT_MicrosoftGraphX509CertificateRule[] | Rules are configured in addition to the authentication mode to bind a specific x509CertificateRuleType to an x509CertificateAuthenticationMode. For example, bind the policyOID with identifier 1.32.132.343 to x509CertificateMultiFactor authentication mode. | |
| **X509CertificateAuthenticationDefaultMode** | Write | String | The type of strong authentication mode. The possible values are: x509CertificateSingleFactor, x509CertificateMultiFactor, unknownFutureValue. | `x509CertificateSingleFactor`, `x509CertificateMultiFactor`, `unknownFutureValue` |

### MSFT_MicrosoftGraphX509CertificateRule

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identifier** | Write | String | The identifier of the X.509 certificate. Required. | |
| **X509CertificateAuthenticationMode** | Write | String | The type of strong authentication mode. The possible values are: x509CertificateSingleFactor, x509CertificateMultiFactor, unknownFutureValue. Required. | `x509CertificateSingleFactor`, `x509CertificateMultiFactor`, `unknownFutureValue` |
| **X509CertificateRuleType** | Write | String | The type of the X.509 certificate mode configuration rule. The possible values are: issuerSubject, policyOID, unknownFutureValue. Required. | `issuerSubject`, `policyOID`, `unknownFutureValue` |

### MSFT_MicrosoftGraphX509CertificateUserBinding

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Priority** | Write | UInt32 | The priority of the binding. Azure AD uses the binding with the highest priority. This value must be a non-negative integer and unique in the collection of objects in the certificateUserBindings property of an x509CertificateAuthenticationMethodConfiguration object. Required | |
| **UserProperty** | Write | String | Defines the Azure AD user property of the user object to use for the binding. The possible values are: userPrincipalName, onPremisesUserPrincipalName, email. Required. | |
| **X509CertificateField** | Write | String | The field on the X.509 certificate to use for the binding. The possible values are: PrincipalName, RFC822Name. | |

### MSFT_AADAuthenticationMethodPolicyX509ExcludeTarget

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Write | String | The object identifier of an Azure AD group. | |
| **TargetType** | Write | String | The type of the authentication method target. Possible values are: group and unknownFutureValue. | `group`, `unknownFutureValue` |

### MSFT_AADAuthenticationMethodPolicyX509IncludeTarget

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Write | String | The object identifier of an Azure AD group. | |
| **isRegistrationRequired** | Write | Boolean | Determines if the user is enforced to register the authentication method. | |
| **TargetType** | Write | String | The type of the authentication method target. Possible values are: group and unknownFutureValue. | `group`, `unknownFutureValue` |


## Description

Azure AD Authentication Method Policy X509

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Policy.ReadWrite.AuthenticationMethod, Policy.Read.All

- **Update**

    - Policy.ReadWrite.AuthenticationMethod, Policy.Read.All

#### Application permissions

- **Read**

    - Policy.ReadWrite.AuthenticationMethod, Policy.Read.All

- **Update**

    - Policy.ReadWrite.AuthenticationMethod, Policy.Read.All

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsCredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
        AADAuthenticationMethodPolicyX509 "AADAuthenticationMethodPolicyX509-X509Certificate"
        {
            AuthenticationModeConfiguration = MSFT_MicrosoftGraphx509CertificateAuthenticationModeConfiguration{
                X509CertificateAuthenticationDefaultMode = 'x509CertificateSingleFactor'
            };
            CertificateUserBindings         = @(
                MSFT_MicrosoftGraphx509CertificateUserBinding{
                    Priority = 1
                    UserProperty = 'userPrincipalName'
                    X509CertificateField = 'PrincipalName'
                }
                MSFT_MicrosoftGraphx509CertificateUserBinding{
                    Priority = 2
                    UserProperty = 'userPrincipalName'
                    X509CertificateField = 'RFC822Name'
                }
                MSFT_MicrosoftGraphx509CertificateUserBinding{
                    Priority = 3
                    UserProperty = 'certificateUserIds'
                    X509CertificateField = 'SubjectKeyIdentifier'
                }
            );
            Credential                      = $Credscredential;
            Ensure                          = "Present";
            ExcludeTargets                  = @(
                MSFT_AADAuthenticationMethodPolicyX509ExcludeTarget{
                    Id = 'DSCGroup'
                    TargetType = 'group'
                }
            );
            Id                              = "X509Certificate";
            IncludeTargets                  = @(
                MSFT_AADAuthenticationMethodPolicyX509IncludeTarget{
                    Id = 'Finance Team'
                    TargetType = 'group'
                }
            );
            State                           = "enabled";
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
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsCredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
        AADAuthenticationMethodPolicyX509 "AADAuthenticationMethodPolicyX509-X509Certificate"
        {
            AuthenticationModeConfiguration = MSFT_MicrosoftGraphx509CertificateAuthenticationModeConfiguration{
                X509CertificateAuthenticationDefaultMode = 'x509CertificateSingleFactor'
            };
            CertificateUserBindings         = @(
                MSFT_MicrosoftGraphx509CertificateUserBinding{
                    Priority = 1
                    UserProperty = 'userPrincipalName'
                    X509CertificateField = 'PrincipalName'
                }
                MSFT_MicrosoftGraphx509CertificateUserBinding{
                    Priority = 2
                    UserProperty = 'userPrincipalName'
                    X509CertificateField = 'RFC822Name'
                }
                MSFT_MicrosoftGraphx509CertificateUserBinding{
                    Priority = 3
                    UserProperty = 'certificateUserIds'
                    X509CertificateField = 'SubjectKeyIdentifier'
                }
            );
            Credential                      = $Credscredential;
            Ensure                          = "Present";
            ExcludeTargets                  = @(
                MSFT_AADAuthenticationMethodPolicyX509ExcludeTarget{
                    Id = 'DSCGroup'
                    TargetType = 'group'
                }
            );
            Id                              = "X509Certificate";
            IncludeTargets                  = @(
                MSFT_AADAuthenticationMethodPolicyX509IncludeTarget{
                    Id = 'Finance Team'
                    TargetType = 'group'
                }
            );
            State                           = "enabled";
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
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsCredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
        AADAuthenticationMethodPolicyX509 "AADAuthenticationMethodPolicyX509-X509Certificate"
        {
            Credential                      = $credsCredential;
            Ensure                          = "Absent";
            Id                              = "X509Certificate";
        }
    }
}
```

