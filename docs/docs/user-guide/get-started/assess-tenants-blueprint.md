It is important to understand here that we use the term **Blueprint** loosely. A blueprint is nothing but a verified and validated Microsoft365DSC configuration file. These Blueprints are configuration files that have been reviewed and approved by an entity and have the .m365 extension. Note that it is completely possible to use any other .ps1 configuration as a blueprint to assess a tenant. In fact you can extract the configuration from a tenant (using the steps in the above section), and use that extracted configuration to assess any other tenant against it. PowerShell Desired State Configuration (DSC) let's you assess an environment against any given compiled DSC configuration without actually applying it on the environment. If you wish to assess the state of your Microsoft 365 tenant against a blueprint you can either use a local blueprint or use an hosted blueprint hosted in a public repository such as GitHub.

To assess a tenant against a local blueprint (.m365 or .ps1), you can use the following PowerShell command. Running the command will prompt you to provide the administrator credentials of the tenant you wish to assess the blueprint against.

```powershell
Assert-M365DSCBluePrint -BlueprintUrl {local path or URL to the Blueprint} -OutputReportPath {path to where to save the .html file}
```
