# MicrosoftPlaceMap

## Description

This resource configures a Microsoft Place Map in Microsoft 365.

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

This example creates a new Microsoft Place Map.

```powershell
MicrosoftPlaceMap 'FloorPlan1'
{
    Identity       = 'map-floor1'
    DisplayName    = 'First Floor Plan'
    BuildingId     = 'building-001'
    Floor          = '1'
    FloorLabel     = 'First Floor'
    MapType        = 'FloorPlan'
    MapImageUrl    = 'https://contoso.sharepoint.com/sites/facilities/floorplans/floor1.png'
    Tags           = @('FloorPlan', 'Navigation')
    Ensure         = 'Present'
    ApplicationId  = $ApplicationId
    TenantId       = $TenantId
    CertificateThumbprint = $CertificateThumbprint
}
```