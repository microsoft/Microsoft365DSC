# IntuneRoleAssignment

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Write | String | The unique idenfier for an entity. Read-only. ||
| **Description** | Write | String | Description of the Role Assignment. ||
| **DisplayName** | Key | String | The display or friendly name of the role Assignment. ||
| **ResourceScopes** | Write | StringArray[] | List of ids of role scope member security groups. These are IDs from Azure Active Directory. ||
| **ResourceScopesDisplayNames** | Write | StringArray[] | List of DisplayName of role scope member security groups. These are Displayname from Azure Active Directory. ||
| **Members** | Write | StringArray[] | The list of ids of role member security groups. These are IDs from Azure Active Directory. ||
| **MembersDisplayNames** | Write | StringArray[] | The list of Displaynames of role member security groups. These are Displaynamnes from Azure Active Directory. ||
| **RoleDefinition** | Write | String | The Role Definition Id. ||
| **RoleDefinitionDisplayName** | Write | String | The Role Definition Displayname. ||
| **Ensure** | Write | String | Present ensures the Role exists, absent ensures it is removed. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Intune Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. ||


# IntuneRoleAssignment

### Description

This resource configures an Intune Role Assignment.

## Examples

### Example 1

This example creates a new Intune Role Assigment.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
        IntuneRoleAssignment "IntuneRoleAssignment"
        {
            Description                = "test2";
            DisplayName                = "test2";
            Ensure                     = "Present";
            Id                         = "20556aad-3d16-465a-890c-cf915ae1cd60";
            Members                    = @("");
            MembersDisplayNames        = @("SecGroup2");
            ResourceScopes             = @("6eb76881-f56f-470f-be0d-672145d3dcb1");
            ResourceScopesDisplayNames = @("");
            RoleDefinition             = "2d00d0fd-45e9-4166-904f-b76ac5eed2c7";
            RoleDefinitionDisplayName  = "This is my role";
            Credential                 = $credsGlobalAdmin
        }
    }
}
```

