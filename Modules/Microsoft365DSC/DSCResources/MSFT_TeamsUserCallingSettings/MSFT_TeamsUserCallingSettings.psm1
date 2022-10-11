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
        [System.String]
        [ValidateSet("Ring","Mute","Banner")]
        $GroupNotificationOverride,

        [Parameter()]
        [System.String]
        $CallGroupOrder,

        [Parameter()]
        [System.String[]]
        $CallGroupTargets,

        [Parameter()]
        [System.Boolean]
        $IsUnansweredEnabled,

        [Parameter()]
        [System.String]
        $UnansweredDelay,

        [Parameter()]
        [System.String]
        $UnansweredTarget,

        [Parameter()]
        [System.String]
        [ValidateSet("Group","MyDelegates","SingleTarget","Voicemail")]
        $UnansweredTargetType,

        [Parameter()]
        [System.Boolean]
        $IsForwardingEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet("Immediate","Simultaneous")]
        $ForwardingType,

        [Parameter()]
        [System.String]
        [ValidateSet("Group","MyDelegates","SingleTarget","Voicemail")]
        $ForwardingTargetType,

        [Parameter()]
        [System.String]
        $ForwardingTarget,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    Write-Verbose -Message "Getting the Teams Calling Policy $($Identity)"

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
        $instance = Get-CsUserCallingSettings -Identity $Identity -ErrorAction 'SilentlyContinue'

        if ($null -eq $instance)
        {
            Write-Verbose -Message "Could not find Teams User Calling Settings for ${$Identity}"
            return $nullReturn
        }
        Write-Verbose -Message "Found Teams User Calling Settings for {$Identity}"
        return @{
            Identity                  = $Identity
            GroupNotificationOverride = $instance.GroupNotificationOverride
            CallGroupOrder            = $instance.CallGroupOrder
            CallGroupTargets          = $instance.CallGroupTargets
            IsUnansweredEnabled       = $instance.IsUnansweredEnabled
            UnansweredDelay           = $instance.UnansweredDelay
            UnansweredTarget          = $instance.UnansweredTarget
            UnansweredTargetType      = $instance.UnansweredTargetType
            IsForwardingEnabled       = $instance.IsForwardingEnabled
            ForwardingType            = $instance.ForwardingType
            ForwardingTargetType      = $instance.ForwardingTargetType
            ForwardingTarget          = $instance.ForwardingTarget
            Ensure                    = 'Present'
            Credential                = $Credential
        }
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
        [System.String]
        [ValidateSet("Ring","Mute","Banner")]
        $GroupNotificationOverride,

        [Parameter()]
        [System.String]
        $CallGroupOrder,

        [Parameter()]
        [System.String[]]
        $CallGroupTargets,

        [Parameter()]
        [System.Boolean]
        $IsUnansweredEnabled,

        [Parameter()]
        [System.String]
        $UnansweredDelay,

        [Parameter()]
        [System.String]
        $UnansweredTarget,

        [Parameter()]
        [System.String]
        [ValidateSet("Group","MyDelegates","SingleTarget","Voicemail")]
        $UnansweredTargetType,

        [Parameter()]
        [System.Boolean]
        $IsForwardingEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet("Immediate","Simultaneous")]
        $ForwardingType,

        [Parameter()]
        [System.String]
        [ValidateSet("Group","MyDelegates","SingleTarget","Voicemail")]
        $ForwardingTargetType,

        [Parameter()]
        [System.String]
        $ForwardingTarget,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    Write-Verbose -Message "Setting Teams User Calling Settings"

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

    $CurrentValues = Get-TargetResource @PSBoundParameters

    $SetParameters = $PSBoundParameters
    $SetParameters.Remove("Ensure") | Out-Null
    $SetParameters.Remove("Credential") | Out-Null

    try
    {
        if ($CallGroupOrder -ne $CurrentValues.CallGroupOrder -or $CallGroupTargets -ne $CurrentValues.CallGroupTargets)
        {
            Set-CsUserCallingSettings -Identity $Identity -CallGroupOrder $CallGroupOrder -CallGroupTargets $CallGroupTargets
            $SetParameters.Remove("CallGroupOrder") | Out-Null
        }
        Set-CsUserCallingSettings @SetParameters
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
        [System.String]
        [ValidateSet("Ring","Mute","Banner")]
        $GroupNotificationOverride,

        [Parameter()]
        [System.String]
        $CallGroupOrder,

        [Parameter()]
        [System.String[]]
        $CallGroupTargets,

        [Parameter()]
        [System.Boolean]
        $IsUnansweredEnabled,

        [Parameter()]
        [System.String]
        $UnansweredDelay,

        [Parameter()]
        [System.String]
        $UnansweredTarget,

        [Parameter()]
        [System.String]
        [ValidateSet("Group","MyDelegates","SingleTarget","Voicemail")]
        $UnansweredTargetType,

        [Parameter()]
        [System.Boolean]
        $IsForwardingEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet("Immediate","Simultaneous")]
        $ForwardingType,

        [Parameter()]
        [System.String]
        [ValidateSet("Group","MyDelegates","SingleTarget","Voicemail")]
        $ForwardingTargetType,

        [Parameter()]
        [System.String]
        $ForwardingTarget,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

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

    Write-Verbose -Message "Testing configuration of Team User Calling Settings {$Identity}"

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

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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
        $allUsers = Get-MgUser -All -Select 'UserPrincipalName'
        $i = 1
        Write-Host "`r`n" -NoNewline
        $dscContent = [System.Text.StringBuilder]::New()
        foreach ($user in $allUsers)
        {
            Write-Host "    |---[$i/$($allUsers.Length)] $($user.UserPrincipalName)" -NoNewline
            $params = @{
                Identity   = $user.UserPrincipalName
                Ensure     = 'Present'
                Credential = $Credential
            }
            $Results = Get-TargetResource @Params

            if ($Results.Ensure -eq 'Present')
            {
                $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                    -Results $Results
                $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -Credential $Credential
                $dscContent.Append($currentDSCBlock) | Out-Null
                Save-M365DSCPartialExport -Content $currentDSCBlock `
                    -FileName $Global:PartialExportFileName
            }
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
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
