function New-M365DSCStubFiles
{
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DestinationFilePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    if ($null -eq $GlobalAdminAccount)
    {
        $GlobalAdminAccount = Get-Credential
        $PSBoundParameters.Add("GlobalAdminAccount", $GlobalAdminAccount)
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

    $Modules = @(
        @{
            Platform     = 'AzureAD'
            ModuleName   = 'AzureADPreview'
            RandomCmdlet = 'Get-AzureADDirectorySetting'
        },
        @{
            Platform     = 'ExchangeOnline'
            ModuleName   = $null
            RandomCmdlet = 'Add-AvailabilityAddressSpace'
        },
        @{
            Platform   = 'Intune'
            ModuleName = "Microsoft.Graph.Intune"
        },
        @{
            Platform   = 'MicrosoftTeams'
            ModuleName = 'MicrosoftTeams'
        },
        @{
            Platform   = 'PnP'
            ModuleName = 'SharePointPnPPowerShellOnline'
        },
        @{
            Platform   = 'PowerPlatforms'
            ModuleName = 'Microsoft.PowerApps.Administration.PowerShell'
        },
        @{
            Platform     = 'SecurityComplianceCenter'
            ModuleName   = $null
            RandomCmdlet = 'Add-ComplianceCaseMember'
        },
        @{
            Platform     = 'SkypeForBusiness'
            ModuleName   = $null
            RandomCmdlet = 'Clear-CsOnlineTelephoneNumberReservation'
        }
    )
    $Content = ''
    foreach ($Module in $Modules)
    {
        Write-Host "Generating Stubs for {$($Module.Platform)}..."
        $CurrentModuleName = $Module.ModuleName
        if ($null -eq $CurrentModuleName)
        {
            $ConnectionMode = New-M365DSCConnection -Platform $Module.Platform `
                -InboundParameters $PSBoundParameters
            $foundModule = Get-Module | Where-Object -FilterScript { $_.ExportedCommands.Values.Name -ccontains $Module.RandomCmdlet }
            $CurrentModuleName = $foundModule.Name
        }
        else
        {
            Import-Module $CurrentModuleName -Force -ErrorAction SilentlyContinue
            $ConnectionMode = New-M365DSCConnection -Platform $Module.Platform `
                -InboundParameters $PSBoundParameters
        }

        $cmdlets = Get-Command -CommandType 'Cmdlet' | Where-Object -FilterScript { $_.Source -eq $CurrentModuleName }
        if ($null -eq $cmdlets)
        {
            $cmdlets = Get-Command -CommandType 'Function' | Where-Object -FilterScript { $_.Source -eq $CurrentModuleName }
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
                if (-not $parameters.ContainsKey($additionalParam) -and `
                        -not $invalidParameters.Contains($additionalParameter))
                {
                    $parameters += @{$additionalParam = $additionalParameters.$additionalParam }
                }
            }
            $StubContent += "function $($cmdlet.Name)`n{`r`n    [CmdletBinding()]`r`n    param(`r`n"
            $invalidTypes = @("ActionPreference")

            $foundParamNames = @()
            foreach ($param in $parameters.Values)
            {
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
