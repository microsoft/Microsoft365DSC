# AADGroupOwnerConsentSettings

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Only valid value is 'Yes'. | `Yes` |
| **EnableGroupSpecificConsent** | Write | Boolean | Flag indicating if groups owners are allowed to grant group specific permissions. | |
| **BlockUserConsentForRiskyApps** | Write | Boolean | Flag indicating if user consent will be blocked when a risky request is detected. Administrators will still be able to consent to apps considered risky. | |
| **EnableAdminConsentRequests** | Write | Boolean | Flag indicating if users will be able to request admin consent when they are unable to grant consent to an app themselves. | |
| **ConstrainGroupSpecificConsentToMembersOfGroupName** | Write | String | If EnableGroupSpecificConsent is set to âTrueâ and this is set to a security group name, members (both direct and transitive) of the group identified will be authorized to grant group-specific permissions to the groups they own. | |
| **Ensure** | Write | String | Specify if the Azure AD Group Consent Settings should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |


# AADGroupOwnerConsentPolicySettings

## Description

Azure AD Group Owner Consent Settings

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Directory.Read.All, Group.Read.All

- **Update**

    - Directory.ReadWrite.All, Policy.ReadWrite.Authorization

#### Application permissions

- **Read**

    - Directory.Read.All, Group.Read.All

- **Update**

    - Directory.ReadWrite.All, Policy.ReadWrite.Authorization

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
        AADGroupOwnerConsentSettings 'Example'
        {
            IsSingleInstance                                  = "Yes"
            EnableGroupSpecificConsent                        = $false
            BlockUserConsentForRiskyApps                      = $true
            EnableAdminConsentRequests                        = $false
            #ConstrainGroupSpecificConsentToMembersOfGroupName = ''  # value is only relevant if EnableGroupSpecificConsent is true. See example 2
            Ensure                                            = 'Present'
            Credential                                        = $Credscredential
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
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADGroupOwnerConsentSettings 'Example'
        {
            IsSingleInstance                                  = "Yes"
            EnableGroupSpecificConsent                        = $true  # prerequisite for specifying a constraining group
            ConstrainGroupSpecificConsentToMembersOfGroupName = 'Group-Vetted-GroupOwners'
            Ensure                                            = 'Present'
            Credential                                        = $Credscredential
        }
    }
}
```

