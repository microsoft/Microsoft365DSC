# O365User

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **UserPrincipalName** | Key | String | The login name of the user ||
| **DisplayName** | Write | String | The display name for the user ||
| **FirstName** | Write | String | The first name of the user ||
| **LastName** | Write | String | The last name of the user ||
| **UsageLocation** | Write | String | The country code the user will be assigned to ||
| **LicenseAssignment** | Write | StringArray[] | The account SKU Id for the license to be assigned to the user ||
| **Password** | Write | PSCredential | The password for the account. The parameter is a PSCredential object, but only the Password component will be used ||
| **City** | Write | String | The City name of the user ||
| **Country** | Write | String | The Country name of the user ||
| **Department** | Write | String | The Department name of the user ||
| **Fax** | Write | String | The Fax Number of the user ||
| **MobilePhone** | Write | String | The Mobile Phone Number of the user ||
| **Office** | Write | String | The Office Name of the user ||
| **PasswordNeverExpires** | Write | Boolean | Specifies whether the user password expires periodically. Default value is false ||
| **PhoneNumber** | Write | String | The Phone Number of the user ||
| **PostalCode** | Write | String | The Postal Code of the user ||
| **PreferredDataLocation** | Write | String | The Prefered location to store data of the user ||
| **PreferredLanguage** | Write | String | The Prefered Language of the user ||
| **State** | Write | String | Specifies the state or province where the user is located ||
| **StreetAddress** | Write | String | Specifies the street address of the user ||
| **Title** | Write | String | Specifies the title of the user ||
| **UserType** | Write | String | Specifies the title of the user |Guest, Member, Other, Viral|
| **Ensure** | Write | String | Present ensures the user exists, absent ensures it is removed |Present, Absent|
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
        O365User 'ConfigureJohnSMith'
        {
            UserPrincipalName  = "John.Smith@O365DSC1.onmicrosoft.com"
            FirstName          = "John"
            LastName           = "Smith"
            DisplayName        = "John J. Smith"
            City               = "Gatineau"
            Country            = "Canada"
            Office             = "Ottawa - Queen"
            LicenseAssignment  = @("O365dsc1:ENTERPRISEPREMIUM")
            UsageLocation      = "US"
            Ensure             = "Present"
            Credential         = $credsGlobalAdmin
        }
    }
}
```

