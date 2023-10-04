# Microsoft365DSC – October 2023 Major Release (version 1.23.1004.1)

As defined by our [Breaking Changes Policy](https://microsoft365dsc.com/concepts/breaking-changes/), twice a year we allow for breaking changes to be deployed as part of a release. Our next major release, scheduled to go out on October 4th 2023, will include several breaking changes and will be labeled version 1.23.1004.1. This article provides details on the breaking changes and other important updates that will be included as part of our October 2023 Major release.

## EXODistributionGroup ([#3743](https://github.com/microsoft/Microsoft365DSC/pull/3743))

A new Identity parameter is now mandatory and a primary key for the resource. The Name property continues to be required, but no longer acts as a primary key. This change was put in place to prevent conflicts where we had two or more groups with the same name (even if they were of different type).

## AADEntitlementManagementAccessPackageAssignmentPolicy - CustomExtensionID Parameter Type Change ([#3692](https://github.com/microsoft/Microsoft365DSC/pull/3692))

The property type for the CustomExtensionID parameter has changed from being an embeded CIMInstance of Type 'MSFT_MicrosoftGraphcustomaccesspackageworkflowextension' to being a String. To remediate to this in existing configuration, the recommendation is to either retake a configuration snapshot of this resource using the latest version of the solution or to manually fix the parameter's value while refering to the official documentation.
