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
        $AgendaMailIntroductionEnabled,

        [Parameter()]
        [System.Boolean]
        $AutoDeclineWhenBusy,

        [Parameter()]
        [System.String]
        $CalendarFeedsPreferredLanguage,

        [Parameter()]
        [System.String]
        $CalendarFeedsPreferredRegion,

        [Parameter()]
        [System.String]
        $CalendarFeedsRootPageId,

        [Parameter()]
        [System.Boolean]
        $ConversationalSchedulingEnabled,

        [Parameter()]
        [System.Boolean]
        $CreateEventsFromEmailAsPrivate,

        [Parameter()]
        [System.Int32]
        $DefaultMinutesToReduceLongEventsBy,

        [Parameter()]
        [System.Int32]
        $DefaultMinutesToReduceShortEventsBy,

        [Parameter()]
        [System.String]
        $DefaultOnlineMeetingProvider,

        [Parameter()]
        [System.TimeSpan]
        $DefaultReminderTime,

        [Parameter()]
        [System.Boolean]
        $DeleteMeetingRequestOnRespond,

        [Parameter()]
        [System.Boolean]
        $DiningEventsFromEmailEnabled,

        [Parameter()]
        [System.Boolean]
        $EntertainmentEventsFromEmailEnabled,

        [Parameter()]
        [System.Boolean]
        $EventsFromEmailEnabled,

        [Parameter()]
        [System.String]
        $FirstWeekOfYear,

        [Parameter()]
        [System.Boolean]
        $FlightEventsFromEmailEnabled,

        [Parameter()]
        [System.Boolean]
        $HotelEventsFromEmailEnabled,

        [Parameter()]
        [System.Boolean]
        $InvoiceEventsFromEmailEnabled,

        [Parameter()]
        [System.String]
        $LocationDetailsInFreeBusy,

        [Parameter()]
        [System.String]
        $MailboxLocation,

        [Parameter()]
        [System.Boolean]
        $OnlineMeetingsByDefaultEnabled,

        [Parameter()]
        [System.Boolean]
        $PackageDeliveryEventsFromEmailEnabled,

        [Parameter()]
        [System.Boolean]
        $PreserveDeclinedMeetings,

        [Parameter()]
        [System.Boolean]
        $RemindersEnabled,

        [Parameter()]
        [System.Boolean]
        $ReminderSoundEnabled,

        [Parameter()]
        [System.Boolean]
        $RentalCarEventsFromEmailEnabled,

        [Parameter()]
        [System.Boolean]
        $ServiceAppointmentEventsFromEmailEnabled,

        [Parameter()]
        [System.String]
        $ShortenEventScopeDefault,

        [Parameter()]
        [System.Boolean]
        $ShowWeekNumbers,

        [Parameter()]
        [System.String]
        $TimeIncrement,

        [Parameter()]
        [System.Boolean]
        $UseBrightCalendarColorThemeInOwa,

        [Parameter()]
        [System.String]
        $WeatherEnabled,

        [Parameter()]
        [System.Int32]
        $WeatherLocationBookmark,

        [Parameter()]
        [System.String[]]
        $WeatherLocations,

        [Parameter()]
        [System.String]
        $WeatherUnit,

        [Parameter()]
        [System.String]
        $WeekStartDay,

        [Parameter()]
        [System.String]
        $WorkDays,

        [Parameter()]
        [System.TimeSpan]
        $WorkingHoursEndTime,

        [Parameter()]
        [System.TimeSpan]
        $WorkingHoursStartTime,

        [Parameter()]
        [System.String]
        $WorkingHoursTimeZone,

        [Parameter()]
        [System.Boolean]
        $WorkspaceUserEnabled,

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

    New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters | Out-Null

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullResult = $PSBoundParameters
    $nullResult.Ensure = 'Absent'
    try
    {
        $config = Get-MailboxCalendarConfiguration -Identity $Identity -ErrorAction Stop

        if ($null -eq $config)
        {
            return $nullResult 
        }

        $results = @{
            Ensure                              = 'Present'
            Identity                            = $Identity
            AgendaMailIntroductionEnabled       = $config.AgendaMailIntroductionEnabled
            AutoDeclineWhenBusy                 = $config.AutoDeclineWhenBusy
            CalendarFeedsPreferredLanguage      = $config.CalendarFeedsPreferredLanguage
            CalendarFeedsPreferredRegion        = $config.CalendarFeedsPreferredRegion
            CalendarFeedsRootPageId             = $config.CalendarFeedsRootPageId
            ConversationalSchedulingEnabled     = $config.ConversationalSchedulingEnabled
            CreateEventsFromEmailAsPrivate      = $config.CreateEventsFromEmailAsPrivate
            DefaultMinutesToReduceLongEventsBy  = $config.DefaultMinutesToReduceLongEventsBy
            DefaultMinutesToReduceShortEventsBy = $config.DefaultMinutesToReduceShortEventsBy
            DefaultOnlineMeetingProvider        = $config.DefaultOnlineMeetingProvider
            DefaultReminderTime                 = $config.DefaultReminderTime
            DeleteMeetingRequestOnRespond       = $config.DeleteMeetingRequestOnRespond
            DiningEventsFromEmailEnabled        = $config.DiningEventsFromEmailEnabled
            EntertainmentEventsFromEmailEnabled = $config.EntertainmentEventsFromEmailEnabled
            EventsFromEmailEnabled              = $config.EventsFromEmailEnabled
            FirstWeekOfYear                     = $config.FirstWeekOfYear
            FlightEventsFromEmailEnabled        = $config.FlightEventsFromEmailEnabled
            HotelEventsFromEmailEnabled         = $config.HotelEventsFromEmailEnabled
            InvoiceEventsFromEmailEnabled       = $config.InvoiceEventsFromEmailEnabled
            LocationDetailsInFreeBusy           = $config.LocationDetailsInFreeBusy
            MailboxLocation                     = $config.MailboxLocation
            OnlineMeetingsByDefaultEnabled      = $config.OnlineMeetingsByDefaultEnabled
            PackageDeliveryEventsFromEmailEnabled = $config.PackageDeliveryEventsFromEmailEnabled
            PreserveDeclinedMeetings            = $config.PreserveDeclinedMeetings
            RemindersEnabled                    = $config.RemindersEnabled
            ReminderSoundEnabled                = $config.ReminderSoundEnabled
            RentalCarEventsFromEmailEnabled     = $config.RentalCarEventsFromEmailEnabled
            ServiceAppointmentEventsFromEmailEnabled = $config.ServiceAppointmentEventsFromEmailEnabled
            ShortenEventScopeDefault            = $config.ShortenEventScopeDefault
            ShowWeekNumbers                     = $config.ShowWeekNumbers
            TimeIncrement                       = $config.TimeIncrement
            UseBrightCalendarColorThemeInOwa    = $config.UseBrightCalendarColorThemeInOwa
            WeatherEnabled                      = $config.WeatherEnabled
            WeatherLocationBookmark             = $config.WeatherLocationBookmark
            WeatherLocations                    = [Array]$config.WeatherLocations
            WeatherUnit                         = $config.WeatherUnit
            WeekStartDay                        = $config.WeekStartDay
            WorkDays                            = $config.WorkDays
            WorkingHoursEndTime                 = $config.WorkingHoursEndTime
            WorkingHoursStartTime               = $config.WorkingHoursStartTime
            WorkingHoursTimeZone                = $config.WorkingHoursTimeZone
            WorkspaceUserEnabled                = $config.WorkspaceUserEnabled
            Credential                          = $Credential
            ApplicationId                       = $ApplicationId
            TenantId                            = $TenantId
            CertificateThumbprint               = $CertificateThumbprint
            ManagedIdentity                     = $ManagedIdentity.IsPresent
            AccessTokens                        = $AccessTokens
        }
        return [System.Collections.Hashtable] $results
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $nullResult
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
        $AgendaMailIntroductionEnabled,

        [Parameter()]
        [System.Boolean]
        $AutoDeclineWhenBusy,

        [Parameter()]
        [System.String]
        $CalendarFeedsPreferredLanguage,

        [Parameter()]
        [System.String]
        $CalendarFeedsPreferredRegion,

        [Parameter()]
        [System.String]
        $CalendarFeedsRootPageId,

        [Parameter()]
        [System.Boolean]
        $ConversationalSchedulingEnabled,

        [Parameter()]
        [System.Boolean]
        $CreateEventsFromEmailAsPrivate,

        [Parameter()]
        [System.Int32]
        $DefaultMinutesToReduceLongEventsBy,

        [Parameter()]
        [System.Int32]
        $DefaultMinutesToReduceShortEventsBy,

        [Parameter()]
        [System.String]
        $DefaultOnlineMeetingProvider,

        [Parameter()]
        [System.TimeSpan]
        $DefaultReminderTime,

        [Parameter()]
        [System.Boolean]
        $DeleteMeetingRequestOnRespond,

        [Parameter()]
        [System.Boolean]
        $DiningEventsFromEmailEnabled,

        [Parameter()]
        [System.Boolean]
        $EntertainmentEventsFromEmailEnabled,

        [Parameter()]
        [System.Boolean]
        $EventsFromEmailEnabled,

        [Parameter()]
        [System.String]
        $FirstWeekOfYear,

        [Parameter()]
        [System.Boolean]
        $FlightEventsFromEmailEnabled,

        [Parameter()]
        [System.Boolean]
        $HotelEventsFromEmailEnabled,

        [Parameter()]
        [System.Boolean]
        $InvoiceEventsFromEmailEnabled,

        [Parameter()]
        [System.String]
        $LocationDetailsInFreeBusy,

        [Parameter()]
        [System.String]
        $MailboxLocation,

        [Parameter()]
        [System.Boolean]
        $OnlineMeetingsByDefaultEnabled,

        [Parameter()]
        [System.Boolean]
        $PackageDeliveryEventsFromEmailEnabled,

        [Parameter()]
        [System.Boolean]
        $PreserveDeclinedMeetings,

        [Parameter()]
        [System.Boolean]
        $RemindersEnabled,

        [Parameter()]
        [System.Boolean]
        $ReminderSoundEnabled,

        [Parameter()]
        [System.Boolean]
        $RentalCarEventsFromEmailEnabled,

        [Parameter()]
        [System.Boolean]
        $ServiceAppointmentEventsFromEmailEnabled,

        [Parameter()]
        [System.String]
        $ShortenEventScopeDefault,

        [Parameter()]
        [System.Boolean]
        $ShowWeekNumbers,

        [Parameter()]
        [System.String]
        $TimeIncrement,

        [Parameter()]
        [System.Boolean]
        $UseBrightCalendarColorThemeInOwa,

        [Parameter()]
        [System.String]
        $WeatherEnabled,

        [Parameter()]
        [System.Int32]
        $WeatherLocationBookmark,

        [Parameter()]
        [System.String[]]
        $WeatherLocations,

        [Parameter()]
        [System.String]
        $WeatherUnit,

        [Parameter()]
        [System.String]
        $WeekStartDay,

        [Parameter()]
        [System.String]
        $WorkDays,

        [Parameter()]
        [System.TimeSpan]
        $WorkingHoursEndTime,

        [Parameter()]
        [System.TimeSpan]
        $WorkingHoursStartTime,

        [Parameter()]
        [System.String]
        $WorkingHoursTimeZone,

        [Parameter()]
        [System.Boolean]
        $WorkspaceUserEnabled,

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

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentInstance = Get-TargetResource @PSBoundParameters

    $setParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    Set-MailboxCalendarConfiguration @SetParameters
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
        $AgendaMailIntroductionEnabled,

        [Parameter()]
        [System.Boolean]
        $AutoDeclineWhenBusy,

        [Parameter()]
        [System.String]
        $CalendarFeedsPreferredLanguage,

        [Parameter()]
        [System.String]
        $CalendarFeedsPreferredRegion,

        [Parameter()]
        [System.String]
        $CalendarFeedsRootPageId,

        [Parameter()]
        [System.Boolean]
        $ConversationalSchedulingEnabled,

        [Parameter()]
        [System.Boolean]
        $CreateEventsFromEmailAsPrivate,

        [Parameter()]
        [System.Int32]
        $DefaultMinutesToReduceLongEventsBy,

        [Parameter()]
        [System.Int32]
        $DefaultMinutesToReduceShortEventsBy,

        [Parameter()]
        [System.String]
        $DefaultOnlineMeetingProvider,

        [Parameter()]
        [System.TimeSpan]
        $DefaultReminderTime,

        [Parameter()]
        [System.Boolean]
        $DeleteMeetingRequestOnRespond,

        [Parameter()]
        [System.Boolean]
        $DiningEventsFromEmailEnabled,

        [Parameter()]
        [System.Boolean]
        $EntertainmentEventsFromEmailEnabled,

        [Parameter()]
        [System.Boolean]
        $EventsFromEmailEnabled,

        [Parameter()]
        [System.String]
        $FirstWeekOfYear,

        [Parameter()]
        [System.Boolean]
        $FlightEventsFromEmailEnabled,

        [Parameter()]
        [System.Boolean]
        $HotelEventsFromEmailEnabled,

        [Parameter()]
        [System.Boolean]
        $InvoiceEventsFromEmailEnabled,

        [Parameter()]
        [System.String]
        $LocationDetailsInFreeBusy,

        [Parameter()]
        [System.String]
        $MailboxLocation,

        [Parameter()]
        [System.Boolean]
        $OnlineMeetingsByDefaultEnabled,

        [Parameter()]
        [System.Boolean]
        $PackageDeliveryEventsFromEmailEnabled,

        [Parameter()]
        [System.Boolean]
        $PreserveDeclinedMeetings,

        [Parameter()]
        [System.Boolean]
        $RemindersEnabled,

        [Parameter()]
        [System.Boolean]
        $ReminderSoundEnabled,

        [Parameter()]
        [System.Boolean]
        $RentalCarEventsFromEmailEnabled,

        [Parameter()]
        [System.Boolean]
        $ServiceAppointmentEventsFromEmailEnabled,

        [Parameter()]
        [System.String]
        $ShortenEventScopeDefault,

        [Parameter()]
        [System.Boolean]
        $ShowWeekNumbers,

        [Parameter()]
        [System.String]
        $TimeIncrement,

        [Parameter()]
        [System.Boolean]
        $UseBrightCalendarColorThemeInOwa,

        [Parameter()]
        [System.String]
        $WeatherEnabled,

        [Parameter()]
        [System.Int32]
        $WeatherLocationBookmark,

        [Parameter()]
        [System.String[]]
        $WeatherLocations,

        [Parameter()]
        [System.String]
        $WeatherUnit,

        [Parameter()]
        [System.String]
        $WeekStartDay,

        [Parameter()]
        [System.String]
        $WorkDays,

        [Parameter()]
        [System.TimeSpan]
        $WorkingHoursEndTime,

        [Parameter()]
        [System.TimeSpan]
        $WorkingHoursStartTime,

        [Parameter()]
        [System.String]
        $WorkingHoursTimeZone,

        [Parameter()]
        [System.Boolean]
        $WorkspaceUserEnabled,

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

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).Clone()

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $testResult"

    return $testResult
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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

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

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        $Script:ExportMode = $true
        [array] $Script:exportedInstances = Get-Mailbox -ResultSize 'Unlimited' -ErrorAction Stop

        $i = 1
        $dscContent = ''
        if ($Script:exportedInstances.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($config in $Script:exportedInstances)
        {
            $displayedKey = $config.UserPrincipalName
            Write-Host "    |---[$i/$($Script:exportedInstances.Count)] $displayedKey" -NoNewline
            $params = @{
                Identity              = $config.UserPrincipalName
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
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
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
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
