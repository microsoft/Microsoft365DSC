param(
    [String]$ResourcesOutputPath = "../public/data/resources.json",
    [String]$WorkloadsOutputPath = "../public/data/workloads.json",
    [switch]$Force
)

Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

$Workloads = Get-Content -Raw -Path "../src/data/workloads.json" | ConvertFrom-Json
$Resources = @()

Get-ChildItem -Path "../../Modules/Microsoft365DSC/DSCResources" -Directory | ForEach-Object {
    $CurrentResource = $_.Name.Replace('MSFT_', '')
    $Workloads | ForEach-Object {
        $CurrentWorkload = $_
        if ($CurrentResource.StartsWith($CurrentWorkload.id))
        {
            $Resources += @{
                "name"     = $CurrentResource;
                "workload" = $_.id
            }
        }
    }
}

ConvertTo-Json -InputObject $Resources -Depth 5 | Out-File $ResourcesOutputPath -Force:$Force
ConvertTo-Json -InputObject $Workloads -Depth 5 | Out-File $WorkloadsOutputPath -Force:$Force

Pop-Location
