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
        $roles = $data.Content.Split('|')[0].Split(',')

        # Fix for the Tasks name not matching the UI.
        $roles += @('Tasks.Read.All', 'Tasks.ReadWrite.All')
        $delegated = $data.Content.Split('|')[1].Split(',')
    }

     It "Permissions used in settings.json file for '<ResourceName>' should exist" -TestCases $settingsFiles {
        $json = Get-Content -Path $FullName -Raw
        $settings = ConvertFrom-Json -InputObject $json
        foreach ($permission in $settings.permissions.graph.application.read)
        {
            # Only validate non-GUID (hidden) permissions.
            $ObjectGuid = [System.Guid]::empty
            # There is an issue where the GUI shows Tasks.Read.All but the OAuth value is actually Tasks.Read
            if (-not [System.Guid]::TryParse($permission.Name  ,[System.Management.Automation.PSReference]$ObjectGuid) -and
                $permission.Name -ne 'Tasks.Read.All')
            {
                $permission.Name | Should -BeIn $roles
            }
        }
    }
}
