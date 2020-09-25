function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $ActivityBasedAuthenticationTimeoutEnabled,

        [Parameter()]
        [System.String]
        [ValidatePattern('^(0[0-7]:[0-5][0-9]:[0-5][0-9]|08:00:00)$')]
        $ActivityBasedAuthenticationTimeoutInterval,

        [Parameter()]
        [System.Boolean]
        $ActivityBasedAuthenticationTimeoutWithSingleSignOnEnabled,

        [Parameter()]
        [System.Boolean]
        $AppsForOfficeEnabled,

        [Parameter()]
        [System.Boolean]
        $AsyncSendEnabled,

        [Parameter()]
        [System.Boolean]
        $AuditDisabled,

        [Parameter()]
        [System.Boolean]
        $AutoExpandingArchive,

        [Parameter()]
        [System.Boolean]
        $BookingsEnabled,

        [Parameter()]
        [System.Boolean]
        $BookingsPaymentsEnabled,

        [Parameter()]
        [System.Boolean]
        $BookingsSocialSharingRestricted,

        [Parameter()]
        [System.UInt32]
        $ByteEncoderTypeFor7BitCharsets,

        [Parameter()]
        [System.Boolean]
        $ConnectorsActionableMessagesEnabled,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabled,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabledForOutlook,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabledForSharepoint,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabledForTeams,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabledForYammer,

        [Parameter()]
        [System.String]
        $DefaultAuthenticationPolicy,

        [Parameter()]
        [ValidateSet('Private', 'Public')]
        [System.String]
        $DefaultGroupAccessType,

        [Parameter()]
        [System.String]
        [ValidatePattern('^([0-9][0-9]|[0-9]).[0-9][0-9]:[0-9][0-9]:[0-9][0-9]$')]
        $DefaultPublicFolderAgeLimit,

        [Parameter()]
        [System.String]
        [ValidatePattern('^([0-9][0-9]|[0-9]).[0-9][0-9]:[0-9][0-9]:[0-9][0-9]$')]
        $DefaultPublicFolderDeletedItemRetention,

        [Parameter()]
        [System.String]
        $DefaultPublicFolderIssueWarningQuota,

        [Parameter()]
        [System.String]
        $DefaultPublicFolderMaxItemSize,

        [Parameter()]
        [System.String]
        [ValidatePattern('^([0-9][0-9]|[0-9]).[0-9][0-9]:[0-9][0-9]:[0-9][0-9]$')]
        $DefaultPublicFolderMovedItemRetention,

        [Parameter()]
        [System.String]
        $DefaultPublicFolderProhibitPostQuota,

        [Parameter()]
        [System.Boolean]
        $DirectReportsGroupAutoCreationEnabled,

        [Parameter()]
        [System.String]
        $DistributionGroupDefaultOU,

        [Parameter()]
        [System.String[]]
        $DistributionGroupNameBlockedWordsList,

        [Parameter()]
        [System.String]
        $DistributionGroupNamingPolicy,

        [Parameter()]
        [System.Boolean]
        $ElcProcessingDisabled,

        [Parameter()]
        [System.Boolean]
        $EndUserDLUpgradeFlowsDisabled,

        [Parameter()]
        [System.Boolean]
        $EwsAllowEntourage,

        [Parameter()]
        [System.String[]]
        $EwsAllowList,

        [Parameter()]
        [System.Boolean]
        $EwsAllowMacOutlook,

        [Parameter()]
        [System.Boolean]
        $EwsAllowOutlook,

        [Parameter()]
        [ValidateSet('EnforceAllowList', 'EnforceBlockList')]
        [System.String]
        $EwsApplicationAccessPolicy,

        [Parameter()]
        [System.String[]]
        $EwsBlockList,

        [Parameter()]
        [System.Boolean]
        $EwsEnabled,

        [Parameter()]
        [System.Boolean]
        $ExchangeNotificationEnabled,

        [Parameter()]
        [System.String[]]
        $ExchangeNotificationRecipients,

        [Parameter()]
        [System.Boolean]
        $FocusedInboxOn,

        [Parameter()]
        [System.String]
        $HierarchicalAddressBookRoot,

        [Parameter()]
        [System.String[]]
        $IPListBlocked,

        [Parameter()]
        [System.Boolean]
        $LeanPopoutEnabled,

        [Parameter()]
        [System.Boolean]
        $LinkPreviewEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsAllTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsExternalRecipientsTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsGroupMetricsEnabled,

        [Parameter()]
        [System.UInt32]
        $MailTipsLargeAudienceThreshold,

        [Parameter()]
        [System.Boolean]
        $MailTipsMailboxSourcedTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $OAuth2ClientProfileEnabled,

        [Parameter()]
        [System.Boolean]
        $OutlookMobileGCCRestrictionsEnabled,

        [Parameter()]
        [System.Boolean]
        $OutlookPayEnabled,

        [Parameter()]
        [System.Boolean]
        $PublicComputersDetectionEnabled,

        [Parameter()]
        [ValidateSet('None', 'Local', 'Remote')]
        [System.String]
        $PublicFoldersEnabled,

        [Parameter()]
        [System.Boolean]
        $PublicFolderShowClientControl,

        [Parameter()]
        [System.Boolean]
        $ReadTrackingEnabled,

        [Parameter()]
        [System.String[]]
        $RemotePublicFolderMailboxes,

        [Parameter()]
        [System.String]
        $SiteMailboxCreationURL,

        [Parameter()]
        [System.Boolean]
        $SmtpActionableMessagesEnabled,

        [Parameter()]
        [System.String]
        $VisibleMeetingUpdateProperties,

        [Parameter()]
        [System.Boolean]
        $WebPushNotificationsDisabled,

        [Parameter()]
        [System.Boolean]
        $WebSuggestedRepliesDisabled,

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

    Write-Verbose -Message "Getting EXOOrganizationConfig"
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
        $ConfigSettings = Get-OrganizationConfig -ErrorAction Stop
        if ($null -eq $ConfigSettings)
        {
            throw 'There was an error retrieving values from the Get function in EXOOrganizationConfig.'
        }

        $results = @{
            IsSingleInstance                                          = 'Yes'
            ActivityBasedAuthenticationTimeoutEnabled                 = $ConfigSettings.ActivityBasedAuthenticationTimeoutEnabled
            ActivityBasedAuthenticationTimeoutInterval                = $ConfigSettings.ActivityBasedAuthenticationTimeoutInterval
            ActivityBasedAuthenticationTimeoutWithSingleSignOnEnabled = $ConfigSettings.ActivityBasedAuthenticationTimeoutWithSingleSignOnEnabled
            AppsForOfficeEnabled                                      = $ConfigSettings.AppsForOfficeEnabled
            AsyncSendEnabled                                          = $ConfigSettings.AsyncSendEnabled
            AuditDisabled                                             = $ConfigSettings.AuditDisabled
            AutoExpandingArchive                                      = $ConfigSettings.AutoExpandingArchive
            BookingsEnabled                                           = $ConfigSettings.BookingsEnabled
            BookingsPaymentsEnabled                                   = $ConfigSettings.BookingsPaymentsEnabled
            BookingsSocialSharingRestricted                           = $ConfigSettings.BookingsSocialSharingRestricted
            ByteEncoderTypeFor7BitCharsets                            = $ConfigSettings.ByteEncoderTypeFor7BitCharsets
            ConnectorsActionableMessagesEnabled                       = $ConfigSettings.ConnectorsActionableMessagesEnabled
            ConnectorsEnabled                                         = $ConfigSettings.ConnectorsEnabled
            ConnectorsEnabledForOutlook                               = $ConfigSettings.ConnectorsEnabledForOutlook
            ConnectorsEnabledForSharepoint                            = $ConfigSettings.ConnectorsEnabledForSharepoint
            ConnectorsEnabledForTeams                                 = $ConfigSettings.ConnectorsEnabledForTeams
            ConnectorsEnabledForYammer                                = $ConfigSettings.ConnectorsEnabledForYammer
            DefaultAuthenticationPolicy                               = $ConfigSettings.DefaultAuthenticationPolicy
            DefaultGroupAccessType                                    = $ConfigSettings.DefaultGroupAccessType
            DefaultPublicFolderAgeLimit                               = $ConfigSettings.DefaultPublicFolderAgeLimit
            DefaultPublicFolderDeletedItemRetention                   = $ConfigSettings.DefaultPublicFolderDeletedItemRetention
            DefaultPublicFolderIssueWarningQuota                      = $ConfigSettings.DefaultPublicFolderIssueWarningQuota
            DefaultPublicFolderMaxItemSize                            = $ConfigSettings.DefaultPublicFolderMaxItemSize
            DefaultPublicFolderMovedItemRetention                     = $ConfigSettings.DefaultPublicFolderMovedItemRetention
            DefaultPublicFolderProhibitPostQuota                      = $ConfigSettings.DefaultPublicFolderProhibitPostQuota
            DirectReportsGroupAutoCreationEnabled                     = $ConfigSettings.DirectReportsGroupAutoCreationEnabled
            DistributionGroupDefaultOU                                = $ConfigSettings.DistributionGroupDefaultOU
            DistributionGroupNameBlockedWordsList                     = $ConfigSettings.DistributionGroupNameBlockedWordsList
            DistributionGroupNamingPolicy                             = $ConfigSettings.DistributionGroupNamingPolicy
            ElcProcessingDisabled                                     = $ConfigSettings.ElcProcessingDisabled
            EndUserDLUpgradeFlowsDisabled                             = $ConfigSettings.EndUserDLUpgradeFlowsDisabled
            EwsAllowEntourage                                         = $ConfigSettings.EwsAllowEntourage
            EwsAllowList                                              = $ConfigSettings.EwsAllowList
            EwsAllowMacOutlook                                        = $ConfigSettings.EwsAllowMacOutlook
            EwsAllowOutlook                                           = $ConfigSettings.EwsAllowOutlook
            EwsApplicationAccessPolicy                                = $ConfigSettings.EwsApplicationAccessPolicy
            EwsBlockList                                              = $ConfigSettings.EwsBlockList
            EwsEnabled                                                = $ConfigSettings.EwsEnabled
            ExchangeNotificationEnabled                               = $ConfigSettings.ExchangeNotificationEnabled
            ExchangeNotificationRecipients                            = $ConfigSettings.ExchangeNotificationRecipients
            FocusedInboxOn                                            = $ConfigSettings.FocusedInboxOn
            HierarchicalAddressBookRoot                               = $ConfigSettings.HierarchicalAddressBookRoot
            IPListBlocked                                             = $ConfigSettings.IPListBlocked
            LeanPopoutEnabled                                         = $ConfigSettings.LeanPopoutEnabled
            LinkPreviewEnabled                                        = $ConfigSettings.LinkPreviewEnabled
            MailTipsAllTipsEnabled                                    = $ConfigSettings.MailTipsAllTipsEnabled
            MailTipsExternalRecipientsTipsEnabled                     = $ConfigSettings.MailTipsExternalRecipientsTipsEnabled
            MailTipsGroupMetricsEnabled                               = $ConfigSettings.MailTipsGroupMetricsEnabled
            MailTipsLargeAudienceThreshold                            = $ConfigSettings.MailTipsLargeAudienceThreshold
            MailTipsMailboxSourcedTipsEnabled                         = $ConfigSettings.MailTipsMailboxSourcedTipsEnabled
            OAuth2ClientProfileEnabled                                = $ConfigSettings.OAuth2ClientProfileEnabled
            OutlookMobileGCCRestrictionsEnabled                       = $ConfigSettings.OutlookMobileGCCRestrictionsEnabled
            OutlookPayEnabled                                         = $ConfigSettings.OutlookPayEnabled
            PublicComputersDetectionEnabled                           = $ConfigSettings.PublicComputersDetectionEnabled
            PublicFoldersEnabled                                      = $ConfigSettings.PublicFoldersEnabled
            PublicFolderShowClientControl                             = $ConfigSettings.PublicFolderShowClientControl
            ReadTrackingEnabled                                       = $ConfigSettings.ReadTrackingEnabled
            RemotePublicFolderMailboxes                               = $ConfigSettings.RemotePublicFolderMailboxes
            SiteMailboxCreationURL                                    = $ConfigSettings.SiteMailboxCreationURL
            SmtpActionableMessagesEnabled                             = $ConfigSettings.SmtpActionableMessagesEnabled
            VisibleMeetingUpdateProperties                            = $ConfigSettings.VisibleMeetingUpdateProperties
            WebPushNotificationsDisabled                              = $ConfigSettings.WebPushNotificationsDisabled
            WebSuggestedRepliesDisabled                               = $ConfigSettings.WebSuggestedRepliesDisabled
            GlobalAdminAccount                                        = $GlobalAdminAccount
        }

        if ($null -eq $ConfigSettings.AutoExpandingArchive)
        {
            $results.AutoExpandingArchive = $false
        }

        if ([System.String]::IsNullOrEmpty($results.EwsApplicationAccessPolicy))
        {
            $results.Remove("EwsApplicationAccessPolicy")
        }

        if ($null -eq $EwsAllowList)
        {
            $results.Remove("EwsAllowList")
        }

        if ($null -eq $EwsBlockList)
        {
            $results.Remove("EwsBlockList")
        }

        return $results
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
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $ActivityBasedAuthenticationTimeoutEnabled,

        [Parameter()]
        [System.String]
        [ValidatePattern('^(0[0-7]:[0-5][0-9]:[0-5][0-9]|08:00:00)$')]
        $ActivityBasedAuthenticationTimeoutInterval,

        [Parameter()]
        [System.Boolean]
        $ActivityBasedAuthenticationTimeoutWithSingleSignOnEnabled,

        [Parameter()]
        [System.Boolean]
        $AppsForOfficeEnabled,

        [Parameter()]
        [System.Boolean]
        $AsyncSendEnabled,

        [Parameter()]
        [System.Boolean]
        $AuditDisabled,

        [Parameter()]
        [System.Boolean]
        $AutoExpandingArchive,

        [Parameter()]
        [System.Boolean]
        $BookingsEnabled,

        [Parameter()]
        [System.Boolean]
        $BookingsPaymentsEnabled,

        [Parameter()]
        [System.Boolean]
        $BookingsSocialSharingRestricted,

        [Parameter()]
        [System.UInt32]
        $ByteEncoderTypeFor7BitCharsets,

        [Parameter()]
        [System.Boolean]
        $ConnectorsActionableMessagesEnabled,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabled,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabledForOutlook,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabledForSharepoint,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabledForTeams,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabledForYammer,

        [Parameter()]
        [System.String]
        $DefaultAuthenticationPolicy,

        [Parameter()]
        [ValidateSet('Private', 'Public')]
        [System.String]
        $DefaultGroupAccessType,

        [Parameter()]
        [System.String]
        [ValidatePattern('^([0-9][0-9]|[0-9]).[0-9][0-9]:[0-9][0-9]:[0-9][0-9]$')]
        $DefaultPublicFolderAgeLimit,

        [Parameter()]
        [System.String]
        [ValidatePattern('^([0-9][0-9]|[0-9]).[0-9][0-9]:[0-9][0-9]:[0-9][0-9]$')]
        $DefaultPublicFolderDeletedItemRetention,

        [Parameter()]
        [System.String]
        $DefaultPublicFolderIssueWarningQuota,

        [Parameter()]
        [System.String]
        $DefaultPublicFolderMaxItemSize,

        [Parameter()]
        [System.String]
        [ValidatePattern('^([0-9][0-9]|[0-9]).[0-9][0-9]:[0-9][0-9]:[0-9][0-9]$')]
        $DefaultPublicFolderMovedItemRetention,

        [Parameter()]
        [System.String]
        $DefaultPublicFolderProhibitPostQuota,

        [Parameter()]
        [System.Boolean]
        $DirectReportsGroupAutoCreationEnabled,

        [Parameter()]
        [System.String]
        $DistributionGroupDefaultOU,

        [Parameter()]
        [System.String[]]
        $DistributionGroupNameBlockedWordsList,

        [Parameter()]
        [System.String]
        $DistributionGroupNamingPolicy,

        [Parameter()]
        [System.Boolean]
        $ElcProcessingDisabled,

        [Parameter()]
        [System.Boolean]
        $EndUserDLUpgradeFlowsDisabled,

        [Parameter()]
        [System.Boolean]
        $EwsAllowEntourage,

        [Parameter()]
        [System.String[]]
        $EwsAllowList,

        [Parameter()]
        [System.Boolean]
        $EwsAllowMacOutlook,

        [Parameter()]
        [System.Boolean]
        $EwsAllowOutlook,

        [Parameter()]
        [ValidateSet('EnforceAllowList', 'EnforceBlockList')]
        [System.String]
        $EwsApplicationAccessPolicy,

        [Parameter()]
        [System.String[]]
        $EwsBlockList,

        [Parameter()]
        [System.Boolean]
        $EwsEnabled,

        [Parameter()]
        [System.Boolean]
        $ExchangeNotificationEnabled,

        [Parameter()]
        [System.String[]]
        $ExchangeNotificationRecipients,

        [Parameter()]
        [System.Boolean]
        $FocusedInboxOn,

        [Parameter()]
        [System.String]
        $HierarchicalAddressBookRoot,

        [Parameter()]
        [System.String[]]
        $IPListBlocked,

        [Parameter()]
        [System.Boolean]
        $LeanPopoutEnabled,

        [Parameter()]
        [System.Boolean]
        $LinkPreviewEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsAllTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsExternalRecipientsTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsGroupMetricsEnabled,

        [Parameter()]
        [System.UInt32]
        $MailTipsLargeAudienceThreshold,

        [Parameter()]
        [System.Boolean]
        $MailTipsMailboxSourcedTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $OAuth2ClientProfileEnabled,

        [Parameter()]
        [System.Boolean]
        $OutlookMobileGCCRestrictionsEnabled,

        [Parameter()]
        [System.Boolean]
        $OutlookPayEnabled,

        [Parameter()]
        [System.Boolean]
        $PublicComputersDetectionEnabled,

        [Parameter()]
        [ValidateSet('None', 'Local', 'Remote')]
        [System.String]
        $PublicFoldersEnabled,

        [Parameter()]
        [System.Boolean]
        $PublicFolderShowClientControl,

        [Parameter()]
        [System.Boolean]
        $ReadTrackingEnabled,

        [Parameter()]
        [System.String[]]
        $RemotePublicFolderMailboxes,

        [Parameter()]
        [System.String]
        $SiteMailboxCreationURL,

        [Parameter()]
        [System.Boolean]
        $SmtpActionableMessagesEnabled,

        [Parameter()]
        [System.String]
        $VisibleMeetingUpdateProperties,

        [Parameter()]
        [System.Boolean]
        $WebPushNotificationsDisabled,

        [Parameter()]
        [System.Boolean]
        $WebSuggestedRepliesDisabled,

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

    if ($null -ne $EwsAllowList -and $null -ne $EwsBlockList)
    {
        throw "You can't specify both EWSAllowList and EWSBlockList properties."
    }

    Write-Verbose -Message "Setting EXOOrganizationConfig"

    $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters


    Write-Verbose -Message "Setting EXOOrganizationConfig with values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"
    $SetValues = $PSBoundParameters
    $SetValues.Remove('IsSingleInstance')
    $SetValues.Remove('GlobalAdminAccount')
    Set-OrganizationConfig @SetValues
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $ActivityBasedAuthenticationTimeoutEnabled,

        [Parameter()]
        [System.String]
        [ValidatePattern('^(0[0-7]:[0-5][0-9]:[0-5][0-9]|08:00:00)$')]
        $ActivityBasedAuthenticationTimeoutInterval,

        [Parameter()]
        [System.Boolean]
        $ActivityBasedAuthenticationTimeoutWithSingleSignOnEnabled,

        [Parameter()]
        [System.Boolean]
        $AppsForOfficeEnabled,

        [Parameter()]
        [System.Boolean]
        $AsyncSendEnabled,

        [Parameter()]
        [System.Boolean]
        $AuditDisabled,

        [Parameter()]
        [System.Boolean]
        $AutoExpandingArchive,

        [Parameter()]
        [System.Boolean]
        $BookingsEnabled,

        [Parameter()]
        [System.Boolean]
        $BookingsPaymentsEnabled,

        [Parameter()]
        [System.Boolean]
        $BookingsSocialSharingRestricted,

        [Parameter()]
        [System.UInt32]
        $ByteEncoderTypeFor7BitCharsets,

        [Parameter()]
        [System.Boolean]
        $ConnectorsActionableMessagesEnabled,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabled,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabledForOutlook,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabledForSharepoint,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabledForTeams,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabledForYammer,

        [Parameter()]
        [System.String]
        $DefaultAuthenticationPolicy,

        [Parameter()]
        [ValidateSet('Private', 'Public')]
        [System.String]
        $DefaultGroupAccessType,

        [Parameter()]
        [System.String]
        [ValidatePattern('^([0-9][0-9]|[0-9]).[0-9][0-9]:[0-9][0-9]:[0-9][0-9]$')]
        $DefaultPublicFolderAgeLimit,

        [Parameter()]
        [System.String]
        [ValidatePattern('^([0-9][0-9]|[0-9]).[0-9][0-9]:[0-9][0-9]:[0-9][0-9]$')]
        $DefaultPublicFolderDeletedItemRetention,

        [Parameter()]
        [System.String]
        $DefaultPublicFolderIssueWarningQuota,

        [Parameter()]
        [System.String]
        $DefaultPublicFolderMaxItemSize,

        [Parameter()]
        [System.String]
        [ValidatePattern('^([0-9][0-9]|[0-9]).[0-9][0-9]:[0-9][0-9]:[0-9][0-9]$')]
        $DefaultPublicFolderMovedItemRetention,

        [Parameter()]
        [System.String]
        $DefaultPublicFolderProhibitPostQuota,

        [Parameter()]
        [System.Boolean]
        $DirectReportsGroupAutoCreationEnabled,

        [Parameter()]
        [System.String]
        $DistributionGroupDefaultOU,

        [Parameter()]
        [System.String[]]
        $DistributionGroupNameBlockedWordsList,

        [Parameter()]
        [System.String]
        $DistributionGroupNamingPolicy,

        [Parameter()]
        [System.Boolean]
        $ElcProcessingDisabled,

        [Parameter()]
        [System.Boolean]
        $EndUserDLUpgradeFlowsDisabled,

        [Parameter()]
        [System.Boolean]
        $EwsAllowEntourage,

        [Parameter()]
        [System.String[]]
        $EwsAllowList,

        [Parameter()]
        [System.Boolean]
        $EwsAllowMacOutlook,

        [Parameter()]
        [System.Boolean]
        $EwsAllowOutlook,

        [Parameter()]
        [ValidateSet('EnforceAllowList', 'EnforceBlockList')]
        [System.String]
        $EwsApplicationAccessPolicy,

        [Parameter()]
        [System.String[]]
        $EwsBlockList,

        [Parameter()]
        [System.Boolean]
        $EwsEnabled,

        [Parameter()]
        [System.Boolean]
        $ExchangeNotificationEnabled,

        [Parameter()]
        [System.String[]]
        $ExchangeNotificationRecipients,

        [Parameter()]
        [System.Boolean]
        $FocusedInboxOn,

        [Parameter()]
        [System.String]
        $HierarchicalAddressBookRoot,

        [Parameter()]
        [System.String[]]
        $IPListBlocked,

        [Parameter()]
        [System.Boolean]
        $LeanPopoutEnabled,

        [Parameter()]
        [System.Boolean]
        $LinkPreviewEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsAllTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsExternalRecipientsTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsGroupMetricsEnabled,

        [Parameter()]
        [System.UInt32]
        $MailTipsLargeAudienceThreshold,

        [Parameter()]
        [System.Boolean]
        $MailTipsMailboxSourcedTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $OAuth2ClientProfileEnabled,

        [Parameter()]
        [System.Boolean]
        $OutlookMobileGCCRestrictionsEnabled,

        [Parameter()]
        [System.Boolean]
        $OutlookPayEnabled,

        [Parameter()]
        [System.Boolean]
        $PublicComputersDetectionEnabled,

        [Parameter()]
        [ValidateSet('None', 'Local', 'Remote')]
        [System.String]
        $PublicFoldersEnabled,

        [Parameter()]
        [System.Boolean]
        $PublicFolderShowClientControl,

        [Parameter()]
        [System.Boolean]
        $ReadTrackingEnabled,

        [Parameter()]
        [System.String[]]
        $RemotePublicFolderMailboxes,

        [Parameter()]
        [System.String]
        $SiteMailboxCreationURL,

        [Parameter()]
        [System.Boolean]
        $SmtpActionableMessagesEnabled,

        [Parameter()]
        [System.String]
        $VisibleMeetingUpdateProperties,

        [Parameter()]
        [System.Boolean]
        $WebPushNotificationsDisabled,

        [Parameter()]
        [System.Boolean]
        $WebSuggestedRepliesDisabled,

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

    Write-Verbose -Message "Testing configuration of EXOOrganizationConfig"

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
        $Params = @{
            IsSingleInstance      = 'Yes'
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
        $dscContent = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -GlobalAdminAccount $GlobalAdminAccount
        Write-Host $Global:M365DSCEmojiGreenCheckMark
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
