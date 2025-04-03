
# IntuneDeviceEnrollmentPlatformRestriction

## Description

This resource configures the Intune device platform enrollment restrictions.

### Restrictions

After deploying the configuration, updating the policies is no longer possible. This is a restriction by the Microsoft Graph API. Any further updates to the policies have to be done using the Intune Portal. 

**Be aware**: To deploy a Android platform restriction policy, two individual configurations must exist:

* The first one contains the key for `AndroidRestriction`
* The second one contains the key for `AndroidForWorkRestriction`
