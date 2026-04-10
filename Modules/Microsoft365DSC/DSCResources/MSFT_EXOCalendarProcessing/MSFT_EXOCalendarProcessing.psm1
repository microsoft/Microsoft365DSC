Confirm-M365DSCModuleDependency -ModuleName 'MSFT_EXOCalendarProcessing'

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
        [System.Boolean]
        $AddAdditionalResponse,

        [Parameter()]
        [System.String]
        $AdditionalResponse,

        [Parameter()]
        [System.Boolean]
        $AddNewRequestsTentatively,

        [Parameter()]
        [System.Boolean]
        $AddOrganizerToSubject,

        [Parameter()]
        [System.Boolean]
        $AllBookInPolicy,

        [Parameter()]
        [System.Boolean]
        $AllowConflicts,

        [Parameter()]
        [System.Boolean]
        $AllowRecurringMeetings,

        [Parameter()]
        [System.Boolean]
        $AllRequestInPolicy,

        [Parameter()]
        [System.Boolean]
        $AllRequestOutOfPolicy,

        [Parameter()]
        [ValidateSet('None', 'AutoUpdate', 'AutoAccept')]
        [System.String]
        $AutomateProcessing,

        [Parameter()]
        [ValidateSet('Standard', 'Reserved')]
        [System.String]
        $BookingType,

        [Parameter()]
        [ValidateRange(0, 1080)]
        [System.UInt32]
        $BookingWindowInDays = 180,

        [Parameter()]
        [System.String[]]
        $BookInPolicy,

        [Parameter()]
        [System.UInt32]
        $ConflictPercentageAllowed,

        [Parameter()]
        [System.Boolean]
        $DeleteAttachments,

        [Parameter()]
        [System.Boolean]
        $DeleteComments,

        [Parameter()]
        [System.Boolean]
        $DeleteNonCalendarItems,

        [Parameter()]
        [System.Boolean]
        $DeleteSubject,

        [Parameter()]
        [System.Boolean]
        $EnableAutoRelease,

        [Parameter()]
        [System.Boolean]
        $EnableResponseDetails,

        [Parameter()]
        [System.Boolean]
        $EnforceCapacity,

        [Parameter()]
        [System.Boolean]
        $EnforceSchedulingHorizon,

        [Parameter()]
        [System.Boolean]
        $ForwardRequestsToDelegates,

        [Parameter()]
        [System.UInt32]
        $MaximumConflictInstances,

        [Parameter()]
        [System.UInt32]
        $MaximumDurationInMinutes,

        [Parameter()]
        [System.UInt32]
        $MinimumDurationInMinutes,

        [Parameter()]
        [System.Boolean]
        $OrganizerInfo,

        [Parameter()]
        [System.UInt32]
        $PostReservationMaxClaimTimeInMinutes,

        [Parameter()]
        [System.Boolean]
        $ProcessExternalMeetingMessages,

        [Parameter()]
        [System.Boolean]
        $RemoveCanceledMeetings,

        [Parameter()]
        [System.Boolean]
        $RemoveForwardedMeetingNotifications,

        [Parameter()]
        [System.Boolean]
        $RemoveOldMeetingMessages,

        [Parameter()]
        [System.Boolean]
        $RemovePrivateProperty,

        [Parameter()]
        [System.String[]]
        $RequestInPolicy,

        [Parameter()]
        [System.String[]]
        $RequestOutOfPolicy,

        [Parameter()]
        [System.String[]]
        $ResourceDelegates,

        [Parameter()]
        [System.Boolean]
        $ScheduleOnlyDuringWorkHours,

        [Parameter()]
        [System.Boolean]
        $TentativePendingApproval,

        [Parameter()]
        [ValidateSet('Present')]
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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration of Calendar Processing settings for $Identity"

    try
    {
        $null = New-M365DSCConnection -Workload 'ExchangeOnline' `
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

        $calendarProc = Get-CalendarProcessing -Identity $Identity -ErrorAction SilentlyContinue

        if ($null -eq $calendarProc)
        {
            Write-Verbose -Message "Calendar processing settings for $($Identity) does not exist."
            return $nullReturn
        }

        if ($null -eq $Script:UsersCache)
        {
            $Script:UsersCache = [System.Collections.Generic.Dictionary[System.String, System.String]]::new()
        }

        $RequestInPolicyValue = @()
        if ($null -ne $calendarProc.RequestInPolicy)
        {
            foreach ($user in $calendarProc.RequestInPolicy)
            {
                $userInfo = $null
                if ($Script:UsersCache.TryGetValue($user, [ref]$userInfo))
                {
                    $RequestInPolicyValue += $userInfo
                }
                else
                {
                    $userInfo = (Get-User -Identity $user).UserPrincipalName
                    $Script:UsersCache[$user] = $userInfo
                    $RequestInPolicyValue += $userInfo
                }
            }
        }

        $RequestOutOfPolicyValue = @()
        if ($null -ne $calendarProc.RequestOutOfPolicy)
        {
            foreach ($user in $calendarProc.RequestOutOfPolicy)
            {
                $userInfo = $null
                if ($Script:UsersCache.TryGetValue($user, [ref]$userInfo))
                {
                    $RequestOutOfPolicyValue += $userInfo
                }
                else
                {
                    $userInfo = (Get-User -Identity $user).UserPrincipalName
                    $Script:UsersCache[$user] = $userInfo
                    $RequestOutOfPolicyValue += $userInfo
                }
            }
        }

        $ResourceDelegatesValue = @()
        if ($null -ne $calendarProc.ResourceDelegates)
        {
            foreach ($user in $calendarProc.ResourceDelegates)
            {
                $userInfo = $null
                if ($Script:UsersCache.TryGetValue($user, [ref]$userInfo))
                {
                    $ResourceDelegatesValue += $userInfo
                }
                else
                {
                    $userInfo = (Get-Recipient -Identity $user).PrimarySmtpAddress
                    $Script:UsersCache[$user] = $userInfo
                    $ResourceDelegatesValue += $userInfo
                }
            }
        }

        $result = @{
            Identity                             = $Identity
            AddAdditionalResponse                = $calendarProc.AddAdditionalResponse
            AdditionalResponse                   = $calendarProc.AdditionalResponse
            AddNewRequestsTentatively            = $calendarProc.AddNewRequestsTentatively
            AddOrganizerToSubject                = $calendarProc.AddOrganizerToSubject
            AllBookInPolicy                      = $calendarProc.AllBookInPolicy
            AllowConflicts                       = $calendarProc.AllowConflicts
            AllowRecurringMeetings               = $calendarProc.AllowRecurringMeetings
            AllRequestInPolicy                   = $calendarProc.AllRequestInPolicy
            AllRequestOutOfPolicy                = $calendarProc.AllRequestOutOfPolicy
            AutomateProcessing                   = $calendarProc.AutomateProcessing
            BookingType                          = $calendarProc.BookingType
            BookingWindowInDays                  = $calendarProc.BookingWindowInDays
            BookInPolicy                         = [Array]$calendarProc.BookInPolicy
            ConflictPercentageAllowed            = $calendarProc.ConflictPercentageAllowed
            DeleteAttachments                    = $calendarProc.DeleteAttachments
            DeleteComments                       = $calendarProc.DeleteComments
            DeleteNonCalendarItems               = $calendarProc.DeleteNonCalendarItems
            DeleteSubject                        = $calendarProc.DeleteSubject
            EnableAutoRelease                    = $calendarProc.EnableAutoRelease
            EnableResponseDetails                = $calendarProc.EnableResponseDetails
            EnforceCapacity                      = $calendarProc.EnforceCapacity
            EnforceSchedulingHorizon             = $calendarProc.EnforceSchedulingHorizon
            ForwardRequestsToDelegates           = $calendarProc.ForwardRequestsToDelegates
            MaximumConflictInstances             = $calendarProc.MaximumConflictInstances
            MaximumDurationInMinutes             = $calendarProc.MaximumDurationInMinutes
            MinimumDurationInMinutes             = $calendarProc.MinimumDurationInMinutes
            OrganizerInfo                        = $calendarProc.OrganizerInfo
            PostReservationMaxClaimTimeInMinutes = $calendarProc.PostReservationMaxClaimTimeInMinutes
            ProcessExternalMeetingMessages       = $calendarProc.ProcessExternalMeetingMessages
            RemoveCanceledMeetings               = $calendarProc.RemoveCanceledMeetings
            RemoveForwardedMeetingNotifications  = $calendarProc.RemoveForwardedMeetingNotifications
            RemoveOldMeetingMessages             = $calendarProc.RemoveOldMeetingMessages
            RemovePrivateProperty                = $calendarProc.RemovePrivateProperty
            RequestInPolicy                      = $RequestInPolicyValue
            RequestOutOfPolicy                   = $RequestOutOfPolicyValue
            ResourceDelegates                    = $ResourceDelegatesValue
            ScheduleOnlyDuringWorkHours          = $calendarProc.ScheduleOnlyDuringWorkHours
            TentativePendingApproval             = $calendarProc.TentativePendingApproval
            Ensure                               = 'Present'
            Credential                           = $Credential
            ApplicationId                        = $ApplicationId
            CertificateThumbprint                = $CertificateThumbprint
            CertificatePath                      = $CertificatePath
            CertificatePassword                  = $CertificatePassword
            ManagedIdentity                      = $ManagedIdentity.IsPresent
            TenantId                             = $TenantId
            AccessTokens                         = $AccessTokens
        }

        Write-Verbose -Message "Found Availability Config for $($OrgWideAccount)"
        return $result
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
        [System.Boolean]
        $AddAdditionalResponse,

        [Parameter()]
        [System.String]
        $AdditionalResponse,

        [Parameter()]
        [System.Boolean]
        $AddNewRequestsTentatively,

        [Parameter()]
        [System.Boolean]
        $AddOrganizerToSubject,

        [Parameter()]
        [System.Boolean]
        $AllBookInPolicy,

        [Parameter()]
        [System.Boolean]
        $AllowConflicts,

        [Parameter()]
        [System.Boolean]
        $AllowRecurringMeetings,

        [Parameter()]
        [System.Boolean]
        $AllRequestInPolicy,

        [Parameter()]
        [System.Boolean]
        $AllRequestOutOfPolicy,

        [Parameter()]
        [ValidateSet('None', 'AutoUpdate', 'AutoAccept')]
        [System.String]
        $AutomateProcessing,

        [Parameter()]
        [ValidateSet('Standard', 'Reserved')]
        [System.String]
        $BookingType,

        [Parameter()]
        [ValidateRange(0, 1080)]
        [System.UInt32]
        $BookingWindowInDays = 180,

        [Parameter()]
        [System.String[]]
        $BookInPolicy,

        [Parameter()]
        [System.UInt32]
        $ConflictPercentageAllowed,

        [Parameter()]
        [System.Boolean]
        $DeleteAttachments,

        [Parameter()]
        [System.Boolean]
        $DeleteComments,

        [Parameter()]
        [System.Boolean]
        $DeleteNonCalendarItems,

        [Parameter()]
        [System.Boolean]
        $DeleteSubject,

        [Parameter()]
        [System.Boolean]
        $EnableAutoRelease,

        [Parameter()]
        [System.Boolean]
        $EnableResponseDetails,

        [Parameter()]
        [System.Boolean]
        $EnforceCapacity,

        [Parameter()]
        [System.Boolean]
        $EnforceSchedulingHorizon,

        [Parameter()]
        [System.Boolean]
        $ForwardRequestsToDelegates,

        [Parameter()]
        [System.UInt32]
        $MaximumConflictInstances,

        [Parameter()]
        [System.UInt32]
        $MaximumDurationInMinutes,

        [Parameter()]
        [System.UInt32]
        $MinimumDurationInMinutes,

        [Parameter()]
        [System.Boolean]
        $OrganizerInfo,

        [Parameter()]
        [System.UInt32]
        $PostReservationMaxClaimTimeInMinutes,

        [Parameter()]
        [System.Boolean]
        $ProcessExternalMeetingMessages,

        [Parameter()]
        [System.Boolean]
        $RemoveCanceledMeetings,

        [Parameter()]
        [System.Boolean]
        $RemoveForwardedMeetingNotifications,

        [Parameter()]
        [System.Boolean]
        $RemoveOldMeetingMessages,

        [Parameter()]
        [System.Boolean]
        $RemovePrivateProperty,

        [Parameter()]
        [System.String[]]
        $RequestInPolicy,

        [Parameter()]
        [System.String[]]
        $RequestOutOfPolicy,

        [Parameter()]
        [System.String[]]
        $ResourceDelegates,

        [Parameter()]
        [System.Boolean]
        $ScheduleOnlyDuringWorkHours,

        [Parameter()]
        [System.Boolean]
        $TentativePendingApproval,

        [Parameter()]
        [ValidateSet('Present')]
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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

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

    $currentValues = Get-TargetResource @PSBoundParameters

    if ($null -ne $currentValues)
    {
        Write-Verbose -Message "Setting configuration of Calendar Processing for $Identity"
    }
    else
    {
        return
    }

    $UpdateParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    # Some parameters can only be applied to Resource Mailboxes
    if ($UpdateParameters.ContainsKey('AddNewRequestsTentatively'))
    {
        $mailbox = Get-Mailbox $UpdateParameters.Identity
        if ($mailbox.RecipientTypeDetails -ne 'EquipmentMailbox' -and $mailbox.RecipientTypeDetails -ne 'RoomMailbox')
        {
            Write-Verbose -Message 'Removing the AddNewRequestsTentatively parameter because the mailbox is not a resource one.'
            $UpdateParameters.Remove('AddNewRequestsTentatively') | Out-Null

            Write-Verbose -Message 'Removing the BookingType parameter because the mailbox is not a resource one.'
            $UpdateParameters.Remove('BookingType') | Out-Null

            Write-Verbose -Message 'Removing the ProcessExternalMeetingMessages parameter because the mailbox is not a resource one.'
            $UpdateParameters.Remove('ProcessExternalMeetingMessages') | Out-Null
        }
    }

    Set-CalendarProcessing @UpdateParameters
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
        [System.Boolean]
        $AddAdditionalResponse,

        [Parameter()]
        [System.String]
        $AdditionalResponse,

        [Parameter()]
        [System.Boolean]
        $AddNewRequestsTentatively,

        [Parameter()]
        [System.Boolean]
        $AddOrganizerToSubject,

        [Parameter()]
        [System.Boolean]
        $AllBookInPolicy,

        [Parameter()]
        [System.Boolean]
        $AllowConflicts,

        [Parameter()]
        [System.Boolean]
        $AllowRecurringMeetings,

        [Parameter()]
        [System.Boolean]
        $AllRequestInPolicy,

        [Parameter()]
        [System.Boolean]
        $AllRequestOutOfPolicy,

        [Parameter()]
        [ValidateSet('None', 'AutoUpdate', 'AutoAccept')]
        [System.String]
        $AutomateProcessing,

        [Parameter()]
        [ValidateSet('Standard', 'Reserved')]
        [System.String]
        $BookingType,

        [Parameter()]
        [ValidateRange(0, 1080)]
        [System.UInt32]
        $BookingWindowInDays = 180,

        [Parameter()]
        [System.String[]]
        $BookInPolicy,

        [Parameter()]
        [System.UInt32]
        $ConflictPercentageAllowed,

        [Parameter()]
        [System.Boolean]
        $DeleteAttachments,

        [Parameter()]
        [System.Boolean]
        $DeleteComments,

        [Parameter()]
        [System.Boolean]
        $DeleteNonCalendarItems,

        [Parameter()]
        [System.Boolean]
        $DeleteSubject,

        [Parameter()]
        [System.Boolean]
        $EnableAutoRelease,

        [Parameter()]
        [System.Boolean]
        $EnableResponseDetails,

        [Parameter()]
        [System.Boolean]
        $EnforceCapacity,

        [Parameter()]
        [System.Boolean]
        $EnforceSchedulingHorizon,

        [Parameter()]
        [System.Boolean]
        $ForwardRequestsToDelegates,

        [Parameter()]
        [System.UInt32]
        $MaximumConflictInstances,

        [Parameter()]
        [System.UInt32]
        $MaximumDurationInMinutes,

        [Parameter()]
        [System.UInt32]
        $MinimumDurationInMinutes,

        [Parameter()]
        [System.Boolean]
        $OrganizerInfo,

        [Parameter()]
        [System.UInt32]
        $PostReservationMaxClaimTimeInMinutes,

        [Parameter()]
        [System.Boolean]
        $ProcessExternalMeetingMessages,

        [Parameter()]
        [System.Boolean]
        $RemoveCanceledMeetings,

        [Parameter()]
        [System.Boolean]
        $RemoveForwardedMeetingNotifications,

        [Parameter()]
        [System.Boolean]
        $RemoveOldMeetingMessages,

        [Parameter()]
        [System.Boolean]
        $RemovePrivateProperty,

        [Parameter()]
        [System.String[]]
        $RequestInPolicy,

        [Parameter()]
        [System.String[]]
        $RequestOutOfPolicy,

        [Parameter()]
        [System.String[]]
        $ResourceDelegates,

        [Parameter()]
        [System.Boolean]
        $ScheduleOnlyDuringWorkHours,

        [Parameter()]
        [System.Boolean]
        $TentativePendingApproval,

        [Parameter()]
        [ValidateSet('Present')]
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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
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
        $Script:currentModeIsExport = $true
        $mailboxes = Get-Mailbox -ResultSize 'Unlimited' -ErrorAction Stop

        if ($null -eq $mailboxes)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            return ''
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }

        Write-Verbose -Message 'Fetching all users for caching purposes'
        $Script:UsersCache = [System.Collections.Generic.Dictionary[System.String, System.String]]::new()
        Get-User -ResultSize 'Unlimited' | ForEach-Object {
            $Script:UsersCache[$_.Identity] = $_.UserPrincipalName
        }
        Write-Verbose -Message 'Fetching all recipients for caching purposes'
        Get-Recipient -ResultSize 'Unlimited' | ForEach-Object {
            $Script:UsersCache[$_.Identity] = $_.PrimarySmtpAddress
        }

        $i = 1
        foreach ($mailbox in $mailboxes)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($mailboxes.Count)] $($mailbox.UserPrincipalName)" -DeferWrite
            $Params = @{
                Identity              = $mailbox.UserPrincipalName
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
                AccessTokens          = $AccessTokens
            }
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
