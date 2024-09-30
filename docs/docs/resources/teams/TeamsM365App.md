# TeamsM365App

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Key | String | Application ID of Microsoft Teams app. | |
| **IsBlocked** | Write | Boolean | The state of the app in the tenant. | |
| **AssignmentType** | Write | String | App availability type. | `Everyone`, `UsersAndGroups`, `NoOne` |
| **Users** | Write | StringArray[] | List of all the users for whom the app is enabled or disabled. | |
| **Groups** | Write | StringArray[] | List of all the groups for whom the app is enabled or disabled. | |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

This resource manages Teams app. This includes app state, app availability, user who updated app availability, and the associated timestamp.

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

    - Organization.Read.All

- **Update**

    - Organization.Read.All

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
        TeamsM365App "TeamsM365App-Update"
        {
            AssignmentType       = "UsersAndGroups";
            Credential           = $Credscredential;
            Groups               = @("Finance Team");
            Id                   = "95de633a-083e-42f5-b444-a4295d8e9314";
            IsBlocked            = $False;
            Users                = @();
        }
    }
}
```

