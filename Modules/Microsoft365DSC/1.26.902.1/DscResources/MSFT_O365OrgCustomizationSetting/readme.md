# O365OrgCustomizationSetting

## Description

This resource configures the tenant settings so that the tenant runs in a fully
configurable mode. Usually tenants are created in a mode, that limits options to
customize the tenant. This setting is reflected by the Organization Config proptery
`IsDehydrated: True`.
Running this resource will set the property to false.

Currently there is no setting available to undo Enable-OrganizationCustomization.
