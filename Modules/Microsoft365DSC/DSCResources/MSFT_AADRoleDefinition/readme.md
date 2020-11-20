# AADRoleDefintiion

## Description

This resource configures an Azure Active Directory role definition.
To configure custom roles you require an Azure AD Premium P1 license.
The account used to configure role definitions based on this resource needs either to be a
"Global Administrator" or a "Privileged role administrator".

## Azure AD Permissions

To authenticate via Azure Active Directory, this resource required the following Application permissions:

* **Automate**
  * Directory.ReadWrite.All
  * RoleManagement.ReadWrite.Directory
* **Export**
  * RoleManagement.Read.Directory
  * Directory.Read.All

NOTE: All permisions listed above require admin consent.
