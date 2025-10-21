# IntuneSecurityBaselineMicrosoft365AppsForEnterprise

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Description** | Write | String | Policy description | |
| **DisplayName** | Key | String | Policy name | |
| **RoleScopeTagIds** | Write | StringArray[] | List of Scope Tags for this Entity instance. | |
| **Id** | Write | String | The unique identifier for an entity. Read-only. | |
| **DeviceSettings** | Write | MSFT_MicrosoftGraphIntuneSettingsCatalogDeviceSettings_IntuneSecurityBaselineMicrosoft365AppsForEnterprise | The policy settings for the device scope | |
| **UserSettings** | Write | MSFT_MicrosoftGraphIntuneSettingsCatalogUserSettings_IntuneSecurityBaselineMicrosoft365AppsForEnterprise | The policy settings for the user scope | |
| **Assignments** | Write | MSFT_DeviceManagementConfigurationPolicyAssignments[] | Represents the assignment to the Intune policy. | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

### MSFT_DeviceManagementConfigurationPolicyAssignments

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **dataType** | Write | String | The type of the target assignment. | `#microsoft.graph.cloudPcManagementGroupAssignmentTarget`, `#microsoft.graph.groupAssignmentTarget`, `#microsoft.graph.allLicensedUsersAssignmentTarget`, `#microsoft.graph.allDevicesAssignmentTarget`, `#microsoft.graph.exclusionGroupAssignmentTarget`, `#microsoft.graph.configurationManagerCollectionAssignmentTarget` |
| **deviceAndAppManagementAssignmentFilterType** | Write | String | The type of filter of the target assignment i.e. Exclude or Include. Possible values are:none, include, exclude. | `none`, `include`, `exclude` |
| **deviceAndAppManagementAssignmentFilterId** | Write | String | The Id of the filter for the target assignment. | |
| **deviceAndAppManagementAssignmentFilterDisplayName** | Write | String | The display name of the filter for the target assignment. | |
| **groupId** | Write | String | The group Id that is the target of the assignment. | |
| **groupDisplayName** | Write | String | The group Display Name that is the target of the assignment. | |
| **collectionId** | Write | String | The collection Id that is the target of the assignment.(ConfigMgr) | |

### MSFT_MicrosoftGraphIntuneSettingsCatalogDeviceSettings_IntuneSecurityBaselineMicrosoft365AppsForEnterprise

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Pol_SecGuide_A001_Block_Flash** | Write | SInt32 | Block Flash activation in Office documents (0: Disabled, 1: Enabled) | `0`, `1` |
| **Pol_SecGuide_Block_Flash** | Write | String | Block Flash player in Office (Device) - Depends on Pol_SecGuide_A001_Block_Flash (block all flash activation: Block all activation, block embedded flash activation only: Block embedding/linking, allow other activation, allow all flash activation: Allow all activation) | `block all flash activation`, `block embedded flash activation only`, `allow all flash activation` |
| **Pol_SecGuide_Legacy_JScript** | Write | SInt32 | Restrict legacy JScript execution for Office (0: Disabled, 1: Enabled) | `0`, `1` |
| **POL_SG_powerpnt** | Write | SInt32 | PowerPoint: (Device) - Depends on Pol_SecGuide_Legacy_JScript | |
| **POL_SG_onenote** | Write | SInt32 | OneNote: (Device) - Depends on Pol_SecGuide_Legacy_JScript | |
| **POL_SG_mspub** | Write | SInt32 | Publisher: (Device) - Depends on Pol_SecGuide_Legacy_JScript | |
| **POL_SG_msaccess** | Write | SInt32 | Access: (Device) - Depends on Pol_SecGuide_Legacy_JScript | |
| **POL_SG_winproj** | Write | SInt32 | Project: (Device) - Depends on Pol_SecGuide_Legacy_JScript | |
| **POL_SG_visio** | Write | SInt32 | Visio: (Device) - Depends on Pol_SecGuide_Legacy_JScript | |
| **POL_SG_outlook** | Write | SInt32 | Outlook: (Device) - Depends on Pol_SecGuide_Legacy_JScript | |
| **POL_SG_winword** | Write | SInt32 | Word: (Device) - Depends on Pol_SecGuide_Legacy_JScript | |
| **POL_SG_excel** | Write | SInt32 | Excel: (Device) - Depends on Pol_SecGuide_Legacy_JScript | |
| **L_PolicyEnableSIPHighSecurityMode** | Write | SInt32 | Configure SIP security mode (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_PolicyDisableHttpConnect** | Write | SInt32 | Disable HTTP fallback for SIP connection (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_AddonManagement** | Write | SInt32 | Add-on Management (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_powerpntexe17** | Write | SInt32 | powerpnt.exe (Device) - Depends on L_AddonManagement (0: False, 1: True) | `0`, `1` |
| **L_excelexe15** | Write | SInt32 | excel.exe (Device) - Depends on L_AddonManagement (0: False, 1: True) | `0`, `1` |
| **L_visioexe19** | Write | SInt32 | visio.exe (Device) - Depends on L_AddonManagement (0: False, 1: True) | `0`, `1` |
| **L_onenoteexe26** | Write | SInt32 | onent.exe (Device) - Depends on L_AddonManagement (0: False, 1: True) | `0`, `1` |
| **L_outlookexe22** | Write | SInt32 | outlook.exe (Device) - Depends on L_AddonManagement (0: False, 1: True) | `0`, `1` |
| **L_pptviewexe18** | Write | SInt32 | pptview.exe (Device) - Depends on L_AddonManagement (0: False, 1: True) | `0`, `1` |
| **L_winwordexe21** | Write | SInt32 | winword.exe (Device) - Depends on L_AddonManagement (0: False, 1: True) | `0`, `1` |
| **L_exprwdexe24** | Write | SInt32 | exprwd.exe (Device) - Depends on L_AddonManagement (0: False, 1: True) | `0`, `1` |
| **L_spdesignexe23** | Write | SInt32 | spDesign.exe (Device) - Depends on L_AddonManagement (0: False, 1: True) | `0`, `1` |
| **L_winprojexe20** | Write | SInt32 | winproj.exe (Device) - Depends on L_AddonManagement (0: False, 1: True) | `0`, `1` |
| **L_grooveexe14** | Write | SInt32 | groove.exe (Device) - Depends on L_AddonManagement (0: False, 1: True) | `0`, `1` |
| **L_mspubexe16** | Write | SInt32 | mspub.exe (Device) - Depends on L_AddonManagement (0: False, 1: True) | `0`, `1` |
| **L_mse7exe27** | Write | SInt32 | mse7.exe (Device) - Depends on L_AddonManagement (0: False, 1: True) | `0`, `1` |
| **L_msaccessexe25** | Write | SInt32 | msaccess.exe (Device) - Depends on L_AddonManagement (0: False, 1: True) | `0`, `1` |
| **L_ConsistentMimeHandling** | Write | SInt32 | Consistent Mime Handling (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_excelexe43** | Write | SInt32 | excel.exe (Device) - Depends on L_ConsistentMimeHandling (0: False, 1: True) | `0`, `1` |
| **L_spdesignexe51** | Write | SInt32 | spDesign.exe (Device) - Depends on L_ConsistentMimeHandling (0: False, 1: True) | `0`, `1` |
| **L_onenoteexe54** | Write | SInt32 | onent.exe (Device) - Depends on L_ConsistentMimeHandling (0: False, 1: True) | `0`, `1` |
| **L_outlookexe50** | Write | SInt32 | outlook.exe (Device) - Depends on L_ConsistentMimeHandling (0: False, 1: True) | `0`, `1` |
| **L_pptviewexe46** | Write | SInt32 | pptview.exe (Device) - Depends on L_ConsistentMimeHandling (0: False, 1: True) | `0`, `1` |
| **L_mspubexe44** | Write | SInt32 | mspub.exe (Device) - Depends on L_ConsistentMimeHandling (0: False, 1: True) | `0`, `1` |
| **L_visioexe47** | Write | SInt32 | visio.exe (Device) - Depends on L_ConsistentMimeHandling (0: False, 1: True) | `0`, `1` |
| **L_winprojexe48** | Write | SInt32 | winproj.exe (Device) - Depends on L_ConsistentMimeHandling (0: False, 1: True) | `0`, `1` |
| **L_msaccessexe53** | Write | SInt32 | msaccess.exe (Device) - Depends on L_ConsistentMimeHandling (0: False, 1: True) | `0`, `1` |
| **L_powerpntexe45** | Write | SInt32 | powerpnt.exe (Device) - Depends on L_ConsistentMimeHandling (0: False, 1: True) | `0`, `1` |
| **L_grooveexe42** | Write | SInt32 | groove.exe (Device) - Depends on L_ConsistentMimeHandling (0: False, 1: True) | `0`, `1` |
| **L_mse7exe55** | Write | SInt32 | mse7.exe (Device) - Depends on L_ConsistentMimeHandling (0: False, 1: True) | `0`, `1` |
| **L_winwordexe49** | Write | SInt32 | winword.exe (Device) - Depends on L_ConsistentMimeHandling (0: False, 1: True) | `0`, `1` |
| **L_exprwdexe52** | Write | SInt32 | exprwd.exe (Device) - Depends on L_ConsistentMimeHandling (0: False, 1: True) | `0`, `1` |
| **L_Disableusernameandpassword** | Write | SInt32 | Disable user name and password (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_excelexe127** | Write | SInt32 | excel.exe (Device) - Depends on L_Disableusernameandpassword (0: False, 1: True) | `0`, `1` |
| **L_grooveexe126** | Write | SInt32 | groove.exe (Device) - Depends on L_Disableusernameandpassword (0: False, 1: True) | `0`, `1` |
| **L_onenoteexe138** | Write | SInt32 | onent.exe (Device) - Depends on L_Disableusernameandpassword (0: False, 1: True) | `0`, `1` |
| **L_mse7exe139** | Write | SInt32 | mse7.exe (Device) - Depends on L_Disableusernameandpassword (0: False, 1: True) | `0`, `1` |
| **L_mspubexe128** | Write | SInt32 | mspub.exe (Device) - Depends on L_Disableusernameandpassword (0: False, 1: True) | `0`, `1` |
| **L_visioexe131** | Write | SInt32 | visio.exe (Device) - Depends on L_Disableusernameandpassword (0: False, 1: True) | `0`, `1` |
| **L_exprwdexe136** | Write | SInt32 | exprwd.exe (Device) - Depends on L_Disableusernameandpassword (0: False, 1: True) | `0`, `1` |
| **L_msaccessexe137** | Write | SInt32 | msaccess.exe (Device) - Depends on L_Disableusernameandpassword (0: False, 1: True) | `0`, `1` |
| **L_spdesignexe135** | Write | SInt32 | spDesign.exe (Device) - Depends on L_Disableusernameandpassword (0: False, 1: True) | `0`, `1` |
| **L_winwordexe133** | Write | SInt32 | winword.exe (Device) - Depends on L_Disableusernameandpassword (0: False, 1: True) | `0`, `1` |
| **L_powerpntexe129** | Write | SInt32 | powerpnt.exe (Device) - Depends on L_Disableusernameandpassword (0: False, 1: True) | `0`, `1` |
| **L_outlookexe134** | Write | SInt32 | outlook.exe (Device) - Depends on L_Disableusernameandpassword (0: False, 1: True) | `0`, `1` |
| **L_winprojexe132** | Write | SInt32 | winproj.exe (Device) - Depends on L_Disableusernameandpassword (0: False, 1: True) | `0`, `1` |
| **L_pptviewexe130** | Write | SInt32 | pptview.exe (Device) - Depends on L_Disableusernameandpassword (0: False, 1: True) | `0`, `1` |
| **L_Informationbar** | Write | SInt32 | Information Bar (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_excelexe113** | Write | SInt32 | excel.exe (Device) - Depends on L_Informationbar (0: False, 1: True) | `0`, `1` |
| **L_mspubexe114** | Write | SInt32 | mspub.exe (Device) - Depends on L_Informationbar (0: False, 1: True) | `0`, `1` |
| **L_msaccessexe123** | Write | SInt32 | msaccess.exe (Device) - Depends on L_Informationbar (0: False, 1: True) | `0`, `1` |
| **L_onenoteexe124** | Write | SInt32 | onent.exe (Device) - Depends on L_Informationbar (0: False, 1: True) | `0`, `1` |
| **L_outlookexe120** | Write | SInt32 | outlook.exe (Device) - Depends on L_Informationbar (0: False, 1: True) | `0`, `1` |
| **L_winprojexe118** | Write | SInt32 | winproj.exe (Device) - Depends on L_Informationbar (0: False, 1: True) | `0`, `1` |
| **L_powerpntexe115** | Write | SInt32 | powerpnt.exe (Device) - Depends on L_Informationbar (0: False, 1: True) | `0`, `1` |
| **L_spdesignexe121** | Write | SInt32 | spDesign.exe (Device) - Depends on L_Informationbar (0: False, 1: True) | `0`, `1` |
| **L_grooveexe112** | Write | SInt32 | groove.exe (Device) - Depends on L_Informationbar (0: False, 1: True) | `0`, `1` |
| **L_visioexe117** | Write | SInt32 | visio.exe (Device) - Depends on L_Informationbar (0: False, 1: True) | `0`, `1` |
| **L_mse7exe125** | Write | SInt32 | mse7.exe (Device) - Depends on L_Informationbar (0: False, 1: True) | `0`, `1` |
| **L_winwordexe119** | Write | SInt32 | winword.exe (Device) - Depends on L_Informationbar (0: False, 1: True) | `0`, `1` |
| **L_exprwdexe122** | Write | SInt32 | exprwd.exe (Device) - Depends on L_Informationbar (0: False, 1: True) | `0`, `1` |
| **L_pptviewexe116** | Write | SInt32 | pptview.exe (Device) - Depends on L_Informationbar (0: False, 1: True) | `0`, `1` |
| **L_LocalMachineZoneLockdownSecurity** | Write | SInt32 | Local Machine Zone Lockdown Security (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_mse7exe41** | Write | SInt32 | mse7.exe (Device) - Depends on L_LocalMachineZoneLockdownSecurity (0: False, 1: True) | `0`, `1` |
| **L_powerpntexe31** | Write | SInt32 | powerpnt.exe (Device) - Depends on L_LocalMachineZoneLockdownSecurity (0: False, 1: True) | `0`, `1` |
| **L_mspubexe30** | Write | SInt32 | mspub.exe (Device) - Depends on L_LocalMachineZoneLockdownSecurity (0: False, 1: True) | `0`, `1` |
| **L_outlookexe36** | Write | SInt32 | outlook.exe (Device) - Depends on L_LocalMachineZoneLockdownSecurity (0: False, 1: True) | `0`, `1` |
| **L_pptviewexe32** | Write | SInt32 | pptview.exe (Device) - Depends on L_LocalMachineZoneLockdownSecurity (0: False, 1: True) | `0`, `1` |
| **L_excelexe29** | Write | SInt32 | excel.exe (Device) - Depends on L_LocalMachineZoneLockdownSecurity (0: False, 1: True) | `0`, `1` |
| **L_exprwdexe38** | Write | SInt32 | exprwd.exe (Device) - Depends on L_LocalMachineZoneLockdownSecurity (0: False, 1: True) | `0`, `1` |
| **L_grooveexe28** | Write | SInt32 | groove.exe (Device) - Depends on L_LocalMachineZoneLockdownSecurity (0: False, 1: True) | `0`, `1` |
| **L_winwordexe35** | Write | SInt32 | winword.exe (Device) - Depends on L_LocalMachineZoneLockdownSecurity (0: False, 1: True) | `0`, `1` |
| **L_msaccessexe39** | Write | SInt32 | msaccess.exe (Device) - Depends on L_LocalMachineZoneLockdownSecurity (0: False, 1: True) | `0`, `1` |
| **L_spdesignexe37** | Write | SInt32 | spDesign.exe (Device) - Depends on L_LocalMachineZoneLockdownSecurity (0: False, 1: True) | `0`, `1` |
| **L_visioexe33** | Write | SInt32 | visio.exe (Device) - Depends on L_LocalMachineZoneLockdownSecurity (0: False, 1: True) | `0`, `1` |
| **L_onenoteexe40** | Write | SInt32 | onent.exe (Device) - Depends on L_LocalMachineZoneLockdownSecurity (0: False, 1: True) | `0`, `1` |
| **L_winprojexe34** | Write | SInt32 | winproj.exe (Device) - Depends on L_LocalMachineZoneLockdownSecurity (0: False, 1: True) | `0`, `1` |
| **L_MimeSniffingSafetyFature** | Write | SInt32 | Mime Sniffing Safety Feature (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_powerpntexe59** | Write | SInt32 | powerpnt.exe (Device) - Depends on L_MimeSniffingSafetyFature (0: False, 1: True) | `0`, `1` |
| **L_exprwdexe66** | Write | SInt32 | exprwd.exe (Device) - Depends on L_MimeSniffingSafetyFature (0: False, 1: True) | `0`, `1` |
| **L_grooveexe56** | Write | SInt32 | groove.exe (Device) - Depends on L_MimeSniffingSafetyFature (0: False, 1: True) | `0`, `1` |
| **L_visioexe61** | Write | SInt32 | visio.exe (Device) - Depends on L_MimeSniffingSafetyFature (0: False, 1: True) | `0`, `1` |
| **L_outlookexe64** | Write | SInt32 | outlook.exe (Device) - Depends on L_MimeSniffingSafetyFature (0: False, 1: True) | `0`, `1` |
| **L_mspubexe58** | Write | SInt32 | mspub.exe (Device) - Depends on L_MimeSniffingSafetyFature (0: False, 1: True) | `0`, `1` |
| **L_mse7exe69** | Write | SInt32 | mse7.exe (Device) - Depends on L_MimeSniffingSafetyFature (0: False, 1: True) | `0`, `1` |
| **L_msaccessexe67** | Write | SInt32 | msaccess.exe (Device) - Depends on L_MimeSniffingSafetyFature (0: False, 1: True) | `0`, `1` |
| **L_pptviewexe60** | Write | SInt32 | pptview.exe (Device) - Depends on L_MimeSniffingSafetyFature (0: False, 1: True) | `0`, `1` |
| **L_winprojexe62** | Write | SInt32 | winproj.exe (Device) - Depends on L_MimeSniffingSafetyFature (0: False, 1: True) | `0`, `1` |
| **L_spdesignexe65** | Write | SInt32 | spDesign.exe (Device) - Depends on L_MimeSniffingSafetyFature (0: False, 1: True) | `0`, `1` |
| **L_onenoteexe68** | Write | SInt32 | onent.exe (Device) - Depends on L_MimeSniffingSafetyFature (0: False, 1: True) | `0`, `1` |
| **L_winwordexe63** | Write | SInt32 | winword.exe (Device) - Depends on L_MimeSniffingSafetyFature (0: False, 1: True) | `0`, `1` |
| **L_excelexe57** | Write | SInt32 | excel.exe (Device) - Depends on L_MimeSniffingSafetyFature (0: False, 1: True) | `0`, `1` |
| **L_NavigateURL** | Write | SInt32 | Navigate URL (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_spdesignexe177** | Write | SInt32 | spDesign.exe (Device) - Depends on L_NavigateURL (0: False, 1: True) | `0`, `1` |
| **L_onenoteexe180** | Write | SInt32 | onent.exe (Device) - Depends on L_NavigateURL (0: False, 1: True) | `0`, `1` |
| **L_pptviewexe172** | Write | SInt32 | pptview.exe (Device) - Depends on L_NavigateURL (0: False, 1: True) | `0`, `1` |
| **L_outlookexe176** | Write | SInt32 | outlook.exe (Device) - Depends on L_NavigateURL (0: False, 1: True) | `0`, `1` |
| **L_winprojexe174** | Write | SInt32 | winproj.exe (Device) - Depends on L_NavigateURL (0: False, 1: True) | `0`, `1` |
| **L_msaccessexe179** | Write | SInt32 | msaccess.exe (Device) - Depends on L_NavigateURL (0: False, 1: True) | `0`, `1` |
| **L_winwordexe175** | Write | SInt32 | winword.exe (Device) - Depends on L_NavigateURL (0: False, 1: True) | `0`, `1` |
| **L_excelexe169** | Write | SInt32 | excel.exe (Device) - Depends on L_NavigateURL (0: False, 1: True) | `0`, `1` |
| **L_mspubexe170** | Write | SInt32 | mspub.exe (Device) - Depends on L_NavigateURL (0: False, 1: True) | `0`, `1` |
| **L_exprwdexe178** | Write | SInt32 | exprwd.exe (Device) - Depends on L_NavigateURL (0: False, 1: True) | `0`, `1` |
| **L_powerpntexe171** | Write | SInt32 | powerpnt.exe (Device) - Depends on L_NavigateURL (0: False, 1: True) | `0`, `1` |
| **L_visioexe173** | Write | SInt32 | visio.exe (Device) - Depends on L_NavigateURL (0: False, 1: True) | `0`, `1` |
| **L_mse7exe181** | Write | SInt32 | mse7.exe (Device) - Depends on L_NavigateURL (0: False, 1: True) | `0`, `1` |
| **L_grooveexe168** | Write | SInt32 | groove.exe (Device) - Depends on L_NavigateURL (0: False, 1: True) | `0`, `1` |
| **L_ObjectCachingProtection** | Write | SInt32 | Object Caching Protection (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_winwordexe77** | Write | SInt32 | winword.exe (Device) - Depends on L_ObjectCachingProtection (0: False, 1: True) | `0`, `1` |
| **L_powerpntexe73** | Write | SInt32 | powerpnt.exe (Device) - Depends on L_ObjectCachingProtection (0: False, 1: True) | `0`, `1` |
| **L_spdesignexe79** | Write | SInt32 | spDesign.exe (Device) - Depends on L_ObjectCachingProtection (0: False, 1: True) | `0`, `1` |
| **L_mse7exe83** | Write | SInt32 | mse7.exe (Device) - Depends on L_ObjectCachingProtection (0: False, 1: True) | `0`, `1` |
| **L_mspubexe72** | Write | SInt32 | mspub.exe (Device) - Depends on L_ObjectCachingProtection (0: False, 1: True) | `0`, `1` |
| **L_msaccessexe81** | Write | SInt32 | msaccess.exe (Device) - Depends on L_ObjectCachingProtection (0: False, 1: True) | `0`, `1` |
| **L_onenoteexe82** | Write | SInt32 | onent.exe (Device) - Depends on L_ObjectCachingProtection (0: False, 1: True) | `0`, `1` |
| **L_outlookexe78** | Write | SInt32 | outlook.exe (Device) - Depends on L_ObjectCachingProtection (0: False, 1: True) | `0`, `1` |
| **L_grooveexe70** | Write | SInt32 | groove.exe (Device) - Depends on L_ObjectCachingProtection (0: False, 1: True) | `0`, `1` |
| **L_excelexe71** | Write | SInt32 | excel.exe (Device) - Depends on L_ObjectCachingProtection (0: False, 1: True) | `0`, `1` |
| **L_visioexe75** | Write | SInt32 | visio.exe (Device) - Depends on L_ObjectCachingProtection (0: False, 1: True) | `0`, `1` |
| **L_pptviewexe74** | Write | SInt32 | pptview.exe (Device) - Depends on L_ObjectCachingProtection (0: False, 1: True) | `0`, `1` |
| **L_winprojexe76** | Write | SInt32 | winproj.exe (Device) - Depends on L_ObjectCachingProtection (0: False, 1: True) | `0`, `1` |
| **L_exprwdexe80** | Write | SInt32 | exprwd.exe (Device) - Depends on L_ObjectCachingProtection (0: False, 1: True) | `0`, `1` |
| **L_ProtectionFromZoneElevation** | Write | SInt32 | Protection From Zone Elevation (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_mspubexe100** | Write | SInt32 | mspub.exe (Device) - Depends on L_ProtectionFromZoneElevation (0: False, 1: True) | `0`, `1` |
| **L_visioexe103** | Write | SInt32 | visio.exe (Device) - Depends on L_ProtectionFromZoneElevation (0: False, 1: True) | `0`, `1` |
| **L_powerpntexe101** | Write | SInt32 | powerpnt.exe (Device) - Depends on L_ProtectionFromZoneElevation (0: False, 1: True) | `0`, `1` |
| **L_excelexe99** | Write | SInt32 | excel.exe (Device) - Depends on L_ProtectionFromZoneElevation (0: False, 1: True) | `0`, `1` |
| **L_mse7exe111** | Write | SInt32 | mse7.exe (Device) - Depends on L_ProtectionFromZoneElevation (0: False, 1: True) | `0`, `1` |
| **L_winwordexe105** | Write | SInt32 | winword.exe (Device) - Depends on L_ProtectionFromZoneElevation (0: False, 1: True) | `0`, `1` |
| **L_exprwdexe108** | Write | SInt32 | exprwd.exe (Device) - Depends on L_ProtectionFromZoneElevation (0: False, 1: True) | `0`, `1` |
| **L_msaccessexe109** | Write | SInt32 | msaccess.exe (Device) - Depends on L_ProtectionFromZoneElevation (0: False, 1: True) | `0`, `1` |
| **L_spdesignexe107** | Write | SInt32 | spDesign.exe (Device) - Depends on L_ProtectionFromZoneElevation (0: False, 1: True) | `0`, `1` |
| **L_onenoteexe110** | Write | SInt32 | onent.exe (Device) - Depends on L_ProtectionFromZoneElevation (0: False, 1: True) | `0`, `1` |
| **L_pptviewexe102** | Write | SInt32 | pptview.exe (Device) - Depends on L_ProtectionFromZoneElevation (0: False, 1: True) | `0`, `1` |
| **L_winprojexe104** | Write | SInt32 | winproj.exe (Device) - Depends on L_ProtectionFromZoneElevation (0: False, 1: True) | `0`, `1` |
| **L_grooveexe98** | Write | SInt32 | groove.exe (Device) - Depends on L_ProtectionFromZoneElevation (0: False, 1: True) | `0`, `1` |
| **L_outlookexe106** | Write | SInt32 | outlook.exe (Device) - Depends on L_ProtectionFromZoneElevation (0: False, 1: True) | `0`, `1` |
| **L_RestrictActiveXInstall** | Write | SInt32 | Restrict ActiveX Install (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_mse7exe** | Write | SInt32 | mse7.exe (Device) - Depends on L_RestrictActiveXInstall (0: False, 1: True) | `0`, `1` |
| **L_powerpntexe** | Write | SInt32 | powerpnt.exe (Device) - Depends on L_RestrictActiveXInstall (0: False, 1: True) | `0`, `1` |
| **L_spDesignexe** | Write | SInt32 | spDesign.exe (Device) - Depends on L_RestrictActiveXInstall (0: False, 1: True) | `0`, `1` |
| **L_onenoteexe** | Write | SInt32 | onent.exe (Device) - Depends on L_RestrictActiveXInstall (0: False, 1: True) | `0`, `1` |
| **L_excelexe** | Write | SInt32 | excel.exe (Device) - Depends on L_RestrictActiveXInstall (0: False, 1: True) | `0`, `1` |
| **L_mspubexe** | Write | SInt32 | mspub.exe (Device) - Depends on L_RestrictActiveXInstall (0: False, 1: True) | `0`, `1` |
| **L_visioexe** | Write | SInt32 | visio.exe (Device) - Depends on L_RestrictActiveXInstall (0: False, 1: True) | `0`, `1` |
| **L_exprwdexe** | Write | SInt32 | exprwd.exe (Device) - Depends on L_RestrictActiveXInstall (0: False, 1: True) | `0`, `1` |
| **L_outlookexe** | Write | SInt32 | outlook.exe (Device) - Depends on L_RestrictActiveXInstall (0: False, 1: True) | `0`, `1` |
| **L_pptviewexe** | Write | SInt32 | pptview.exe (Device) - Depends on L_RestrictActiveXInstall (0: False, 1: True) | `0`, `1` |
| **L_winprojexe** | Write | SInt32 | winproj.exe (Device) - Depends on L_RestrictActiveXInstall (0: False, 1: True) | `0`, `1` |
| **L_winwordexe** | Write | SInt32 | winword.exe (Device) - Depends on L_RestrictActiveXInstall (0: False, 1: True) | `0`, `1` |
| **L_grooveexe** | Write | SInt32 | groove.exe (Device) - Depends on L_RestrictActiveXInstall (0: False, 1: True) | `0`, `1` |
| **L_msaccessexe** | Write | SInt32 | msaccess.exe (Device) - Depends on L_RestrictActiveXInstall (0: False, 1: True) | `0`, `1` |
| **L_RestrictFileDownload** | Write | SInt32 | Restrict File Download (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_visioexe5** | Write | SInt32 | visio.exe (Device) - Depends on L_RestrictFileDownload (0: False, 1: True) | `0`, `1` |
| **L_winprojexe6** | Write | SInt32 | winproj.exe (Device) - Depends on L_RestrictFileDownload (0: False, 1: True) | `0`, `1` |
| **L_msaccessexe11** | Write | SInt32 | msaccess.exe (Device) - Depends on L_RestrictFileDownload (0: False, 1: True) | `0`, `1` |
| **L_spdesignexe9** | Write | SInt32 | spDesign.exe (Device) - Depends on L_RestrictFileDownload (0: False, 1: True) | `0`, `1` |
| **L_excelexe1** | Write | SInt32 | excel.exe (Device) - Depends on L_RestrictFileDownload (0: False, 1: True) | `0`, `1` |
| **L_powerpntexe3** | Write | SInt32 | powerpnt.exe (Device) - Depends on L_RestrictFileDownload (0: False, 1: True) | `0`, `1` |
| **L_mspubexe2** | Write | SInt32 | mspub.exe (Device) - Depends on L_RestrictFileDownload (0: False, 1: True) | `0`, `1` |
| **L_exprwdexe10** | Write | SInt32 | exprwd.exe (Device) - Depends on L_RestrictFileDownload (0: False, 1: True) | `0`, `1` |
| **L_outlookexe8** | Write | SInt32 | outlook.exe (Device) - Depends on L_RestrictFileDownload (0: False, 1: True) | `0`, `1` |
| **L_pptviewexe4** | Write | SInt32 | pptview.exe (Device) - Depends on L_RestrictFileDownload (0: False, 1: True) | `0`, `1` |
| **L_winwordexe7** | Write | SInt32 | winword.exe (Device) - Depends on L_RestrictFileDownload (0: False, 1: True) | `0`, `1` |
| **L_onenoteexe12** | Write | SInt32 | onent.exe (Device) - Depends on L_RestrictFileDownload (0: False, 1: True) | `0`, `1` |
| **L_mse7exe13** | Write | SInt32 | mse7.exe (Device) - Depends on L_RestrictFileDownload (0: False, 1: True) | `0`, `1` |
| **L_grooveexe0** | Write | SInt32 | groove.exe (Device) - Depends on L_RestrictFileDownload (0: False, 1: True) | `0`, `1` |
| **L_SavedfromURL** | Write | SInt32 | Saved from URL (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_pptviewexe158** | Write | SInt32 | pptview.exe (Device) - Depends on L_SavedfromURL (0: False, 1: True) | `0`, `1` |
| **L_exprwdexe164** | Write | SInt32 | exprwd.exe (Device) - Depends on L_SavedfromURL (0: False, 1: True) | `0`, `1` |
| **L_mse7exe167** | Write | SInt32 | mse7.exe (Device) - Depends on L_SavedfromURL (0: False, 1: True) | `0`, `1` |
| **L_spdesignexe163** | Write | SInt32 | spDesign.exe (Device) - Depends on L_SavedfromURL (0: False, 1: True) | `0`, `1` |
| **L_winprojexe160** | Write | SInt32 | winproj.exe (Device) - Depends on L_SavedfromURL (0: False, 1: True) | `0`, `1` |
| **L_mspubexe156** | Write | SInt32 | mspub.exe (Device) - Depends on L_SavedfromURL (0: False, 1: True) | `0`, `1` |
| **L_visioexe159** | Write | SInt32 | visio.exe (Device) - Depends on L_SavedfromURL (0: False, 1: True) | `0`, `1` |
| **L_winwordexe161** | Write | SInt32 | winword.exe (Device) - Depends on L_SavedfromURL (0: False, 1: True) | `0`, `1` |
| **L_msaccessexe165** | Write | SInt32 | msaccess.exe (Device) - Depends on L_SavedfromURL (0: False, 1: True) | `0`, `1` |
| **L_onenoteexe166** | Write | SInt32 | onent.exe (Device) - Depends on L_SavedfromURL (0: False, 1: True) | `0`, `1` |
| **L_outlookexe162** | Write | SInt32 | outlook.exe (Device) - Depends on L_SavedfromURL (0: False, 1: True) | `0`, `1` |
| **L_grooveexe154** | Write | SInt32 | groove.exe (Device) - Depends on L_SavedfromURL (0: False, 1: True) | `0`, `1` |
| **L_excelexe155** | Write | SInt32 | excel.exe (Device) - Depends on L_SavedfromURL (0: False, 1: True) | `0`, `1` |
| **L_powerpntexe157** | Write | SInt32 | powerpnt.exe (Device) - Depends on L_SavedfromURL (0: False, 1: True) | `0`, `1` |
| **L_ScriptedWindowSecurityRestrictions** | Write | SInt32 | Scripted Window Security Restrictions (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_exprwdexe94** | Write | SInt32 | exprwd.exe (Device) - Depends on L_ScriptedWindowSecurityRestrictions (0: False, 1: True) | `0`, `1` |
| **L_mse7exe97** | Write | SInt32 | mse7.exe (Device) - Depends on L_ScriptedWindowSecurityRestrictions (0: False, 1: True) | `0`, `1` |
| **L_mspubexe86** | Write | SInt32 | mspub.exe (Device) - Depends on L_ScriptedWindowSecurityRestrictions (0: False, 1: True) | `0`, `1` |
| **L_outlookexe92** | Write | SInt32 | outlook.exe (Device) - Depends on L_ScriptedWindowSecurityRestrictions (0: False, 1: True) | `0`, `1` |
| **L_msaccessexe95** | Write | SInt32 | msaccess.exe (Device) - Depends on L_ScriptedWindowSecurityRestrictions (0: False, 1: True) | `0`, `1` |
| **L_powerpntexe87** | Write | SInt32 | powerpnt.exe (Device) - Depends on L_ScriptedWindowSecurityRestrictions (0: False, 1: True) | `0`, `1` |
| **L_grooveexe84** | Write | SInt32 | groove.exe (Device) - Depends on L_ScriptedWindowSecurityRestrictions (0: False, 1: True) | `0`, `1` |
| **L_excelexe85** | Write | SInt32 | excel.exe (Device) - Depends on L_ScriptedWindowSecurityRestrictions (0: False, 1: True) | `0`, `1` |
| **L_pptviewexe88** | Write | SInt32 | pptview.exe (Device) - Depends on L_ScriptedWindowSecurityRestrictions (0: False, 1: True) | `0`, `1` |
| **L_spdesignexe93** | Write | SInt32 | spDesign.exe (Device) - Depends on L_ScriptedWindowSecurityRestrictions (0: False, 1: True) | `0`, `1` |
| **L_visioexe89** | Write | SInt32 | visio.exe (Device) - Depends on L_ScriptedWindowSecurityRestrictions (0: False, 1: True) | `0`, `1` |
| **L_onenoteexe96** | Write | SInt32 | onent.exe (Device) - Depends on L_ScriptedWindowSecurityRestrictions (0: False, 1: True) | `0`, `1` |
| **L_winprojexe90** | Write | SInt32 | winproj.exe (Device) - Depends on L_ScriptedWindowSecurityRestrictions (0: False, 1: True) | `0`, `1` |
| **L_winwordexe91** | Write | SInt32 | winword.exe (Device) - Depends on L_ScriptedWindowSecurityRestrictions (0: False, 1: True) | `0`, `1` |

### MSFT_MicrosoftGraphIntuneSettingsCatalogUserSettings_IntuneSecurityBaselineMicrosoft365AppsForEnterprise

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **MicrosoftAccess_Security_TrustCenter_L_BlockMacroExecutionFromInternet** | Write | SInt32 | Block macros from running in Office files from the Internet (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftAccess_Security_TrustCenter_L_DisableTrustBarNotificationforunsigned** | Write | SInt32 | Disable Trust Bar Notification for unsigned application add-ins and block them (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftAccess_Security_TrustCenter_L_RequirethatApplicationExtensionsaresigned** | Write | SInt32 | Require that application add-ins are signed by Trusted Publisher (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftAccess_Security_TrustCenterTrustedLocations_L_AllowTrustedLocationsOnTheNetwork** | Write | SInt32 | Allow Trusted Locations on the network (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftAccess_Security_TrustCenter_L_VBAWarningsPolicy** | Write | SInt32 | VBA Macro Notification Settings (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftAccess_Security_TrustCenter_L_VBAWarningsPolicy_L_Empty** | Write | SInt32 |  - Depends on MicrosoftAccess_Security_TrustCenter_L_VBAWarningsPolicy (2: Disable all with notification, 3: Disable all except digitally signed macros, 4: Disable all without notification, 1: Enable all macros (not recommended)) | `2`, `3`, `4`, `1` |
| **L_Donotshowdataextractionoptionswhenopeningcorruptworkbooks** | Write | SInt32 | Do not show data extraction options when opening corrupt workbooks (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_Asktoupdateautomaticlinks** | Write | SInt32 | Ask to update automatic links (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_LoadpicturesfromWebpagesnotcreatedinExcel** | Write | SInt32 | Load pictures from Web pages not created in Excel (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_DisableAutoRepublish** | Write | SInt32 | Disable AutoRepublish (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_DoNotShowAutoRepublishWarningAlert** | Write | SInt32 | Do not show AutoRepublish warning alert (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_Forcefileextenstionstomatch** | Write | SInt32 | Force file extension to match file type (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_Forcefileextenstionstomatch_L_Empty** | Write | SInt32 |  - Depends on L_Forcefileextenstionstomatch (0: Allow different, 1: Allow different, but warn, 2: Always match file type) | `0`, `1`, `2` |
| **L_DeterminewhethertoforceencryptedExcel** | Write | SInt32 | Scan encrypted macros in Excel Open XML workbooks (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_DeterminewhethertoforceencryptedExcelDropID** | Write | SInt32 |  - Depends on L_DeterminewhethertoforceencryptedExcel (0: Scan encrypted macros (default), 1: Scan if anti-virus software available, 2: Load macros without scanning) | `0`, `1`, `2` |
| **L_BlockXLLFromInternet** | Write | SInt32 | Block Excel XLL Add-ins that come from an untrusted source (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_BlockXLLFromInternetEnum** | Write | SInt32 |  - Depends on L_BlockXLLFromInternet (1: Block, 0: Show Additional Warning, 2: Allow) | `1`, `0`, `2` |
| **MicrosoftExcel_Security_TrustCenter_L_BlockMacroExecutionFromInternet** | Write | SInt32 | Block macros from running in Office files from the Internet (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftExcel_Security_TrustCenter_L_DisableTrustBarNotificationforunsigned** | Write | SInt32 | Disable Trust Bar Notification for unsigned application add-ins and block them (User) (Deprecated) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_EnableBlockUnsecureQueryFiles** | Write | SInt32 | Always prevent untrusted Microsoft Query files from opening (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_DBaseIIIANDIVFiles** | Write | SInt32 | dBase III / IV files (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_DBaseIIIANDIVFilesDropID** | Write | SInt32 | File block setting: (User) - Depends on L_DBaseIIIANDIVFiles (0: Do not block, 2: Open/Save blocked, use open policy) | `0`, `2` |
| **L_DifAndSylkFiles** | Write | SInt32 | Dif and Sylk files (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_DifAndSylkFilesDropID** | Write | SInt32 | File block setting: (User) - Depends on L_DifAndSylkFiles (0: Do not block, 1: Save blocked, 2: Open/Save blocked, use open policy) | `0`, `1`, `2` |
| **L_Excel2MacrosheetsAndAddInFiles** | Write | SInt32 | Excel 2 macrosheets and add-in files (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_Excel2MacrosheetsAndAddInFilesDropID** | Write | SInt32 | File block setting: (User) - Depends on L_Excel2MacrosheetsAndAddInFiles (0: Do not block, 2: Open/Save blocked, use open policy, 3: Block, 4: Open in Protected View, 5: Allow editing and open in Protected View) | `0`, `2`, `3`, `4`, `5` |
| **L_Excel2Worksheets** | Write | SInt32 | Excel 2 worksheets (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_Excel2WorksheetsDropID** | Write | SInt32 | File block setting: (User) - Depends on L_Excel2Worksheets (0: Do not block, 2: Open/Save blocked, use open policy, 3: Block, 4: Open in Protected View, 5: Allow editing and open in Protected View) | `0`, `2`, `3`, `4`, `5` |
| **L_Excel3MacrosheetsAndAddInFiles** | Write | SInt32 | Excel 3 macrosheets and add-in files (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_Excel3MacrosheetsAndAddInFilesDropID** | Write | SInt32 | File block setting: (User) - Depends on L_Excel3MacrosheetsAndAddInFiles (0: Do not block, 2: Open/Save blocked, use open policy, 3: Block, 4: Open in Protected View, 5: Allow editing and open in Protected View) | `0`, `2`, `3`, `4`, `5` |
| **L_Excel3Worksheets** | Write | SInt32 | Excel 3 worksheets (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_Excel3WorksheetsDropID** | Write | SInt32 | File block setting: (User) - Depends on L_Excel3Worksheets (0: Do not block, 2: Open/Save blocked, use open policy, 3: Block, 4: Open in Protected View, 5: Allow editing and open in Protected View) | `0`, `2`, `3`, `4`, `5` |
| **L_Excel4MacrosheetsAndAddInFiles** | Write | SInt32 | Excel 4 macrosheets and add-in files (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_Excel4MacrosheetsAndAddInFilesDropID** | Write | SInt32 | File block setting: (User) - Depends on L_Excel4MacrosheetsAndAddInFiles (0: Do not block, 2: Open/Save blocked, use open policy, 3: Block, 4: Open in Protected View, 5: Allow editing and open in Protected View) | `0`, `2`, `3`, `4`, `5` |
| **L_Excel4Workbooks** | Write | SInt32 | Excel 4 workbooks (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_Excel4WorkbooksDropID** | Write | SInt32 | File block setting: (User) - Depends on L_Excel4Workbooks (0: Do not block, 2: Open/Save blocked, use open policy, 3: Block, 4: Open in Protected View, 5: Allow editing and open in Protected View) | `0`, `2`, `3`, `4`, `5` |
| **L_Excel4Worksheets** | Write | SInt32 | Excel 4 worksheets (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_Excel4WorksheetsDropID** | Write | SInt32 | File block setting: (User) - Depends on L_Excel4Worksheets (0: Do not block, 2: Open/Save blocked, use open policy, 3: Block, 4: Open in Protected View, 5: Allow editing and open in Protected View) | `0`, `2`, `3`, `4`, `5` |
| **L_Excel95Workbooks** | Write | SInt32 | Excel 95 workbooks (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_Excel95WorkbooksDropID** | Write | SInt32 | File block setting: (User) - Depends on L_Excel95Workbooks (0: Do not block, 1: Save blocked, 2: Open/Save blocked, use open policy, 3: Block, 4: Open in Protected View, 5: Allow editing and open in Protected View) | `0`, `1`, `2`, `3`, `4`, `5` |
| **L_Excel9597WorkbooksAndTemplates** | Write | SInt32 | Excel 95-97 workbooks and templates (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_Excel9597WorkbooksAndTemplatesDropID** | Write | SInt32 | File block setting: (User) - Depends on L_Excel9597WorkbooksAndTemplates (0: Do not block, 2: Open/Save blocked, use open policy, 3: Block, 4: Open in Protected View, 5: Allow editing and open in Protected View) | `0`, `2`, `3`, `4`, `5` |
| **L_Excel972003WorkbooksAndTemplates** | Write | SInt32 | Excel 97-2003 workbooks and templates (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_Excel972003WorkbooksAndTemplatesDropID** | Write | SInt32 | File block setting: (User) - Depends on L_Excel972003WorkbooksAndTemplates (0: Do not block, 1: Save blocked, 2: Open/Save blocked, use open policy, 3: Block, 4: Open in Protected View, 5: Allow editing and open in Protected View) | `0`, `1`, `2`, `3`, `4`, `5` |
| **MicrosoftExcel_Security_TrustCenterFileBlockSettings_L_SetDefaultFileBlockBehavior** | Write | SInt32 | Set default file block behavior (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftExcel_Security_TrustCenterFileBlockSettings_L_SetDefaultFileBlockBehaviorDropID** | Write | SInt32 |  - Depends on MicrosoftExcel_Security_TrustCenterFileBlockSettings_L_SetDefaultFileBlockBehavior (0: Blocked files are not opened, 1: Blocked files open in Protected View and can not be edited, 2: Blocked files open in Protected View and can be edited) | `0`, `1`, `2` |
| **L_WebPagesAndExcel2003XMLSpreadsheets** | Write | SInt32 | Web pages and Excel 2003 XML spreadsheets (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_WebPagesAndExcel2003XMLSpreadsheetsDropID** | Write | SInt32 | File block setting: (User) - Depends on L_WebPagesAndExcel2003XMLSpreadsheets (0: Do not block, 1: Save blocked, 2: Open/Save blocked, use open policy, 3: Block, 4: Open in Protected View, 5: Allow editing and open in Protected View) | `0`, `1`, `2`, `3`, `4`, `5` |
| **L_XL4KillSwitchPolicy** | Write | SInt32 | Prevent Excel from running XLM macros (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_EnableDataBaseFileProtectedView** | Write | SInt32 | Always open untrusted database files in Protected View (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftExcel_Security_TrustCenterProtectedView_L_DoNotOpenFilesFromTheInternetZoneInProtectedView** | Write | SInt32 | Do not open files from the Internet zone in Protected View (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftExcel_Security_TrustCenterProtectedView_L_DoNotOpenFilesInUnsafeLocationsInProtectedView** | Write | SInt32 | Do not open files in unsafe locations in Protected View (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftExcel_Security_TrustCenterProtectedView_L_SetDocumentBehaviorIfFileValidationFails** | Write | SInt32 | Set document behavior if file validation fails (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftExcel_Security_TrustCenterProtectedView_L_SetDocumentBehaviorIfFileValidationFailsStr3** | Write | SInt32 | Checked: Allow edit.  Unchecked: Do not allow edit. (User) - Depends on MicrosoftExcel_Security_TrustCenterProtectedView_L_SetDocumentBehaviorIfFileValidationFails (0: False, 1: True) | `0`, `1` |
| **MicrosoftExcel_Security_TrustCenterProtectedView_L_SetDocumentBehaviorIfFileValidationFailsDropID** | Write | SInt32 |  - Depends on MicrosoftExcel_Security_TrustCenterProtectedView_L_SetDocumentBehaviorIfFileValidationFails (0: Block files, 1: Open in Protected View) | `0`, `1` |
| **MicrosoftExcel_Security_TrustCenterProtectedView_L_TurnOffProtectedViewForAttachmentsOpenedFromOutlook** | Write | SInt32 | Turn off Protected View for attachments opened from Outlook (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftExcel_Security_TrustCenter_L_RequirethatApplicationExtensionsaresigned** | Write | SInt32 | Require that application add-ins are signed by Trusted Publisher (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftExcel_Security_TrustCenter_L_DisableTrustBarNotificationforunsigned_v2** | Write | SInt32 | Disable Trust Bar Notification for unsigned application add-ins and block them (User) - Depends on MicrosoftExcel_Security_TrustCenter_L_RequirethatApplicationExtensionsaresigned (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftExcel_Security_TrustCenterTrustedLocations_L_AllowTrustedLocationsOnTheNetwork** | Write | SInt32 | Allow Trusted Locations on the network (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftExcel_Security_TrustCenter_L_VBAWarningsPolicy** | Write | SInt32 | VBA Macro Notification Settings (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_empty4** | Write | SInt32 |  - Depends on MicrosoftExcel_Security_TrustCenter_L_VBAWarningsPolicy (2: Disable VBA macros with notification, 3: Disable VBA macros except digitally signed macros, 4: Disable VBA macros without notification, 1: Enable VBA macros (not recommended)) | `2`, `3`, `4`, `1` |
| **MicrosoftExcel_Security_L_TurnOffFileValidation** | Write | SInt32 | Turn off file validation (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_WebContentWarningLevel** | Write | SInt32 | WEBSERVICE Function Notification Settings (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_WebContentWarningLevelValue** | Write | SInt32 |  - Depends on L_WebContentWarningLevel (0: Enable all WEBSERVICE functions (not recommended), 1: Disable all with notification, 2: Disable all without notification) | `0`, `1`, `2` |
| **L_NoExtensibilityCustomizationFromDocumentPolicy** | Write | SInt32 | Disable UI extending from documents and templates (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_NoExtensibilityCustomizationFromDocumentPolicyWord** | Write | SInt32 | Disallow in Word (User) - Depends on L_NoExtensibilityCustomizationFromDocumentPolicy (0: False, 1: True) | `0`, `1` |
| **L_NoExtensibilityCustomizationFromDocumentPolicyExcel** | Write | SInt32 | Disallow in Excel (User) - Depends on L_NoExtensibilityCustomizationFromDocumentPolicy (0: False, 1: True) | `0`, `1` |
| **L_NoExtensibilityCustomizationFromDocumentPolicyVisio** | Write | SInt32 | Disallow in Visio (User) - Depends on L_NoExtensibilityCustomizationFromDocumentPolicy (0: False, 1: True) | `0`, `1` |
| **L_NoExtensibilityCustomizationFromDocumentPolicyPowerPoint** | Write | SInt32 | Disallow in PowerPoint (User) - Depends on L_NoExtensibilityCustomizationFromDocumentPolicy (0: False, 1: True) | `0`, `1` |
| **L_NoExtensibilityCustomizationFromDocumentPolicyPublisher** | Write | SInt32 | Disallow in Publisher (User) - Depends on L_NoExtensibilityCustomizationFromDocumentPolicy (0: False, 1: True) | `0`, `1` |
| **L_NoExtensibilityCustomizationFromDocumentPolicyOutlook** | Write | SInt32 | Disallow in Outlook (User) - Depends on L_NoExtensibilityCustomizationFromDocumentPolicy (0: False, 1: True) | `0`, `1` |
| **L_NoExtensibilityCustomizationFromDocumentPolicyProject** | Write | SInt32 | Disallow in Project (User) - Depends on L_NoExtensibilityCustomizationFromDocumentPolicy (0: False, 1: True) | `0`, `1` |
| **L_NoExtensibilityCustomizationFromDocumentPolicyAccess** | Write | SInt32 | Disallow in Access (User) - Depends on L_NoExtensibilityCustomizationFromDocumentPolicy (0: False, 1: True) | `0`, `1` |
| **L_NoExtensibilityCustomizationFromDocumentPolicyInfoPath** | Write | SInt32 | Disallow in InfoPath (User) - Depends on L_NoExtensibilityCustomizationFromDocumentPolicy (0: False, 1: True) | `0`, `1` |
| **L_ActiveXControlInitialization** | Write | SInt32 | ActiveX Control Initialization (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_ActiveXControlInitializationcolon** | Write | SInt32 | ActiveX Control Initialization: (User) - Depends on L_ActiveXControlInitialization (1: 1, 2: 2, 3: 3, 4: 4, 5: 5, 6: 6) | `1`, `2`, `3`, `4`, `5`, `6` |
| **L_BasicAuthProxyBehavior** | Write | SInt32 | Allow Basic Authentication prompts from network proxies (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_AllowVbaIntranetRefs** | Write | SInt32 | Allow VBA to load typelib references by path from untrusted intranet locations (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_AutomationSecurity** | Write | SInt32 | Automation Security (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_SettheAutomationSecuritylevel** | Write | SInt32 | Set the Automation Security level (User) - Depends on L_AutomationSecurity (3: Disable macros by default, 2: Use application macro security level, 1: Macros enabled (default)) | `3`, `2`, `1` |
| **L_AuthenticationFBABehavior** | Write | SInt32 | Control how Office handles form-based sign-in prompts (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_AuthenticationFBAEnabledHostsID** | Write | String | Specify hosts allowed to show form-based sign-in prompts to users: (User) - Depends on L_AuthenticationFBABehavior | |
| **L_authenticationFBABehaviorEnum** | Write | SInt32 | Behavior: (User) - Depends on L_AuthenticationFBABehavior (1: Block all prompts, 2: Ask the user what to do for each new host, 3: Show prompts only from allowed hosts) | `1`, `2`, `3` |
| **L_DisableStrictVbaRefsSecurityPolicy** | Write | SInt32 | Disable additional security checks on VBA library references that may refer to unsafe locations on the local machine (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_DisableallTrustBarnotificationsfor** | Write | SInt32 | Disable all Trust Bar notifications for security issues (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_Encryptiontypeforirm** | Write | SInt32 | Encryption mode for Information Rights Management (IRM) (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_Encryptiontypeforirmcolon** | Write | SInt32 | IRM Encryption Mode: (User) - Depends on L_Encryptiontypeforirm (1: Cipher Block Chaining (CBC), 2: Electronic Codebook (ECB)) | `1`, `2` |
| **L_Encryptiontypeforpasswordprotectedoffice972003** | Write | SInt32 | Encryption type for password protected Office 97-2003 files (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_encryptiontypecolon318** | Write | String | Encryption type: (User) - Depends on L_Encryptiontypeforpasswordprotectedoffice972003 | |
| **L_Encryptiontypeforpasswordprotectedofficeopen** | Write | SInt32 | Encryption type for password protected Office Open XML files (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_Encryptiontypecolon** | Write | String | Encryption type: (User) - Depends on L_Encryptiontypeforpasswordprotectedofficeopen | |
| **L_LoadControlsinForms3** | Write | SInt32 | Load Controls in Forms3 (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_LoadControlsinForms3colon** | Write | SInt32 | Load Controls in Forms3: (User) - Depends on L_LoadControlsinForms3 (1: 1, 2: 2, 3: 3, 4: 4) | `1`, `2`, `3`, `4` |
| **L_MacroRuntimeScanScope** | Write | SInt32 | Macro Runtime Scan Scope (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_MacroRuntimeScanScopeEnum** | Write | SInt32 |  - Depends on L_MacroRuntimeScanScope (0: Disable for all documents, 1: Enable for low trust documents, 2: Enable for all documents) | `0`, `1`, `2` |
| **L_Protectdocumentmetadataforrightsmanaged** | Write | SInt32 | Protect document metadata for rights managed Office Open XML Files (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_Allowmixofpolicyanduserlocations** | Write | SInt32 | Allow mix of policy and user locations (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_DisabletheOfficeclientfrompolling** | Write | SInt32 | Disable the Office client from polling the SharePoint Server for published links (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_DisableSmartDocumentsuseofmanifests** | Write | SInt32 | Disable Smart Document's use of manifests (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_OutlookSecurityMode** | Write | SInt32 | Outlook Security Mode (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_OOMAddressAccess** | Write | SInt32 | Configure Outlook object model prompt when reading address information (User) - Depends on L_OutlookSecurityMode (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_OOMAddressAccess_Setting** | Write | SInt32 | Guard behavior: (User) (1: Prompt User, 2: Automatically Approve, 0: Automatically Deny, 3: Prompt user based on computer security) | `1`, `2`, `0`, `3` |
| **L_OOMMeetingTaskRequest** | Write | SInt32 | Configure Outlook object model prompt when responding to meeting and task requests (User) - Depends on L_OutlookSecurityMode (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_OOMMeetingTaskRequest_Setting** | Write | SInt32 | Guard behavior: (User) (1: Prompt User, 2: Automatically Approve, 0: Automatically Deny, 3: Prompt user based on computer security) | `1`, `2`, `0`, `3` |
| **L_OOMSend** | Write | SInt32 | Configure Outlook object model prompt when sending mail (User) - Depends on L_OutlookSecurityMode (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_OOMSend_Setting** | Write | SInt32 | Guard behavior: (User) (1: Prompt User, 2: Automatically Approve, 0: Automatically Deny, 3: Prompt user based on computer security) | `1`, `2`, `0`, `3` |
| **L_Preventusersfromcustomizingattachmentsecuritysettings** | Write | SInt32 | Prevent users from customizing attachment security settings (User) - Depends on L_OutlookSecurityMode (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_RetrievingCRLsCertificateRevocationLists** | Write | SInt32 | Retrieving CRLs (Certificate Revocation Lists) (User) - Depends on L_OutlookSecurityMode (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_empty31** | Write | SInt32 |  (0: Use system Default, 1: When online always retreive the CRL, 2: Never retreive the CRL) | `0`, `1`, `2` |
| **L_OOMFormula** | Write | SInt32 | Configure Outlook object model prompt When accessing the Formula property of a UserProperty object (User) - Depends on L_OutlookSecurityMode (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_OOMFormula_Setting** | Write | SInt32 | Guard behavior: (User) (1: Prompt User, 2: Automatically Approve, 0: Automatically Deny, 3: Prompt user based on computer security) | `1`, `2`, `0`, `3` |
| **L_AuthenticationwithExchangeServer** | Write | SInt32 | Authentication with Exchange Server (User) - Depends on L_OutlookSecurityMode (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_SelecttheauthenticationwithExchangeserver** | Write | String | Select the authentication with Exchange server. (User) (9: Kerberos/NTLM Password Authentication, 16: Kerberos Password Authentication, 10: NTLM Password Authentication, 2147545088: Insert a smart card) | `9`, `16`, `10`, `2147545088` |
| **L_EnableRPCEncryption** | Write | SInt32 | Enable RPC encryption (User) - Depends on L_OutlookSecurityMode (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_Enablelinksinemailmessages** | Write | SInt32 | Allow hyperlinks in suspected phishing e-mail messages (User) - Depends on L_OutlookSecurityMode (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_OOMAddressBook** | Write | SInt32 | Configure Outlook object model prompt when accessing an address book (User) - Depends on L_OutlookSecurityMode (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_OOMAddressBook_Setting** | Write | SInt32 | Guard behavior: (User) (1: Prompt User, 2: Automatically Approve, 0: Automatically Deny, 3: Prompt user based on computer security) | `1`, `2`, `0`, `3` |
| **L_OutlookSecurityPolicy** | Write | SInt32 | Outlook Security Policy: (User) - Depends on L_OutlookSecurityMode (0: Outlook Default Security, 1: Use Security Form from 'Outlook Security Settings' Public Folder, 2: Use Security Form from 'Outlook 10 Security Settings' Public Folder, 3: Use Outlook Security Group Policy) | `0`, `1`, `2`, `3` |
| **L_AllowUsersToLowerAttachments** | Write | SInt32 | Allow users to demote attachments to Level 2 (User) - Depends on L_OutlookSecurityMode (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_AllowActiveXOneOffForms** | Write | SInt32 | Allow Active X One Off Forms (User) - Depends on L_OutlookSecurityMode (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_empty29** | Write | SInt32 | Sets which ActiveX controls to allow. (0: Load only Outlook Controls, 1: Allows only Safe Controls, 2: Allows all ActiveX Controls) | `0`, `1`, `2` |
| **L_EnableScriptsInOneOffForms** | Write | SInt32 | Allow scripts in one-off Outlook forms (User) - Depends on L_OutlookSecurityMode (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_Level2RemoveFilePolicy** | Write | SInt32 | Remove file extensions blocked as Level 2 (User) - Depends on L_OutlookSecurityMode (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_removedextensions25** | Write | String | Removed Extensions: (User) | |
| **L_MSGUnicodeformatwhendraggingtofilesystem** | Write | SInt32 | Use Unicode format when dragging e-mail message to file system (User) - Depends on L_OutlookSecurityMode (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_OnExecuteCustomActionOOM** | Write | SInt32 | Set Outlook object model custom actions execution prompt (User) - Depends on L_OutlookSecurityMode (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_OnExecuteCustomActionOOM_Setting** | Write | SInt32 | When executing a custom action: (User) (1: Prompt User, 2: Automatically Approve, 0: Automatically Deny, 3: Prompt user based on computer security) | `1`, `2`, `0`, `3` |
| **L_DisableOutlookobjectmodelscriptsforpublicfolders** | Write | SInt32 | Do not allow Outlook object model scripts to run for public folders (User) - Depends on L_OutlookSecurityMode (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_BlockInternet** | Write | SInt32 | Include Internet in Safe Zones for Automatic Picture Download (User) - Depends on L_OutlookSecurityMode (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_SecurityLevelOutlook** | Write | SInt32 | Security setting for macros (User) - Depends on L_OutlookSecurityMode (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_SecurityLevel** | Write | SInt32 | Security Level (User) (2: Always warn, 4: Never warn, disable all, 3: Warn for signed, disable unsigned, 1: No security check) | `2`, `4`, `3`, `1` |
| **L_Level1RemoveFilePolicy** | Write | SInt32 | Remove file extensions blocked as Level 1 (User) - Depends on L_OutlookSecurityMode (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_RemovedExtensions** | Write | String | Removed Extensions: (User) | |
| **L_SignatureWarning** | Write | SInt32 | Signature Warning (User) - Depends on L_OutlookSecurityMode (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_signaturewarning30** | Write | SInt32 | Signature Warning (User) (0: Let user decide if they want to be warned, 1: Always warn about invalid signatures, 2: Never warn about invalid signatures) | `0`, `1`, `2` |
| **L_Level1Attachments** | Write | SInt32 | Display Level 1 attachments (User) - Depends on L_OutlookSecurityMode (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_Minimumencryptionsettings** | Write | SInt32 | Minimum encryption settings (User) - Depends on L_OutlookSecurityMode (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_Minimumkeysizeinbits** | Write | SInt32 | Minimum key size (in bits): (User) | |
| **L_DisableOutlookobjectmodelscripts** | Write | SInt32 | Do not allow Outlook object model scripts to run for shared folders (User) - Depends on L_OutlookSecurityMode (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_OOMSaveAs** | Write | SInt32 | Configure Outlook object model prompt when executing Save As (User) - Depends on L_OutlookSecurityMode (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_OOMSaveAs_Setting** | Write | SInt32 | Guard behavior: (User) (1: Prompt User, 2: Automatically Approve, 0: Automatically Deny, 3: Prompt user based on computer security) | `1`, `2`, `0`, `3` |
| **L_JunkEmailprotectionlevel** | Write | SInt32 | Junk E-mail protection level (User) - Depends on L_OutlookSecurityMode (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_Selectlevel** | Write | String | Select level: (User) (4294967295: No Protection, 6: Low (Default), 3: High, 2147483648: Trusted Lists Only) | `4294967295`, `6`, `3`, `2147483648` |
| **L_RunPrograms** | Write | SInt32 | Run Programs (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_RunPrograms_L_Empty** | Write | SInt32 |  - Depends on L_RunPrograms (0: disable (don't run any programs), 1: enable (prompt user before running), 2: enable all (run without prompting)) | `0`, `1`, `2` |
| **L_Determinewhethertoforceencryptedppt** | Write | SInt32 | Scan encrypted macros in PowerPoint Open XML presentations (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_DeterminewhethertoforceencryptedpptDropID** | Write | SInt32 |  - Depends on L_Determinewhethertoforceencryptedppt (0: Scan encrypted macros (default), 1: Scan if anti-virus software available, 2: Load macros without scanning) | `0`, `1`, `2` |
| **MicrosoftPowerPoint_Security_TrustCenter_L_BlockMacroExecutionFromInternet** | Write | SInt32 | Block macros from running in Office files from the Internet (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftPowerPoint_Security_TrustCenter_L_DisableTrustBarNotificationforunsigned** | Write | SInt32 | Disable Trust Bar Notification for unsigned application add-ins and block them (User) (Deprecated) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_PowerPoint972003PresentationsShowsTemplatesandAddInFiles** | Write | SInt32 | PowerPoint 97-2003 presentations, shows, templates and add-in files (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_PowerPoint972003PresentationsShowsTemplatesandAddInFilesDropID** | Write | SInt32 | File block setting: (User) - Depends on L_PowerPoint972003PresentationsShowsTemplatesandAddInFiles (0: Do not block, 1: Save blocked, 2: Open/Save blocked, use open policy, 3: Block, 4: Open in Protected View, 5: Allow editing and open in Protected View) | `0`, `1`, `2`, `3`, `4`, `5` |
| **MicrosoftPowerPoint_Security_TrustCenterFileBlockSettings_L_SetDefaultFileBlockBehavior** | Write | SInt32 | Set default file block behavior (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftPowerPoint_Security_TrustCenterFileBlockSettings_L_SetDefaultFileBlockBehaviorDropID** | Write | SInt32 |  - Depends on MicrosoftPowerPoint_Security_TrustCenterFileBlockSettings_L_SetDefaultFileBlockBehavior (0: Blocked files are not opened, 1: Blocked files open in Protected View and can not be edited, 2: Blocked files open in Protected View and can be edited) | `0`, `1`, `2` |
| **MicrosoftPowerPoint_Security_TrustCenterProtectedView_L_DoNotOpenFilesFromTheInternetZoneInProtectedView** | Write | SInt32 | Do not open files from the Internet zone in Protected View (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftPowerPoint_Security_TrustCenterProtectedView_L_DoNotOpenFilesInUnsafeLocationsInProtectedView** | Write | SInt32 | Do not open files in unsafe locations in Protected View (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftPowerPoint_Security_TrustCenterProtectedView_L_SetDocumentBehaviorIfFileValidationFails** | Write | SInt32 | Set document behavior if file validation fails (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftPowerPoint_Security_TrustCenterProtectedView_L_SetDocumentBehaviorIfFileValidationFailsStr3** | Write | SInt32 | Checked: Allow edit.  Unchecked: Do not allow edit. (User) - Depends on MicrosoftPowerPoint_Security_TrustCenterProtectedView_L_SetDocumentBehaviorIfFileValidationFails (0: False, 1: True) | `0`, `1` |
| **MicrosoftPowerPoint_Security_TrustCenterProtectedView_L_SetDocumentBehaviorIfFileValidationFailsDropID** | Write | SInt32 |  - Depends on MicrosoftPowerPoint_Security_TrustCenterProtectedView_L_SetDocumentBehaviorIfFileValidationFails (0: Block files, 1: Open in Protected View) | `0`, `1` |
| **MicrosoftPowerPoint_Security_TrustCenterProtectedView_L_TurnOffProtectedViewForAttachmentsOpenedFromOutlook** | Write | SInt32 | Turn off Protected View for attachments opened from Outlook (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftPowerPoint_Security_TrustCenter_L_RequirethatApplicationExtensionsaresigned** | Write | SInt32 | Require that application add-ins are signed by Trusted Publisher (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftPowerPoint_Security_TrustCenter_L_DisableTrustBarNotificationforunsigned_v2** | Write | SInt32 | Disable Trust Bar Notification for unsigned application add-ins and block them (User) - Depends on MicrosoftPowerPoint_Security_TrustCenter_L_RequirethatApplicationExtensionsaresigned (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftPowerPoint_Security_TrustCenterTrustedLocations_L_AllowTrustedLocationsOnTheNetwork** | Write | SInt32 | Allow Trusted Locations on the network (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftPowerPoint_Security_TrustCenter_L_VBAWarningsPolicy** | Write | SInt32 | VBA Macro Notification Settings (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_empty3** | Write | SInt32 |  - Depends on MicrosoftPowerPoint_Security_TrustCenter_L_VBAWarningsPolicy (2: Disable all with notification, 3: Disable all except digitally signed macros, 4: Disable all without notification, 1: Enable all macros (not recommended)) | `2`, `3`, `4`, `1` |
| **MicrosoftPowerPoint_Security_L_TurnOffFileValidation** | Write | SInt32 | Turn off file validation (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftProject_Security_TrustCenter_L_AllowTrustedLocationsOnTheNetwork** | Write | SInt32 | Allow Trusted Locations on the network (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftProject_Security_TrustCenter_L_DisableTrustBarNotificationforunsigned** | Write | SInt32 | Disable Trust Bar Notification for unsigned application add-ins and block them (User) (Deprecated) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftProject_Security_TrustCenter_L_RequirethatApplicationExtensionsaresigned** | Write | SInt32 | Require that application add-ins are signed by Trusted Publisher (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftProject_Security_TrustCenter_L_DisableTrustBarNotificationforunsigned_v2** | Write | SInt32 | Disable Trust Bar Notification for unsigned application add-ins and block them (User) - Depends on MicrosoftProject_Security_TrustCenter_L_RequirethatApplicationExtensionsaresigned (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftProject_Security_TrustCenter_L_VBAWarningsPolicy** | Write | SInt32 | VBA Macro Notification Settings (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftProject_Security_TrustCenter_L_VBAWarningsPolicy_L_Empty** | Write | SInt32 |  - Depends on MicrosoftProject_Security_TrustCenter_L_VBAWarningsPolicy (2: Disable all with notification, 3: Disable all except digitally signed macros, 4: Disable all without notification, 1: Enable all macros (not recommended)) | `2`, `3`, `4`, `1` |
| **L_PublisherAutomationSecurityLevel** | Write | SInt32 | Publisher Automation Security Level (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_PublisherAutomationSecurityLevel_L_Empty** | Write | SInt32 |  - Depends on L_PublisherAutomationSecurityLevel (1: Low (enabled), 2: By UI (prompted), 3: High (disabled)) | `1`, `2`, `3` |
| **MicrosoftPublisherV3_Security_TrustCenter_L_BlockMacroExecutionFromInternet** | Write | SInt32 | Block macros from running in Office files from the internet (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftPublisherV2_Security_TrustCenter_L_DisableTrustBarNotificationforunsigned** | Write | SInt32 | Disable Trust Bar Notification for unsigned application add-ins (User) (Deprecated) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftPublisherV2_Security_TrustCenter_L_RequirethatApplicationExtensionsaresigned** | Write | SInt32 | Require that application add-ins are signed by Trusted Publisher (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftPublisherV2_Security_TrustCenter_L_DisableTrustBarNotificationforunsigned_v2** | Write | SInt32 | Disable Trust Bar Notification for unsigned application add-ins (User) - Depends on MicrosoftPublisherV2_Security_TrustCenter_L_RequirethatApplicationExtensionsaresigned (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftPublisherV2_Security_TrustCenter_L_VBAWarningsPolicy** | Write | SInt32 | VBA Macro Notification Settings (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_empty0** | Write | SInt32 |  - Depends on MicrosoftPublisherV2_Security_TrustCenter_L_VBAWarningsPolicy (2: Disable all with notification, 3: Disable all except digitally signed macros, 4: Disable all without notification, 1: Enable all macros (not recommended)) | `2`, `3`, `4`, `1` |
| **MicrosoftVisio_Security_TrustCenter_L_AllowTrustedLocationsOnTheNetwork** | Write | SInt32 | Allow Trusted Locations on the network (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftVisio_Security_TrustCenter_L_BlockMacroExecutionFromInternet** | Write | SInt32 | Block macros from running in Office files from the Internet (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftVisio_Security_TrustCenter_L_DisableTrustBarNotificationforunsigned** | Write | SInt32 | Disable Trust Bar Notification for unsigned application add-ins and block them (User) (Deprecated) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_Visio2000Files** | Write | SInt32 | Visio 2000-2002 Binary Drawings, Templates and Stencils (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_Visio2000FilesDropID** | Write | SInt32 | File block setting: (User) - Depends on L_Visio2000Files (0: Do not block, 2: Open/Save blocked) | `0`, `2` |
| **L_Visio2003Files** | Write | SInt32 | Visio 2003-2010 Binary Drawings, Templates and Stencils (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_Visio2003FilesDropID** | Write | SInt32 | File block setting: (User) - Depends on L_Visio2003Files (0: Do not block, 1: Save blocked, 2: Open/Save blocked) | `0`, `1`, `2` |
| **L_Visio50AndEarlierFiles** | Write | SInt32 | Visio 5.0 or earlier Binary Drawings, Templates and Stencils (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_Visio50AndEarlierFilesDropID** | Write | SInt32 | File block setting: (User) - Depends on L_Visio50AndEarlierFiles (0: Do not block, 2: Open/Save blocked) | `0`, `2` |
| **MicrosoftVisio_Security_TrustCenter_L_RequirethatApplicationExtensionsaresigned** | Write | SInt32 | Require that application add-ins are signed by Trusted Publisher (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftVisio_Security_TrustCenter_L_DisableTrustBarNotificationforunsigned_v2** | Write | SInt32 | Disable Trust Bar Notification for unsigned application add-ins and block them (User) - Depends on MicrosoftVisio_Security_TrustCenter_L_RequirethatApplicationExtensionsaresigned (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftVisio_Security_TrustCenter_L_VBAWarningsPolicy** | Write | SInt32 | VBA Macro Notification Settings (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftVisio_Security_TrustCenter_L_VBAWarningsPolicy_L_Empty** | Write | SInt32 |  - Depends on MicrosoftVisio_Security_TrustCenter_L_VBAWarningsPolicy (2: Disable all with notification, 3: Disable all except digitally signed macros, 4: Disable all without notification, 1: Enable all macros (not recommended)) | `2`, `3`, `4`, `1` |
| **MicrosoftWord_Security_TrustCenter_L_BlockMacroExecutionFromInternet** | Write | SInt32 | Block macros from running in Office files from the Internet (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftWord_Security_TrustCenter_L_DisableTrustBarNotificationforunsigned** | Write | SInt32 | Disable Trust Bar Notification for unsigned application add-ins and block them (User) (Deprecated) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_AllowDDE** | Write | SInt32 | Dynamic Data Exchange (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_AllowDDEDropID** | Write | SInt32 | Dynamic Data Exchange setting (User) - Depends on L_AllowDDE (1: Limited Dynamic Data Exchange, 2: Allow Dynamic Data Exchange) | `1`, `2` |
| **MicrosoftWord_Security_TrustCenterFileBlockSettings_L_SetDefaultFileBlockBehavior** | Write | SInt32 | Set default file block behavior (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftWord_Security_TrustCenterFileBlockSettings_L_SetDefaultFileBlockBehaviorDropID** | Write | SInt32 |  - Depends on MicrosoftWord_Security_TrustCenterFileBlockSettings_L_SetDefaultFileBlockBehavior (0: Blocked files are not opened, 1: Blocked files open in Protected View and can not be edited, 2: Blocked files open in Protected View and can be edited) | `0`, `1`, `2` |
| **L_Word2AndEarlierBinaryDocumentsAndTemplates** | Write | SInt32 | Word 2 and earlier binary documents and templates (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_Word2AndEarlierBinaryDocumentsAndTemplatesDropID** | Write | SInt32 | File block setting: (User) - Depends on L_Word2AndEarlierBinaryDocumentsAndTemplates (0: Do not block, 2: Open/Save blocked, use open policy, 3: Block, 4: Open in Protected View, 5: Allow editing and open in Protected View) | `0`, `2`, `3`, `4`, `5` |
| **L_Word2000BinaryDocumentsAndTemplates** | Write | SInt32 | Word 2000 binary documents and templates (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_Word2000BinaryDocumentsAndTemplatesDropID** | Write | SInt32 | File block setting: (User) - Depends on L_Word2000BinaryDocumentsAndTemplates (0: Do not block, 2: Open/Save blocked, use open policy, 3: Block, 4: Open in Protected View, 5: Allow editing and open in Protected View) | `0`, `2`, `3`, `4`, `5` |
| **L_Word2003BinaryDocumentsAndTemplates** | Write | SInt32 | Word 2003 binary documents and templates (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_Word2003BinaryDocumentsAndTemplatesDropID** | Write | SInt32 | File block setting: (User) - Depends on L_Word2003BinaryDocumentsAndTemplates (0: Do not block, 2: Open/Save blocked, use open policy, 3: Block, 4: Open in Protected View, 5: Allow editing and open in Protected View) | `0`, `2`, `3`, `4`, `5` |
| **L_Word2007AndLaterBinaryDocumentsAndTemplates** | Write | SInt32 | Word 2007 and later binary documents and templates (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_Word2007AndLaterBinaryDocumentsAndTemplatesDropID** | Write | SInt32 | File block setting: (User) - Depends on L_Word2007AndLaterBinaryDocumentsAndTemplates (0: Do not block, 1: Save blocked, 2: Open/Save blocked, use open policy, 3: Block, 4: Open in Protected View, 5: Allow editing and open in Protected View) | `0`, `1`, `2`, `3`, `4`, `5` |
| **L_Word6Pt0BinaryDocumentsAndTemplates** | Write | SInt32 | Word 6.0 binary documents and templates (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_Word6Pt0BinaryDocumentsAndTemplatesDropID** | Write | SInt32 | File block setting: (User) - Depends on L_Word6Pt0BinaryDocumentsAndTemplates (0: Do not block, 2: Open/Save blocked, use open policy, 3: Block, 4: Open in Protected View, 5: Allow editing and open in Protected View) | `0`, `2`, `3`, `4`, `5` |
| **L_Word95BinaryDocumentsAndTemplates** | Write | SInt32 | Word 95 binary documents and templates (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_Word95BinaryDocumentsAndTemplatesDropID** | Write | SInt32 | File block setting: (User) - Depends on L_Word95BinaryDocumentsAndTemplates (0: Do not block, 2: Open/Save blocked, use open policy, 3: Block, 4: Open in Protected View, 5: Allow editing and open in Protected View) | `0`, `2`, `3`, `4`, `5` |
| **L_Word97BinaryDocumentsAndTemplates** | Write | SInt32 | Word 97 binary documents and templates (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_Word97BinaryDocumentsAndTemplatesDropID** | Write | SInt32 | File block setting: (User) - Depends on L_Word97BinaryDocumentsAndTemplates (0: Do not block, 2: Open/Save blocked, use open policy, 3: Block, 4: Open in Protected View, 5: Allow editing and open in Protected View) | `0`, `2`, `3`, `4`, `5` |
| **L_WordXPBinaryDocumentsAndTemplates** | Write | SInt32 | Word XP binary documents and templates (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_WordXPBinaryDocumentsAndTemplatesDropID** | Write | SInt32 | File block setting: (User) - Depends on L_WordXPBinaryDocumentsAndTemplates (0: Do not block, 2: Open/Save blocked, use open policy, 3: Block, 4: Open in Protected View, 5: Allow editing and open in Protected View) | `0`, `2`, `3`, `4`, `5` |
| **MicrosoftWord_Security_TrustCenterProtectedView_L_DoNotOpenFilesFromTheInternetZoneInProtectedView** | Write | SInt32 | Do not open files from the Internet zone in Protected View (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftWord_Security_TrustCenterProtectedView_L_DoNotOpenFilesInUnsafeLocationsInProtectedView** | Write | SInt32 | Do not open files in unsafe locations in Protected View (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftWord_Security_TrustCenterProtectedView_L_SetDocumentBehaviorIfFileValidationFails** | Write | SInt32 | Set document behavior if file validation fails (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftWord_Security_TrustCenterProtectedView_L_SetDocumentBehaviorIfFileValidationFailsDropID** | Write | SInt32 |  - Depends on MicrosoftWord_Security_TrustCenterProtectedView_L_SetDocumentBehaviorIfFileValidationFails (0: Block files, 1: Open in Protected View) | `0`, `1` |
| **MicrosoftWord_Security_TrustCenterProtectedView_L_SetDocumentBehaviorIfFileValidationFailsStr3** | Write | SInt32 | Checked: Allow edit.  Unchecked: Do not allow edit. (User) - Depends on MicrosoftWord_Security_TrustCenterProtectedView_L_SetDocumentBehaviorIfFileValidationFails (0: False, 1: True) | `0`, `1` |
| **MicrosoftWord_Security_TrustCenterProtectedView_L_TurnOffProtectedViewForAttachmentsOpenedFromOutlook** | Write | SInt32 | Turn off Protected View for attachments opened from Outlook (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftWord_Security_TrustCenter_L_RequirethatApplicationExtensionsaresigned** | Write | SInt32 | Require that application add-ins are signed by Trusted Publisher (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftWord_Security_TrustCenter_L_DisableTrustBarNotificationforunsigned_v2** | Write | SInt32 | Disable Trust Bar Notification for unsigned application add-ins and block them (User) - Depends on MicrosoftWord_Security_TrustCenter_L_RequirethatApplicationExtensionsaresigned (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_DeterminewhethertoforceencryptedWord** | Write | SInt32 | Scan encrypted macros in Word Open XML documents (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_DeterminewhethertoforceencryptedWordDropID** | Write | SInt32 |  - Depends on L_DeterminewhethertoforceencryptedWord (0: Scan encrypted macros (default), 1: Scan if anti-virus software available, 2: Load macros without scanning) | `0`, `1`, `2` |
| **MicrosoftWord_Security_TrustCenter_L_VBAWarningsPolicy** | Write | SInt32 | VBA Macro Notification Settings (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **L_empty19** | Write | SInt32 |  - Depends on MicrosoftWord_Security_TrustCenter_L_VBAWarningsPolicy (2: Disable all with notification, 3: Disable all except digitally signed macros, 4: Disable all without notification, 1: Enable all macros (not recommended)) | `2`, `3`, `4`, `1` |
| **MicrosoftWord_Security_L_TurnOffFileValidation** | Write | SInt32 | Turn off file validation (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftWord_Security_TrustCenterTrustedLocations_L_AllowTrustedLocationsOnTheNetwork** | Write | SInt32 | Allow Trusted Locations on the network (User) (0: Disabled, 1: Enabled) | `0`, `1` |


## Description

Intune Security Baseline Microsoft365 Apps For Enterprise

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Group.Read.All, DeviceManagementConfiguration.Read.All

- **Update**

    - Group.Read.All, DeviceManagementConfiguration.ReadWrite.All

#### Application permissions

- **Read**

    - Group.Read.All, DeviceManagementConfiguration.Read.All

- **Update**

    - Group.Read.All, DeviceManagementConfiguration.ReadWrite.All

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneSecurityBaselineMicrosoft365AppsForEnterprise 'mySecurityBaselineMicrosoft365AppsForEnterprisePolicy'
        {
            DisplayName           = 'test'
            DeviceSettings = MSFT_MicrosoftGraphIntuneSettingsCatalogDeviceSettings_IntuneSecurityBaselineMicrosoft365AppsForEnterprise
            {
                L_ProtectionFromZoneElevation = '1'
                L_grooveexe98 = '1'
                L_excelexe99 = '1'
                L_mspubexe100 = '1'
                L_powerpntexe101 = '1'
                L_pptviewexe102 = '1'
                L_visioexe103 = '1'
                L_winprojexe104 = '1'
                L_winwordexe105 = '1'
                L_outlookexe106 = '1'
                L_spdesignexe107 = '1'
                L_exprwdexe108 = '1'
                L_msaccessexe109 = '1'
                L_onenoteexe110 = '1'
                L_mse7exe111 = '1'
            }
            UserSettings = MSFT_MicrosoftGraphIntuneSettingsCatalogUserSettings_IntuneSecurityBaselineMicrosoft365AppsForEnterprise
            {
                MicrosoftPublisherV3_Security_TrustCenter_L_BlockMacroExecutionFromInternet = '1'
                MicrosoftVisio_Security_TrustCenter_L_VBAWarningsPolicy = '1'
                MicrosoftVisio_Security_TrustCenter_L_VBAWarningsPolicy_L_Empty = '3'
            }
            Ensure                = 'Present'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
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
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneSecurityBaselineMicrosoft365AppsForEnterprise 'mySecurityBaselineMicrosoft365AppsForEnterprisePolicy'
        {
            DisplayName           = 'test'
            DeviceSettings = MSFT_MicrosoftGraphIntuneSettingsCatalogDeviceSettings_IntuneSecurityBaselineMicrosoft365AppsForEnterprise
            {
                L_ProtectionFromZoneElevation = '1'
                L_grooveexe98 = '1'
                L_excelexe99 = '1'
                L_mspubexe100 = '1'
                L_powerpntexe101 = '1'
                L_pptviewexe102 = '1'
                L_visioexe103 = '1'
                L_winprojexe104 = '1'
                L_winwordexe105 = '1'
                L_outlookexe106 = '1'
                L_spdesignexe107 = '1'
                L_exprwdexe108 = '1'
                L_msaccessexe109 = '1'
                L_onenoteexe110 = '1'
                L_mse7exe111 = '1'
            }
            UserSettings = MSFT_MicrosoftGraphIntuneSettingsCatalogUserSettings_IntuneSecurityBaselineMicrosoft365AppsForEnterprise
            {
                MicrosoftPublisherV3_Security_TrustCenter_L_BlockMacroExecutionFromInternet = '1'
                MicrosoftVisio_Security_TrustCenter_L_VBAWarningsPolicy = '1'
                MicrosoftVisio_Security_TrustCenter_L_VBAWarningsPolicy_L_Empty = '2' # Updated property
            }
            Ensure                = 'Present'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
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
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneSecurityBaselineMicrosoft365AppsForEnterprise 'mySecurityBaselineMicrosoft365AppsForEnterprisePolicy'
        {
            DisplayName           = 'test'
            Ensure                = 'Absent'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

