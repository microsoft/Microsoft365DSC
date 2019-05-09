# SPOSiteDesign

## Description

This resource configures Site Designs.

## Parameters

Ensure

- Required: No (Defaults to 'Present')
- Description: `Present` or `Absent` are the only value accepted.
    Absent will remove site design
    Present will add site design

Title

- Required: Yes
- Description: Title of the Site Design

SiteScriptNames

- Required: No
- Description: List of names of site scripts to include in site design

WebTemplate

- Required: No
- Description: Web template to apply site design, only validate
  parameters are CommunicationSite and TeamSite

Description

- Required: No
- Description: Description of the site design

IsDefault

- Required: No
- Description: Determines if the site design is applied by default

PreviewImageAltText

- Required: No
- Description: Preview text for the alt image of site design

PreviewImageUrl

- Required: No
- Description: Url of image preview of site design

Version

- Required: No
- Description: Version number of site design script

Tenant Admin Url

- Required: Yes
- Description: Url to tenant admin site

GlobalAdminAccount

- Required: Yes
- Description: Credentials of the Office365 Tenant Admin

## Example

```PowerShell
        SiteDesign SiteDesignConfig {
            Title               = "DSC Site Design"
            SiteScriptNames     = @("Cust List", "List_Views")
            WebTemplate         = "TeamSite"
            IsDefault           = $false
            Description         = "Created by DSC"
            PreviewImageAltText = "Office 365"
            Ensure              = "Present"
            Version             = 1
            CentralAdminUrl     = 'https://contoso-admin.sharepoint.com'
            GlobalAdminAccount  = $GlobalAdminAccount
        }
```
