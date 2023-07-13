# Personas

This article describes the personas we've identified for Microsoft365DSC and provides additional insights about what each one is trying to achieve and how we recommend they configure authentication. For each personas, we provide the permissions that are required to either deploy configuration changes (including creating new instances of components) and to backup and monitor these configuration settings. If you are only interested in taking snapshots/backups of current configuration settings or to monitor existing settings for configuration drifts, than only read-only permissions are required (with some exceptions). On the other hand, if you are trying to create new instances of components (e.g., new policy) or to update existing ones, then write permissions will also be needed on top of the read permissions.

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
## The Security Administrator

As a Security Administrator, I want to define new Entra Identity policies, make updates to exsting ones and monitor them for configuration drifts at scale and across one or multiple tenants.

<table width="100%">
<tr>
<td width="25%" rowspan="2"><img src="../Images/Personas/SecurityAdmin.jpg"/></td>
<td width="10%" style="text-align:right"><strong>Role:</strong></td><td width="65%">Security Administrator</td>
</tr>
<tr><td style="text-align:right"><strong>Required Permissions:</strong></td>
<td>
<table width="100%">
<tr><th width="100%" colspan="2">Credentials</th></tr>
<tr>
<td width="25%" style="text-align:right">Create & Update</td>
<td width="75%"><ul>
<li>
Microsoft Graph Command Line Tools
<ul>
    <li>Domain.Read.All</li>
    <li>openid</li>
    <li>profile</li>
    <li>offline_access</li>
    <li><em>any additional permissions required by the associated resources.</em></li>
</ul>
</li>
</ul></td>
</tr>
<tr>
<td width="25%" style="text-align:right">Export/Monitor</td>
<td width="75%"><ul>
<li>
Microsoft Graph Command Line Tools
<ul>
    <li>Domain.Read.All</li>
    <li>openid</li>
    <li>profile</li>
    <li>offline_access</li>
    <li><em>any additional permissions required by the associated resources.</em></li>
</ul>
</li>
</ul></td>
</tr>
</table>
</td>
</tr>
</table>
