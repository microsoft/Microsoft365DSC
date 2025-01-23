# O365SearchAndIntelligenceConfigurations

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Specifies the resource is a single instance, the value must be 'Yes' | `Yes` |
| **ItemInsightsIsEnabledInOrganization** | Write | Boolean | Specifies whether or not Item Insights should be available for the organization. | |
| **ItemInsightsDisabledForGroup** | Write | String | Specifies a single Azure AD Group for which Item Insights needs to be disabled. | |
| **MeetingInsightsIsEnabledInOrganization** | Write | Boolean | Specifies whether or not Meeting Insights should be available for the organization. | |
| **PersonInsightsIsEnabledInOrganization** | Write | Boolean | Specifies whether or not Person Insights should be available for the organization. | |
| **PersonInsightsDisabledForGroup** | Write | String | Specifies a single Azure AD Group for which Person Insights needs to be disabled. | |
| **Credential** | Write | PSCredential | Credentials of the Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

## Description

This resource configures the Search And Intelligence configuration settings.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - User.Read.All

- **Update**

    - User.ReadWrite

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
        O365SearchAndIntelligenceConfigurations 'SearchAndIntelligenceConfigurations'
        {
            Credential                               = $Credscredential;
            IsSingleInstance                         = "Yes";
            ItemInsightsIsEnabledInOrganization      = $False;
            MeetingInsightsIsEnabledInOrganization   = $True;
            ItemInsightsDisabledForGroup             = "TestGroup"
            PersonInsightsIsEnabledInOrganization    = $True;
        }
    }
}
```

