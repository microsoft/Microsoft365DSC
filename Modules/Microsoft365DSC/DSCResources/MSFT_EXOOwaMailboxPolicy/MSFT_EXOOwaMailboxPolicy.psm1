function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateLength(1, 64)]
        [System.String]
        $Name,

        [Parameter()]
        [ValidateSet('Allow', 'ForceSave', 'Block')]
        [System.String]
        $ActionForUnknownFileAndMIMETypes,

        [Parameter()]
        [System.Boolean]
        $ActiveSyncIntegrationEnabled,

        [Parameter()]
        [System.Boolean]
        $AdditionalStorageProvidersAvailable,

        [Parameter()]
        [System.Boolean]
        $AllAddressListsEnabled,

        [Parameter()]
        [System.Boolean]
        $AllowCopyContactsToDeviceAddressBook,

        [Parameter()]
        [System.String[]]
        $AllowedFileTypes,

        [Parameter()]
        [System.String[]]
        $AllowedMimeTypes,

        [Parameter()]
        [System.String[]]
        $BlockedFileTypes,

        [Parameter()]
        [System.String[]]
        $BlockedMimeTypes,

        [Parameter()]
        [System.Boolean]
        $ClassicAttachmentsEnabled,

        [Parameter()]
        [ValidateSet('Off', 'ReadOnly', 'ReadOnlyPlusAttachmentsBlocked')]
        [System.String]
        $ConditionalAccessPolicy,

        [Parameter()]
        [System.String]
        $DefaultTheme,

        [Parameter()]
        [System.Boolean]
        $DirectFileAccessOnPrivateComputersEnabled,

        [Parameter()]
        [System.Boolean]
        $DirectFileAccessOnPublicComputersEnabled,

        [Parameter()]
        [System.Boolean]
        $DisableFacebook,

        [Parameter()]
        [System.Boolean]
        $DisplayPhotosEnabled,

        [Parameter()]
        [System.Boolean]
        $ExplicitLogonEnabled,

        [Parameter()]
        [System.Boolean]
        $ExternalImageProxyEnabled,

        [Parameter()]
        [System.String]
        $ExternalSPMySiteHostURL,

        [Parameter()]
        [System.Boolean]
        $ForceSaveAttachmentFilteringEnabled,

        [Parameter()]
        [System.String[]]
        $ForceSaveFileTypes,

        [Parameter()]
        [System.String[]]
        $ForceSaveMimeTypes,

        [Parameter()]
        [System.Boolean]
        $ForceWacViewingFirstOnPrivateComputers,

        [Parameter()]
        [System.Boolean]
        $ForceWacViewingFirstOnPublicComputers,

        [Parameter()]
        [System.Boolean]
        $FreCardsEnabled,

        [Parameter()]
        [System.Boolean]
        $GlobalAddressListEnabled,

        [Parameter()]
        [System.Boolean]
        $GroupCreationEnabled,

        [Parameter()]
        [System.Boolean]
        $InstantMessagingEnabled,

        [Parameter()]
        [ValidateSet('None', 'Ocs')]
        [System.String]
        $InstantMessagingType,

        [Parameter()]
        [System.Boolean]
        $InterestingCalendarsEnabled,

        [Parameter()]
        [System.String]
        $InternalSPMySiteHostURL,

        [Parameter()]
        [System.Boolean]
        $IRMEnabled,

        [Parameter()]
        [System.Boolean]
        $IsDefault,

        [Parameter()]
        [System.Boolean]
        $JournalEnabled,

        [Parameter()]
        [System.Boolean]
        $LocalEventsEnabled,

        [Parameter()]
        [System.Int32]
        $LogonAndErrorLanguage,

        [Parameter()]
        [System.Boolean]
        $NotesEnabled,

        [Parameter()]
        [System.Boolean]
        $NpsSurveysEnabled,

        [Parameter()]
        [System.Boolean]
        $OrganizationEnabled,

        [Parameter()]
        [System.Boolean]
        $OnSendAddinsEnabled,

        [Parameter()]
        [ValidateSet('AutoDetect', 'AlwaysUTF8', 'UserLanguageChoice')]
        [System.String]
        $OutboundCharset,

        [Parameter()]
        [System.Boolean]
        $OutlookBetaToggleEnabled,

        [Parameter()]
        [System.Boolean]
        $OWALightEnabled,

        [Parameter()]
        [System.Boolean]
        $PersonalAccountCalendarsEnabled,

        [Parameter()]
        [System.Boolean]
        $PhoneticSupportEnabled,

        [Parameter()]
        [System.Boolean]
        $PlacesEnabled,

        [Parameter()]
        [System.Boolean]
        $PremiumClientEnabled,

        [Parameter()]
        [System.Boolean]
        $PrintWithoutDownloadEnabled,

        [Parameter()]
        [System.Boolean]
        $PublicFoldersEnabled,

        [Parameter()]
        [System.Boolean]
        $RecoverDeletedItemsEnabled,

        [Parameter()]
        [System.Boolean]
        $ReferenceAttachmentsEnabled,

        [Parameter()]
        [System.Boolean]
        $RemindersAndNotificationsEnabled,

        [Parameter()]
        [System.Boolean]
        $ReportJunkEmailEnabled,

        [Parameter()]
        [System.Boolean]
        $RulesEnabled,

        [Parameter()]
        [System.Boolean]
        $SatisfactionEnabled,

        [Parameter()]
        [System.Boolean]
        $SaveAttachmentsToCloudEnabled,

        [Parameter()]
        [System.Boolean]
        $SearchFoldersEnabled,

        [Parameter()]
        [System.Boolean]
        $SetPhotoEnabled,

        [Parameter()]
        [System.String]
        $SetPhotoURL,

        [Parameter()]
        [System.Boolean]
        $SignaturesEnabled,

        [Parameter()]
        [System.Boolean]
        $SkipCreateUnifiedGroupCustomSharepointClassification,

        [Parameter()]
        [System.Boolean]
        $TeamSnapCalendarsEnabled,

        [Parameter()]
        [System.Boolean]
        $TextMessagingEnabled,

        [Parameter()]
        [System.Boolean]
        $ThemeSelectionEnabled,

        [Parameter()]
        [System.Boolean]
        $UMIntegrationEnabled,

        [Parameter()]
        [System.Boolean]
        $UseGB18030,

        [Parameter()]
        [System.Boolean]
        $UseISO885915,

        [Parameter()]
        [System.Boolean]
        $UserVoiceEnabled,

        [Parameter()]
        [System.Boolean]
        $WacEditingEnabled,

        [Parameter()]
        [System.Boolean]
        $WacExternalServicesEnabled,

        [Parameter()]
        [System.Boolean]
        $WacOMEXEnabled,

        [Parameter()]
        [System.Boolean]
        $WacViewingOnPrivateComputersEnabled,

        [Parameter()]
        [System.Boolean]
        $WacViewingOnPublicComputersEnabled,

        [Parameter()]
        [System.Boolean]
        $WeatherEnabled,

        [Parameter()]
        [ValidateSet('None', 'SameOrigin', 'Deny')]
        [System.String]
        $WebPartsFrameOptionsType,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

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
        $CertificatePassword
    )

    Write-Verbose -Message "Getting OWA Mailbox Policy configuration for $Name"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    if ($Global:CurrentModeIsExport)
    {
        $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters `
            -SkipModuleReload $true
    }
    else
    {
        $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters
    }
    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"
    try
    {
        $AllOwaMailboxPolicies = Get-OwaMailboxPolicy -ErrorAction Stop

        $OwaMailboxPolicy = $AllOwaMailboxPolicies | Where-Object -FilterScript { $_.Name -eq $Name }

        if ($null -eq $OwaMailboxPolicy)
        {
            Write-Verbose -Message "OWA Mailbox Policy $($Name) does not exist."
            return $nullReturn
        }
        else
        {
            $result = @{
                Name                                                 = $OwaMailboxPolicy.Name
                ActionForUnknownFileAndMIMETypes                     = $OwaMailboxPolicy.ActionForUnknownFileAndMIMETypes
                ActiveSyncIntegrationEnabled                         = $OwaMailboxPolicy.ActiveSyncIntegrationEnabled
                AdditionalStorageProvidersAvailable                  = $OwaMailboxPolicy.AdditionalStorageProvidersAvailable
                AllAddressListsEnabled                               = $OwaMailboxPolicy.AllAddressListsEnabled
                AllowCopyContactsToDeviceAddressBook                 = $OwaMailboxPolicy.AllowCopyContactsToDeviceAddressBook
                AllowedFileTypes                                     = $OwaMailboxPolicy.AllowedFileTypes
                AllowedMimeTypes                                     = $OwaMailboxPolicy.AllowedMimeTypes
                BlockedFileTypes                                     = $OwaMailboxPolicy.BlockedFileTypes
                BlockedMimeTypes                                     = $OwaMailboxPolicy.BlockedMimeTypes
                ClassicAttachmentsEnabled                            = $OwaMailboxPolicy.ClassicAttachmentsEnabled
                ConditionalAccessPolicy                              = $OwaMailboxPolicy.ConditionalAccessPolicy
                DefaultTheme                                         = $OwaMailboxPolicy.DefaultTheme
                DirectFileAccessOnPrivateComputersEnabled            = $OwaMailboxPolicy.DirectFileAccessOnPrivateComputersEnabled
                DirectFileAccessOnPublicComputersEnabled             = $OwaMailboxPolicy.DirectFileAccessOnPublicComputersEnabled
                DisableFacebook                                      = $OwaMailboxPolicy.DisableFacebook
                DisplayPhotosEnabled                                 = $OwaMailboxPolicy.DisplayPhotosEnabled
                ExplicitLogonEnabled                                 = $OwaMailboxPolicy.ExplicitLogonEnabled
                ExternalImageProxyEnabled                            = $OwaMailboxPolicy.ExternalImageProxyEnabled
                ExternalSPMySiteHostURL                              = $OwaMailboxPolicy.ExternalSPMySiteHostURL
                ForceSaveAttachmentFilteringEnabled                  = $OwaMailboxPolicy.ForceSaveAttachmentFilteringEnabled
                ForceSaveFileTypes                                   = $OwaMailboxPolicy.ForceSaveFileTypes
                ForceSaveMimeTypes                                   = $OwaMailboxPolicy.ForceSaveMimeTypes
                ForceWacViewingFirstOnPrivateComputers               = $OwaMailboxPolicy.ForceWacViewingFirstOnPrivateComputers
                ForceWacViewingFirstOnPublicComputers                = $OwaMailboxPolicy.ForceWacViewingFirstOnPublicComputers
                FreCardsEnabled                                      = $OwaMailboxPolicy.FreCardsEnabled
                GlobalAddressListEnabled                             = $OwaMailboxPolicy.GlobalAddressListEnabled
                GroupCreationEnabled                                 = $OwaMailboxPolicy.GroupCreationEnabled
                InstantMessagingEnabled                              = $OwaMailboxPolicy.InstantMessagingEnabled
                InstantMessagingType                                 = $OwaMailboxPolicy.InstantMessagingType
                InterestingCalendarsEnabled                          = $OwaMailboxPolicy.InterestingCalendarsEnabled
                InternalSPMySiteHostURL                              = $OwaMailboxPolicy.InternalSPMySiteHostURL
                IRMEnabled                                           = $OwaMailboxPolicy.IRMEnabled
                IsDefault                                            = $OwaMailboxPolicy.IsDefault
                JournalEnabled                                       = $OwaMailboxPolicy.JournalEnabled
                LocalEventsEnabled                                   = $OwaMailboxPolicy.LocalEventsEnabled
                LogonAndErrorLanguage                                = $OwaMailboxPolicy.LogonAndErrorLanguage
                NotesEnabled                                         = $OwaMailboxPolicy.NotesEnabled
                NpsSurveysEnabled                                    = $OwaMailboxPolicy.NpsSurveysEnabled
                OrganizationEnabled                                  = $OwaMailboxPolicy.OrganizationEnabled
                OnSendAddinsEnabled                                  = $OwaMailboxPolicy.OnSendAddinsEnabled
                OutboundCharset                                      = $OwaMailboxPolicy.OutboundCharset
                OutlookBetaToggleEnabled                             = $OwaMailboxPolicy.OutlookBetaToggleEnabled
                OWALightEnabled                                      = $OwaMailboxPolicy.OWALightEnabled
                PersonalAccountCalendarsEnabled                      = $OwaMailboxPolicy.PersonalAccountCalendarsEnabled
                PhoneticSupportEnabled                               = $OwaMailboxPolicy.PhoneticSupportEnabled
                PlacesEnabled                                        = $OwaMailboxPolicy.PlacesEnabled
                PremiumClientEnabled                                 = $OwaMailboxPolicy.PremiumClientEnabled
                PrintWithoutDownloadEnabled                          = $OwaMailboxPolicy.PrintWithoutDownloadEnabled
                PublicFoldersEnabled                                 = $OwaMailboxPolicy.PublicFoldersEnabled
                RecoverDeletedItemsEnabled                           = $OwaMailboxPolicy.RecoverDeletedItemsEnabled
                ReferenceAttachmentsEnabled                          = $OwaMailboxPolicy.ReferenceAttachmentsEnabled
                RemindersAndNotificationsEnabled                     = $OwaMailboxPolicy.RemindersAndNotificationsEnabled
                ReportJunkEmailEnabled                               = $OwaMailboxPolicy.ReportJunkEmailEnabled
                RulesEnabled                                         = $OwaMailboxPolicy.RulesEnabled
                SatisfactionEnabled                                  = $OwaMailboxPolicy.SatisfactionEnabled
                SaveAttachmentsToCloudEnabled                        = $OwaMailboxPolicy.SaveAttachmentsToCloudEnabled
                SearchFoldersEnabled                                 = $OwaMailboxPolicy.SearchFoldersEnabled
                SetPhotoEnabled                                      = $OwaMailboxPolicy.SetPhotoEnabled
                SetPhotoURL                                          = $OwaMailboxPolicy.SetPhotoURL
                SignaturesEnabled                                    = $OwaMailboxPolicy.SignaturesEnabled
                SkipCreateUnifiedGroupCustomSharepointClassification = $OwaMailboxPolicy.SkipCreateUnifiedGroupCustomSharepointClassification
                TeamSnapCalendarsEnabled                             = $OwaMailboxPolicy.TeamSnapCalendarsEnabled
                TextMessagingEnabled                                 = $OwaMailboxPolicy.TextMessagingEnabled
                ThemeSelectionEnabled                                = $OwaMailboxPolicy.ThemeSelectionEnabled
                UMIntegrationEnabled                                 = $OwaMailboxPolicy.UMIntegrationEnabled
                UseGB18030                                           = $OwaMailboxPolicy.UseGB18030
                UseISO885915                                         = $OwaMailboxPolicy.UseISO885915
                UserVoiceEnabled                                     = $OwaMailboxPolicy.UserVoiceEnabled
                WacEditingEnabled                                    = $OwaMailboxPolicy.WacEditingEnabled
                WacExternalServicesEnabled                           = $OwaMailboxPolicy.WacExternalServicesEnabled
                WacOMEXEnabled                                       = $OwaMailboxPolicy.WacOMEXEnabled
                WacViewingOnPrivateComputersEnabled                  = $OwaMailboxPolicy.WacViewingOnPrivateComputersEnabled
                WacViewingOnPublicComputersEnabled                   = $OwaMailboxPolicy.WacViewingOnPublicComputersEnabled
                WeatherEnabled                                       = $OwaMailboxPolicy.WeatherEnabled
                WebPartsFrameOptionsType                             = $OwaMailboxPolicy.WebPartsFrameOptionsType
                Ensure                                               = 'Present'
                GlobalAdminAccount                                   = $GlobalAdminAccount
            }

            Write-Verbose -Message "Found OWA Mailbox Policy $($Name)"
            return $result
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
        [ValidateLength(1, 64)]
        [System.String]
        $Name,

        [Parameter()]
        [ValidateSet('Allow', 'ForceSave', 'Block')]
        [System.String]
        $ActionForUnknownFileAndMIMETypes,

        [Parameter()]
        [System.Boolean]
        $ActiveSyncIntegrationEnabled,

        [Parameter()]
        [System.Boolean]
        $AdditionalStorageProvidersAvailable,

        [Parameter()]
        [System.Boolean]
        $AllAddressListsEnabled,

        [Parameter()]
        [System.Boolean]
        $AllowCopyContactsToDeviceAddressBook,

        [Parameter()]
        [System.String[]]
        $AllowedFileTypes,

        [Parameter()]
        [System.String[]]
        $AllowedMimeTypes,

        [Parameter()]
        [System.String[]]
        $BlockedFileTypes,

        [Parameter()]
        [System.String[]]
        $BlockedMimeTypes,

        [Parameter()]
        [System.Boolean]
        $ClassicAttachmentsEnabled,

        [Parameter()]
        [ValidateSet('Off', 'ReadOnly', 'ReadOnlyPlusAttachmentsBlocked')]
        [System.String]
        $ConditionalAccessPolicy,

        [Parameter()]
        [System.String]
        $DefaultTheme,

        [Parameter()]
        [System.Boolean]
        $DirectFileAccessOnPrivateComputersEnabled,

        [Parameter()]
        [System.Boolean]
        $DirectFileAccessOnPublicComputersEnabled,

        [Parameter()]
        [System.Boolean]
        $DisableFacebook,

        [Parameter()]
        [System.Boolean]
        $DisplayPhotosEnabled,

        [Parameter()]
        [System.Boolean]
        $ExplicitLogonEnabled,

        [Parameter()]
        [System.Boolean]
        $ExternalImageProxyEnabled,

        [Parameter()]
        [System.String]
        $ExternalSPMySiteHostURL,

        [Parameter()]
        [System.Boolean]
        $ForceSaveAttachmentFilteringEnabled,

        [Parameter()]
        [System.String[]]
        $ForceSaveFileTypes,

        [Parameter()]
        [System.String[]]
        $ForceSaveMimeTypes,

        [Parameter()]
        [System.Boolean]
        $ForceWacViewingFirstOnPrivateComputers,

        [Parameter()]
        [System.Boolean]
        $ForceWacViewingFirstOnPublicComputers,

        [Parameter()]
        [System.Boolean]
        $FreCardsEnabled,

        [Parameter()]
        [System.Boolean]
        $GlobalAddressListEnabled,

        [Parameter()]
        [System.Boolean]
        $GroupCreationEnabled,

        [Parameter()]
        [System.Boolean]
        $InstantMessagingEnabled,

        [Parameter()]
        [ValidateSet('None', 'Ocs')]
        [System.String]
        $InstantMessagingType,

        [Parameter()]
        [System.Boolean]
        $InterestingCalendarsEnabled,

        [Parameter()]
        [System.String]
        $InternalSPMySiteHostURL,

        [Parameter()]
        [System.Boolean]
        $IRMEnabled,

        [Parameter()]
        [System.Boolean]
        $IsDefault,

        [Parameter()]
        [System.Boolean]
        $JournalEnabled,

        [Parameter()]
        [System.Boolean]
        $LocalEventsEnabled,

        [Parameter()]
        [System.Int32]
        $LogonAndErrorLanguage,

        [Parameter()]
        [System.Boolean]
        $NotesEnabled,

        [Parameter()]
        [System.Boolean]
        $NpsSurveysEnabled,

        [Parameter()]
        [System.Boolean]
        $OrganizationEnabled,

        [Parameter()]
        [System.Boolean]
        $OnSendAddinsEnabled,

        [Parameter()]
        [ValidateSet('AutoDetect', 'AlwaysUTF8', 'UserLanguageChoice')]
        [System.String]
        $OutboundCharset,

        [Parameter()]
        [System.Boolean]
        $OutlookBetaToggleEnabled,

        [Parameter()]
        [System.Boolean]
        $OWALightEnabled,

        [Parameter()]
        [System.Boolean]
        $PersonalAccountCalendarsEnabled,

        [Parameter()]
        [System.Boolean]
        $PhoneticSupportEnabled,

        [Parameter()]
        [System.Boolean]
        $PlacesEnabled,

        [Parameter()]
        [System.Boolean]
        $PremiumClientEnabled,

        [Parameter()]
        [System.Boolean]
        $PrintWithoutDownloadEnabled,

        [Parameter()]
        [System.Boolean]
        $PublicFoldersEnabled,

        [Parameter()]
        [System.Boolean]
        $RecoverDeletedItemsEnabled,

        [Parameter()]
        [System.Boolean]
        $ReferenceAttachmentsEnabled,

        [Parameter()]
        [System.Boolean]
        $RemindersAndNotificationsEnabled,

        [Parameter()]
        [System.Boolean]
        $ReportJunkEmailEnabled,

        [Parameter()]
        [System.Boolean]
        $RulesEnabled,

        [Parameter()]
        [System.Boolean]
        $SatisfactionEnabled,

        [Parameter()]
        [System.Boolean]
        $SaveAttachmentsToCloudEnabled,

        [Parameter()]
        [System.Boolean]
        $SearchFoldersEnabled,

        [Parameter()]
        [System.Boolean]
        $SetPhotoEnabled,

        [Parameter()]
        [System.String]
        $SetPhotoURL,

        [Parameter()]
        [System.Boolean]
        $SignaturesEnabled,

        [Parameter()]
        [System.Boolean]
        $SkipCreateUnifiedGroupCustomSharepointClassification,

        [Parameter()]
        [System.Boolean]
        $TeamSnapCalendarsEnabled,

        [Parameter()]
        [System.Boolean]
        $TextMessagingEnabled,

        [Parameter()]
        [System.Boolean]
        $ThemeSelectionEnabled,

        [Parameter()]
        [System.Boolean]
        $UMIntegrationEnabled,

        [Parameter()]
        [System.Boolean]
        $UseGB18030,

        [Parameter()]
        [System.Boolean]
        $UseISO885915,

        [Parameter()]
        [System.Boolean]
        $UserVoiceEnabled,

        [Parameter()]
        [System.Boolean]
        $WacEditingEnabled,

        [Parameter()]
        [System.Boolean]
        $WacExternalServicesEnabled,

        [Parameter()]
        [System.Boolean]
        $WacOMEXEnabled,

        [Parameter()]
        [System.Boolean]
        $WacViewingOnPrivateComputersEnabled,

        [Parameter()]
        [System.Boolean]
        $WacViewingOnPublicComputersEnabled,

        [Parameter()]
        [System.Boolean]
        $WeatherEnabled,

        [Parameter()]
        [ValidateSet('None', 'SameOrigin', 'Deny')]
        [System.String]
        $WebPartsFrameOptionsType,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

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
        $CertificatePassword
    )

    Write-Verbose -Message "Setting OWA Mailbox Policy configuration for $Name"

    $currentOwaMailboxPolicyConfig = Get-TargetResource @PSBoundParameters

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $NewOwaMailboxPolicyParams = @{
        Name      = $Name
        IsDefault = $IsDefault
        Confirm   = $false
    }

    $SetOwaMailboxPolicyParams = @{
        Identity                                             = $Name
        ActionForUnknownFileAndMIMETypes                     = $ActionForUnknownFileAndMIMETypes
        ActiveSyncIntegrationEnabled                         = $ActiveSyncIntegrationEnabled
        AdditionalStorageProvidersAvailable                  = $AdditionalStorageProvidersAvailable
        AllAddressListsEnabled                               = $AllAddressListsEnabled
        AllowCopyContactsToDeviceAddressBook                 = $AllowCopyContactsToDeviceAddressBook
        AllowedFileTypes                                     = $AllowedFileTypes
        AllowedMimeTypes                                     = $AllowedMimeTypes
        BlockedFileTypes                                     = $BlockedFileTypes
        BlockedMimeTypes                                     = $BlockedMimeTypes
        ClassicAttachmentsEnabled                            = $ClassicAttachmentsEnabled
        ConditionalAccessPolicy                              = $ConditionalAccessPolicy
        DefaultTheme                                         = $DefaultTheme
        DirectFileAccessOnPrivateComputersEnabled            = $DirectFileAccessOnPrivateComputersEnabled
        DirectFileAccessOnPublicComputersEnabled             = $DirectFileAccessOnPublicComputersEnabled
        DisableFacebook                                      = $DisableFacebook
        DisplayPhotosEnabled                                 = $DisplayPhotosEnabled
        ExplicitLogonEnabled                                 = $ExplicitLogonEnabled
        ExternalImageProxyEnabled                            = $ExternalImageProxyEnabled
        ExternalSPMySiteHostURL                              = $ExternalSPMySiteHostURL
        ForceSaveAttachmentFilteringEnabled                  = $ForceSaveAttachmentFilteringEnabled
        ForceSaveFileTypes                                   = $ForceSaveFileTypes
        ForceSaveMimeTypes                                   = $ForceSaveMimeTypes
        ForceWacViewingFirstOnPrivateComputers               = $ForceWacViewingFirstOnPrivateComputers
        ForceWacViewingFirstOnPublicComputers                = $ForceWacViewingFirstOnPublicComputers
        FreCardsEnabled                                      = $FreCardsEnabled
        GlobalAddressListEnabled                             = $GlobalAddressListEnabled
        GroupCreationEnabled                                 = $GroupCreationEnabled
        InstantMessagingEnabled                              = $InstantMessagingEnabled
        InstantMessagingType                                 = $InstantMessagingType
        InterestingCalendarsEnabled                          = $InterestingCalendarsEnabled
        InternalSPMySiteHostURL                              = $InternalSPMySiteHostURL
        IRMEnabled                                           = $IRMEnabled
        IsDefault                                            = $IsDefault
        JournalEnabled                                       = $JournalEnabled
        LocalEventsEnabled                                   = $LocalEventsEnabled
        LogonAndErrorLanguage                                = $LogonAndErrorLanguage
        NotesEnabled                                         = $NotesEnabled
        NpsSurveysEnabled                                    = $NpsSurveysEnabled
        OrganizationEnabled                                  = $OrganizationEnabled
        OnSendAddinsEnabled                                  = $OnSendAddinsEnabled
        OutboundCharset                                      = $OutboundCharset
        OutlookBetaToggleEnabled                             = $OutlookBetaToggleEnabled
        OWALightEnabled                                      = $OWALightEnabled
        PersonalAccountCalendarsEnabled                      = $PersonalAccountCalendarsEnabled
        PhoneticSupportEnabled                               = $PhoneticSupportEnabled
        PlacesEnabled                                        = $PlacesEnabled
        PremiumClientEnabled                                 = $PremiumClientEnabled
        PrintWithoutDownloadEnabled                          = $PrintWithoutDownloadEnabled
        PublicFoldersEnabled                                 = $PublicFoldersEnabled
        RecoverDeletedItemsEnabled                           = $RecoverDeletedItemsEnabled
        ReferenceAttachmentsEnabled                          = $ReferenceAttachmentsEnabled
        RemindersAndNotificationsEnabled                     = $RemindersAndNotificationsEnabled
        ReportJunkEmailEnabled                               = $ReportJunkEmailEnabled
        RulesEnabled                                         = $RulesEnabled
        SatisfactionEnabled                                  = $SatisfactionEnabled
        SaveAttachmentsToCloudEnabled                        = $SaveAttachmentsToCloudEnabled
        SearchFoldersEnabled                                 = $SearchFoldersEnabled
        SetPhotoEnabled                                      = $SetPhotoEnabled
        SetPhotoURL                                          = $SetPhotoURL
        SignaturesEnabled                                    = $SignaturesEnabled
        SkipCreateUnifiedGroupCustomSharepointClassification = $SkipCreateUnifiedGroupCustomSharepointClassification
        TeamSnapCalendarsEnabled                             = $TeamSnapCalendarsEnabled
        TextMessagingEnabled                                 = $TextMessagingEnabled
        ThemeSelectionEnabled                                = $ThemeSelectionEnabled
        UMIntegrationEnabled                                 = $UMIntegrationEnabled
        UseGB18030                                           = $UseGB18030
        UseISO885915                                         = $UseISO885915
        UserVoiceEnabled                                     = $UserVoiceEnabled
        WacEditingEnabled                                    = $WacEditingEnabled
        WacExternalServicesEnabled                           = $WacExternalServicesEnabled
        WacOMEXEnabled                                       = $WacOMEXEnabled
        WacViewingOnPrivateComputersEnabled                  = $WacViewingOnPrivateComputersEnabled
        WacViewingOnPublicComputersEnabled                   = $WacViewingOnPublicComputersEnabled
        WeatherEnabled                                       = $WeatherEnabled
        WebPartsFrameOptionsType                             = $WebPartsFrameOptionsType
        Confirm                                              = $false
    }
    # Removes empty properties from Splat to prevent function throwing errors if parameter is null or empty
    Remove-EmptyValue -Splat $SetOwaMailboxPolicyParams

    # CASE: OWA Mailbox Policy doesn't exist but should;
    if ($Ensure -eq "Present" -and $currentOwaMailboxPolicyConfig.Ensure -eq "Absent")
    {
        Write-Verbose -Message "OWA Mailbox Policy '$($Name)' does not exist but it should. Create and configure it."
        # Create OWA Mailbox Policy
        New-OwaMailboxPolicy @NewOwaMailboxPolicyParams

        #Configure new OWA Mailbox Policy
        Set-OwaMailboxPolicy @SetOwaMailboxPolicyParams

    }
    # CASE: OWA Mailbox Policy exists but it shouldn't;
    elseif ($Ensure -eq "Absent" -and $currentOwaMailboxPolicyConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "OWA Mailbox Policy '$($Name)' exists but it shouldn't. Remove it."
        Remove-OwaMailboxPolicyPolicy -Identity $Name -Confirm:$false
    }
    # CASE: OWA Mailbox Policy exists and it should, but has different values than the desired ones
    elseif ($Ensure -eq "Present" -and $currentOwaMailboxPolicyConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "OWA Mailbox Policy '$($Name)' already exists, but needs updating."
        Write-Verbose -Message "Setting OWA Mailbox Policy $($Name) with values: $(Convert-M365DscHashtableToString -Hashtable $SetOwaMailboxPolicyParams)"
        Set-OwaMailboxPolicy @SetOwaMailboxPolicyParams
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateLength(1, 64)]
        [System.String]
        $Name,

        [Parameter()]
        [ValidateSet('Allow', 'ForceSave', 'Block')]
        [System.String]
        $ActionForUnknownFileAndMIMETypes,

        [Parameter()]
        [System.Boolean]
        $ActiveSyncIntegrationEnabled,

        [Parameter()]
        [System.Boolean]
        $AdditionalStorageProvidersAvailable,

        [Parameter()]
        [System.Boolean]
        $AllAddressListsEnabled,

        [Parameter()]
        [System.Boolean]
        $AllowCopyContactsToDeviceAddressBook,

        [Parameter()]
        [System.String[]]
        $AllowedFileTypes,

        [Parameter()]
        [System.String[]]
        $AllowedMimeTypes,

        [Parameter()]
        [System.String[]]
        $BlockedFileTypes,

        [Parameter()]
        [System.String[]]
        $BlockedMimeTypes,

        [Parameter()]
        [System.Boolean]
        $ClassicAttachmentsEnabled,

        [Parameter()]
        [ValidateSet('Off', 'ReadOnly', 'ReadOnlyPlusAttachmentsBlocked')]
        [System.String]
        $ConditionalAccessPolicy,

        [Parameter()]
        [System.String]
        $DefaultTheme,

        [Parameter()]
        [System.Boolean]
        $DirectFileAccessOnPrivateComputersEnabled,

        [Parameter()]
        [System.Boolean]
        $DirectFileAccessOnPublicComputersEnabled,

        [Parameter()]
        [System.Boolean]
        $DisableFacebook,

        [Parameter()]
        [System.Boolean]
        $DisplayPhotosEnabled,

        [Parameter()]
        [System.Boolean]
        $ExplicitLogonEnabled,

        [Parameter()]
        [System.Boolean]
        $ExternalImageProxyEnabled,

        [Parameter()]
        [System.String]
        $ExternalSPMySiteHostURL,

        [Parameter()]
        [System.Boolean]
        $ForceSaveAttachmentFilteringEnabled,

        [Parameter()]
        [System.String[]]
        $ForceSaveFileTypes,

        [Parameter()]
        [System.String[]]
        $ForceSaveMimeTypes,

        [Parameter()]
        [System.Boolean]
        $ForceWacViewingFirstOnPrivateComputers,

        [Parameter()]
        [System.Boolean]
        $ForceWacViewingFirstOnPublicComputers,

        [Parameter()]
        [System.Boolean]
        $FreCardsEnabled,

        [Parameter()]
        [System.Boolean]
        $GlobalAddressListEnabled,

        [Parameter()]
        [System.Boolean]
        $GroupCreationEnabled,

        [Parameter()]
        [System.Boolean]
        $InstantMessagingEnabled,

        [Parameter()]
        [ValidateSet('None', 'Ocs')]
        [System.String]
        $InstantMessagingType,

        [Parameter()]
        [System.Boolean]
        $InterestingCalendarsEnabled,

        [Parameter()]
        [System.String]
        $InternalSPMySiteHostURL,

        [Parameter()]
        [System.Boolean]
        $IRMEnabled,

        [Parameter()]
        [System.Boolean]
        $IsDefault,

        [Parameter()]
        [System.Boolean]
        $JournalEnabled,

        [Parameter()]
        [System.Boolean]
        $LocalEventsEnabled,

        [Parameter()]
        [System.Int32]
        $LogonAndErrorLanguage,

        [Parameter()]
        [System.Boolean]
        $NotesEnabled,

        [Parameter()]
        [System.Boolean]
        $NpsSurveysEnabled,

        [Parameter()]
        [System.Boolean]
        $OrganizationEnabled,

        [Parameter()]
        [System.Boolean]
        $OnSendAddinsEnabled,

        [Parameter()]
        [ValidateSet('AutoDetect', 'AlwaysUTF8', 'UserLanguageChoice')]
        [System.String]
        $OutboundCharset,

        [Parameter()]
        [System.Boolean]
        $OutlookBetaToggleEnabled,

        [Parameter()]
        [System.Boolean]
        $OWALightEnabled,

        [Parameter()]
        [System.Boolean]
        $PersonalAccountCalendarsEnabled,

        [Parameter()]
        [System.Boolean]
        $PhoneticSupportEnabled,

        [Parameter()]
        [System.Boolean]
        $PlacesEnabled,

        [Parameter()]
        [System.Boolean]
        $PremiumClientEnabled,

        [Parameter()]
        [System.Boolean]
        $PrintWithoutDownloadEnabled,

        [Parameter()]
        [System.Boolean]
        $PublicFoldersEnabled,

        [Parameter()]
        [System.Boolean]
        $RecoverDeletedItemsEnabled,

        [Parameter()]
        [System.Boolean]
        $ReferenceAttachmentsEnabled,

        [Parameter()]
        [System.Boolean]
        $RemindersAndNotificationsEnabled,

        [Parameter()]
        [System.Boolean]
        $ReportJunkEmailEnabled,

        [Parameter()]
        [System.Boolean]
        $RulesEnabled,

        [Parameter()]
        [System.Boolean]
        $SatisfactionEnabled,

        [Parameter()]
        [System.Boolean]
        $SaveAttachmentsToCloudEnabled,

        [Parameter()]
        [System.Boolean]
        $SearchFoldersEnabled,

        [Parameter()]
        [System.Boolean]
        $SetPhotoEnabled,

        [Parameter()]
        [System.String]
        $SetPhotoURL,

        [Parameter()]
        [System.Boolean]
        $SignaturesEnabled,

        [Parameter()]
        [System.Boolean]
        $SkipCreateUnifiedGroupCustomSharepointClassification,

        [Parameter()]
        [System.Boolean]
        $TeamSnapCalendarsEnabled,

        [Parameter()]
        [System.Boolean]
        $TextMessagingEnabled,

        [Parameter()]
        [System.Boolean]
        $ThemeSelectionEnabled,

        [Parameter()]
        [System.Boolean]
        $UMIntegrationEnabled,

        [Parameter()]
        [System.Boolean]
        $UseGB18030,

        [Parameter()]
        [System.Boolean]
        $UseISO885915,

        [Parameter()]
        [System.Boolean]
        $UserVoiceEnabled,

        [Parameter()]
        [System.Boolean]
        $WacEditingEnabled,

        [Parameter()]
        [System.Boolean]
        $WacExternalServicesEnabled,

        [Parameter()]
        [System.Boolean]
        $WacOMEXEnabled,

        [Parameter()]
        [System.Boolean]
        $WacViewingOnPrivateComputersEnabled,

        [Parameter()]
        [System.Boolean]
        $WacViewingOnPublicComputersEnabled,

        [Parameter()]
        [System.Boolean]
        $WeatherEnabled,

        [Parameter()]
        [ValidateSet('None', 'SameOrigin', 'Deny')]
        [System.String]
        $WebPartsFrameOptionsType,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

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
        $CertificatePassword
    )

    Write-Verbose -Message "Testing OWA Mailbox Policy configuration for $Name"

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
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

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
        $CertificatePassword
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
    $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

    try
    {
        [array]$AllOwaMailboxPolicies = Get-OwaMailboxPolicy -ErrorAction Stop

        $dscContent = ""

        if ($AllOwaMailboxPolicies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewLine
        }
        $i = 1
        foreach ($OwaMailboxPolicy in $AllOwaMailboxPolicies)
        {
            Write-Host "    |---[$i/$($AllOwaMailboxPolicies.Length)] $($OwaMailboxPolicy.Name)" -NoNewLine

            $Params = @{
                Name                  = $OwaMailboxPolicy.Name
                GlobalAdminAccount    = $GlobalAdminAccount
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                CertificatePath       = $CertificatePath
            }
            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $dscContent += Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -GlobalAdminAccount $GlobalAdminAccount
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
        }
        return $dscContent
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

