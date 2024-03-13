# TeamsWorkloadPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Unique identity for the Teams workload policy | |
| **AllowCalling** | Write | Boolean | Allows calling. | |
| **AllowCallingPinned** | Write | Boolean | Allows pinning a call. | |
| **AllowMeeting** | Write | Boolean | Allows meetins. | |
| **AllowMeetingPinned** | Write | Boolean | Allows pinning meetings. | |
| **AllowMessaging** | Write | Boolean | Allows messaging. | |
| **AllowMessagingPinned** | Write | Boolean | Allows pinning a message. | |
| **Description** | Write | String | Description of the policy. | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |


## Description

This resources implements a Teams workload policy.


## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - None

- **Update**

    - None

#### Application permissions

- **Read**

    - Organization.Read.All

- **Update**

    - Organization.Read.All

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        TeamsWorkloadPolicy 'Example'
        {
            AllowCalling         = $True;
            AllowCallingPinned   = $True;
            AllowMeeting         = $True;
            AllowMeetingPinned   = $True;
            AllowMessaging       = $True;
            AllowMessagingPinned = $True;
            Credential           = $Credscredential;
            Ensure               = "Present";
            Identity             = "Global";
        }
    }
}
```

