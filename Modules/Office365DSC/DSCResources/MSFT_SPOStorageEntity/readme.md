# SPOStorageEntity

## Description

This resource configures Storage Entity.

## Parameters

    Ensure
      - Required: No (Defaults to 'Present')
      - Description: `Present` or `Absent` are the only value accepted.
          Absent will remove site design
          Present will add site design

    Key
      - Required: Yes
      - Description: Title of the Site Design

    Value
      - Required: No
      - Description: List of names of site scripts to include in site design

    Scope
      - Required: No
      - Description: Web template to apply site design, only validate
        parameters are CommunicationSite and TeamSite

    Description
      - Required: No
      - Description: Description of the site design

    Comment
      - Required: No
      - Description: Determines if the site design is applied by default

    SiteUrl
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
