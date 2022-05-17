﻿# TeamsUser

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **TeamName** | Key | String | Team NAme ||
| **User** | Key | String | UPN of user to add to Team ||
| **Role** | Write | String | User role in Team |Guest, Member, Owner|
| **Ensure** | Write | String | Present ensures the Team user exists, absent ensures it is removed |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Teams Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||

## Description

This resource is used to add new users to a team

## Azure AD Permissions

To authenticate via Azure Active Directory, this resource required the following Application permissions:

* **Automate**
  * Microsoft.Graph
    * Group.ReadWrite.All
* **Export**
  * Microsoft.Graph
    * Group.ReadAll

NOTE: All permisions listed above require admin consent.

More information: https://docs.microsoft.com/en-us/microsoftteams/assign-roles-permissions

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
        TeamsUser 'ConfigureTeamsUser'
        {
            TeamName   = "SuperSecretTeam"
            User       = "jdoe@contoso.com"
            Role       = "Member"
            Ensure     = "Present"
            Credential = $credsGlobalAdmin
        }
    }
}
```

