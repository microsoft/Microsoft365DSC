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

Describe -Name 'Successfully validate all used permissions in Settings.json files ' {
    BeforeAll {
        $allModules = Get-module Microsoft.graph.* -ListAvailable
        $allPermissions = @()
        foreach ($module in $allModules)
        {
            $cmds = Get-Command -Module $module.Name
            foreach ($cmd in $cmds)
            {
                $graphInfo = Find-MgGraphCommand -Command $cmd.Name -ErrorAction SilentlyContinue
                if ($null -ne $graphInfo)
                {
                    $permissions = $graphInfo.Permissions | Where-Object -FilterScript {$_.PermissionType -eq 'Application'}
                    $allPermissions += $permissions.Name
                }
            }
        }

        $allPermissions+= @('OrgSettings-Microsoft365Install.Read.All', `
                            'OrgSettings-Forms.Read.All', `
                            'OrgSettings-Todo.Read.All', `
                            'OrgSettings-AppsAndServices.Read.All', `
                            'OrgSettings-DynamicsVoice.Read.All', `
                            'ReportSettings.Read.All', `
                            'RoleManagementPolicy.Read.Directory', `
                            'RoleEligibilitySchedule.Read.Directory', `
                            'Agreement.Read.All')
        $roles = $allPermissions | Select-Object -Unique | Sort-Object -Descending:$false
    }

    It "Permissions used in settings.json file for '<ResourceName>' should exist" -TestCases $settingsFiles {
        $json = Get-Content -Path $FullName -Raw
        $settings = ConvertFrom-Json -InputObject $json
        foreach ($permission in $settings.permissions.graph.application.read)
        {
            # Only validate non-GUID (hidden) permissions.
            $ObjectGuid = [System.Guid]::empty
            # There is an issue where the GUI shows Tasks.Read.All but the OAuth value is actually Tasks.Read
            if (-not [System.Guid]::TryParse($permission.Name  , [System.Management.Automation.PSReference]$ObjectGuid) -and
                $permission.Name -ne 'Tasks.Read.All')
            {
                $permission.Name | Should -BeIn $roles -ErrorAction Continue
            }
        }
        foreach ($permission in $settings.permissions.graph.application.write)
        {
            # Only validate non-GUID (hidden) permissions.
            $ObjectGuid = [System.Guid]::empty
            if (-not [System.Guid]::TryParse($permission.Name  , [System.Management.Automation.PSReference]$ObjectGuid))
            {
                $permission.Name | Should -BeIn $roles -ErrorAction Continue
            }
        }
    }

    It "Should use the least permissions for '<ResourceName>'" -TestCase $settingsFiles {
        $json = Get-Content -Path $FullName -Raw
        $settings = ConvertFrom-Json -InputObject $json

        $allowedPermissions = @()

        if ($settings.ResourceName -like 'Teams*')
        {
            $allowedPermissions = @(
                'Organization.Read.All',
                'User.Read.All',
                'Group.ReadWrite.All',
                'AppCatalog.ReadWrite.All',
                'TeamSettings.ReadWrite.All',
                'Channel.Delete.All',
                'ChannelSettings.ReadWrite.All',
                'ChannelMember.ReadWrite.All'
            )
        }

        if ($settings.ResourceName -like 'AADAuthenticationMethod*' -or $settings.ResourceName -eq 'AADAuthenticationStrengthPolicy')
        {
            $allowedPermissions = @(
                'Policy.ReadWrite.AuthenticationMethod'
            )
        }

        if ($settings.ResourceName -eq 'O365OrgSettings')
        {
            $allowedPermissions = @(
                'Application.ReadWrite.All'
            )
        }

        foreach ($permission in $settings.permissions.graph.application.read)
        {
            $ObjectGuid = [System.Guid]::empty
            # There is an issue where the GUI shows Tasks.Read.All but the OAuth value is actually Tasks.Read
            if (-not [System.Guid]::TryParse($permission.Name  , [System.Management.Automation.PSReference]$ObjectGuid) -and
                $permission.Name -ne 'Tasks.Read.All' -and -not ($permission.Name -in $allowedPermissions))
            {
                $permission.Name | Should -BeLike '*.Read.*' -ErrorAction Continue
            }
        }
    }
}
