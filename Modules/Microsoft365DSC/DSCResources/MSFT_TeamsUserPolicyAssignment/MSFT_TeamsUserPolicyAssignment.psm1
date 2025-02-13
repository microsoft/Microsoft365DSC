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

        $CallingLineIdentityValue = ($assignment | Where-Object -FilterScript { $_.PolicyType -eq 'CallingLineIdentity' }).PolicyName
        if ([System.String]::IsNullOrEmpty($CallingLineIdentityValue))
        {
            $CallingLineIdentityValue = 'Global'
        }

        $ExternalAccessPolicyValue = ($assignment | Where-Object -FilterScript { $_.PolicyType -eq 'ExternalAccessPolicy' }).PolicyName
        if ([System.String]::IsNullOrEmpty($ExternalAccessPolicyValue))
        {
            $ExternalAccessPolicyValue = 'Global'
        }

        $OnlineVoicemailPolicyValue = ($assignment | Where-Object -FilterScript { $_.PolicyType -eq 'OnlineVoicemailPolicy' }).PolicyName
        if ([System.String]::IsNullOrEmpty($OnlineVoicemailPolicyValue))
        {
            $OnlineVoicemailPolicyValue = 'Global'
        }

        $OnlineVoiceRoutingPolicyValue = ($assignment | Where-Object -FilterScript { $_.PolicyType -eq 'OnlineVoiceRoutingPolicy' }).PolicyName
        if ([System.String]::IsNullOrEmpty($OnlineVoiceRoutingPolicyValue))
        {
            $OnlineVoiceRoutingPolicyValue = 'Global'
        }

        $TeamsAppPermissionPolicyValue = ($assignment | Where-Object -FilterScript { $_.PolicyType -eq 'TeamsAppPermissionPolicy' }).PolicyName
        if ([System.String]::IsNullOrEmpty($TeamsAppPermissionPolicyValue))
        {
            $TeamsAppPermissionPolicyValue = 'Global'
        }

        $TeamsAppSetupPolicyValue = ($assignment | Where-Object -FilterScript { $_.PolicyType -eq 'TeamsAppSetupPolicy' }).PolicyName
        if ([System.String]::IsNullOrEmpty($TeamsAppSetupPolicyValue))
        {
            $TeamsAppSetupPolicyValue = 'Global'
        }

        $TeamsAudioConferencingPolicyValue = ($assignment | Where-Object -FilterScript { $_.PolicyType -eq 'TeamsAudioConferencingPolicy' }).PolicyName
        if ([System.String]::IsNullOrEmpty($TeamsAudioConferencingPolicyValue))
        {
            $TeamsAudioConferencingPolicyValue = 'Global'
        }

        $TeamsCallHoldPolicyValue = ($assignment | Where-Object -FilterScript { $_.PolicyType -eq 'TeamsCallHoldPolicy' }).PolicyName
        if ([System.String]::IsNullOrEmpty($TeamsCallHoldPolicyValue))
        {
            $TeamsCallHoldPolicyValue = 'Global'
        }

        $TeamsCallingPolicyValue = ($assignment | Where-Object -FilterScript { $_.PolicyType -eq 'TeamsCallingPolicy' }).PolicyName
        if ([System.String]::IsNullOrEmpty($TeamsCallingPolicyValue))
        {
            $TeamsCallingPolicyValue = 'Global'
        }

        $TeamsCallParkPolicyValue = ($assignment | Where-Object -FilterScript { $_.PolicyType -eq 'TeamsCallParkPolicy' }).PolicyName
        if ([System.String]::IsNullOrEmpty($TeamsCallParkPolicyValue))
        {
            $TeamsCallParkPolicyValue = 'Global'
        }

        $TeamsChannelsPolicyValue = ($assignment | Where-Object -FilterScript { $_.PolicyType -eq 'TeamsChannelsPolicy' }).PolicyName
        if ([System.String]::IsNullOrEmpty($TeamsChannelsPolicyValue))
        {
            $TeamsChannelsPolicyValue = 'Global'
        }

        $TeamsEmergencyCallingPolicyValue = ($assignment | Where-Object -FilterScript { $_.PolicyType -eq 'TeamsEmergencyCallingPolicy' }).PolicyName
        if ([System.String]::IsNullOrEmpty($TeamsEmergencyCallingPolicyValue))
        {
            $TeamsEmergencyCallingPolicyValue = 'Global'
        }

        $TeamsEmergencyCallRoutingPolicyValue = ($assignment | Where-Object -FilterScript { $_.PolicyType -eq 'TeamsEmergencyCallRoutingPolicy' }).PolicyName
        if ([System.String]::IsNullOrEmpty($TeamsEmergencyCallRoutingPolicyValue))
        {
            $TeamsEmergencyCallRoutingPolicyValue = 'Global'
        }

        $TeamsEnhancedEncryptionPolicyValue = ($assignment | Where-Object -FilterScript { $_.PolicyType -eq 'TeamsEnhancedEncryptionPolicy' }).PolicyName
        if ([System.String]::IsNullOrEmpty($TeamsEnhancedEncryptionPolicyValue))
        {
            $TeamsEnhancedEncryptionPolicyValue = 'Global'
        }

        $TeamsEventsPolicyValue = ($assignment | Where-Object -FilterScript { $_.PolicyType -eq 'TeamsEventsPolicy' }).PolicyName
        if ([System.String]::IsNullOrEmpty($TeamsEventsPolicyValue))
        {
            $TeamsEventsPolicyValue = 'Global'
        }

        $TeamsMeetingBroadcastPolicyValue = ($assignment | Where-Object -FilterScript { $_.PolicyType -eq 'TeamsMeetingBroadcastPolicy' }).PolicyName
        if ([System.String]::IsNullOrEmpty($TeamsMeetingBroadcastPolicyValue))
        {
            $TeamsMeetingBroadcastPolicyValue = 'Global'
        }

        $TeamsMeetingPolicyValue = ($assignment | Where-Object -FilterScript { $_.PolicyType -eq 'TeamsMeetingPolicy' }).PolicyName
        if ([System.String]::IsNullOrEmpty($TeamsMeetingPolicyValue))
        {
            $TeamsMeetingPolicyValue = 'Global'
        }

        $TeamsMessagingPolicyValue = ($assignment | Where-Object -FilterScript { $_.PolicyType -eq 'TeamsMessagingPolicy' }).PolicyName
        if ([System.String]::IsNullOrEmpty($TeamsMessagingPolicyValue))
        {
            $TeamsMessagingPolicyValue = 'Global'
        }

        $TeamsMobilityPolicyValue = ($assignment | Where-Object -FilterScript { $_.PolicyType -eq 'TeamsMobilityPolicy' }).PolicyName
        if ([System.String]::IsNullOrEmpty($TeamsMobilityPolicyValue))
        {
            $TeamsMobilityPolicyValue = 'Global'
        }

        $TeamsUpdateManagementPolicyValue = ($assignment | Where-Object -FilterScript { $_.PolicyType -eq 'TeamsUpdateManagementPolicy' }).PolicyName
        if ([System.String]::IsNullOrEmpty($TeamsUpdateManagementPolicyValue))
        {
            $TeamsUpdateManagementPolicyValue = 'Global'
        }

        $TeamsUpgradePolicyValue = ($assignment | Where-Object -FilterScript { $_.PolicyType -eq 'TeamsUpgradePolicy' }).PolicyName
        if ([System.String]::IsNullOrEmpty($TeamsUpgradePolicyValue))
        {
            $TeamsUpgradePolicyValue = 'Global'
        }

        $TenantDialPlanValue = ($assignment | Where-Object -FilterScript { $_.PolicyType -eq 'TenantDialPlan' }).PolicyName
        if ([System.String]::IsNullOrEmpty($TenantDialPlanValue))
        {
            $TenantDialPlanValue = 'Global'
        }

        Write-Verbose -Message "Found Policy Assignment for user {$User}"
        return @{
            User                            = $User
            CallingLineIdentity             = $CallingLineIdentityValue
            ExternalAccessPolicy            = $ExternalAccessPolicyValue
            OnlineVoicemailPolicy           = $OnlineVoicemailPolicyValue
            OnlineVoiceRoutingPolicy        = $OnlineVoiceRoutingPolicyValue
            TeamsAppPermissionPolicy        = $TeamsAppPermissionPolicyValue
            TeamsAppSetupPolicy             = $TeamsAppSetupPolicyValue
            TeamsAudioConferencingPolicy    = $TeamsAudioConferencingPolicyValue
            TeamsCallHoldPolicy             = $TeamsCallHoldPolicyValue
            TeamsCallingPolicy              = $TeamsCallingPolicyValue
            TeamsCallParkPolicy             = $TeamsCallParkPolicyValue
            TeamsChannelsPolicy             = $TeamsChannelsPolicyValue
            TeamsEmergencyCallingPolicy     = $TeamsEmergencyCallingPolicyValue
            TeamsEmergencyCallRoutingPolicy = $TeamsEmergencyCallRoutingPolicyValue
            TeamsEnhancedEncryptionPolicy   = $TeamsEnhancedEncryptionPolicyValue
            TeamsEventsPolicy               = $TeamsEventsPolicyValue
            TeamsMeetingBroadcastPolicy     = $TeamsMeetingBroadcastPolicyValue
            TeamsMeetingPolicy              = $TeamsMeetingPolicyValue
            TeamsMessagingPolicy            = $TeamsMessagingPolicyValue
            TeamsMobilityPolicy             = $TeamsMobilityPolicyValue
            TeamsUpdateManagementPolicy     = $TeamsUpdateManagementPolicyValue
            TeamsUpgradePolicy              = $TeamsUpgradePolicyValue
            TenantDialPlan                  = $TenantDialPlanValue
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

    $currentInstance = Get-TargetResource @PSBoundParameters
    try
    {
        if ($null -ne $CallingLineIdentity -and $CallingLineIdentity -ne $currentInstance.CallingLineIdentity)
        {
            Write-Verbose -Message "Assigning the Call Line Identity Policy {$CallingLineIdentity} to user {$User}"
            if ($CallingLineIdentity -eq 'Global')
            {
                $CallingLineIdentity = $null
            }
            Grant-CsCallingLineIdentity -Identity $User -PolicyName $CallingLineIdentity | Out-Null
        }
        if ($null -ne $ExternalAccessPolicy -and $ExternalAccessPolicy -ne $currentInstance.ExternalAccessPolicy)
        {
            Write-Verbose -Message "Assigning the External Access Policy {$ExternalAccessPolicy} to user {$User}"
            if ($ExternalAccessPolicy -eq 'Global')
            {
                $ExternalAccessPolicy = $null
            }
            Grant-CsExternalAccessPolicy -Identity $User -PolicyName $ExternalAccessPolicy | Out-Null
        }
        if ($null -ne $OnlineVoicemailPolicy -and $OnlineVoicemailPolicy -ne $currentInstance.OnlineVoicemailPolicy)
        {
            Write-Verbose -Message "Assigning the Online Voicemail Policy {$OnlineVoicemailPolicy} to user {$User}"
            if ($OnlineVoicemailPolicy -eq 'Global')
            {
                $OnlineVoicemailPolicy = $null
            }
            Grant-CsOnlineVoicemailPolicy -Identity $User -PolicyName $OnlineVoicemailPolicy | Out-Null
        }
        if ($null -ne $OnlineVoiceRoutingPolicy -and $OnlineVoiceRoutingPolicy -ne $currentInstance.OnlineVoiceRoutingPolicy)
        {
            Write-Verbose -Message "Assigning the Online Voice Routing Policy {$OnlineVoiceRoutingPolicy} to user {$User}"
            if ($OnlineVoiceRoutingPolicy -eq 'Global')
            {
                $OnlineVoiceRoutingPolicy = $null
            }
            Grant-CsOnlineVoiceRoutingPolicy -Identity $User -PolicyName $OnlineVoiceRoutingPolicy | Out-Null
        }
        if ($null -ne $TeamsAppPermissionPolicy -and $TeamsAppPermissionPolicy -ne $currentInstance.TeamsAppPermissionPolicy)
        {
            Write-Verbose -Message "Assigning the Apps Permission Policy {$TeamsAppPermissionPolicy} to user {$User}"
            if ($TeamsAppPermissionPolicy -eq 'Global')
            {
                $TeamsAppPermissionPolicy = $null
            }
            Grant-CsTeamsAppPermissionPolicy -Identity $User -PolicyName $TeamsAppPermissionPolicy | Out-Null
        }
        if ($null -ne $TeamsAppSetupPolicy -and $TeamsAppSetupPolicy -ne $currentInstance.TeamsAppSetupPolicy)
        {
            Write-Verbose -Message "Assigning the Apps Setup Policy {$TeamsAppSetupPolicy} to user {$User}"
            if ($TeamsAppSetupPolicy -eq 'Global')
            {
                $TeamsAppSetupPolicy = $null
            }
            Grant-CsTeamsAppSetupPolicy -Identity $User -PolicyName $TeamsAppSetupPolicy | Out-Null
        }
        if ($null -ne $TeamsAudioConferencingPolicy -and $TeamsAudioConferencingPolicy -ne $currentInstance.TeamsAudioConferencingPolicy)
        {
            Write-Verbose -Message "Assigning the Audio COnferencing Policy {$TeamsAudioConferencingPolicy} to user {$User}"
            if ($TeamsAudioConferencingPolicy -eq 'Global')
            {
                $TeamsAudioConferencingPolicy = $null
            }
            Grant-CsTeamsAudioConferencingPolicy -Identity $User -PolicyName $TeamsAudioConferencingPolicy | Out-Null
        }
        if ($null -ne $TeamsCallHoldPolicy -and $TeamsCallHoldPolicy -ne $currentInstance.TeamsCallHoldPolicy)
        {
            Write-Verbose -Message "Assigning the Call Hold Policy {$TeamsCallHoldPolicy} to user {$User}"
            if ($TeamsCallHoldPolicy -eq 'Global')
            {
                $TeamsCallHoldPolicy = $null
            }
            Grant-CsTeamsCallHoldPolicy -Identity $User -PolicyName $TeamsCallHoldPolicy | Out-Null
        }
        if ($null -ne $TeamsCallingPolicy -and $TeamsCallingPolicy -ne $currentInstance.TeamsCallingPolicy)
        {
            Write-Verbose -Message "Assigning the Calling Policy {$TeamsCallParkPolicy} to user {$User}"
            if ($TeamsCallParkPolicy -eq 'Global')
            {
                $TeamsCallParkPolicy = $null
            }
            Grant-CsTeamsCallingPolicy -Identity $User -PolicyName $TeamsCallingPolicy | Out-Null
        }
        if ($null -ne $TeamsCallParkPolicy -and $TeamsCallParkPolicy -ne $currentInstance.TeamsCallParkPolicy)
        {
            Write-Verbose -Message "Assigning the Call Park Policy {$TeamsCallParkPolicy} to user {$User}"
            if ($TeamsCallParkPolicy -eq 'Global')
            {
                $TeamsCallParkPolicy = $null
            }
            Grant-CsTeamsCallParkPolicy -Identity $User -PolicyName $TeamsCallParkPolicy | Out-Null
        }
        if ($null -ne $TeamsChannelsPolicy -and $TeamsChannelsPolicy -ne $currentInstance.TeamsChannelsPolicy)
        {
            Write-Verbose -Message "Assigning the Channels Policy {$TeamsChannelsPolicy} to user {$User}"
            if ($TeamsChannelsPolicy -eq 'Global')
            {
                $TeamsChannelsPolicy = $null
            }
            Grant-CsTeamsChannelsPolicy -Identity $User -PolicyName $TeamsChannelsPolicy | Out-Null
        }
        if ($null -ne $TeamsEmergencyCallingPolicy -and $TeamsEmergencyCallingPolicy -ne $currentInstance.TeamsEmergencyCallingPolicy)
        {
            Write-Verbose -Message "Assigning the Emergency Calling Policy {$TeamsEmergencyCallingPolicy} to user {$User}"
            if ($TeamsEmergencyCallingPolicy -eq 'Global')
            {
                $TeamsEmergencyCallingPolicy = $null
            }
            Grant-CsTeamsEmergencyCallingPolicy -Identity $User -PolicyName $TeamsEmergencyCallingPolicy | Out-Null
        }
        if ($null -ne $TeamsEmergencyCallRoutingPolicy -and $TeamsEmergencyCallRoutingPolicy -ne $currentInstance.TeamsEmergencyCallRoutingPolicy)
        {
            Write-Verbose -Message "Assigning the Emergency Call Routing Policy {$TeamsEmergencyCallRoutingPolicy} to user {$User}"
            if ($TeamsEmergencyCallRoutingPolicy -eq 'Global')
            {
                $TeamsEmergencyCallRoutingPolicy = $null
            }
            Grant-CsTeamsEmergencyCallRoutingPolicy -Identity $User -PolicyName $TeamsEmergencyCallRoutingPolicy | Out-Null
        }
        if ($null -ne $TeamsEnhancedEncryptionPolicy -and $TeamsEnhancedEncryptionPolicy -ne $currentInstance.TeamsEnhancedEncryptionPolicy)
        {
            Write-Verbose -Message "Assigning the Enhanced Encryption Policy {$TeamsEnhancedEncryptionPolicy} to user {$User}"
            if ($TeamsEnhancedEncryptionPolicy -eq 'Global')
            {
                $TeamsEnhancedEncryptionPolicy = $null
            }
            Grant-CsTeamsEnhancedEncryptionPolicy -Identity $User -PolicyName $TeamsEnhancedEncryptionPolicy | Out-Null
        }
        if ($null -ne $TeamsEventsPolicy -and $TeamsEventsPolicy -ne $currentInstance.TeamsEventsPolicy)
        {
            Write-Verbose -Message "Assigning the Events Policy {$TeamsEventsPolicy} to user {$User}"
            if ($TeamsEventsPolicy -eq 'Global')
            {
                $TeamsEventsPolicy = $null
            }
            Grant-CsTeamsEventsPolicy -Identity $User -PolicyName $TeamsEventsPolicy | Out-Null
        }
        if ($null -ne $TeamsMeetingBroadcastPolicy -and $TeamsMeetingBroadcastPolicy -ne $currentInstance.TeamsMeetingBroadcastPolicy)
        {
            Write-Verbose -Message "Assigning the Meeting Broadcast Policy {$TeamsMeetingBroadcastPolicy} to user {$User}"
            if ($TeamsMeetingBroadcastPolicy -eq 'Global')
            {
                $TeamsMeetingBroadcastPolicy = $null
            }
            Grant-CsTeamsMeetingBroadcastPolicy -Identity $User -PolicyName $TeamsMeetingBroadcastPolicy | Out-Null
        }
        if ($null -ne $TeamsMeetingPolicy -and $TeamsMeetingPolicy -ne $currentInstance.TeamsMeetingPolicy)
        {
            Write-Verbose -Message "Assigning the Meeting Policy {$TeamsMeetingPolicy} to user {$User}"
            if ($TeamsMeetingPolicy -eq 'Global')
            {
                $TeamsMeetingPolicy = $null
            }
            Grant-CsTeamsMeetingPolicy -Identity $User -PolicyName $TeamsMeetingPolicy | Out-Null
        }
        if ($null -ne $TeamsMessagingPolicy -and $TeamsMessagingPolicy -ne $currentInstance.TeamsMessagingPolicy)
        {
            Write-Verbose -Message "Assigning the Messaging Policy {$TeamsMessagingPolicy} to user {$User}"
            if ($TeamsMessagingPolicy -eq 'Global')
            {
                $TeamsMessagingPolicy = $null
            }
            Grant-CsTeamsMessagingPolicy -Identity $User -PolicyName $TeamsMessagingPolicy | Out-Null
        }
        if ($null -ne $TeamsMobilityPolicy -and $TeamsMobilityPolicy -ne $currentInstance.TeamsMobilityPolicy)
        {
            Write-Verbose -Message "Assigning the Mobility Policy {$TeamsMobilityPolicy} to user {$User}"
            if ($TeamsMobilityPolicy -eq 'Global')
            {
                $TeamsMobilityPolicy = $null
            }
            Grant-CsTeamsMobilityPolicy -Identity $User -PolicyName $TeamsMobilityPolicy | Out-Null
        }
        if ($null -ne $TeamsUpdateManagementPolicy -and $TeamsUpdateManagementPolicy -ne $currentInstance.TeamsUpdateManagementPolicy)
        {
            Write-Verbose -Message "Assigning the Update Management Policy {$TeamsUpdateManagementPolicy} to user {$User}"
            if ($TeamsUpdateManagementPolicy -eq 'Global')
            {
                $TeamsUpdateManagementPolicy = $null
            }
            Grant-CsTeamsUpdateManagementPolicy -Identity $User -PolicyName $TeamsUpdateManagementPolicy | Out-Null
        }
        if ($null -ne $TeamsUpgradePolicy -and $TeamsUpgradePolicy -ne $currentInstance.TeamsUpgradePolicy)
        {
            Write-Verbose -Message "Assigning the Upgrade Policy {$TeamsUpgradePolicy} to user {$User}"
            if ($TeamsUpgradePolicy -eq 'Global')
            {
                $TeamsUpgradePolicy = $null
            }
            Grant-CsTeamsUpgradePolicy -Identity $User -PolicyName $TeamsUpgradePolicy | Out-Null
        }
        if ($null -ne $TenantDialPlan -and $TenantDialPlan -ne $currentInstance.TenantDialPlan)
        {
            Write-Verbose -Message "Assigning the Tenant Dial Plan {$TenantDialPlan} to user {$User}"
            if ($TenantDialPlan -eq 'Global')
            {
                $TenantDialPlan = $null
            }
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
