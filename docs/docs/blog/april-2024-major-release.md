# Microsoft365DSC – April 2024 Major Release (version 1.24.403.1)

As defined by our [Breaking Changes Policy](https://microsoft365dsc.com/concepts/breaking-changes/), twice a year we allow for breaking changes to be deployed as part of a release. Our next major release, scheduled to go out on April 3rd 2024, will include several breaking changes and will be labeled version 1.24.403.1. This article provides details on the breaking changes and other important updates that will be included as part of our April 2024 Major release.

## EXOMailTips ([#4117](https://github.com/microsoft/Microsoft365DSC/issues/4117))

We are removing the Organization parameter from the resource and adding the IsSingleInstance parameter as the primary key for it. This is to make sure we align the logic of this resource with the logic of other resources that are tenant-wide components, which means that there can only ever be a single instance of it across the tenant. The remediation here involves checking existing configuration to see if it contains the EXOMailTips instance and to replace the Organization parameter by the new IsSingleInstance one. E.g.,

From:
```powershell
EXOMailTips Tips
{
  ...
  Organization = "contoso.com"
}
```

To:
```powershell
EXOMailTips Tips
{
  ...
  IsSingleInstance = 'yes'
}
```

## EXOTransportRule ([#4136](https://github.com/microsoft/Microsoft365DSC/issues/4136))

The Priority parameter used to be defined as a string data type. With this breaking change we are changing the data type to be an Integer. Remediation involves checking existing configuration files that include EXOTransportRule definitions and to make sure the parameters are numbers instead of string. This normally involves removing the double quotes around the value. E.g.,

From:
```powershell
EXOTransportRule MyRule
{
  ...
  Priority = "2"
}
```

To:
```powershell
EXOTransportRule MyRule
{
  ...
  Priority = 2
}
```

## SPOAccessControlSettings & SPOTenantSettings ([3576](https://github.com/microsoft/Microsoft365DSC/issues/3576))

These resources were both defining the same CommentsOnSitePagesDisabled parameter. This change ensures that the property is only defined in one resource, in occurence SPOTenantSettings. We've also move the SocialBarOnSitePagesDisabled parameter out of the SPOAccessControlSettings resource and into the SPOTenantSettings for consistency. In addition to these 2 changes, we've also removed the ConditionalAccessPolicy property from the SPOTenantSettings since it already existed in the SPOAccessControlSettings resource. To remediate to these breaking changes, users should:

* 1 - Check their configuration for SPOAccessControlSettings. If an instance is found:
  * a) Remove the CommentsOnSitePagesDisabled property from it, and make sure it is defined as part of the SPOTenantSettings resource instead.
  * b) Remove the SocialBarOnSitePagesDisabled property from it, and make sure it is defined as part of the SPOTenantSettings resource instead.
* 2 - Check their configuration for SPOTenantSettings. If an instance is found:
  * a) Remove the ConditionalAccessPolicy property and instead make sure it is only defined at the SPOAccessControlSettings resource level.
