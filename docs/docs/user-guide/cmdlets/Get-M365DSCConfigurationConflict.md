# Get-M365DSCConfigurationConflict

## Description

This function analyzes an M365DSC configuration file and returns information about potential issues (e.g., duplicate primary keys).

## Output

This function outputs information as the following type:
**System.Array**

## Parameters

| Parameter | Required | DataType | Default Value | Allowed Values | Description |
| --- | --- | --- | --- | --- | --- |
| ConfigurationContent | True | String |  |  |  |

## Examples

-------------------------- EXAMPLE 1 --------------------------

`Get-M365DSCConfigurationConflict -ConfigurationContent "content"`


