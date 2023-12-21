# AADUser

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **UserPrincipalName** | Key | String | The login name of the user | |
| **DisplayName** | Write | String | The display name for the user | |
| **FirstName** | Write | String | The first name of the user | |
| **LastName** | Write | String | The last name of the user | |
| **Roles** | Write | StringArray[] | The list of Azure Active Directory roles assigned to the user. | |
| **UsageLocation** | Write | String | The country code the user will be assigned to | |
| **LicenseAssignment** | Write | StringArray[] | The account SKU Id for the license to be assigned to the user | |
| **Password** | Write | PSCredential | The password for the account. The parameter is a PSCredential object, but only the Password component will be used. If Password is not supplied for a new resource a new random password will be generated. Property will only be used when creating the user and not on subsequent updates. | |
| **City** | Write | String | The City name of the user | |
| **Country** | Write | String | The Country name of the user | |
| **Department** | Write | String | The Department name of the user | |
| **Fax** | Write | String | The Fax Number of the user | |
| **MemberOf** | Write | StringArray[] | The Groups that the user is a direct member of | |
| **MobilePhone** | Write | String | The Mobile Phone Number of the user | |
| **Office** | Write | String | The Office Name of the user | |
| **PasswordNeverExpires** | Write | Boolean | Specifies whether the user password expires periodically. Default value is false | |
| **PasswordPolicies** | Write | String | Specifies password policies for the user. | |
| **PhoneNumber** | Write | String | The Phone Number of the user | |
| **PostalCode** | Write | String | The Postal Code of the user | |
| **PreferredLanguage** | Write | String | The Prefered Language of the user | |
| **State** | Write | String | Specifies the state or province where the user is located | |
| **StreetAddress** | Write | String | Specifies the street address of the user | |
| **Title** | Write | String | Specifies the title of the user | |
| **UserType** | Write | String | Specifies the title of the user | `Guest`, `Member`, `Other`, `Viral` |
| **Ensure** | Write | String | Present ensures the user exists, absent ensures it is removed | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource allows users to create Azure AD Users and assign them licenses, roles and/or groups.

If using with AADGroup, be aware that if AADUser->MemberOf is being specified and the referenced group is configured with AADGroup->Member then a conflict may arise if the two don't match. It is usually best to choose only one of them. See AADGroup

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - RoleManagement.Read.Directory, User.Read.All, Group.Read.All, GroupMember.Read.All

- **Update**

    - Organization.Read.All, RoleManagement.Read.Directory, RoleManagement.ReadWrite.Directory, User.Read.All, Group.Read.All, GroupMember.Read.All, User.ReadWrite.All, Group.ReadWrite.All, GroupMember.ReadWrite.All

#### Application permissions

- **Read**

    - RoleManagement.Read.Directory, User.Read.All

- **Update**

    - Organization.Read.All, RoleManagement.Read.Directory, RoleManagement.ReadWrite.Directory, User.Read.All, User.ReadWrite.All

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
        $Organization = $Credscredential.Username.Split('@')[1]
        AADUser 'ConfigureJohnSMith'
        {
            UserPrincipalName  = "John.Smith@$Organization"
            FirstName          = "John"
            LastName           = "Smith"
            DisplayName        = "John J. Smith"
            City               = "Gatineau"
            Country            = "Canada"
            Office             = "Ottawa - Queen"
            LicenseAssignment  = @("O365dsc1:ENTERPRISEPREMIUM")
            UsageLocation      = "US"
            Ensure             = "Present"
            Credential         = $Credscredential
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
        $Organization = $Credscredential.Username.Split('@')[1]
        AADUser 'ConfigureJohnSMith'
        {
            UserPrincipalName  = "John.Smith@$Organization"
            FirstName          = "John"
            LastName           = "Smith"
            DisplayName        = "John J. Smith"
            City               = "Ottawa" # Updated
            Country            = "Canada"
            Office             = "Ottawa - Queen"
            LicenseAssignment  = @("O365dsc1:ENTERPRISEPREMIUM")
            UsageLocation      = "US"
            Ensure             = "Present"
            Credential         = $Credscredential
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
        $Organization = $Credscredential.Username.Split('@')[1]
        AADUser 'ConfigureJohnSMith'
        {
            UserPrincipalName  = "John.Smith@$Organization"
            Ensure             = "Absent"
            Credential         = $Credscredential
        }
    }
}
```

