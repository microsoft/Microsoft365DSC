# IntuneEpmElevationRulesPolicyWindows10

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Description** | Write | String | Policy description | |
| **DisplayName** | Key | String | Policy name | |
| **RoleScopeTagIds** | Write | StringArray[] | List of Scope Tags for this Entity instance. | |
| **Id** | Write | String | The unique identifier for an entity. Read-only. | |
| **ElevationRuleName** | Write | MSFT_MicrosoftGraphIntuneSettingsCatalogElevationRuleName[] | Elevation Rule Name | |
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
| **dataType** | Write | String | The type of the target assignment. | `#microsoft.graph.cloudPcManagementGroupAssignmentTarget`, `#microsoft.graph.groupAssignmentTarget`, `#microsoft.graph.allLicensedUsersAssignmentTarget`, `#microsoft.graph.allDevicesAssignmentTarget`, `#microsoft.graph.exclusionGroupAssignmentTarget`, `#microsoft.graph.configurationManagerCollectionAssignmentTarget` |
| **deviceAndAppManagementAssignmentFilterType** | Write | String | The type of filter of the target assignment i.e. Exclude or Include. Possible values are:none, include, exclude. | `none`, `include`, `exclude` |
| **deviceAndAppManagementAssignmentFilterId** | Write | String | The Id of the filter for the target assignment. | |
| **deviceAndAppManagementAssignmentFilterDisplayName** | Write | String | The display name of the filter for the target assignment. | |
| **groupId** | Write | String | The group Id that is the target of the assignment. | |
| **groupDisplayName** | Write | String | The group Display Name that is the target of the assignment. | |
| **collectionId** | Write | String | The collection Id that is the target of the assignment.(ConfigMgr) | |

### MSFT_MicrosoftGraphIntuneSettingsCatalogElevationRuleName

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **ChildProcessBehavior** | Write | String | Child process behavior (allowrunelevated: AllowRunElevated, allowrunelevatedrulerequired: AllowRunElevatedRuleRequired, deny: Deny) | `allowrunelevated`, `allowrunelevatedrulerequired`, `deny` |
| **FileName** | Required | String | File name | |
| **Name** | Required | String | Rule name | |
| **FilePath** | Write | String | File path | |
| **ProductName** | Write | String | Product name | |
| **AppliesTo** | Write | String | Applies to (allusers: Allusers) | `allusers` |
| **Description** | Write | String | Description | |
| **FileVersion** | Write | String | Minimum version | |
| **InternalName** | Write | String | Internal name | |
| **FileHash** | Write | String | File hash. Required, if no certificate is used. | |
| **FileDescription** | Write | String | File description | |
| **SignatureSource** | Write | SInt32 | Signature source (0: ReusableCertificate, 1: NewCertificate) | `0`, `1` |
| **CertificateType** | Write | String | Certificate type (publisher: Publisher, issuingauthority: IssuingAuthority) | `publisher`, `issuingauthority` |
| **CertificatePayloadWithReusableSetting** | Write | String | Certificate | |
| **CertificateFileUpload** | Write | String | File upload | |
| **Elevationtype** | Required | String | Elevation type (self: Userconfirmed, automatic: Automatic, deny: Deny, supportarbitrated: Supportapproved, userconfirmeduser: UserConfirmedUser) | `self`, `automatic`, `deny`, `supportarbitrated`, `userconfirmeduser` |
| **UserConfirmedUserElevationTypeValidation** | Write | SInt32Array[] | User Confirmed User Validation (2: Windows Authentication) | `2` |
| **ElevationTypeValidation** | Write | SInt32Array[] | Validation (1: Business Justification, 2: Windows Authentication) | `1`, `2` |
| **RestrictArguments** | Write | String | Restrict Arguments (allow: Allow) | `allow` |
| **ArgumentList** | Write | StringArray[] | Argument List | |


## Description

Intune Epm Elevation Rules Policy for Windows10

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
        IntuneEpmElevationRulesPolicyWindows10 'Example'
        {
            Assignments           = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.groupAssignmentTarget'
                    groupId = '11111111-1111-1111-1111-111111111111'
                }
            );
            Description                 = 'Description'
            DisplayName                 = "IntuneEpmElevationRulesPolicyWindows10_1";
            ElevationRuleName     = @(
                MSFT_MicrosoftGraphIntuneSettingsCatalogElevationRuleName{
                    ChildProcessBehavior = "allowrunelevated"
                    FilePath = "C:\temp"
                    FileVersion = "1.1.1.1"
                    CertificateType = "publisher"
                    FileDescription = "File Description"
                    Elevationtype = "self"
                    FileName = "file.exe"
                    ElevationTypeValidation = @(
                        1
                        2
                    )
                    Name = "Rule name"
                    RestrictArguments = "allow"
                    Description = "Description"
                    CertificatePayloadWithReusableSetting = "IntuneEpmCertificatePolicySetting_1"
                    AppliesTo = "allusers"
                    ProductName = "Product name"
                    InternalName = "Internal name"
                    SignatureSource = 0
                }
                MSFT_MicrosoftGraphIntuneSettingsCatalogElevationRuleName{
                    ChildProcessBehavior = "allowrunelevatedrulerequired"
                    CertificateType = "issuingauthority"
                    Elevationtype = "automatic"
                    FileName = "file2.exe"
                    Name = "Rule 2"
                    CertificatePayloadWithReusableSetting = "IntuneEpmCertificatePolicySetting_1"
                    AppliesTo = "allusers"
                    SignatureSource = 0
                }
            );
            Ensure                      = "Present";
            Id                          = '00000000-0000-0000-0000-000000000000'
            RoleScopeTagIds             = @("0");
            ApplicationId               = $ApplicationId;
            TenantId                    = $TenantId;
            CertificateThumbprint       = $CertificateThumbprint;
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
        IntuneEpmElevationRulesPolicyWindows10 'Example'
        {
            Assignments           = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.groupAssignmentTarget'
                    groupId = '11111111-1111-1111-1111-111111111111'
                }
            );
            Description                 = 'Description'
            DisplayName                 = "IntuneEpmElevationRulesPolicyWindows10_1";
            ElevationRuleName     = @(
                MSFT_MicrosoftGraphIntuneSettingsCatalogElevationRuleName{
                    ChildProcessBehavior = "allowrunelevated"
                    FilePath = "C:\temp"
                    FileVersion = "1.1.1.1"
                    CertificateType = "publisher"
                    FileDescription = "File Description"
                    Elevationtype = "self"
                    FileName = "file.exe"
                    ElevationTypeValidation = @(
                        1
                        2
                    )
                    Name = "Rule name"
                    RestrictArguments = "allow"
                    Description = "Description"
                    CertificatePayloadWithReusableSetting = "IntuneEpmCertificatePolicySetting_1"
                    AppliesTo = "allusers"
                    ProductName = "Product name"
                    InternalName = "Internal name"
                    SignatureSource = 0
                }
                MSFT_MicrosoftGraphIntuneSettingsCatalogElevationRuleName{
                    ChildProcessBehavior = "allowrunelevatedrulerequired"
                    CertificateType = "issuingauthority"
                    Elevationtype = "automatic"
                    FileName = "file.exe" # Updated property
                    Name = "Rule 2"
                    CertificatePayloadWithReusableSetting = "IntuneEpmCertificatePolicySetting_1"
                    AppliesTo = "allusers"
                    SignatureSource = 0
                }
            );
            Ensure                      = "Present";
            Id                          = '00000000-0000-0000-0000-000000000000'
            RoleScopeTagIds             = @("0");
            ApplicationId               = $ApplicationId;
            TenantId                    = $TenantId;
            CertificateThumbprint       = $CertificateThumbprint;
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
        IntuneEpmElevationRulesPolicyWindows10 'Example'
        {
            DisplayName                 = "IntuneEpmElevationRulesPolicyWindows10_1";
            Ensure                      = "Absent";
            Id                          = '00000000-0000-0000-0000-000000000000'
            ApplicationId               = $ApplicationId;
            TenantId                    = $TenantId;
            CertificateThumbprint       = $CertificateThumbprint;
        }
    }
}
```

