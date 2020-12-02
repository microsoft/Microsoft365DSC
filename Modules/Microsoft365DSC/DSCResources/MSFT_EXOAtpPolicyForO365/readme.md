# EXOAtpPolicyForO365

## Description

This resource configures the Advanced Threat Protection (ATP) policy
in Office 365.  Tenant must be subscribed to ATP.

## Parameters

Ensure

- Required: No (Defaults to 'Present')
- Description: `Present` is the only value accepted.
  Configurations using `Ensure = 'Absent'` will throw an Error!

IsSingleInstance

- Required: Yes
- Description: Single instance resource, the value must be 'Yes'

GlobalAdminAccount

- Required: Yes
- Description: Credentials of the Office 365 Global Admin

Identity

- Required: No
- Description: The Identity parameter specifies the ATP policy that you
  want to modify. There's only one policy namd Default.

AllowClickThrough

- Required: No
- Description: The AllowClickThrough parameter specifies whether to allow
  users to click through to the original blocked URL in
  Office 365 ProPlus. The default value is $true

BlockUrls

- Required: No
- Description: The BlockUrls parameter specifies the URLs that are
  always blocked by Safe Links scanning.
  You can specify multiple values separated by commas.

EnableATPForSPOTeamsODB

- Required: No
- Description: The EnableATPForSPOTeamsODB parameter specifies whether
  ATP is enabled for SharePoint Online, OneDrive for Business and
  Microsoft Teams. The default value is $false

EnableSafeDocs

- Required: No
- Description: The EnableSafeDocs parameter specifies whether to enable the
  Safe Documents feature in the organization.
  The default value is $false

EnableSafeLinksForO365Clients

- Required: No
- Description: The EnableSafeLinksForO365Clients parameter specifies whether Safe Links
  scanning is enabled for supported Office 365 desktop, mobile, and web apps.
   The default value is $true

TrackClicks

- Required: No
- Description: The TrackClicks parameter specifies whether to track user
  clicks related to blocked URLs. The default value is $false

## Example

```PowerShell
        EXOAtpPolicyForO365 AtpConfigExample {
            IsSingleInstance                = 'Yes'
            Ensure                          = 'Present'
            Identity                        = 'Default'
            GlobalAdminAccount              = $GlobalAdminAccount
            AllowClickThrough               = $true
            BlockUrls                       = @('test1.badurl.com','test2.badurl.com')
            EnableATPForSPOTeamsODB         = $true
            EnableSafeDocs                  = $false
            EnableSafeLinksForO365Clients   = $true
            TrackClicks                     = $true
        }
```
