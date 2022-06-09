# Assert-M365DSCBlueprint

## Description

This function compares a created export with the specified M365DSC Blueprint

## Output

This function does not generate any output.

## Parameters

| Parameter | Required | DataType | Default Value | Allowed Values | Description |
| --- | --- | --- | --- | --- | --- |
| BluePrintUrl | True | String |  |  | Specifies the url to the blueprint to which the tenant should be compared. |
| OutputReportPath | True | String |  |  | Specifies the path of the report that will be created. |
| Credentials | True | PSCredential |  |  | Specifies the credentials that will be used for authentication. |
| HeaderFilePath | False | String |  |  | Specifies that file that contains a custom header for the report. |

## Examples

-------------------------- EXAMPLE 1 --------------------------

`Assert-M365DSCBlueprint -BluePrintUrl 'C:\DS\blueprint.m365' -OutputReportPath 'C:\DSC\BlueprintReport.html'`

-------------------------- EXAMPLE 2 --------------------------

`Assert-M365DSCBlueprint -BluePrintUrl 'C:\DS\blueprint.m365' -OutputReportPath 'C:\DSC\BlueprintReport.html' -Credentials $credentials -HeaderFilePath 'C:\DSC\ReportCustomHeader.html'`


