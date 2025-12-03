
# IntuneDeviceEnrollmentStatusPageWindows10

## Description

Intune Device Enrollment Status Page Configuration for Windows10

**Please note:** If multiple resources are defined and they are not sorted by their priority increasing (meaning that the first resource e.g. has priority 2 and the next one has 1),
it is possible that the priority cannot be set correctly because not enough policies exist in the tenant.

To prevent this issue from happening, either define the resources with their priority increasing or use the `DependsOn` property to define a relation to the one that needs to be processed first.
