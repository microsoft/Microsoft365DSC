# TeamsAppSetupPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Unique identifier to be assigned to the new Teams app setup policy. Use the 'Global' Identity if you wish to assign this policy to the entire tenant. | |
| **Description** | Write | String | Enables administrators to provide explanatory text to accompany a Teams app setup policy. | |
| **AppPresetList** | Write | StringArray[] | Choose which apps and messaging extensions you want to be installed in your users' personal Teams environment and in meetings they create. Users can install other available apps from the Teams app store. | |
| **AppPresetMeetingList** | Write | StringArray[] | Choose which apps and meeting extensions you want to be installed in your users' personal Teams environment and in meetings they create. Users can install other available apps from the Teams app store. | |
| **PinnedAppBarApps** | Write | StringArray[] | Pinning an app displays the app in the app bar in Teams client. Admins can pin apps and they can allow users to pin apps. Pinning is used to highlight apps that are needed the most by users and promote ease of access. | |
| **PinnedMessageBarApps** | Write | StringArray[] | Apps are pinned in messaging extensions and into the ellipsis menu. | |
| **AllowUserPinning** | Write | Boolean | If you turn this on, the user's existing app pins will be added to the list of pinned apps set in this policy. Users can rearrange, add, and remove pins as they choose. If you turn this off, the user's existing app pins will be removed and replaced with the apps defined in this policy. | |
| **AllowSideLoading** | Write | Boolean | This is also known as side loading. This setting determines if a user can upload a custom app package in the Teams app. Turning it on lets you create or develop a custom app to be used personally or across your organization without having to submit it to the Teams app store. Uploading a custom app also lets you test an app before you distribute it more widely by only assigning it to a single user or group of users. | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

Manages Teams app setup policies in your tenant.

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

    - Organization.Read.All

- **Update**

    - Organization.Read.All

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
        TeamsAppSetupPolicy "TeamsAppSetupPolicy-TestPolicy"
        {
            AllowSideLoading     = $True;
            AllowUserPinning     = $True;
            AppPresetList        = "com.microsoft.teamspace.tab.vsts";
            Credential           = $Credscredential;
            Description          = "My test policy";
            Ensure               = "Present";
            Identity             = "Test Policy";
            PinnedAppBarApps     = @("14d6962d-6eeb-4f48-8890-de55454bb136","86fcd49b-61a2-4701-b771-54728cd291fb","2a84919f-59d8-4441-a975-2a8c2643b741","ef56c0de-36fc-4ef8-b417-3d82ba9d073c","20c3440d-c67e-4420-9f80-0e50c39693df","5af6a76b-40fc-4ba1-af29-8f49b08e44fd");
        }
    }
}
```

