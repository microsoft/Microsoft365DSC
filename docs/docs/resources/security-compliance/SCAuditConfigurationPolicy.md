# SCAuditConfigurationPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Workload** | Key | String | Workload associated with the policy. |Exchange, SharePoint, OneDriveForBusiness|
| **Ensure** | Write | String | Specify if this policy should exist or not. |Present, Absent|
| **Credential** | Required | PSCredential | Credentials of the Global Admin ||

# SCAuditConfigurationPolicy

### Description

This resource configures an Audit ConfigurationPolicy
in Security and Compliance Center.

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
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        SCAuditConfigurationPolicy 'ExchangeAuditPolicy'
        {
            Workload           = "Exchange"
            Ensure             = "Present"
            Credential         = $credsGlobalAdmin
        }

        SCAuditConfigurationPolicy 'OneDriveAuditPolicy'
        {
            Workload           = "OneDriveForBusiness"
            Ensure             = "Present"
            Credential         = $credsGlobalAdmin
        }

        SCAuditConfigurationPolicy 'SharePointAuditPolicy'
        {
            Workload           = "SharePoint"
            Ensure             = "Present"
            Credential         = $credsGlobalAdmin
        }
    }
}
```

