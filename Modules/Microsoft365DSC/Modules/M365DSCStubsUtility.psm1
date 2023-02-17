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
        $PSBoundParameters.Add('Credential', $Credential)
    }

    if (Test-Path $DestinationFilePath)
    {
        $answer = $null
        do
        {
            $answer = Read-Host 'A file already exists at the specified location. Remove it? (y/n)'
        } while ($answer -ne 'y' -and $answer -ne 'n')

        if ($answer -eq 'y')
        {
            Remove-Item -Path $DestinationFilePath -Confirm:$false
        }
    }

    $Content = ''
    $folderPath = Join-Path $PSScriptRoot -ChildPath '../DSCResources'
    Write-Host $FolderPath
    $workloads = @(
        @{Name = 'ExchangeOnline'; ModuleName = 'ExchangeOnlineManagement'; CommandName = 'Get-Mailbox' },
        @{Name = 'MicrosoftGraph'; ModuleName = 'Microsoft.Graph.Applications'; },
        @{Name = 'MicrosoftGraph'; ModuleName = 'Microsoft.Graph.Authentication'; },
        @{Name = 'MicrosoftGraph'; ModuleName = 'Microsoft.Graph.Beta.DeviceManagement'; },
        @{Name = 'MicrosoftGraph'; ModuleName = 'Microsoft.Graph.Beta.Devices.CorporateManagement'; },
        @{Name = 'MicrosoftGraph'; ModuleName = 'Microsoft.Graph.Beta.Identity.DirectoryManagement'; },
        @{Name = 'MicrosoftGraph'; ModuleName = 'Microsoft.Graph.Beta.Identity.Governance'; },
        @{Name = 'MicrosoftGraph'; ModuleName = 'Microsoft.Graph.DeviceManagement.Administration'; },
        @{Name = 'MicrosoftGraph'; ModuleName = 'Microsoft.Graph.DeviceManagement.Enrollment'; },
        @{Name = 'MicrosoftGraph'; ModuleName = 'Microsoft.Graph.Groups'; },
        @{Name = 'MicrosoftGraph'; ModuleName = 'Microsoft.Graph.Identity.DirectoryManagement'; },
        @{Name = 'MicrosoftGraph'; ModuleName = 'Microsoft.Graph.Identity.Governance'; },
        @{Name = 'MicrosoftGraph'; ModuleName = 'Microsoft.Graph.Identity.SignIns'; },
        @{Name = 'MicrosoftGraph'; ModuleName = 'Microsoft.Graph.Planner'; },
        @{Name = 'MicrosoftGraph'; ModuleName = 'Microsoft.Graph.Teams'; },
        @{Name = 'MicrosoftGraph'; ModuleName = 'Microsoft.Graph.Users'; },
        @{Name = 'MicrosoftGraph'; ModuleName = 'Microsoft.Graph.Users.Actions';},
        @{Name = 'SecurityComplianceCenter'; ModuleName = 'ExchangeOnlineManagement'; CommandName = 'Get-Label' },
        @{Name = 'PnP'; ModuleName = 'PnP.PowerShell'; },
        @{Name = 'PowerPlatforms'; ModuleName = 'Microsoft.PowerApps.Administration.PowerShell'; },
        @{Name = 'MicrosoftTeams'; ModuleName = 'MicrosoftTeams'; }
    )
    foreach ($Module in $workloads)
    {
        Write-Host "Connecting to {$($Module.Name)}"
        $ConnectionMode = New-M365DSCConnection -Workload ($Module.Name) `
            -InboundParameters $PSBoundParameters

        Write-Host "Generating Stubs for {$($Module.ModuleName)}..."
        $CurrentModuleName = $Module.ModuleName

        if ($null -eq $CurrentModuleName -or $Module.CommandName)
        {
            Write-Host "Loading proxy for $($Module.ModuleName)"
            $foundModule = Get-Module | Where-Object -FilterScript { $_.ExportedCommands.Values.Name -ccontains $Module.CommandName }
            $CurrentModuleName = $foundModule.Name
            Import-Module $CurrentModuleName -Force -Global -ErrorAction SilentlyContinue
        }
        else
        {
            Import-Module $CurrentModuleName -Force -Global -ErrorAction SilentlyContinue
            $ConnectionMode = New-M365DSCConnection -Workload $Module.Name `
                -InboundParameters $PSBoundParameters
        }

        $cmdlets = Get-Command -CommandType 'Cmdlet' | Where-Object -FilterScript { $_.Source -eq $CurrentModuleName }
        if ($null -eq $cmdlets -or $Module.ModuleName -eq 'MicrosoftTeams')
        {
            $cmdlets += Get-Command -CommandType 'Function' -Module $CurrentModuleName
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
            Write-Progress -Activity 'Generating Stubs' -Status $cmdlet.Name -PercentComplete (($i / $cmdlets.Length) * 100)
            $foundInFiles = Get-ChildItem -Path $folderPath `
                -Recurse | Select-String -Pattern $cmdlet.Name

            if ($null -eq $foundInFiles)
            {
                Write-Verbose -Message "No references found for $($cmdlet.Name)"
            }
            else
            {
                Write-Host $cmdlet

                try
                {
                    $metadata = New-Object -TypeName System.Management.Automation.CommandMetaData -ArgumentList $cmdlet
                    $parameters = $metadata.Parameters
                }
                catch
                {
                    Write-Verbose -Message $_
                }

                $invalidParameters = @('ErrorVariable', `
                        'ErrorAction', `
                        'InformationVariable', `
                        'InformationAction', `
                        'WarningVariable', `
                        'WarningAction', `
                        'OutVariable', `
                        'OutBuffer', `
                        'PipelineVariable', `
                        'Verbose', `
                        'WhatIf', `
                        'Debug')

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
                $invalidTypes = @('ActionPreference')

                $foundParamNames = @()
                foreach ($key in $parameters.Keys)
                {
                    Write-Verbose -Message "    --> $($parameters.$key.Name)"
                    if ($foundParamNames -notcontains $parameters.$key.Name)
                    {
                        $foundParamNames += $parameters.$key.Name
                        if ($parameters.$key.ParameterType.Name -notin $invalidTypes -and `
                        $parameters.$key.Name -notin $invalidParameters -and `
                                -not [System.String]::IsNullOrEmpty($parameters.$key.Name))
                        {
                            $StubContent += "        [Parameter()]`r`n"
                            $ParamType = $parameters.$key.ParameterType.ToString()
                            if ($ParamType -eq 'System.Collections.Generic.List`1[System.String]')
                            {
                                $ParamType = 'System.String[]'
                            }
                            elseif ($ParamType -eq 'System.Nullable`1[System.Boolean]')
                            {
                                $ParamType = 'System.Boolean'
                            }
                            elseif ($ParamType.StartsWith("System.Collections.Generic.List``1[Microsoft.Open.MSGraph.Model."))
                            {
                                $ParamType = 'System.Object[]'
                            }
                            elseif ($ParamType.StartsWith('Microsoft.Graph.PowerShell.') -or $ParamType.StartsWith('Microsoft.Graph.Beta.PowerShell.'))
                            {
                                $ParamType = 'PSObject'
                            }
                            elseif ($ParamType.StartsWith('Microsoft.Teams.'))
                            {
                                $ParamType = 'PSObject'
                            }
                            elseif ($ParamType.StartsWith('Microsoft.Rtc.'))
                            {
                                $ParamType = 'PSObject'
                            }
                            $StubContent += "        [$ParamType]`r`n"
                            $StubContent += "        `$$($parameters.$key.Name),`r`n`r`n"
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
            }
            $i ++
        }
        Write-Progress -Activity 'Generating Stubs' -Completed

        $Content += "#region $($Module.Name)`r`n"

        $TypesToConvert = @('Microsoft.Online.SharePoint.PowerShell.SpoHubSitePipeBind', `
                'Microsoft.Online.SharePoint.PowerShell.SpoSitePipeBind'
        )

        foreach ($type in $TypesToConvert)
        {
            $StubContent = $StubContent.Replace($type, 'Object')
        }
        $Content += $StubContent
        $Content += "#endregion`r`n"
        $i++
        Remove-Module $CurrentModuleName
    }
    $Content | Out-File $DestinationFilePath -Encoding utf8
}

Export-ModuleMember -Function @(
    'New-M365DSCStubFiles'
)
