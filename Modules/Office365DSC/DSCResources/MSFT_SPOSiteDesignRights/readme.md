# SPOSiteDesignRights

## Description

This resource configures rights on Site Designs.

## Parameters

    Ensure
      - Required: No (Defaults to 'Present')
      - Description: `Present` is the only value accepted.
          Configurations using `Ensure = 'Absent'` will throw an Error!

    SiteDesignTitle
      - Required: Yes
      - Description: Title of the Site Design

    UserPrincipals
      - Required: Yes
      - Description: List of users with permissions to Site Design

    Rights
      - Required: Yes
      - Description: Values can be view or none

    Tenant Admin Url
      - Required: Yes
      - Description: Url to tenant admin site

    GlobalAdminAccount
      - Required: Yes
      - Description: Credentials of the Office365 Tenant Admin

## Example

```PowerShell
        SiteDesignRights MySiteDesignRights {
            SiteDesignTitle                      = 'Customer List'
            Ensure                               = 'Present'
            UserPrincipals                       = 'jdoe@contoso.com'
            Rights                               = 'View'
            CentralAdminUrl                      = 'https://contoso-admin.sharepoint.com'
            GlobalAdminAccount                   = $GlobalAdminAccount
        }
```
