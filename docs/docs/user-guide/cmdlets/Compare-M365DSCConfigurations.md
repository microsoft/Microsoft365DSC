# Compare-M365DSCConfigurations

## Description

This function compares two provided DSC configuration to determine the delta.

## Output

Array the contains the differences between the source and destination configuration.

## Parameters

| Parameter | Required | DataType | Default Value | Allowed Values | Description |
| --- | --- | --- | --- | --- | --- |
| Source | False | String |  |  | Local path of the source configuration. |
| Destination | False | String |  |  | Local path of the destination configuraton. |
| SourceObject | False | Array |   |  | Array that contains the list of configuration components for the source. |
| DestinationObject | False | Array |  |  | Array that contains the list of configuration components for the destination. |

## Examples

-------------------------- EXAMPLE 1 --------------------------

`Compare-M365DSCConfigurations -Source 'C:\DSC\source.ps1' -Destination 'C:\DSC\destination.ps1'`


