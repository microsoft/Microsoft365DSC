# Because modules are imported in alphabetical order using NestedModules in the module manifest,
# we need to import the DLL Loader module before everything else with ScriptsToProcess
Import-Module -Name "$PSScriptRoot/Modules/M365DSCDllLoader.psm1" -Global -Force
