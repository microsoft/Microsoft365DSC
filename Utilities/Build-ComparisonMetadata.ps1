<#
.SYNOPSIS
    Scans all M365DSC resources for custom comparison parameters and generates ComparisonMetadata.json

.DESCRIPTION
    This script analyzes all DSC resources in the Microsoft365DSC module to identify resources
    that have a Get-CompareParameters function. It extracts the comparison logic
    (ExcludedProperties, IncludedProperties, PostProcessing, PostProcessingArgs) from the
    function's return value and generates or updates the ComparisonMetadata.json file.

.PARAMETER ResourcesPath
    The path to the DSCResources folder. Defaults to the standard location.

.PARAMETER OutputPath
    The path where ComparisonMetadata.json should be saved. Defaults to the Modules/Microsoft365DSC folder.

.PARAMETER Force
    If specified, overwrites the existing ComparisonMetadata.json file completely.

.EXAMPLE
    PS> .\Build-ComparisonMetadata.ps1

.EXAMPLE
    PS> .\Build-ComparisonMetadata.ps1 -Force

.NOTES
    This script looks for Get-CompareParameters functions and analyzes their return values.
#>

[CmdletBinding()]
param
(
    [Parameter()]
    [System.String]
    $ResourcesPath = (Join-Path -Path $PSScriptRoot -ChildPath '..\Modules\Microsoft365DSC\DSCResources'),

    [Parameter()]
    [System.String]
    $OutputPath = (Join-Path -Path $PSScriptRoot -ChildPath '..\Modules\Microsoft365DSC\ComparisonMetadata.json'),

    [Parameter()]
    [switch]
    $Force
)

Write-Host "Starting scan of M365DSC resources for custom comparison parameters..." -ForegroundColor Cyan

# Get all resource module files
$resourceFiles = Get-ChildItem -Path $ResourcesPath -Filter "MSFT_*.psm1" -Recurse -File | Where-Object -FilterScript {
    $_.Directory.Name -eq $_.BaseName
}

Write-Host "Found $($resourceFiles.Count) resource files to scan" -ForegroundColor Green

# Initialize results
$resourcesWithCustomComparison = @{}
$scanResults = @()

# Regex pattern to find Get-CompareParameters function
$getCompareParamsPattern = '(?s)function\s+Get-CompareParameters\s*\{.*?return\s+@\{(.*?)\n\s{4}}'

$progressCount = 0
foreach ($resourceFile in $resourceFiles)
{
    $progressCount++
    $resourceName = $resourceFile.BaseName -replace '^MSFT_', ''

    Write-Progress -Activity "Scanning resources" `
        -Status "Processing $resourceName ($progressCount/$($resourceFiles.Count))" `
        -PercentComplete (($progressCount / $resourceFiles.Count) * 100)

    # Read file content once
    $content = Get-Content -Path $resourceFile.FullName -Raw

    # Check if Get-CompareParameters function exists
    if ($content -notmatch 'function\s+Get-CompareParameters')
    {
        continue
    }

    # Find the Get-CompareParameters function and extract its return value
    $match = [regex]::Match($content, $getCompareParamsPattern)

    if (-not $match.Success)
    {
        Write-Warning "Found Get-CompareParameters in $resourceName but couldn't parse return value"
        continue
    }

    $returnBody = $match.Groups[1].Value

    # Check for custom parameters in the return hashtable
    $hasExcludedProperties = $returnBody -match 'ExcludedProperties\s*='
    $hasIncludedProperties = $returnBody -match 'IncludedProperties\s*='
    $hasPostProcessing = $returnBody -match 'PostProcessing\s*='
    $hasPostProcessingArgs = $returnBody -match 'PostProcessingArgs\s*='

    # If any custom parameter is found, this resource needs metadata
    if ($hasExcludedProperties -or $hasIncludedProperties -or $hasPostProcessing -or $hasPostProcessingArgs)
    {
        $description = @()

        if ($hasExcludedProperties)
        {
            # Try to extract the excluded properties array
            if ($returnBody -match 'ExcludedProperties\s*=\s*@\(([^\)]+)\)')
            {
                $props = $Matches[1] -replace "'", "" -replace '"', '' -replace '\s+', ' '
                $description += "Excludes properties: $props"
            }
            else
            {
                $description += "Uses ExcludedProperties"
            }
        }

        if ($hasIncludedProperties)
        {
            # Try to extract the included properties array
            if ($returnBody -match 'IncludedProperties\s*=\s*@\(([^\)]+)\)')
            {
                $props = $Matches[1] -replace "'", "" -replace '"', '' -replace '\s+', ' '
                $description += "Includes properties: $props"
            }
            else
            {
                $description += "Uses IncludedProperties"
            }
        }

        if ($hasPostProcessing)
        {
            $description += "Uses PostProcessing scriptblock"
        }

        if ($hasPostProcessingArgs)
        {
            $description += "Uses PostProcessingArgs"
        }

        $resourcesWithCustomComparison[$resourceName] = @{
            HasCustomComparison = $true
            Description = $description -join "; "
        }

        $scanResults += [PSCustomObject]@{
            ResourceName = $resourceName
            FilePath = $resourceFile.FullName
            ExcludedProperties = $hasExcludedProperties
            IncludedProperties = $hasIncludedProperties
            PostProcessing = $hasPostProcessing
            PostProcessingArgs = $hasPostProcessingArgs
            Description = $description -join "; "
        }
    }
}

Write-Progress -Activity "Scanning resources" -Completed

Write-Host "`nScan complete!" -ForegroundColor Green
Write-Host "Found $($resourcesWithCustomComparison.Count) resources with custom comparison logic" -ForegroundColor Green

# Display summary
if ($scanResults.Count -gt 0)
{
    Write-Host "`nResources with custom comparison:" -ForegroundColor Yellow
    $scanResults | Sort-Object ResourceName | Format-Table ResourceName, ExcludedProperties, IncludedProperties, PostProcessing, PostProcessingArgs -AutoSize
}

# Load existing metadata if not forcing
$existingMetadata = @{}
if ((Test-Path -Path $OutputPath) -and -not $Force)
{
    Write-Host "`nLoading existing metadata from $OutputPath" -ForegroundColor Cyan
    try
    {
        $existingJson = Get-Content -Path $OutputPath -Raw | ConvertFrom-Json
        foreach ($resource in $existingJson.Resources.PSObject.Properties)
        {
            $existingMetadata[$resource.Name] = @{
                HasCustomComparison = $resource.Value.HasCustomComparison
                Description = $resource.Value.Description
            }
        }
        Write-Host "Loaded $($existingMetadata.Count) existing entries" -ForegroundColor Green
    }
    catch
    {
        Write-Warning "Failed to load existing metadata: $_"
    }
}

# Merge with existing metadata (new discoveries take precedence)
foreach ($key in $existingMetadata.Keys)
{
    if (-not $resourcesWithCustomComparison.ContainsKey($key))
    {
        $resourcesWithCustomComparison[$key] = $existingMetadata[$key]
    }
}

# Build the metadata structure
$metadata = [ordered]@{
    Description = "Metadata for resources that require custom comparison logic during drift detection and reporting. When HasCustomComparison is true, the resource's Get-CompareParameters function will be invoked to retrieve comparison-specific parameters (ExcludedProperties, IncludedProperties, PostProcessing, etc.)."
    LastGenerated = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    TotalResources = $resourcesWithCustomComparison.Count
    Resources = [ordered]@{}
}

# Sort resources alphabetically
$sortedResources = $resourcesWithCustomComparison.GetEnumerator() | Sort-Object Name

foreach ($resource in $sortedResources)
{
    $metadata.Resources[$resource.Name] = [ordered]@{
        HasCustomComparison = $resource.Value.HasCustomComparison
        Description = $resource.Value.Description
    }
}

# Convert to JSON with proper formatting
$jsonOutput = $metadata | ConvertTo-Json -Depth 10

# Save to file
Write-Host "`nSaving metadata to $OutputPath" -ForegroundColor Cyan
try
{
    $jsonOutput | Set-Content -Path $OutputPath -Encoding UTF8 -Force
    Write-Host "Metadata file saved successfully!" -ForegroundColor Green
    Write-Host "Total resources in metadata: $($metadata.TotalResources)" -ForegroundColor Green
}
catch
{
    throw "Failed to save metadata file: $_"
}

# Summary statistics
Write-Host "`n=== Summary ===" -ForegroundColor Cyan
Write-Host "Total resources scanned: $($resourceFiles.Count)" -ForegroundColor White
Write-Host "Resources with custom comparison: $($scanResults.Count)" -ForegroundColor White
Write-Host "  - With ExcludedProperties: $(($scanResults | Where-Object ExcludedProperties).Count)" -ForegroundColor White
Write-Host "  - With IncludedProperties: $(($scanResults | Where-Object IncludedProperties).Count)" -ForegroundColor White
Write-Host "  - With PostProcessing: $(($scanResults | Where-Object PostProcessing).Count)" -ForegroundColor White
Write-Host "  - With PostProcessingArgs: $(($scanResults | Where-Object PostProcessingArgs).Count)" -ForegroundColor White
