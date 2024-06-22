function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $User,

        [Parameter()]
        [System.String]
        $CallingLineIdentity,

        [Parameter()]
        [System.String]
        $ExternalAccessPolicy,

        [Parameter()]
        [System.String]
        $OnlineVoicemailPolicy,

        [Parameter()]
        [System.String]
        $OnlineVoiceRoutingPolicy,

        [Parameter()]
        [System.String]
        $TeamsAppPermissionPolicy,

        [Parameter()]
        [System.String]
        $TeamsAppSetupPolicy,

        [Parameter()]
        [System.String]
        $TeamsAudioConferencingPolicy,

        [Parameter()]
        [System.String]
        $TeamsCallHoldPolicy,

        [Parameter()]
        [System.String]
        $TeamsCallingPolicy,

        [Parameter()]
        [System.String]
        $TeamsCallParkPolicy,

        [Parameter()]
        [System.String]
        $TeamsChannelsPolicy,

        [Parameter()]
        [System.String]
        $TeamsEmergencyCallingPolicy,

        [Parameter()]
        [System.String]
        $TeamsEmergencyCallRoutingPolicy,

        [Parameter()]
        [System.String]
        $TeamsEnhancedEncryptionPolicy,

        [Parameter()]
        [System.String]
        $TeamsEventsPolicy,

        [Parameter()]
        [System.String]
        $TeamsMeetingBroadcastPolicy,

        [Parameter()]
        [System.String]
        $TeamsMeetingPolicy,

        [Parameter()]
        [System.String]
        $TeamsMessagingPolicy,

        [Parameter()]
        [System.String]
        $TeamsMobilityPolicy,

        [Parameter()]
        [System.String]
        $TeamsUpdateManagementPolicy,

        [Parameter()]
        [System.String]
        $TeamsUpgradePolicy,

        [Parameter()]
        [System.String]
        $TenantDialPlan,

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

    try
    {
        $assignment = Get-CsUserPolicyAssignment -Identity $User -ErrorAction SilentlyContinue
        if ($null -eq $assignment)
        {
            Write-Verbose -Message "User Policy Assignment not found for $User"
            return $null
        }
        Write-Verbose -Message "Found Policy Assignment for user {$User}"
        return @{
            User                            = $User
            CallingLineIdentity             = ($assignment | Where-Object -FilterScript {$_.PolicyType -eq 'CallingLineIdentity'}).PolicyName
            ExternalAccessPolicy            = ($assignment | Where-Object -FilterScript {$_.PolicyType -eq 'ExternalAccessPolicy'}).PolicyName
            OnlineVoicemailPolicy           = ($assignment | Where-Object -FilterScript {$_.PolicyType -eq 'OnlineVoicemailPolicy'}).PolicyName
            OnlineVoiceRoutingPolicy        = ($assignment | Where-Object -FilterScript {$_.PolicyType -eq 'OnlineVoiceRoutingPolicy'}).PolicyName
            TeamsAppPermissionPolicy        = ($assignment | Where-Object -FilterScript {$_.PolicyType -eq 'TeamsAppPermissionPolicy'}).PolicyName
            TeamsAppSetupPolicy             = ($assignment | Where-Object -FilterScript {$_.PolicyType -eq 'TeamsAppSetupPolicy'}).PolicyName
            TeamsAudioConferencingPolicy    = ($assignment | Where-Object -FilterScript {$_.PolicyType -eq 'TeamsAudioConferencingPolicy'}).PolicyName
            TeamsCallHoldPolicy             = ($assignment | Where-Object -FilterScript {$_.PolicyType -eq 'TeamsCallHoldPolicy'}).PolicyName
            TeamsCallingPolicy              = ($assignment | Where-Object -FilterScript {$_.PolicyType -eq 'TeamsCallingPolicy'}).PolicyName
            TeamsCallParkPolicy             = ($assignment | Where-Object -FilterScript {$_.PolicyType -eq 'TeamsCallParkPolicy'}).PolicyName
            TeamsChannelsPolicy             = ($assignment | Where-Object -FilterScript {$_.PolicyType -eq 'TeamsChannelsPolicy'}).PolicyName
            TeamsEmergencyCallingPolicy     = ($assignment | Where-Object -FilterScript {$_.PolicyType -eq 'TeamsEmergencyCallingPolicy'}).PolicyName
            TeamsEmergencyCallRoutingPolicy = ($assignment | Where-Object -FilterScript {$_.PolicyType -eq 'TeamsEmergencyCallRoutingPolicy'}).PolicyName
            TeamsEnhancedEncryptionPolicy   = ($assignment | Where-Object -FilterScript {$_.PolicyType -eq 'TeamsEnhancedEncryptionPolicy'}).PolicyName
            TeamsEventsPolicy               = ($assignment | Where-Object -FilterScript {$_.PolicyType -eq 'TeamsEventsPolicy'}).PolicyName
            TeamsMeetingBroadcastPolicy     = ($assignment | Where-Object -FilterScript {$_.PolicyType -eq 'TeamsMeetingBroadcastPolicy'}).PolicyName
            TeamsMeetingPolicy              = ($assignment | Where-Object -FilterScript {$_.PolicyType -eq 'TeamsMeetingPolicy'}).PolicyName
            TeamsMessagingPolicy            = ($assignment | Where-Object -FilterScript {$_.PolicyType -eq 'TeamsMessagingPolicy'}).PolicyName
            TeamsMobilityPolicy             = ($assignment | Where-Object -FilterScript {$_.PolicyType -eq 'TeamsMobilityPolicy'}).PolicyName
            TeamsUpdateManagementPolicy     = ($assignment | Where-Object -FilterScript {$_.PolicyType -eq 'TeamsUpdateManagementPolicy'}).PolicyName
            TeamsUpgradePolicy              = ($assignment | Where-Object -FilterScript {$_.PolicyType -eq 'TeamsUpgradePolicy'}).PolicyName
            TenantDialPlan                  = ($assignment | Where-Object -FilterScript {$_.PolicyType -eq 'TenantDialPlan'}).PolicyName
            Credential                      = $Credential
            ApplicationId                   = $ApplicationId
            TenantId                        = $TenantId
            CertificateThumbprint           = $CertificateThumbprint
            ManagedIdentity                 = $ManagedIdentity.IsPresent
            AccessTokens                    = $AccessTokens
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
        $User,

        [Parameter()]
        [System.String]
        $CallingLineIdentity,

        [Parameter()]
        [System.String]
        $ExternalAccessPolicy,

        [Parameter()]
        [System.String]
        $OnlineVoicemailPolicy,

        [Parameter()]
        [System.String]
        $OnlineVoiceRoutingPolicy,

        [Parameter()]
        [System.String]
        $TeamsAppPermissionPolicy,

        [Parameter()]
        [System.String]
        $TeamsAppSetupPolicy,

        [Parameter()]
        [System.String]
        $TeamsAudioConferencingPolicy,

        [Parameter()]
        [System.String]
        $TeamsCallHoldPolicy,

        [Parameter()]
        [System.String]
        $TeamsCallingPolicy,

        [Parameter()]
        [System.String]
        $TeamsCallParkPolicy,

        [Parameter()]
        [System.String]
        $TeamsChannelsPolicy,

        [Parameter()]
        [System.String]
        $TeamsEmergencyCallingPolicy,

        [Parameter()]
        [System.String]
        $TeamsEmergencyCallRoutingPolicy,

        [Parameter()]
        [System.String]
        $TeamsEnhancedEncryptionPolicy,

        [Parameter()]
        [System.String]
        $TeamsEventsPolicy,

        [Parameter()]
        [System.String]
        $TeamsMeetingBroadcastPolicy,

        [Parameter()]
        [System.String]
        $TeamsMeetingPolicy,

        [Parameter()]
        [System.String]
        $TeamsMessagingPolicy,

        [Parameter()]
        [System.String]
        $TeamsMobilityPolicy,

        [Parameter()]
        [System.String]
        $TeamsUpdateManagementPolicy,

        [Parameter()]
        [System.String]
        $TeamsUpgradePolicy,

        [Parameter()]
        [System.String]
        $TenantDialPlan,

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

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' -InboundParameters $PSBoundParameters

    try
    {
        if ($null -ne $CallingLineIdentity)
        {
            Write-Verbose -Message "Assigning the Call Line Identity Policy {$CallingLineIdentity} to user {$User}"
            Grant-CsCallingLineIdentity -Identity $User -PolicyName $CallingLineIdentity | Out-Null
        }
        if ($null -ne $ExternalAccessPolicy)
        {
            Write-Verbose -Message "Assigning the External Access Policy {$ExternalAccessPolicy} to user {$User}"
            Grant-CsExternalAccessPolicy -Identity $User -PolicyName $CallingLineIdentity | Out-Null
        }
        if ($null -ne $OnlineVoicemailPolicy)
        {
            Write-Verbose -Message "Assigning the Online Voicemail Policy {$OnlineVoicemailPolicy} to user {$User}"
            Grant-CsOnlineVoicemailPolicy -Identity $User -PolicyName $OnlineVoicemailPolicy | Out-Null
        }
        if ($null -ne $OnlineVoiceRoutingPolicy)
        {
            Write-Verbose -Message "Assigning the Online Voice Routing Policy {$OnlineVoiceRoutingPolicy} to user {$User}"
            Grant-CsOnlineVoiceRoutingPolicy -Identity $User -PolicyName $OnlineVoiceRoutingPolicy | Out-Null
        }
        if ($null -ne $TeamsAppPermissionPolicy)
        {
            Write-Verbose -Message "Assigning the Apps Permission Policy {$TeamsAppPermissionPolicy} to user {$User}"
            Grant-CsTeamsAppPermissionPolicy -Identity $User -PolicyName $TeamsAppPermissionPolicy | Out-Null
        }
        if ($null -ne $TeamsAppSetupPolicy)
        {
            Write-Verbose -Message "Assigning the Apps Setup Policy {$TeamsAppSetupPolicy} to user {$User}"
            Grant-CsTeamsAppSetupPolicy -Identity $User -PolicyName $TeamsAppSetupPolicy | Out-Null
        }
        if ($null -ne $TeamsAudioConferencingPolicy)
        {
            Write-Verbose -Message "Assigning the Audio COnferencing Policy {$TeamsAudioConferencingPolicy} to user {$User}"
            Grant-CsTeamsAudioConferencingPolicy -Identity $User -PolicyName $TeamsAudioConferencingPolicy | Out-Null
        }
        if ($null -ne $TeamsCallHoldPolicy)
        {
            Write-Verbose -Message "Assigning the Call Hold Policy {$TeamsCallHoldPolicy} to user {$User}"
            Grant-CsTeamsCallHoldPolicy -Identity $User -PolicyName $TeamsCallHoldPolicy | Out-Null
        }
        if ($null -ne $TeamsCallingPolicy)
        {
            Write-Verbose -Message "Assigning the Calling Policy {$TeamsCallingPolicy} to user {$User}"
            Grant-CsTeamsCallingPolicy -Identity $User -PolicyName $TeamsCallingPolicy | Out-Null
        }
        if ($null -ne $TeamsCallParkPolicy)
        {
            Write-Verbose -Message "Assigning the Call Park Policy {$TeamsCallParkPolicy} to user {$User}"
            Grant-CsTeamsCallParkPolicy -Identity $User -PolicyName $TeamsCallParkPolicy | Out-Null
        }
        if ($null -ne $TeamsChannelsPolicy)
        {
            Write-Verbose -Message "Assigning the Channels Policy {$TeamsChannelsPolicy} to user {$User}"
            Grant-CsTeamsChannelsPolicy -Identity $User -PolicyName $TeamsChannelsPolicy | Out-Null
        }
        if ($null -ne $TeamsEmergencyCallingPolicy)
        {
            Write-Verbose -Message "Assigning the Emergency Calling Policy {$TeamsEmergencyCallingPolicy} to user {$User}"
            Grant-CsTeamsEmergencyCallingPolicy -Identity $User -PolicyName $TeamsEmergencyCallingPolicy | Out-Null
        }
        if ($null -ne $TeamsEmergencyCallRoutingPolicy)
        {
            Write-Verbose -Message "Assigning the Emergency Call Routing Policy {$TeamsEmergencyCallRoutingPolicy} to user {$User}"
            Grant-CsTeamsEmergencyCallRoutingPolicy -Identity $User -PolicyName $TeamsEmergencyCallRoutingPolicy | Out-Null
        }
        if ($null -ne $TeamsEnhancedEncryptionPolicy)
        {
            Write-Verbose -Message "Assigning the Enhanced Encryption Policy {$TeamsEnhancedEncryptionPolicy} to user {$User}"
            Grant-CsTeamsEnhancedEncryptionPolicy -Identity $User -PolicyName $TeamsEnhancedEncryptionPolicy | Out-Null
        }
        if ($null -ne $TeamsEventsPolicy)
        {
            Write-Verbose -Message "Assigning the Events Policy {$TeamsEventsPolicy} to user {$User}"
            Grant-CsTeamsEventsPolicy -Identity $User -PolicyName $TeamsEventsPolicy | Out-Null
        }
        if ($null -ne $TeamsMeetingBroadcastPolicy)
        {
            Write-Verbose -Message "Assigning the Meeting Broadcast Policy {$TeamsMeetingBroadcastPolicy} to user {$User}"
            Grant-CsTeamsMeetingBroadcastPolicy -Identity $User -PolicyName $TeamsMeetingBroadcastPolicy | Out-Null
        }
        if ($null -ne $TeamsMeetingPolicy)
        {
            Write-Verbose -Message "Assigning the Meeting Policy {$TeamsMeetingPolicy} to user {$User}"
            Grant-CsTeamsMeetingPolicy -Identity $User -PolicyName $TeamsMeetingPolicy | Out-Null
        }
        if ($null -ne $TeamsMessagingPolicy)
        {
            Write-Verbose -Message "Assigning the Messaging Policy {$TeamsMessagingPolicy} to user {$User}"
            Grant-CsTeamsMessagingPolicy -Identity $User -PolicyName $TeamsMessagingPolicy | Out-Null
        }
        if ($null -ne $TeamsMobilityPolicy)
        {
            Write-Verbose -Message "Assigning the Mobility Policy {$TeamsMobilityPolicy} to user {$User}"
            Grant-CsTeamsMobilityPolicy -Identity $User -PolicyName $TeamsMobilityPolicy | Out-Null
        }
        if ($null -ne $TeamsUpdateManagementPolicy)
        {
            Write-Verbose -Message "Assigning the Update Management Policy {$TeamsUpdateManagementPolicy} to user {$User}"
            Grant-CsTeamsUpdateManagementPolicy -Identity $User -PolicyName $TeamsUpdateManagementPolicy | Out-Null
        }
        if ($null -ne $TeamsUpgradePolicy)
        {
            Write-Verbose -Message "Assigning the Upgrade Policy {$TeamsUpgradePolicy} to user {$User}"
            Grant-CsTeamsUpgradePolicy -Identity $User -PolicyName $TeamsUpgradePolicy | Out-Null
        }
        if ($null -ne $TenantDialPlan)
        {
            Write-Verbose -Message "Assigning the Tenant Dial Plan {$TenantDialPlan} to user {$User}"
            Grant-CsTenantDialPlan -Identity $User -PolicyName $TenantDialPlan | Out-Null
        }
    }
    catch
    {
        Write-Verbose -Message "Error: $($_.Exception.Message)"
        New-M365DSCLogEntry -Message "Error while setting Policy Assignment for User {$User}" `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential
        throw $_
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
        $User,

        [Parameter()]
        [System.String]
        $CallingLineIdentity,

        [Parameter()]
        [System.String]
        $ExternalAccessPolicy,

        [Parameter()]
        [System.String]
        $OnlineVoicemailPolicy,

        [Parameter()]
        [System.String]
        $OnlineVoiceRoutingPolicy,

        [Parameter()]
        [System.String]
        $TeamsAppPermissionPolicy,

        [Parameter()]
        [System.String]
        $TeamsAppSetupPolicy,

        [Parameter()]
        [System.String]
        $TeamsAudioConferencingPolicy,

        [Parameter()]
        [System.String]
        $TeamsCallHoldPolicy,

        [Parameter()]
        [System.String]
        $TeamsCallingPolicy,

        [Parameter()]
        [System.String]
        $TeamsCallParkPolicy,

        [Parameter()]
        [System.String]
        $TeamsChannelsPolicy,

        [Parameter()]
        [System.String]
        $TeamsEmergencyCallingPolicy,

        [Parameter()]
        [System.String]
        $TeamsEmergencyCallRoutingPolicy,

        [Parameter()]
        [System.String]
        $TeamsEnhancedEncryptionPolicy,

        [Parameter()]
        [System.String]
        $TeamsEventsPolicy,

        [Parameter()]
        [System.String]
        $TeamsMeetingBroadcastPolicy,

        [Parameter()]
        [System.String]
        $TeamsMeetingPolicy,

        [Parameter()]
        [System.String]
        $TeamsMessagingPolicy,

        [Parameter()]
        [System.String]
        $TeamsMobilityPolicy,

        [Parameter()]
        [System.String]
        $TeamsUpdateManagementPolicy,

        [Parameter()]
        [System.String]
        $TeamsUpgradePolicy,

        [Parameter()]
        [System.String]
        $TenantDialPlan,

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

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).Clone()

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

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
    $InformationPreference = 'Continue'
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' -InboundParameters $PSBoundParameters
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' -InboundParameters $PSBoundParameters

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
        [array]$users = Get-MgUser -All
        if ($users.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        $dscContent = [System.Text.StringBuilder]::new()
        $j = 1
        $totalCount = $users.Length
        foreach ($user in $users)
        {
            if ($null -eq $totalCount)
            {
                $totalCount = 1
            }
            Write-Host "    |---[$j/$totalCount] Policy Assignment(s) for user {$($user.UserPrincipalName)}" -NoNewline
            $getParams = @{
                User                  = $user.UserPrincipalName
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }
            $results = Get-TargetResource @getParams

            if ($null -ne $results)
            {
                if ($null -ne $Global:M365DSCExportResourceInstancesCount)
                {
                    $Global:M365DSCExportResourceInstancesCount++
                }

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

            $j++
        }
        return $dscContent.ToString()
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
