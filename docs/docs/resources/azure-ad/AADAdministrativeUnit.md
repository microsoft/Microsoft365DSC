# AADAdministrativeUnit

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Write | String | User or Group Principal name. ||
| **Type** | Write | String | Member type. Valid values are: Group or User. |Group, User|
| **DisplayName** | Key | String | Display name for the administrative unit. ||
| **Description** | Write | String | An optional description for the administrative unit. ||
| **Id** | Write | String | Unique identifier for the administrative unit. ||
| **MembershipRule** | Write | String | Dynamic membership rule for the administrative unit. ||
| **MembershipType** | Write | String | Membership type for the administrative unit. Can be dynamic or assigned. |Assigned, Dynamic|
| **MembershipRuleProcessingState** | Write | String | Membership type for the administrative unit. Can be dynamic or assigned. |On, Paused|
| **Members** | Write | InstanceArray[] | Users and groups that are members of this administrative unit. ||
| **Visibility** | Write | String | Controls whether the administrative unit and its members are hidden or public. Can be set to HiddenMembership. If not set (value is null), the default behavior is public. When set to HiddenMembership, only members of the administrative unit can list other members of the administrative unit. ||
| **Ensure** | Write | String | Specify if the Azure AD Administrative Unit should exist or not. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Azure AD Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. ||

# AADAdministrativeUnit

### Description

This resource configures an Azure Active Directory Administrative Unit.

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

    node localhost
    {
        AADAdministrativeUnit 'TestUnit'
        {
            Credential                    = $credsCredential;
            DisplayName                   = "Test-Unit";
            Ensure                        = "Present";
            MembershipRule                = "(user.country -eq `"Canada`")";
            MembershipRuleProcessingState = "On";
            MembershipType                = "Dynamic";
        }
    }
}
```

