# Personas

This article describes the personas we've identified for Microsoft365DSC and provides additional insights about what each one is trying to achieve and how we recommend they configure authentication. For each persona, we provide the permissions that are required to either deploy configuration changes (including creating new instances of components) and to backup and monitor these configuration settings. If you are only interested in taking snapshots/backups of current configuration settings or to monitor existing settings for configuration drifts, than only read-only permissions are required (with some exceptions). On the other hand, if you are trying to create new instances of components (e.g., new policy) or to update existing ones, then write permissions will also be needed on top of the read permissions.

<p>As mentioned in our User Guide section, there are three main types of authentication allowed in Microsoft365DSC:
<ul>
<li><p><strong>Credentials:</strong> which uses a user's account to authenticate using a username/password combination. This type of authenticate requires Role-Based Access Control (RBAC) permissions to be granted to the account. For credential authentication to work with Microsoft Graph based resources, a combination of RBAC permission on the user account as well as API Permissions on the Microsoft Graph Command Line Tools enterprise app will need to be granted. These roles and permissions can be determined by looking at the settings.json file of the associated resources you are trying to interact with.
</p><br />
<p>For example, if you are trying to use Credentials authentication to monitor Azure AD Conditional Access Policies, the user account will need to be granted the Security Reader RBAC permission at a minimum and the Microsoft Graph Command Line Tools enterprise app will need to be granted the Policy.Read.All API permission.
</li>
</p>
<br/>
<li><strong>Service Principal:</strong> which requires the organization to define an Azure AD app registration and grant it the proper API permissions (or assign it to RBAC roles). This type of authentication requires the users to specify an Application ID and Certificate Thumbprint or Application Secret combination to authenticate.</li>
<br/>
<li><strong>Managed Identity:</strong> which is not covered as part of this article due to the lack of support across all workloads.</li>
</ul>
</p>
## Azure AD/ Entra

<!--- Identity Admin --->
<table width="100%">
<tr>
    <td width="10%" colspan="3">
        <strong>Identity Administrator</strong>
    </td>
</tr>
<tr>
<td width="25%" rowspan="2"><img src="/Images/Personas/IdentityAdmin.jpg"/></td>
<td style="text-align:right"><strong>Description:</strong></td>
<td><p>The Identity Administrators are responsible managing users and groups settings. As part of their role, they are responsible for defining what permissions users and service principals are granted in the tenant. They are dealing with components such as:</p>
<ul>
    <li>AADAdministrativeUnit</li>
    <li>AADApplication</li>
    <li>AADGroups</li>
    <li>AADGroupsNamingPolicy</li>
    <li>AADRoleDefinition</li>
    <li>AADServicePrincipal</li>
    <li>AADUser</li>
    <li>Etc.</li>
</ul>
</td>
</tr>

<tr><td style="text-align:right"><strong>Associated Azure AD Roles:</strong></td>
<td>
<p><strong>Create & Update:</strong><ul>
<li>Groups Administrator</li>
<li>Identity Governance Administrator</li>
<li>Security Administrator</li>
<li>User Administrator</li>
</ul></p>

<p><strong>Export & Monitor:</strong>
<ul>
<li>Global Reader</li>
<li>Security Reader</li>
</ul></p>
</td>
</tr>
</table>

<!--- Security Admin --->
<table width="100%">
<tr>
    <td width="10%" colspan="3">
        <strong>Security Administrator</strong>
    </td>
</tr>
<tr>
<td width="25%" rowspan="2"><img src="/Images/Personas/SecurityAdmin.jpg"/></td>
<td style="text-align:right"><strong>Description:</strong></td>
<td><p>The Security Administrators are responsible for defining new Entra Identity policies, make updates to existing ones and monitor them for configuration drifts at scale and across one or multiple tenants. Their goal is to ensure the overal security of the tenant by ensuring only authorized users can perform certain tasks. They are dealing with components such as:</p>
<ul>
    <li>AADAuthenticationMethodPolicy</li>
    <li>AADAuthorizationPolicy</li>
    <li>AADConditionalAccessPolicy</li>
    <li>AADCrossTenantAccessPolicy</li>
    <li>AADEntitlementManagementAccessPackage</li>
    <li>Etc.</li>
</ul>
</td>
</tr>

<tr><td style="text-align:right"><strong>Associated Azure AD Roles:</strong></td>
<td>
<p><strong>Create & Update:</strong><ul>
<li>Authentication Policy Administrator</li>
<li>Conditional Access Administrator</li>
<li>Privileged Role Administrator</li>
<li>Security Administrator</li>
</ul></p>

<p><strong>Export & Monitor:</strong>
<ul>
<li>Global Reader</li>
<li>Security Reader</li>
</ul></p>
</td>
</tr>
</table>

## Exchange Online

<!--- Exchange Online Admin --->
<table width="100%">
<tr>
    <td width="10%" colspan="3">
        <strong>Exchange Administrator</strong>
    </td>
</tr>
<tr>
<td width="25%" rowspan="2"><img src="/Images/Personas/ExchangeAdmin.jpg"/></td>
<td style="text-align:right"><strong>Description:</strong></td>
<td><p>The Exchange Administrators are responsible for ensuring the proper functioning of the mail and calendar functionality as well as securing communications between internal employees and with external entities. They are dealing with components such as:</p>
<ul>
    <li>EXOAntiphishPolicy</li>
    <li>EXOMalwareFilterRule</li>
    <li>EXOPerimeterConfiguration</li>
    <li>EXOTransportRule</li>
    <li>Etc.</li>
</ul>
</td>
</tr>

<tr><td style="text-align:right"><strong>Associated Azure AD Roles:</strong></td>
<td>
<p><strong>Create & Update:</strong><ul>
<li>Exchange Administrator</li>
</ul></p>

<p><strong>Export & Monitor:</strong>
<ul>
<li>Global Reader</li>
<li>Security Reader</li>
</ul></p>
</td>
</tr>
</table>

## Microsoft Teams

<!--- Teams Collaboration Admin --->
<table width="100%">
<tr>
    <td width="10%" colspan="3">
        <strong>Teams Collaboration Administrator</strong>
    </td>
</tr>
<tr>
<td width="25%" rowspan="2"><img src="/Images/Personas/CollabAdmin.jpg"/></td>
<td style="text-align:right"><strong>Description:</strong></td>
<td><p>The Teams Collaboration Administrators are responsible for ensuring the proper functioning of the Teams collaboration features, such as managing channels, managing teams, etc. and for their associated policies (e.g., Teams Channel Policies, Teams Messaging Policies, etc.). They are dealing with components such as:</p>
<ul>
    <li>TeamsAppPermissionPolicy</li>
    <li>TeamsChannel</li>
    <li>TeamsMessagingPolicy</li>
    <li>TeamsShiftPolicy</li>
    <li>Etc.</li>
</ul>
</td>
</tr>

<tr><td style="text-align:right"><strong>Associated Azure AD Roles:</strong></td>
<td>
<p><strong>Create & Update:</strong><ul>
<li>Teams Administrator</li>
</ul></p>

<p><strong>Export & Monitor:</strong>
<ul>
<li>Global Reader</li>
</ul></p>
</td>
</tr>
</table>

<!--- Teams Voice Admin --->
<table width="100%">
<tr>
    <td width="10%" colspan="3">
        <strong>Teams Voice Administrator</strong>
    </td>
</tr>
<tr>
<td width="25%" rowspan="2"><img src="/Images/Personas/VoiceAdmin.jpg"/></td>
<td style="text-align:right"><strong>Description:</strong></td>
<td><p>The Teams Voice Administrators are responsible for ensuring the proper functioning of the voice features in Teams, such as managing IP Phone policies, Voicemail settings, Dial plans, etc. They are dealing with components such as:</p>
<ul>
    <li>TeamsEmergencyCallingPolicy</li>
    <li>TeamsIPPhonePolicy</li>
    <li>TeamsOnlineVoicemailPolicy</li>
    <li>TeamsTenantDialPlan</li>
    <li>Etc.</li>
</ul>
</td>
</tr>

<tr><td style="text-align:right"><strong>Associated Azure AD Roles:</strong></td>
<td>
<p><strong>Create & Update:</strong><ul>
<li>Teams Administrator</li>
</ul></p>

<p><strong>Export & Monitor:</strong>
<ul>
<li>Global Reader</li>
</ul></p>
</td>
</tr>
</table>
