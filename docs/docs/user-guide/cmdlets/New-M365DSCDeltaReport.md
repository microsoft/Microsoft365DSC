# New-M365DSCDeltaReport

## Description

This function creates a delta HTML report between two provided exported
DSC configurations

## Output

This function does not generate any output.

## Parameters

| Parameter | Required | DataType | Default Value | Allowed Values | Description |
| --- | --- | --- | --- | --- | --- |
| Source | True | String |  |  | The source DSC configuration to compare from. |
| Destination | True | String |  |  | The destination DSC configuration to compare with. |
| OutputPath | False | String |  |  | The output path of the delta report. |
| DriftOnly | False | Boolean |  |  | Specifies that only difference should be in the report. |
| IsBlueprintAssessment | False | Boolean |  |  | Specifies that the report is a comparison with a Blueprint. |
| HeaderFilePath | False | String |  |  | Specifies that file that contains a custom header for the report. |
| Delta | False | Array |  |  | An array with difference, already compiled from another source. |
| Type | False | String | HTML | HTML, JSON |  |
| ExcludedProperties | False | Array |  |  | Array that contains the list of parameters to exclude. |
| ExcludedResources | False | Array |  |  | Array that contains the list of resources to exclude. |

## Examples

-------------------------- EXAMPLE 1 --------------------------

`New-M365DSCDeltaReport -Source 'C:\DSC\Source.ps1' -Destination 'C:\DSC\Destination.ps1' -OutputPath 'C:\Dsc\DeltaReport.html'`

-------------------------- EXAMPLE 2 --------------------------

`New-M365DSCDeltaReport -Source 'C:\DSC\Source.ps1' -Destination 'C:\DSC\Destination.ps1' -OutputPath 'C:\Dsc\DeltaReport.html' -DriftOnly $true`


