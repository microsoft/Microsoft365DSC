# SCComplianceTag

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies the unique name of the complaiance tag. | |
| **Ensure** | Write | String | Specify if this rule should exist or not. | `Present`, `Absent` |
| **Comment** | Write | String | The Comment parameter specifies an optional comment. | |
| **EventType** | Write | String | The EventType parameter specifies the retention rule that's associated with the label. | |
| **IsRecordLabel** | Write | Boolean | The IsRecordLabel parameter specifies whether the label is a record label. | |
| **Notes** | Write | String | The Notes parameter specifies an optional note. If you specify a value that contains spaces, enclose the value in quotation marks, for example: 'This is a user note' | |
| **Regulatory** | Write | Boolean | Regulatory description | |
| **FilePlanProperty** | Write | MSFT_SCFilePlanProperty | The FilePlanProperty parameter specifies the file plan properties to include in the label. | |
| **ReviewerEmail** | Write | StringArray[] | The ReviewerEmail parameter specifies the email address of a reviewer for Delete and KeepAndDelete retention actions. You can specify multiple email addresses separated by commas. | |
| **RetentionDuration** | Write | String | The RetentionDuration parameter specifies the hold duration for the retention rule. Valid values are: An integer - The hold duration in days, Unlimited - The content is held indefinitely. | |
| **RetentionAction** | Write | String | The RetentionAction parameter specifies the action for the label. Valid values are: Delete, Keep or KeepAndDelete. | `Delete`, `Keep`, `KeepAndDelete` |
| **RetentionType** | Write | String | The RetentionType parameter specifies whether the retention duration is calculated from the content creation date, tagged date, or last modification date. Valid values are: CreationAgeInDays, EventAgeInDays,ModificationAgeInDays, or TaggedAgeInDays. | `CreationAgeInDays`, `EventAgeInDays`, `ModificationAgeInDays`, `TaggedAgeInDays` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

### MSFT_SCFilePlanProperty

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **FilePlanPropertyDepartment** | Write | String | File plan department. Can get list by running Get-FilePlanPropertyDepartment. | |
| **FilePlanPropertyAuthority** | Write | String | File plan Authority. Can get list by running Get-FilePlanPropertyAuthority. | |
| **FilePlanPropertyCategory** | Write | String | File plan category. Can get a list by running Get-FilePlanPropertyCategory. | |
| **FilePlanPropertyCitation** | Write | String | File plan citation. Can get a list by running Get-FilePlanPropertyCitation. | |
| **FilePlanPropertyReferenceId** | Write | String | File plan reference id. Can get a list by running Get-FilePlanPropertyReferenceId. | |
| **FilePlanPropertySubCategory** | Write | String | File plan subcategory. Can get a list by running Get-FilePlanPropertySubCategory. | |

## Description

This resource configures a Compliance Tag in Security and Compliance.

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
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        SCComplianceTag 'ConfigureComplianceTag'
        {
            Name              = "DemoTag"
            Comment           = "This is a Demo Tag"
            RetentionAction   = "Keep"
            RetentionDuration = "1025"
            RetentionType     = "ModificationAgeInDays"
            FilePlanProperty  = MSFT_SCFilePlanProperty
            {
                FilePlanPropertyDepartment  = "DemoDept"
                FilePlanPropertyCitation    = "DemoCit"
                FilePlanPropertyReferenceId = "DemoRef"
                FilePlanPropertyAuthority   = "DemoAuth"
                FilePlanPropertyCategory    = "DemoCat"
                FilePlanPropertySubcategory = "DemoSub"
            }
            Ensure            = "Present"
            Credential        = $Credscredential
        }
    }
}
```

