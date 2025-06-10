# MicrosoftPlaceBuilding

## Description

This resource configures a Microsoft Place Building in Microsoft 365.

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

This example creates a new Microsoft Place Building.

```powershell
MicrosoftPlaceBuilding 'MainBuilding'
{
    Identity         = 'building-001'
    DisplayName      = 'Main Office Building'
    Address          = '123 Main Street'
    City             = 'Seattle'
    State            = 'Washington'
    CountryOrRegion  = 'United States'
    PostalCode       = '98101'
    Phone            = '+1-555-0123'
    GeoCoordinates   = '47.6062,-122.3321'
    Ensure           = 'Present'
    ApplicationId    = $ApplicationId
    TenantId         = $TenantId
    CertificateThumbprint = $CertificateThumbprint
}
```

### Example 2

This example updates an existing Microsoft Place Building.

```powershell
MicrosoftPlaceBuilding 'MainBuilding'
{
    Identity         = 'building-001'
    DisplayName      = 'Main Office Building - Updated'
    Address          = '123 Main Street, Suite 100'
    City             = 'Seattle'
    State            = 'Washington'
    CountryOrRegion  = 'United States'
    PostalCode       = '98101'
    Phone            = '+1-555-0124'
    Ensure           = 'Present'
    ApplicationId    = $ApplicationId
    TenantId         = $TenantId
    CertificateThumbprint = $CertificateThumbprint
}
```

### Example 3

This example removes a Microsoft Place Building.

```powershell
MicrosoftPlaceBuilding 'MainBuilding'
{
    Identity         = 'building-001'
    Ensure           = 'Absent'
    ApplicationId    = $ApplicationId
    TenantId         = $TenantId
    CertificateThumbprint = $CertificateThumbprint
}
```