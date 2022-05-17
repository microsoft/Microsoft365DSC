﻿# TeamsChannel

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | Current channel name ||
| **TeamName** | Key | String | Name of the team the Channel belongs to ||
| **GroupID** | Write | String | Team group ID, only used to target a Team when duplicated display names occurs. ||
| **NewDisplayName** | Write | String | Used to update current channel name ||
| **Description** | Write | String | Channel description ||
| **Ensure** | Write | String | Present ensures the Team channel exists, absent ensures it is removed |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Teams Global Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||

## Description

This resource is used to add and update channels in existing Teams.

## Azure AD Permissions

To authenticate via Azure Active Directory, this resource required the following Application permissions:

* **Automate**
  * Microsoft.Graph
    * Group.ReadWrite.All
* **Export**
  * Microsoft.Graph
    * Group.ReadAll

NOTE: All permisions listed above require admin consent.

More information: https://docs.microsoft.com/en-us/microsoftteams/teams-channels-overview

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
        TeamsChannel 'ConfigureChannel'
        {
            TeamName           = "SuperSecretTeam"
            DisplayName        = "SP2013 Review teams group"
            NewDisplayName     = "SP2016 Review teams group"
            Description        = "SP2016 Code reviews for SPFX"
            Ensure             = "Present"
            Credential         = $credsGlobalAdmin
        }
    }
}
```

