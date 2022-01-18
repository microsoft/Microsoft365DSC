This article is a complete guide to installing, deploying and using Microsoft365DSC. Microsoft365DSC is an open-source solution that’s available for free on <a href='https://github.com/Microsoft/Microsoft365DSC'>GitHub</a>. It is led by Microsoft engineers and maintained by the community. Official documentation for the solution is available on the official site at <a href="https://Microsoft365DSC.com">https://Microsoft365DSC.com</a>. Microsoft365DSC is the declarative form of Microsoft 365 tenant’s configuration. It is to the Microsoft 365 environment what Azure Resource Manager templates (ARM) are to Azure.  It allows you to represent your tenant’s configuration-as-code using <a href="https://docs.microsoft.com/en-us/powershell/dsc/overview/dscforengineers?view=dsc-1.1">PowerShell Desired State Configuration (DSC)</a>, use it to automatically configure your Microsoft tenants in the described state, take snapshots of existing tenants into DSC declarative code, generate reports out of those snapshots, continuously monitor all your Microsoft 365 tenants for configuration drifts and be alerted when drifts are detected, clone the configuration of an existing tenant onto another and compare the configuration between one or multiple tenants.

# Prerequisites
Microsoft365DSC is supported for PowerShell version 5.1 and 7.1. Support for newer versions of PowerShell is not yet offered since these have now decoupled the DSC engine into its own separate module and require additional work from the team. It is however on the roadmap as a priority item for the later part of Calendar Year of 2022.

To get the best experience, it is recommended that you use the <a href="https://www.microsoft.com/en-ca/p/windows-terminal/9n0dx20hk701?activetab=pivot:overviewtab">Windows Terminal</a> to run and execute Microsoft365DSC. All screenshots provided in this article are using the Windows Terminal. This tool allows you to quickly switch between PowerShell versions and provide better support for icons and symbols that are used throughout Microsoft365DSC’s experience.

## Microsoft Graph Permissions
Most components of the Microsoft365DSC solution are using the Microsoft Graph PowerShell SDK under the cover to authenticate and interact with Microsoft 365. By default, if you are using Microsoft365DSC without using your own Azure Active Directory application instance, the tool will automatically use the Microsoft Graph PowerShell application instance to authenticate.

 ![image](https://user-images.githubusercontent.com/2547149/149792907-fb23e825-d1a5-4391-b67d-3e13e576dbd8.png)

In order to be able to interact with these components, you need to grant your application or the Microsoft Graph PowerShell one the proper permissions against the Microsoft Graph scope. To determine what permission what permissions are required by a given component that uses Microsoft Graph, you can use the **Get-M365DSCCompiledPermissionList** cmdlet and pass in the list of parameters for which you wish to grant permissions for.

 ![image](https://user-images.githubusercontent.com/2547149/149797417-379d8590-852d-4888-85f7-3b0f7bf7460f.png)

Doing so will return an object with two properties. The ReadPermissions property contains a list of the minimal permissions that need to be granted for the app to be able to read information about the selected components. These are the permissions you want to grant if you are taking a snapshot of the configuration of an existing tenant. The second property, UpdatePermissions, contains the minimal permissions required to interact with and configure the selected components. You will need to grant your application these permissions if you are trying to apply a configuration onto a tenant.

If you are trying to interact with all available components in Microsoft365DSC, you can get a complete picture of all permissions required across all resources by running the following line of PowerShell.

```
Get-M365DSCCompiledPermissionList -ResourceNameList (Get-M365DSCAllResources)
```
![image](https://user-images.githubusercontent.com/2547149/149797453-3f7ea11c-f7d3-4431-b65f-2fe1ab815871.png)

The **Get-M365DSCAllResources** cmdlet will return a list of all components available inside of the Microsoft365DSC solution which will then by passed in the Get-M365DSCCompiledPermissionList cmdlet which will compile the resulting permissions needed for the list of components it receives, in occurrence all of them. These permissions need to be granted to your application instance, either using the Azure portal or automating the process via PowerShell.

We provide an easy way of consenting permissions to the Microsoft Graph PowerShell application in your tenant with the **Update-M365DSCAllowedGraphScopes** cmdlet. This cmdlet accepts either a list of components to grant the permissions for or can grant it for all resources if the **-All** switch is used. You also need to specify what type of permissions, Read or Update, you wish to grant it using the **-Type** parameter.

![image](https://user-images.githubusercontent.com/2547149/149797611-409a38ae-953e-4fc4-9751-4183c7ad7497.png)

Executing the cmdlet will prompt you to authenticate using an administrator account that has access to consent permissions to Azure AD applications in your environment.

# How to Install
While the source code of the solution is open-sourced on GitHub at https://GitHub.com/Microsoft.Microsoft365DSC, the releases of the solutions are being published to the <a href="https://www.powershellgallery.com/packages/Microsoft365DSC/">PowerShell Gallery</a>. This means that the tool can be installed onto any machine by running the following command:
```
Install-Module Microsoft365DSC -Force
```
 ![image](https://user-images.githubusercontent.com/2547149/149797724-c4f87cc1-2fa1-4812-81ef-c31c69c26376.png)

Executing this command can take a minute or two. Microsoft365DSC depends on several other modules to function properly. For example, it uses the <a href="https://www.powershellgallery.com/packages/MSCloudLoginAssistant/">MSCloudLoginAssistant</a> module to delegate all authentication logic to the various workloads, it leverages a dozen <a href="https://www.powershellgallery.com/packages?q=Microsoft.Graph">Microsoft Graph PowerShell module</a> to interact with various configuration settings, etc. Newer versions of Microsoft365DSC no longer download all the required prerequisites by default. When you install the Microsoft365DSC, you only get the core components. It is our recommendation that you run the following command to update all dependencies on the system after installing the module:

```
Update-M365DSCDependencies
```
 ![image](https://user-images.githubusercontent.com/2547149/149797877-bb59cb8b-6d39-4f14-8912-ca2a1f1ea851.png)

Running the above command will automatically read the list of dependencies from the [root]/Dependencies/Manifest.psd1 file, check to see if they are installed on the machine with the proper version, and if not it will automatically download them and install them from the PowerShell Gallery.

Depending on your configuration and on the version of PowerShell you are using, the installed modules may be put in different locations. The process of installing a PowerShell module from the PowerShell Gallery really just comes down to downloading the files from the gallery as a zip, extracting them and copying to a location on the system that is associated with PowerShell via environment variables. The following command will allow you to view the version of any given PowerShell module on a system along with its associated version:
```
Get-Module Microsoft365DSC -ListAvailable | select ModuleBase, Version
```
 ![image](https://user-images.githubusercontent.com/2547149/149798129-051dba57-95b8-4916-8109-5d5445fd0737.png)

# Authentication
It is also very important for users to understand the authentication process of Microsoft365DSC. The solution supports connecting to the various workloads for either applying the configuration, monitoring it for configuration drifts or taking a snapshot of an existing configuration. It supports authenticating using either a set of credentials for a user, to use a Service Principal by specifying parameters such as an Azure Active Directory (AD) Application ID, or a combination of both.

The recommendation is to use Service Principal whenever possible because it offers the most granular levels of security and doesn’t introduce the risk of having to send high privileged credentials across the wire to authenticate. However, not all workloads supported by Microsoft365DSC are currently able to handle Service Principal authentication. Currently, the Security and Compliance and Microsoft Teams workload unfortunately do not support authenticating using the Service Principal of an Azure Active Directory Application. The following picture gives you an overview of what authentication mechanisms are supported by each workload and what underlying module is being used to authenticate for each.
 ![image](https://user-images.githubusercontent.com/2547149/149798164-6e95848a-9405-40f5-aa3c-dc0063ba02d3.png)

As you can see from the picture above, Credentials while being the least preferred option for security reasons, is the only option that works across all supported workloads. It is also important to clarify the difference between the Teams and the Skype for Business Online entries in the picture above. If we take a look a few months back, to manage Microsoft Teams using PowerShell you needed two different modules: one for the collaboration part of Microsoft Teams (the MicrosoftTeams PowerShell module) and one for the Skype For Business components (SkypeOnlineConnector). While the collaboration aspect of Teams, which includes Teams and Channels is accessible through Service Principal authentication, other components such as all Teams administrative policies are still only available through the Skype for Business part of the new combined MicrosoftTeams module and therefore don’t work with service principal authentication.

We are having discussions with the various product groups that are responsible for these PowerShell modules inside of Microsoft to have better consistency across all workloads on how to authenticate. Items highlighted in green in the table above, are workloads for which we use the <a href="https://github.com/microsoftgraph/msgraph-sdk-powershell">Microsoft Graph PowerShell SDK</a> to authenticate against. Our plan is to update the underlying logic of every component inside of Microsoft365DSC to leverage that SDK as new APIs become available on Microsoft Graph.

It is possible for a configuration to use a mix of credentials and Service Principals to authenticate against the various workloads. For example, if you decide to keep a master configuration for all of you tenant’s configuration, you could have Azure AD components use the Service Principal of an app you’ve created to authenticate, and further down in the configuration have your Security and Compliance components use credentials. That approach is perfectly fine, but we’d recommend to try and split different workloads across different configuration files in this case to make it easier to manage.

It is also important to note that we’ve added logic inside of the command that allows you to take a snapshot of your current’s tenant configuration to warn you when the components you are trying to capture can’t be accessed based on the authentication model you’ve selected. For example, if you are trying to take a snapshot of both Azure AD and Security and Compliance components, but are authenticating using a Service Principal, the tool will warn you that the Security and Compliance components can’t be captured and that they will be ignored. In this case, the resulting capture would only contain the Azure AD components because those are the only ones the tool can get access to using Service Principal.
![image](https://user-images.githubusercontent.com/2547149/149798269-70a82229-f8c9-4645-bf57-5419b721ea92.png)

# Taking a Snapshot of Existing Tenant
The first thing that most folks using the solution will want to do is take a snapshot of an existing tenant they have access to and that they are familiar with. As soon as you install the Microsoft365DSC module on a system, it will automatically get access to run the **Export-M365DSCConfiguragtion** PowerShell cmdlet which is the main command for initiating a snapshot of an existing configuration. In previous versions of the module, simply running the above cmdlet would automatically launch a Graphical User Interface that would allow you to pick and choose the components you wanted to capture the configuration for as part of your snapshot and initiate the capture process. Newer versions of the module have moved to an unattended process by default, meaning that running the cmdlet will expect additional parameters by default and will then attempt to initiate the snapshot process automatically without further human interaction.

Initiating the snapshot process via the **Export-M365DSCConfiguration** cmdlet will begin by authenticating against all required workloads. The first thing it will do is compile a list of all components it is about to capture and figure out what workload they are part of. Then it will automatically authenticated against each one using the authentication parameters provided.

## Web Based User Interface
While the default process has changed with recent versions of the module, you can still use a newly revamped, web-based User Interface to help you build the PowerShell command to execute based on the components you wish to capture. To launch this new web interface, simply use the **-LaunchWebUI** switch when calling the Export-M365DSCConfiguration cmdlet. This will automatically launch a new web browser interface and navigate you to https://Export.Microsoft365DSC.com
![image](https://user-images.githubusercontent.com/2547149/149798448-3a01db84-3a6e-4a97-9d65-11bfcaca20eb.png)


From the interface, simply select the components you want, and click on the **Generate** button at the top right. This will open a new prompt that will allow you to copy the PowerShell command you need to run to capture a snapshot of the selected components via Microsoft365DSC. Simply copy this command and paste it in your PowerShell console to initiate the capture process.
![image](https://user-images.githubusercontent.com/2547149/149798483-d8dac9ea-5498-4870-ab60-be497111e92e.png)


## Unattended Capture
As mentioned above, Microsoft365DSC now defaults to an unattended capture process when running the Export-M365DSCConfiguration cmdlet. To quickly get started, simply open a new PowerShell console and type in the cmdlet. By default, if you don’t provide any additional parameters to the cmdlet, it will try to use credentials to authenticate against the various workloads. In the case where no additional authentication parameters are provided, Microsoft365DSC will prompt you for credentials and will use those credentials to authenticate throughout the capture process.

  ![image](https://user-images.githubusercontent.com/2547149/149798516-916a822a-242e-4288-b1d9-f24b1812ed3c.png)![image](https://user-images.githubusercontent.com/2547149/149798528-b8580be6-62c6-4ce0-9193-2f928f4f3791.png)

You could always pass in the credentials in as a variable, which will bypass the credential prompt and automatically initiate the export process when calling the cmdlet.
E.g.

```
$creds = Get-Credential
Export-M365DSCConfiguration -Credential $creds
```
 
 ![image](https://user-images.githubusercontent.com/2547149/149798704-328e8355-fafc-4748-a277-1224009b0515.png)

The same process applies if you are trying to authenticate using a Service Principal. In this case you would need to pass in the ApplicationID and TenantID parameter and decide whether to use an ApplicationSecret or a CertificateThumbprint.
 ![image](https://user-images.githubusercontent.com/2547149/149798742-569902f8-84fa-4360-82e7-fcb334f69b5d.png)
![image](https://user-images.githubusercontent.com/2547149/149798752-7335cc56-d09a-485d-8408-9ff12ebd89f6.png)


It is important to understand that the resulting file that contains the captured configuration will also implement the same authentication mechanism used by the capture process. For example, if you used credentials to capture the configuration, the resulting file will contain logic to capture credentials when it gets executed and every component it defines will also implement the **Credential** parameter.
![image](https://user-images.githubusercontent.com/2547149/149798788-d9e1f08b-6e18-46d3-b9ca-652c6c1a18bf.png)


In comparison, if you used a Service Principal to do the export, the resulting file will implement logic to receive information about the Azure AD application instance to use and every component defined within the file will as well.
  ![image](https://user-images.githubusercontent.com/2547149/149798810-9e7ba15d-e8ae-4f64-8340-e4e950ef31cf.png)

As we can see from the image above, the Service Principal fields' values are coming from the Configuration Data file that also get stored along the configuration file during the snapshot process. If you take a look at the folder where the resulting files were stored, you should see a file named ConfigurationData.psd1. This is where the value for the parameters above are defined.
![image](https://user-images.githubusercontent.com/2547149/149798970-fff1404b-6f48-4186-8acb-30299816de9d.png)


It is also important to note, the resulting file will always contain random GUID for the name of the resources in the DSC configuration. These are random and are only used to ensure we don’t have resource naming conflicts inside the configuration. They can be replaced by anything meaningful, as long as you don’t have two components of the same resource type named the same across your configuration. Names are meaningless in the world of DSC and are only used as a primary key when compiling your configuration.
 ![image](https://user-images.githubusercontent.com/2547149/149799004-4e57c166-df00-4b43-a554-add1f03dee3e.png)

## Available Parameters
The Microsoft365DSC tenant's configuration snapshot feature offers several options you can use to better control the output capture. This section provides an overview of each additional parameter that is available for the **Export-M365DSCConfiguration** cmdlet and how they can be used during the capture process

### LaunchWebUI
As mentioned above, the moment this switch is present when calling the Export-M365DSCConfiguration cmdlet it will launch new browser window and navigate to the export user interface at https://export.microsoft365dsc.com.

### FileName
This allows you to specify how you wish the resulting file to be named. Specify the name of the file, including the extension (e.g. .ps1).
 ![image](https://user-images.githubusercontent.com/2547149/149799116-4942a0e9-4865-48be-a32e-7de683ea9264.png)

Omitting to specify this parameter will name the resulting file as M365TenantConfig.ps1

### ConfigurationName
This parameter allows you to specify how the DSC configuration object, inside of the exported configuration file will be named.
 ![image](https://user-images.githubusercontent.com/2547149/149799157-cb03fb1e-d3b6-4a39-b33c-959b1e3ccbde.png)

Omitting to specify this parameter will result in the configuration object to be named as the file’s name (e.g. M365TenantConfig).

### Path
Specifies the location where the resulting file will be stored. Omitting to specify this parameter will prompt the user to provide the destination path at the end of the capture process.
 ![image](https://user-images.githubusercontent.com/2547149/149799199-5f8e454b-9d05-42da-9a7c-5a22cf39fe46.png)

### Components
This parameter accepts an array containing the names of the components you want to capture as part of your snapshot. Omitting this parameter will default the capture process to capture all components that are part of the default components list (see parameter Mode).
 ![image](https://user-images.githubusercontent.com/2547149/149799217-4f2c2bf8-1ceb-4e6c-a9a4-d8d989c1a05a.png)

### Workloads
This component accepts an array containing the names of various workloads you wish to capture the components for as part of your snapshot process.  Users need to specify the acronym of the workloads, which can be any of:
* **AAD** – Azure Active Directory
* **EXO** – Exchange Online
* **O365** – Office 365 administration
* **Intune** – Intune
* **OD** – OneDrive
* **Planner** – Planner
* **PP** – Power Platform
* **SC** – Security and Compliance
* **SPO** – SharePoint Online
* **Teams** – Microsoft Teams
 ![image](https://user-images.githubusercontent.com/2547149/149799340-8019c321-5115-4edd-8c2e-d98588fb09bb.png)

By default, specifying a workload will only export components that are part of the default component list (see Mode). If you want to capture every component available for a given workload, you will need to combine this parameter with **-Mode Full**.

### Mode
This parameter allows users to specify what set of components they wish to capture as part of their snapshot process. By default, Microsoft365DSC will exclude some components from the capture process either because these are likely to take a very long time to export (e.g. SPOPropertyBag) or that they are more related to data than actual configuration settings (e.g. Planner Tasks, SPOUserProfileProperty, etc.). Available modes are:
* Lite
* Default
* Full
And off course, omitting to specify this parameter will default to the **default** mode.
To keep track of what resources are available in what mode, Microsoft365DSC defines two global variables which contain the list of resources unique to this extraction mode: **$Global:DefaultComponents** and **$Global:FullComponents**
![image](https://user-images.githubusercontent.com/2547149/149799484-cda8c84e-971e-446a-b247-b58c40f08a6a.png)


This means that the **Lite** extraction mode will contain all resources with the exception of those listed in Default and Full. The **Default** mode will include all resources from the Lite mode, plus the SPOApp and SPOSiteDesign components, and **Full** will include every resource available in the project.

### MaxProcesses
There are a few components inside of Microsoft365DSC for which parallelism has been implemented as part of their snapshot process to improve speed. This parameter allows user to specify how many parallel threads should be created during the capture process. Components leveraging parallelism are: SPOPropertyBag, SPOUserProfileProperty and TeamsUser. The specified value for this parameter has to be between **1** and **100**. Instances of the components will be equally divided amongst the various threads.
 ![image](https://user-images.githubusercontent.com/2547149/149799619-509d7526-eba0-4ccc-b028-aeb012a2275a.png)
![image](https://user-images.githubusercontent.com/2547149/149799632-06ae6b61-4bbc-4cf8-8102-1c008d805205.png)

While there are advantages to implementing multithreading for the snapshot process, there are many disadvantages as well such as not being able to properly view ongoing progress inside threads and added complexity to the design of the resources. After weighting in the pros can cons of implementing this approach across all components to speed up the entire capture process, we’ve opted to keep the design of the resources simpler (no use parallelism) for maintenance purposes and to ensure users have a consistent way of view progress during the snapshot process.

### GenerateInfo
This parameter allows users to specify whether or not comments should be added as part of the exported file to provide additional information about the various types of components captured.
 ![image](https://user-images.githubusercontent.com/2547149/149799667-9cfc5e09-c7c4-460e-979e-3c3f1129abc2.png)

# Deploying Configurations
This section explains how you can take a Microsoft365DSC configuration file you’ve written (or captured using the snapshot feature) and apply the settings it defines onto a Microsoft 365 tenant. It is very important to understand that at this stage, we are using PowerShell Desired State (DSC) out-of-the-box and that the process of applying a DSC configuration is not something specific to Microsoft365DSC.

## Compiling and Validating the Configuration
The first step in trying to deploy a DSC configuration is to compile the configuration file into what we call a Managed Object Format (MOF) file. To do so, simply execute the .ps1 file that contains your configuration. The process of compiling your configuration will also perform some level of validation on the configuration such as ensuring that every component defined in the file has all of their mandatory parameters defined and that there are no typos in components or property names. If the compilation process is successful, you should see a mention that the .mof file was created. This file gets created in the same location where your configuration file is located by default and will create a new folder based on the name of the configuration object defined within your file.
 ![image](https://user-images.githubusercontent.com/2547149/149799734-204e64d7-19d5-4f5b-a62c-90fcb04213a0.png)
![image](https://user-images.githubusercontent.com/2547149/149799745-ff76dcc4-a4d4-4c43-8f76-9f29873e5d18.png)![image](https://user-images.githubusercontent.com/2547149/149799755-5880b2c7-545a-45c5-b4d7-36c99ecaff31.png)


# Securing your Compiled Configuration
In the case where you are using credentials to authenticate to your tenant, you will be prompted to provide credentials at compilation time for your configuration. By default, these credentials will be stored as plain text in the resulting MOF file, which is a big security concern.

![image](https://user-images.githubusercontent.com/2547149/149799792-6656a848-cc46-487c-9c77-a141aec63e30.png)


To remediate to this, PowerShell DSC lets us use an encryption certificate to encrypt information about credentials in the MOF files. To make this process easier for users, Microsoft365DSC defines a function named **Set-M365DSCAgentCertificateConfiguration** which will automatically generate an encryption certificate and configure the PowerShell DSC engine on the system to use it for encrypting the MOF files. The cmdlet will return the Thumbprint for the newly generated certificate.

![image](https://user-images.githubusercontent.com/2547149/149799811-a6f64a8b-bcb8-4cdc-8c80-d7d68849ea25.png)

You can also have the cmdlet generate the private key for the certificate by using the **-GeneratePFX** switch and specifying a password with the **-Password** parameter. This will require you to also specify the **-ForceRenew** parameter so that a brand new certificate gets emitted.

![image](https://user-images.githubusercontent.com/2547149/149799898-7a5b36ad-634a-41c3-aaa3-abc1ca7d8848.png)

Once the certificate has been configured every time you do a snapshot of an existing tenant’s configuration, a new M365DSC.cer certificate file will be stored in the same repository as the configuration files. The ConfigurationData.psd1 will also contain a new entry under the localhost node that will point to this certificate, effectively telling DSC to use this file to encrypt credentials when compiling.

 ![image](https://user-images.githubusercontent.com/2547149/149799919-7b594207-f435-491d-a424-c3f15447294c.png)

If you compile your configuration using the new certificate and take a look at your MOF file, you should see that the password for the credential object was successfully encrypted and is no longer showing in plaintext.

 ![image](https://user-images.githubusercontent.com/2547149/149799949-163c0ba6-8bd9-4ec5-acab-9597ae77966f.png)

## Deploying the Configuration
To initiate the deployment of a configuration onto a Microsoft 365 tenant, you need to use the out-of-the-box cmdlet provided by PowerShell DSC named **Start-DSCConfiguration**. By default, this cmdlet will execute as a background job. If you wish to monitor the execution of the process, you need to use the **-Wait** switch, which will make the process synchronous. We also recommend using the **-Verbose** switch with the command to get additional details on the progression of the process. The cmdlet takes in the path to the folder that contains the compiled .MOF file.

e.g.
```
Start-DSCConfiguration C:\DemoM365DSC\M365TenantConfig -Wait -Verbose -Force
```

Executing the cmdlet will automatically authenticate against the affected workload using the authentication parameters provided at compilation time and will apply the configuration settings defined in the file.
 ![image](https://user-images.githubusercontent.com/2547149/149800095-28010b6b-8b7c-4c2b-85fd-f0614294fb50.png)

It is normal for this process to take several minutes if not hours to complete, based on how many components are defined in your configuration. It is important to understand that once the configuration completes its deployment, this will configure the PowerShell DSC engine on the current system to due frequent checks against your Microsoft 365 tenant to check for configuration drifts. By default, the engine will wake up every 15 minutes (minimum value possible). For more details on how to configure this, please refer to <a href="https://docs.microsoft.com/en-us/powershell/dsc/managing-nodes/metaconfig?view=dsc-1.1">Configuring the Local Configuration Manager</a>. If you simply want to apply the configuration on the tenant as a one off and prevent the system form doing frequent checks for configuration drifts, you can remove the configuration you’ve applied from memory by running the following PowerShell commands:
```
Stop-DSCConfiguration -Force
Remove-DSCConfigurationDocument -Stage Current
```
 ![image](https://user-images.githubusercontent.com/2547149/149800178-ea830872-446a-4e97-9cda-068d9eef7266.png)

# Monitoring for Configuration Drifts
Once a configuration has been applied to a Microsoft 365 tenant using Microsoft365DSC, the local system will perform regular checks to analyze the configuration of the remote tenant against what its desired state should be and detect any configuration drifts. This feature comes from PowerShell DSC out-of-the-box and is not something specific to Microsoft365DSC. By default the DSC engine on the system where the configuration was applied from will check for configuration drifts every 15 minutes. If a drift in configuration is detected, it will log it in Event Viewer on the machine by default. Detected drifts will get logged under the **M365DSC** log journal in Event Viewer. Microsoft365DSC provide very detailed entries in event viewer that help you identify exactly in what component a drift was detected as well as what property was detected to have drifted.
 ![image](https://user-images.githubusercontent.com/2547149/149800220-a67f31ef-3cc3-46bd-b462-3099ce0c89d6.png)

Just like for any DSC module, you can also configure the DSC engine to automatically attempt to automatically fix detected drift and bring the tenant back into its desired state. This is referred to as the DSC configuration mode. To learn more about how you can configure the DSC engine to automatically fix detected drift, please refer to <a href="https://docs.microsoft.com/en-us/powershell/dsc/managing-nodes/metaconfig?view=dsc-1.1">Configuring the Local Configuration Manager</a>.

# Cloning Tenant's Configuration
This feature of Microsoft365DSC is not a true standalone feature; it is a combination of existing features to unlock a new scenario for users. Since Microsoft365DSC is able to take a snapshot of any Microsoft 365 tenant and because we can deploy a Microsoft365DSC configuration onto any tenant, we can easily clone the configuration of any tenant over another one (or another set of tenants). When you take a snapshot of an existing tenant, the extracted configuration file doesn’t contain any information that is specific to the source tenant. It abstracts it all into variables, which make the configuration generic instead of unique for a particular tenant. It is then at compilation time that you provide information about the environment onto which this configuration will be applied to.

For example, let's assume you are trying to clone the configuration of Tenant A onto Tenant B. You would start by capturing the existing configuration of tenant A using credentials or a Service Principal that exists and has rights on Tenant A. This will generate the configuration file containing all the configuration settings for Tenant A. Then at compilation time, when trying to compile the extracted configuration into a MOF file, you will need to provide credentials or a Service Principal that has access to Tenant B. Then all that is left to do is to deploy the configuration onto Tenant B to have all the configurations settings from tenant A applied onto it.

# Generating Reports from Configurations
Microsoft365DSC makes it very easy to generate user friendly reports from any configuration, whether you wrote it yourself or generated it using the configuration snapshot feature. The solution allows you to generate both HTML and Excel reports from existing files. To generate and Excel reports however, you need to have Office installed on the machine that you are trying to generate the report from. To generate reports, simply use the **New-M365DSCReportFromConfiguration** and specify what type of report you want using the **Type** parameter (specify HTML or Excel). The cmdlet also requires you to specify the full path to the .ps1 configuration file you want to generate the report from using the **-ConfigurationPath** parameter and specify where you wish to store the generated report using the **-OutputPath** parameter.

Trying to generate an Excel report from a configuration will automatically launch the Excel client as part of the process. Users will see data being loaded progressively into it and once the generation processes has finished, columns will automatically be resized to fit the content. The report will also automatically put the key mandatory parameter (e.g. primary key) of each resource in bold and do some styling of the output. report.
 ![image](https://user-images.githubusercontent.com/2547149/149800400-e44efd1c-77a9-4b9c-8c43-c3b05f139714.png)

Generating an HTML report will generate a different result. It will create the report file at the location specified by the **OutputPath** parameter, but it won’t actually launch the report in a browser. The **New-M365DSCReportFromConfiguration** cmdlet, when used for HTML reports will also return the raw HTML content of the report as seen in the image below.
 ![image](https://user-images.githubusercontent.com/2547149/149800454-466920fd-0fb0-48fd-b5b2-873c3cb00b28.png)
![image](https://user-images.githubusercontent.com/2547149/149800462-c3ab5699-4991-48b3-89cc-3f48e36d8a86.png)



# Comparing Configurations
The Microsoft365DSC solution has a built-in engine to compare configurations and generate a delta report in HTML that shows the discrepancies between the two. You can either use it to compare the configuration between 2 files or you can use it to compare a configuration against another tenant and see how it defers from that tenant’s current configuration.

## Comparing 2 Configuration Files
Using the **New-M365DSCDeltaReport** cmdlet, you can specify the two configuration files you wish to compare using the **-Source** and **-Destination** parameters. You then need to specify where you wish to store the resulting HTML report using the **-OutputPath** parameter. Consider the following example, where I've taken two configuration snapshots of my tenant over a period of 6 months apart. I wish to determine what configuration settings have changed over that period of time. Using the **New-M365DSCDeltaReport** cmdlet, I can easily compare the two and generate a delta report as shown in the image below.
![image](https://user-images.githubusercontent.com/2547149/149800668-d0c6ab84-703f-4b46-a17e-8603388ca190.png)


You can also decide to customize the generated report by injecting your own HTML into its header. To do so, simply specify the location of the HTML file to inject in the header of the report using the **-HeaderFilePath** parameter. The example shown in the following picture shows how to add your customer header to a delta report.
![image](https://user-images.githubusercontent.com/2547149/149800692-614c5463-906f-4d1f-9acf-d52c0794121f.png)


## Comparing a Configuration Against Another Tenant
Using Microsoft365DSC, you can compare any configuration file against the current configuration of any other given Microsoft 365 tenant. This can be very useful in comparing the configuration between two tenants in scenarios like mergers and acquisitions. For example, let’s assume you are trying to compare the configuration of Tenant A with the one from Tenant B. You can start by taking a snapshot of both tenants, and then use this feature to compare it against the configuration of Tenant B using the **New-M365DSCDeltaReport** cmdlet.

# Integrating with Azure DevOPS
Microsoft365DSC takes all its sense when used as part of DevOPS processes within the enterprise. You can use it to automate your Microsoft 365 Change Management process so that any requested configuration changes to tenants get tracked via systems like Azure DevOPS and GitHub and use them to automate the deployment of your changes across your various tenants when a change is approved. While this article doesn’t cover the process of integrating Microsoft365DSC with these systems, our team has written a great <a href="https://office365dsc.azurewebsites.net/Pages/Resources/Whitepapers/Managing Microsoft 365 with Microsoft365Dsc and Azure DevOps.pdf">whitepaper</a> to help you get started with integrating Microsoft365DSC with Azure DevOPS.

# Support
As mentioned at the beginning of this document, Microsoft365DSC is an open-source solution led by Microsoft engineers and maintained by the community. This means that it is not supported via Microsoft's support. If you need help getting started, need to report a bug or request new features to be added, you will need to use the Issues section of the official <a href="https://github.com/microsoft/microsoft365DSC">GitHub</a> repository to do so. The team is meeting on a weekly basis to review items and prioritize fixes. If you require immediate attention for a blocking issue and that you have a Premiere or Unified support contract with Microsoft, you can always talk to your account team to leverage hours in your contract to have an engineer assigned to expedite the process.

# Telemetry
By default, Microsoft365DSC is sending telemetry back to Microsoft to help the team improve the solution in a pro-active manner. Information is all captured using Azure Application Insights. We are capturing information about what operations are being called the more often, information about any errors encountered, authentication type most commonly used, PowerShell versions used, etc. Users can decide to stop sending telemetry back to Microsoft at any given point by opting out. To do so, simply run the following PowerShell command:
```
Set-M365DSCTelemetryOption -Enabled $false
```
**Note** that this is a per machine setting. Therefore, if you are executing Microsoft365DSC on different systems within your organization, this command will have to be executed on each one.
Organizations can also decide to capture telemetry from Microsoft365DSC using their own Application Insights account (without sending any data back to Microsoft). The **Set-M365DSCTelemetryOption** cmdlet lets you specify what Application Insights account you wish to send telemetry back to using the **-InstrumentationKey** parameter.

 ![image](https://user-images.githubusercontent.com/2547149/149800998-71bf37ff-ff82-4627-8893-7465d689f0fe.png)

Users can also specify a custom name for their solution using the **-ProjectName** parameter. This will ensure that every telemetry reported back to the Application Insights account gets tagged with the project name under **customDimensions.ProjectName**.
