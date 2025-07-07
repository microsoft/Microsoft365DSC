# AADAgreement

## Description

This resource configures Azure AD Terms of Use Agreements in Entra ID.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Agreement.Read.All

- **Update**

    - Agreement.ReadWrite.All

#### Application permissions

- **Read**

    - Agreement.Read.All

- **Update**

    - Agreement.ReadWrite.All

## Examples

### Example 1

This example creates a new Azure AD Terms of Use Agreement.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADAgreement 'CompanyTermsOfUse'
        {
            DisplayName                          = "Company Terms of Use"
            IsViewingBeforeAcceptanceRequired    = $true
            IsPerDeviceAcceptanceRequired        = $false
            UserReacceptRequiredFrequency        = "P90D"
            AcceptanceStatement                  = "I accept the terms of use"
            FileData                             = "Terms of Use content goes here..."
            FileName                             = "CompanyToU.txt"
            Language                             = "en-US"
            Ensure                               = "Present"
            Credential                           = $Credential
        }
    }
}
```

### Example 2

This example removes an existing Azure AD Terms of Use Agreement.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADAgreement 'CompanyTermsOfUse'
        {
            DisplayName = "Company Terms of Use"
            Ensure      = "Absent"
            Credential  = $Credential
        }
    }
}
```