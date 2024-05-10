# EXOPlace

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the room mailbox that you want to modify. You can use any value that uniquely identifies the room. | |
| **DisplayName** | Write | String | The display name of the place. | |
| **AudioDeviceName** | Write | String | The AudioDeviceName parameter specifies the name of the audio device in the room. If the value contains spaces, enclose the value in quotation marks. | |
| **Building** | Write | String | The Building parameter specifies the building name or building number that the room is in. If the value contains spaces, enclose the value in quotation marks. | |
| **Capacity** | Write | UInt32 | The Capacity parameter specifies the capacity of the room. A valid value is an integer. | |
| **City** | Write | String | The City parameter specifies the room's city. If the value contains spaces, enclose the value in quotation marks. | |
| **CountryOrRegion** | Write | String | The CountryOrRegion parameter specifies the room's country or region. A valid value is a valid ISO 3166-1 two-letter country code (for example, AU for Australia) or the corresponding friendly name for the country (which might be different from the official ISO 3166 Maintenance Agency short name). | |
| **Desks** | Write | StringArray[] | N/A | |
| **DisplayDeviceName** | Write | String | The DisplayDeviceName parameter specifies the name of the display device in the room. If the value contains spaces, enclose the value in quotation marks. | |
| **Floor** | Write | String | The Floor parameter specifies the floor number that the room is on. | |
| **FloorLabel** | Write | String | The FloorLabel parameter specifies a descriptive label for the floor that the room is on. If the value contains spaces, enclose the value in quotation marks. | |
| **GeoCoordinates** | Write | String | The GeoCoordinates parameter specifies the room's location in latitude, longitude and (optionally) altitude coordinates. | |
| **IsWheelChairAccessible** | Write | Boolean | The IsWheelChairAccessible parameter specifies whether the room is wheelchair accessible. | |
| **Label** | Write | String | The Label parameter specifies a descriptive label for the room (for example, a number or name). If the value contains spaces, enclose the value in quotation marks. | |
| **MTREnabled** | Write | Boolean | The MTREnabled parameter identifies the room as configured with a Microsoft Teams room system. You can add Teams room systems as audio sources in Teams meetings that involve the room. | |
| **ParentId** | Write | String | The ParentId parameter specifies the ID of a Place in the parent location hierarchy in Microsoft Places. | |
| **ParentType** | Write | String | The ParentType parameter specifies the parent type of the ParentId in Microsoft Places. Valid values are: Floor, Section | `Floor`, `Section`, `None` |
| **Phone** | Write | String | The Phone parameter specifies the room's telephone number. | |
| **PostalCode** | Write | String | The PostalCode parameter specifies the room's postal code. | |
| **State** | Write | String | The State parameter specifies the room's state or province. | |
| **Street** | Write | String | The Street parameter specifies the room's physical address. | |
| **Tags** | Write | StringArray[] | The Tags parameter specifies additional features of the room (for example, details like the type of view or furniture type). | |
| **VideoDeviceName** | Write | String | The VideoDeviceName parameter specifies the name of the video device in the room. If the value contains spaces, enclose the value in quotation marks. | |
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

This resource configures a place in Exchange Online (e.g., room).

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Remote and Accepted Domains, View-Only Configuration

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

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        EXOPlace 'TestPlace'
        {
            AudioDeviceName        = "MyAudioDevice";
            Capacity               = 15;
            City                   = "";
            Credential             = $Credscredential
            DisplayDeviceName      = "DisplayDeviceName";
            Ensure                 = 'Present'
            Identity               = "Hood@$Domain";
            IsWheelChairAccessible = $True;
            MTREnabled             = $False;
            ParentType             = "None";
            Phone                  = "555-555-5555";
            Tags                   = @("Tag1", "Tag2");
            VideoDeviceName        = "VideoDevice";
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

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        EXOPlace 'TestPlace'
        {
            AudioDeviceName        = "MyAudioDevice";
            Capacity               = 16; # Updated Property
            City                   = "";
            Credential             = $Credscredential
            DisplayDeviceName      = "DisplayDeviceName";
            Ensure                 = 'Present'
            Identity               = "Hood@$Domain";
            IsWheelChairAccessible = $True;
            MTREnabled             = $False;
            ParentType             = "None";
            Phone                  = "555-555-5555";
            Tags                   = @("Tag1", "Tag2");
            VideoDeviceName        = "VideoDevice";
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

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        EXOPlace 'TestPlace'
        {
            AudioDeviceName        = "MyAudioDevice";
            Credential             = $Credscredential
            DisplayDeviceName      = "DisplayDeviceName";
            Ensure                 = 'Absent'
            Identity               = "Hood@$Domain";
        }
    }
}
```

