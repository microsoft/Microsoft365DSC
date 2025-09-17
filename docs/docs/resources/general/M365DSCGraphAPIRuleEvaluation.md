# M365DSCGraphAPIRuleEvaluation

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **APIUrl** | Key | String | Url of the REST Endpoint. | |
| **RuleDefinition** | Key | String | Specify the rules to evaluate. | |
| **InstancesProperty** | Write | String | Name of the parent property of the response, which contains the instances. Default is 'value'. | |
| **InstanceIdentifier** | Write | String | For logging purposes only. This represents the unique identifier of instances returned by the Graph API call. | |
| **RuleName** | Write | String | Custom display name for the rule. This will show up in the logs on drift detection. | |
| **AfterRuleCountQuery** | Write | String | Query to check how many instances exist, using PowerShell format | |
| **Credential** | Write | PSCredential | Credentials of the Azure Active Directory Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

## Description

This resource monitors Graph API endpoints against the defined rules.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - None

- **Update**

    - None

#### Application permissions

- **Read**

    - None

- **Update**

    - None

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
        $CredsCredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        M365DSCGraphAPIRuleEvaluation 'AllowAnonymousUsersToJoinMeetingAllPolicies'
        {
            APIUrl              = 'https://graph.microsoft.com/beta/serviceprincipals'
            InstancesProperty   = 'value'
            InstanceIdentifier  = 'displayName'
            RuleDefinition      = "`$_.appCategory -eq 'mdm'"
            AfterRuleCountQuery = '-eq 4'
            Credential          = $CredsCredential
        }
    }
}
```

