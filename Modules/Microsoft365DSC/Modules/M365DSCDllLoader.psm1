<#
.SYNOPSIS
    Loads and initializes the Microsoft365DSC C# dll files.

.DESCRIPTION
    This module loads all of the Microsoft365DSC.*.dll at module import time.
    It provides fail-fast validation of .NET Framework version requirements and
    exports initialization status for diagnostics.

.NOTES
    The dll loader requires .NET Framework 4.7.2 or higher.
    The DLLs are located in the Dependencies/Assemblies directory relative to the module root.
#>

$Script:AcceleratorLoaded = $false
$Script:AcceleratorAssembly = $null
$Script:AcceleratorLoadError = $null

$Script:ConverterLoaded = $false
$Script:ConverterAssembly = $null
$Script:ConverterLoadError = $null

<#
.SYNOPSIS
    Initializes the Microsoft365DSC C# dll files.

.DESCRIPTION
    Validates .NET Framework version requirements and loads the compiled C# dll files.
    This function is called automatically during module import but can be invoked manually
    for troubleshooting or reloading scenarios.

.PARAMETER Force
    Forces reloading of the dll files even if already loaded.

.EXAMPLE
    PS> Initialize-M365DSCDllLoader
    Loads the dll files with standard version checks.
.EXAMPLE
    PS> Initialize-M365DSCDllLoader -Force
    Forces reload of the dll files.

.OUTPUTS
    System.Collections.Hashtable with keys: Loaded (bool), Assembly (Reflection.Assembly), Error (string)
#>
function Initialize-M365DSCDllLoader
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    try
    {
        # Validate .NET Framework version (4.7.2 = Release 461808+)
        $netFrameworkVersion = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full' -ErrorAction Stop
        $releaseKey = $netFrameworkVersion.Release

        if ($releaseKey -lt 461808)
        {
            $versionString = $netFrameworkVersion.Version
            $errorMessage = ".NET Framework 4.7.2 or higher is required for Microsoft365DSC C# dll files. Current version: $versionString (Release: $releaseKey). Please install .NET Framework 4.7.2+ from https://dotnet.microsoft.com/download/dotnet-framework"

            Write-Error -Message $errorMessage -ErrorAction Stop
        }

        Write-Verbose -Message ".NET Framework version check passed (Release: $releaseKey)"

        # Locate the accelerator DLL
        $moduleRoot = Split-Path -Path $PSScriptRoot -Parent
        $dllsToLoad = @(
            'Microsoft365DSC.Cache.dll'
            'Microsoft365DSC.Compare.dll'
            'Microsoft365DSC.Connection.dll'
            'Microsoft365DSC.Converter.dll'
            'Microsoft365DSC.Intune.dll'
            'Microsoft365DSC.Utilities.dll'
        )

        foreach ($dllName in $dllsToLoad)
        {
            $dllPath = Join-Path -Path $moduleRoot -ChildPath "Dependencies/Assemblies/$dllName"
            if (-not (Test-Path -Path $dllPath))
            {
                $errorMessage = "$dllName not found at: $dllPath. Please run Utilities/Build-DllFiles.ps1 to build the dll file."
                Write-Warning $errorMessage

                $Script:AcceleratorLoaded = $false
                $Script:AcceleratorLoadError = $errorMessage

                return @{
                    Loaded = $false
                    Assembly = $null
                    Error = $errorMessage
                }
            }

            Write-Verbose -Message "Loading dll from: $dllPath"
        }

        # Load the assembly
        $loadedAssemblies = @()
        foreach ($dllName in $dllsToLoad)
        {
            $dllPath = Join-Path -Path $moduleRoot -ChildPath "Dependencies/Assemblies/$dllName"
            $loadedAssemblies += Add-Type -Path $dllPath -PassThru -ErrorAction Stop
        }

        # Verify expected types are available
        $expectedTypes = @(
            'Microsoft365DSC.Compare.ComplexObjectComparer'
            'Microsoft365DSC.Connection.ConnectionHelper'
            'Microsoft365DSC.Converter.ComplexObjectConverter'
            'Microsoft365DSC.Converter.SimpleObjectConverter'
            'Microsoft365DSC.Utilities.Utilities'
        )

        foreach ($typeName in $expectedTypes)
        {
            $currentAssemblies = [AppDomain]::CurrentDomain.GetAssemblies().Where({ $_.FullName -like "Microsoft365DSC.*" })
            $type = $currentAssemblies | ForEach-Object { $_.GetTypes() } | Where-Object { $_.FullName -eq $typeName }
            if ($null -eq $type)
            {
                Write-Warning "Expected type not found in assembly: $typeName"
            }
            else
            {
                Write-Verbose -Message "Verified accelerator type: $typeName"
            }
        }

        Write-Verbose -Message "Microsoft365DSC C# dll files loaded successfully."
    }
    catch
    {
        throw "Failed to initialize Microsoft365DSC C# dll files: $($_.Exception.Message)"
    }
}

Export-ModuleMember -Function Initialize-M365DSCDllLoader
