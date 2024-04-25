# AADAuthenticationContextClassReference

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Key | String | Identifier used to reference the authentication context class. The id is used to trigger step-up authentication for the referenced authentication requirements and is the value that will be issued in the acrs claim of an access token. This value in the claim is used to verify that the required authentication context has been satisfied. The allowed values are c1 through c25. | `c1`, `c2`, `c3`, `c4`, `c5`, `c6`, `c7`, `c8`, `c9`, `c10`, `c11`, `c12`, `c13`, `c14`, `c15`, `c16`, `c17`, `c18`, `c19`, `c20`, `c21`, `c22`, `c23`, `c24`, `c25` |
| **DisplayName** | Write | String | A friendly name that identifies the authenticationContextClassReference object when building user-facing admin experiences. For example, a selection UX | |
| **Description** | Write | String | A short explanation of the policies that are enforced by authenticationContextClassReference. This value should be used to provide secondary text to describe the authentication context class reference when building user-facing admin experiences. For example, a selection UX. | |
| **IsAvailable** | Write | Boolean | Indicates whether the authenticationContextClassReference has been published by the security admin and is ready for use by apps. When it's set to false, it shouldn't be shown in admin UX experiences because the value isn't currently available for selection. | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

Represents a Microsoft Entra authentication context class reference. Authentication context class references are custom values that define a Conditional Access authentication requirement

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

    - Policy.Read.ConditionalAccess

- **Update**

    - Policy.ReadWrite.ConditionalAccess

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsCredential
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADAuthenticationContextClassReference "AADAuthenticationContextClassReference-Test"
        {
            Credential           = $credsCredential;
            Description          = "Context test";
            DisplayName          = "My Context";
            Ensure               = "Present";
            Id                   = "c3";
            IsAvailable          = $True;
        }
    }
}
```

### Example 2

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsCredential
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADAuthenticationContextClassReference "AADAuthenticationContextClassReference-Test"
        {
            Credential           = $credsCredential;
            Description          = "Context test Updated"; # Updated Property
            DisplayName          = "My Context";
            Ensure               = "Present";
            Id                   = "c3";
            IsAvailable          = $False; # Updated Property
        }
    }
}
```

### Example 3

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsCredential
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADAuthenticationContextClassReference "AADAuthenticationContextClassReference-Test"
        {
            Credential           = $credsCredential;
            Description          = "Context test Updated"; # Updated Property
            DisplayName          = "My Context";
            Ensure               = "Absent";
            Id                   = "c3";
            IsAvailable          = $True;
        }
    }
}
```

