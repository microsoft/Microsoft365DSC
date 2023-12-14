# AADGroupsNamingPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Only valid value is 'Yes'. | `Yes` |
| **PrefixSuffixNamingRequirement** | Write | String | Prefixes and suffixes to add to the group name. | |
| **CustomBlockedWordsList** | Write | StringArray[] | Comma delimited list of words that should be blocked from being included in groups' names. | |
| **Ensure** | Write | String | Specify if the Azure AD Groups Naming Policy should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials for the Microsoft Graph delegated permissions. | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures an Azure Active Directory Group Naming Policy.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Directory.Read.All

- **Update**

    - Directory.Read.All, Directory.ReadWrite.All

#### Application permissions

- **Read**

    - Directory.Read.All

- **Update**

    - Directory.Read.All, Directory.ReadWrite.All

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
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADGroupsNamingPolicy 'GroupsNamingPolicy'
        {
            IsSingleInstance              = "Yes"
            CustomBlockedWordsList        = @("CEO", "President")
            PrefixSuffixNamingRequirement = "[Title]Test[Company][GroupName][Office]Redmond"
            Ensure                        = "Present"
            Credential                    = $Credscredential
        }
    }
}
```

