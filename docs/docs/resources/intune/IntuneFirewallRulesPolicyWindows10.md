# IntuneFirewallRulesPolicyWindows10

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Description** | Write | String | Policy description | |
| **DisplayName** | Key | String | Policy name | |
| **RoleScopeTagIds** | Write | StringArray[] | List of Scope Tags for this Entity instance. | |
| **Id** | Write | String | The unique identifier for an entity. Read-only. | |
| **FirewallRuleName** | Write | MSFT_MicrosoftGraphIntuneSettingsCatalogFirewallRuleName[] | Firewall Rules | |
| **Assignments** | Write | MSFT_DeviceManagementConfigurationPolicyAssignments[] | Represents the assignment to the Intune policy. | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

### MSFT_DeviceManagementConfigurationPolicyAssignments

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **dataType** | Write | String | The type of the target assignment. | `#microsoft.graph.groupAssignmentTarget`, `#microsoft.graph.allLicensedUsersAssignmentTarget`, `#microsoft.graph.allDevicesAssignmentTarget`, `#microsoft.graph.exclusionGroupAssignmentTarget`, `#microsoft.graph.configurationManagerCollectionAssignmentTarget` |
| **deviceAndAppManagementAssignmentFilterType** | Write | String | The type of filter of the target assignment i.e. Exclude or Include. Possible values are:none, include, exclude. | `none`, `include`, `exclude` |
| **deviceAndAppManagementAssignmentFilterId** | Write | String | The Id of the filter for the target assignment. | |
| **groupId** | Write | String | The group Id that is the target of the assignment. | |
| **groupDisplayName** | Write | String | The group Display Name that is the target of the assignment. | |
| **collectionId** | Write | String | The collection Id that is the target of the assignment.(ConfigMgr) | |

### MSFT_MicrosoftGraphIntuneSettingsCatalogFirewallRuleName

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Enabled** | Write | String | Enabled - Depends on FirewallRuleName (0: Disabled, 1: Enabled) | `0`, `1` |
| **Name** | Write | String | Name - Depends on FirewallRuleName | |
| **InterfaceTypes** | Write | StringArray[] | Interface Types - Depends on FirewallRuleName (remoteaccess: RemoteAccess, wireless: Wireless, lan: Lan, mobilebroadband: MobileBroadband, mbb: MBB, all: All) | `remoteaccess`, `wireless`, `lan`, `mobilebroadband`, `mbb`, `all` |
| **FilePath** | Write | String | File Path - Depends on FirewallRuleName | |
| **RemotePortRanges** | Write | StringArray[] | Remote Port Ranges - Depends on FirewallRuleName | |
| **EdgeTraversal** | Write | String | Edge Traversal - Depends on FirewallRuleName (0: Disabled, 1: Enabled) | `0`, `1` |
| **LocalUserAuthorizedList** | Write | StringArray[] | Local User Authorized List - Depends on FirewallRuleName | |
| **Profiles** | Write | SInt32Array[] | Network Types - Depends on FirewallRuleName (1: FW_PROFILE_TYPE_DOMAIN:  This value represents the profile for networks that are connected to domains., 2: FW_PROFILE_TYPE_STANDARD:  This value represents the standard profile for networks. These networks are classified as private by the administrators in the server host. The classification happens the first time the host connects to the network. Usually these networks are behind Network Address Translation (NAT) devices, routers, and other edge devices, and they are in a private location, such as a home or an office. AND FW_PROFILE_TYPE_PRIVATE:  This value represents the profile for private networks, which is represented by the same value as that used for FW_PROFILE_TYPE_STANDARD., 4: FW_PROFILE_TYPE_PUBLIC:  This value represents the profile for public networks. These networks are classified as public by the administrators in the server host. The classification happens the first time the host connects to the network. Usually these networks are those at airports, coffee shops, and other public places where the peers in the network or the network administrator are not trusted., 2147483647: FW_PROFILE_TYPE_ALL:  This value represents all these network sets and any future network sets., -2147483648: FW_PROFILE_TYPE_CURRENT:  This value represents the current profiles to which the firewall and advanced security components determine the host is connected at the moment of the call. This value can be specified only in method calls, and it cannot be combined with other flags.) | `1`, `2`, `4`, `2147483647`, `-2147483648` |
| **LocalPortRanges** | Write | StringArray[] | Local Port Ranges - Depends on FirewallRuleName | |
| **Description** | Write | String | Description - Depends on FirewallRuleName | |
| **PolicyAppId** | Write | String | Policy App Id - Depends on FirewallRuleName | |
| **PackageFamilyName** | Write | String | Package Family Name - Depends on FirewallRuleName | |
| **LocalAddressRanges** | Write | StringArray[] | Local Address Ranges - Depends on FirewallRuleName | |
| **Direction** | Write | String | Direction - Depends on FirewallRuleName (in: The rule applies to inbound traffic., out: The rule applies to outbound traffic.) | `in`, `out` |
| **ServiceName** | Write | String | Service Name - Depends on FirewallRuleName | |
| **RemoteAddressRanges** | Write | StringArray[] | Remote Address Ranges - Depends on FirewallRuleName | |
| **Type** | Write | String | Action - Depends on FirewallRuleName (0: Block, 1: Allow) | `0`, `1` |
| **RemoteAddressDynamicKeywords** | Write | StringArray[] | Reusable groups - Depends on FirewallRuleName | |
| **Protocol** | Write | SInt32 | Protocol - Depends on FirewallRuleName | |
| **IcmpTypesAndCodes** | Write | StringArray[] | ICMP Types And Codes - Depends on FirewallRuleName | |


## Description

Intune Firewall Rules Policy for Windows10

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - DeviceManagementConfiguration.Read.All, Group.Read.All

- **Update**

    - DeviceManagementConfiguration.ReadWrite.All, Group.Read.All

#### Application permissions

- **Read**

    - DeviceManagementConfiguration.Read.All, Group.Read.All

- **Update**

    - DeviceManagementConfiguration.ReadWrite.All, Group.Read.All

## Examples

### Example 1

This example creates a new Intune Firewall Policy for Windows10.

```powershell
Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneFirewallRulesPolicyWindows10 'myIntuneFirewallRulesPolicyWindows10'
        {
            Assignments           = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.groupAssignmentTarget'
                    groupId = '11111111-1111-1111-1111-111111111111'
                }
            );
            FirewallRuleName = @(
                MSFT_MicrosoftGraphIntuneSettingsCatalogFirewallRuleName{
                    Direction = 'out'
                    InterfaceTypes = @('lan')
                    RemotePortRanges = @('0-100')
                    Name = 'Rule1'
                    FilePath = 'C:\Temp'
                    Protocol = 80
                    ServiceName = 'mysvc'
                    Enabled = '1'
                    Type = '1'
                }
            )
            Description           = 'Description'
            DisplayName           = "Intune Firewall Rules Policy Windows10";
            Ensure                = "Present";
            Id                    = '00000000-0000-0000-0000-000000000000'
            RoleScopeTagIds       = @("0");
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

### Example 2

This example updates a Intune Firewall Policy for Windows10.

```powershell
Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneFirewallRulesPolicyWindows10 'myIntuneFirewallRulesPolicyWindows10'
        {
            Assignments           = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.groupAssignmentTarget'
                    groupId = '11111111-1111-1111-1111-111111111111'
                }
            );
            FirewallRuleName = @(
                MSFT_MicrosoftGraphIntuneSettingsCatalogFirewallRuleName{
                    Direction = 'in' # Updated property
                    InterfaceTypes = @('lan')
                    RemotePortRanges = @('0-100')
                    Name = 'Rule1'
                    FilePath = 'C:\Temp'
                    Protocol = 80
                    ServiceName = 'mysvc'
                    Enabled = '1'
                    Type = '1'
                }
            )
            Description           = 'Description'
            DisplayName           = "Intune Firewall Rules Policy Windows10";
            Ensure                = "Present";
            Id                    = '00000000-0000-0000-0000-000000000000'
            RoleScopeTagIds       = @("0");
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

### Example 3

This example removes a Device Control Policy.

```powershell
Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneFirewallRulesPolicyWindows10 'myIntuneFirewallRulesPolicyWindows10'
        {
            Id          = '00000000-0000-0000-0000-000000000000'
            DisplayName = 'Intune Firewall Rules Policy Windows10'
            Ensure      = 'Absent'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

