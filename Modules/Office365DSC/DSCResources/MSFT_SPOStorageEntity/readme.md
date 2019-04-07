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
      - Description: Key of the value to set

    Value
      - Required: No
      - Description: Value to store

    Scope
      - Required: No
      - Description: Scope of the storage entity either Tenant or site

    Description
      - Required: No
      - Description: Desecription of the storage entity

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
            Scope               = "Site"
            Description         = "Description created by DSC"
            Comment             = "Comment from DSC"
            Ensure              = "Present"
            CentralAdminUrl     = 'https://contoso-admin.sharepoint.com'
            GlobalAdminAccount  = $GlobalAdminAccount
        }
```
