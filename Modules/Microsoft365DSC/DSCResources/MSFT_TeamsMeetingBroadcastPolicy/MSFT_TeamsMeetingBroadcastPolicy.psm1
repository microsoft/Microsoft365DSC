function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $AllowBroadcastScheduling,

        [Parameter()]
        [System.Boolean]
        $AllowBroadcastTranscription,

        [Parameter()]
        [System.String]
        [ValidateSet("Everyone", "EveryoneInCompany", "InvitedUsersInCompany", "EveryoneInCompanyAndExternal", "InvitedUsersInCompanyAndExternal")]
        $BroadcastAttendeeVisibilityMode,

        [Parameter()]
        [System.String]
        [ValidateSet("AlwaysEnabled", "AlwaysDisabled", "UserOverride")]
        $BroadcastRecordingMode,

        [Parameter()]
        [System.String]
        [ValidateSet("Present", "Absent")]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    Write-Verbose -Message "Getting configuration of Teams Meeting Broadcast Policy {$Identity}"

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"
    try
    {
        $config = Get-CsTeamsMeetingBroadcastPolicy -Identity $Identity `
            -ErrorAction SilentlyContinue
        if ($null -ne $config)
        {
            return @{
                Identity                        = $Identity
                AllowBroadcastScheduling        = $config.AllowBroadcastScheduling
                AllowBroadcastTranscription     = $config.AllowBroadcastTranscription
                BroadcastAttendeeVisibilityMode = $config.BroadcastAttendeeVisibilityMode
                BroadcastRecordingMode          = $config.BroadcastRecordingMode
                Ensure                          = 'Present'
                Credential              = $Credential
            }
        }
        return $nullReturn
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
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
        $Identity,

        [Parameter()]
        [System.Boolean]
        $AllowBroadcastScheduling,

        [Parameter()]
        [System.Boolean]
        $AllowBroadcastTranscription,

        [Parameter()]
        [System.String]
        [ValidateSet("Everyone", "EveryoneInCompany", "InvitedUsersInCompany", "EveryoneInCompanyAndExternal", "InvitedUsersInCompanyAndExternal")]
        $BroadcastAttendeeVisibilityMode,

        [Parameter()]
        [System.String]
        [ValidateSet("AlwaysEnabled", "AlwaysDisabled", "UserOverride")]
        $BroadcastRecordingMode,

        [Parameter()]
        [System.String]
        [ValidateSet("Present", "Absent")]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )
    Write-Verbose -Message "Setting configuration of Teams Meeting Broadcast Policy {$Identity}"

    # Check that at least one optional parameter is specified
    $inputValues = @()
    foreach ($item in $PSBoundParameters.Keys)
    {
        if (-not [System.String]::IsNullOrEmpty($PSBoundParameters.$item) -and $item -ne 'Credential' `
                -and $item -ne 'Identity' -and $item -ne 'Ensure')
        {
            $inputValues += $item
        }
    }

    if ($inputValues.Count -eq 0)
    {
        throw "You need to specify at least one optional parameter for the Set-TargetResource function" + `
            " of the [TeamsMeetingBroadcastPolicy] instance {$Identity}"
    }

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' `
        -InboundParameters $PSBoundParameters

    $SetParams = $PSBoundParameters
    $currentValues = Get-TargetResource @PSBoundParameters
    $SetParams.Remove("Credential") | Out-Null
    $SetParams.Remove("Ensure") | Out-Null

    if ($Ensure -eq 'Present' -and $currentValues.Ensure -eq 'Absent')
    {
        New-CSTeamsMeetingBroadcastPolicy @SetParams
    }
    elseif ($Ensure -eq 'Present' -and $currentValues.Ensure -eq 'Present')
    {
        Set-CSTeamsMeetingBroadcastPolicy @SetParams
    }
    elseif ($Ensure -eq 'Absent' -and $currentValues.Ensure -eq 'Present')
    {
        Remove-CSTeamsMeetingBroadcastPolicy -Identity $Identity -Confirm:$false
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
        $Identity,

        [Parameter()]
        [System.Boolean]
        $AllowBroadcastScheduling,

        [Parameter()]
        [System.Boolean]
        $AllowBroadcastTranscription,

        [Parameter()]
        [System.String]
        [ValidateSet("Everyone", "EveryoneInCompany", "InvitedUsersInCompany", "EveryoneInCompanyAndExternal", "InvitedUsersInCompanyAndExternal")]
        $BroadcastAttendeeVisibilityMode,

        [Parameter()]
        [System.String]
        [ValidateSet("AlwaysEnabled", "AlwaysDisabled", "UserOverride")]
        $BroadcastRecordingMode,

        [Parameter()]
        [System.String]
        [ValidateSet("Present", "Absent")]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of Teams Meeting Broadcast policies"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null
    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $TestResult"

    return $TestResult
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        [array]$policies = Get-CsTeamsMeetingBroadcastPolicy -ErrorAction Stop

        $i = 1
        $dscContent = ''
        Write-Host "`r`n" -NoNewline
        foreach ($policy in $policies)
        {
            $params = @{
                Identity           = $policy.Identity
                Credential = $Credential
            }
            Write-Host "    |---[$i/$($policies.Length)] $($policy.Identity)" -NoNewline
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
        return $dscContent
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiRedX
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource
