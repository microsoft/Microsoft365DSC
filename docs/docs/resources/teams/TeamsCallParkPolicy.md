# TeamsCallParkPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | A unique identifier for the policy - this will be used to retrieve the policy later on to assign it to specific users. | |
| **AllowCallPark** | Write | Boolean | If set to true, customers will be able to leverage the call park feature to place calls on hold and then decide how the call should be handled - transferred to another department, retrieved using the same phone, or retrieved using a different phone. | |
| **Description** | Write | String | Description of the Teams Call Park Policy. | |
| **ParkTimeoutSeconds** | Write | UInt64 | Specify the number of seconds to wait before ringing the parker when the parked call hasn't been picked up. Value can be from 120 to 1800 (seconds). | |
| **PickupRangeEnd** | Write | UInt64 | Specify the maximum value that a rendered pickup code can take. Value can be from 10 to 9999. Note: PickupRangeStart must be smaller than PickupRangeEnd. | |
| **PickupRangeStart** | Write | UInt64 | Specify the minimum value that a rendered pickup code can take. Value can be from 10 to 9999. | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |


## Description

The TeamsCallParkPolicy controls whether or not users are able to leverage the call park feature in Microsoft Teams. Call park allows enterprise voice customers to place a call on hold and then perform a number of actions on that call: transfer to another department, retrieve via the same phone, or retrieve via a different Teams phone. The New-CsTeamsCallParkPolicy resource lets you create a new custom policy that can then be assigned to one or more specific users.

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
        TeamsCallParkPolicy 'Example'
        {
            AllowCallPark        = $False;
            Credential           = $Credscredential;
            Ensure               = "Present";
            Identity             = "Global";
            ParkTimeoutSeconds   = 300;
            PickupRangeEnd       = 99;
            PickupRangeStart     = 10;
        }
    }
}
```

