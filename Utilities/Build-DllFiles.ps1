<#
.SYNOPSIS
    Builds the Microsoft365DSC C# projects and copies the DLLs to the module dependencies folder.

.DESCRIPTION
    This script builds the Microsoft365DSC C# projects targeting netstandard2.0 and copies the resulting
    DLLs to the Microsoft365DSC module's Dependencies/Assemblies directory.

.PARAMETER Configuration
    Build configuration: Debug or Release. Default is Release.

.PARAMETER RepositoryRoot
    Root directory of the Microsoft365DSC repository. Default is parent of script location.

.PARAMETER SkipClean
    Skip the clean step before building. Useful for incremental builds during development.

.EXAMPLE
    PS> .\Build-DllFiles.ps1
    Builds the Microsoft365DSC C# projects in Release configuration.

.EXAMPLE
    PS> .\Build-DllFiles.ps1 -Configuration Debug -SkipClean
    Builds in Debug configuration without cleaning first.

.NOTES
    Requires .NET SDK 6.0 or higher to be installed for build tools.
    The compiled DLL targets .NET Standard 2.0 for compatibility with .NET Framework 4.7.2+ and .NET Core 2.0+.
#>

[CmdletBinding()]
param(
    [Parameter()]
    [ValidateSet('Debug', 'Release')]
    [System.String]
    $Configuration = 'Release',

    [Parameter()]
    [System.String]
    $RepositoryRoot,

    [Parameter()]
    [switch]
    $SkipClean
)

# Verify .NET SDK is available
try {
    $dotnetVersion = dotnet --version
    Write-Host "Using .NET SDK version: $dotnetVersion" -ForegroundColor Green
} catch {
    Write-Error "dotnet CLI not found. Please install .NET SDK 6.0 or higher from https://dotnet.microsoft.com/download"
    exit 1
}

$nugetSource = "https://api.nuget.org/v3/index.json"
$currentNugetSources = (dotnet nuget list source --format short) -join ", "
if (-not ($currentNugetSources -like "*$nugetSource*")) {
    Write-Host "Adding NuGet source: $nugetSource" -ForegroundColor Yellow
    dotnet nuget add source $nugetSource --name "nuget.org"
} else {
    Write-Host "NuGet source already configured: $nugetSource" -ForegroundColor Green
}

function Build-Project {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProjectName,

        [Parameter(Mandatory = $true)]
        [string]$Configuration,

        [Parameter(Mandatory = $true)]
        [string]$RepositoryRoot,

        [Parameter(Mandatory = $false)]
        [switch]$SkipClean
    )

    $projectPath = Join-Path -Path $RepositoryRoot -ChildPath "src/$ProjectName/$ProjectName.csproj"
    $outputDir = Join-Path -Path $RepositoryRoot -ChildPath "src/$ProjectName/bin/$Configuration/netstandard2.0"
    $targetDir = Join-Path -Path $RepositoryRoot -ChildPath 'Modules/Microsoft365DSC/Dependencies/Assemblies'

    Write-Host "Building $ProjectName..." -ForegroundColor Cyan
    Write-Host "Repository Root: $RepositoryRoot" -ForegroundColor Gray
    Write-Host "Project Path: $projectPath" -ForegroundColor Gray
    Write-Host "Configuration: $Configuration" -ForegroundColor Gray

    # Verify project file exists
    if (-not (Test-Path -Path $projectPath)) {
        Write-Error "Project file not found at: $projectPath"
        exit 1
    }

    # Clean if requested
    if (-not $SkipClean) {
        Write-Host ""
        Write-Host "Cleaning previous build artifacts..." -ForegroundColor Yellow
        $cleanResult = dotnet clean $projectPath -c $Configuration 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "Clean failed, continuing with build..."
            Write-Verbose ($cleanResult | Out-String)
        }
    }

    # Build the project
    Write-Host ""
    Write-Host "Building C# project $ProjectName..." -ForegroundColor Yellow
    $buildResult = dotnet build $projectPath -c $Configuration --nologo 2>&1

    if ($LASTEXITCODE -ne 0) {
        Write-Error "Build failed with exit code $LASTEXITCODE"
        Write-Error ($buildResult | Out-String)
        exit $LASTEXITCODE
    }

    Write-Host "Build succeeded!" -ForegroundColor Green

    # Verify output DLL exists
    $dllPath = Join-Path -Path $outputDir -ChildPath "$projectName.dll"
    if (-not (Test-Path -Path $dllPath)) {
        Write-Error "Build succeeded but DLL not found at expected location: $dllPath"
        exit 1
    }

    # Create target directory if it doesn't exist
    if (-not (Test-Path -Path $targetDir)) {
        Write-Host ""
        Write-Host "Creating target directory: $targetDir" -ForegroundColor Yellow
        New-Item -Path $targetDir -ItemType Directory -Force | Out-Null
    }

    # Copy DLL and dependencies to module assemblies folder
    Write-Host ""
    Write-Host "Copying assemblies to module dependencies..." -ForegroundColor Yellow

    $filesToCopy = @(
        "$projectName.dll"
        "$projectName.pdb" # Include PDB for debugging
        "$projectName.xml" # Include XML documentation
    )

    foreach ($fileName in $filesToCopy) {
        $sourcePath = Join-Path -Path $outputDir -ChildPath $fileName
        $destPath = Join-Path -Path $targetDir -ChildPath $fileName

        if (Test-Path -Path $sourcePath) {
            Copy-Item -Path $sourcePath -Destination $destPath -Force
            Write-Host "  Copied: $fileName" -ForegroundColor Gray
        } else {
            Write-Warning "  Skipped: $fileName (not found)"
        }
    }

    Write-Host ""
    Write-Host "Build completed successfully!" -ForegroundColor Green
    Write-Host "Output location: $targetDir" -ForegroundColor Cyan

    # Display file information
    Write-Host ""
    Write-Host "Assembly Information:" -ForegroundColor Cyan
    $dllInfo = Get-Item -Path (Join-Path -Path $targetDir -ChildPath "$projectName.dll")
    Write-Host "  Size: $($dllInfo.Length) bytes" -ForegroundColor Gray
    Write-Host "  Last Modified: $($dllInfo.LastWriteTime)" -ForegroundColor Gray
}

# Determine repository root
if ([System.String]::IsNullOrEmpty($RepositoryRoot)) {
    $RepositoryRoot = Split-Path -Path $PSScriptRoot -Parent
}

$projects = Get-ChildItem -Path (Join-Path -Path $RepositoryRoot -ChildPath 'src') -Filter "*.csproj" -File -Recurse | ForEach-Object { $_.Name }

foreach ($project in $projects) {
    Build-Project -ProjectName $project.Replace(".csproj", "") -Configuration $Configuration -RepositoryRoot $RepositoryRoot -SkipClean:$SkipClean
}
