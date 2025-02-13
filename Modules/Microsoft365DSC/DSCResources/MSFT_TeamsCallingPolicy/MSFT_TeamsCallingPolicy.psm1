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
        $Description,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateCalling,

        [Parameter()]
        [System.Boolean]
        $AllowWebPSTNCalling,

        [Parameter()]
        [System.String]
        [ValidateSet('AlwaysEnabled', 'AlwaysDisabled', 'UserOverride')]
        $AllowVoicemail,

        [Parameter()]
        [System.Boolean]
        $AllowCallGroups,

        [Parameter()]
        [System.Boolean]
        $AllowDelegation,

        [Parameter()]
        [System.Boolean]
        $AllowCallForwardingToUser,

        [Parameter()]
        [System.Boolean]
        $AllowCallForwardingToPhone,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled', 'UserOverride')]
        $AllowCallRedirect,

        [Parameter()]
        [System.Boolean]
        $AllowSIPDevicesCalling,

        [Parameter()]
        [System.Boolean]
        $PreventTollBypass,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled', 'Unanswered', 'UserOverride')]
        $BusyOnBusyEnabledType = 'Enabled',

        [Parameter()]
        [System.Int32]
        $CallRecordingExpirationDays,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled', 'UserOverride')]
        $MusicOnHoldEnabledType = 'Enabled',

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled', 'UserOverride')]
        $SafeTransferEnabled = 'Enabled',

        [Parameter()]
        [System.Boolean]
        $AllowCloudRecordingForCalls,

        [Parameter()]
        [System.Boolean]
        $AllowTranscriptionForCalling,

        [Parameter()]
        [System.String]
        [ValidateSet('DisabledUserOverride', 'Disabled')]
        $LiveCaptionsEnabledTypeForCalling = 'DisabledUserOverride',

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled')]
        $AutoAnswerEnabledType = 'Disabled',

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled')]
        $SpamFilteringEnabledType = 'Enabled',

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
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting the Teams Calling Policy $($Identity)"

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

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'

    try
    {
        $policy = Get-CsTeamsCallingPolicy -Identity $Identity -ErrorAction 'SilentlyContinue'

        if ($null -eq $policy)
        {
            Write-Verbose -Message "Could not find Teams Calling Policy ${$Identity}"
            return $nullReturn
        }
        Write-Verbose -Message "Found Teams Calling Policy {$Identity}"
        return @{
            Identity                          = $Identity
            AllowPrivateCalling               = $policy.AllowPrivateCalling
            AllowWebPSTNCalling               = $policy.AllowWebPSTNCalling
            AllowVoicemail                    = $policy.AllowVoicemail
            AllowCallGroups                   = $policy.AllowCallGroups
            AllowDelegation                   = $policy.AllowDelegation
            AllowCallForwardingToUser         = $policy.AllowCallForwardingToUser
            AllowCallForwardingToPhone        = $policy.AllowCallForwardingToPhone
            AllowCallRedirect                 = $policy.AllowCallRedirect
            AllowSIPDevicesCalling            = $policy.AllowSIPDevicesCalling
            Description                       = $policy.Description
            PreventTollBypass                 = $policy.PreventTollBypass
            BusyOnBusyEnabledType             = $policy.BusyOnBusyEnabledType
            CallRecordingExpirationDays       = $policy.CallRecordingExpirationDays
            MusicOnHoldEnabledType            = $policy.MusicOnHoldEnabledType
            SafeTransferEnabled               = $policy.SafeTransferEnabled
            AllowCloudRecordingForCalls       = $policy.AllowCloudRecordingForCalls
            AllowTranscriptionForCalling      = $policy.AllowTranscriptionForCalling
            LiveCaptionsEnabledTypeForCalling = $policy.LiveCaptionsEnabledTypeForCalling
            AutoAnswerEnabledType             = $policy.AutoAnswerEnabledType
            SpamFilteringEnabledType          = $policy.SpamFilteringEnabledType
            Ensure                            = 'Present'
            Credential                        = $Credential
            ApplicationId                     = $ApplicationId
            TenantId                          = $TenantId
            CertificateThumbprint             = $CertificateThumbprint
            ManagedIdentity                   = $ManagedIdentity.IsPresent
            AccessTokens                      = $AccessTokens
        }
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
        $Identity,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateCalling,

        [Parameter()]
        [System.Boolean]
        $AllowWebPSTNCalling,

        [Parameter()]
        [System.String]
        [ValidateSet('AlwaysEnabled', 'AlwaysDisabled', 'UserOverride')]
        $AllowVoicemail,

        [Parameter()]
        [System.Boolean]
        $AllowCallGroups,

        [Parameter()]
        [System.Boolean]
        $AllowDelegation,

        [Parameter()]
        [System.Boolean]
        $AllowCallForwardingToUser,

        [Parameter()]
        [System.Boolean]
        $AllowCallForwardingToPhone,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled', 'UserOverride')]
        $AllowCallRedirect,

        [Parameter()]
        [System.Boolean]
        $AllowSIPDevicesCalling,

        [Parameter()]
        [System.Boolean]
        $PreventTollBypass,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled', 'Unanswered', 'UserOverride')]
        $BusyOnBusyEnabledType = 'Enabled',

        [Parameter()]
        [System.Int32]
        $CallRecordingExpirationDays,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled', 'UserOverride')]
        $MusicOnHoldEnabledType = 'Enabled',

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled', 'UserOverride')]
        $SafeTransferEnabled = 'Enabled',

        [Parameter()]
        [System.Boolean]
        $AllowCloudRecordingForCalls,

        [Parameter()]
        [System.Boolean]
        $AllowTranscriptionForCalling,

        [Parameter()]
        [System.String]
        [ValidateSet('DisabledUserOverride', 'Disabled')]
        $LiveCaptionsEnabledTypeForCalling = 'DisabledUserOverride',

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled')]
        $AutoAnswerEnabledType = 'Disabled',

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled')]
        $SpamFilteringEnabledType = 'Enabled',

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
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message 'Setting Teams Calling Policy'

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

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' `
        -InboundParameters $PSBoundParameters

    $CurrentValues = Get-TargetResource @PSBoundParameters

    $SetParameters = $PSBoundParameters
    $SetParameters.Remove('Ensure') | Out-Null
    $SetParameters.Remove('Credential') | Out-Null
    $SetParameters.Remove('ApplicationId') | Out-Null
    $SetParameters.Remove('TenantId') | Out-Null
    $SetParameters.Remove('CertificateThumbprint') | Out-Null
    $SetParameters.Remove('ManagedIdentity') | Out-Null
    $SetParameters.Remove('AccessTokens') | Out-Null

    if ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating a new Teams Calling Policy {$Identity}"
        New-CsTeamsCallingPolicy @SetParameters
    }
    elseif ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Present')
    {
        # If we get here, it's because the Test-TargetResource detected a drift, therefore we always call
        # into the Set-CsTeamsCallingPolicy cmdlet.
        Write-Verbose -Message "Updating settings for Teams Calling Policy {$Identity}"
        Set-CsTeamsCallingPolicy @SetParameters
    }
    elseif ($Ensure -eq 'Absent' -and $CurrentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing existing Teams Calling Policy {$Identity}"
        Remove-CsTeamsCallingPolicy -Identity $Identity -Confirm:$false
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
        $Description,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateCalling,

        [Parameter()]
        [System.Boolean]
        $AllowWebPSTNCalling,

        [Parameter()]
        [System.String]
        [ValidateSet('AlwaysEnabled', 'AlwaysDisabled', 'UserOverride')]
        $AllowVoicemail,

        [Parameter()]
        [System.Boolean]
        $AllowCallGroups,

        [Parameter()]
        [System.Boolean]
        $AllowDelegation,

        [Parameter()]
        [System.Boolean]
        $AllowCallForwardingToUser,

        [Parameter()]
        [System.Boolean]
        $AllowCallForwardingToPhone,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled', 'UserOverride')]
        $AllowCallRedirect,

        [Parameter()]
        [System.Boolean]
        $AllowSIPDevicesCalling,

        [Parameter()]
        [System.Boolean]
        $PreventTollBypass,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled', 'Unanswered', 'UserOverride')]
        $BusyOnBusyEnabledType = 'Enabled',

        [Parameter()]
        [System.Int32]
        $CallRecordingExpirationDays,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled', 'UserOverride')]
        $MusicOnHoldEnabledType = 'Enabled',

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled', 'UserOverride')]
        $SafeTransferEnabled = 'Enabled',

        [Parameter()]
        [System.Boolean]
        $AllowCloudRecordingForCalls,

        [Parameter()]
        [System.Boolean]
        $AllowTranscriptionForCalling,

        [Parameter()]
        [System.String]
        [ValidateSet('DisabledUserOverride', 'Disabled')]
        $LiveCaptionsEnabledTypeForCalling = 'DisabledUserOverride',

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled')]
        $AutoAnswerEnabledType = 'Disabled',

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled')]
        $SpamFilteringEnabledType = 'Enabled',

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
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
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

    Write-Verbose -Message "Testing configuration of Team Calling Policy {$Identity}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters

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
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
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
        $i = 1
        [array]$policies = Get-CsTeamsCallingPolicy
        $dscContent = ''
        Write-Host "`r`n" -NoNewline
        foreach ($policy in $policies)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-Host "    |---[$i/$($policies.Length)] $($policy.Identity)" -NoNewline
            $params = @{
                Identity              = $policy.Identity
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
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
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
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
