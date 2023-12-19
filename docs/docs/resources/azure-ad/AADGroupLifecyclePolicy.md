# AADGroupLifecyclePolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Only valid value is 'Yes'. | `Yes` |
| **GroupLifetimeInDays** | Required | UInt32 | The number of days a group can exist before it needs to be renewed. | |
| **ManagedGroupTypes** | Required | String | This parameter allows the admin to select which office 365 groups the policy will apply to. 'None' will create the policy in a disabled state. 'All' will apply the policy to every Office 365 group in the tenant. 'Selected' will allow the admin to choose specific Office 365 groups that the policy will apply to. | `All`, `None`, `Selected` |
| **AlternateNotificationEmails** | Required | StringArray[] | Notification emails for groups that have no owners will be sent to these email addresses. | |
| **Ensure** | Write | String | Specify if the Azure AD Groups Lifecycle Policy should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials for the Microsoft Graph delegated permissions. | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures an Azure Active Directory Group Lifecycle Policy (e.g. Expiration).

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
        AADGroupLifecyclePolicy 'GroupLifecyclePolicy'
        {
            IsSingleInstance            = "Yes"
            AlternateNotificationEmails = @("john.smith@contoso.com")
            GroupLifetimeInDays         = 99
            ManagedGroupTypes           = "Selected"
            Ensure                      = "Present"
            Credential                  = $Credscredential
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
        AADGroupLifecyclePolicy 'GroupLifecyclePolicy'
        {
            IsSingleInstance            = "Yes"
            Ensure                      = "Absent"
            Credential                  = $Credscredential
        }
    }
}
```

