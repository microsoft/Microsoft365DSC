# Update-M365DSCResourcesSettingsJSON

## Description

This function updates the settings.json files for all resources that use Graph cmdlets.
It is compiling a permissions list based on all used Graph cmdlets in the resource and
retrieving the permissions for these cmdlets from the Graph. Then it updates the
settings.json file

## Output

This function does not generate any output.

## Parameters

This function does not have any input parameters.
## Examples

-------------------------- EXAMPLE 1 --------------------------

`Update-M365DSCResourcesSettingsJSON`



