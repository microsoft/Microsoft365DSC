<#
.SYNOPSIS
    Gets Azure billing accounts.

.DESCRIPTION
    Retrieves the list of Azure billing accounts for the current authenticated context.

.OUTPUTS
    System.Collections.Hashtable
#>
function Get-M365DSCAzureBillingAccount
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    $uri = "$((Get-MSCloudLoginConnectionProfile -Workload Azure).ManagementUrl)providers/Microsoft.Billing/billingAccounts?api-version=2024-04-01&?includeAll=true"
    $response = Invoke-AzRestMethod -Method GET -Uri $uri
    $result = ConvertFrom-Json $response.Content
    return $result
}

<#
.SYNOPSIS
    Gets associated tenants for a billing account.

.DESCRIPTION
    Retrieves the tenants currently associated to a specific Azure billing account.

.PARAMETER BillingAccountId
    Specifies the billing account identifier.

.OUTPUTS
    System.Collections.Hashtable
#>
function Get-M365DSCAzureBillingAccountsAssociatedTenant
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $BillingAccountId
    )

    $uri = "$((Get-MSCloudLoginConnectionProfile -Workload Azure).ManagementUrl)providers/Microsoft.Billing/billingAccounts/$($BillingAccountId)/associatedTenants?api-version=2024-04-01"
    $response = Invoke-AzRestMethod -Method GET -Uri $uri
    $result = ConvertFrom-Json $response.Content
    return $result
}

<#
.SYNOPSIS
    Removes an associated tenant from a billing account.

.DESCRIPTION
    Deletes the association between an Azure billing account and an associated tenant.

.PARAMETER BillingAccountId
    Specifies the billing account identifier.

.PARAMETER AssociatedTenantId
    Specifies the associated tenant identifier to remove.

.OUTPUTS
    System.Collections.Hashtable
#>
function Remove-M365DSCAzureBillingAccountsAssociatedTenant
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $BillingAccountId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $AssociatedTenantId
    )

    $uri = "$((Get-MSCloudLoginConnectionProfile -Workload Azure).ManagementUrl)providers/Microsoft.Billing/billingAccounts/$($BillingAccountId)/associatedTenants/$($AssociatedTenantId)?api-version=2024-04-01"
    $response = Invoke-AzRestMethod -Method DELETE -Uri $uri
    $result = ConvertFrom-Json $response.Content
    return $result
}

<#
.SYNOPSIS
    Creates or updates an associated tenant for a billing account.

.DESCRIPTION
    Creates or updates the associated tenant relationship for an Azure billing account using the provided request body.

.PARAMETER BillingAccountId
    Specifies the billing account identifier.

.PARAMETER AssociatedTenantId
    Specifies the associated tenant identifier to create or update.

.PARAMETER Body
    Specifies the request payload sent to the Azure Billing API.

.OUTPUTS
    System.Collections.Hashtable
#>
function New-M365DSCAzureBillingAccountsAssociatedTenant
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $BillingAccountId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $AssociatedTenantId,

        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Body
    )

    $uri = "$((Get-MSCloudLoginConnectionProfile -Workload Azure).ManagementUrl)providers/Microsoft.Billing/billingAccounts/$($BillingAccountId)/associatedTenants/$($AssociatedTenantId)?api-version=2024-04-01"
    $payload = ConvertTo-Json $body -Depth 10 -Compress
    $response = Invoke-AzRestMethod -Method PUT -Uri $uri -Payload $payload
    $result = ConvertFrom-Json $response.Content
    return $result
}

<#
.SYNOPSIS
    Gets billing role assignments for a billing account.

.DESCRIPTION
    Retrieves all billing role assignments for a specific Azure billing account.

.PARAMETER BillingAccountId
    Specifies the billing account identifier.

.OUTPUTS
    System.Collections.Hashtable
#>
function Get-M365DSCAzureBillingAccountsRoleAssignment
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $BillingAccountId
    )

    $uri = "$((Get-MSCloudLoginConnectionProfile -Workload Azure).ManagementUrl)providers/Microsoft.Billing/billingAccounts/$($BillingAccountId)/billingRoleAssignments?api-version=2024-04-01"
    $response = Invoke-AzRestMethod -Method GET -Uri $uri
    $result = ConvertFrom-Json $response.Content
    return $result
}

<#
.SYNOPSIS
    Gets billing role definitions for a billing account.

.DESCRIPTION
    Retrieves billing role definitions for a specific Azure billing account, or a single role definition when an identifier is provided.

.PARAMETER BillingAccountId
    Specifies the billing account identifier.

.PARAMETER RoleDefinitionId
    Specifies the role definition identifier. When omitted, all role definitions are returned.

.OUTPUTS
    System.Collections.Hashtable
#>
function Get-M365DSCAzureBillingAccountsRoleDefinition
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $BillingAccountId,

        [Parameter()]
        [System.String]
        $RoleDefinitionId
    )

    if ($null -eq $RoleDefinitionId)
    {
        $uri = "$((Get-MSCloudLoginConnectionProfile -Workload Azure).ManagementUrl)providers/Microsoft.Billing/billingAccounts/$($BillingAccountId)/billingRoleDefinitions?api-version=2024-04-01"
    }
    else
    {
        $uri = "$((Get-MSCloudLoginConnectionProfile -Workload Azure).ManagementUrl)providers/Microsoft.Billing/billingAccounts/$($BillingAccountId)/billingRoleDefinitions/$($RoleDefinitionId)?api-version=2024-04-01"
    }
    $response = Invoke-AzRestMethod -Method GET -Uri $uri
    $result = ConvertFrom-Json $response.Content
    return $result
}

<#
.SYNOPSIS
    Creates a billing role assignment.

.DESCRIPTION
    Creates a new billing role assignment for a specific Azure billing account using the provided request body.

.PARAMETER BillingAccountId
    Specifies the billing account identifier.

.PARAMETER Body
    Specifies the request payload sent to the Azure Billing API.

.OUTPUTS
    System.Collections.Hashtable
#>
function New-M365DSCAzureBillingAccountsRoleAssignment
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $BillingAccountId,

        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Body
    )

    $uri = "$((Get-MSCloudLoginConnectionProfile -Workload Azure).ManagementUrl)providers/Microsoft.Billing/billingAccounts/$($BillingAccountId)/createBillingRoleAssignment?api-version=2024-04-01"
    $payload = ConvertTo-Json $Body -Depth 10 -Compress
    $response = Invoke-AzRestMethod -Method POST -Uri $uri -Payload $payload
    $result = ConvertFrom-Json $response.Content
    return $result
}

<#
.SYNOPSIS
    Removes a billing role assignment.

.DESCRIPTION
    Deletes a billing role assignment from a specific Azure billing account.

.PARAMETER BillingAccountId
    Specifies the billing account identifier.

.PARAMETER AssignmentId
    Specifies the billing role assignment identifier to remove.

.OUTPUTS
    System.Collections.Hashtable
#>
function Remove-M365DSCAzureBillingAccountsRoleAssignment
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $BillingAccountId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $AssignmentId
    )

    $uri = "$((Get-MSCloudLoginConnectionProfile -Workload Azure).ManagementUrl)providers/Microsoft.Billing/billingAccounts/$($BillingAccountId)/billingRoleAssignments/$($AssignmentId)?api-version=2024-04-01"
    $response = Invoke-AzRestMethod -Method DELETE -Uri $uri
    $result = ConvertFrom-Json $response.Content
    return $result
}
