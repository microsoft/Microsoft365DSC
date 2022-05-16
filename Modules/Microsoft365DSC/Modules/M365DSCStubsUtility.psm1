<#
.Description
This function creates new stub files for all used M365 module dependencies

.Functionality
Internal
#>
function New-M365DSCStubFiles
{
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DestinationFilePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    if ($null -eq $Credential)
    {
        $Credential = Get-Credential
        $PSBoundParameters.Add("Credential", $Credential)
    }

    if (Test-Path $DestinationFilePath)
    {
        $answer = $null
        do
        {
            $answer = Read-Host "A file already exists at the specified location. Remove it? (y/n)"
        } while ($answer -ne 'y' -and $answer -ne 'n')

        if ($answer -eq 'y')
        {
            Remove-Item -Path $DestinationFilePath -Confirm:$false
        }
    }

    $currentPath = Join-Path -Path $PSScriptRoot -ChildPath '..\' -Resolve
    $manifest = Import-PowerShellDataFile "$currentPath/Microsoft365DSC.psd1"
    $dependencies = $manifest.RequiredModules
    $Content = ''
    $folderPath = Join-Path $PSScriptRoot -ChildPath "../DSCResources"
    Write-Host $FolderPath
    $workloads = @('ExchangeOnline', 'SecurityComplianceCenter', 'PnP', 'PowerPlatforms', 'MicrosoftTeams', 'MicrosoftGraph')
    foreach ($workload in $workloads)
    {
        $ConnectionMode = New-M365DSCConnection -Workload $workload `
            -InboundParameters $PSBoundParameters
    }
    foreach ($Module in $dependencies.ModuleName)
    {
        Write-Host "Generating Stubs for {$($Module.Platform)}..."
        $CurrentModuleName = $Module.ModuleName
        if ($null -eq $CurrentModuleName)
        {
            $foundModule = Get-Module | Where-Object -FilterScript { $_.ExportedCommands.Values.Name -ccontains $Module.RandomCmdlet }
            $CurrentModuleName = $foundModule.Name
            Import-Module $CurrentModuleName -Force -Global -ErrorAction SilentlyContinue
        }
        else
        {
            Import-Module $CurrentModuleName -Force -Global -ErrorAction SilentlyContinue
            $ConnectionMode = New-M365DSCConnection -Workload $Module.Platform `
                -InboundParameters $PSBoundParameters
        }

        $cmdlets = Get-Command -CommandType 'Cmdlet' | Where-Object -FilterScript { $_.Source -eq $CurrentModuleName }
        if ($null -eq $cmdlets -or $Module.ModuleName -eq 'MicrosoftTeams')
        {
            $cmdlets += Get-Command -CommandType 'Function' | Where-Object -FilterScript { $_.Source -eq $CurrentModuleName }
        }

        if ($CurrentModuleName -eq 'Intune')
        {
            $MaximumFunctionCount = 32000
            Select-MgProfile -Name beta | Out-Null
            $betaCmdlets = Get-Command -CommandType 'Cmdlet' | Where-Object -FilterScript { $_.Source -eq $CurrentModuleName }
            foreach ($cmdlet in $betaCmdlets)
            {
                if ($cmdlets.Name -notcontains $cmdlet.Name)
                {
                    $cmdlets += $cmdlet
                }
            }
        }

        try
        {
            $aliases = Get-Command -CommandType 'Alias' | Where-Object -FilterScript { $_.Source -eq $CurrentModuleName }
            $cmdlets += $aliases
            $cmdlets = $cmdlets | Select-Object -Unique
        }
        catch
        {
            Write-Verbose -Message $_
        }
        $StubContent = ''
        $i = 1
        foreach ($cmdlet in $cmdlets)
        {
            $foundInFiles = Get-ChildItem -Path $folderPath `
                -Recurse | Select-String -Pattern $cmdlet.Name

            if ($null -eq $foundInFiles)
            {
                Write-Host "No references found for $($cmdlet.Name)"
            }
            else
            {
                Write-Host $cmdlet
                Write-Progress -Activity "Generating Stubs" -Status $cmdlet.Name -PercentComplete (($i / $cmdlets.Length) * 100)

                try
                {
                    $metadata = New-Object -TypeName System.Management.Automation.CommandMetaData -ArgumentList $cmdlet
                    $parameters = $metadata.Parameters
                }
                catch
                {
                    Write-Verbose -Message $_
                }

                $invalidParameters = @("ErrorVariable", `
                        "ErrorAction", `
                        "InformationVariable", `
                        "InformationAction", `
                        "WarningVariable", `
                        "WarningAction", `
                        "OutVariable", `
                        "OutBuffer", `
                        "PipelineVariable", `
                        "Verbose", `
                        "WhatIf", `
                        "Debug")

                $additionalParameters = (Get-Command $cmdlet.Name).Parameters

                foreach ($additionalParam in $additionalParameters.Keys)
                {
                    if ($null -eq $parameters -or
                        (-not $parameters.ContainsKey($additionalParam) -and `
                            -not $invalidParameters.Contains($additionalParameter)))
                    {
                        $parameters += @{$additionalParam = $additionalParameters.$additionalParam }
                    }
                }
                $StubContent += "function $($cmdlet.Name)`n{`r`n    [CmdletBinding()]`r`n    param(`r`n"
                $invalidTypes = @("ActionPreference")

                $foundParamNames = @()
                foreach ($param in $parameters.Values)
                {
                    Write-Host "    --> $($param.Name)"
                    if ($foundParamNames -notcontains $param.Name)
                    {
                        $foundParamNames += $param.Name
                        if ($param.ParameterType.Name -notin $invalidTypes -and `
                                $param.Name -notin $invalidParameters -and `
                                -not [System.String]::IsNullOrEmpty($param.Name))
                        {
                            $StubContent += "        [Parameter()]`r`n"
                            $ParamType = $param.ParameterType.ToString()
                            if ($ParamType -eq 'System.Collections.Generic.List`1[System.String]')
                            {
                                $ParamType = "System.String[]"
                            }
                            elseif ($ParamType -eq 'System.Nullable`1[System.Boolean]')
                            {
                                $ParamType = "System.Boolean"
                            }
                            elseif ($ParamType.StartsWith("System.Collections.Generic.List``1[Microsoft.Open.MSGraph.Model."))
                            {
                                $ParamType = "System.Object[]"
                            }
                            $StubContent += "        [$ParamType]`r`n"
                            $StubContent += "        `$$($param.Name),`r`n`r`n"
                        }
                    }
                }
                if ($parameters.Values.Count -gt 0)
                {
                    $endOfString = $StubContent.SubString($StubContent.Length - 5, 5)
                    if ($endOfString -eq ",`r`n`r`n")
                    {
                        $StubContent = $StubContent.Remove($StubContent.Length - 5, 5)
                    }
                }
                $StubContent += "`r`n    )`r`n}`n"
                $i ++
            }
        }
        Write-Progress -Activity "Generating Stubs" -Completed

        $Content += "#region $($Module.Platform)`r`n"

        $TypesToConvert = @('Microsoft.Online.SharePoint.PowerShell.SpoHubSitePipeBind', `
                'Microsoft.Online.SharePoint.PowerShell.SpoSitePipeBind'
        )

        foreach ($type in $TypesToConvert)
        {
            $StubContent = $StubContent.Replace($type, 'Object')
        }
        $Content += $StubContent
        $Content += "#endregion`r`n"
        Write-Host "Done" -ForegroundColor Green
    }
    $Content | Out-File $DestinationFilePath -Encoding utf8
}

Export-ModuleMember -Function @(
    'New-M365DSCStubFiles'
)
