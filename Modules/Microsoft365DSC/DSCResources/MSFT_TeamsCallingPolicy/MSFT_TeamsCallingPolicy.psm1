Confirm-M365DSCModuleDependency -ModuleName 'MSFT_TeamsCallingPolicy'

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
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $AIInterpreter,

        [Parameter()]
        [System.UInt32]
        $CallingSpendUserLimit,

        [Parameter()]
        [ValidateSet('Enabled', 'EnabledWithTranscript', 'Disabled')]
        [System.String]
        $Copilot,

        [Parameter()]
        [System.Boolean]
        $EnableSpendLimits,

        [Parameter()]
        [System.Boolean]
        $EnableWebPstnMediaBypass,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $ExplicitRecordingConsent,

        [Parameter()]
        [ValidateSet('RegularIncoming', 'Unanswered', 'Voicemail')]
        [System.String]
        $InboundFederatedCallRoutingTreatment,

        [Parameter()]
        [ValidateSet('RegularIncoming', 'Unanswered', 'Voicemail', 'UserOverride')]
        [System.String]
        $InboundPstnCallRoutingTreatment,

        [Parameter()]
        [System.String]
        $PopoutAppPathForIncomingPstnCalls,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $PopoutForIncomingPstnCalls,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $RealTimeText,

        [Parameter()]
        [System.Boolean]
        $ShowTeamsCallsInCallLog,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $VoiceSimulationInInterpreter,

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

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Identity -ne $Identity)
        {
            $null = New-M365DSCConnection -Workload 'MicrosoftTeams' `
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

            $policy = Get-CsTeamsCallingPolicy -Identity $Identity -ErrorAction 'SilentlyContinue'
        }
        else
        {
            $policy = $Script:exportedInstance
        }

        if ($null -eq $policy)
        {
            Write-Verbose -Message "Could not find Teams Calling Policy ${$Identity}"
            return $nullReturn
        }

        Write-Verbose -Message "Found Teams Calling Policy {$Identity}"
        return @{
            Identity                             = $Identity
            AIInterpreter                        = $policy.AIInterpreter
            AllowPrivateCalling                  = $policy.AllowPrivateCalling
            AllowWebPSTNCalling                  = $policy.AllowWebPSTNCalling
            AllowVoicemail                       = $policy.AllowVoicemail
            AllowCallGroups                      = $policy.AllowCallGroups
            AllowDelegation                      = $policy.AllowDelegation
            AllowCallForwardingToUser            = $policy.AllowCallForwardingToUser
            AllowCallForwardingToPhone           = $policy.AllowCallForwardingToPhone
            AllowCallRedirect                    = $policy.AllowCallRedirect
            AllowSIPDevicesCalling               = $policy.AllowSIPDevicesCalling
            CallingSpendUserLimit                = $policy.CallingSpendUserLimit
            Copilot                              = $policy.Copilot
            Description                          = $policy.Description
            EnableSpendLimits                    = $policy.EnableSpendLimits
            EnableWebPstnMediaBypass             = $policy.EnableWebPstnMediaBypass
            ExplicitRecordingConsent             = $policy.ExplicitRecordingConsent
            InboundFederatedCallRoutingTreatment = $policy.InboundFederatedCallRoutingTreatment
            InboundPstnCallRoutingTreatment      = $policy.InboundPstnCallRoutingTreatment
            PopoutAppPathForIncomingPstnCalls    = $policy.PopoutAppPathForIncomingPstnCalls
            PopoutForIncomingPstnCalls           = $policy.PopoutForIncomingPstnCalls
            PreventTollBypass                    = $policy.PreventTollBypass
            RealTimeText                         = $policy.RealTimeText
            ShowTeamsCallsInCallLog              = $policy.ShowTeamsCallsInCallLog
            BusyOnBusyEnabledType                = $policy.BusyOnBusyEnabledType
            CallRecordingExpirationDays          = $policy.CallRecordingExpirationDays
            MusicOnHoldEnabledType               = $policy.MusicOnHoldEnabledType
            SafeTransferEnabled                  = $policy.SafeTransferEnabled
            AllowCloudRecordingForCalls          = $policy.AllowCloudRecordingForCalls
            AllowTranscriptionForCalling         = $policy.AllowTranscriptionForCalling
            LiveCaptionsEnabledTypeForCalling    = $policy.LiveCaptionsEnabledTypeForCalling
            AutoAnswerEnabledType                = $policy.AutoAnswerEnabledType
            SpamFilteringEnabledType             = $policy.SpamFilteringEnabledType
            VoiceSimulationInInterpreter         = $policy.VoiceSimulationInInterpreter
            Ensure                               = 'Present'
            Credential                           = $Credential
            ApplicationId                        = $ApplicationId
            TenantId                             = $TenantId
            CertificateThumbprint                = $CertificateThumbprint
            ManagedIdentity                      = $ManagedIdentity.IsPresent
            AccessTokens                         = $AccessTokens
        }
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
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
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $AIInterpreter,

        [Parameter()]
        [System.UInt32]
        $CallingSpendUserLimit,

        [Parameter()]
        [ValidateSet('Enabled', 'EnabledWithTranscript', 'Disabled')]
        [System.String]
        $Copilot,

        [Parameter()]
        [System.Boolean]
        $EnableSpendLimits,

        [Parameter()]
        [System.Boolean]
        $EnableWebPstnMediaBypass,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $ExplicitRecordingConsent,

        [Parameter()]
        [ValidateSet('RegularIncoming', 'Unanswered', 'Voicemail')]
        [System.String]
        $InboundFederatedCallRoutingTreatment,

        [Parameter()]
        [ValidateSet('RegularIncoming', 'Unanswered', 'Voicemail', 'UserOverride')]
        [System.String]
        $InboundPstnCallRoutingTreatment,

        [Parameter()]
        [System.String]
        $PopoutAppPathForIncomingPstnCalls,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $PopoutForIncomingPstnCalls,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $RealTimeText,

        [Parameter()]
        [System.Boolean]
        $ShowTeamsCallsInCallLog,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $VoiceSimulationInInterpreter,

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

    $CurrentValues = Get-TargetResource @PSBoundParameters

    $SetParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

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
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $AIInterpreter,

        [Parameter()]
        [System.UInt32]
        $CallingSpendUserLimit,

        [Parameter()]
        [ValidateSet('Enabled', 'EnabledWithTranscript', 'Disabled')]
        [System.String]
        $Copilot,

        [Parameter()]
        [System.Boolean]
        $EnableSpendLimits,

        [Parameter()]
        [System.Boolean]
        $EnableWebPstnMediaBypass,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $ExplicitRecordingConsent,

        [Parameter()]
        [ValidateSet('RegularIncoming', 'Unanswered', 'Voicemail')]
        [System.String]
        $InboundFederatedCallRoutingTreatment,

        [Parameter()]
        [ValidateSet('RegularIncoming', 'Unanswered', 'Voicemail', 'UserOverride')]
        [System.String]
        $InboundPstnCallRoutingTreatment,

        [Parameter()]
        [System.String]
        $PopoutAppPathForIncomingPstnCalls,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $PopoutForIncomingPstnCalls,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $RealTimeText,

        [Parameter()]
        [System.Boolean]
        $ShowTeamsCallsInCallLog,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $VoiceSimulationInInterpreter,

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

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '')
    return $result
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [System.String]
        $Filter = "*",

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
        [array]$policies = Get-CsTeamsCallingPolicy -Filter $Filter -ErrorAction Stop
        $dscContent = ''
        Write-M365DSCHost -Message "`r`n" -DeferWrite
        foreach ($policy in $policies)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($policies.Length)] $($policy.Identity)" -DeferWrite
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
            $Script:exportedInstance = $policy
            $Results = Get-TargetResource @Params
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            $i++
        }
        return $dscContent
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

Export-ModuleMember -Function *-TargetResource
