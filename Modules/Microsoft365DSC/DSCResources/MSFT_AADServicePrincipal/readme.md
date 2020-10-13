# AADServicePrincipal

## Description

This resource configures an Azure Active Directory ServicePrincipal.

## Azure AD Permissions

To authenticate via Azure Active Directory, this resource required the following Application permissions:

* **Automate**
  * microsoft.directory/servicePrincipals/appRoleAssignedTo/read
  * microsoft.directory/servicePrincipals/appRoleAssignments/read
  * microsoft.directory/servicePrincipals/standard/read
  * microsoft.directory/servicePrincipals/memberOf/read
  * microsoft.directory/servicePrincipals/oAuth2PermissionGrants/read
  * microsoft.directory/servicePrincipals/owners/read
  * microsoft.directory/servicePrincipals/ownedObjects/read
  * microsoft.directory/servicePrincipals/policies/read
  * microsoft.directory/servicePrincipals/synchronizationCredentials/manage

  Alternatively you can also assign the Application the "Directory writers" role.

* **Export**
  * microsoft.directory/servicePrincipals/appRoleAssignedTo/read
  * microsoft.directory/servicePrincipals/appRoleAssignments/read
  * microsoft.directory/servicePrincipals/standard/read
  * microsoft.directory/servicePrincipals/memberOf/read
  * microsoft.directory/servicePrincipals/oAuth2PermissionGrants/read
  * microsoft.directory/servicePrincipals/owners/read
  * microsoft.directory/servicePrincipals/ownedObjects/read
  * microsoft.directory/servicePrincipals/policies/read

  Alternatively you can also assign the Application the "Directory readers" role.

NOTE: All permisions listed above require admin consent.
