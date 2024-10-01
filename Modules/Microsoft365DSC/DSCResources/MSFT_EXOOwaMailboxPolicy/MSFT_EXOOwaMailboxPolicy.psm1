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
        [System.Boolean]
        $AccountTransferEnabled,

        [Parameter()]
        [ValidateSet('Allow', 'ForceSave', 'Block')]
        [System.String]
        $ActionForUnknownFileAndMIMETypes,

        [Parameter()]
        [System.Boolean]
        $ActiveSyncIntegrationEnabled,

        [Parameter()]
        [System.Boolean]
        $AdditionalAccountsEnabled,

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
        $BookingsMailboxCreationEnabled,

        [Parameter()]
        [System.Boolean]
        $ChangeSettingsAccountEnabled,

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
        $FeedbackEnabled,

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
        $ItemsToOtherAccountsEnabled,

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
        $MessagePreviewsDisabled,

        [Parameter()]
        [System.Boolean]
        $NotesEnabled,

        [Parameter()]
        [System.Boolean]
        $NpsSurveysEnabled,

        [Parameter()]
        [System.Boolean]
        $OneWinNativeOutlookEnabled,

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
        $PersonalAccountsEnabled,

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
        $ProjectMocaEnabled,

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
        $ShowOnlineArchiveEnabled,

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

    Write-Verbose -Message "Getting OWA Mailbox Policy configuration for $Name"
    if ($Global:CurrentModeIsExport)
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters `
            -SkipModuleReload $true
    }
    else
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters
    }

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
                AccountTransferEnabled                               = $OwaMailboxPolicy.AccountTransferEnabled
                ActionForUnknownFileAndMIMETypes                     = $OwaMailboxPolicy.ActionForUnknownFileAndMIMETypes
                ActiveSyncIntegrationEnabled                         = $OwaMailboxPolicy.ActiveSyncIntegrationEnabled
                AdditionalAccountsEnabled                            = $OwaMailboxPolicy.AdditionalAccountsEnabled
                AdditionalStorageProvidersAvailable                  = $OwaMailboxPolicy.AdditionalStorageProvidersAvailable
                AllAddressListsEnabled                               = $OwaMailboxPolicy.AllAddressListsEnabled
                AllowCopyContactsToDeviceAddressBook                 = $OwaMailboxPolicy.AllowCopyContactsToDeviceAddressBook
                AllowedFileTypes                                     = $OwaMailboxPolicy.AllowedFileTypes
                AllowedMimeTypes                                     = $OwaMailboxPolicy.AllowedMimeTypes
                BlockedFileTypes                                     = $OwaMailboxPolicy.BlockedFileTypes
                BlockedMimeTypes                                     = $OwaMailboxPolicy.BlockedMimeTypes
                BookingsMailboxCreationEnabled                       = $OwaMailboxPolicy.BookingsMailboxCreationEnabled
                ChangeSettingsAccountEnabled                         = $OwaMailboxPolicy.ChangeSettingsAccountEnabled
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
                FeedbackEnabled                                      = $OwaMailboxPolicy.FeedbackEnabled
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
                ItemsToOtherAccountsEnabled                          = $OwaMailboxPolicy.ItemsToOtherAccountsEnabled
                IsDefault                                            = $OwaMailboxPolicy.IsDefault
                JournalEnabled                                       = $OwaMailboxPolicy.JournalEnabled
                LocalEventsEnabled                                   = $OwaMailboxPolicy.LocalEventsEnabled
                LogonAndErrorLanguage                                = $OwaMailboxPolicy.LogonAndErrorLanguage
                MessagePreviewsDisabled                              = $OwaMailboxPolicy.MessagePreviewsDisabled
                NotesEnabled                                         = $OwaMailboxPolicy.NotesEnabled
                NpsSurveysEnabled                                    = $OwaMailboxPolicy.NpsSurveysEnabled
                OneWinNativeOutlookEnabled                           = $OwaMailboxPolicy.OneWinNativeOutlookEnabled
                OrganizationEnabled                                  = $OwaMailboxPolicy.OrganizationEnabled
                OnSendAddinsEnabled                                  = $OwaMailboxPolicy.OnSendAddinsEnabled
                OutboundCharset                                      = $OwaMailboxPolicy.OutboundCharset
                OutlookBetaToggleEnabled                             = $OwaMailboxPolicy.OutlookBetaToggleEnabled
                OWALightEnabled                                      = $OwaMailboxPolicy.OWALightEnabled
                PersonalAccountCalendarsEnabled                      = $OwaMailboxPolicy.PersonalAccountCalendarsEnabled
                PersonalAccountsEnabled                              = $OwaMailboxPolicy.PersonalAccountsEnabled
                PhoneticSupportEnabled                               = $OwaMailboxPolicy.PhoneticSupportEnabled
                PlacesEnabled                                        = $OwaMailboxPolicy.PlacesEnabled
                PremiumClientEnabled                                 = $OwaMailboxPolicy.PremiumClientEnabled
                PrintWithoutDownloadEnabled                          = $OwaMailboxPolicy.PrintWithoutDownloadEnabled
                ProjectMocaEnabled                                   = $OwaMailboxPolicy.ProjectMocaEnabled
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
                ShowOnlineArchiveEnabled                             = $OwaMailboxPolicy.ShowOnlineArchiveEnabled
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
                Credential                                           = $Credential
                ApplicationId                                        = $ApplicationId
                CertificateThumbprint                                = $CertificateThumbprint
                CertificatePath                                      = $CertificatePath
                CertificatePassword                                  = $CertificatePassword
                Managedidentity                                      = $ManagedIdentity.IsPresent
                TenantId                                             = $TenantId
                AccessTokens                                         = $AccessTokens
            }

            Write-Verbose -Message "Found OWA Mailbox Policy $($Name)"
            return $result
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
        [ValidateLength(1, 64)]
        [System.String]
        $Name,

        [Parameter()]
        [System.Boolean]
        $AccountTransferEnabled,

        [Parameter()]
        [ValidateSet('Allow', 'ForceSave', 'Block')]
        [System.String]
        $ActionForUnknownFileAndMIMETypes,

        [Parameter()]
        [System.Boolean]
        $ActiveSyncIntegrationEnabled,

        [Parameter()]
        [System.Boolean]
        $AdditionalAccountsEnabled,

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
        $BookingsMailboxCreationEnabled,

        [Parameter()]
        [System.Boolean]
        $ChangeSettingsAccountEnabled,

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
        $FeedbackEnabled,

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
        $ItemsToOtherAccountsEnabled,

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
        $MessagePreviewsDisabled,

        [Parameter()]
        [System.Boolean]
        $NotesEnabled,

        [Parameter()]
        [System.Boolean]
        $NpsSurveysEnabled,

        [Parameter()]
        [System.Boolean]
        $OneWinNativeOutlookEnabled,

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
        $PersonalAccountsEnabled,

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
        $ProjectMocaEnabled,

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
        $ShowOnlineArchiveEnabled,

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

    Write-Verbose -Message "Setting OWA Mailbox Policy configuration for $Name"

    $currentOwaMailboxPolicyConfig = Get-TargetResource @PSBoundParameters

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

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $NewOwaMailboxPolicyParams = @{
        Name      = $Name
        IsDefault = $IsDefault
        Confirm   = $false
    }

    $SetOwaMailboxPolicyParams = $PSBoundParameters
    $SetOwaMailboxPolicyParams.Remove('Credential') | Out-Null
    $SetOwaMailboxPolicyParams.Remove('ApplicationId') | Out-Null
    $SetOwaMailboxPolicyParams.Remove('TenantId') | Out-Null
    $SetOwaMailboxPolicyParams.Remove('ApplicationSecret') | Out-Null
    $SetOwaMailboxPolicyParams.Remove('CertificateThumbprint') | Out-Null
    $SetOwaMailboxPolicyParams.Remove('CertificatePath') | Out-Null
    $SetOwaMailboxPolicyParams.Remove('CertificatePassword') | Out-Null
    $SetOwaMailboxPolicyParams.Remove('ManagedIdentity') | Out-Null
    $SetOwaMailboxPolicyParams.Remove('Ensure') | Out-Null
    $SetOwaMailboxPolicyParams.Add('Identity', $Name)
    $SetOwaMailboxPolicyParams.Remove('Name') | Out-Null
    $SetOwaMailboxPolicyParams.Remove('AccessTokens') | Out-Null

    # CASE: OWA Mailbox Policy doesn't exist but should;
    if ($Ensure -eq 'Present' -and $currentOwaMailboxPolicyConfig.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "OWA Mailbox Policy '$($Name)' does not exist but it should. Create and configure it."
        # Create OWA Mailbox Policy
        New-OwaMailboxPolicy @NewOwaMailboxPolicyParams

        #Configure new OWA Mailbox Policy
        Set-OwaMailboxPolicy @SetOwaMailboxPolicyParams

    }
    # CASE: OWA Mailbox Policy exists but it shouldn't;
    elseif ($Ensure -eq 'Absent' -and $currentOwaMailboxPolicyConfig.Ensure -eq 'Present')
    {
        Write-Verbose -Message "OWA Mailbox Policy '$($Name)' exists but it shouldn't. Remove it."
        Remove-OwaMailboxPolicy -Identity $Name -Confirm:$false
    }
    # CASE: OWA Mailbox Policy exists and it should, but has different values than the desired ones
    elseif ($Ensure -eq 'Present' -and $currentOwaMailboxPolicyConfig.Ensure -eq 'Present')
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
        [System.Boolean]
        $AccountTransferEnabled,

        [Parameter()]
        [ValidateSet('Allow', 'ForceSave', 'Block')]
        [System.String]
        $ActionForUnknownFileAndMIMETypes,

        [Parameter()]
        [System.Boolean]
        $ActiveSyncIntegrationEnabled,

        [Parameter()]
        [System.Boolean]
        $AdditionalAccountsEnabled,

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
        $BookingsMailboxCreationEnabled,

        [Parameter()]
        [System.Boolean]
        $ChangeSettingsAccountEnabled,

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
        $FeedbackEnabled,

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
        $ItemsToOtherAccountsEnabled,

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
        $MessagePreviewsDisabled,

        [Parameter()]
        [System.Boolean]
        $NotesEnabled,

        [Parameter()]
        [System.Boolean]
        $NpsSurveysEnabled,

        [Parameter()]
        [System.Boolean]
        $OneWinNativeOutlookEnabled,

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
        $PersonalAccountsEnabled,

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
        $ProjectMocaEnabled,

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
        $ShowOnlineArchiveEnabled,

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

    Write-Verbose -Message "Testing OWA Mailbox Policy configuration for $Name"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters

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
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

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
        [array]$AllOwaMailboxPolicies = Get-OwaMailboxPolicy -ErrorAction Stop

        $dscContent = ''

        if ($AllOwaMailboxPolicies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        $i = 1
        foreach ($OwaMailboxPolicy in $AllOwaMailboxPolicies)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-Host "    |---[$i/$($AllOwaMailboxPolicies.Length)] $($OwaMailboxPolicy.Name)" -NoNewline

            $Params = @{
                Name                  = $OwaMailboxPolicy.Name
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                Managedidentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
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
            Write-Host $Global:M365DSCEmojiGreenCheckMark
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

