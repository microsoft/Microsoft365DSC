# EXOMessageClassification

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the OME Configuration policy that you want to modify. | |
| **ClassificationID** | Write | String | The ClassificationID parameter specifies the classification ID (GUID) of an existing message classification that you want to import and use in your Exchange organization. | |
| **DisplayName** | Write | String | The DisplayName parameter specifies the title of the message classification that's displayed in Outlook and selected by users. | |
| **DisplayPrecedence** | Write | String | The DisplayPrecedence parameter specifies the relative precedence of the message classification to other message classifications that may be applied to a specified message. | `Highest`, `Higher`, `High`, `MediumHigh`, `Medium`, `MediumLow`, `Low`, `Lower`, `Lowest` |
| **Name** | Write | String | The Name parameter specifies the unique name for the message classification. | |
| **PermissionMenuVisible** | Write | Boolean | The PermissionMenuVisible parameter specifies whether the values that you entered for the DisplayName and RecipientDescription parameters are displayed in Outlook as the user composes a message.  | |
| **RecipientDescription** | Write | String | The RecipientDescription parameter specifies the detailed text that's shown to Outlook recipient when they receive a message that has the message classification applied. | |
| **RetainClassificationEnabled** | Write | Boolean | The RetainClassificationEnabled parameter specifies whether the message classification should persist with the message if the message is forwarded or replied to. | |
| **SenderDescription** | Write | String | The SenderDescription parameter specifies the detailed text that's shown to Outlook senders when they select a message classification to apply to a message before they send the message.  | |
| **Ensure** | Write | String | Specifies if this Outbound connector should exist. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

## Description

Create a new Message Classification policy in your cloud-based organization.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- User Options, Data Loss Prevention, Transport Rules, View-Only Configuration, Mail Recipients

#### Role Groups

- Organization Management

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
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOMessageClassification 'ConfigureMessageClassification'
        {
            Identity                    = "Contoso Message Classification"
            Name                        = "Contoso Message Classification"
            DisplayName                 = "Contoso Message Classification"
            DisplayPrecedence           = "Highest"
            PermissionMenuVisible       = $True
            RecipientDescription        = "Shown to receipients"
            SenderDescription           = "Shown to senders"
            RetainClassificationEnabled = $True
            Ensure                      = "Present"
            Credential                  = $Credscredential
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
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOMessageClassification 'ConfigureMessageClassification'
        {
            Identity                    = "Contoso Message Classification"
            Name                        = "Contoso Message Classification"
            DisplayName                 = "Contoso Message Classification"
            DisplayPrecedence           = "Highest"
            PermissionMenuVisible       = $True
            RecipientDescription        = "Shown to receipients"
            SenderDescription           = "Shown to senders"
            RetainClassificationEnabled = $False # Updated Property
            Ensure                      = "Present"
            Credential                  = $Credscredential
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
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOMessageClassification 'ConfigureMessageClassification'
        {
            Identity                    = "Contoso Message Classification"
            Name                        = "Contoso Message Classification"
            DisplayName                 = "Contoso Message Classification"
            Ensure                      = "Absent"
            Credential                  = $Credscredential
        }
    }
}
```

