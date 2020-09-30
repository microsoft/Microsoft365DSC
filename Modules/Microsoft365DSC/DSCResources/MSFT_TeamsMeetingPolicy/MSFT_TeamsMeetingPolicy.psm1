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
        $AllowIPVideo,

        [Parameter()]
        [System.Boolean]
        $AllowAnonymousUsersToStartMeeting,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateMeetingScheduling,

        [Parameter()]
        [System.String]
        [ValidateSet('EveryoneInCompany', 'Everyone', 'EveryoneInSameAndFederatedCompany')]
        $AutoAdmittedUsers,

        [Parameter()]
        [System.Boolean]
        $AllowPSTNUsersToBypassLobby,

        [Parameter()]
        [System.Boolean]
        $AllowCloudRecording,

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
            AllowIPVideo                               = $policy.AllowIPVideo
            AllowAnonymousUsersToStartMeeting          = $policy.AllowAnonymousUsersToStartMeeting
            AllowPrivateMeetingScheduling              = $policy.AllowPrivateMeetingScheduling
            AllowPSTNUsersToBypassLobby                = $policy.AllowPSTNUsersToBypassLobby
            AutoAdmittedUsers                          = $policy.AutoAdmittedUsers
            AllowCloudRecording                        = $policy.AllowCloudRecording
            AllowOutlookAddIn                          = $policy.AllowOutlookAddIn
            AllowPowerPointSharing                     = $policy.AllowPowerPointSharing
            AllowParticipantGiveRequestControl         = $policy.AllowParticipantGiveRequestControl
            AllowExternalParticipantGiveRequestControl = $policy.AllowExternalParticipantGiveRequestControl
            AllowSharedNotes                           = $policy.AllowSharedNotes
            AllowWhiteboard                            = $policy.AllowWhiteboard
            AllowTranscription                         = $policy.AllowTranscription
            MediaBitRateKb                             = $policy.MediaBitRateKb
            ScreenSharingMode                          = $policy.ScreenSharingMode
            Ensure                                     = "Present"
            GlobalAdminAccount                         = $GlobalAdminAccount
        }
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
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
        $AllowIPVideo,

        [Parameter()]
        [System.Boolean]
        $AllowAnonymousUsersToStartMeeting,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateMeetingScheduling,

        [Parameter()]
        [System.String]
        [ValidateSet('EveryoneInCompany', 'Everyone', 'EveryoneInSameAndFederatedCompany')]
        $AutoAdmittedUsers,

        [Parameter()]
        [System.Boolean]
        $AllowPSTNUsersToBypassLobby,

        [Parameter()]
        [System.Boolean]
        $AllowCloudRecording,

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
        New-CsTeamsMeetingPolicy @SetParameters
    }
    elseif ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Present')
    {
        # If we get here, it's because the Test-TargetResource detected a drift, therefore we always call
        # into the Set-CsTeamsMeetingPolicy cmdlet.
        Write-Verbose -Message "Updating settings for Teams Meeting Policy {$Identity}"
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
        $AllowIPVideo,

        [Parameter()]
        [System.Boolean]
        $AllowAnonymousUsersToStartMeeting,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateMeetingScheduling,

        [Parameter()]
        [System.String]
        [ValidateSet('EveryoneInCompany', 'Everyone', 'EveryoneInSameAndFederatedCompany')]
        $AutoAdmittedUsers,

        [Parameter()]
        [System.Boolean]
        $AllowPSTNUsersToBypassLobby,

        [Parameter()]
        [System.Boolean]
        $AllowCloudRecording,

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
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of Team Meeting Policy {$Identity}"

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
        Write-Host "`r`n" -NoNewLine
        foreach ($policy in $policies)
        {
            Write-Host "    |---[$i/$($policies.Count)] $($policy.Identity)" -NoNewLine
            $params = @{
                Identity           = $policy.Identity
                GlobalAdminAccount = $GlobalAdminAccount
            }
            $result = Get-TargetResource @params
            $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
            $content += "        TeamsMeetingPolicy " + (New-GUID).ToString() + "`r`n"
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
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource
