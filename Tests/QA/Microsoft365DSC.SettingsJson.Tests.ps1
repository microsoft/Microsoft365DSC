BeforeDiscovery {
    $resourcesPath = Join-Path -Path $PSScriptRoot -ChildPath '..\..\Modules\Microsoft365DSC\DSCResources'
    $settingsFiles = Get-ChildItem -Path $resourcesPath -Filter '*.json' -Recurse | ForEach-Object {
        @{
            ResourceName = $_.Directory.Name
            FullName     = $_.FullName
        }
    }
}

Describe -Name 'Successfully import Settings.json files' {
    It "File for '<ResourceName>' should be read successfully" -TestCases $settingsFiles {
        $json = Get-Content -Path $FullName -Raw
        { ConvertFrom-Json -InputObject $json } | Should -Not -Throw
    }
}
