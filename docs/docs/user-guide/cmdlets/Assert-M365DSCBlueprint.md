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
| Credentials | False | PSCredential |  |  | Specifies the credentials that will be used for authentication. |
| ApplicationId | False | String |  |  | Specifies the application id to be used for authentication. |
| TenantId | False | String |  |  | Specifies the id of the tenant. |
| CertificatePath | False | String |  |  | Specifies the path of the PFX file which is used for authentication. |
| CertificatePassword | False | PSCredential |  |  | Specifies the password of the PFX file which is used for authentication. |
| CertificateThumbprint | False | String |  |  | Specifies the thumbprint to be used for authentication. |
| HeaderFilePath | False | String |  |  | Specifies that file that contains a custom header for the report. |
| Type | False | String | HTML | HTML, JSON |  |
| ExcludedProperties | False | String[] |  |  | Specifies the name of parameters that should not be assessed as part of the report. The names speficied will apply to all resources where they are encountered. |
| ExcludedResources | False | String[] |  |  | Specifies the name of resources that should not be assessed as part of the report. |

## Examples

-------------------------- EXAMPLE 1 --------------------------

`Assert-M365DSCBlueprint -BluePrintUrl 'C:\DS\blueprint.m365' -OutputReportPath 'C:\DSC\BlueprintReport.html'`

-------------------------- EXAMPLE 2 --------------------------

`Assert-M365DSCBlueprint -BluePrintUrl 'C:\DS\blueprint.m365' -OutputReportPath 'C:\DSC\BlueprintReport.html' -Credentials $credentials -HeaderFilePath 'C:\DSC\ReportCustomHeader.html'`

-------------------------- EXAMPLE 3 --------------------------

`Assert-M365DSCBlueprint -BluePrintUrl 'C:\DS\blueprint.m365' -OutputReportPath 'C:\DSC\BlueprintReport.html' -ApplicationId $clientid -TenantId $tenantId -CertificateThumbprint $certthumbprint -HeaderFilePath 'C:\DSC\ReportCustomHeader.html'`


