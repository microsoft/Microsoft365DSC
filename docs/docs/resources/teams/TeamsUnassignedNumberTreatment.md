# TeamsUnassignedNumberTreatment

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Id of the treatment. | |
| **Description** | Write | String | Free format description of this treatment. | |
| **Pattern** | Write | String | A regular expression that the called number must match in order for the treatment to take effect. It is best pratice to start the regular expression with the hat character and end it with the dollar character. You can use various regular expression test sites on the Internet to validate the expression. | |
| **Target** | Write | String | The identity of the destination the call should be routed to. Depending on the TargetType it should either be the ObjectId of the user or application instance/resource account or the AudioFileId of the uploaded audio file. | |
| **TargetType** | Write | String | The type of target used for the treatment. Allowed values are User, ResourceAccount and Announcement. | `User`, `ResourceAccount`, `Announcement` |
| **TreatmentPriority** | Write | UInt32 | The priority of the treatment. Used to distinguish identical patterns. The lower the priority the higher preference. The priority needs to be unique. | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

Creates a new treatment for how calls to an unassigned number range should be routed. The call can be routed to a user, an application or to an announcement service where a custom message will be played to the caller.

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
        TeamsUnassignedNumberTreatment 'Example'
        {
            Credential           = $Credscredential;
            Ensure               = "Present";
            Identity             = "TR2";
            Pattern              = "^\+15552224444$";
            Target               = "ae274f0a-9c9c-496a-8dd3-8a57640d93aa";
            TargetType           = "User";
            TreatmentPriority    = 3;
        }
    }
}
```

