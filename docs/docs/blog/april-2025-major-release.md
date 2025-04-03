# Microsoft365DSC – April 2025 Major Release (version 1.25.402.1)

As defined by our [Breaking Changes Policy](https://microsoft365dsc.com/concepts/breaking-changes/), twice a year we allow for breaking changes to be deployed as part of a release. Our next major release, scheduled to go out on April 2nd 2025, will include several breaking changes and will be labeled version 1.25.402.1. This article provides details on the breaking changes and other important updates that will be included as part of our April 2025 Major release.

## AADPasswordRuleSettings - Updated the BannedPasswordCheckOnPremisesMode Accepted Values ([5966](https://github.com/microsoft/Microsoft365DSC/pull/5966))

To reflect and align with a change in the associated API, we are changing the possible value of the BannedPasswordCheckOnPremisesMode property from <strong>Enforced</strong> to <strong>Enforce</strong>. Existing configuration that use this resource, should check for that property and make sure that if the value is specified as Enforced, that it gets updated to Enforce.

## EXOArcConfig - Removed Identity Parameter ([#5917](https://github.com/microsoft/Microsoft365DSC/pull/5917))

This change removes the Identity property from the resource. The reason for this change is that the property is a tenant wide setting and always set to 'default'. To fix configuration files that define this parameter, simply find the EXOArcConfig entry and remove the Identity parameter entirely.

## EXOMailTips - Removed Resource ([5773](https://github.com/microsoft/Microsoft365DSC/pull/5773))

The EXOMailTups resource conflicted with the Mail tips related properties in the EXOOrganizationConfig resource. Because of this, it was removed to avoid conflicts. To fix configuration files, simply remove the EXOMailTips instance and ensure the settings you were initially setting via this resource and correctly specified as part fo the EXOOrganizationConfig resource.

## IntuneAccountProtectionLocalUserGroupMembershipPolicy - Removed the add_replace Deprecated Action ([#5790](https://github.com/microsoft/Microsoft365DSC/pull/5790))

In the IntuneAccountProtectionLocalUserGroupMembershipPolicy resource, the property LocalUserGroupCollection defines a list of accepted actions to be performed on the users' collection. This breaking change removes the deprecated add_replace action from the list of accepted value. To fix you configuration, simply make sure you replace all add_replace actions by one of the accepted value: add_update, remove_update or add_restrict.


## IntuneSecurityBaselineMicrosoftEdge  - Remove Deprecated auth_schemes Parameter ([#5789](https://github.com/microsoft/Microsoft365DSC/pull/5789))

The auth_schemes paremeter has been marked as deprecated for the past few releases and is now being removed from the IntuneSecurityBaselineMicrosoftEdge resource. To fix configuration files that are using this parameter, simply remove it from the file and recompile your MOF file.


