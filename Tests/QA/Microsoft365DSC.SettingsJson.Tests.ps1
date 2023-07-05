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

Describe -Name 'Successfully validate all used permissions in Settings.json files' {
    BeforeAll {
        $data = Invoke-WebRequest -Uri 'https://graphpermissions.azurewebsites.net/api/GetPermissionList'
        $allPermissions = $data.Split(',')
    }

     It "Permissions used in settings.json file for '<ResourceName>' should exist" -TestCases $settingsFiles {
        $json = Get-Content -Path $FullName -Raw
        $settings = ConvertFrom-Json -InputObject $json
        foreach ($permission in $settings.permissions.graph.delegated.read)
        {
            # Only validate non-GUID (hidden) permissions.
            $ObjectGuid = [System.Guid]::empty
            if (-not [System.Guid]::TryParse($permission.Name  ,[System.Management.Automation.PSReference]$ObjectGuid))
            {
                $permission.Name | Should -BeIn $allPermissions
            }
        }
    }
}
