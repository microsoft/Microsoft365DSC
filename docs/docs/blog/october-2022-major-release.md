# Microsoft365DSC – October 2022 Major Release (version 1.22.1005.1)

As defined by our [Breaking Changes Policy](https://microsoft365dsc.com/concepts/breaking-changes/), twice a year we allow for breaking changes to be deployed as part of a release. Next week’s release, scheduled to go out on October 5th 2022, will include several breaking changes and will be labeled version 1.22.1005.1. This article provides details on the breaking changes that will be included as part of our October 2022 Major release.

## Application Secret is Changing Type
All resources that support the ApplicationSecret authentication parameter will be updated so that the parameter becomes of type PSCredential instead of String. Currently, the ApplicationSecret parameter is being treated as a normal text string across all resources that implement it (e.g., AAD, EXO, Intune, SPO, etc.). When Desired State Configuration (DSC) is compiled as a Managed Object Format (MOF) file, string parameters are stored as plaintext, which introduces security risks where anyone who gets their hands on such a MOF file, could retrieve the ApplicationSecret of a given Application Registration and authenticate against the tenant. By changing its parameter type to PSCredential, we ensure that the parameter will get encrypted in the MOF file (when a certificate is used), which prevents malicious users from getting their hands on the plaintext secret.

![image](https://user-images.githubusercontent.com/2547149/193338708-fb15ca12-0c63-4858-86df-919eb578a76c.png)

We have modified the export logic across all M365DSC resources so that it properly handles the extraction of the Application Secret parameter. It will now extract it as an inline PSCredential object and will default the username component to "ApplicationSecret". **Note:** the username component can be set to any value, only the SecureString Password piece will be used to authenticate.
When doing an export of a tenant's configuration using ApplicationSecret authentication, M365DSC will continue to pull the secret's value from the associated ConfigurationData.psd1 file, but will automatically convert it to a PSCredential object within the configuration.

![image](https://user-images.githubusercontent.com/2547149/193338781-b2142127-49fb-4d8e-b7bf-cad15d27c263.png)

In order to update your existing configuration files to leverage this new, more secure version of Microsoft365DSC, you simply have to do a find and replace all instances of the ApplicationSecret within your file to use this new definition.

**Before version 1.22.1005.1:**
```
ApplicationSecret = $ConfigurationData.NonNodeData.ApplicationSecret;
```

**Starting with version 1.22.1005.1:**
```
ApplicationSecret = New-Object System.Management.Automation.PSCredential ('ApplicationSecret', (ConvertTo-SecureString $ConfigurationData.NonNodeData.ApplicationSecret -AsPlainText -Force));
```

## O365User is now AADUser
The O365User resource was one of the very first resource to be released as part of Microsoft365DSC back in 2018, back when the scope of the project didn't include Azure Active Directory. To avoid confusion moving forward, we are renaming the O365User resource to AADUser. On top of this, we are also introducing support for AAD role assignment to the resource. Users can update their current configurations by simply replacing all instances of the word O365User to AADUser in their existing configurations

## Removing Deprecated Parameters from EXOATPPolicyForO365
For the past few releases, the following properties of the EXOATPPolicyForO365 resource have been marked as deprecated:

*	AllowClickThrough
*	BlockURLs
*	EnableSafeLinksForO365Clients
*	TrackClicks

As part of the 1.22.1005.1 release this parameter have been removed from the resource. To update existing configurations, simply search for these parameters and remove them from your desired state configuration files.

## IntuneDeviceConfigurationPolicyiOS get a new MediaContentRating type
We've updated the IntuneDeviceConfigurationPolicyiOS resource's MediaContentRating locale parameters to now be of type CIMInstance instead of String. This allows you to specify Move and TV ratings independently of one another.

![image](https://user-images.githubusercontent.com/2547149/193338958-71dfc545-f971-4dcb-ad57-9e9cda6e8d06.png)

Updating existing configurations that leveraged the string based properties will require you to rewrite the properties values following the format shown in the screen capture above.

## SCSensitivityLabel - Renaming the Settings Parameter to LabelSettings
Settings is a reserved keyword in PowerShell and is causing issues when trying to generate reports if present. We are renaming this parameter to LabelSettings to ensure it doesn't get threated as a reserved keyword by the reporting and assessments engine. In order to update your existing configurations, simply rename the Settings property to LabelSettings in each instance of the SCSensitivityLabel resource.
