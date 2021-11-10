# O365Group

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | The display name for the group. ||
| **MailNickName** | Key | String | The group's Internal Name. ||
| **ManagedBy** | Write | StringArray[] | The group's owner user principal. ||
| **Description** | Write | String | The group's description. ||
| **Members** | Write | StringArray[] | Members of the group. ||
| **Ensure** | Write | String | Present ensures the group exists, absent ensures it is removed. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||

## Description

This resource allows users to create Office 365 Users and assign them licenses.

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
        O365Group 'OttawaTeamGroup'
        {
            DisplayName        = "Ottawa Employees"
            MailNickName       = "OttawaEmployees"
            Description        = "This is only for employees of the Ottawa Office"
            ManagedBy          = "TenantAdmin@contoso.onmicrosoft.com"
            Members            = @("Bob.Houle", "John.Smith")
            Ensure             = "Present"
            Credential         = $credsGlobalAdmin
        }
    }
}
```

