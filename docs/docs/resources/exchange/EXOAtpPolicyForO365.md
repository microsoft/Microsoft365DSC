# EXOAtpPolicyForO365

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Specifies the resource is a single instance, the value must be 'Yes' |Yes|
| **Identity** | Write | String | The Identity parameter specifies the ATP policy that you want to modify. There's only one policy named Default. ||
| **Ensure** | Write | String | Since there is only one policy, the default policy, this must be set to 'Present' |Present|
| **AllowClickThrough** | Write | Boolean | The AllowClickThrough parameter specifies whether to allow users to click through to the original blocked URL in Office 365 ProPlus. Default is $true. ||
| **AllowSafeDocsOpen** | Write | Boolean | The AllowSafeDocsOpen parameter specifies whether users can click through and bypass the Protected View container even when Safe Documents identifies a file as malicious. ||
| **BlockUrls** | Write | StringArray[] | The BlockUrls parameter specifies the URLs that are always blocked by Safe Links scanning. You can specify multiple values separated by commas. ||
| **EnableATPForSPOTeamsODB** | Write | Boolean | The EnableATPForSPOTeamsODB parameter specifies whether ATP is enabled for SharePoint Online, OneDrive for Business and Microsoft Teams. Default is $false. ||
| **EnableSafeDocs** | Write | Boolean | The EnableSafeDocs parameter specifies whether to enable the Safe Documents feature in the organization. Default is $false. ||
| **EnableSafeLinksForO365Clients** | Write | Boolean | The EnableSafeLinksForO365Clients parameter specifies whether Safe Links scanning is enabled for supported Office 365 desktop, mobile, and web apps. Default is $true. ||
| **TrackClicks** | Write | Boolean | The TrackClicks parameter specifies whether to track user clicks related to blocked URLs. Default is $true. ||
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||

# EXOAtpPolicyForO365

### Description

This resource configures the Advanced Threat Protection (ATP) policy
in Office 365.  Tenant must be subscribed to ATP.

## Parameters

Ensure

- Required: No (Defaults to 'Present')
- Description: `Present` is the only value accepted.
  Configurations using `Ensure = 'Absent'` will throw an Error!

IsSingleInstance

- Required: Yes
- Description: Single instance resource, the value must be 'Yes'

Credential

- Required: Yes
- Description: Credentials of the Office 365 Global Admin

Identity

- Required: No
- Description: The Identity parameter specifies the ATP policy that you
  want to modify. There's only one policy namd Default.

AllowClickThrough

- Required: No
- Description: The AllowClickThrough parameter specifies whether to allow
  users to click through to the original blocked URL in
  Office 365 ProPlus. The default value is $true

AllowSafeDocsOpen

- Required: No
- Description: The AllowSafeDocsOpen parameter specifies whether users can
  click through and bypass the Protected View container even when Safe Documents
  identifies a file as malicious.

BlockUrls

- Required: No
- Description: The BlockUrls parameter specifies the URLs that are
  always blocked by Safe Links scanning.
  You can specify multiple values separated by commas.

EnableATPForSPOTeamsODB

- Required: No
- Description: The EnableATPForSPOTeamsODB parameter specifies whether
  ATP is enabled for SharePoint Online, OneDrive for Business and
  Microsoft Teams. The default value is $false

EnableSafeDocs

- Required: No
- Description: The EnableSafeDocs parameter specifies whether to enable the
  Safe Documents feature in the organization.
  The default value is $false

EnableSafeLinksForO365Clients

- Required: No
- Description: The EnableSafeLinksForO365Clients parameter specifies whether Safe Links
  scanning is enabled for supported Office 365 desktop, mobile, and web apps.
   The default value is $true

TrackClicks

- Required: No
- Description: The TrackClicks parameter specifies whether to track user
  clicks related to blocked URLs. The default value is $false

## Example

```PowerShell
        EXOAtpPolicyForO365 AtpConfigExample {
            IsSingleInstance                = 'Yes'
            Ensure                          = 'Present'
            Identity                        = 'Default'
            Credential                      = $Credential
            AllowClickThrough               = $true
            AllowSafeDocsOpen               = $true
            BlockUrls                       = @('test1.badurl.com','test2.badurl.com')
            EnableATPForSPOTeamsODB         = $true
            EnableSafeDocs                  = $false
            EnableSafeLinksForO365Clients   = $true
            TrackClicks                     = $true
        }
```

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
        EXOAtpPolicyForO365 'ConfigureAntiPhishPolicy'
        {
            IsSingleInstance        = "Yes"
            AllowClickThrough       = $false
            BlockUrls               = "https://badurl.contoso.com"
            EnableATPForSPOTeamsODB = $true
            Ensure                  = "Present"
            Credential              = $credsGlobalAdmin
        }
    }
}
```

