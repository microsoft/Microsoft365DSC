# TeamsOnlineVoiceUser

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Specifies the identity of the target user. ||
| **LocationID** | Write | String | Specifies the unique identifier of the emergency location to assign to the user. Location identities can be discovered by using the Get-CsOnlineLisLocation cmdlet. ||
| **TelephoneNumber** | Write | String | Specifies the telephone number to be assigned to the user. The value must be in E.164 format: +14255043920. Setting the value to $Null clears the user's telephone number. ||
| **Ensure** | Write | String | Present ensures the online voice user exists, absent ensures it is removed. |Present, Absent|
| **Credential** | Required | PSCredential | Credentials of the Teams Global Admin. ||


# TeamsOnlineVoiceUser

### Description

This resource configures the Teams Online Voice User.

## Examples

### Example 1

This example adds a new Teams Voice Route.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsCredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        TeamsOnlineVOiceUser 'AssignVoiceUser'
        {
            Identity        = 'John.Smith@Contoso.com'
            TelephoneNumber = "1800-555-1234"
            LocationId      = "c7c5a17f-00d7-47c0-9ddb-3383229d606"
            Ensure          = "Present"
            Credential      = $credsCredential
        }
    }
}
```

