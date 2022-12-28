<#
.Description
    This function checks if properties of existing resources are up to date.
    Creates a report about missing or outdated properties of existing resources
    and a list of missing resources.

.Functionality
    Internal
#>

function Get-PropertyReport
{
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DestinationFolder,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    # list of cmdlet parameters to be ignored
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
            'Debug',
        'Confirm',
        'AsJob')

    # list of M365 DSC resource properties to be ignored
    $invalidProperties = @('ErrorVariable', `
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
            'Debug',
        'Credential',
        'ApplicationId',
        'Ensure',
        'TenantId',
        'CertificateThumbprint',
        'CertificatePath',
        'CertificatePassword',
        'IsSingleInstance')

    # list of M365 workloads to check
    $workloads = @(
        @{Name = 'ExchangeOnline'; ModuleName = 'ExchangeOnlineManagement'; CommandName = 'Get-Mailbox'; Prefix = 'EXO'; }
        @{Name = 'MicrosoftTeams'; ModuleName = 'MicrosoftTeams'; Prefix = 'Teams'; }
        @{Name = 'SecurityComplianceCenter'; ModuleName = 'ExchangeOnlineManagement'; CommandName = 'Set-ComplianceCase'; Prefix = 'SC'; }
    )

    # mapping table for resources with names different from cmdlet name
    $cmdletMapping = @{
        CasMailbox                   = 'CASMailboxSettings'
        Mailbox                      = 'SharedMailbox'
        MailboxRegionalConfiguration = 'MailboxSettings'
        EXOPerimeterConfig           = 'PerimeterConfiguration'
    }

    $missingResources = @()
    $report = @()

    if ($null -eq $Credential)
    {
        $Credential = Get-Credential
        $PSBoundParameters.Add('Credential', $Credential)
    }

    $folderPath = Join-Path $PSScriptRoot -ChildPath '../DSCResources'
    Write-Verbose "Folderpath of DSC resources: $folderPath"

    foreach ($module in $workloads)
    {
        Write-Verbose "Connecting to {$($Module.Name)}"
        $ConnectionMode = New-M365DSCConnection -Workload ($Module.Name) -InboundParameters $PSBoundParameters

        Write-Verbose "Getting list of cmdlets of {$($Module.ModuleName)}..."
        $CurrentModuleName = $Module.ModuleName

        if ($null -eq $CurrentModuleName -or $Module.CommandName)
        {
            Write-Verbose "Loading proxy for $($Module.ModuleName)"
            $foundModule = Get-Module | Where-Object -FilterScript { $_.ExportedCommands.Values.Name -ccontains $Module.CommandName }
            $CurrentModuleName = $foundModule.Name
            Import-Module $CurrentModuleName -Force -Global -ErrorAction SilentlyContinue
        }
        else
        {
            Import-Module $CurrentModuleName -Force -Global -ErrorAction SilentlyContinue
            $ConnectionMode = New-M365DSCConnection -Workload $Module.Name -InboundParameters $PSBoundParameters
        }

        $cmdlets = Get-Command -CommandType 'Function' -Module $CurrentModuleName
        $setCmdlets = $cmdlets | Where-Object { $_.Name -like 'Set-*' }

        Write-Verbose "Found $($setCmdlets.Count) Set-* cmdlets for $($Module.ModuleName) ($($cmdlets.Count) in total)"

        $i = 1
        foreach ($cmdlet in $setCmdlets)
        {
            Write-Progress -Activity 'Checking resources' -Status $cmdlet.Name -PercentComplete (($i / $setCmdlets.Length) * 100)

            $resourceExists = $false
            $resourceName = 'MSFT_' + $module.Prefix + $cmdlet.Name.split('-')[1]

            if ($module.ModuleName -eq 'MicrosoftTeams' -and $resourceName -like '*TeamsCsTeams*')
            {
                $resourceName = $resourceName -replace ('TeamsCsTeams', 'Teams')
            }
            if ($module.ModuleName -eq 'MicrosoftTeams' -and $resourceName -like '*TeamsCs*')
            {
                $resourceName = $resourceName -replace ('TeamsCs', 'Teams')
            }
            $foundInFiles = Get-ChildItem -Path $folderPath | Where-Object { $_.Name -like $resourceName }

            if ($null -eq $foundInFiles)
            {
                $resourceNameFromMapping = $cmdletMapping[$cmdlet.Name.split('-')[1]]
                if ($null -ne $resourceNameFromMapping)
                {
                    $resourceName = 'MSFT_' + $module.Prefix + $resourceNameFromMapping
                    $foundInFiles = Get-ChildItem -Path $folderPath | Where-Object { $_.Name -like $resourceName }
                    if ($null -ne $foundInFiles)
                    {
                        $resourceExists = $true
                    }
                }
            }
            else
            {
                $resourceExists = $true
            }

            if ($resourceExists)
            {
                # Get parameter of cmdlet
                Write-Verbose "Get parameters of cmdlet $($cmdlet.Name)"
                $targetParameters = @()
                $resourceParamters = @()
                $cmdletParameters = (Get-Command $cmdlet.Name).Parameters

                foreach ($parameter in $cmdletParameters.Keys)
                {
                    if ($parameter -notin $invalidParameters)
                    {
                        $targetParameters += $parameter
                    }
                }

                # Get properties of DSC resource
                Write-Verbose "Get properties of resource $resourceName"
                Import-Module $($folderPath + '\' + $resourceName) -Force
                $resourceProperties = (Get-Command Set-TargetResource -Module $resourceName).Parameters

                foreach ($property in $resourceProperties.Keys)
                {
                    if ($property -notin $invalidProperties)
                    {
                        $resourceParamters += $property
                    }
                }
                Remove-Module -Name $resourceName -Force -Confirm:$false

                # Compare properties
                Write-Verbose "Compare parameters of $resourceName"
                $difference = Compare-Object -ReferenceObject @($targetParameters | Select-Object) -DifferenceObject @($resourceParamters | Select-Object) -IncludeEqual
                $missingProperties = ($difference | Where-Object { $_.SideIndicator -eq '<=' }).InputObject
                $addtionalProperties = ($difference | Where-Object { $_.SideIndicator -eq '=>' }).InputObject

                # Add to report
                $cmdletResult = [PSCustomObject]@{
                    'M365DSCResource'      = $resourceName
                    'Cmdlet'               = $cmdlet.Name
                    'Service'              = $module.Name
                    'MissingProperties'    = $missingProperties -join ('; ')
                    'AdditionalProperties' = $addtionalProperties -join ('; ')
                }
                $report += $cmdletResult
            }
            else
            {
                $missingResources += $resourceName
                Write-Verbose "Resource $resourceName not found."
            }
            $i++
        }
    }

    # Export reports
    Write-Verbose 'Export reports'
    $report | Export-Csv -NoTypeInformation -Path "$DestinationFolder\M365DSC-Properties-Report.csv" -Delimiter ','
    $missingResources | Out-File "$DestinationFolder\MissingDSCResources.csv"
}

Export-ModuleMember -Function @(
    'Get-PropertyReport'
)
