function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ResourceName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $RuleDefinition,

        [Parameter()]
        [System.String]
        $AfterRuleCountQuery,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity
    )
    return $null
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ResourceName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $RuleDefinition,

        [Parameter()]
        [System.String]
        $AfterRuleCountQuery,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity
    )
    # Not Implemented
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ResourceName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $RuleDefinition,

        [Parameter()]
        [System.String]
        $AfterRuleCountQuery,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity
    )
    #region Telemetry
    $CurrentResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $CurrentResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message 'Testing configuration of AzureAD Tenant Details'

    $Global:PartialExportFileName = "$((New-Guid).ToString()).partial"
    $module = Get-DSCResource -Module 'Microsoft365DSC' -Name $ResourceName
    if ($null -ne $module)
    {
        $params = @{
            Credential            = $PSBoundParameters.Credential
            ApplicationId         = $PSBoundParameters.ApplicationId
            TenantId              = $PSBoundParameters.TenantId
            CertificateThumbprint = $PSBoundParameters.CertificateThumbprint
            ManagedIdentity       = $PSBoundParameters.ManagedIdentity
        }

        if ($null -ne $PSBoundParameters.ApplicationSecret)
        {
            $params.Add("ApplicationSecret", $PSBoundParameters.ApplicationSecret)
        }

        Write-Verbose -Message "Importing module from Path {$($module.Path)}"
        Import-Module $module.Path -Force -Function 'Export-TargetResource' | Out-Null
        $cmdName = "MSFT_$ResourceName\Export-TargetResource"

        [Array]$instances = &$cmdName @params

        $DSCStringContent = @"
        # Generated with Microsoft365DSC version 1.23.906.1
        # For additional information on how to use Microsoft365DSC, please visit https://aka.ms/M365DSC
        param (
        )

        Configuration M365TenantConfig
        {
            param (
            )

            $OrganizationName = $ConfigurationData.NonNodeData.OrganizationName

            Import-DscResource -ModuleName 'Microsoft365DSC'

            Node localhost
            {
                $instances
            }
        }

        M365TenantConfig -ConfigurationData .\ConfigurationData.psd1
"@
        Write-Verbose -Message "Converting the retrieved instances into DSC Objects"
        $DSCConvertedInstances = ConvertTo-DSCObject -Content $DSCStringContent
        Write-Verbose -Message "Successfully converted {$($DSCConvertedInstances.Length)} DSC Objects."

        Write-Verbose -Message "Querying DSC Objects for invalid instances based on the specified Rule Definition."
        if ($RuleDefinition -eq '*')
        {
            [Array]$instances = $DSCConvertedInstances
            Write-Verbose -Message "Identified {$($instances.Length)} instances matching rule."
        }
        else
        {
            $queryBlock = [Scriptblock]::Create($RuleDefinition)
            [Array]$instances = $DSCConvertedInstances | Where-Object -FilterScript $queryBlock
            Write-Verbose -Message "Identified {$($instances.Length)} instances matching rule."
        }

        $result = ($instances.Length -$DSCConvertedInstances.Length) -eq 0

        if (-not [System.String]::IsNullOrEmpty($AfterRuleCountQuery))
        {
            Write-Verbose -Message "Checking the After Rule Count"
            $afterRuleCountQueryString = "`$instances.Length $AfterRuleCountQuery"
            $afterRuleCountQueryBlock = [Scriptblock]::Create($afterRuleCountQueryString)
            $result = [Boolean](Invoke-Command -ScriptBlock $afterRuleCountQueryBlock)
            $message = [System.Text.StringBuilder]::New()
            if ($instances.Length -eq 0)
            {
                [void]$message.AppendLine("No instances were found for the given Rule Definition.")
            }
            elseif (-not $result)
            {
                $invalidInstancesLogNames = ''
                foreach ($invalidInstance in $instances)
                {
                    $invalidInstancesLogNames += "[$ResourceName]$($invalidInstance.ResourceInstanceName)`r`n"
                }

                [void]$message.AppendLine("The following resource instance(s) failed a rule validation:`r`n$invalidInstancesLogNames")
                [void]$message.AppendLine("`r`nRuleDefinition:`r`n$RuleDefinition")
                [void]$message.AppendLine("`r`AfterRuleCountQuery:`r`n$AfterRuleCountQuery")
                Add-M365DSCEvent -Message $message.ToString() `
                            -EventType 'RuleEvaluation' `
                            -EntryType 'Warning' `
                            -EventID 1 -Source $CurrentResourceName
            }
        }
        elseif (-not $result)
        {
            $invalidInstances = Compare-Object -ReferenceObject $DSCConvertedInstances.ResourceInstanceName -DifferenceObject $instances.ResourceInstanceName
            # Log drifts for each invalid instances found.
            $invalidInstancesLogNames = ''
            foreach ($invalidInstance in $invalidInstances)
            {
                $invalidInstancesLogNames += "[$ResourceName]$($invalidInstance.InputObject)`r`n"
            }

            if (-not $result)
            {
                $message = [System.Text.StringBuilder]::New()
                [void]$message.AppendLine("The following resource instance(s) failed a rule validation:`r`n$invalidInstancesLogNames")
                [void]$message.AppendLine("`r`nRuleDefinition:`r`n$RuleDefinition")
                Add-M365DSCEvent -Message $message.ToString() `
                        -EventType 'RuleEvaluation' `
                        -EntryType 'Warning' `
                        -EventID 1 -Source $CurrentResourceName
            }
        }
        Write-Verbose -Message "Test-TargetResource returned $result"
        return $result
    }
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity
    )
    Write-Host "`r`n" -NoNewline
    return $null
}


Export-ModuleMember -Function *-TargetResource
