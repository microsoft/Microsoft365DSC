# Set-M365DSCTelemetryOption

## Description

This function configures the telemetry feature of M365DSC

## Output

This function does not generate any output.

## Parameters

| Parameter | Required | DataType | Default Value | Allowed Values | Description |
| --- | --- | --- | --- | --- | --- |
| Enabled | False | Boolean |  |  | Enables or disables telemetry collection. |
| InstrumentationKey | False | String |  |  | Specifies the Instrumention Key to be used to send the telemetry to. |
| ProjectName | False | String |  |  | Specifies the name of the project to store the telemetry data under. |
| ConnectionString | False | String |  |  |  |

## Examples

-------------------------- EXAMPLE 1 --------------------------

`Set-M365DSCTelemetryOption -Enabled $false`


