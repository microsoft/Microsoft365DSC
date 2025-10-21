Confirm-M365DSCModuleDependency -ModuleName 'MSFT_TeamsMeetingPolicy'

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
        $AllowAvatarsInGallery,

        [Parameter()]
        [System.Boolean]
        $AllowBreakoutRooms,

        [Parameter()]
        [System.Boolean]
        $AllowCarbonSummary,

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
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $AllowDocumentCollaboration,

        [Parameter()]
        [System.String]
        $AllowedStreamingMediaInput,

        [Parameter()]
        [ValidateSet('Everyone', 'UsersAllowedToByPassTheLobby')]
        [System.String]
        $AllowedUsersForMeetingDetails,

        [Parameter()]
        [ValidateSet('Enabled', 'Disabled', 'ForceEnabled')]
        [System.String]
        $AllowEngagementReport = 'Disabled',

        [Parameter()]
        [System.Boolean]
        $AllowExternalNonTrustedMeetingChat,

        [Parameter()]
        [System.Boolean]
        $AllowExternalParticipantGiveRequestControl,

        [Parameter()]
        [System.Boolean]
        $AllowImmersiveView,

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
        $AllowPowerPointSharing,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateMeetingScheduling,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateMeetNow,

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
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $AllowTasksFromTranscript,

        [Parameter()]
        [System.Boolean]
        $AllowTranscription,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'FederatedOnly', 'Disabled')]
        $AllowUserToJoinExternalMeeting,

        [Parameter()]
        [System.Boolean]
        $AllowWatermarkCustomizationForCameraVideo,

        [Parameter()]
        [System.Boolean]
        $AllowWatermarkCustomizationForScreenSharing,

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
        [ValidateSet('None', 'OneTimePasscode')]
        [System.String]
        $AnonymousUserAuthenticationMethod,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled', 'DisabledUserOverride')]
        [System.String]
        $AttendeeIdentityMasking,

        [Parameter()]
        [ValidateSet('AllAttendees', 'PstnOnly')]
        [System.String]
        $AudibleRecordingNotification,

        [Parameter()]
        [System.String]
        [ValidateSet('EveryoneInCompany', 'Everyone', 'EveryoneInSameAndFederatedCompany', 'OrganizerOnly', 'InvitedUsers', 'EveryoneInCompanyExcludingGuests')]
        $AutoAdmittedUsers,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $AutomaticallyStartCopilot,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $AutoRecording,

        [Parameter()]
        [System.String]
        $BlockedAnonymousJoinClientTypes,

        [Parameter()]
        [System.String]
        $CaptchaVerificationForMeetingJoin,

        [Parameter()]
        [ValidateSet('Allow', 'Block')]
        [System.String]
        $ChannelRecordingDownload,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $ConnectToMeetingControls,

        [Parameter()]
        [ValidateSet('EnabledForAnyone', 'EnabledForTrustedOrgs', 'Disabled')]
        [System.String]
        $ContentSharingInExternalMeetings,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled', 'EnabledWithTranscript', 'EnabledWithTranscriptDefaultOn')]
        [System.String]
        $Copilot,

        [Parameter()]
        [System.Boolean]
        $CopyRestriction,

        [Parameter()]
        [ValidateSet('OrganizerOnlyUserOverride', 'EveryoneInCompanyUserOverride', 'EveryoneUserOverride')]
        [System.String]
        $DesignatedPresenterRoleMode = 'EveryoneUserOverride',

        [Parameter()]
        [System.Boolean]
        $DetectSensitiveContentDuringScreenSharing,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $EnrollUserOverride = 'Disabled',

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $ExplicitRecordingConsent,

        [Parameter()]
        [ValidateSet('EnabledForAnyone', 'EnabledForTrustedOrgs', 'Disabled')]
        [System.String]
        $ExternalMeetingJoin,

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
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $LobbyChat,

        [Parameter()]
        [System.UInt32]
        $MediaBitRateKb,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled', 'EnabledExceptAnonymous')]
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
        [ValidateSet('Disabled', 'Enabled', 'MicrosoftDefault')]
        [System.String]
        $NoiseSuppressionForDialInParticipants,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $ParticipantNameChange,

        [Parameter()]
        [ValidateSet('Everyone', 'EveryoneInOrganization', 'EveryoneInOrganizationAndGuests', 'None')]
        [System.String]
        $ParticipantSlideControl,

        [Parameter()]
        [System.String]
        [ValidateSet('TeamsAndSfb', 'Teams')]
        $PreferredMeetingProviderForIslandsMode,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $QnAEngagementMode,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $RealTimeText,

        [Parameter()]
        [ValidateSet('Off', 'Distinguish', 'Attribute')]
        [System.String]
        $RoomAttributeUserOverride = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On')]
        [System.String]
        $RoomPeopleNameUserOverride,

        [Parameter()]
        [System.String]
        [ValidateSet('SingleApplication', 'EntireScreen', 'Disabled')]
        $ScreenSharingMode,

        [Parameter()]
        [ValidateSet('OnAllowOrganizerOverride', 'OffAllowOrganizerOverride', 'Off')]
        [System.String]
        $SmsNotifications,

        [Parameter()]
        [System.String]
        [ValidateSet('Disabled', 'DisabledUserOverride', 'EnabledUserOverride', 'Enabled')]
        $SpeakerAttributionMode,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $StreamingAttendeeMode = 'Enabled',

        [Parameter()]
        [ValidateSet('Disabled', 'AutoAcceptInTenant', 'AutoAcceptAll')]
        [System.String]
        $TeamsCameraFarEndPTZMode,

        [Parameter()]
        [ValidateSet('OrganizerAndCoOrganizersOnly', 'OrganizersAndPresentersOnly')]
        [System.String]
        $UsersCanAdmitFromLobby,

        [Parameter()]
        [System.String]
        [ValidateSet('NoFilters', 'BlurOnly', 'BlurAndDefaultBackgrounds', 'AllFilters')]
        $VideoFiltersMode,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $VoiceIsolation,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $VoiceSimulationInInterpreter,

        [Parameter()]
        [ValidateSet('JoinWithAudioOnly', 'WatermarkWithDisplayName')]
        [System.String]
        $WatermarkForAnonymousUsers,

        [Parameter()]
        [ValidateRange(1, 100)]
        [System.Int64]
        $WatermarkForCameraVideoOpacity,

        [Parameter()]
        [ValidateSet('Single', 'Tiled')]
        [System.String]
        $WatermarkForCameraVideoPattern,

        [Parameter()]
        [ValidateRange(1, 100)]
        [System.Int64]
        $WatermarkForScreenSharingOpacity,

        [Parameter()]
        [ValidateSet('Single', 'Tiled')]
        [System.String]
        $WatermarkForScreenSharingPattern,

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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting the Teams Meeting Policy $($Identity)"

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

            $policy = Get-CsTeamsMeetingPolicy -Identity $Identity `
                -ErrorAction 'SilentlyContinue'
        }
        else
        {
            $policy = $Script:exportedInstance
        }

        if ($null -eq $policy)
        {
            Write-Verbose -Message "Could not find Teams Meeting Policy {$Identity}"
            return $nullReturn
        }
        Write-Verbose -Message "Found Teams Meeting Policy {$Identity}"
        return @{
            Identity                                   = $Identity
            Description                                = $policy.Description
            AIInterpreter                              = $policy.AIInterpreter
            AllowAnnotations                           = $policy.AllowAnnotations
            AllowAnonymousUsersToDialOut               = $policy.AllowAnonymousUsersToDialOut
            AllowAnonymousUsersToJoinMeeting           = $policy.AllowAnonymousUsersToJoinMeeting
            AllowAnonymousUsersToStartMeeting          = $policy.AllowAnonymousUsersToStartMeeting
            AllowAvatarsInGallery                      = $policy.AllowAvatarsInGallery
            AllowBreakoutRooms                         = $policy.AllowBreakoutRooms
            AllowCarbonSummary                         = $policy.AllowCarbonSummary
            AllowCartCaptionsScheduling                = $policy.AllowCartCaptionsScheduling
            AllowChannelMeetingScheduling              = $policy.AllowChannelMeetingScheduling
            AllowCloudRecording                        = $policy.AllowCloudRecording
            AllowDocumentCollaboration                 = $policy.AllowDocumentCollaboration
            AllowedStreamingMediaInput                 = $policy.AllowedStreamingMediaInput
            AllowedUsersForMeetingDetails              = $policy.AllowedUsersForMeetingDetails
            AllowEngagementReport                      = $policy.AllowEngagementReport
            AllowExternalNonTrustedMeetingChat         = $policy.AllowExternalNonTrustedMeetingChat
            AllowExternalParticipantGiveRequestControl = $policy.AllowExternalParticipantGiveRequestControl
            AllowImmersiveView                         = $policy.AllowImmersiveView
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
            AllowTasksFromTranscript                   = $policy.AllowTasksFromTranscript
            AllowTranscription                         = $policy.AllowTranscription
            AllowUserToJoinExternalMeeting             = $policy.AllowUserToJoinExternalMeeting
            AllowWatermarkCustomizationForCameraVideo  = $policy.AllowWatermarkCustomizationForCameraVideo
            AllowWatermarkCustomizationForScreenSharing = $policy.AllowWatermarkCustomizationForScreenSharing
            AllowWatermarkForCameraVideo               = $policy.AllowWatermarkForCameraVideo
            AllowWatermarkForScreenSharing             = $policy.AllowWatermarkForScreenSharing
            AllowWhiteboard                            = $policy.AllowWhiteboard
            AnonymousUserAuthenticationMethod          = $policy.AnonymousUserAuthenticationMethod
            AttendeeIdentityMasking                    = $policy.AttendeeIdentityMasking
            AudibleRecordingNotification               = $policy.AudibleRecordingNotification
            AutoAdmittedUsers                          = $policy.AutoAdmittedUsers
            AutomaticallyStartCopilot                  = $policy.AutomaticallyStartCopilot
            AutoRecording                              = $policy.AutoRecording
            BlockedAnonymousJoinClientTypes            = $policy.BlockedAnonymousJoinClientTypes
            CaptchaVerificationForMeetingJoin          = $policy.CaptchaVerificationForMeetingJoin
            ChannelRecordingDownload                   = $policy.ChannelRecordingDownload
            ConnectToMeetingControls                   = $policy.ConnectToMeetingControls
            ContentSharingInExternalMeetings           = $policy.ContentSharingInExternalMeetings
            Copilot                                    = $policy.Copilot
            CopyRestriction                            = $policy.CopyRestriction
            DesignatedPresenterRoleMode                = $policy.DesignatedPresenterRoleMode
            DetectSensitiveContentDuringScreenSharing  = $policy.DetectSensitiveContentDuringScreenSharing
            EnrollUserOverride                         = $policy.EnrollUserOverride
            ExplicitRecordingConsent                   = $policy.ExplicitRecordingConsent
            ExternalMeetingJoin                        = $policy.ExternalMeetingJoin
            InfoShownInReportMode                      = $policy.InfoShownInReportMode
            IPAudioMode                                = $policy.IPAudioMode
            IPVideoMode                                = $policy.IPVideoMode
            LiveCaptionsEnabledType                    = $policy.LiveCaptionsEnabledType
            LiveInterpretationEnabledType              = $policy.LiveInterpretationEnabledType
            LiveStreamingMode                          = $policy.LiveStreamingMode
            LobbyChat                                  = $policy.LobbyChat
            MediaBitRateKb                             = $policy.MediaBitRateKb
            MeetingChatEnabledType                     = $policy.MeetingChatEnabledType
            MeetingInviteLanguages                     = $policy.MeetingInviteLanguages
            NewMeetingRecordingExpirationDays          = $policy.NewMeetingRecordingExpirationDays
            NoiseSuppressionForDialInParticipants      = $policy.NoiseSuppressionForDialInParticipants
            ParticipantNameChange                      = $policy.ParticipantNameChange
            ParticipantSlideControl                    = $policy.ParticipantSlideControl
            PreferredMeetingProviderForIslandsMode     = $policy.PreferredMeetingProviderForIslandsMode
            QnAEngagementMode                          = $policy.QnAEngagementMode
            RealTimeText                               = $policy.RealTimeText
            RoomAttributeUserOverride                  = $policy.RoomAttributeUserOverride
            RoomPeopleNameUserOverride                 = $policy.RoomPeopleNameUserOverride
            ScreenSharingMode                          = $policy.ScreenSharingMode
            SmsNotifications                           = $policy.SmsNotifications
            SpeakerAttributionMode                     = $policy.SpeakerAttributionMode
            StreamingAttendeeMode                      = $policy.StreamingAttendeeMode
            TeamsCameraFarEndPTZMode                   = $policy.TeamsCameraFarEndPTZMode
            UsersCanAdmitFromLobby                     = $policy.UsersCanAdmitFromLobby
            VideoFiltersMode                           = $policy.VideoFiltersMode
            VoiceIsolation                             = $policy.VoiceIsolation
            VoiceSimulationInInterpreter               = $policy.VoiceSimulationInInterpreter
            WatermarkForAnonymousUsers                 = $policy.WatermarkForAnonymousUsers
            WatermarkForCameraVideoOpacity             = $policy.WatermarkForCameraVideoOpacity
            WatermarkForCameraVideoPattern             = $policy.WatermarkForCameraVideoPattern
            WatermarkForScreenSharingOpacity           = $policy.WatermarkForScreenSharingOpacity
            WatermarkForScreenSharingPattern           = $policy.WatermarkForScreenSharingPattern
            WhoCanRegister                             = $policy.WhoCanRegister
            Ensure                                     = 'Present'
            Credential                                 = $Credential
            ApplicationId                              = $ApplicationId
            TenantId                                   = $TenantId
            CertificateThumbprint                      = $CertificateThumbprint
            ManagedIdentity                            = $ManagedIdentity.IsPresent
            AccessTokens                               = $AccessTokens
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
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $AIInterpreter,

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
        $AllowAvatarsInGallery,

        [Parameter()]
        [System.Boolean]
        $AllowBreakoutRooms,

        [Parameter()]
        [System.Boolean]
        $AllowCarbonSummary,

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
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $AllowDocumentCollaboration,

        [Parameter()]
        [System.String]
        $AllowedStreamingMediaInput,

        [Parameter()]
        [ValidateSet('Everyone', 'UsersAllowedToByPassTheLobby')]
        [System.String]
        $AllowedUsersForMeetingDetails,

        [Parameter()]
        [ValidateSet('Enabled', 'Disabled', 'ForceEnabled')]
        [System.String]
        $AllowEngagementReport = 'Disabled',

        [Parameter()]
        [System.Boolean]
        $AllowExternalNonTrustedMeetingChat,

        [Parameter()]
        [System.Boolean]
        $AllowExternalParticipantGiveRequestControl,

        [Parameter()]
        [System.Boolean]
        $AllowImmersiveView,

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
        $AllowPowerPointSharing,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateMeetingScheduling,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateMeetNow,

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
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $AllowTasksFromTranscript,

        [Parameter()]
        [System.Boolean]
        $AllowTranscription,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'FederatedOnly', 'Disabled')]
        $AllowUserToJoinExternalMeeting,

        [Parameter()]
        [System.Boolean]
        $AllowWatermarkCustomizationForCameraVideo,

        [Parameter()]
        [System.Boolean]
        $AllowWatermarkCustomizationForScreenSharing,

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
        [ValidateSet('None', 'OneTimePasscode')]
        [System.String]
        $AnonymousUserAuthenticationMethod,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled', 'DisabledUserOverride')]
        [System.String]
        $AttendeeIdentityMasking,

        [Parameter()]
        [ValidateSet('AllAttendees', 'PstnOnly')]
        [System.String]
        $AudibleRecordingNotification,

        [Parameter()]
        [System.String]
        [ValidateSet('EveryoneInCompany', 'Everyone', 'EveryoneInSameAndFederatedCompany', 'OrganizerOnly', 'InvitedUsers', 'EveryoneInCompanyExcludingGuests')]
        $AutoAdmittedUsers,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $AutomaticallyStartCopilot,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $AutoRecording,

        [Parameter()]
        [System.String]
        $BlockedAnonymousJoinClientTypes,

        [Parameter()]
        [System.String]
        $CaptchaVerificationForMeetingJoin,

        [Parameter()]
        [ValidateSet('Allow', 'Block')]
        [System.String]
        $ChannelRecordingDownload,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $ConnectToMeetingControls,

        [Parameter()]
        [ValidateSet('EnabledForAnyone', 'EnabledForTrustedOrgs', 'Disabled')]
        [System.String]
        $ContentSharingInExternalMeetings,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled', 'EnabledWithTranscript', 'EnabledWithTranscriptDefaultOn')]
        [System.String]
        $Copilot,

        [Parameter()]
        [System.Boolean]
        $CopyRestriction,

        [Parameter()]
        [ValidateSet('OrganizerOnlyUserOverride', 'EveryoneInCompanyUserOverride', 'EveryoneUserOverride')]
        [System.String]
        $DesignatedPresenterRoleMode = 'EveryoneUserOverride',

        [Parameter()]
        [System.Boolean]
        $DetectSensitiveContentDuringScreenSharing,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $EnrollUserOverride = 'Disabled',

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $ExplicitRecordingConsent,

        [Parameter()]
        [ValidateSet('EnabledForAnyone', 'EnabledForTrustedOrgs', 'Disabled')]
        [System.String]
        $ExternalMeetingJoin,

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
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $LobbyChat,

        [Parameter()]
        [System.UInt32]
        $MediaBitRateKb,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled', 'EnabledExceptAnonymous')]
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
        [ValidateSet('Disabled', 'Enabled', 'MicrosoftDefault')]
        [System.String]
        $NoiseSuppressionForDialInParticipants,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $ParticipantNameChange,

        [Parameter()]
        [ValidateSet('Everyone', 'EveryoneInOrganization', 'EveryoneInOrganizationAndGuests', 'None')]
        [System.String]
        $ParticipantSlideControl,

        [Parameter()]
        [System.String]
        [ValidateSet('TeamsAndSfb', 'Teams')]
        $PreferredMeetingProviderForIslandsMode,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $QnAEngagementMode,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $RealTimeText,

        [Parameter()]
        [ValidateSet('Off', 'Distinguish', 'Attribute')]
        [System.String]
        $RoomAttributeUserOverride = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On')]
        [System.String]
        $RoomPeopleNameUserOverride,

        [Parameter()]
        [System.String]
        [ValidateSet('SingleApplication', 'EntireScreen', 'Disabled')]
        $ScreenSharingMode,

        [Parameter()]
        [ValidateSet('OnAllowOrganizerOverride', 'OffAllowOrganizerOverride', 'Off')]
        [System.String]
        $SmsNotifications,

        [Parameter()]
        [System.String]
        [ValidateSet('Disabled', 'DisabledUserOverride', 'EnabledUserOverride', 'Enabled')]
        $SpeakerAttributionMode,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $StreamingAttendeeMode = 'Enabled',

        [Parameter()]
        [ValidateSet('Disabled', 'AutoAcceptInTenant', 'AutoAcceptAll')]
        [System.String]
        $TeamsCameraFarEndPTZMode,

        [Parameter()]
        [ValidateSet('OrganizerAndCoOrganizersOnly', 'OrganizersAndPresentersOnly')]
        [System.String]
        $UsersCanAdmitFromLobby,

        [Parameter()]
        [System.String]
        [ValidateSet('NoFilters', 'BlurOnly', 'BlurAndDefaultBackgrounds', 'AllFilters')]
        $VideoFiltersMode,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $VoiceIsolation,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $VoiceSimulationInInterpreter,

        [Parameter()]
        [ValidateSet('JoinWithAudioOnly', 'WatermarkWithDisplayName')]
        [System.String]
        $WatermarkForAnonymousUsers,

        [Parameter()]
        [ValidateRange(1, 100)]
        [System.Int64]
        $WatermarkForCameraVideoOpacity,

        [Parameter()]
        [ValidateSet('Single', 'Tiled')]
        [System.String]
        $WatermarkForCameraVideoPattern,

        [Parameter()]
        [ValidateRange(1, 100)]
        [System.Int64]
        $WatermarkForScreenSharingOpacity,

        [Parameter()]
        [ValidateSet('Single', 'Tiled')]
        [System.String]
        $WatermarkForScreenSharingPattern,

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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
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

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $SetParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    # The AllowUserToJoinExternalMeeting is not available in Set-CsTeamsMeetingPolicy
    $SetParameters.Remove('AllowUserToJoinExternalMeeting') | Out-Null

    if ($AllowCloudRecording -eq $false -and $SetParameters.Keys -contains 'AllowRecordingStorageOutsideRegion')
    {
        $SetParameters.Remove('AllowRecordingStorageOutsideRegion') | Out-Null
    }

    if ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating a Teams Meeting Policy with Identity {$Identity}"

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
        Write-Verbose -Message "Updating the Teams Meeting Policy with Identity {$Identity}"

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
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $AIInterpreter,

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
        $AllowAvatarsInGallery,

        [Parameter()]
        [System.Boolean]
        $AllowBreakoutRooms,

        [Parameter()]
        [System.Boolean]
        $AllowCarbonSummary,

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
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $AllowDocumentCollaboration,

        [Parameter()]
        [System.String]
        $AllowedStreamingMediaInput,

        [Parameter()]
        [ValidateSet('Everyone', 'UsersAllowedToByPassTheLobby')]
        [System.String]
        $AllowedUsersForMeetingDetails,

        [Parameter()]
        [ValidateSet('Enabled', 'Disabled', 'ForceEnabled')]
        [System.String]
        $AllowEngagementReport = 'Disabled',

        [Parameter()]
        [System.Boolean]
        $AllowExternalNonTrustedMeetingChat,

        [Parameter()]
        [System.Boolean]
        $AllowExternalParticipantGiveRequestControl,

        [Parameter()]
        [System.Boolean]
        $AllowImmersiveView,

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
        $AllowPowerPointSharing,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateMeetingScheduling,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateMeetNow,

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
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $AllowTasksFromTranscript,

        [Parameter()]
        [System.Boolean]
        $AllowTranscription,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'FederatedOnly', 'Disabled')]
        $AllowUserToJoinExternalMeeting,

        [Parameter()]
        [System.Boolean]
        $AllowWatermarkCustomizationForCameraVideo,

        [Parameter()]
        [System.Boolean]
        $AllowWatermarkCustomizationForScreenSharing,

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
        [ValidateSet('None', 'OneTimePasscode')]
        [System.String]
        $AnonymousUserAuthenticationMethod,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled', 'DisabledUserOverride')]
        [System.String]
        $AttendeeIdentityMasking,

        [Parameter()]
        [ValidateSet('AllAttendees', 'PstnOnly')]
        [System.String]
        $AudibleRecordingNotification,

        [Parameter()]
        [System.String]
        [ValidateSet('EveryoneInCompany', 'Everyone', 'EveryoneInSameAndFederatedCompany', 'OrganizerOnly', 'InvitedUsers', 'EveryoneInCompanyExcludingGuests')]
        $AutoAdmittedUsers,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $AutomaticallyStartCopilot,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $AutoRecording,

        [Parameter()]
        [System.String]
        $BlockedAnonymousJoinClientTypes,

        [Parameter()]
        [System.String]
        $CaptchaVerificationForMeetingJoin,

        [Parameter()]
        [ValidateSet('Allow', 'Block')]
        [System.String]
        $ChannelRecordingDownload,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $ConnectToMeetingControls,

        [Parameter()]
        [ValidateSet('EnabledForAnyone', 'EnabledForTrustedOrgs', 'Disabled')]
        [System.String]
        $ContentSharingInExternalMeetings,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled', 'EnabledWithTranscript', 'EnabledWithTranscriptDefaultOn')]
        [System.String]
        $Copilot,

        [Parameter()]
        [System.Boolean]
        $CopyRestriction,

        [Parameter()]
        [ValidateSet('OrganizerOnlyUserOverride', 'EveryoneInCompanyUserOverride', 'EveryoneUserOverride')]
        [System.String]
        $DesignatedPresenterRoleMode = 'EveryoneUserOverride',

        [Parameter()]
        [System.Boolean]
        $DetectSensitiveContentDuringScreenSharing,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $EnrollUserOverride = 'Disabled',

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $ExplicitRecordingConsent,

        [Parameter()]
        [ValidateSet('EnabledForAnyone', 'EnabledForTrustedOrgs', 'Disabled')]
        [System.String]
        $ExternalMeetingJoin,

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
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $LobbyChat,

        [Parameter()]
        [System.UInt32]
        $MediaBitRateKb,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled', 'EnabledExceptAnonymous')]
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
        [ValidateSet('Disabled', 'Enabled', 'MicrosoftDefault')]
        [System.String]
        $NoiseSuppressionForDialInParticipants,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $ParticipantNameChange,

        [Parameter()]
        [ValidateSet('Everyone', 'EveryoneInOrganization', 'EveryoneInOrganizationAndGuests', 'None')]
        [System.String]
        $ParticipantSlideControl,

        [Parameter()]
        [System.String]
        [ValidateSet('TeamsAndSfb', 'Teams')]
        $PreferredMeetingProviderForIslandsMode,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $QnAEngagementMode,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $RealTimeText,

        [Parameter()]
        [ValidateSet('Off', 'Distinguish', 'Attribute')]
        [System.String]
        $RoomAttributeUserOverride = 'Off',

        [Parameter()]
        [ValidateSet('Off', 'On')]
        [System.String]
        $RoomPeopleNameUserOverride,

        [Parameter()]
        [System.String]
        [ValidateSet('SingleApplication', 'EntireScreen', 'Disabled')]
        $ScreenSharingMode,

        [Parameter()]
        [ValidateSet('OnAllowOrganizerOverride', 'OffAllowOrganizerOverride', 'Off')]
        [System.String]
        $SmsNotifications,

        [Parameter()]
        [System.String]
        [ValidateSet('Disabled', 'DisabledUserOverride', 'EnabledUserOverride', 'Enabled')]
        $SpeakerAttributionMode,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $StreamingAttendeeMode = 'Enabled',

        [Parameter()]
        [ValidateSet('Disabled', 'AutoAcceptInTenant', 'AutoAcceptAll')]
        [System.String]
        $TeamsCameraFarEndPTZMode,

        [Parameter()]
        [ValidateSet('OrganizerAndCoOrganizersOnly', 'OrganizersAndPresentersOnly')]
        [System.String]
        $UsersCanAdmitFromLobby,

        [Parameter()]
        [System.String]
        [ValidateSet('NoFilters', 'BlurOnly', 'BlurAndDefaultBackgrounds', 'AllFilters')]
        $VideoFiltersMode,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $VoiceIsolation,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $VoiceSimulationInInterpreter,

        [Parameter()]
        [ValidateSet('JoinWithAudioOnly', 'WatermarkWithDisplayName')]
        [System.String]
        $WatermarkForAnonymousUsers,

        [Parameter()]
        [ValidateRange(1, 100)]
        [System.Int64]
        $WatermarkForCameraVideoOpacity,

        [Parameter()]
        [ValidateSet('Single', 'Tiled')]
        [System.String]
        $WatermarkForCameraVideoPattern,

        [Parameter()]
        [ValidateRange(1, 100)]
        [System.Int64]
        $WatermarkForScreenSharingOpacity,

        [Parameter()]
        [ValidateSet('Single', 'Tiled')]
        [System.String]
        $WatermarkForScreenSharingPattern,

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

    # The AllowAnonymousUsersToDialOut is temporarly disabled. Therefore we can't create or update a policy with it and it needs to be removed
    # The AllowIPVideo is temporarly not working, therefore we won't check the value
    # The AllowUserToJoinExternalMeeting doesn't do anything based on official documentation
    $excludedProperties = @('AllowAnonymousUsersToDialOut', 'AllowIPVideo', 'AllowUserToJoinExternalMeeting')
    if ($AllowCloudRecording -eq $false -and $PSBoundParameters.ContainsKey('AllowRecordingStorageOutsideRegion'))
    {
        $excludedProperties += 'AllowCloudRecording'
    }
    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
                                         -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '') `
                                         -ExcludedProperties $excludedProperties
    return $result
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
        [array]$policies = Get-CsTeamsMeetingPolicy -ErrorAction Stop
        $dscContent = ''
        Write-M365DSCHost -Message "`r`n" -DeferWrite
        foreach ($policy in $policies)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($policies.Count)] $($policy.Identity)" -DeferWrite
            $params = @{
                Identity              = $policy.Identity
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
        Write-M365DSCHost -Message $Global:M365DSCEmojiRedX -CommitWrite

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
