# EXOPolicyTipConfig

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies the custom Policy Tip you want to modify. ||
| **Value** | Write | String | The Value parameter specifies the text that's displayed by the Policy Tip. ||
| **Ensure** | Write | String | Specify if the Policy Tip Config should exist or not. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||

# EXOPolicyTipConfig

### Description

This resource configures Policy Tips in Exchange Online.


