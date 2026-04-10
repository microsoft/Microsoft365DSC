# Dynamic Resource Generator

The Microsoft365DSC Dynamic Resource Generator (DRG) is a set of PowerShell Modules and templates that enables the automatic generation of Microsoft365DSC resources, examples, and unit tests based on OpenAPI definitions. Currently it only supports generating resources from Microsoft Graph endpoints, but the team is investigating expanding its scope to also include other dependencies that are not yet on Microsoft Graph (e.g., Exchange Online, Teams, etc.). The DRG is included as part of the main Microsoft365DSC codebase and is currently in **public preview**, which means it is likely to change before becoming Generally Available (GA).

## Why the DRG?

Microsoft 365 is evolving at a rapid pace, with new features being released on a regular basis and other legacy configuration items being deprecated. So far, the Microsoft365DSC team has been manually creating the DSC resources that make up the solution, which has been very time-consuming and requires constant updating as these resources change and evolve. The Dynamic Resource Generator will allow the team to reduce manual effort and enable faster release of DSC resources and open the floodgates, releasing dozens of DSC resources with minimal effort and ensuring they are always in-sync with their underlying workload dependencies (e.g., Microsoft Graph, Exchange Online Management Shell, etc.). The team is committed to investing time in building and improving the DRG in order to ensure the sustainability of the Microsoft project in the long run.

## Getting Started

The DRG files are located at the root of the project under the `ResourceGenerator` folder. This folder contains:
- A single PowerShell module (M365DSCResourceGenerator.psm1) 
- Several template files that define the structure of the various files to generate.
The main function for the module is the **New-M365DSCResource** cmdlet which will initiate the creation of a new DSC resource alongside its associated schema, readme file, examples, and unit tests. The cmdlet accepts the following parameters:

| Parameter Name | Required | Accepted Values | Description |
| --- | --- | --- | --- |
| ResourceName | **True** | String | The name of the resource to be generated. E.g., AADDomain, IntuneResourceX, etc. |
| Workload | **True** | String. Any of: "ExchangeOnline", "Intune", "MicrosoftGraph", "MicrosoftTeams", "PnP", "PowerPlatforms", "SecurityComplianceCenter" | The name of the Microsoft 365 workload associated with the resource to be generated |
| CmdLetNoun | False | String | The noun part of the cmdlet associated with the resource. E.g., for the AADDomain resource, the associated cmdlet is Get-MgBetaDomain. Therefore the value for this property is 'MgDomain'. |
| Path | False | String | Local path to the root DSCResources folder where all the DSC Resources are being stored (e.g., C:\Github\Microsoft365DSC\Modules\Microsoft365DSC\DSCResources) |
| UnitTestPath | False | String | Local path to the root of the unit test folder (e.g., C:\GitHub\Microsoft365DSC\Tests\Unit\Microsoft365DSC) |
| ExampleFilePath | False | String | Local path to the root of the examples Resources folder (e.g. C:\GitHub\Microsoft365DSC\Modules\Microsoft365DSC\Examples\Resources) |
| APIVersion | False | String. Any of: "v1.0", "beta" | Represents what version of the Microsoft Graph APIs to use. Should use 'v1.0' whenever possible. |
| Credential | False | PSCredential | Credentials of a Microsoft 365 account that will be used to take a snapshot of the resource to be generated from a given tenant. This is used to generate the examples. **Use a test tenant**. |
| SettingsCatalogSettingTemplates | False | Array of device configuration policy templates | Templates of an Intune policy that is based on the Settings Catalog. The templates can be obtained with `Get-MgBetaDeviceManagementConfigurationPolicyTemplateSettingTemplate`. |
| SkipPlatformsAndTechnologies | False | Switch | For a settings catalog resource, if the platforms and technologies should be removed from the parameters for the resource. |

As an example, to generate the AADDomain resource for the Azure Active Directory workload, run the following command. 
**NOTE:**The paths specified represent the local paths on the machine used. Make sure to update this to point to the location of your local branch on your machine.**

```powershell
cd C:\Github\Microsoft365DSC\ResourceGenerator
Import-Module .\M365DSCResourceGenerator.psm1

$ResourcePath = "C:\GitHub\Microsoft365DSC\Modules\Microsoft365DSC\DSCResources"
$UnitTestPath = "C:\GitHub\Microsoft365DSC\Tests\Unit\Microsoft365DSC"
$ExamplePath = "C:\GitHub\Microsoft365DSC\Modules\Microsoft365DSC\Examples\Resources"
$creds = Get-Credential #Use creditials from a test tenant onlt

New-M365DSCResource `
  -ResourceName AADDomain `
  -Workload MicrosoftGraph `
  -CmdletNoun 'MgDomain' `
  -Path $ResourcePath `
  -UnitTestPath $UnitTestPath `
  -ExampleFilePath $ExamplePath `
  -Credential $creds `
```
Running this command will generate the following files under the path you specified:
- DSC Resource - The resource module and schema files (e.g., MSFT_AADDomain.psm1 and MSFT_AADDomain.schema.mof)
- README - auto-generated Docmentation describing the resource's properties
- Example - A sample .ps1 configuration that shows how to use resource in a DSC script
- Unit tests - A Pre-scaffolded Pester test file to validate the resource's behavior

  After generation, review each file to ensure the auto-detected properties match your expectations. Some properties may need to be maarked as [key[ or[Required] in the schema manually, depending on the workload's API behavior.

We are currently looking for users to help us test and improve the DRG. If you are interested in helping out, please try it out with the instructions above and report any issues or questions in the Issues section of the [GitHub repository](https://github.com/microsoft/Microsoft365DSC) mentioning that the item is related to the DRG testing.
