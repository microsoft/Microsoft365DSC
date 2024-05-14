# SCAutoSensitivityLabelPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies the unique name for the sensitivity label. The maximum length is 64 characters. If the value contains spaces, enclose the value in quotation marks. | |
| **Ensure** | Write | String | Specify if this label policy should exist or not. | `Present`, `Absent` |
| **Comment** | Write | String | The Comment parameter specifies an optional comment. | |
| **ApplySensitivityLabel** | Write | String | The ApplySensitivityLabel parameter specifies the label to use for the auto label policy. | |
| **ExchangeSender** | Write | StringArray[] | The ExchangeSender parameter specifies which senders to include in the policy. | |
| **ExchangeSenderException** | Write | StringArray[] | The ExchangeSenderException parameter specifies which senders to exclude in the policy. | |
| **ExchangeSenderMemberOf** | Write | StringArray[] | The ExchangeSenderMemberOf parameter specifies the distribution groups, mail-enabled security groups, or dynamic distribution groups to include in the auto-labeling policy. | |
| **ExchangeSenderMemberOfException** | Write | StringArray[] | he ExchangeSenderMemberOf parameter specifies the distribution groups, mail-enabled security groups, or dynamic distribution groups to exclude from the auto-labeling policy. | |
| **ExchangeLocation** | Write | StringArray[] | The ExchangeSender parameter specifies which senders to include in the policy. | |
| **AddExchangeLocation** | Write | StringArray[] | This AddExchangeLocation parameter specifies new Exchange locations to be added to the policy without affecting the existing ones. | |
| **RemoveExchangeLocation** | Write | StringArray[] | The RemoveExchangeLocation parameter removes locations on Exchange from the policy. | |
| **Mode** | Write | String | The Mode parameter specifies the action and notification level of the auto-labeling policy. | `Enable`, `Disable`, `TestWithNotifications`, `TestWithoutNotifications` |
| **OneDriveLocation** | Write | StringArray[] | The OneDriveLocation parameter specifies the OneDrive for Business sites to include. You identify the site by its URL value, or you can use the value. | |
| **AddOneDriveLocation** | Write | StringArray[] | The AddOneDriveLocation parameter specifies the OneDrive for Business sites to add to the list of included sites when you aren't using the value All for the OneDriveLocation parameter. | |
| **RemoveOneDriveLocation** | Write | StringArray[] | The RemoveOneDriveLocation parameter specifies the OneDrive for Business sites to remove from the list of included sites when you aren't using the value All for the OneDriveLocation parameter. | |
| **AddOneDriveLocationException** | Write | StringArray[] | This parameter specifies the OneDrive for Business sites to exclude when you use the value All for the OneDriveLocation parameter. | |
| **RemoveOneDriveLocationException** | Write | StringArray[] | This RemoveOneDriveLocationException parameter specifies the OneDrive for Business sites to remove from the list of excluded sites when you use the value All for the OneDriveLocation parameter. | |
| **OneDriveLocationException** | Write | StringArray[] | The AddOneDriveLocationException parameter specifies the OneDrive for Business sites to add to the list of excluded sites when you use the value All for the OneDriveLocation parameter. | |
| **Priority** | Write | UInt32 | The Priority parameter specifies the priority of the policy. The highest priority policy will take action over lower priority policies if two policies are applicable for a file. | |
| **SharePointLocation** | Write | StringArray[] | The SharePointLocation parameter specifies the SharePoint Online sites to include. You identify the site by its URL value, or you can use the value All to include all sites. | |
| **SharePointLocationException** | Write | StringArray[] | This parameter specifies the SharePoint Online sites to exclude when you use the value All for the SharePointLocation parameter. | |
| **AddSharePointLocationException** | Write | StringArray[] | The AddSharePointLocation parameter specifies the SharePoint Online sites to add to the list of included sites when you aren't using the value All for the SharePointLocation parameter. | |
| **RemoveSharePointLocationException** | Write | StringArray[] | The RemoveSharePointLocationException parameter specifies the SharePoint Online sites to remove from the list of excluded sites when you use the value All for the SharePointLocation parameter. | |
| **AddSharePointLocation** | Write | StringArray[] | The AddSharePointLocation parameter specifies the SharePoint Online sites to add to the list of included sites when you aren't using the value All for the SharePointLocation parameter. | |
| **RemoveSharePointLocation** | Write | StringArray[] | The RemoveSharePointLocation parameter specifies the SharePoint Online sites to remove from the list of included sites when you aren't using the value All for the SharePointLocation parameter. | |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

## Description

This resource configures a Auto Sensitivity label policy in Security and Compliance.

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

    - None

- **Update**

    - None

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
        SCAutoSensitivityLabelPolicy 'TestPolicy'
        {
            ApplySensitivityLabel           = "TopSecret";
            Comment                         = "This is a test";
            Credential                      = $Credscredential;
            Ensure                          = "Present";
            ExchangeLocation                = @("All");
            Mode                            = "Enable";
            Name                            = "TestPolicy";
            Priority                        = 0;
        }
    }
}
```

