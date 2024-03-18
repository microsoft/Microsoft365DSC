# IntuneSettingCatalogASRRulesPolicyWindows10

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Write | String | Identity of the endpoint protection attack surface protection rules policy for Windows 10. | |
| **DisplayName** | Key | String | Display name of the endpoint protection attack surface protection rules policy for Windows 10. | |
| **Description** | Write | String | Description of the endpoint protection attack surface protection rules policy for Windows 10. | |
| **Assignments** | Write | MSFT_DeviceManagementConfigurationPolicyAssignments[] | Assignments of the endpoint protection. | |
| **AttackSurfaceReductionOnlyExclusions** | Write | StringArray[] | Exclude files and paths from attack surface reduction rules | |
| **BlockAbuseOfExploitedVulnerableSignedDrivers** | Write | String | This rule prevents an application from writing a vulnerable signed driver to disk. | `off`, `block`, `audit`, `warn` |
| **BlockAdobeReaderFromCreatingChildProcesses** | Write | String | This rule prevents attacks by blocking Adobe Reader from creating processes. | `off`, `block`, `audit`, `warn` |
| **BlockAllOfficeApplicationsFromCreatingChildProcesses** | Write | String | This rule blocks Office apps from creating child processes. Office apps include Word, Excel, PowerPoint, OneNote, and Access. | `off`, `block`, `audit`, `warn` |
| **BlockCredentialStealingFromWindowsLocalSecurityAuthoritySubsystem** | Write | String | This rule helps prevent credential stealing by locking down Local Security Authority Subsystem Service (LSASS). | `off`, `block`, `audit`, `warn` |
| **BlockExecutableContentFromEmailClientAndWebmail** | Write | String | This rule blocks the following file types from launching from email opened within the Microsoft Outlook application, or Outlook.com and other popular webmail providers. | `off`, `block`, `audit`, `warn` |
| **BlockExecutableFilesRunningUnlessTheyMeetPrevalenceAgeTrustedListCriterion** | Write | String | This rule blocks executable files that don't meet a prevalence, age, or trusted list criteria, such as .exe, .dll, or .scr, from launching. | `off`, `block`, `audit`, `warn` |
| **BlockExecutionOfPotentiallyObfuscatedScripts** | Write | String | This rule detects suspicious properties within an obfuscated script. | `off`, `block`, `audit`, `warn` |
| **BlockJavaScriptOrVBScriptFromLaunchingDownloadedExecutableContent** | Write | String | This rule prevents scripts from launching potentially malicious downloaded content. | `off`, `block`, `audit`, `warn` |
| **BlockOfficeApplicationsFromCreatingExecutableContent** | Write | String | This rule prevents Office apps, including Word, Excel, and PowerPoint, from creating potentially malicious executable content, by blocking malicious code from being written to disk. | `off`, `block`, `audit`, `warn` |
| **BlockOfficeApplicationsFromInjectingCodeIntoOtherProcesses** | Write | String | This rule blocks code injection attempts from Office apps into other processes. | `off`, `block`, `audit`, `warn` |
| **BlockOfficeCommunicationAppFromCreatingChildProcesses** | Write | String | This rule prevents Outlook from creating child processes, while still allowing legitimate Outlook functions. | `off`, `block`, `audit`, `warn` |
| **BlockPersistenceThroughWMIEventSubscription** | Write | String | This rule prevents malware from abusing WMI to attain persistence on a device. | `off`, `block`, `audit`, `warn` |
| **BlockProcessCreationsFromPSExecAndWMICommands** | Write | String | This rule blocks processes created through PsExec and WMI from running. | `off`, `block`, `audit`, `warn` |
| **BlockUntrustedUnsignedProcessesThatRunFromUSB** | Write | String | With this rule, admins can prevent unsigned or untrusted executable files from running from USB removable drives, including SD cards. | `off`, `block`, `audit`, `warn` |
| **BlockWebShellCreationForServers** | Write | String | This rule blocks webshell creation for servers. | `off`, `block`, `audit`, `warn` |
| **BlockWin32APICallsFromOfficeMacros** | Write | String | This rule prevents VBA macros from calling Win32 APIs. | `off`, `block`, `audit`, `warn` |
| **UseAdvancedProtectionAgainstRansomware** | Write | String | This rule provides an extra layer of protection against ransomware. | `off`, `block`, `audit`, `warn` |
| **ControlledFolderAccessProtectedFolders** | Write | StringArray[] | List of additional folders that need to be protected | |
| **ControlledFolderAccessAllowedApplications** | Write | StringArray[] | List of apps that have access to protected folders. | |
| **EnableControlledFolderAccess** | Write | String | This rule enable Controlled folder access which protects your data by checking apps against a list of known, trusted apps.values 0:disable, 1:enable, 2:audit | `0`, `1`, `2` |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Intune Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

### MSFT_DeviceManagementConfigurationPolicyAssignments

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **dataType** | Write | String | The type of the target assignment. | `#microsoft.graph.groupAssignmentTarget`, `#microsoft.graph.allLicensedUsersAssignmentTarget`, `#microsoft.graph.allDevicesAssignmentTarget`, `#microsoft.graph.exclusionGroupAssignmentTarget`, `#microsoft.graph.configurationManagerCollectionAssignmentTarget` |
| **deviceAndAppManagementAssignmentFilterType** | Write | String | The type of filter of the target assignment i.e. Exclude or Include. Possible values are:none, include, exclude. | `none`, `include`, `exclude` |
| **deviceAndAppManagementAssignmentFilterId** | Write | String | The Id of the filter for the target assignment. | |
| **groupId** | Write | String | The group Id that is the target of the assignment. | |
| **groupDisplayName** | Write | String | The group Display Name that is the target of the assignment. | |
| **collectionId** | Write | String | The collection Id that is the target of the assignment.(ConfigMgr) | |


## Description

This resource configures a Intune Endpoint Protection Attack Surface Reduction rules policy for a Windows 10 Device.
This resource returns ASR rules created using settings catalog settings.


## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - DeviceManagementConfiguration.Read.All

- **Update**

    - DeviceManagementConfiguration.ReadWrite.All

#### Application permissions

- **Read**

    - DeviceManagementConfiguration.Read.All

- **Update**

    - DeviceManagementConfiguration.ReadWrite.All

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
        IntuneSettingCatalogASRRulesPolicyWindows10 'myASRRulesPolicy'
        {
            DisplayName                                                                = 'asr 2'
            Assignments                                                                = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments {
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType                                   = '#microsoft.graph.allLicensedUsersAssignmentTarget'
                })
            attacksurfacereductiononlyexclusions                                       = @('Test 10', 'Test2', 'Test3')
            blockabuseofexploitedvulnerablesigneddrivers                               = 'block'
            blockexecutablefilesrunningunlesstheymeetprevalenceagetrustedlistcriterion = 'audit'
            Description                                                                = 'Post'
            Ensure                                                                     = 'Present'
            Credential                                                                 = $Credscredential
        }
    }
}
```

### Example 2

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
        IntuneSettingCatalogASRRulesPolicyWindows10 'myASRRulesPolicy'
        {
            DisplayName                                                                = 'asr 2'
            Assignments                                                                = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments {
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType                                   = '#microsoft.graph.allLicensedUsersAssignmentTarget'
                })
            attacksurfacereductiononlyexclusions                                       = @('Test 10', 'Test2', 'Test3')
            blockabuseofexploitedvulnerablesigneddrivers                               = 'audit' # Updated Property
            blockexecutablefilesrunningunlesstheymeetprevalenceagetrustedlistcriterion = 'audit'
            Description                                                                = 'Post'
            Ensure                                                                     = 'Present'
            Credential                                                                 = $Credscredential
        }
    }
}
```

### Example 3

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
        IntuneSettingCatalogASRRulesPolicyWindows10 'myASRRulesPolicy'
        {
            DisplayName                                                                = 'asr 2'
            Ensure                                                                     = 'Absent'
            Credential                                                                 = $Credscredential
        }
    }
}
```

