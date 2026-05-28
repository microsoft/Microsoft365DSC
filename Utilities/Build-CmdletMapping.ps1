param(
    [string]$CmdletSourceModulesPath = "$PSScriptRoot\cmdlet-source-modules.json",
    [string]$OutputPath = "$PSScriptRoot\cmdlet-mapping.json"
)

Write-Host "Loading cmdlet list from: $CmdletSourceModulesPath"
$cmdletModules = Get-Content $CmdletSourceModulesPath -Raw | ConvertFrom-Json

$cmdletNames = @($cmdletModules.PSObject.Properties.Name | Sort-Object)
Write-Host "Processing $($cmdletNames.Count) cmdlets..."

$mapping = [ordered]@{}
$failed = [System.Collections.Generic.List[string]]::new()
$counter = 0

foreach ($cmdletName in $cmdletNames)
{
    $counter++
    if ($counter % 50 -eq 0) {
        Write-Host "  $counter / $($cmdletNames.Count)..."
    }

    $sourceModule = $cmdletModules.$cmdletName

    # Determine API version from module name
    $apiVersion = if ($sourceModule -like '*Beta*' -or $cmdletName -match '-MgBeta')
    {
        'beta'
    }
    else
    {
        'v1.0'
    }

    try
    {
        $info = Find-MgGraphCommand -Command $cmdletName -ApiVersion $apiVersion -ErrorAction Stop
    }
    catch
    {
        # Try the other API version
        $altVersion = if ($apiVersion -eq 'beta') { 'v1.0' } else { 'beta' }
        try
        {
            $info = Find-MgGraphCommand -Command $cmdletName -ApiVersion $altVersion -ErrorAction Stop
            $apiVersion = $altVersion
        }
        catch
        {
            Write-Warning "  Failed to find: $cmdletName"
            $failed.Add($cmdletName)
            continue
        }
    }

    if ($null -eq $info)
    {
        Write-Warning "  No results for: $cmdletName"
        $failed.Add($cmdletName)
        continue
    }

    # Separate single-item (with {id} placeholder) and list (no placeholder) variants
    $variants = @()
    foreach ($v in $info)
    {
        $variants += [ordered]@{
            Method     = $v.Method
            URI        = $v.URI
            ApiVersion = $v.APIVersion
        }
    }

    $mapping[$cmdletName] = [ordered]@{
        SourceModule = $sourceModule
        ApiVersion   = $apiVersion
        Variants     = $variants
    }
}

Write-Host "`nSaving mapping for $($mapping.Count) cmdlets to: $OutputPath"
$mapping | ConvertTo-Json -Depth 5 | Set-Content $OutputPath -Encoding utf8 -Force

if ($failed.Count -gt 0)
{
    Write-Host "`nFailed to map $($failed.Count) cmdlets:"
    $failed | ForEach-Object { Write-Host "  $_" }
}

Write-Host "Done."
