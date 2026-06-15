$MaximumFunctionCount = 32767
Update-M365DSCDependencies -ValidateOnly -Development
$workingDir = Split-Path -Path $PSScriptRoot -Parent
$m365dscModules = (Import-PowerShellDataFile -Path "$workingDir\Modules\Microsoft365DSC\Dependencies\Manifest.psd1").Dependencies.ModuleName + (Import-PowerShellDataFile -Path "$workingDir\Modules\Microsoft365DSC\Dependencies\DevManifest.psd1").Dependencies.ModuleName
foreach ($file in (Get-ChildItem -Path "$workingDir\Modules\Microsoft365DSC\DSCResources" -Filter *.psm1 -Recurse -File)) {
    Write-Host "Processing file: $($file.FullName)"
    $content = Get-Content -Path $file.FullName -Raw
    $resourceCmdlets = @()

    # Get all custom Microsoft365DSC functions that use a Graph cmdlet
    if ($content -like "*Convert*-*Intune*Assignment*") {
        $resourceCmdlets += @("Get-MgGroup", "Get-MgBetaDeviceManagementAssignmentFilter")
    }
    if ($content -like "*Update-DeviceAppManagementAppCategory*") {
        $resourceCmdlets += "Get-MgBetaDeviceAppManagementMobileAppCategory"
    }
    if ($content -like "*Get-IntuneSettingCatalogPolicySetting*") {
        $resourceCmdlets += "Get-MgBetaDeviceManagementConfigurationPolicyTemplateSettingTemplate"
    }
    if ($content -like "*Get-M365DSCIntuneDeviceConfigurationSettings*") {
        $resourceCmdlets += @("Get-MgBetaDeviceManagementTemplateCategory", "Get-MgBetaDeviceManagementTemplateCategoryRecommendedSetting")
    }
    if ($content -like "*Invoke-M365DSCGraphBatchRequest*") {
        $resourceCmdlets += "Invoke-MgGraphRequest"
    }
    if ($content -like "*Get-M365DSCGroupDisplayNameById*") {
        $resourceCmdlets += "Get-MgGroup"
    }
    if ($content -like "*-Workload 'Azure'*") {
        $resourceCmdlets += @("Connect-AzAccount", "Register-AzModule")
    }

    $ast = [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$null, [ref]$null)
    $targetResourceFunctions = $ast.FindAll(
        {
            param($Item)
            return (
                ($Item -is [System.Management.Automation.Language.FunctionDefinitionAst])
            )
        }, $true
    )
    $resourceCmdlets += ($targetResourceFunctions | ForEach-Object -Process {
        $_.FindAll(
            {
                 param($Item)
                 return (
                     ($Item -is [System.Management.Automation.Language.CommandAst])
                 )
            }, $true
        )
    } | Foreach-Object -Process {
        $_.CommandElements[0]
    }).Value | Select-Object -Unique

    # Get all used cmdlets that have *-Mg* in their name that can appear anywhere in the file
    #$resourceCmdlets += [regex]::Matches($content, '\w+-Mg\w+') | ForEach-Object { $_.Value } | Sort-Object -Unique
    $resourceCmdletsGrouped = @()
    if ($resourceCmdlets.Count -gt 0) {
        $commands = Get-Command -Name $resourceCmdlets -ErrorAction SilentlyContinue
        $commands = $commands | Where-Object { $_.ModuleName -in $m365dscModules }
        $commandsNotFunctionOrCmdlet = $commands | Where-Object { $_.CommandType -ne 'Function' -and $_.CommandType -ne 'Cmdlet' }
        if ($commandsNotFunctionOrCmdlet.Count -gt 0) {
            Write-Host "Warning: The following commands are not functions or cmdlets: $($commandsNotFunctionOrCmdlet.Name -join ', ')" -ForegroundColor Yellow
        }
        $resourceCmdletsGrouped += ($commands | Group-Object -Property Source -AsHashTable)?.GetEnumerator() | Sort-Object -Property Key | Foreach-Object { [ordered]@{ module = $_.Key; cmdlets = @($_.Value.Name | Sort-Object)} }
    }

    if ($resourceCmdletsGrouped.Count -gt 0) {
        $settingsFilePath = Join-Path -Path $file.DirectoryName -ChildPath "settings.json"
        $settingsJson = Get-Content -Path $settingsFilePath -Raw | ConvertFrom-Json -AsHashtable
        $settingsJson["requiredModules"] = @($resourceCmdletsGrouped.module)
        $settingsJson["commands"] = $resourceCmdletsGrouped
        $fileOutput = $settingsJson | ConvertTo-Json -Depth 5
        $fileOutput | Out-File -FilePath $settingsFilePath -Encoding utf8 -Force
    }
}

$cmdletsGroupMap = @{}
foreach ($file in (Get-ChildItem -Path "$workingDir\Modules\Microsoft365DSC\Modules" -Filter *.psm1 -Recurse -File)) {
    Write-Host "Processing file: $($file.FullName)"
    $content = Get-Content -Path $file.FullName -Raw

    # Get all used cmdlets that have *-Mg* in their name that can appear anywhere in the file
    $resourceCmdlets = @()
    $resourceCmdlets += [regex]::Matches($content, '\w+-Mg\w+') | ForEach-Object { $_.Value } | Sort-Object -Unique
    if ($resourceCmdlets.Count -gt 0) {
        $commands = Get-Command $resourceCmdlets -ErrorAction SilentlyContinue
        $commandsNotFunctionOrCmdlet = $commands | Where-Object { $_.CommandType -ne 'Function' -and $_.CommandType -ne 'Cmdlet' }
        if ($commandsNotFunctionOrCmdlet.Count -gt 0) {
            Write-Host "Warning: The following commands are not functions or cmdlets: $($commandsNotFunctionOrCmdlet.Name -join ', ')" -ForegroundColor Yellow
        }
        foreach ($cmdlet in $commands) {
            if ($cmdlet.CommandType -eq 'Function' -or $cmdlet.CommandType -eq 'Cmdlet') {
                if ($cmdletsGroupMap.ContainsKey($cmdlet.Source)) {
                    $cmdletsGroupMap[$cmdlet.Source] += $cmdlet.Name
                }
                else {
                    $cmdletsGroupMap[$cmdlet.Source] = @($cmdlet.Name)
                }
            }
        }
    }
}

# Output the cmdletsGroupMap to a JSON file
$settingsFilePath = Join-Path -Path "$workingDir\Modules\Microsoft365DSC" -ChildPath "config2.json"
$settingsJson = @{
    requiredModules = @{}
}
foreach ($entry in $cmdletsGroupMap.GetEnumerator()) {
    $settingsJson["requiredModules"].$($entry.Key) = @($entry.Value | Sort-Object -Unique)
}
$fileOutput = $settingsJson | ConvertTo-Json -Depth 5
$fileOutput | Out-File -FilePath $settingsFilePath -Encoding utf8 -Force
