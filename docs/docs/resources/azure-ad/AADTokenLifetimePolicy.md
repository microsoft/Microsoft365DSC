# AADTokenLifetimePolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | DisplayName of the Policy ||
| **Id** | Write | String | ObjectID of the Policy. ||
| **Description** | Write | String | Description of the Policy. ||
| **Definition** | Write | StringArray[] | Definition of the Policy. ||
| **IsOrganizationDefault** | Write | Boolean | IsOrganizationDefault of the Policy. ||
| **Ensure** | Write | String | Specify if the Azure AD Policy should exist or not. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials for the Microsoft Graph delegated permissions. ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **ApplicationSecret** | Write | String | Secret of the Azure Active Directory application to authenticate with. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||

# AADTokenLifetimePolicy

### Description

This resource configures the Azure AD Token Lifetime Policies

## Azure AD Permissions

To authenticate via Azure Active Directory, this resource required the following Application permissions:

* **Automate**
  * Policy.Read.All,Policy.ReadWrite.ApplicationConfiguration
* **Export**
  * None

NOTE: All permisions listed above require admin consent.


