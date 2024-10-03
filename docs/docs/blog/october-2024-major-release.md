# Microsoft365DSC – OCtober 2024 Major Release (version 1.24.1002.1)

As defined by our [Breaking Changes Policy](https://microsoft365dsc.com/concepts/breaking-changes/), twice a year we allow for breaking changes to be deployed as part of a release. Our next major release, scheduled to go out on October 2nd 2024, will include several breaking changes and will be labeled version 1.24.1002.1. This article provides details on the breaking changes and other important updates that will be included as part of our October 2024 Major release.

## EXOMailTips - Removal of the Ensure Parameter ([#4823](https://github.com/microsoft/Microsoft365DSC/pull/4823))

The EXOMailTips resource manages a tenant wide setting where only one instance can ever exist. Therefore, the Ensure parameter has been removed from the resource. In order to fix your baseline, search for any EXOMailTips entry and remove the Ensure parameter from the configuration file.

## EXOAntiPhishPolicy - Changed PhishThresholdLevel to Integer ([#4687](https://github.com/microsoft/Microsoft365DSC/pull/4687/))

The PhishThresholdLevel property of the EXOAntiPhishPolicy resource was incorrectly defined as a string. In this major release, the parameter type will change from String to Int32. In order to fix your baseline, search for the PhishThresholdLevel property and make sure you update the type to be an integer (e.g., remove quotes around the level value).

## TeamsComplianceRecordingPolicy - Added Complex type for ComplianceRecordingApplications ([3754](https://github.com/microsoft/Microsoft365DSC/pull/3754))

The ComplianceRecordingApplications parameter of the TeamsComplianceRecordingPolicy resource was changed from being a string array to being an array of CIMInstances (complex types). There are unfortunately no direct ways to update existing configurations. Instead, make sure you search for the ComplianceRecordingApplications property in your config and update the entries to match the CimInstances definition.

e.g.,
```Powershell
ComplianceRecordingApplications                     = @(
    MSFT_TeamsComplianceRecordingApplication{
        Id = '00000000-0000-0000-0000-000000000000'
        ComplianceRecordingPairedApplications = @('00000000-0000-0000-0000-000000000000')
        ConcurrentInvitationCount = 1
        RequiredDuringCall = $True
        RequiredBeforeMeetingJoin = $True
        RequiredBeforeCallEstablishment = $True
        RequiredDuringMeeting = $True
    }
    MSFT_TeamsComplianceRecordingApplication{
        Id = '12345678-0000-0000-0000-000000000000'
        ComplianceRecordingPairedApplications = @('87654321-0000-0000-0000-000000000000')
        ConcurrentInvitationCount = 1
        RequiredDuringCall = $True
        RequiredBeforeMeetingJoin = $True
        RequiredBeforeCallEstablishment = $True
        RequiredDuringMeeting = $True
    }
);
```
