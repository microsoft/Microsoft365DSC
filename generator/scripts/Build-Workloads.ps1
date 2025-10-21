param(
    [switch]$Force
)

$currentDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
[String]$DataPath = Join-Path -Path $currentDirectory -ChildPath "../public/data"
[String]$ResourcesOutputPath = "$DataPath/resources.json"
[String]$WorkloadsOutputPath = "$DataPath/workloads.json"

Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

# Getting the main workload file from the src data folder
$Workloads = Get-Content -Raw -Path "../src/data/workloads.json" | ConvertFrom-Json
$Resources = @()

# For every resources found, generate an array of resources
Get-ChildItem -Path "../../Modules/Microsoft365DSC/DSCResources" -Directory | ForEach-Object {
    $CurrentResource = $_.Name.Replace('MSFT_', '')
    $settingsFile = Join-Path -Path $_.FullName -ChildPath "settings.json"
    $settingsContent = [System.IO.File]::ReadAllText($settingsFile) | ConvertFrom-Json
    $Workloads | ForEach-Object {
        $CurrentWorkload = $_
        if ($CurrentResource.StartsWith($CurrentWorkload.id))
        {
            if ($settingsContent.mode -eq 'Data')
            {
                $Workloads | Where-Object { $_.id -eq $CurrentWorkload.id } | ForEach-Object {
                    $_.extractionModes.full += $CurrentResource
                }
            }
            $Resources += @{
                "name"     = $CurrentResource;
                "workload" = $CurrentWorkload.id
            }
        }
    }
}

# Creating the data folder if it doesn't exist
if (-not (Test-Path $DataPath))
{
    New-Item -ItemType Directory -Force -Path $DataPath | Out-Null
}

# Serializing on disk the resources and workloads files
ConvertTo-Json -InputObject $Resources -Depth 5 | Out-File $ResourcesOutputPath -Force:$Force
ConvertTo-Json -InputObject $Workloads -Depth 5 | Out-File $WorkloadsOutputPath -Force:$Force

Pop-Location
