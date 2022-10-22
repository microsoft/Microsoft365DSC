# Get-M365DSCWorkloadsListFromResourceNames

## Description

This function returns the used workloads for the specified DSC resources

## Output

This function outputs information as the following type:
**System.Boolean**

## Parameters

| Parameter | Required | DataType | Default Value | Allowed Values | Description |
| --- | --- | --- | --- | --- | --- |
| ResourceNames | True | String[] |  |  | Specifies the resources for which the workloads should be determined. |

## Examples

-------------------------- EXAMPLE 1 --------------------------

`Get-M365DSCWorkloadsListFromResourceNames -ResourceNames AADUser`


