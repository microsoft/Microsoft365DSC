function Get-M365DSCCompiledPermissionList
{
    [CmdletBinding(DefaultParametersetName = 'None')]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true, Position = 0)]
        [System.String[]]
        $ResourceNameList
    )
    $results = @{
        UpdatePermissions = @()
        ReadPermissions   = @()
    }
    foreach ($resourceName in $ResourceNameList)
    {
        $settingsFilePath = $null
        try
        {
            $settingsFilePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_$resourceName\settings.json" `
                -Resolve `
                -ErrorAction Stop
        }
        catch
        {
            Write-Verbose -Message "File settings.json was not found for resource {$resourceName}"
        }

        if ($null -ne $settingsFilePath)
        {
            $fileContent = Get-Content $settingsFilePath -Raw
            $jsonContent = ConvertFrom-Json -InputObject $fileContent

            foreach ($updatePermission in $jsonContent.permissions.update)
            {
                if (-not $results.UpdatePermissions.Contains($updatePermission.name))
                {
                    Write-Verbose -Message "Found new Update permission {$($updatePermission.name)}"
                    $results.UpdatePermissions += $updatePermission.name
                }
                else
                {
                    Write-Verbose -Message "Update permission {$($updatePermission.name)} was already added"
                }
            }

            foreach ($readPermission in $jsonContent.permissions.read)
            {
                if (-not $results.UpdatePermissions.Contains($readPermission.name))
                {
                    Write-Verbose -Message "Found new Read permission {$($readPermission.name)}"
                    $results.ReadPermissions += $readPermission.name
                }
                else
                {
                    Write-Verbose -Message "Read permission {$($readPermission.name)} was already added"
                }
            }
        }
    }
    return $results
}
