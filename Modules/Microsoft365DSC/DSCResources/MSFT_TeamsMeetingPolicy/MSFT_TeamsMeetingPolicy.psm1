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
        [ValidateSet("Disabled", "Enabled")]
        [System.String]
        $MeetingChatEnabledType = "Enabled",

        [Parameter()]
        [ValidateSet("Disabled", "DisabledUserOverride")]
        [System.String]
        $LiveCaptionsEnabledType = "DisabledUserOverride",

        [Parameter()]
        [ValidateSet("OrganizerOnlyUserOverride", "EveryoneInCompanyUserOverride", "EveryoneUserOverride")]
        [System.String]
        $DesignatedPresenterRoleMode = "EveryoneUserOverride",

        [Parameter()]
        [System.Boolean]
        $AllowIPAudio,

        [Parameter()]
        [System.Boolean]
        $AllowIPVideo,

        [Parameter()]
        [ValidateSet("Enabled", "Disabled")]
        [System.String]
        $AllowEngagementReport = "Disabled",

        [Parameter()]
        [ValidateSet("EnabledOutgoingIncoming", "Disabled")]
        [System.String]
        $IPAudioMode = "EnabledOutgoingIncoming",

        [Parameter()]
        [ValidateSet("EnabledOutgoingIncoming", "Disabled")]
        [System.String]
        $IPVideoMode = "EnabledOutgoingIncoming",

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
        [ValidateSet('EveryoneInCompany', 'Everyone', 'EveryoneInSameAndFederatedCompany', 'OrganizerOnly')]
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
        [ValidateSet("Disabled", "Enabled")]
        [System.String]
        $EnrollUserOverride = "Disabled",

        [Parameter()]
        [ValidateSet("Off", "Distinguish", "Attribute")]
        [System.String]
        $RoomAttributeUserOverride = "Off",

        [Parameter()]
        [ValidateSet("Disabled", "Enabled")]
        [System.String]
        $StreamingAttendeeMode = "Enabled",

        [Parameter()]
        [System.Boolean]
        $AllowBreakoutRooms,

        [Parameter()]
        [ValidateSet("Disabled", "Enabled")]
        [System.String]
        $TeamsCameraFarEndPTZMode,

        [Parameter()]
        [System.Boolean]
        $AllowMeetingReactions,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting the Teams Meeting Policy $($Identity)"

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'SkypeForBusiness' `
        -InboundParameters $PSBoundParameters

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"
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
            Ensure                                     = "Present"
            GlobalAdminAccount                         = $GlobalAdminAccount
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
        $AllowChannelMeetingScheduling,

        [Parameter()]
        [System.Boolean]
        $AllowMeetNow,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateMeetNow,

        [Parameter()]
        [ValidateSet("Disabled", "Enabled")]
        [System.String]
        $MeetingChatEnabledType = "Enabled",

        [Parameter()]
        [ValidateSet("Disabled", "DisabledUserOverride")]
        [System.String]
        $LiveCaptionsEnabledType = "DisabledUserOverride",

        [Parameter()]
        [ValidateSet("OrganizerOnlyUserOverride", "EveryoneInCompanyUserOverride", "EveryoneUserOverride")]
        [System.String]
        $DesignatedPresenterRoleMode = "EveryoneUserOverride",

        [Parameter()]
        [System.Boolean]
        $AllowIPAudio,

        [Parameter()]
        [System.Boolean]
        $AllowIPVideo,

        [Parameter()]
        [ValidateSet("Enabled", "Disabled")]
        [System.String]
        $AllowEngagementReport = "Disabled",

        [Parameter()]
        [ValidateSet("EnabledOutgoingIncoming", "Disabled")]
        [System.String]
        $IPAudioMode = "EnabledOutgoingIncoming",

        [Parameter()]
        [ValidateSet("EnabledOutgoingIncoming", "Disabled")]
        [System.String]
        $IPVideoMode = "EnabledOutgoingIncoming",

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
        [ValidateSet('EveryoneInCompany', 'Everyone', 'EveryoneInSameAndFederatedCompany', 'OrganizerOnly')]
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
        [ValidateSet("Disabled", "Enabled")]
        [System.String]
        $EnrollUserOverride = "Disabled",

        [Parameter()]
        [ValidateSet("Off", "Distinguish", "Attribute")]
        [System.String]
        $RoomAttributeUserOverride = "Off",

        [Parameter()]
        [ValidateSet("Disabled", "Enabled")]
        [System.String]
        $StreamingAttendeeMode = "Enabled",

        [Parameter()]
        [System.Boolean]
        $AllowBreakoutRooms,

        [Parameter()]
        [ValidateSet("Disabled", "Enabled")]
        [System.String]
        $TeamsCameraFarEndPTZMode,

        [Parameter()]
        [System.Boolean]
        $AllowMeetingReactions,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting Teams Meeting Policy"

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'SkypeForBusiness' `
        -InboundParameters $PSBoundParameters

    $CurrentValues = Get-TargetResource @PSBoundParameters

    $SetParameters = $PSBoundParameters
    $SetParameters.Remove("Ensure") | Out-Null
    $SetParameters.Remove("GlobalAdminAccount") | Out-Null

    if ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating a new Teams Meeting Policy {$Identity}"

        # The AllowAnonymousUsersToDialOut is temporarly disabled. Therefore
        # we can't create or update a policy with it and it needs to be removed;
        if ($SetParameters.ContainsKey("AllowAnonymousUsersToDialOut"))
        {
            $SetParameters.Remove("AllowAnonymousUsersToDialOut") | Out-Null
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
        if ($SetParameters.ContainsKey("AllowAnonymousUsersToDialOut"))
        {
            $SetParameters.Remove("AllowAnonymousUsersToDialOut") | Out-Null
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
        [ValidateSet("Disabled", "Enabled")]
        [System.String]
        $MeetingChatEnabledType = "Enabled",

        [Parameter()]
        [ValidateSet("Disabled", "DisabledUserOverride")]
        [System.String]
        $LiveCaptionsEnabledType = "DisabledUserOverride",

        [Parameter()]
        [ValidateSet("OrganizerOnlyUserOverride", "EveryoneInCompanyUserOverride", "EveryoneUserOverride")]
        [System.String]
        $DesignatedPresenterRoleMode = "EveryoneUserOverride",

        [Parameter()]
        [System.Boolean]
        $AllowIPAudio,

        [Parameter()]
        [System.Boolean]
        $AllowIPVideo,

        [Parameter()]
        [ValidateSet("Enabled", "Disabled")]
        [System.String]
        $AllowEngagementReport = "Disabled",

        [Parameter()]
        [ValidateSet("EnabledOutgoingIncoming", "Disabled")]
        [System.String]
        $IPAudioMode = "EnabledOutgoingIncoming",

        [Parameter()]
        [ValidateSet("EnabledOutgoingIncoming", "Disabled")]
        [System.String]
        $IPVideoMode = "EnabledOutgoingIncoming",

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
        [ValidateSet('EveryoneInCompany', 'Everyone', 'EveryoneInSameAndFederatedCompany', 'OrganizerOnly')]
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
        [ValidateSet("Disabled", "Enabled")]
        [System.String]
        $EnrollUserOverride = "Disabled",

        [Parameter()]
        [ValidateSet("Off", "Distinguish", "Attribute")]
        [System.String]
        $RoomAttributeUserOverride = "Off",

        [Parameter()]
        [ValidateSet("Disabled", "Enabled")]
        [System.String]
        $StreamingAttendeeMode = "Enabled",

        [Parameter()]
        [System.Boolean]
        $AllowBreakoutRooms,

        [Parameter()]
        [ValidateSet("Disabled", "Enabled")]
        [System.String]
        $TeamsCameraFarEndPTZMode,

        [Parameter()]
        [System.Boolean]
        $AllowMeetingReactions,

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

    Write-Verbose -Message "Testing configuration of Team Meeting Policy {$Identity}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null
    # The AllowAnonymousUsersToDialOut is temporarly disabled. Therefore
    # we can't create or update a policy with it and it needs to be removed;
    $ValuesToCheck.Remove("AllowAnonymousUsersToDialOut") | Out-Null


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
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'SkypeForBusiness' `
        -InboundParameters $PSBoundParameters

    try
    {
        $i = 1
        [array]$policies = Get-CsTeamsMeetingPolicy -ErrorAction Stop
        $content = ''
        Write-Host "`r`n" -NoNewline
        foreach ($policy in $policies)
        {
            Write-Host "    |---[$i/$($policies.Count)] $($policy.Identity)" -NoNewline
            $params = @{
                Identity           = $policy.Identity
                GlobalAdminAccount = $GlobalAdminAccount
            }
            $result = Get-TargetResource @params
            $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
            $content += "        TeamsMeetingPolicy " + (New-Guid).ToString() + "`r`n"
            $content += "        {`r`n"
            $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
            $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
            $content += "        }`r`n"
            Write-Host $Global:M365DSCEmojiGreenCheckmark
            $i++
        }
        return $content
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
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource
