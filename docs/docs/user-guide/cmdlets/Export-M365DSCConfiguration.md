# Export-M365DSCConfiguration

## Description

This is the main Microsoft365DSC.Reverse function that extracts the DSC configuration from an existing Microsoft 365 Tenant.

## Output

This function does not generate any output.

## Parameters

| Parameter | Required | DataType | Default Value | Allowed Values | Description |
| --- | --- | --- | --- | --- | --- |
| LaunchWebUI | False | SwitchParameter |  |  | Adding this parameter will open the WebUI in a browser. |
| Path | False | String |  |  | Specifies the path in which the exported DSC configuration should be stored. |
| FileName | False | String |  |  | Specifies the name of the file in which the exported DSC configuration should be stored. |
| ConfigurationName | False | String |  |  | Specifies the name of the configuration that will be generated. |
| Components | False | String[] |  |  | Specifies the components for which an export should be created. |
| Workloads | False | String[] |  | AAD, SPO, EXO, INTUNE, SC, OD, O365, PLANNER, PP, TEAMS | Specifies the workload for which an export should be created for all resources. |
| Mode | False | String | Default | Lite, Default, Full | Specifies the mode of the export: Lite, Default or Full. |
| MaxProcesses | False | Object |  |  | Specifies the maximum number of processes that should run simultanious. |
| GenerateInfo | False | Boolean |  |  | Specifies if each exported resource should get a link to the Wiki article of the resource. |
| Filters | False | Hashtable |  |  | Specifies resource level filters to apply in order to reduce the number of instances exported. |
| ApplicationId | False | String |  |  | Specifies the application id to be used for authentication. |
| TenantId | False | String |  |  | Specifies the id of the tenant. |
| ApplicationSecret | False | String |  |  | Specifies the application secret of the application to be used for authentication. |
| CertificateThumbprint | False | String |  |  | Specifies the thumbprint to be used for authentication. |
| Credential | False | PSCredential |  |  | Specifies the credentials to be used for authentication. |
| CertificatePassword | False | PSCredential |  |  | Specifies the password of the PFX file which is used for authentication. |
| CertificatePath | False | String |  |  | Specifies the path of the PFX file which is used for authentication. |
| ManagedIdentity | False | SwitchParameter |  |  | Specifies use of managed identity for authentication. |
| AccessTokens | False | String[] |  |  |  |
| Validate | False | SwitchParameter |  |  | Specifies that the configuration needs to be validated for conflicts or issues after its extraction is completed. |

## Examples

-------------------------- EXAMPLE 1 --------------------------

`Export-M365DSCConfiguration -Components @("AADApplication", "AADConditionalAccessPolicy", "AADGroupsSettings") -Credential $Credential`

-------------------------- EXAMPLE 2 --------------------------

`Export-M365DSCConfiguration -Mode 'Default' -ApplicationId '2560bb7c-bc85-415f-a799-841e10ec4f9a' -TenantId 'contoso.sharepoint.com' -ApplicationSecret 'abcdefghijkl'`

-------------------------- EXAMPLE 3 --------------------------

`Export-M365DSCConfiguration -Components @("AADApplication", "AADConditionalAccessPolicy", "AADGroupsSettings") -Credential $Credential -Path 'C:\DSC' -FileName 'MyConfig.ps1'`

-------------------------- EXAMPLE 4 --------------------------

`Export-M365DSCConfiguration -Credential $Credential -Filters @{AADApplication = "DisplayName eq 'MyApp'"}`


