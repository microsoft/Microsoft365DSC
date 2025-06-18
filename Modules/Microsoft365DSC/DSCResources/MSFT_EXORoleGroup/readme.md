# EXORoleGroup

## Description

This resource configures Role Groups in Exchange Online.

This resource supports filtering based on the PowerShell syntax and not the OPath query syntax from ExchangeOnline. The filter is applied offline after fetching all results from the backend.

Example:

```powershell
Export-M365DSCConfiguration -Components @("EXORoleGroup") -Path <path> -Credential (Get-Credential) -Filters @{ EXORoleGroup = '$_.Capabilities -eq "partner_managed"' }
```
