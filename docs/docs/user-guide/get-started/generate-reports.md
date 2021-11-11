Whether you wrote your own Microsoft365DSC configuration or you've exported it from an existing tenant, you can convert it to either an HTML or Excel report. Both these reports are read-only, and values changed in the Excel report will not update values in your tenant. To generate reports from an existing configuration, you need to use the **New-M365DSCReportFromConfiguration** cmdlet. This cmdlet let's you specify what type of report you wish to generate (HTML or Excel), specify the path to the configuration you are generating the report for and the destination path where you wish to store the generated report.

```powershell
New-M365DSCReportFromConfiguration -Type Excel -ConfigurationPath c:\DSC\PathToMyConfig.ps1 -OutputPath c:\whatever\Report.xlsx
New-M365DSCReportFromConfiguration -Type HTML -ConfigurationPath c:\DSC\PathToMyConfig.ps1 -OutputPath c:\whatever\Report.html
```
Microsoft365DSC also allows you to generate discrepancy reports between two configurations. The discrepancy report will identify the differences between the two configuration into an HTML format.

```powershell
New-M365DSCDeltaReport -Source 'C:\DSC\SourceConfig.ps1' -Destination 'C:\DSC\DestinationConfig.ps1' -OutputPath 'C:\Output\Delta.html'
```
