## Technical requirements

For Microsoft365DSC to function, you need to arrange the following components:

### PowerShell version

Microsoft365DSC is supported for PowerShell version 5.1 and 7.3+. For additional details on how to leverage it with PowerShell 7, please refer to our [PowerShell 7+ Guide for Microsoft365DSC](https://microsoft365dsc.com/user-guide/get-started/powershell7-support/).

### PowerShell Execution Policy

Microsoft365DSC consists of its own module and various PowerShell submodules. Allowing scripts to run is necessary for the successful execution of the functions. The command `Get-ExecutionPolicy` retrieves the current execution policy. Usually, it is enough if the value is set to RemoteSigned. If you encounter issues while loading scripts, set it to Unrestricted: `Set-ExecutionPolicy -ExecutionPolicy Unrestricted`

### Windows Remote Management (WinRM)

Microsoft365DSC uses the Local Configuration Manager (LCM). This requires PowerShell Remoting to be enabled. Please run either `winrm quickconfig -force` or `Enable-PSRemoting -Force -SkipNetworkProfileCheck` to enable it.

### Tooling

To get the best experience running Microsoft365DSC cmdlets, it is recommended that you use the <a href="https://www.microsoft.com/en-ca/p/windows-terminal/9n0dx20hk701" target="_blank">Windows Terminal</a>. All screenshots provided in this article are using the Windows Terminal. This tool allows you to quickly switch between PowerShell versions and provide better support for icons and symbols that are used throughout Microsoft365DSC’s experience.

### Permissions

In order to connect to Microsoft 365, you need to make sure you have valid credentials (user **or** application credentials) with the correct permissions to the Microsoft 365 service. Microsoft365DSC offers several methods of authentication, depending on the used resources. Unfortunately, we are depending on the supported authentication methods used by the various PowerShell modules that are used.

Make sure you review the [Authentication and Permissions](../authentication-and-permissions) article for more information on the available authentication methods and how to configure all required permissions.

## Experience and skills

Before you start using Microsoft365DSC, it is important that you also have the proper experience and skills on administering Microsoft 365. Microsoft365DSC is a powerful solution that can greatly streamline Microsoft 365 administration. But with great power comes great responsibility:

**If you don't know what exactly you are doing, using Microsoft365DSC you can also cause some serious damage.**

That is why it is important that you have the correct experience and skills. To use this module properly you should be very familiar with:

- <a href="https://docs.microsoft.com/en-us/microsoft-365/admin/admin-overview/admin-center-overview" target="_blank">Microsoft 365 administration across all services / workloads</a>
- <a href="https://docs.microsoft.com/en-us/powershell/" target="_blank">(Windows) PowerShell</a>
- <a href="https://docs.microsoft.com/nl-nl/powershell/dsc/getting-started/winGettingStarted?view=dsc-1.1" target="_blank">PowerShell Desired State Configuration</a>
- <a href="https://docs.microsoft.com/en-us/azure/active-directory/develop/msal-authentication-flows" target="_blank">Authentication methods and permission management in Azure Active Directory</a>

Additionally it can be helpful, depending on the planned use of Microsoft365DSC, to have a good understanding of:

- <a href="https://azure.microsoft.com/en-us/services/devops/" target="_blank">Azure DevOps </a>
- <a href="https://docs.microsoft.com/en-us/azure/automation/overview" target="_blank">Azure Automation</a>

### Training resources

You can review the following training resources and certifications, for learning more about the above topics:

#### PowerShell Desired State Configuration

- <a href="https://docs.microsoft.com/en-us/powershell/dsc/getting-started/wingettingstarted" target="_blank">Get started with Desired State Configuration for Windows</a>
- <a href="https://docs.microsoft.com/en-us/powershell/dsc/configurations/separatingenvdata" target="_blank">Separating configuration and environment data</a>
- <a href="https://docs.microsoft.com/en-us/shows/getting-started-with-powershell-dsc/" target="_blank">Video series: "Getting Started with PowerShell Desired State Configuration"</a>

#### Microsoft 365 Administration

- <a href="https://docs.microsoft.com/en-us/microsoft-365/admin/admin-overview/about-the-admin-center" target="_blank">About the Microsoft 365 admin center</a>
- <a href="https://docs.microsoft.com/en-us/microsoft-365/admin/admin-overview/admin-center-overview" target="_blank">Overview of the Microsoft 365 admin center</a>
- <a href="https://docs.microsoft.com/en-us/microsoft-365/admin/add-users/about-admin-roles" target="_blank">About admin roles</a>
- <a href="https://www.youtube.com/watch?v=aTkgF33C9hA" target="_blank">Video: Get an overview of the Microsoft 365 admin center</a>

#### Recommended Certification

- <a href="https://docs.microsoft.com/en-us/learn/certifications/microsoft-365-fundamentals/" target="_blank">Microsoft 365 Certified: Fundamentals (MS-900)</a>
- <a href="https://docs.microsoft.com/en-us/learn/certifications/m365-enterprise-administrator/" target="_blank">Microsoft 365 Certified: Enterprise Administrator Expert (MS-100 & MS-101)</a>
