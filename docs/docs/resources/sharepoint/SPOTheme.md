# SPOTheme

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The name of the theme, which appears in the theme picker UI and is also used by administrators and developers to refer to the theme in PowerShell cmdlets or calls to the SharePoint REST API. | |
| **IsInverted** | Write | Boolean | This value should be false for light themes and true for dark themes; it controls whether SharePoint uses dark or light theme colors to render text on colored backgrounds. | |
| **Palette** | Write | MSFT_SPOThemePaletteProperty[] | Specifies the color scheme which composes your theme. | |
| **Ensure** | Write | String | Only accepted value is 'Present'. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the account to authenticate with. | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for certificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

### MSFT_SPOThemePaletteProperty

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Property** | Write | String | Name of the property. | |
| **Value** | Write | String | Color value in Hexadecimal. | |


## Description

This resource allows users to configure and monitor the themes for
their SPO tenant.

To configure your SPO themes using this configuration resource requires you to
provide a color palette which at the end defines the colors of your theme.

You can use the SPO Theme builder under:

[https://aka.ms/spthemebuilder](https://aka.ms/spthemebuilder)

to create and preview your color palette.

Once you are satisfied with the color of your theme you can copy
the JSON Output and put it directly into your configuration.

More details on the theme schema can be found
[here](https://aka.ms/AboutSPOThemes)

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Domain.Read.All

- **Update**

    - Domain.Read.All

#### Application permissions

- **Read**

    - Domain.Read.All

- **Update**

    - Domain.Read.All

### Microsoft SharePoint

To authenticate with the SharePoint API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Sites.FullControl.All

- **Update**

    - Sites.FullControl.All

#### Application permissions

- **Read**

    - Sites.FullControl.All

- **Update**

    - Sites.FullControl.All

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
        SPOTheme 'ConfigureSharePointTheme'
        {
            Name       = "PSTheme1"
            IsInverted = $false
            Palette    = @(
                MSFT_SPOThemePaletteProperty
                {
                    Property = "themePrimary"
                    Value    = "#0078d4"
                }
                MSFT_SPOThemePaletteProperty
                {
                    Property = "themeLighterAlt"
                    Value    = "#eff6fc"
                }
            )
            Ensure     = "Present"
            Credential = $Credscredential
        }
    }
}
```

