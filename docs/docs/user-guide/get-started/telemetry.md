By default, Microsoft365DSC is sending telemetry back to Microsoft to help the team improve the solution in a pro-active manner. Information is all captured using Azure Application Insights. We are capturing information about what operations are being called, what any errors were encountered, used authentication types, used PowerShell version, etc.

## Telemetry Configuration

Users can decide to stop sending telemetry back to Microsoft at any given point by opting out. To do so, simply run the [Set-M365DSCTelemetryOption](../../cmdlets/Set-M365DSCTelemetryOption) PowerShell command:

```PowerShell
Set-M365DSCTelemetryOption -Enabled $false
```

**Note**: This is a ***per machine*** setting. Therefore, if you are executing Microsoft365DSC on different systems within your organization, this command will have to be executed on each system.

## Custom Telemetry Store

Organizations can also decide to capture telemetry from Microsoft365DSC using their own Application Insights account (without sending any data back to Microsoft). The **Set-M365DSCTelemetryOption** cmdlet lets you specify what Application Insights account you wish to send telemetry back to using the **-InstrumentationKey** parameter.

 ![image](https://user-images.githubusercontent.com/2547149/149800998-71bf37ff-ff82-4627-8893-7465d689f0fe.png)

Users can also specify a custom name for their solution using the **-ProjectName** parameter. This will ensure that every telemetry reported back to the Application Insights account gets tagged with the project name under **customDimensions.ProjectName**.
