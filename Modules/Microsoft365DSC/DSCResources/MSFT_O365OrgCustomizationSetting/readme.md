# O365OrgCustomizationSetting

## Description

This resource configures the tenant settings so that the tenant runs in a fully
configurable mode. Usually tenants are created in a mode, that limits options to
customize the tenant. This setting is reflected by the Organization Config proptery
`IsDehydrated: True`.
Running this resource will set the property to false.

Currently there is no setting available to undo Enable-OrganizationCustomization.

## Parameters

IsSingleInstance

- Required: Yes
- Description: Single instance resource, the value must be 'Yes'

Ensure

- Required: No (Defaults to 'Present')
- Description: `Present` is the only value accepted.
  Configurations using `Ensure = 'Absent'` will throw an Error!

Credential

- Required: Yes
- Description: Credentials of the account to authenticate with

## Example

```PowerShell
        O365OrgCustomizationSettting EnableOgranizationCustomization {
            IsSingleInstance    = 'Yes'
            Ensure              = 'Present'
            Credential  = $Credential
        }
```
