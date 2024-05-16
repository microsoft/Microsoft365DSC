# SCProtectionAlert

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **AlertBy** | Write | StringArray[] | Specifies the scope for aggregated alert policies | |
| **AlertFor** | Write | StringArray[] | This parameter is reserved for internal Microsoft use | |
| **AggregationType** | Write | String | Specifies how the alert policy triggers alerts for multiple occurrences of monitored activity | `None`, `SimpleAggregation`, `AnomalousAggregation`, `CustomAggregation` |
| **Category** | Write | String | Specifies a category for the alert policy | |
| **Comment** | Write | String | Specifies an optional comment | |
| **Disabled** | Write | Boolean | Enables or disables the alert policy | |
| **Ensure** | Write | String | Specify if this alert should exist or not. | `Present`, `Absent` |
| **Filter** | Write | String | The Filter parameter uses OPATH syntax to filter the results by the specified properties and values | |
| **Name** | Key | String | Specifies the unique name for the alert policy | |
| **NotificationCulture** | Write | String | Specifies the language or locale that's used for notifications. For example, da-DK for Danish | |
| **NotificationEnabled** | Write | Boolean | NotificationEnabled true or false | |
| **NotifyUserOnFilterMatch** | Write | Boolean | Specifies whether to trigger an alert for a single event when the alert policy is configured for aggregated activity | |
| **NotifyUserSuppressionExpiryDate** | Write | DateTime | Specifies whether to temporarily suspend notifications for the alert policy. Until the specified date-time, no notifications are sent for detected activities. | |
| **NotifyUserThrottleThreshold** | Write | UInt32 | Specifies the maximum number of notifications for the alert policy within the time period specified by the NotifyUserThrottleWindow parameter. Once the maximum number of notifications has been reached in the time period, no more notifications are sent for the alert. | |
| **NotifyUserThrottleWindow** | Write | UInt32 | Specifies the time interval in minutes that's used by the NotifyUserThrottleThreshold parameter | |
| **NotifyUser** | Write | StringArray[] | Specifies the SMTP address of the user who receives notification messages for the alert policy. You can specify multiple values separated by commas | |
| **Operation** | Write | StringArray[] | Specifies the activities that are monitored by the alert policy | |
| **PrivacyManagementScopedSensitiveInformationTypes** | Write | StringArray[] | PrivacyManagementScopedSensitiveInformationTypes | |
| **PrivacyManagementScopedSensitiveInformationTypesForCounting** | Write | StringArray[] | PrivacyManagementScopedSensitiveInformationTypesForCounting | |
| **PrivacyManagementScopedSensitiveInformationTypesThreshold** | Write | UInt64 | PrivacyManagementScopedSensitiveInformationTypesThreshold | |
| **Severity** | Write | String | specifies the severity of the detection | `Low`, `Medium`, `High`, `Informational` |
| **ThreatType** | Write | String | Specifies the type of activities that are monitored by the alert policy | `Activity`, `Malware`, `Phish`, `Malicious`, `MaliciousUrlClick`, `MailFlow` |
| **Threshold** | Write | UInt32 | Specifies the number of detections that trigger the alert policy within the time period specified by the TimeWindow parameter. A valid value is an integer that's greater than or equal to 3. | |
| **TimeWindow** | Write | UInt32 | Specifies the time interval in minutes for number of detections specified by the Threshold parameter. A valid value is an integer that's greater than 60 (one hour). | |
| **VolumeThreshold** | Write | UInt32 | Volume Threshold | |
| **Credential** | Write | PSCredential | Credentials of the Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

## Description

This resource configures a Protection Alert
in Security and Compliance Center.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - None

- **Update**

    - None

#### Application permissions

- **Read**

    - None

- **Update**

    - None

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        SCProtectionAlert 'CustomSuspiciousEmailSendingPatternDetected'
        {
            AggregationType         = "None";
            Category                = "ThreatManagement";
            Comment                 = "User has been detected as sending suspicious messages outside the organization and will be restricted if this activity continues. -V1.0.0.1";
            Credential              = $Credscredential;
            Disabled                = $False;
            Ensure                  = "Present";
            Name                    = "Custom Suspicious email sending patterns detected";
            NotificationEnabled     = $True;
            NotifyUser              = @("admin@contoso.com");
            NotifyUserOnFilterMatch = $False;
            Operation               = @("CompromisedWarningAccount");
            Severity                = "Medium";
        }

        SCProtectionAlert 'CustomEmailMessagesFromAcampaignRemovedAfterDelivery'
        {
            AggregationType         = "None";
            Category                = "ThreatManagement";
            Comment                 = "Emails messages from a campaign were delivered and later removed -V1.0.0.2";
            Credential              = $Credscredential;
            Disabled                = $False;
            Ensure                  = "Present";
            Filter                  = "(Mail.IsMailZAPSuccessful -eq 1) -and Mail.IsCampaignZapped -eq 1 -and (Mail.TenantPolicyFinalVerdictSource -ne 'PhishEdu') -and (Mail.TenantPolicyFinalVerdictSource -ne 'SecOps') -and (Mail.TenantPolicyFinalVerdictSource -ne 'ThirdPartyFiltering')";
            Name                    = "Custom Email messages from a campaign removed after deliveryâ€‹";
            NotificationEnabled     = $False;
            NotifyUser              = @("TenantAdmins");
            NotifyUserOnFilterMatch = $False;
            Severity                = "Informational";
            ThreatType              = "Malicious";
        }
    }
}
```

