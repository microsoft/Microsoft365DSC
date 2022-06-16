﻿# IntuneASRRulesPolicyWindows10

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Identity of the endpoint protection attack surface protection rules policy for Windows 10. ||
| **DisplayName** | Write | String | Display name of the endpoint protection attack surface protection rules policy for Windows 10. ||
| **Description** | Write | String | Description of the endpoint protection attack surface protection rules policy for Windows 10. ||
| **ProcessCreationType** | Write | String | This rule blocks processes created through PsExec and WMI from running. |userDefined, block, auditMode, warn, disable|
| **AdvancedRansomewareProtectionType** | Write | String | This rule provides an extra layer of protection against ransomware. |notConfigured, userDefined, enable, auditMode|
| **BlockPersistenceThroughWmiType** | Write | String | This rule prevents malware from abusing WMI to attain persistence on a device. |userDefined, block, auditMode, disable|
| **ScriptObfuscatedMacroCodeType** | Write | String | This rule detects suspicious properties within an obfuscated script. |userDefined, block, auditMode, warn, disable|
| **OfficeMacroCodeAllowWin32ImportsType** | Write | String | This rule prevents VBA macros from calling Win32 APIs. |userDefined, block, auditMode, warn, disable|
| **OfficeAppsLaunchChildProcessType** | Write | String | This rule blocks Office apps from creating child processes. Office apps include Word, Excel, PowerPoint, OneNote, and Access. |userDefined, block, auditMode, warn, disable|
| **GuardMyFoldersType** | Write | String | This rule enable Controlled folder access which protects your data by checking apps against a list of known, trusted apps. |userDefined, enable, auditMode, blockDiskModification, auditDiskModification|
| **UntrustedUSBProcessType** | Write | String | With this rule, admins can prevent unsigned or untrusted executable files from running from USB removable drives, including SD cards. |notConfigured, userDefined, block, auditMode, warn, disable|
| **AttackSurfaceReductionExcludedPaths** | Write | StringArray[] | Exclude files and paths from attack surface reduction rules ||
| **UntrustedExecutableType** | Write | String | This rule blocks executable files that don't meet a prevalence, age, or trusted list criteria, such as .exe, .dll, or .scr, from launching. |userDefined, block, auditMode, warn, disable|
| **OfficeCommunicationAppsLaunchChildProcess** | Write | String | This rule prevents Outlook from creating child processes, while still allowing legitimate Outlook functions. |notConfigured, userDefined, block, auditMode, warn, disable|
| **EmailContentExecutionType** | Write | String | This rule blocks the following file types from launching from email opened within the Microsoft Outlook application, or Outlook.com and other popular webmail providers. |notConfigured, block, auditMode, userDefined, disable|
| **ScriptDownloadedPayloadExecutionType** | Write | String | This rule prevents scripts from launching potentially malicious downloaded content. |userDefined, block, auditMode, warn, disable|
| **AdditionalGuardedFolders** | Write | StringArray[] | List of additional folders that need to be protected ||
| **AdobeReaderLaunchChildProcess** | Write | String | This rule prevents attacks by blocking Adobe Reader from creating processes. |notConfigured, userDefined, enable, auditMode, warn|
| **OfficeAppsExecutableContentCreationOrLaunchType** | Write | String | This rule prevents Office apps, including Word, Excel, and PowerPoint, from creating potentially malicious executable content, by blocking malicious code from being written to disk. |userDefined, block, auditMode, warn, disable|
| **PreventCredentialStealingType** | Write | String | This rule helps prevent credential stealing by locking down Local Security Authority Subsystem Service (LSASS). |notConfigured, userDefined, enable, auditMode, warn|
| **OfficeAppsOtherProcessInjectionType** | Write | String | This rule blocks code injection attempts from Office apps into other processes. |userDefined, block, auditMode, warn, disable|
| **GuardedFoldersAllowedAppPaths** | Write | StringArray[] | List of apps that have access to protected folders. ||
| **Ensure** | Write | String | Present ensures the site collection exists, absent ensures it is removed |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Intune Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com ||
| **ApplicationSecret** | Write | String | Secret of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||


# IntuneASRRulesPolicyWindows10

### Description

This resource configures a Intune Endpoint Protection Attack Surface Reduction rules policy for a Windows 10 Device.
This resource returns ASR rules created using deviceConfiguration Graph settings.



