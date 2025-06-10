# MicrosoftPlaceDesk

## Description

This resource configures a Microsoft Place Desk in Microsoft 365.

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

This example creates a new Microsoft Place Desk.

```powershell
MicrosoftPlaceDesk 'Desk101'
{
    Identity              = 'desk-101'
    DisplayName           = 'Desk 101'
    BuildingId            = 'building-001'
    Floor                 = '1'
    FloorLabel            = 'First Floor'
    Label                 = 'Hot Desk 101'
    IsWheelChairAccessible = $true
    Tags                  = @('HotDesk', 'Available')
    Ensure                = 'Present'
    ApplicationId         = $ApplicationId
    TenantId              = $TenantId
    CertificateThumbprint = $CertificateThumbprint
}
```