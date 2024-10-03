[CmdletBinding()]
param(
)
$M365DSCTestFolder = Join-Path -Path $PSScriptRoot `
                        -ChildPath '..\..\Unit' `
                        -Resolve
$CmdletModule = (Join-Path -Path $M365DSCTestFolder `
            -ChildPath '\Stubs\Microsoft365.psm1' `
            -Resolve)
$GenericStubPath = (Join-Path -Path $M365DSCTestFolder `
    -ChildPath '\Stubs\Generic.psm1' `
    -Resolve)
Import-Module -Name (Join-Path -Path $M365DSCTestFolder `
        -ChildPath '\UnitTestHelper.psm1' `
        -Resolve)

$CurrentScriptPath = $PSCommandPath.Split('\')
$CurrentScriptName = $CurrentScriptPath[$CurrentScriptPath.Length -1]
$ResourceName      = $CurrentScriptName.Split('.')[1]
$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource $ResourceName -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            Mock -CommandName Set-MailboxCalendarConfiguration -MockWith {
                return $null
            }

            
            Mock -CommandName Get-Mailbox -MockWith {
                return @{
                    Id                = '12345-12345-12345-12345-12345'
                    UserPrincipalName = "admin@contoso.com"
                }
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }
        # Test contexts

        Context -Name 'Settings are not in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    AgendaMailIntroductionEnabled            = $True;
                    AutoDeclineWhenBusy                      = $False;
                    ConversationalSchedulingEnabled          = $True;
                    CreateEventsFromEmailAsPrivate           = $True;
                    Credential                               = $Credscredential;
                    DefaultMinutesToReduceLongEventsBy       = 10;
                    DefaultMinutesToReduceShortEventsBy      = 5;
                    DefaultOnlineMeetingProvider             = "TeamsForBusiness";
                    DefaultReminderTime                      = "00:15:00";
                    DeleteMeetingRequestOnRespond            = $True;
                    DiningEventsFromEmailEnabled             = $True;
                    Ensure                                   = "Present";
                    EntertainmentEventsFromEmailEnabled      = $True;
                    EventsFromEmailEnabled                   = $True;
                    FirstWeekOfYear                          = "FirstDay";
                    FlightEventsFromEmailEnabled             = $True;
                    HotelEventsFromEmailEnabled              = $True;
                    Identity                                 = "admin@contoso.com";
                    InvoiceEventsFromEmailEnabled            = $True;
                    LocationDetailsInFreeBusy                = "Desk";
                    PackageDeliveryEventsFromEmailEnabled    = $False;
                    PreserveDeclinedMeetings                 = $False;
                    RemindersEnabled                         = $True;
                    ReminderSoundEnabled                     = $True;
                    RentalCarEventsFromEmailEnabled          = $True;
                    ServiceAppointmentEventsFromEmailEnabled = $True;
                    ShortenEventScopeDefault                 = "None";
                    ShowWeekNumbers                          = $False;
                    TimeIncrement                            = "ThirtyMinutes";
                    UseBrightCalendarColorThemeInOwa         = $False;
                    WeatherEnabled                           = "FirstRun";
                    WeatherLocationBookmark                  = 0;
                    WeatherLocations                         = @();
                    WeatherUnit                              = "Default";
                    WeekStartDay                             = "Sunday";
                    WorkDays                                 = "Monday, Tuesday";
                    WorkingHoursEndTime                      = "17:00:00";
                    WorkingHoursStartTime                    = "08:00:00";
                    WorkingHoursTimeZone                     = "Pacific Standard Time";
                    WorkspaceUserEnabled                     = $False;
                }

                Mock -CommandName Get-MailboxCalendarConfiguration -MockWith {
                    return @{
                        AgendaMailIntroductionEnabled            = $True;
                        AutoDeclineWhenBusy                      = $False;
                        ConversationalSchedulingEnabled          = $True;
                        CreateEventsFromEmailAsPrivate           = $True;
                        Credential                               = $Credscredential;
                        DefaultMinutesToReduceLongEventsBy       = 10;
                        DefaultMinutesToReduceShortEventsBy      = 6; #drift
                        DefaultOnlineMeetingProvider             = "TeamsForBusiness";
                        DefaultReminderTime                      = "00:15:00";
                        DeleteMeetingRequestOnRespond            = $True;
                        DiningEventsFromEmailEnabled             = $True;
                        Ensure                                   = "Present";
                        EntertainmentEventsFromEmailEnabled      = $True;
                        EventsFromEmailEnabled                   = $True;
                        FirstWeekOfYear                          = "FirstDay";
                        FlightEventsFromEmailEnabled             = $True;
                        HotelEventsFromEmailEnabled              = $True;
                        Identity                                 = "admin@contoso.com";
                        InvoiceEventsFromEmailEnabled            = $True;
                        LocationDetailsInFreeBusy                = "Desk";
                        PackageDeliveryEventsFromEmailEnabled    = $False;
                        PreserveDeclinedMeetings                 = $False;
                        RemindersEnabled                         = $True;
                        ReminderSoundEnabled                     = $True;
                        RentalCarEventsFromEmailEnabled          = $True;
                        ServiceAppointmentEventsFromEmailEnabled = $True;
                        ShortenEventScopeDefault                 = "None";
                        ShowWeekNumbers                          = $False;
                        TimeIncrement                            = "ThirtyMinutes";
                        UseBrightCalendarColorThemeInOwa         = $False;
                        WeatherEnabled                           = "FirstRun";
                        WeatherLocationBookmark                  = 0;
                        WeatherLocations                         = @();
                        WeatherUnit                              = "Default";
                        WeekStartDay                             = "Sunday";
                        WorkDays                                 = "Monday, Tuesday";
                        WorkingHoursEndTime                      = "17:00:00";
                        WorkingHoursStartTime                    = "08:00:00";
                        WorkingHoursTimeZone                     = "Pacific Standard Time";
                        WorkspaceUserEnabled                     = $False;

                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-MailboxCalendarConfiguration -Exactly 1
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }

        Context -Name 'Settings are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    AgendaMailIntroductionEnabled            = $True;
                    AutoDeclineWhenBusy                      = $False;
                    ConversationalSchedulingEnabled          = $True;
                    CreateEventsFromEmailAsPrivate           = $True;
                    Credential                               = $Credscredential;
                    DefaultMinutesToReduceLongEventsBy       = 10;
                    DefaultMinutesToReduceShortEventsBy      = 5;
                    DefaultOnlineMeetingProvider             = "TeamsForBusiness";
                    DefaultReminderTime                      = "00:15:00";
                    DeleteMeetingRequestOnRespond            = $True;
                    DiningEventsFromEmailEnabled             = $True;
                    Ensure                                   = "Present";
                    EntertainmentEventsFromEmailEnabled      = $True;
                    EventsFromEmailEnabled                   = $True;
                    FirstWeekOfYear                          = "FirstDay";
                    FlightEventsFromEmailEnabled             = $True;
                    HotelEventsFromEmailEnabled              = $True;
                    Identity                                 = "admin@contoso.com";
                    InvoiceEventsFromEmailEnabled            = $True;
                    LocationDetailsInFreeBusy                = "Desk";
                    PackageDeliveryEventsFromEmailEnabled    = $False;
                    PreserveDeclinedMeetings                 = $False;
                    RemindersEnabled                         = $True;
                    ReminderSoundEnabled                     = $True;
                    RentalCarEventsFromEmailEnabled          = $True;
                    ServiceAppointmentEventsFromEmailEnabled = $True;
                    ShortenEventScopeDefault                 = "None";
                    ShowWeekNumbers                          = $False;
                    TimeIncrement                            = "ThirtyMinutes";
                    UseBrightCalendarColorThemeInOwa         = $False;
                    WeatherEnabled                           = "FirstRun";
                    WeatherLocationBookmark                  = 0;
                    WeatherLocations                         = @();
                    WeatherUnit                              = "Default";
                    WeekStartDay                             = "Sunday";
                    WorkDays                                 = "Monday, Tuesday";
                    WorkingHoursEndTime                      = "17:00:00";
                    WorkingHoursStartTime                    = "08:00:00";
                    WorkingHoursTimeZone                     = "Pacific Standard Time";
                    WorkspaceUserEnabled                     = $False;
                }

                Mock -CommandName Get-MailboxCalendarConfiguration -MockWith {
                    return @{
                        AgendaMailIntroductionEnabled            = $True;
                        AutoDeclineWhenBusy                      = $False;
                        ConversationalSchedulingEnabled          = $True;
                        CreateEventsFromEmailAsPrivate           = $True;
                        Credential                               = $Credscredential;
                        DefaultMinutesToReduceLongEventsBy       = 10;
                        DefaultMinutesToReduceShortEventsBy      = 5;
                        DefaultOnlineMeetingProvider             = "TeamsForBusiness";
                        DefaultReminderTime                      = "00:15:00";
                        DeleteMeetingRequestOnRespond            = $True;
                        DiningEventsFromEmailEnabled             = $True;
                        Ensure                                   = "Present";
                        EntertainmentEventsFromEmailEnabled      = $True;
                        EventsFromEmailEnabled                   = $True;
                        FirstWeekOfYear                          = "FirstDay";
                        FlightEventsFromEmailEnabled             = $True;
                        HotelEventsFromEmailEnabled              = $True;
                        Identity                                 = "admin@contoso.com";
                        InvoiceEventsFromEmailEnabled            = $True;
                        LocationDetailsInFreeBusy                = "Desk";
                        PackageDeliveryEventsFromEmailEnabled    = $False;
                        PreserveDeclinedMeetings                 = $False;
                        RemindersEnabled                         = $True;
                        ReminderSoundEnabled                     = $True;
                        RentalCarEventsFromEmailEnabled          = $True;
                        ServiceAppointmentEventsFromEmailEnabled = $True;
                        ShortenEventScopeDefault                 = "None";
                        ShowWeekNumbers                          = $False;
                        TimeIncrement                            = "ThirtyMinutes";
                        UseBrightCalendarColorThemeInOwa         = $False;
                        WeatherEnabled                           = "FirstRun";
                        WeatherLocationBookmark                  = 0;
                        WeatherLocations                         = @();
                        WeatherUnit                              = "Default";
                        WeekStartDay                             = "Sunday";
                        WorkDays                                 = "Monday, Tuesday";
                        WorkingHoursEndTime                      = "17:00:00";
                        WorkingHoursStartTime                    = "08:00:00";
                        WorkingHoursTimeZone                     = "Pacific Standard Time";
                        WorkspaceUserEnabled                     = $False;
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }

        Context -Name "User doesn't exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    AgendaMailIntroductionEnabled            = $True;
                    AutoDeclineWhenBusy                      = $False;
                    ConversationalSchedulingEnabled          = $True;
                    CreateEventsFromEmailAsPrivate           = $True;
                    Credential                               = $Credscredential;
                    DefaultMinutesToReduceLongEventsBy       = 10;
                    DefaultMinutesToReduceShortEventsBy      = 5;
                    DefaultOnlineMeetingProvider             = "TeamsForBusiness";
                    DefaultReminderTime                      = "00:15:00";
                    DeleteMeetingRequestOnRespond            = $True;
                    DiningEventsFromEmailEnabled             = $True;
                    Ensure                                   = "Present";
                    EntertainmentEventsFromEmailEnabled      = $True;
                    EventsFromEmailEnabled                   = $True;
                    FirstWeekOfYear                          = "FirstDay";
                    FlightEventsFromEmailEnabled             = $True;
                    HotelEventsFromEmailEnabled              = $True;
                    Identity                                 = "admin@contoso.com";
                    InvoiceEventsFromEmailEnabled            = $True;
                    LocationDetailsInFreeBusy                = "Desk";
                    PackageDeliveryEventsFromEmailEnabled    = $False;
                    PreserveDeclinedMeetings                 = $False;
                    RemindersEnabled                         = $True;
                    ReminderSoundEnabled                     = $True;
                    RentalCarEventsFromEmailEnabled          = $True;
                    ServiceAppointmentEventsFromEmailEnabled = $True;
                    ShortenEventScopeDefault                 = "None";
                    ShowWeekNumbers                          = $False;
                    TimeIncrement                            = "ThirtyMinutes";
                    UseBrightCalendarColorThemeInOwa         = $False;
                    WeatherEnabled                           = "FirstRun";
                    WeatherLocationBookmark                  = 0;
                    WeatherLocations                         = @();
                    WeatherUnit                              = "Default";
                    WeekStartDay                             = "Sunday";
                    WorkDays                                 = "Monday, Tuesday";
                    WorkingHoursEndTime                      = "17:00:00";
                    WorkingHoursStartTime                    = "08:00:00";
                    WorkingHoursTimeZone                     = "Pacific Standard Time";
                    WorkspaceUserEnabled                     = $False;
                }

                Mock -CommandName Get-MailboxCalendarConfiguration -MockWith {
                    return $null
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
        }




        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential  = $Credential;
                }

                Mock -CommandName Get-Mailbox -MockWith {
                    return @{
                        Id                = '12345-12345-12345-12345-12345'
                        UserPrincipalName = "admin@contoso.com"
                    }
                }

                Mock -CommandName Get-MailboxCalendarConfiguration -MockWith {
                    return @{
                        AgendaMailIntroductionEnabled            = $True;
                        AutoDeclineWhenBusy                      = $False;
                        ConversationalSchedulingEnabled          = $True;
                        CreateEventsFromEmailAsPrivate           = $True;
                        Credential                               = $Credscredential;
                        DefaultMinutesToReduceLongEventsBy       = 10;
                        DefaultMinutesToReduceShortEventsBy      = 5;
                        DefaultOnlineMeetingProvider             = "TeamsForBusiness";
                        DefaultReminderTime                      = "00:15:00";
                        DeleteMeetingRequestOnRespond            = $True;
                        DiningEventsFromEmailEnabled             = $True;
                        Ensure                                   = "Present";
                        EntertainmentEventsFromEmailEnabled      = $True;
                        EventsFromEmailEnabled                   = $True;
                        FirstWeekOfYear                          = "FirstDay";
                        FlightEventsFromEmailEnabled             = $True;
                        HotelEventsFromEmailEnabled              = $True;
                        Identity                                 = "admin@contoso.com";
                        InvoiceEventsFromEmailEnabled            = $True;
                        LocationDetailsInFreeBusy                = "Desk";
                        PackageDeliveryEventsFromEmailEnabled    = $False;
                        PreserveDeclinedMeetings                 = $False;
                        RemindersEnabled                         = $True;
                        ReminderSoundEnabled                     = $True;
                        RentalCarEventsFromEmailEnabled          = $True;
                        ServiceAppointmentEventsFromEmailEnabled = $True;
                        ShortenEventScopeDefault                 = "None";
                        ShowWeekNumbers                          = $False;
                        TimeIncrement                            = "ThirtyMinutes";
                        UseBrightCalendarColorThemeInOwa         = $False;
                        WeatherEnabled                           = "FirstRun";
                        WeatherLocationBookmark                  = 0;
                        WeatherLocations                         = @();
                        WeatherUnit                              = "Default";
                        WeekStartDay                             = "Sunday";
                        WorkDays                                 = "Monday, Tuesday";
                        WorkingHoursEndTime                      = "17:00:00";
                        WorkingHoursStartTime                    = "08:00:00";
                        WorkingHoursTimeZone                     = "Pacific Standard Time";
                        WorkspaceUserEnabled                     = $False;
                    }
                }
            }
            It 'Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
