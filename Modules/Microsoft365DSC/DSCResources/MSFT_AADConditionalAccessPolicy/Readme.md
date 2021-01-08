# AADConditionalAccessPolicy

## Description

This resource configures an Azure Active Directory Conditional Access Policy.

## Azure AD Permissions

To authenticate via Azure Active Directory, this resource required the following Application permissions:

* **Automate**
  * Application.Read.All
  * Group.Read.All
  * Directory.Read.All
  * Policy.Read.All
  * Policy.Read.ConditionalAccess
  * Policy.ReadWrite.ConditionalAccess
  * RoleManagement.Read.All
  * RoleManagement.Read.Directory
  * User.Read.All

* **Export**
  * Application.Read.All
  * Group.Read.All
  * Directory.Read.All
  * Policy.Read.All
  * Policy.Read.ConditionalAccess
  * RoleManagement.Read.All
  * RoleManagement.Read.Directory
  * User.Read.All

NOTE: All permisions listed above require admin consent.

Additionally Global Reader Role needs to be assigned, as long as AAD PowerShell is not fully converged to use GRAPH API
