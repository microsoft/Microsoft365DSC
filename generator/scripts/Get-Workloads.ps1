    param(
        [Parameter(Mandatory=$true)]
        $OutputPath,
        
        [switch]
        $Force
    )

    $Workloads = Get-Content -Raw -Path "../src/data/workloads.json" | ConvertFrom-Json
    Push-Location -Path ../../Modules/Microsoft365DSC/DSCResources

    Get-ChildItem -Directory | ForEach-Object {
        $CurrentResource = $_.Name.Replace('MSFT_', '')
        $Workloads | ForEach-Object {
            $CurrentWorkload = $_
            if($CurrentResource.StartsWith($CurrentWorkload.acronym)) {
                $CurrentWorkload.resources += @{
                    "name" = $CurrentResource
                }
            }
        }
    }

    Pop-Location
    
    ConvertTo-Json -InputObject $Workloads -Depth 5 | Out-File $OutputPath -Force:$Force
