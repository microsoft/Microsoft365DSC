param(
    [String]$DataPath = "../public/data",
    [String]$ResourcesOutputPath = "$DataPath/resources.json",
    [String]$WorkloadsOutputPath = "$DataPath/workloads.json",
    [switch]$Force
)

Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

# Getting the main workload file from the src data folder
$Workloads = Get-Content -Raw -Path "../src/data/workloads.json" | ConvertFrom-Json
$Resources = @()

# For every resources found, generate an array of resources
Get-ChildItem -Path "../../Modules/Microsoft365DSC/DSCResources" -Directory | ForEach-Object {
    $CurrentResource = $_.Name.Replace('MSFT_', '')
    $Workloads | ForEach-Object {
        $CurrentWorkload = $_
        if ($CurrentResource.StartsWith($CurrentWorkload.id))
        {
            $Resources += @{
                "name"     = $CurrentResource;
                "workload" = $CurrentWorkload.id
            }
        }
    }
}

# Creating the data folder if it doesn't exist
if (!(Test-Path $DataPath))
{
    New-Item -ItemType Directory -Force -Path $DataPath | Out-Null
}

# Serializing on disk the resources and workloads files
ConvertTo-Json -InputObject $Resources -Depth 5 | Out-File $ResourcesOutputPath -Force:$Force
ConvertTo-Json -InputObject $Workloads -Depth 5 | Out-File $WorkloadsOutputPath -Force:$Force

Pop-Location
