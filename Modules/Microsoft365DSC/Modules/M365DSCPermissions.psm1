using namespace System.Management.Automation.Language

<#
.Description
This function lists all Graph permissions required for the specified resources,
both for reading and updating.

.Parameter ResourceNameList
An array of resource names for which the permissions should be determined.

.Example
Get-M365DSCCompiledPermissionList -ResourceNameList @('O365User', 'AADApplication')

.Functionality
Public
#>
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
                if (-not $results.ReadPermissions.Contains($readPermission.name))
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

<#
.Description
This function updates the required permissions in the Graph API for the specified resources and type

.Parameter ResourceNameList
An array of resource names for which the permissions should be determined.

.Parameter All
Specifies that the permissions should be determined for all resources.

.Parameter Type
For which action should the permissions be updated: Read or Update.

.Example
Update-M365DSCAllowedGraphScopes -ResourceNameList @('O365User', 'AADApplication') -Type 'Read'

.Example
Update-M365DSCAllowedGraphScopes -All -Type 'Update' -Environment 'Global'

.Functionality
Public
#>
function Update-M365DSCAllowedGraphScopes
{
    [CmdletBinding()]
    [OutputType()]
    param
    (
        [Parameter()]
        [System.String[]]
        $ResourceNameList,

        [Parameter()]
        [Switch]
        $All,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Read', 'Update')]
        [System.String]
        $Type,

        [Parameter()]
        [ValidateSet('Global', 'China', 'USGov', 'USGovDoD', 'Germany')]
        [System.String]
        $Environment = 'Global'
    )

    if ($All)
    {
        Write-Verbose -Message 'All parameter specified'
        $dscResourcesRoot = Join-Path -Path $PSScriptRoot -ChildPath '..\DSCResources'
        $resourceNames = (Get-ChildItem -Path $dscResourcesRoot -Directory).Name -replace "MSFT_", ''
        $permissions = Get-M365DSCCompiledPermissionList -ResourceNameList $resourceNames
    }
    else
    {
        if ($PSBoundParameters.ContainsKey('ResourceNameList') -eq $false)
        {
            throw "You have to specify either the All or ResourceNameList parameter!"
        }

        Write-Verbose -Message "Specified resources: $($ResourceNameList -join ", ")"
        $permissions = Get-M365DSCCompiledPermissionList -ResourceNameList $ResourceNameList
    }

    if ($Type -eq 'Read')
    {
        Write-Verbose -Message 'Specified type: Read'
        Write-Verbose -Message "Found permissions: $($permissions.ReadPermissions -join ", ")"
        $params = @{
            Scopes = $permissions.ReadPermissions
        }
    }
    else
    {
        Write-Verbose -Message 'Specified type: Update'
        Write-Verbose -Message "Found permissions: $($permissions.UpdatePermissions -join ", ")"
        $params = @{
            Scopes = $permissions.UpdatePermissions
        }
    }

    Write-Verbose -Message 'Connecting to MS Graph to update permissions'
    $result = Connect-MgGraph @params -Environment $Environment
    if ($result -eq 'Welcome To Microsoft Graph!')
    {
        Write-Output 'Allowed Graph scopes updated!'
    }
    else
    {
        Write-Output 'Error during updating allowed Graph scopes!'
    }
}

<#
.Description
This function updates the settings.json files for all resources that use Graph cmdlets.
It is compiling a permissions list based on all used Graph cmdlets in the resource and
retrieving the permissions for these cmdlets from the Graph. Then it updates the
settings.json file

.Example
Update-M365DSCResourcesSettingsJSON

.Functionality
Public
#>
function Update-M365DSCResourcesSettingsJSON
{
    [CmdletBinding()]
    param()

    Write-Verbose "Determining DSCResources path"
    $dscResourcesRoot = Join-Path -Path $PSScriptRoot -ChildPath '..\DSCResources'
    Write-Verbose "  DSCResouces path: $dscResourcesRoot"

    Write-Verbose "Getting all psm1 files"
    $files = Get-ChildItem -Path "$dscResourcesRoot\*.psm1" -Recurse
    Write-Verbose "  Found $($files.Count) psm1 files"

    foreach ($file in $files)
    {
        $readPermissions = @()
        $updatePermissions = @()
        if ($file -notlike "*Intune*")
        {
            Write-Verbose "Processing file: $($file.BaseName)"
            $content = Get-Content $file -Raw

            $sb = [ScriptBlock]::Create($content)

            $functions = $sb.Ast.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $true)

            $functions = $functions | Where-Object { $_.Name -in ("Get-TargetResource", "Set-TargetResource") }

            foreach ($function in $functions)
            {
                Write-Verbose "  Function: $($function.Name)"

                $regex = [Regex]::new('(?<Cmdlet>(Update|Get|Remove|Set)-Mg\w*)')
                $regexMatches = $regex.Matches($function.Extent.Text)

                $cmdlets = $regexMatches.Value | Sort-Object | Select-Object -Unique

                $functionPermissions = @()
                foreach ($cmdlet in $cmdlets)
                {
                    $commands = Find-MgGraphCommand -Command $cmdlet

                    $cmdletPermissions = $commands[0].Permissions
                    $functionPermissions += $cmdletPermissions.Name
                }
                $cleanFunctionPermissions = $functionPermissions | Sort-Object | Select-Object -Unique

                if ($null -ne $cleanFunctionPermissions)
                {
                    switch ($function.Name)
                    {
                        "Get-TargetResource"
                        {
                            $readPermissions = @()
                            foreach ($item in $cleanFunctionPermissions)
                            {
                                $readPermissions += [PSCustomObject]@{
                                    name = $item
                                }
                            }
                        }
                        "Set-TargetResource"
                        {
                            $updatePermissions = @()
                            foreach ($item in $cleanFunctionPermissions)
                            {
                                $updatePermissions += [PSCustomObject]@{
                                    name = $item
                                }
                            }
                        }
                    }
                }
            }

            $settingsFile = Join-Path -Path $file.DirectoryName -ChildPath 'settings.json'
            if (Test-Path -Path $settingsFile)
            {
                Write-Verbose "  Updating existing settings.json file"
                $settingsJson = Get-Content -Path $settingsFile -Raw
                $settings = ConvertFrom-Json $settingsJson

                if ($readPermissions.Count -eq 0 -and $settings.permissions.read.Count -ne 0)
                {
                    [array]$readPermissions = $settings.permissions.read
                }

                if ($updatePermissions.Count -eq 0 -and $settings.permissions.update.Count -ne 0)
                {
                    [array]$updatePermissions = $settings.permissions.update
                }

                $settings.permissions = @([PSCustomObject]@{
                        read   = $readPermissions
                        update = $updatePermissions
                    })

            }
            else
            {
                Write-Verbose "    Creating new settings.json file"
                $settings = [PSCustomObject]@{
                    resourceName = $file.BaseName -replace 'MSFT_'
                    description  = ""
                    permissions  = @([PSCustomObject]@{
                            read   = $readPermissions
                            update = $updatePermissions
                        })
                }
            }
            $json = ConvertTo-Json -InputObject $settings -Depth 10
            Set-Content -Path $settingsFile -Value $json -Encoding UTF8
        }
        else
        {
            Write-Verbose "$($file.BaseName) - Skipping Intune resources (unable to process those Graph cmdlets)"
        }
    }
}

Export-ModuleMember -Function @(
    'Get-M365DSCCompiledPermissionList',
    'Update-M365DSCAllowedGraphScopes',
    'Update-M365DSCResourcesSettingsJSON'
)
