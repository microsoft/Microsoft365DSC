function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateLength(1, 50)]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $TeamName,

        [Parameter()]
        [System.String]
        $GroupID,

        [Parameter()]
        [System.String]
        [ValidateLength(0, 50)]
        $NewDisplayName,

        [Parameter()]
        [System.String]
        [ValidateLength(1, 1024)]
        $Description,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

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
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Getting configuration of Teams channel $DisplayName"

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'
    Write-Verbose -Message 'Checking for existance of team channels'

    try
    {
        if (-not [System.String]::IsNullOrEmpty($GroupId))
        {
            $team = Get-Team -GroupId $GroupId -ErrorAction 'SilentlyContinue'
        }

        if ($null -eq $team)
        {
            $team = Get-TeamByName ([System.Net.WebUtility]::UrlEncode($TeamName))
        }

        if ($null -eq $team)
        {
            return $nullReturn
        }

        Write-Verbose -Message "Retrieve team GroupId: $($team.GroupId)"

        $channel = Get-TeamChannel -GroupId $team.GroupId `
            -ErrorAction SilentlyContinue `
        | Where-Object -FilterScript {
            ($_.DisplayName -eq $DisplayName)
        }

        #Current channel doesnt exist and trying to rename throw an error
        if (($null -eq $channel) -and $PSBoundParameters.ContainsKey('NewDisplayName'))
        {
            Write-Verbose -Message "Cannot rename channel $DisplayName , doesnt exist in current Team"
            throw "Channel named $DisplayName doesn't exist in current Team"
        }

        if ($null -eq $channel)
        {
            Write-Verbose -Message "Failed to get team channels with ID $($team.GroupId) and display name of $DisplayName"
            return $nullReturn
        }

        $results = @{
            DisplayName           = $channel.DisplayName
            TeamName              = $team.DisplayName
            GroupId               = $team.GroupId
            Description           = $channel.Description
            Ensure                = 'Present'
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            Credential            = $Credential
        }

        if ($NewDisplayName)
        {
            $results.Add('NewDisplayName', $NewDisplayName)
        }
        return $results
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $nullReturn
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateLength(1, 50)]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $TeamName,

        [Parameter()]
        [System.String]
        $GroupID,

        [Parameter()]
        [System.String]
        [ValidateLength(0, 50)]
        $NewDisplayName,

        [Parameter()]
        [System.String]
        [ValidateLength(1, 1024)]
        $Description,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

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
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Setting configuration of Teams channel $DisplayName"

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $channel = Get-TargetResource @PSBoundParameters

    $CurrentParameters = $PSBoundParameters

    $team = Get-TeamByName ([System.Net.WebUtility]::UrlEncode($TeamName))

    if ($team.Length -gt 1)
    {
        throw "Multiple Teams with name {$($TeamName)} were found"
    }
    Write-Verbose -Message "Retrieve team GroupId: $($team.GroupId)"

    $CurrentParameters.Remove('TeamName') | Out-Null
    $CurrentParameters.Remove('Credential') | Out-Null
    $CurrentParameters.Remove('ApplicationId') | Out-Null
    $CurrentParameters.Remove('TenantId') | Out-Null
    $CurrentParameters.Remove('CertificateThumbprint') | Out-Null
    $CurrentParameters.Remove('Ensure') | Out-Null
    if ($CurrentParameters.ContainsKey('GroupId'))
    {
        $CurrentParameters.GroupId = $team.GroupId
    }
    else
    {
        $CurrentParameters.Add('GroupId', $team.GroupId)
    }

    if ($Ensure -eq 'Present')
    {
        # Remap attribute from DisplayName to current display name for Set-TeamChannel cmdlet
        if ($channel.Ensure -eq 'Present')
        {
            if ($CurrentParameters.ContainsKey('NewDisplayName'))
            {
                Write-Verbose -Message "Updating team channel to new channel name $NewDisplayName"
                $CurrentParameters.Remove('DisplayName') | Out-Null
                Set-TeamChannel @CurrentParameters -CurrentDisplayName $DisplayName
            }
        }
        else
        {
            if ($CurrentParameters.ContainsKey('NewDisplayName'))
            {
                $CurrentParameters.Remove('NewDisplayName')
            }
            Write-Verbose -Message "Creating team channel $DisplayName"
            Write-Verbose -Message "Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentParameters)"
            New-TeamChannel @CurrentParameters
        }
    }
    else
    {
        if ($channel.DisplayName)
        {
            Write-Verbose -Message "Removing team channel $DisplayName"
            Remove-TeamChannel -GroupId $team.GroupId -DisplayName $DisplayName
        }
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateLength(1, 50)]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $TeamName,

        [Parameter()]
        [System.String]
        $GroupID,

        [Parameter()]
        [System.String]
        [ValidateLength(0, 50)]
        $NewDisplayName,

        [Parameter()]
        [System.String]
        [ValidateLength(1, 1024)]
        $Description,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

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
        [System.String]
        $CertificateThumbprint
    )
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of Teams channel $DisplayName"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @('Ensure')

    Write-Verbose -Message "Test-TargetResource returned $TestResult"

    return $TestResult
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        $teams = Get-Team -ErrorAction Stop
        $j = 1
        $dscContent = ''
        Write-Host "`r`n" -NoNewline
        foreach ($team in $Teams)
        {
            if($null -ne $team.GroupId)
            {
                $channels = Get-TeamChannel -GroupId $team.GroupId
                $i = 1
                Write-Host "    |---[$j/$($Teams.Length)] Team {$($team.DisplayName)}"
                foreach ($channel in $channels)
                {
                    Write-Host "        |---[$i/$($channels.Length)] $($channel.DisplayName)" -NoNewline
                    $params = @{
                        TeamName              = $team.DisplayName
                        GroupId               = $team.GroupId
                        DisplayName           = $channel.DisplayName
                        ApplicationId         = $ApplicationId
                        TenantId              = $TenantId
                        CertificateThumbprint = $CertificateThumbprint
                        Credential            = $Credential
                    }
                    $Results = Get-TargetResource @Params
                    $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                        -Results $Results
                    $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                        -ConnectionMode $ConnectionMode `
                        -ModulePath $PSScriptRoot `
                        -Results $Results `
                        -Credential $Credential
                    $dscContent += $currentDSCBlock
                    Save-M365DSCPartialExport -Content $currentDSCBlock `
                        -FileName $Global:PartialExportFileName
                    $i++
                    Write-Host $Global:M365DSCEmojiGreenCheckMark
                }
            }
            else
            {
                Write-Host "    |---[$j/$($Teams.Length)] Team has no GroupId and will be skipped"
            }
            $j++
        }
        return $dscContent
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiRedX

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
