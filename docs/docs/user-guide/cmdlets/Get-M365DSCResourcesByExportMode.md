# Get-M365DSCResourcesByExportMode

## Description

This function retrieves the resources available in the M365DSC project based on the specified export mode.

## Output

This function outputs information as the following type:
**System.String[]**

## Parameters

| Parameter | Required | DataType | Default Value | Allowed Values | Description |
| --- | --- | --- | --- | --- | --- |
| Mode | True | String |  | Default, Full | Specifies the mode of the export. Valid values are 'Default' and 'Full'.
- 'Default' includes only configuration resources.
- 'Full' includes all resources, both configuration and data. |
| ExcludeConfigurationResources | False | SwitchParameter |  |  | If specified, configuration resources will be excluded from the results. Works only for the 'Full' mode. |

## Examples

-------------------------- EXAMPLE 1 --------------------------

`Get-M365DSCResourcesByExportMode -Mode 'Default'`

-------------------------- EXAMPLE 2 --------------------------

`Get-M365DSCResourcesByExportMode -Mode 'Full'`


