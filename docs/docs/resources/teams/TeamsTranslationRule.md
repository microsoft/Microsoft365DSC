# TeamsTranslationRule

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identifier of the rule. This parameter is required and later used to assign the rule to the Inbound or Outbound Trunk Normalization policy. | |
| **Description** | Write | String | A friendly description of the normalization rule. | |
| **Pattern** | Write | String | A regular expression that caller or callee number must match in order for this rule to be applied. | |
| **Translation** | Write | String | The regular expression pattern that will be applied to the number to convert it. | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |


## Description

Cmdlet to create a new telephone number manipulation rule.

## Permissions


