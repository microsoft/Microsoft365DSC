# Join-M365DSCConfiguration

## Description

This function is used to join two or more M365DSC configurations into a single configuration.
The function reads the configuration from the specified paths and combines them into a single configuration.
Please note that the function won't be updating the authentication parameters if they differ between the configurations. Make sure that the authentication parameters are the same over all configurations.

## Output

This function does not generate any output.

## Parameters

| Parameter | Required | DataType | Default Value | Allowed Values | Description |
| --- | --- | --- | --- | --- | --- |
| ConfigurationFile | True | String |  |  | The name of the first configuration file to use as the base configuration. |
| ConfigurationPath | True | String |  |  | The directory path to the configuration files to join to the base configuration. |

## Examples

-------------------------- EXAMPLE 1 --------------------------

`Join-M365DSCConfiguration -ConfigurationFile 'M365TenantConfig.ps1' -ConfigurationPath 'D:\testbed'`


