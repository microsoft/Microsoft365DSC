# SCRetentionComplianceRule

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies the unique name of the retention rule. | |
| **Policy** | Required | String | The Policy parameter specifies the policy to contain the rule. | |
| **Ensure** | Write | String | Specify if this rule should exist or not. | `Present`, `Absent` |
| **Comment** | Write | String | The Comment parameter specifies an optional comment. | |
| **ExpirationDateOption** | Write | String | The ExpirationDateOption parameter specifies whether the expiration date is calculated from the content creation date or last modification date. Valid values are: CreationAgeInDays and ModificationAgeInDays. | `CreationAgeInDays`, `ModificationAgeInDays` |
| **ExcludedItemClasses** | Write | StringArray[] | The ExcludedItemClasses parameter specifies the types of messages to exclude from the rule. You can use this parameter only to exclude items from a hold policy, which excludes the specified item class from being held. Using this parameter won't exclude items from deletion policies. Typically, you use this parameter to exclude voicemail messages, IM conversations, and other Skype for Business Online content from being held by a hold policy. | |
| **ContentMatchQuery** | Write | String | The ContentMatchQuery parameter specifies a content search filter. | |
| **RetentionComplianceAction** | Write | String | The RetentionComplianceAction parameter specifies the retention action for the rule. Valid values are: Delete, Keep and KeepAndDelete. | `Delete`, `Keep`, `KeepAndDelete` |
| **RetentionDuration** | Write | String | The RetentionDuration parameter specifies the hold duration for the retention rule. Valid values are: An integer - The hold duration in days, Unlimited - The content is held indefinitely. | |
| **RetentionDurationDisplayHint** | Write | String | The RetentionDurationDisplayHint parameter specifies the units that are used to display the retention duration in the Security and Compliance Center. Valid values are: Days, Months or Years. | `Days`, `Months`, `Years` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |

## Description

This resource configures a Retention Compliance Rule in Security and Compliance.

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
        SCRetentionComplianceRule 'RetentionComplianceRule'
        {
            Name                      = "DemoRule2"
            Policy                    = "ContosoPolicy"
            Comment                   = "This is a Demo Rule"
            RetentionComplianceAction = "Keep"
            RetentionDuration         = "Unlimited"
            Ensure                    = "Present"
            Credential                = $Credscredential
        }
    }
}
```

