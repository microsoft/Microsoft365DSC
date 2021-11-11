# Breaking Changes Policy

Microsoft 365 is under constant development, which means that functionalities are being added, deprecated or removed all the time. Microsoft365DSC has to adapt to these changes and at the same time make sure existing users and configurations are impacted as little as possible. That is why starting in 2021, we are adopting a formal process to handle breaking changes. The goal of this process is to provide a clear schedule, so that users of Microsoft365DSC are aware of any impact, any required actions and prepare themselves well in advance.

## What are Breaking Changes?

In the cases where a new resource is added, a resource gets a new optional parameter or a parameter that used to be mandatory becomes optional, existing configurations are not impacted. But when a resource or parameter is removed or an optional parameter becomes mandatory, existing configurations can stop functioning, because they are using these removed components. That is what is called a “Breaking Change”: A change that can break existing configurations and therefore impact the administration process of Microsoft 365.

## Release process

Microsoft365DSC relies on multiple other modules for connecting to Microsoft 365, which all can release updates at any time. If a change in any of these modules is released which results in a breaking change in Microsoft365DSC, we will update the module to write a verbose message notifying the administrator that the component (resource, parameter, etc) has become deprecated, is no longer being used and will be removed in a future version. A warning event will also be added to the event logs, allowing users to monitor deprecated events.

Twice a year we will release a version that bundles all breaking changes of the previous six months into a single version: **The first release of the month in April and October.**

The release notes of these versions will have all breaking changes clearly documented, including the required actions to take.

While it is still our recommendation to always use the latest version of the module for your operations, Breaking Changes Releases (BCR) will almost certainly mean that you will have to update your existing configurations or generate a new export. We understand that this may introduce challenges to our users which is why every BCR will be properly communicated and detailed information about how to address these breaking changes will be published in advanced on the official GitHub repository.

NOTE: Since releases are cumulative, all releases after that version will also have those changes included and will require the same updates to existing configurations.
