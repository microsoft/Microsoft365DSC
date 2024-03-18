# EXOEmailAddressPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies the unique name of the email address policy. The maximum length is 64 characters. | |
| **Priority** | Write | String | The Priority parameter specifies the order that the email address policies are evaluated. By default, every time that you add a new email address policy, the policy is assigned a priority of N+1, where N is the number of email address policies that you've created. | |
| **EnabledEmailAddressTemplates** | Write | StringArray[] | The EnabledEmailAddressTemplates parameter specifies the rules in the email address policy that are used to generate email addresses for recipients. | |
| **EnabledPrimarySMTPAddressTemplate** | Write | StringArray[] | The EnabledPrimarySMTPAddressTemplate parameter specifies the specifies the rule in the email address policy that's used to generate the primary SMTP email addresses for recipients. You can use this parameter instead of the EnabledEmailAddressTemplates if the policy only applies the primary email address and no additional proxy addresses. | |
| **ManagedByFilter** | Write | String | The ManagedByFilter parameter specifies the email address policies to apply to Office 365 groups based on the properties of the users who create the Office 365 groups. | |
| **Ensure** | Write | String | Specify if the Email Address Policy should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures Email address policies in Exchange Online.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- E-Mail Address Policies

#### Role Groups

- Organization Management

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

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        EXOEmailAddressPolicy 'ConfigureEmailAddressPolicy'
        {
            Name                              = "Integration Policy"
            EnabledEmailAddressTemplates      = @("SMTP:@$Domain")
            EnabledPrimarySMTPAddressTemplate = "@$Domain"
            ManagedByFilter                   = ""
            Priority                          = 1
            Ensure                            = "Present"
            Credential                        = $Credscredential
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

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        EXOEmailAddressPolicy 'ConfigureEmailAddressPolicy'
        {
            Name                              = "Integration Policy"
            EnabledEmailAddressTemplates      = @("SMTP:@$Domain")
            EnabledPrimarySMTPAddressTemplate = "@$Domain"
            ManagedByFilter                   = "Department -eq 'Sales'" # Updated Property
            Priority                          = 1
            Ensure                            = "Present"
            Credential                        = $Credscredential
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
        $Domain = $Credscredential.Username.Split('@')[1]
        EXOEmailAddressPolicy 'ConfigureEmailAddressPolicy'
        {
            Name                              = "Integration Policy"
            Ensure                            = "Absent"
            Credential                        = $Credscredential
        }
    }
}
```

