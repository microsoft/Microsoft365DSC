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
        $AllowAnnotations,

        [Parameter()]
        [System.Boolean]
        $AllowAnonymousUsersToDialOut,

        [Parameter()]
        [System.Boolean]
        $AllowAnonymousUsersToJoinMeeting,

        [Parameter()]
        [System.Boolean]
        $AllowAnonymousUsersToStartMeeting,

        [Parameter()]
        [System.Boolean]
        $AllowBreakoutRooms,

        [Parameter()]
        [System.String]
        [ValidateSet('EnabledUserOverride', 'DisabledUserOverride', 'Disabled')]
        $AllowCartCaptionsScheduling,

        [Parameter()]
        [System.Boolean]
        $AllowChannelMeetingScheduling,

        [Parameter()]
        [System.Boolean]
        $AllowCloudRecording,

        [Parameter()]
        [System.String]
        $AllowDocumentCollaboration,

        [Parameter()]
        [System.String]
        $AllowedStreamingMediaInput,

        [Parameter()]
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $AllowEngagementReport = 'Disabled',

        [Parameter()]
        [System.Boolean]
        $AllowExternalParticipantGiveRequestControl,

        [Parameter()]
        [System.Boolean]
        $AllowIPAudio,

        [Parameter()]
        [System.Boolean]
        $AllowIPVideo,

        [Parameter()]
        [System.Boolean]
        $AllowMeetingCoach,

        [Parameter()]
        [System.Boolean]
        $AllowMeetingReactions,

        [Parameter()]
        [System.Boolean]
        $AllowMeetingRegistration,

        [Parameter()]
        [System.Boolean]
        $AllowMeetNow,

        [Parameter()]
        [System.Boolean]
        $AllowNDIStreaming,

        [Parameter()]
        [System.Boolean]
        $AllowNetworkConfigurationSettingsLookup,

        [Parameter()]
        [System.Boolean]
        $AllowOrganizersToOverrideLobbySettings,

        [Parameter()]
        [System.Boolean]
        $AllowOutlookAddIn,

        [Parameter()]
        [System.Boolean]
        $AllowParticipantGiveRequestControl,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateMeetNow,

        [Parameter()]
        [System.Boolean]
        $AllowPowerPointSharing,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateMeetingScheduling,

        [Parameter()]
        [System.Boolean]
        $AllowPSTNUsersToBypassLobby,

        [Parameter()]
        [System.Boolean]
        $AllowRecordingStorageOutsideRegion,

        [Parameter()]
        [System.Boolean]
        $AllowSharedNotes,

        [Parameter()]
        [System.Boolean]
        $AllowTranscription,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'FederatedOnly', 'Disabled')]
        $AllowUserToJoinExternalMeeting,

        [Parameter()]
        [System.Boolean]
        $AllowWatermarkForCameraVideo,

        [Parameter()]
        [System.Boolean]
        $AllowWatermarkForScreenSharing,

        [Parameter()]
        [System.Boolean]
        $AllowWhiteboard,

        [Parameter()]
        [System.String]
        [ValidateSet('EveryoneInCompany', 'Everyone', 'EveryoneInSameAndFederatedCompany', 'OrganizerOnly', 'InvitedUsers', 'EveryoneInCompanyExcludingGuests')]
        $AutoAdmittedUsers,

        [Parameter()]
        [System.String]
        $BlockedAnonymousJoinClientTypes,

        [Parameter()]
        [System.String]
        $ChannelRecordingDownload,

        [Parameter()]
        [ValidateSet('OrganizerOnlyUserOverride', 'EveryoneInCompanyUserOverride', 'EveryoneUserOverride')]
        [System.String]
        $DesignatedPresenterRoleMode = 'EveryoneUserOverride',

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $EnrollUserOverride = 'Disabled',

        [Parameter()]
        [System.String]
        $ExplicitRecordingConsent,

        [Parameter()]
        [System.String]
        $ForceStreamingAttendeeMode,

        [Parameter()]
        [System.String]
        $InfoShownInReportMode,

        [Parameter()]
        [ValidateSet('EnabledOutgoingIncoming', 'Disabled')]
        [System.String]
        $IPAudioMode = 'EnabledOutgoingIncoming',

        [Parameter()]
        [ValidateSet('EnabledOutgoingIncoming', 'Disabled')]
        [System.String]
        $IPVideoMode = 'EnabledOutgoingIncoming',

        [Parameter()]
        [ValidateSet('Disabled', 'DisabledUserOverride')]
        [System.String]
        $LiveCaptionsEnabledType = 'DisabledUserOverride',

        [Parameter()]
        [System.String]
        $LiveInterpretationEnabledType,

        [Parameter()]
        [System.String]
        [ValidateSet('Disabled', 'Enabled')]
        $LiveStreamingMode,

        [Parameter()]
        [System.UInt32]
        $MediaBitRateKb,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $MeetingChatEnabledType = 'Enabled',

        [Parameter()]
        [System.String]
        $MeetingInviteLanguages,

        [Parameter()]
        [System.Int32]
        [ValidateRange(-1, 99999)]
        $NewMeetingRecordingExpirationDays,

        [Parameter()]
        [System.String]
        [ValidateSet('TeamsAndSfb', 'Teams')]
        $PreferredMeetingProviderForIslandsMode,

        [Parameter()]
        [System.String]
        $QnAEngagementMode,

        [Parameter()]
        [ValidateSet('Off', 'Distinguish', 'Attribute')]
        [System.String]
        $RoomAttributeUserOverride = 'Off',

        [Parameter()]
        [System.String]
        $RoomPeopleNameUserOverride,

        [Parameter()]
        [System.String]
        [ValidateSet('SingleApplication', 'EntireScreen', 'Disabled')]
        $ScreenSharingMode,

        [Parameter()]
        [System.String]
        [ValidateSet('Disabled', 'EnabledUserOverride')]
        $SpeakerAttributionMode,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $StreamingAttendeeMode = 'Enabled',

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $TeamsCameraFarEndPTZMode,

        [Parameter()]
        [System.String]
        [ValidateSet('NoFilters', 'BlurOnly', 'BlurAndDefaultBackgrounds', 'AllFilters')]
        $VideoFiltersMode,

        [Parameter()]
        [ValidateSet('Everyone', 'EveryoneInCompany')]
        [System.String]
        $WhoCanRegister,

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
        $ManagedIdentity
    )

    Write-Verbose -Message "Getting the Teams Meeting Policy $($Identity)"

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
            AllowAnnotations                           = $policy.AllowAnnotations
            AllowAnonymousUsersToDialOut               = $policy.AllowAnonymousUsersToDialOut
            AllowAnonymousUsersToJoinMeeting           = $policy.AllowAnonymousUsersToJoinMeeting
            AllowAnonymousUsersToStartMeeting          = $policy.AllowAnonymousUsersToStartMeeting
            AllowBreakoutRooms                         = $policy.AllowBreakoutRooms
            AllowCartCaptionsScheduling                = $policy.AllowCartCaptionsScheduling
            AllowChannelMeetingScheduling              = $policy.AllowChannelMeetingScheduling
            AllowCloudRecording                        = $policy.AllowCloudRecording
            AllowDocumentCollaboration                 = $policy.AllowDocumentCollaboration
            AllowedStreamingMediaInput                 = $policy.AllowedStreamingMediaInput
            AllowEngagementReport                      = $policy.AllowEngagementReport
            AllowExternalParticipantGiveRequestControl = $policy.AllowExternalParticipantGiveRequestControl
            AllowIPAudio                               = $policy.AllowIPAudio
            AllowIPVideo                               = $policy.AllowIPVideo
            AllowMeetingCoach                          = $policy.AllowMeetingCoach
            AllowMeetingReactions                      = $policy.AllowMeetingReactions
            AllowMeetingRegistration                   = $policy.AllowMeetingRegistration
            AllowMeetNow                               = $policy.AllowMeetNow
            AllowNDIStreaming                          = $policy.AllowNDIStreaming
            AllowNetworkConfigurationSettingsLookup    = $policy.AllowNetworkConfigurationSettingsLookup
            AllowOrganizersToOverrideLobbySettings     = $policy.AllowOrganizersToOverrideLobbySettings
            AllowOutlookAddIn                          = $policy.AllowOutlookAddIn
            AllowParticipantGiveRequestControl         = $policy.AllowParticipantGiveRequestControl
            AllowPowerPointSharing                     = $policy.AllowPowerPointSharing
            AllowPrivateMeetingScheduling              = $policy.AllowPrivateMeetingScheduling
            AllowPrivateMeetNow                        = $policy.AllowPrivateMeetNow
            AllowPSTNUsersToBypassLobby                = $policy.AllowPSTNUsersToBypassLobby
            AllowRecordingStorageOutsideRegion         = $policy.AllowRecordingStorageOutsideRegion
            AllowSharedNotes                           = $policy.AllowSharedNotes
            AllowTranscription                         = $policy.AllowTranscription
            AllowUserToJoinExternalMeeting             = $policy.AllowUserToJoinExternalMeeting
            AllowWatermarkForCameraVideo               = $policy.AllowWatermarkForCameraVideo
            AllowWatermarkForScreenSharing             = $policy.AllowWatermarkForScreenSharing
            AllowWhiteboard                            = $policy.AllowWhiteboard
            AutoAdmittedUsers                          = $policy.AutoAdmittedUsers
            BlockedAnonymousJoinClientTypes            = $policy.BlockedAnonymousJoinClientTypes
            ChannelRecordingDownload                   = $policy.ChannelRecordingDownload
            DesignatedPresenterRoleMode                = $policy.DesignatedPresenterRoleMode
            EnrollUserOverride                         = $policy.EnrollUserOverride
            ExplicitRecordingConsent                   = $policy.ExplicitRecordingConsent
            ForceStreamingAttendeeMode                 = $policy.ForceStreamingAttendeeMode
            InfoShownInReportMode                      = $policy.InfoShownInReportMode
            IPAudioMode                                = $policy.IPAudioMode
            IPVideoMode                                = $policy.IPVideoMode
            LiveCaptionsEnabledType                    = $policy.LiveCaptionsEnabledType
            LiveInterpretationEnabledType              = $policy.LiveInterpretationEnabledType
            LiveStreamingMode                          = $policy.LiveStreamingMode
            MediaBitRateKb                             = $policy.MediaBitRateKb
            MeetingChatEnabledType                     = $policy.MeetingChatEnabledType
            MeetingInviteLanguages                     = $policy.MeetingInviteLanguages
            NewMeetingRecordingExpirationDays          = $policy.NewMeetingRecordingExpirationDays
            PreferredMeetingProviderForIslandsMode     = $policy.PreferredMeetingProviderForIslandsMode
            QnAEngagementMode                          = $policy.QnAEngagementMode
            RoomPeopleNameUserOverride                 = $policy.RoomPeopleNameUserOverride
            ScreenSharingMode                          = $policy.ScreenSharingMode
            SpeakerAttributionMode                     = $policy.SpeakerAttributionMode
            StreamingAttendeeMode                      = $policy.StreamingAttendeeMode
            VideoFiltersMode                           = $policy.VideoFiltersMode
            TeamsCameraFarEndPTZMode                   = $policy.TeamsCameraFarEndPTZMode
            WhoCanRegister                             = $policy.WhoCanRegister
            Ensure                                     = 'Present'
            Credential                                 = $Credential
            ApplicationId                              = $ApplicationId
            TenantId                                   = $TenantId
            CertificateThumbprint                      = $CertificateThumbprint
            ManagedIdentity                            = $ManagedIdentity.IsPresent
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
        $AllowAnnotations,

        [Parameter()]
        [System.Boolean]
        $AllowAnonymousUsersToDialOut,

        [Parameter()]
        [System.Boolean]
        $AllowAnonymousUsersToJoinMeeting,

        [Parameter()]
        [System.Boolean]
        $AllowAnonymousUsersToStartMeeting,

        [Parameter()]
        [System.Boolean]
        $AllowBreakoutRooms,

        [Parameter()]
        [System.String]
        [ValidateSet('EnabledUserOverride', 'DisabledUserOverride', 'Disabled')]
        $AllowCartCaptionsScheduling,

        [Parameter()]
        [System.Boolean]
        $AllowChannelMeetingScheduling,

        [Parameter()]
        [System.Boolean]
        $AllowCloudRecording,

        [Parameter()]
        [System.String]
        $AllowDocumentCollaboration,

        [Parameter()]
        [System.String]
        $AllowedStreamingMediaInput,

        [Parameter()]
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $AllowEngagementReport = 'Disabled',

        [Parameter()]
        [System.Boolean]
        $AllowExternalParticipantGiveRequestControl,

        [Parameter()]
        [System.Boolean]
        $AllowIPAudio,

        [Parameter()]
        [System.Boolean]
        $AllowIPVideo,

        [Parameter()]
        [System.Boolean]
        $AllowMeetingCoach,

        [Parameter()]
        [System.Boolean]
        $AllowMeetingReactions,

        [Parameter()]
        [System.Boolean]
        $AllowMeetingRegistration,

        [Parameter()]
        [System.Boolean]
        $AllowMeetNow,

        [Parameter()]
        [System.Boolean]
        $AllowNDIStreaming,

        [Parameter()]
        [System.Boolean]
        $AllowNetworkConfigurationSettingsLookup,

        [Parameter()]
        [System.Boolean]
        $AllowOrganizersToOverrideLobbySettings,

        [Parameter()]
        [System.Boolean]
        $AllowOutlookAddIn,

        [Parameter()]
        [System.Boolean]
        $AllowParticipantGiveRequestControl,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateMeetNow,

        [Parameter()]
        [System.Boolean]
        $AllowPowerPointSharing,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateMeetingScheduling,

        [Parameter()]
        [System.Boolean]
        $AllowPSTNUsersToBypassLobby,

        [Parameter()]
        [System.Boolean]
        $AllowRecordingStorageOutsideRegion,

        [Parameter()]
        [System.Boolean]
        $AllowSharedNotes,

        [Parameter()]
        [System.Boolean]
        $AllowTranscription,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'FederatedOnly', 'Disabled')]
        $AllowUserToJoinExternalMeeting,

        [Parameter()]
        [System.Boolean]
        $AllowWatermarkForCameraVideo,

        [Parameter()]
        [System.Boolean]
        $AllowWatermarkForScreenSharing,

        [Parameter()]
        [System.Boolean]
        $AllowWhiteboard,

        [Parameter()]
        [System.String]
        [ValidateSet('EveryoneInCompany', 'Everyone', 'EveryoneInSameAndFederatedCompany', 'OrganizerOnly', 'InvitedUsers', 'EveryoneInCompanyExcludingGuests')]
        $AutoAdmittedUsers,

        [Parameter()]
        [System.String]
        $BlockedAnonymousJoinClientTypes,

        [Parameter()]
        [System.String]
        $ChannelRecordingDownload,

        [Parameter()]
        [ValidateSet('OrganizerOnlyUserOverride', 'EveryoneInCompanyUserOverride', 'EveryoneUserOverride')]
        [System.String]
        $DesignatedPresenterRoleMode = 'EveryoneUserOverride',

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $EnrollUserOverride = 'Disabled',

        [Parameter()]
        [System.String]
        $ExplicitRecordingConsent,

        [Parameter()]
        [System.String]
        $ForceStreamingAttendeeMode,

        [Parameter()]
        [System.String]
        $InfoShownInReportMode,

        [Parameter()]
        [ValidateSet('EnabledOutgoingIncoming', 'Disabled')]
        [System.String]
        $IPAudioMode = 'EnabledOutgoingIncoming',

        [Parameter()]
        [ValidateSet('EnabledOutgoingIncoming', 'Disabled')]
        [System.String]
        $IPVideoMode = 'EnabledOutgoingIncoming',

        [Parameter()]
        [ValidateSet('Disabled', 'DisabledUserOverride')]
        [System.String]
        $LiveCaptionsEnabledType = 'DisabledUserOverride',

        [Parameter()]
        [System.String]
        $LiveInterpretationEnabledType,

        [Parameter()]
        [System.String]
        [ValidateSet('Disabled', 'Enabled')]
        $LiveStreamingMode,

        [Parameter()]
        [System.UInt32]
        $MediaBitRateKb,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $MeetingChatEnabledType = 'Enabled',

        [Parameter()]
        [System.String]
        $MeetingInviteLanguages,

        [Parameter()]
        [System.Int32]
        [ValidateRange(-1, 99999)]
        $NewMeetingRecordingExpirationDays,

        [Parameter()]
        [System.String]
        [ValidateSet('TeamsAndSfb', 'Teams')]
        $PreferredMeetingProviderForIslandsMode,

        [Parameter()]
        [System.String]
        $QnAEngagementMode,

        [Parameter()]
        [ValidateSet('Off', 'Distinguish', 'Attribute')]
        [System.String]
        $RoomAttributeUserOverride = 'Off',

        [Parameter()]
        [System.String]
        $RoomPeopleNameUserOverride,

        [Parameter()]
        [System.String]
        [ValidateSet('SingleApplication', 'EntireScreen', 'Disabled')]
        $ScreenSharingMode,

        [Parameter()]
        [System.String]
        [ValidateSet('Disabled', 'EnabledUserOverride')]
        $SpeakerAttributionMode,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $StreamingAttendeeMode = 'Enabled',

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $TeamsCameraFarEndPTZMode,

        [Parameter()]
        [System.String]
        [ValidateSet('NoFilters', 'BlurOnly', 'BlurAndDefaultBackgrounds', 'AllFilters')]
        $VideoFiltersMode,

        [Parameter()]
        [ValidateSet('Everyone', 'EveryoneInCompany')]
        [System.String]
        $WhoCanRegister,

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
        $ManagedIdentity
    )

    Write-Verbose -Message 'Setting Teams Meeting Policy'

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
    $SetParameters.Remove('Verbose') | Out-Null # Needs to be implicitly removed for the cmdlet to work

    if ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating a new Teams Meeting Policy {$Identity}"

        # The AllowAnonymousUsersToDialOut is temporarly disabled. Therefore
        # we can't create or update a policy with it and it needs to be removed;
        $SetParameters.Remove('AllowAnonymousUsersToDialOut') | Out-Null

        # TEMPORARLY REMOVINGif ($SetParameters.ContainsKey('AllowAnonymousUsersToDialOut'))
        if ($SetParameters.ContainsKey('AllowIPVideo'))
        {
            $SetParameters.Remove('AllowIPVideo') | Out-Null
        }
        Write-Verbose -Message "Creating new Policy with Values: $(Convert-M365DscHashtableToString -Hashtable $SetParameters)"
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
        $AllowAnnotations,

        [Parameter()]
        [System.Boolean]
        $AllowAnonymousUsersToDialOut,

        [Parameter()]
        [System.Boolean]
        $AllowAnonymousUsersToJoinMeeting,

        [Parameter()]
        [System.Boolean]
        $AllowAnonymousUsersToStartMeeting,

        [Parameter()]
        [System.Boolean]
        $AllowBreakoutRooms,

        [Parameter()]
        [System.String]
        [ValidateSet('EnabledUserOverride', 'DisabledUserOverride', 'Disabled')]
        $AllowCartCaptionsScheduling,

        [Parameter()]
        [System.Boolean]
        $AllowChannelMeetingScheduling,

        [Parameter()]
        [System.Boolean]
        $AllowCloudRecording,

        [Parameter()]
        [System.String]
        $AllowDocumentCollaboration,

        [Parameter()]
        [System.String]
        $AllowedStreamingMediaInput,

        [Parameter()]
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $AllowEngagementReport = 'Disabled',

        [Parameter()]
        [System.Boolean]
        $AllowExternalParticipantGiveRequestControl,

        [Parameter()]
        [System.Boolean]
        $AllowIPAudio,

        [Parameter()]
        [System.Boolean]
        $AllowIPVideo,

        [Parameter()]
        [System.Boolean]
        $AllowMeetingCoach,

        [Parameter()]
        [System.Boolean]
        $AllowMeetingReactions,

        [Parameter()]
        [System.Boolean]
        $AllowMeetingRegistration,

        [Parameter()]
        [System.Boolean]
        $AllowMeetNow,

        [Parameter()]
        [System.Boolean]
        $AllowNDIStreaming,

        [Parameter()]
        [System.Boolean]
        $AllowNetworkConfigurationSettingsLookup,

        [Parameter()]
        [System.Boolean]
        $AllowOrganizersToOverrideLobbySettings,

        [Parameter()]
        [System.Boolean]
        $AllowOutlookAddIn,

        [Parameter()]
        [System.Boolean]
        $AllowParticipantGiveRequestControl,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateMeetNow,

        [Parameter()]
        [System.Boolean]
        $AllowPowerPointSharing,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateMeetingScheduling,

        [Parameter()]
        [System.Boolean]
        $AllowPSTNUsersToBypassLobby,

        [Parameter()]
        [System.Boolean]
        $AllowRecordingStorageOutsideRegion,

        [Parameter()]
        [System.Boolean]
        $AllowSharedNotes,

        [Parameter()]
        [System.Boolean]
        $AllowTranscription,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'FederatedOnly', 'Disabled')]
        $AllowUserToJoinExternalMeeting,

        [Parameter()]
        [System.Boolean]
        $AllowWatermarkForCameraVideo,

        [Parameter()]
        [System.Boolean]
        $AllowWatermarkForScreenSharing,

        [Parameter()]
        [System.Boolean]
        $AllowWhiteboard,

        [Parameter()]
        [System.String]
        [ValidateSet('EveryoneInCompany', 'Everyone', 'EveryoneInSameAndFederatedCompany', 'OrganizerOnly', 'InvitedUsers', 'EveryoneInCompanyExcludingGuests')]
        $AutoAdmittedUsers,

        [Parameter()]
        [System.String]
        $BlockedAnonymousJoinClientTypes,

        [Parameter()]
        [System.String]
        $ChannelRecordingDownload,

        [Parameter()]
        [ValidateSet('OrganizerOnlyUserOverride', 'EveryoneInCompanyUserOverride', 'EveryoneUserOverride')]
        [System.String]
        $DesignatedPresenterRoleMode = 'EveryoneUserOverride',

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $EnrollUserOverride = 'Disabled',

        [Parameter()]
        [System.String]
        $ExplicitRecordingConsent,

        [Parameter()]
        [System.String]
        $ForceStreamingAttendeeMode,

        [Parameter()]
        [System.String]
        $InfoShownInReportMode,

        [Parameter()]
        [ValidateSet('EnabledOutgoingIncoming', 'Disabled')]
        [System.String]
        $IPAudioMode = 'EnabledOutgoingIncoming',

        [Parameter()]
        [ValidateSet('EnabledOutgoingIncoming', 'Disabled')]
        [System.String]
        $IPVideoMode = 'EnabledOutgoingIncoming',

        [Parameter()]
        [ValidateSet('Disabled', 'DisabledUserOverride')]
        [System.String]
        $LiveCaptionsEnabledType = 'DisabledUserOverride',

        [Parameter()]
        [System.String]
        $LiveInterpretationEnabledType,

        [Parameter()]
        [System.String]
        [ValidateSet('Disabled', 'Enabled')]
        $LiveStreamingMode,

        [Parameter()]
        [System.UInt32]
        $MediaBitRateKb,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $MeetingChatEnabledType = 'Enabled',

        [Parameter()]
        [System.String]
        $MeetingInviteLanguages,

        [Parameter()]
        [System.Int32]
        [ValidateRange(-1, 99999)]
        $NewMeetingRecordingExpirationDays,

        [Parameter()]
        [System.String]
        [ValidateSet('TeamsAndSfb', 'Teams')]
        $PreferredMeetingProviderForIslandsMode,

        [Parameter()]
        [System.String]
        $QnAEngagementMode,

        [Parameter()]
        [ValidateSet('Off', 'Distinguish', 'Attribute')]
        [System.String]
        $RoomAttributeUserOverride = 'Off',

        [Parameter()]
        [System.String]
        $RoomPeopleNameUserOverride,

        [Parameter()]
        [System.String]
        [ValidateSet('SingleApplication', 'EntireScreen', 'Disabled')]
        $ScreenSharingMode,

        [Parameter()]
        [System.String]
        [ValidateSet('Disabled', 'EnabledUserOverride')]
        $SpeakerAttributionMode,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $StreamingAttendeeMode = 'Enabled',

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $TeamsCameraFarEndPTZMode,

        [Parameter()]
        [System.String]
        [ValidateSet('NoFilters', 'BlurOnly', 'BlurAndDefaultBackgrounds', 'AllFilters')]
        $VideoFiltersMode,

        [Parameter()]
        [ValidateSet('Everyone', 'EveryoneInCompany')]
        [System.String]
        $WhoCanRegister,

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
        $ManagedIdentity
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

    Write-Verbose -Message "Testing configuration of Team Meeting Policy {$Identity}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters

    # The AllowAnonymousUsersToDialOut is temporarly disabled. Therefore
    # we can't create or update a policy with it and it needs to be removed;
    $ValuesToCheck.Remove('AllowAnonymousUsersToDialOut') | Out-Null

    # The AllowIPVideo is temporarly not working, therefore we won't check the value.
    $ValuesToCheck.Remove('AllowIPVideo') | Out-Null

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
        $ManagedIdentity
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
        [array]$policies = Get-CsTeamsMeetingPolicy -ErrorAction Stop
        $dscContent = ''
        Write-Host "`r`n" -NoNewline
        foreach ($policy in $policies)
        {
            Write-Host "    |---[$i/$($policies.Count)] $($policy.Identity)" -NoNewline
            $params = @{
                Identity              = $policy.Identity
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
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

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
