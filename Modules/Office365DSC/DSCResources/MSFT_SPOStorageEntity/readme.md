# SPOStorageEntity

## Description

This resource configures Storage Entity for SharePoint Online.

## Parameters

    Ensure
      - Required: No (Defaults to 'Present')
      - Description: `Present` or `Absent` are the only value accepted.
          Absent will remove storage entity
          Present will add storage entity

    Key
      - Required: Yes
      - Description: Key of the value to set

    Value
      - Required: No
      - Description: Value to store

    EntityScope
      - Required: No
      - Description: Scope of the storage entity either Tenant or site

    Description
      - Required: No
      - Description: Description of the storage entity

    Comment
      - Required: No
      - Description: Comment to set

    SiteUrl
      - Required: Yes
      - Description: Url to tenant or site collection

    GlobalAdminAccount
      - Required: Yes
      - Description: Credentials of the Office365 Tenant or site

## Example

```PowerShell
        SPOStorageEntity StorageEnitytConfig
        {
            Key                 = "DSCKey"
            Value               = "Test storage entity"
            EntityScope         = "Tenant"
            Description         = "Description created by DSC"
            Comment             = "Comment from DSC"
            Ensure              = "Present"
            SiteUrl             = 'https://contoso-admin.sharepoint.com'
            GlobalAdminAccount  = $GlobalAdminAccount
        }
```
