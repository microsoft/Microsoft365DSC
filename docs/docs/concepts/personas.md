# Personas

This article describes the personas we've identified for Microsoft365DSC and provides additional insights about what each one is trying to achieve and how we recommend they configure authentication. For each persona, we provide the permissions that are required to either deploy configuration changes (including creating new instances of components) and to backup and monitor these configuration settings. If you are only interested in taking snapshots/backups of current configuration settings or to monitor existing settings for configuration drifts, then only read-only permissions are required (with some exceptions). On the other hand, if you are trying to create new instances of components (e.g., new policy) or to update existing ones, then write permissions will also be needed on top of the read permissions.

As mentioned in our User Guide section, there are three main types of authentication allowed in Microsoft365DSC:

- **Credentials:** uses a user's account to authenticate using a username/password combination. This type of authentication requires Role-Based Access Control (RBAC) permissions to be granted to the account. For Microsoft Graph based resources, credential authentication requires a combination of RBAC roles on the user account and API Permissions granted to the Microsoft Graph Command Line Tools enterprise app. These roles and permissions can be determined by looking at the settings.json file of the associated resources you are trying to interact with.

  Example: To use Credentials authentication to monitor Azure AD Conditional Access Policies, the user account needs Security Reader RBAC permission at minimum, and the Microsoft Graph Command Line Tools enterprise app needs the Policy.Read.All API permission.

- **Service Principal:** requires defining an Azure AD app registration and granting it the proper API permissions (or assigning it RBAC roles). Authentication uses an Application ID with either a Certificate Thumbprint or an Application Secret.

- **Managed Identity:** not covered in this article due to lack of support across all workloads. Refer to [Authentication Examples](../user-guide/get-started/authentication-examples.md#example-5-managed-identity) for examples on how to use Managed Identity with resources.

---

## Azure AD / Entra

| Identity Administrator | | |
| - | - | - |
| ![Identity Administrator](../Images/Personas/IdentityAdmin.jpg){ width=300 } | **Description:** | The Identity Administrators are responsible for managing users and groups settings. They define what permissions users and service principals are granted in the tenant. They work with components such as: <br> <ul><li>AADAdministrativeUnit</li><li>AADApplication</li><li>AADGroups</li><li>AADGroupsNamingPolicy</li><li>AADRoleDefinition</li><li>AADServicePrincipal</li><li>AADUser</li><li>etc.</li></ul> |
| | **Associated Azure AD Roles:** | **Create & Update** <br> <ul><li>Groups Administrator</li><li>Identity Governance Administrator</li><li>Security Administrator</li><li>User Administrator</li></ul> **Export & Monitor** <br> <ul><li>Global Reader</li><li>Security Reader</li></ul>|

---

| Security Administrator | | |
| - | - | - |
| ![Security Administrator](../Images/Personas/SecurityAdmin.jpg){ width=300 } | **Description:** | Security Administrators define and update Entra Identity policies and monitor them for configuration drift across tenants. Their goal is to ensure tenant security by enforcing authorized operations. They work with components such as: <br> <ul><li>AADAuthenticationMethodPolicy</li><li>AADAuthorizationPolicy</li><li>AADConditionalAccessPolicy</li><li>AADCrossTenantAccessPolicy</li><li>AADEntitlementManagementAccessPackage</li><li>etc.</li></ul> |
| | **Associated Azure AD Roles:** | **Create & Update** <br> <ul><li>Authentication Policy Administrator</li><li>Conditional Access Administrator</li><li>Privileged Role Administrator</li><li>Security Administrator</li></ul> **Export & Monitor** <br> <ul><li>Global Reader</li><li>Security Reader</li></ul>|

---

## Exchange Online

| Exchange Administrator | | |
| - | - | - |
| ![Exchange Administrator](../Images/Personas/ExchangeAdmin.jpg){ width=300 } | **Description:** | Exchange Administrators ensure mail and calendar functionality and secure communications. They work with components such as: <br> <ul><li>EXOAntiphishPolicy</li><li>EXOMalwareFilterRule</li><li>EXOPerimeterConfiguration</li><li>EXOTransportRule</li><li>etc.</li></ul> |
| | **Associated Azure AD Roles:** | **Create & Update** <br> <ul><li>Exchange Administrator</li></ul> **Export & Monitor** <br> <ul><li>Global Reader</li><li>Security Reader</li></ul>|

---

## Microsoft Teams

| Teams Collaboration Administrator | | |
| - | - | - |
| ![Teams Collaboration Administrator](../Images/Personas/CollabAdmin.jpg){ width=300 } | **Description:** | Teams Collaboration Administrators manage Teams collaboration features (channels, teams) and their policies (e.g., channel and messaging policies). They work with components such as: <br> <ul><li>TeamsAppPermissionPolicy</li><li>TeamsChannel</li><li>TeamsMessagingPolicy</li><li>TeamsShiftPolicy</li><li>etc.</li></ul> |
| | **Associated Azure AD Roles:** | **Create & Update** <br> <ul><li>Teams Administrator</li></ul> **Export & Monitor** <br> <ul><li>Global Reader</li></ul>|

| Teams Voice Administrator | | |
| - | - | - |
| ![Teams Voice Administrator](../Images/Personas/VoiceAdmin.jpg){ width=300 } | **Description:** | Teams Voice Administrators manage voice features in Teams (IP phone policies, voicemail, dial plans). They work with components such as: <br> <ul><li>TeamsEmergencyCallingPolicy</li><li>TeamsIPPhonePolicy</li><li>TeamsOnlineVoicemailPolicy</li><li>TeamsTenantDialPlan</li><li>etc.</li></ul> |
| | **Associated Azure AD Roles:** | **Create & Update** <br> <ul><li>Teams Administrator</li></ul> **Export & Monitor** <br> <ul><li>Global Reader</li></ul>|
