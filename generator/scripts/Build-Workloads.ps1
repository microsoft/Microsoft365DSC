param(
    [String]$ResourcesOutputPath = "./generator/public/data/resources.json",
    [String]$WorkloadsOutputPath = "./generator/public/data/workloads.json",
    [switch]$Force
)

$Workloads = Get-Content -Raw -Path "./generator/src/data/workloads.json" | ConvertFrom-Json
Push-Location -Path ../../Modules/Microsoft365DSC/DSCResources
$Resources = @()

Get-ChildItem -Directory | ForEach-Object {
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

Pop-Location

ConvertTo-Json -InputObject $Resources -Depth 5 | Out-File $ResourcesOutputPath -Force:$Force
ConvertTo-Json -InputObject $Workloads -Depth 5 | Out-File $WorkloadsOutputPath -Force:$Force
