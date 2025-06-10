# MicrosoftPlaceWorkspace

## Description

This resource configures a Microsoft Place Workspace in Microsoft 365.

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

This example creates a new Microsoft Place Workspace.

```powershell
MicrosoftPlaceWorkspace 'OpenWorkspace1'
{
    Identity              = 'workspace-001'
    DisplayName           = 'Open Collaboration Area'
    Address               = '123 Main Street'
    City                  = 'Seattle'
    State                 = 'Washington'
    CountryOrRegion       = 'United States'
    PostalCode            = '98101'
    Capacity              = 20
    BuildingId            = 'building-001'
    Floor                 = '3'
    FloorLabel            = 'Third Floor'
    Label                 = 'Open Workspace'
    IsWheelChairAccessible = $true
    Tags                  = @('Collaboration', 'Open', 'Flexible')
    Ensure                = 'Present'
    ApplicationId         = $ApplicationId
    TenantId              = $TenantId
    CertificateThumbprint = $CertificateThumbprint
}
```