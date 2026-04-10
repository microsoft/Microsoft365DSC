# Resource Comparison Metadata Architecture

## Overview

This document describes the metadata-driven approach for handling resource-specific comparison logic in Microsoft365DSC.
This ensures that drift detection and reporting use the same comparison parameters as the DSC runtime, regardless of whether the comparison is triggered by `Test-TargetResource` or `New-M365DSCDeltaReport`.

## Problem Statement

Previously, there were two comparison pathways that produced inconsistent results:

1. **Resource-Level Comparison** (via `Test-TargetResource`):
   * Resources could specify custom comparison logic (PostProcessing, ExcludedProperties, IncludedProperties)
   * Used during DSC runtime operations

2. **Report-Level Comparison** (via `New-M365DSCDeltaReport`):
   * Called `Compare-M365DSCResourceState` directly without resource-specific parameters
   * Lost all custom comparison logic, causing false drift detection

## Solution Architecture

The solution uses a **metadata-driven approach** with three key components:

### 1. Comparison Metadata File

**Location:** `Modules/Microsoft365DSC/ComparisonMetadata.json`

This JSON file flags which resources require custom comparison logic:

```json
{
  "Description": "Metadata for resources that require custom comparison logic...",
  "Resources": {
    "AADRoleAssignmentScheduleRequest": {
      "HasCustomComparison": true,
      "Description": "Uses PostProcessing to handle past StartDateTime values"
    },
    "PlannerTask": {
      "HasCustomComparison": true,
      "Description": "Uses PostProcessing to handle null Bucket values"
    }
  }
}
```

**Fields:**

* `HasCustomComparison` (boolean): When `true`, the resource has a `Get-CompareParameters` function
* `Description` (string): Human-readable explanation of why custom comparison is needed

### 2. Resource-Level Get-CompareParameters Function

Resources that require custom comparison logic must implement a `Get-CompareParameters` function that returns a hashtable with the same parameters passed to `Test-M365DSCTargetResource`:

**Example:** `MSFT_AADRoleAssignmentScheduleRequest\Get-CompareParameters`

```powershell
function Get-CompareParameters
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    $postProcessingScript = {
        param($DesiredValues, $CurrentValues, $ValuesToCheck, $ignore)
        # Custom comparison logic here
        # ... transform values as needed ...
        return [System.Tuple[Hashtable, Hashtable, Hashtable]]::new($DesiredValues, $CurrentValues, $ValuesToCheck)
    }

    return @{
        ExcludedProperties = @('Action', 'IsValidationOnly', 'Justification', 'TicketInfo')
        PostProcessing = $postProcessingScript
    }
}
```

**Supported Return Values:**

* `ExcludedProperties` (string[]): Properties to exclude from comparison
* `IncludedProperties` (string[]): Properties to explicitly include in comparison
* `PostProcessing` (ScriptBlock): Custom transformation logic (must return Tuple[Hashtable, Hashtable, Hashtable])
* `PostProcessingArgs` (object[]): Additional arguments passed to PostProcessing scriptblock

### 3. Helper Functions

**`Get-M365DSCResourceComparisonMetadata`** (in M365DSCUtil.psm1)

* Loads and caches the ComparisonMetadata.json file
* Returns metadata for a specific resource
* Returns `@{HasCustomComparison = $false}` if resource not in metadata

**`Get-M365DSCResourceComparisonParameters`** (in M365DSCUtil.psm1)

* Checks metadata to see if resource has custom comparison
* Imports the resource module if needed
* Invokes the resource's `Get-CompareParameters` function
* Returns the comparison parameters hashtable

### 4. Integration with New-M365DSCDeltaReport

The report generation now uses the metadata-driven approach:

```powershell
# Check if this resource has custom comparison logic
$metadata = Get-M365DSCResourceComparisonMetadata -ResourceName $resource.ResourceName
if ($metadata.HasCustomComparison)
{
    # Retrieve custom comparison parameters from the resource
    $customCompareParams = Get-M365DSCResourceComparisonParameters -ResourceName $resource.ResourceName

    # Merge with global exclusions
    if ($customCompareParams.ContainsKey('ExcludedProperties'))
    {
        $resourceCompareParams.ExcludedProperties = $ExcludedProperties + $customCompareParams.ExcludedProperties | Select-Object -Unique
    }

    # Add PostProcessing, IncludedProperties, etc.
    # ...
}

# Perform comparison with resource-specific parameters
$compareResult = Compare-M365DSCResourceState @resourceCompareParams
```

## Implementation Guide

### Adding Custom Comparison to a New Resource

1. **Add metadata entry** in `ComparisonMetadata.json`:

    ```json
    "YourResourceName": {
        "HasCustomComparison": true,
        "Description": "Brief description of why custom comparison is needed"
    }
    ```

2. **Implement `Get-CompareParameters`** in your resource module (before `Export-ModuleMember`):

    ```powershell
    function Get-CompareParameters
    {
        [CmdletBinding()]
        [OutputType([System.Collections.Hashtable])]
        param()

        return @{
            ExcludedProperties = @('PropertyToExclude1', 'PropertyToExclude2')
            # IncludedProperties = @('PropertyToInclude1')  # Optional
            # PostProcessing = $scriptBlock  # Optional
        }
    }
    ```

3. **Test your implementation**
   * Run your resource's `Test-TargetResource` - should work as before
   * Run `Assert-M365DSCBlueprint` - should now use the same comparison logic

### PostProcessing Script Pattern

The PostProcessing scriptblock receives four parameters and must return a Tuple:

```powershell
$postProcessingScript = {
    param
    (
        $DesiredValues,      # Hashtable - values from configuration
        $CurrentValues,      # Hashtable - values from tenant
        $ValuesToCheck,      # Hashtable - properties to compare
        $PostProcessingArgs  # Optional array - additional context
    )

    # Modify values as needed
    # Example: Normalize datetime values
    if ($DesiredValues.StartDate -lt [DateTime]::Now) {
        $DesiredValues.StartDate = $CurrentValues.StartDate
    }

    # MUST return Tuple[Hashtable, Hashtable, Hashtable]
    return [System.Tuple[Hashtable, Hashtable, Hashtable]]::new(
        $DesiredValues,
        $CurrentValues,
        $ValuesToCheck
    )
}
```

## Benefits

1. **Consistency**: Report generation and DSC runtime use identical comparison logic
2. **Maintainability**: Comparison logic lives in one place (the resource module)
3. **Flexibility**: Resources can define complex comparison rules without modifying core engine
4. **Performance**: Only loads custom logic when needed (metadata-driven)
5. **Discoverability**: Metadata file provides clear inventory of resources with custom logic

## File Locations

* **Metadata:** `Modules/Microsoft365DSC/ComparisonMetadata.json`
* **Helper Functions:** `Modules/Microsoft365DSC/Modules/M365DSCUtil.psm1`
* **Comparison Engine:** `Modules/Microsoft365DSC/Modules/M365DSCCompare.psm1`
* **Report Generator:** `Modules/Microsoft365DSC/Modules/M365DSCReport.psm1`
* **Resource Example:** `Modules/Microsoft365DSC/DSCResources/MSFT_AADRoleAssignmentScheduleRequest/MSFT_AADRoleAssignmentScheduleRequest.psm1`

## Resources Currently Using Custom Comparison

See `ComparisonMetadata.json` for the complete list.
