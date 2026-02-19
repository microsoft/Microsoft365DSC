# IntuneCorporateDeviceIdentifier

## Description

This resource manages Intune corporate device identifiers used to pre-register devices as corporate-owned. Identifiers can include serial numbers, IMEI numbers, or manufacturer/model/serial combinations.

**Important:** This resource enforces the desired state by:
- Adding identifiers that are in the configuration but not in Intune
- **Removing identifiers that are in Intune but NOT in the configuration**

This ensures the Intune corporate identifiers exactly match your configuration as the single source of truth.

## Graph API Endpoints

- GET/POST: `/beta/deviceManagement/importedDeviceIdentities`
- DELETE: `/beta/deviceManagement/importedDeviceIdentities/{id}`

## Cloud Support

This resource is cloud-agnostic and works with:
- Microsoft 365 Global (Commercial)
- Microsoft 365 GCC
- Microsoft 365 GCC High
- Microsoft 365 DoD

The resource automatically uses the correct Graph API endpoint based on your cloud environment.
