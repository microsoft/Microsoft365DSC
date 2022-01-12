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
        $AllowChannelMeetingScheduling,

        [Parameter()]
        [System.Boolean]
        $AllowMeetNow,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateMeetNow,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $MeetingChatEnabledType = 'Enabled',

        [Parameter()]
        [ValidateSet('Disabled', 'DisabledUserOverride')]
        [System.String]
        $LiveCaptionsEnabledType = 'DisabledUserOverride',

        [Parameter()]
        [ValidateSet('OrganizerOnlyUserOverride', 'EveryoneInCompanyUserOverride', 'EveryoneUserOverride')]
        [System.String]
        $DesignatedPresenterRoleMode = 'EveryoneUserOverride',

        [Parameter()]
        [System.Boolean]
        $AllowIPAudio,

        [Parameter()]
        [System.Boolean]
        $AllowIPVideo,

        [Parameter()]
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $AllowEngagementReport = 'Disabled',

        [Parameter()]
        [ValidateSet('EnabledOutgoingIncoming', 'Disabled')]
        [System.String]
        $IPAudioMode = 'EnabledOutgoingIncoming',

        [Parameter()]
        [ValidateSet('EnabledOutgoingIncoming', 'Disabled')]
        [System.String]
        $IPVideoMode = 'EnabledOutgoingIncoming',

        [Parameter()]
        [System.Boolean]
        $AllowAnonymousUsersToDialOut,

        [Parameter()]
        [System.Boolean]
        $AllowAnonymousUsersToStartMeeting,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateMeetingScheduling,

        [Parameter()]
        [System.String]
        [ValidateSet('EveryoneInCompany', 'Everyone', 'EveryoneInSameAndFederatedCompany', 'OrganizerOnly', 'InvitedUsers', 'EveryoneInCompanyExcludingGuests')]
        $AutoAdmittedUsers,

        [Parameter()]
        [System.Boolean]
        $AllowCloudRecording,

        [Parameter()]
        [System.Boolean]
        $AllowRecordingStorageOutsideRegion,

        [Parameter()]
        [System.String]
        [ValidateSet('Stream', 'OneDriveForBusiness')]
        $RecordingStorageMode,

        [Parameter()]
        [System.Boolean]
        $AllowOutlookAddIn,

        [Parameter()]
        [System.Boolean]
        $AllowPowerPointSharing,

        [Parameter()]
        [System.Boolean]
        $AllowParticipantGiveRequestControl,

        [Parameter()]
        [System.Boolean]
        $AllowExternalParticipantGiveRequestControl,

        [Parameter()]
        [System.Boolean]
        $AllowSharedNotes,

        [Parameter()]
        [System.Boolean]
        $AllowWhiteboard,

        [Parameter()]
        [System.Boolean]
        $AllowTranscription,

        [Parameter()]
        [System.UInt32]
        $MediaBitRateKb,

        [Parameter()]
        [System.String]
        [ValidateSet('SingleApplication', 'EntireScreen', 'Disabled')]
        $ScreenSharingMode,

        [Parameter()]
        [System.String]
        [ValidateSet('NoFilters', 'BlurOnly', 'BlurAndDefaultBackgrounds', 'AllFilters')]
        $VideoFiltersMode,

        [Parameter()]
        [System.Boolean]
        $AllowPSTNUsersToBypassLobby,

        [Parameter()]
        [System.Boolean]
        $AllowOrganizersToOverrideLobbySettings,

        [Parameter()]
        [System.String]
        [ValidateSet('TeamsAndSfb', 'Teams')]
        $PreferredMeetingProviderForIslandsMode,

        [Parameter()]
        [System.Boolean]
        $AllowNDIStreaming,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'FederatedOnly', 'Disabled')]
        $AllowUserToJoinExternalMeeting,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $EnrollUserOverride = 'Disabled',

        [Parameter()]
        [ValidateSet('Off', 'Distinguish', 'Attribute')]
        [System.String]
        $RoomAttributeUserOverride = 'Off',

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $StreamingAttendeeMode = 'Enabled',

        [Parameter()]
        [System.Boolean]
        $AllowBreakoutRooms,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $TeamsCameraFarEndPTZMode,

        [Parameter()]
        [System.Boolean]
        $AllowMeetingReactions,

        [Parameter()]
        [ValidateSet('Everyone', 'EveryoneInCompany')]
        [System.String]
        $WhoCanRegister,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    Write-Verbose -Message "Getting the Teams Meeting Policy $($Identity)"

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
    $nullReturn.Ensure = 'Absent'
    try
    {
        $policy = Get-CsTeamsMeetingPolicy -Identity $Identity `
            -ErrorAction 'SilentlyContinue'

        if ($null -eq $policy)
        {
            Write-Verbose -Message "Could not find Teams Meeting Policy ${$Identity}"
            return $nullReturn
        }
        Write-Verbose -Message "Found Teams Meeting Policy {$Identity}"
        return @{
            Identity                                   = $Identity
            Description                                = $policy.Description
            AllowChannelMeetingScheduling              = $policy.AllowChannelMeetingScheduling
            AllowMeetNow                               = $policy.AllowMeetNow
            AllowPrivateMeetNow                        = $policy.AllowPrivateMeetNow
            MeetingChatEnabledType                     = $policy.MeetingChatEnabledType
            LiveCaptionsEnabledType                    = $policy.LiveCaptionsEnabledType
            DesignatedPresenterRoleMode                = $policy.DesignatedPresenterRoleMode
            AllowIPAudio                               = $policy.AllowIPAudio
            AllowIPVideo                               = $policy.AllowIPVideo
            AllowEngagementReport                      = $policy.AllowEngagementReport
            IPAudioMode                                = $policy.IPAudioMode
            IPVideoMode                                = $policy.IPVideoMode
            AllowAnonymousUsersToDialOut               = $policy.AllowAnonymousUsersToDialOut
            AllowAnonymousUsersToStartMeeting          = $policy.AllowAnonymousUsersToStartMeeting
            AllowPrivateMeetingScheduling              = $policy.AllowPrivateMeetingScheduling
            AutoAdmittedUsers                          = $policy.AutoAdmittedUsers
            AllowCloudRecording                        = $policy.AllowCloudRecording
            AllowRecordingStorageOutsideRegion         = $policy.AllowRecordingStorageOutsideRegion
            RecordingStorageMode                       = $policy.RecordingStorageMode
            AllowOutlookAddIn                          = $policy.AllowOutlookAddIn
            AllowPowerPointSharing                     = $policy.AllowPowerPointSharing
            AllowParticipantGiveRequestControl         = $policy.AllowParticipantGiveRequestControl
            AllowExternalParticipantGiveRequestControl = $policy.AllowExternalParticipantGiveRequestControl
            AllowSharedNotes                           = $policy.AllowSharedNotes
            AllowWhiteboard                            = $policy.AllowWhiteboard
            AllowTranscription                         = $policy.AllowTranscription
            MediaBitRateKb                             = $policy.MediaBitRateKb
            ScreenSharingMode                          = $policy.ScreenSharingMode
            VideoFiltersMode                           = $policy.VideoFiltersMode
            AllowPSTNUsersToBypassLobby                = $policy.AllowPSTNUsersToBypassLobby
            AllowOrganizersToOverrideLobbySettings     = $policy.AllowOrganizersToOverrideLobbySettings
            PreferredMeetingProviderForIslandsMode     = $policy.PreferredMeetingProviderForIslandsMode
            AllowNDIStreaming                          = $policy.AllowNDIStreaming
            AllowUserToJoinExternalMeeting             = $policy.AllowUserToJoinExternalMeeting
            EnrollUserOverride                         = $policy.EnrollUserOverride
            StreamingAttendeeMode                      = $policy.StreamingAttendeeMode
            AllowBreakoutRooms                         = $policy.AllowBreakoutRooms
            TeamsCameraFarEndPTZMode                   = $policy.TeamsCameraFarEndPTZMode
            AllowMeetingReactions                      = $policy.AllowMeetingReactions
            WhoCanRegister                             = $policy.WhoCanRegister
            Ensure                                     = 'Present'
            Credential                                 = $Credential
        }
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ''
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
        $Description,

        [Parameter()]
        [System.Boolean]
        $AllowChannelMeetingScheduling,

        [Parameter()]
        [System.Boolean]
        $AllowMeetNow,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateMeetNow,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $MeetingChatEnabledType = 'Enabled',

        [Parameter()]
        [ValidateSet('Disabled', 'DisabledUserOverride')]
        [System.String]
        $LiveCaptionsEnabledType = 'DisabledUserOverride',

        [Parameter()]
        [ValidateSet('OrganizerOnlyUserOverride', 'EveryoneInCompanyUserOverride', 'EveryoneUserOverride')]
        [System.String]
        $DesignatedPresenterRoleMode = 'EveryoneUserOverride',

        [Parameter()]
        [System.Boolean]
        $AllowIPAudio,

        [Parameter()]
        [System.Boolean]
        $AllowIPVideo,

        [Parameter()]
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $AllowEngagementReport = 'Disabled',

        [Parameter()]
        [ValidateSet('EnabledOutgoingIncoming', 'Disabled')]
        [System.String]
        $IPAudioMode = 'EnabledOutgoingIncoming',

        [Parameter()]
        [ValidateSet('EnabledOutgoingIncoming', 'Disabled')]
        [System.String]
        $IPVideoMode = 'EnabledOutgoingIncoming',

        [Parameter()]
        [System.Boolean]
        $AllowAnonymousUsersToDialOut,

        [Parameter()]
        [System.Boolean]
        $AllowAnonymousUsersToStartMeeting,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateMeetingScheduling,

        [Parameter()]
        [System.String]
        [ValidateSet('EveryoneInCompany', 'Everyone', 'EveryoneInSameAndFederatedCompany', 'OrganizerOnly', 'InvitedUsers', 'EveryoneInCompanyExcludingGuests')]
        $AutoAdmittedUsers,

        [Parameter()]
        [System.Boolean]
        $AllowCloudRecording,

        [Parameter()]
        [System.Boolean]
        $AllowRecordingStorageOutsideRegion,

        [Parameter()]
        [System.String]
        [ValidateSet('Stream', 'OneDriveForBusiness')]
        $RecordingStorageMode,

        [Parameter()]
        [System.Boolean]
        $AllowOutlookAddIn,

        [Parameter()]
        [System.Boolean]
        $AllowPowerPointSharing,

        [Parameter()]
        [System.Boolean]
        $AllowParticipantGiveRequestControl,

        [Parameter()]
        [System.Boolean]
        $AllowExternalParticipantGiveRequestControl,

        [Parameter()]
        [System.Boolean]
        $AllowSharedNotes,

        [Parameter()]
        [System.Boolean]
        $AllowWhiteboard,

        [Parameter()]
        [System.Boolean]
        $AllowTranscription,

        [Parameter()]
        [System.UInt32]
        $MediaBitRateKb,

        [Parameter()]
        [System.String]
        [ValidateSet('SingleApplication', 'EntireScreen', 'Disabled')]
        $ScreenSharingMode,

        [Parameter()]
        [System.String]
        [ValidateSet('NoFilters', 'BlurOnly', 'BlurAndDefaultBackgrounds', 'AllFilters')]
        $VideoFiltersMode,

        [Parameter()]
        [System.Boolean]
        $AllowPSTNUsersToBypassLobby,

        [Parameter()]
        [System.Boolean]
        $AllowOrganizersToOverrideLobbySettings,

        [Parameter()]
        [System.String]
        [ValidateSet('TeamsAndSfb', 'Teams')]
        $PreferredMeetingProviderForIslandsMode,

        [Parameter()]
        [System.Boolean]
        $AllowNDIStreaming,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'FederatedOnly', 'Disabled')]
        $AllowUserToJoinExternalMeeting,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $EnrollUserOverride = 'Disabled',

        [Parameter()]
        [ValidateSet('Off', 'Distinguish', 'Attribute')]
        [System.String]
        $RoomAttributeUserOverride = 'Off',

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $StreamingAttendeeMode = 'Enabled',

        [Parameter()]
        [System.Boolean]
        $AllowBreakoutRooms,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $TeamsCameraFarEndPTZMode,

        [Parameter()]
        [System.Boolean]
        $AllowMeetingReactions,

        [Parameter()]
        [ValidateSet('Everyone', 'EveryoneInCompany')]
        [System.String]
        $WhoCanRegister,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    Write-Verbose -Message 'Setting Teams Meeting Policy'

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
    $SetParameters.Remove('Ensure') | Out-Null
    $SetParameters.Remove('Credential') | Out-Null

    if ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating a new Teams Meeting Policy {$Identity}"

        # The AllowAnonymousUsersToDialOut is temporarly disabled. Therefore
        # we can't create or update a policy with it and it needs to be removed;
        if ($SetParameters.ContainsKey('AllowAnonymousUsersToDialOut'))
        {
            $SetParameters.Remove('AllowAnonymousUsersToDialOut') | Out-Null
        }
        New-CsTeamsMeetingPolicy @SetParameters
    }
    elseif ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Present')
    {
        # If we get here, it's because the Test-TargetResource detected a drift, therefore we always call
        # into the Set-CsTeamsMeetingPolicy cmdlet.
        Write-Verbose -Message "Updating settings for Teams Meeting Policy {$Identity}"

        # The AllowAnonymousUsersToDialOut is temporarly disabled. Therefore
        # we can't create or update a policy with it and it needs to be removed;
        if ($SetParameters.ContainsKey('AllowAnonymousUsersToDialOut'))
        {
            $SetParameters.Remove('AllowAnonymousUsersToDialOut') | Out-Null
        }
        if ($SetParameters.AllowCloudRecording -eq $false )
        {
            $SetParameters.Remove('RecordingStorageMode')
            $SetParameters.Remove('AllowRecordingStorageOutsideRegion')
        }
        Set-CsTeamsMeetingPolicy @SetParameters
    }
    elseif ($Ensure -eq 'Absent' -and $CurrentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing existing Teams Meeting Policy {$Identity}"
        Remove-CsTeamsMeetingPolicy -Identity $Identity -Confirm:$false
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
        $AllowChannelMeetingScheduling,

        [Parameter()]
        [System.Boolean]
        $AllowMeetNow,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateMeetNow,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $MeetingChatEnabledType = 'Enabled',

        [Parameter()]
        [ValidateSet('Disabled', 'DisabledUserOverride')]
        [System.String]
        $LiveCaptionsEnabledType = 'DisabledUserOverride',

        [Parameter()]
        [ValidateSet('OrganizerOnlyUserOverride', 'EveryoneInCompanyUserOverride', 'EveryoneUserOverride')]
        [System.String]
        $DesignatedPresenterRoleMode = 'EveryoneUserOverride',

        [Parameter()]
        [System.Boolean]
        $AllowIPAudio,

        [Parameter()]
        [System.Boolean]
        $AllowIPVideo,

        [Parameter()]
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $AllowEngagementReport = 'Disabled',

        [Parameter()]
        [ValidateSet('EnabledOutgoingIncoming', 'Disabled')]
        [System.String]
        $IPAudioMode = 'EnabledOutgoingIncoming',

        [Parameter()]
        [ValidateSet('EnabledOutgoingIncoming', 'Disabled')]
        [System.String]
        $IPVideoMode = 'EnabledOutgoingIncoming',

        [Parameter()]
        [System.Boolean]
        $AllowAnonymousUsersToDialOut,

        [Parameter()]
        [System.Boolean]
        $AllowAnonymousUsersToStartMeeting,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateMeetingScheduling,

        [Parameter()]
        [System.String]
        [ValidateSet('EveryoneInCompany', 'Everyone', 'EveryoneInSameAndFederatedCompany', 'OrganizerOnly', 'InvitedUsers', 'EveryoneInCompanyExcludingGuests')]
        $AutoAdmittedUsers,

        [Parameter()]
        [System.Boolean]
        $AllowCloudRecording,

        [Parameter()]
        [System.Boolean]
        $AllowRecordingStorageOutsideRegion,

        [Parameter()]
        [System.String]
        [ValidateSet('Stream', 'OneDriveForBusiness')]
        $RecordingStorageMode,

        [Parameter()]
        [System.Boolean]
        $AllowOutlookAddIn,

        [Parameter()]
        [System.Boolean]
        $AllowPowerPointSharing,

        [Parameter()]
        [System.Boolean]
        $AllowParticipantGiveRequestControl,

        [Parameter()]
        [System.Boolean]
        $AllowExternalParticipantGiveRequestControl,

        [Parameter()]
        [System.Boolean]
        $AllowSharedNotes,

        [Parameter()]
        [System.Boolean]
        $AllowWhiteboard,

        [Parameter()]
        [System.Boolean]
        $AllowTranscription,

        [Parameter()]
        [System.UInt32]
        $MediaBitRateKb,

        [Parameter()]
        [System.String]
        [ValidateSet('SingleApplication', 'EntireScreen', 'Disabled')]
        $ScreenSharingMode,

        [Parameter()]
        [System.String]
        [ValidateSet('NoFilters', 'BlurOnly', 'BlurAndDefaultBackgrounds', 'AllFilters')]
        $VideoFiltersMode,

        [Parameter()]
        [System.Boolean]
        $AllowPSTNUsersToBypassLobby,

        [Parameter()]
        [System.Boolean]
        $AllowOrganizersToOverrideLobbySettings,

        [Parameter()]
        [System.String]
        [ValidateSet('TeamsAndSfb', 'Teams')]
        $PreferredMeetingProviderForIslandsMode,

        [Parameter()]
        [System.Boolean]
        $AllowNDIStreaming,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'FederatedOnly', 'Disabled')]
        $AllowUserToJoinExternalMeeting,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $EnrollUserOverride = 'Disabled',

        [Parameter()]
        [ValidateSet('Off', 'Distinguish', 'Attribute')]
        [System.String]
        $RoomAttributeUserOverride = 'Off',

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $StreamingAttendeeMode = 'Enabled',

        [Parameter()]
        [System.Boolean]
        $AllowBreakoutRooms,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $TeamsCameraFarEndPTZMode,

        [Parameter()]
        [System.Boolean]
        $AllowMeetingReactions,

        [Parameter()]
        [ValidateSet('Everyone', 'EveryoneInCompany')]
        [System.String]
        $WhoCanRegister,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
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

    Write-Verbose -Message "Testing configuration of Team Meeting Policy {$Identity}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null
    # The AllowAnonymousUsersToDialOut is temporarly disabled. Therefore
    # we can't create or update a policy with it and it needs to be removed;
    $ValuesToCheck.Remove('AllowAnonymousUsersToDialOut') | Out-Null


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
        $i = 1
        [array]$policies = Get-CsTeamsMeetingPolicy -ErrorAction Stop
        $dscContent = ''
        Write-Host "`r`n" -NoNewline
        foreach ($policy in $policies)
        {
            Write-Host "    |---[$i/$($policies.Count)] $($policy.Identity)" -NoNewline
            $params = @{
                Identity           = $policy.Identity
                Credential = $Credential
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
            Write-Host $Global:M365DSCEmojiGreenCheckmark
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
            $tenantIdValue = ''
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
        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
