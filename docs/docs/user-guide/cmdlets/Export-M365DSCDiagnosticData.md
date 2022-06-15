# Export-M365DSCDiagnosticData

## Description

This function creates a ZIP package with a collection of troubleshooting information,
like Verbose logs, M365DSC event log, PowerShell version, OS versions and LCM config.
It is also able to anonymize this information (as much as possible), so important
information isn't shared.

## Output

This function does not generate any output.

## Parameters

| Parameter | Required | DataType | Default Value | Allowed Values | Description |
| --- | --- | --- | --- | --- | --- |
| ExportFilePath | True | String |  |  | The file path to the ZIP file that should be created. |
| NumberOfDays | False | UInt32 | 7 |  | The number of days of logs that should be exported. |
| Anonymize | False | SwitchParameter |  |  | Specify if the results should be anonymized. |
| Server | True | String |  |  | (Anonymize=True) The server name that should be renamed. |
| Domain | True | String |  |  | (Anonymize=True) The domain that should be renamed. |
| Url | True | String |  |  | (Anonymize=True) The url that should be renamed. |

## Examples

-------------------------- EXAMPLE 1 --------------------------

`Export-M365DSCDiagnosticData -ExportFilePath C:\Temp\DSCLogsExport.zip -NumberOfDays 3`

-------------------------- EXAMPLE 2 --------------------------

`Export-M365DSCDiagnosticData -ExportFilePath C:\Temp\DSCLogsExport.zip -Anonymize -Server spfe -Domain contoso.com -Url sharepoint.contoso.com`


