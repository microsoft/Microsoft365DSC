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
        [System.Boolean]
        $PreventTollBypass,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled')]
        $BusyOnBusyEnabledType = 'Enabled',

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
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting the Teams Calling Policy $($Identity)"

    $ConnectionMode = New-M365DSCConnection -Platform 'MicrosoftTeams' `
        -InboundParameters $PSBoundParameters

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    $data.Add("ConnectionMode", $ConnectionMode)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"

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
            Description                       = $policy.Description
            PreventTollBypass                 = $policy.PreventTollBypass
            BusyOnBusyEnabledType             = $policy.BusyOnBusyEnabledType
            MusicOnHoldEnabledType            = $policy.MusicOnHoldEnabledType
            SafeTransferEnabled               = $policy.SafeTransferEnabled
            AllowCloudRecordingForCalls       = $policy.AllowCloudRecordingForCalls
            AllowTranscriptionForCalling      = $policy.AllowTranscriptionForCalling
            LiveCaptionsEnabledTypeForCalling = $policy.LiveCaptionsEnabledTypeForCalling
            AutoAnswerEnabledType             = $policy.AutoAnswerEnabledType
            SpamFilteringEnabledType          = $policy.SpamFilteringEnabledType
            Ensure                            = 'Present'
            GlobalAdminAccount                = $GlobalAdminAccount
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
            elseif ($null -ne $GlobalAdminAccount)
            {
                $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
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
        [System.Boolean]
        $PreventTollBypass,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled')]
        $BusyOnBusyEnabledType = 'Enabled',

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
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting Teams Calling Policy"

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'MicrosoftTeams' `
        -InboundParameters $PSBoundParameters

    $CurrentValues = Get-TargetResource @PSBoundParameters

    $SetParameters = $PSBoundParameters
    $SetParameters.Remove("Ensure") | Out-Null
    $SetParameters.Remove("GlobalAdminAccount") | Out-Null

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
        [System.Boolean]
        $PreventTollBypass,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled')]
        $BusyOnBusyEnabledType = 'Enabled',

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
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of Team Calling Policy {$Identity}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

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
        $GlobalAdminAccount
    )
    $ConnectionMode = New-M365DSCConnection -Platform 'MicrosoftTeams' `
        -InboundParameters $PSBoundParameters

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    $data.Add("ConnectionMode", $ConnectionMode)
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
            Write-Host "    |---[$i/$($policies.Length)] $($policy.Identity)" -NoNewline
            $params = @{
                Identity           = $policy.Identity
                Ensure             = 'Present'
                GlobalAdminAccount = $GlobalAdminAccount
            }
            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -GlobalAdminAccount $GlobalAdminAccount
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
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $GlobalAdminAccount)
            {
                $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
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
