# TeamsEmergencyCallRoutingPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **EmergencyDialString** | Write | String | Specifies the emergency phone number. ||
| **EmergencyDialMask** | Write | String | For each Teams emergency number, you can specify zero or more emergency dial masks. A dial mask is a number that you want to translate into the value of the emergency dial number value when it is dialed. ||
| **OnlinePSTNUsage** | Write | String | Specify the online public switched telephone network (PSTN) usage ||
| **Identity** | Key | String | Identity of the Teams Emergency Call Routing Policy. ||
| **Description** | Write | String | Description of the Teams Emergency Call Routing Policy. ||
| **EmergencyNumbers** | Write | InstanceArray[] | Emergency number(s) associated with the policy. ||
| **AllowEnhancedEmergencyServices** | Write | Boolean | Flag to enable Enhanced Emergency Services ||
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. |Present, Absent|
| **Credential** | Required | PSCredential | Credentials of the Teams Admin. ||


# TeamsEmergencyCallRoutingPolicy

This resource configures the Teams Emergency Call Routing Policies.

## Examples

### Example 1

This example adds a new Teams Emergency Call Routing Policy.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        TeamsEmergencyCallRoutingPolicy 'EmergencyCallRoutingPolicyExample'
        {
            Identity                       = "Unit Test"
            AllowEnhancedEmergencyServices = $False
            Description                    = "Description"
            EmergencyNumbers               = @(
                MSFT_TeamsEmergencyNumber
                {
                    EmergencyDialString = '123456'
                    EmergencyDialMask   = '123'
                    OnlinePSTNUsage     = ''
                }
            )
            Ensure                         = "Present"
            Credential                     = $credsGlobalAdmin
        }
    }
}
```

