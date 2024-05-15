# EXOAddressList

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies a unique name for the address list. | |
| **ConditionalCompany** | Write | StringArray[] | The ConditionalCompany parameter specifies a precanned filter that's based on the value of the recipient's Company property. | |
| **ConditionalCustomAttribute1** | Write | StringArray[] | The ConditionalCustomAttribute1 parameter specifies a precanned filter that's based on the value of the recipient's CustomAttribute1 property. | |
| **ConditionalCustomAttribute10** | Write | StringArray[] | The ConditionalCustomAttribute10 parameter specifies a precanned filter that's based on the value of the recipient's CustomAttribute10 property. | |
| **ConditionalCustomAttribute11** | Write | StringArray[] | The ConditionalCustomAttribute11 parameter specifies a precanned filter that's based on the value of the recipient's CustomAttribute11 property. | |
| **ConditionalCustomAttribute12** | Write | StringArray[] | The ConditionalCustomAttribute12 parameter specifies a precanned filter that's based on the value of the recipient's CustomAttribute12 property. | |
| **ConditionalCustomAttribute13** | Write | StringArray[] | The ConditionalCustomAttribute13 parameter specifies a precanned filter that's based on the value of the recipient's CustomAttribute13 property. | |
| **ConditionalCustomAttribute14** | Write | StringArray[] | The ConditionalCustomAttribute14 parameter specifies a precanned filter that's based on the value of the recipient's CustomAttribute14 property. | |
| **ConditionalCustomAttribute15** | Write | StringArray[] | The ConditionalCustomAttribute15 parameter specifies a precanned filter that's based on the value of the recipient's CustomAttribute15 property. | |
| **ConditionalCustomAttribute2** | Write | StringArray[] | The ConditionalCustomAttribute2 parameter specifies a precanned filter that's based on the value of the recipient's CustomAttribute2 property. | |
| **ConditionalCustomAttribute3** | Write | StringArray[] | The ConditionalCustomAttribute3 parameter specifies a precanned filter that's based on the value of the recipient's CustomAttribute3 property. | |
| **ConditionalCustomAttribute4** | Write | StringArray[] | The ConditionalCustomAttribute4 parameter specifies a precanned filter that's based on the value of the recipient's CustomAttribute4 property. | |
| **ConditionalCustomAttribute5** | Write | StringArray[] | The ConditionalCustomAttribute5 parameter specifies a precanned filter that's based on the value of the recipient's CustomAttribute5 property. | |
| **ConditionalCustomAttribute6** | Write | StringArray[] | The ConditionalCustomAttribute6 parameter specifies a precanned filter that's based on the value of the recipient's CustomAttribute6 property. | |
| **ConditionalCustomAttribute7** | Write | StringArray[] | The ConditionalCustomAttribute7 parameter specifies a precanned filter that's based on the value of the recipient's CustomAttribute7 property. | |
| **ConditionalCustomAttribute8** | Write | StringArray[] | The ConditionalCustomAttribute8 parameter specifies a precanned filter that's based on the value of the recipient's CustomAttribute8 property. | |
| **ConditionalCustomAttribute9** | Write | StringArray[] | The ConditionalCustomAttribute9 parameter specifies a precanned filter that's based on the value of the recipient's CustomAttribute9 property. | |
| **ConditionalDepartment** | Write | StringArray[] | The ConditionalDepartment parameter specifies a precanned filter that's based on the value of the recipient's Department property. | |
| **ConditionalStateOrProvince** | Write | StringArray[] | The ConditionalStateOrProvince parameter specifies a precanned filter that's based on the value of the recipient's StateOrProvince property. | |
| **DisplayName** | Write | String | The DisplayName parameter specifies the display name of the address list. | |
| **IncludedRecipients** | Write | StringArray[] | The IncludedRecipients parameter specifies a precanned filter that's based on the recipient type. | `AllRecipients`, `MailboxUsers`, `MailContacts`, `MailGroups`, `MailUsers`, `Resources` |
| **RecipientFilter** | Write | String | The RecipientFilter parameter specifies a custom OPath filter that's based on the value of any available recipient property. | |
| **Ensure** | Write | String | Specifies if this AddressList should exist. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

## Description

This resource configures Exchange Online address lists.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Address Lists

#### Role Groups

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
        EXOAddressList 'HRUsersAddressList'
        {
            Name                       = "HR Users"
            ConditionalCompany         = "Contoso"
            ConditionalDepartment      = "HR"
            ConditionalStateOrProvince = "US"
            IncludedRecipients         = "AllRecipients"
            Ensure                     = "Present"
            Credential                 = $Credscredential
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
        EXOAddressList 'HRUsersAddressList'
        {
            Name                       = "HR Users"
            ConditionalCompany         = "Contoso"
            ConditionalDepartment      = "HR2" # Updated Property
            ConditionalStateOrProvince = "US"
            IncludedRecipients         = "AllRecipients"
            Ensure                     = "Present"
            Credential                 = $Credscredential
        }
    }
}
```

### Example 3

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
        EXOAddressList 'HRUsersAddressList'
        {
            Name                       = "HR Users"
            Ensure                     = "Absent"
            Credential                 = $Credscredential
        }
    }
}
```

