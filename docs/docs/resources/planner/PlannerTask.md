# PlannerTask

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **PlanId** | Key | String | Id of the Planner Plan which contains the Task. | |
| **Title** | Key | String | The Title of the Planner Task. | |
| **Categories** | Write | StringArray[] | List of categories assigned to the task. | `Pink`, `Red`, `Yellow`, `Green`, `Blue`, `Purple` |
| **AssignedUsers** | Write | StringArray[] | List of users assigned to the tasks (ex: @('john.smith@contoso.com', 'bob.houle@contoso.com')). | |
| **Attachments** | Write | MSFT_PlannerTaskAttachment[] | List of links to attachments assigned to the task. | |
| **Checklist** | Write | MSFT_PlannerTaskChecklistItem[] | List checklist items associated with the task. | |
| **Notes** | Write | String | Description of the Task. | |
| **Bucket** | Write | String | The Id of the bucket that contains the task. | |
| **TaskId** | Write | String | Id of the Task, if known. | |
| **StartDateTime** | Write | String | Date and Time for the start of the Task. | |
| **DueDateTime** | Write | String | Date and Time for the task is due for completion. | |
| **PercentComplete** | Write | UInt32 | Percentage completed of the Task. Value can only be between 0 and 100. | |
| **Priority** | Write | UInt32 | Priority of the Task. Value can only be between 1 and 10. | |
| **ConversationThreadId** | Write | String | Id of the group conversation thread associated with the comments section for this task. | |
| **Ensure** | Write | String | Present ensures the Plan exists, absent ensures it is removed | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the account to authenticate with. | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

### MSFT_PlannerTaskAttachment

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Alias** | Write | String | Alias of for the attachment. | |
| **Uri** | Write | String | Uri of the link to the attachment. | |
| **Type** | Write | String | Type of attachment. | `PowerPoint`, `Word`, `Excel`, `Other` |

### MSFT_PlannerTaskChecklistItem

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Title** | Write | String | Title of the checklist item. | |
| **Completed** | Write | String | True if the item is completed, false otherwise. | |

## Description

This resource is used to configure the Planner Tasks.

* This resource deals with content. Using the Monitoring feature
  of Microsoft365DSC on content resources is not recommended.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Group.Read.All, User.Read.All

- **Update**

    - Group.Read.All, Group.ReadWrite.All, User.Read.All

#### Application permissions

- **Read**

    - Group.Read.All, User.Read.All

- **Update**

    - Group.Read.All, Group.ReadWrite.All, User.Read.All

## Examples

### Example 1

This example creates a new Planner Task in a Plan.

```powershell
Configuration Example
{
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        PlannerTask 'ContosoPlannerTask'
        {
            PlanId                = "1234567890"
            Title                 = "Contoso Task"
            StartDateTime         = "2020-06-09"
            Priority              = 7
            PercentComplete       = 75
            Ensure                = "Present"
            ApplicationId         = "12345-12345-12345-12345-12345"
            TenantId              = "12345-12345-12345-12345-12345"
            CertificateThumbprint = "1234567890"
        }
    }
}
```

