# MicrosoftPlaceRoom

## Description

This resource configures a Microsoft Place Room in Microsoft 365.

## Permissions

### Microsoft Graph

To authenticate with Microsoft Graph, this resource required the following permissions:

#### Delegated permissions

- **Read**: Place.Read.All
- **Update**: Place.ReadWrite.All

#### Application permissions

- **Read**: Place.Read.All
- **Update**: Place.ReadWrite.All

## Examples

### Example 1

This example creates a new Microsoft Place Room.

```powershell
MicrosoftPlaceRoom 'ConferenceRoom1'
{
    Identity              = 'room-001'
    DisplayName           = 'Conference Room A'
    Address               = '123 Main Street'
    City                  = 'Seattle'
    State                 = 'Washington'
    CountryOrRegion       = 'United States'
    PostalCode            = '98101'
    Phone                 = '+1-555-0123'
    GeoCoordinates        = '47.6062,-122.3321'
    Capacity              = 12
    BuildingId            = 'building-001'
    Floor                 = '2'
    FloorLabel            = 'Second Floor'
    Label                 = 'Conference Room A'
    IsWheelChairAccessible = $true
    AudioDeviceName       = 'AudioSystem-A'
    VideoDeviceName       = 'VideoSystem-A'
    DisplayDeviceName     = 'Display-A'
    MTREnabled            = $true
    Tags                  = @('Conference', 'Video', 'Whiteboard')
    Ensure                = 'Present'
    ApplicationId         = $ApplicationId
    TenantId              = $TenantId
    CertificateThumbprint = $CertificateThumbprint
}
```

### Example 2

This example updates an existing Microsoft Place Room.

```powershell
MicrosoftPlaceRoom 'ConferenceRoom1'
{
    Identity              = 'room-001'
    DisplayName           = 'Conference Room A - Updated'
    Capacity              = 15
    MTREnabled            = $false
    Tags                  = @('Conference', 'Video', 'Whiteboard', 'Large')
    Ensure                = 'Present'
    ApplicationId         = $ApplicationId
    TenantId              = $TenantId
    CertificateThumbprint = $CertificateThumbprint
}
```

### Example 3

This example removes a Microsoft Place Room.

```powershell
MicrosoftPlaceRoom 'ConferenceRoom1'
{
    Identity              = 'room-001'
    Ensure                = 'Absent'
    ApplicationId         = $ApplicationId
    TenantId              = $TenantId
    CertificateThumbprint = $CertificateThumbprint
}
```