$resourceToTemplateIdMap = @{}
Get-ChildItem -Path "$PSScriptRoot/../Modules/Microsoft365DSC/DscResources" -Recurse -Filter "*Intune*.psm1" -File | Foreach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -match '\$policyTemplateI[dD] = ''([a-f0-9\-]+_[0-9]+)''') {
        $templateId = $matches[1]
        $resourceName = $_.BaseName.Replace('MSFT_', '')
        $resourceToTemplateIdMap.Add($resourceName, $templateId)
    }
}
$resourceToTemplateIdMap | ConvertTo-Json -Depth 5 | Set-Content -Path "$PSScriptRoot/../Modules/Microsoft365DSC/IntuneTemplateRegistry.json"
