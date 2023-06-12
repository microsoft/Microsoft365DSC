# Compare-M365DSCConfigurations

## Description

This function compares two provided DSC configuration to determine the delta.

## Output

This function outputs information as the following type:
**System.Array**

## Parameters

| Parameter | Required | DataType | Default Value | Allowed Values | Description |
| --- | --- | --- | --- | --- | --- |
| Source | False | String |  |  | Local path of the source configuration. |
| Destination | False | String |  |  | Local path of the destination configuraton. |
| CaptureTelemetry | False | Boolean |  |  |  |
| SourceObject | False | Array |  |  | Array that contains the list of configuration components for the source. |
| DestinationObject | False | Array |  |  | Array that contains the list of configuration components for the destination. |
| ExcludedProperties | False | Array |  |  | Array that contains the list of parameters to exclude. |
| ExcludedResources | False | Array |  |  | Array that contains the list of resources to exclude. |
| IsBlueprintAssessment | False | Boolean |  |  | Specifies whether or not we are currently comparing a configuration to a Blueprint. |

## Examples

-------------------------- EXAMPLE 1 --------------------------

`Compare-M365DSCConfigurations -Source 'C:\DSC\source.ps1' -Destination 'C:\DSC\destination.ps1'`


