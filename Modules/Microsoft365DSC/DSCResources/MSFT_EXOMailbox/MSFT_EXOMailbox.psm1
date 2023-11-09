function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        ########################
        #Minimum property set
        ########################
        [Parameter()]
        [System.String]
        $Alias,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $DistinguishedName,

        [Parameter()]
        [System.String[]]
        $EmailAddresses,

        [Parameter()]
        [System.String]
        $ExchangeVersion,

        [Parameter()]
        [System.String]
        $ExternalDirectoryObjectId,

        [Parameter()]
        [System.String]
        $Guid,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $OrganizationId,

        [Parameter()]
        [System.String]
        $PrimarySmtpAddress,

        [Parameter()]
        [System.String]
        $RecipientType,

        [Parameter()]
        [System.String]
        [ValidateSet('DiscoveryMailbox', 'EquipmentMailbox','GroupMailbox','LegacyMailbox','LinkedMailbox','LinkedRoomMailbox','RoomMailbox','SchedulingMailbox','SharedMailbox','TeamMailbox','UserMailbox')]
        $RecipientTypeDetails,

        [Parameter()]
        [System.String]
        $UserPrincipalName,

        ###########################
        #Address list property set
        ###########################
        [Parameter()]
        [System.String]
        $AddressBookPolicy,

        [Parameter()]
        [System.String]
        $AddressListMembership,

        [Parameter()]
        [System.String]
        $GeneratedOfflineAddressBooks,

        [Parameter()]
        [System.String]
        $HiddenFromAddressListsEnabled,

        [Parameter()]
        [System.String]
        $OfflineAddressBook,

        ########################
        #Archive property set
        ########################
        [Parameter()]
        [System.String]
        $ArchiveDatabase,

        [Parameter()]
        [System.String]
        $ArchiveDomain,

        [Parameter()]
        [System.String]
        $ArchiveGuid,

        [Parameter()]
        [System.String]
        $ArchiveName,

        [Parameter()]
        [System.String]
        $ArchiveQuota,

        [Parameter()]
        [System.String]
        $ArchiveRelease,

        [Parameter()]
        [System.String]
        $ArchiveState,

        [Parameter()]
        [System.String]
        $ArchiveStatus,

        [Parameter()]
        [System.String]
        $ArchiveWarningQuota,

        [Parameter()]
        [System.String]
        $AutoExpandingArchiveEnabled,

        [Parameter()]
        [System.String]
        $DisabledArchiveDatabase,

        [Parameter()]
        [System.String]
        $DisabledArchiveGuid,

        [Parameter()]
        [System.String]
        $JournalArchiveAddress,

        ########################
        #Audit property set
        ########################
        [Parameter()]
        [System.String]
        [ValidateSet('None', 'AddFolderPermissions ', 'ApplyRecord', 'Copy', 'Create', 'FolderBind', 'HardDelete', 'MessageBind', 'ModifyFolderPermissions', 'Move', 'MoveToDeletedItems', 'RecordDelete', 'RemoveFolderPermissions', 'SendAs', 'SendOnBehalf', 'SoftDelete', 'Update', 'UpdateFolderPermissions', 'UpdateCalendarDelegation', 'UpdateInboxRules')]
        $AuditAdmin,

        [Parameter()]
        [System.String]
        [ValidateSet('None', 'AddFolderPermissions ', 'ApplyRecord', 'Create', 'FolderBind', 'HardDelete', 'ModifyFolderPermissions', 'Move', 'MoveToDeletedItems', 'RecordDelete', 'RemoveFolderPermissions', 'SendAs', 'SendOnBehalf', 'SoftDelete', 'Update', 'UpdateFolderPermissions', 'UpdateInboxRules')]
        $AuditDelegate,

        [Parameter()]
        [System.String]
        $AuditEnabled,

        [Parameter()]
        [System.String]
        $AuditLogAgeLimit,

        [Parameter()]
        [System.String]
        [ValidateSet('None', 'AddFolderPermissions ', 'ApplyRecord', 'Create', 'FolderBind', 'HardDelete', 'MailboxLogin', 'MessageBind', 'ModifyFolderPermissions', 'Move', 'MoveToDeletedItems', 'RecordDelete', 'RemoveFolderPermissions', 'SoftDelete', 'Update', 'UpdateFolderPermissions', 'UpdateCalendarDelegation', 'UpdateInboxRules')]
        $AuditOwner,

        [Parameter()]
        [System.String]
        [ValidateSet('Admin', 'Delegate', 'Owner')]
        $DefaultAuditSet,

        ########################
        #Custom property set
        ########################
        [Parameter()]
        [System.String]
        $CustomAttribute1,

        [Parameter()]
        [System.String]
        $CustomAttribute2,

        [Parameter()]
        [System.String]
        $CustomAttribute3,

        [Parameter()]
        [System.String]
        $CustomAttribute4,

        [Parameter()]
        [System.String]
        $CustomAttribute5,

        [Parameter()]
        [System.String]
        $CustomAttribute6,

        [Parameter()]
        [System.String]
        $CustomAttribute7,

        [Parameter()]
        [System.String]
        $CustomAttribute8,

        [Parameter()]
        [System.String]
        $CustomAttribute9,

        [Parameter()]
        [System.String]
        $CustomAttribute10,

        [Parameter()]
        [System.String]
        $CustomAttribute11,

        [Parameter()]
        [System.String]
        $CustomAttribute12,

        [Parameter()]
        [System.String]
        $CustomAttribute13,

        [Parameter()]
        [System.String]
        $CustomAttribute14,

        [Parameter()]
        [System.String]
        $CustomAttribute15,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute1,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute2,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute3,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute4,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute5,

        ########################
        #Delivery property set
        ########################
        [Parameter()]
        [System.String]
        $AcceptMessagesOnlyFrom,

        [Parameter()]
        [System.String]
        $AcceptMessagesOnlyFromDLMembers,

        [Parameter()]
        [System.String]
        $AcceptMessagesOnlyFromSendersOrMembers,

        [Parameter()]
        [System.String]
        $DeliverToMailboxAndForward,

        [Parameter()]
        [System.String]
        $DowngradeHighPriorityMessagesEnabled,

        [Parameter()]
        [System.String]
        $ForwardingAddress,

        [Parameter()]
        [System.String]
        $ForwardingSmtpAddress,

        [Parameter()]
        [System.String]
        $GrantSendOnBehalfTo,

        [Parameter()]
        [System.String]
        $MaxBlockedSenders,

        [Parameter()]
        [System.String]
        $MaxReceiveSize,

        [Parameter()]
        [System.String]
        $MaxSafeSenders,

        [Parameter()]
        [System.String]
        $MaxSendSize,

        [Parameter()]
        [System.String]
        $MessageCopyForSendOnBehalfEnabled,

        [Parameter()]
        [System.String]
        $MessageCopyForSentAsEnabled,

        [Parameter()]
        [System.String]
        $MessageRecallProcessingEnabled,

        [Parameter()]
        [System.String]
        $MessageTrackingReadStatusEnabled,

        [Parameter()]
        [System.String]
        $RecipientLimits,

        [Parameter()]
        [System.String]
        $RejectMessagesFrom,

        [Parameter()]
        [System.String]
        $RejectMessagesFromDLMembers,

        [Parameter()]
        [System.String]
        $RejectMessagesFromSendersOrMembers,

        [Parameter()]
        [System.String]
        $RulesQuota,

        ########################
        #Hold property set
        ########################
        [Parameter()]
        [System.String]
        $ComplianceTagHoldApplied,

        [Parameter()]
        [System.String]
        $DelayHoldApplied,

        [Parameter()]
        [System.String]
        $InPlaceHolds,

        [Parameter()]
        [System.String]
        $InactiveMailboxRetireTime,

        [Parameter()]
        [System.String]
        $LitigationHoldDate,

        [Parameter()]
        [System.String]
        $LitigationHoldDuration,

        [Parameter()]
        [System.String]
        $LitigationHoldEnabled,

        [Parameter()]
        [System.String]
        $LitigationHoldOwner,

        ########################
        #Moderation property set
        ########################
        [Parameter()]
        [System.String]
        $BypassModerationFromSendersOrMembers,

        [Parameter()]
        [System.String]
        $ModeratedBy,

        [Parameter()]
        [System.String]
        $ModerationEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet('Always', 'Internal', 'Never')]
        $SendModerationNotifications,

        ########################
        #Move property set
        ########################
        [Parameter()]
        [System.String]
        $MailboxMoveBatchName,

        [Parameter()]
        [System.String]
        $MailboxMoveFlags,

        [Parameter()]
        [System.String]
        $MailboxMoveRemoteHostName,

        [Parameter()]
        [System.String]
        $MailboxMoveSourceMDB,

        [Parameter()]
        [System.String]
        $MailboxMoveStatus,

        [Parameter()]
        [System.String]
        $MailboxMoveTargetMDB,

        ########################
        #Policy property set
        ########################
        [Parameter()]
        [System.String]
        $DataEncryptionPolicy,

        [Parameter()]
        [System.String]
        $EmailAddressPolicyEnabled,

        [Parameter()]
        [System.String]
        $ManagedFolderMailboxPolicy,

        [Parameter()]
        [System.String]
        $PoliciesExcluded,

        [Parameter()]
        [System.String]
        $PoliciesIncluded,

        [Parameter()]
        [System.String]
        $RemoteAccountPolicy,

        [Parameter()]
        [System.String]
        $RetentionPolicy,

        [Parameter()]
        [System.String]
        $RetentionUrl,

        [Parameter()]
        [System.String]
        $RoleAssignmentPolicy,

        [Parameter()]
        [System.String]
        $SharingPolicy,

        [Parameter()]
        [System.String]
        $ThrottlingPolicy,

        ##########################
        #PublicFolder property set
        ##########################
        [Parameter()]
        [System.String]
        $DefaultPublicFolderMailbox,

        [Parameter()]
        [System.String]
        $EffectivePublicFolderMailbox,

        [Parameter()]
        [System.String]
        $IsExcludedFromServingHierarchy,

        [Parameter()]
        [System.String]
        $IsHierarchyReady,

        [Parameter()]
        [System.String]
        $IsHierarchySyncEnabled,

        [Parameter()]
        [System.String]
        $IsRootPublicFolderMailbox,

        ########################
        #Quota property set
        ########################
        [Parameter()]
        [System.String]
        $CalendarLoggingQuota,

        [Parameter()]
        [System.String]
        $IssueWarningQuota,

        [Parameter()]
        [System.String]
        $ProhibitSendQuota,

        [Parameter()]
        [System.String]
        $ProhibitSendReceiveQuota,

        [Parameter()]
        [System.String]
        $RecoverableItemsQuota,

        [Parameter()]
        [System.String]
        $RecoverableItemsWarningQuota,

        [Parameter()]
        [System.String]
        $UseDatabaseQuotaDefaults,

        ########################
        #Resource property set
        ########################
        [Parameter()]
        [System.String]
        $IsResource,

        [Parameter()]
        [System.String]
        $ResourceCapacity,

        [Parameter()]
        [System.String]
        $ResourceCustom,

        [Parameter()]
        [System.String]
        $ResourceType,

        [Parameter()]
        [System.String]
        $RoomMailboxAccountEnabled,

        ########################
        #Retention property set
        ########################
        [Parameter()]
        [System.String]
        $EndDateForRetentionHold,

        [Parameter()]
        [System.String]
        $OrphanSoftDeleteTrackingTime,

        [Parameter()]
        [System.String]
        $RetainDeletedItemsFor,

        [Parameter()]
        [System.String]
        $RetainDeletedItemsUntilBackup,

        [Parameter()]
        [System.String]
        $RetentionComment,

        [Parameter()]
        [System.String]
        $RetentionHoldEnabled,

        [Parameter()]
        [System.String]
        $SingleItemRecoveryEnabled,

        [Parameter()]
        [System.String]
        $StartDateForRetentionHold,

        [Parameter()]
        [System.String]
        $UseDatabaseRetentionDefaults,

        ########################
        #SCL property set
        ########################
        [Parameter()]
        [System.String]
        $AntispamBypassEnabled,

        [Parameter()]
        [System.String]
        $SCLDeleteEnabled,

        [Parameter()]
        [System.String]
        $SCLDeleteThreshold,

        [Parameter()]
        [System.String]
        $SCLJunkEnabled,

        [Parameter()]
        [System.String]
        $SCLJunkThreshold,

        [Parameter()]
        [System.String]
        $SCLQuarantineEnabled,

        [Parameter()]
        [System.String]
        $SCLQuarantineThreshold,

        [Parameter()]
        [System.String]
        $SCLRejectEnabled,

        [Parameter()]
        [System.String]
        $SCLRejectThreshold,

        ########################
        #SoftDelete property set
        ########################
        [Parameter()]
        [System.String]
        $IncludeInGarbageCollection,

        [Parameter()]
        [System.String]
        $IsInactiveMailbox,

        [Parameter()]
        [System.String]
        $IsSoftDeletedByDisable,

        [Parameter()]
        [System.String]
        $IsSoftDeletedByRemove,

        [Parameter()]
        [System.String]
        $WhenSoftDeleted,

        ############################
        #StatisticsSeed property set
        ############################
        [Parameter()]
        [System.String]
        $ArchiveDatabaseGuid,

        [Parameter()]
        [System.String]
        $DatabaseGuid,

        [Parameter()]
        [System.String]
        $ExchangeGuid,

        ############################
        #Others
        ############################

        [Parameter()]
        [System.String]
        $Archive,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $InactiveMailboxOnly,

        [Parameter()]
        [System.String]
        $IncludeInactiveMailbox,

        [Parameter()]
        [System.String]
        $MailboxPlan,

        [Parameter()]
        [System.String]
        $OrganizationalUnit,

        [Parameter()]
        [System.String]
        $Properties,

        [Parameter()]
        [System.String]
        $ResultSize,

        [Parameter()]
        [System.String]
        $SoftDeletedMailbox,

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
        $ManagedIdentity
    )

    Write-Verbose -Message "Getting mailbox for $Identity"

    if ($Script:ExportMode)
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

    $nullResult = @{
        Identity = $Identity
        Ensure = 'Absent'
    }

    try
    {
        if ($null -ne $Script:Mailboxes -and $Script:ExportMode)
        {
            $Mailbox = $Script:Mailboxes | Where-Object -FilterScript {$_.Identity -eq $Identity}
        }
        else
        {
            #Could include a switch for the different propertySets to retrieve https://learn.microsoft.com/en-us/powershell/exchange/cmdlet-property-sets?view=exchange-ps#get-exomailbox-property-sets
            #Could include a switch for the different recipientTypeDetails to retrieve
            $Mailbox = Get-EXOMailbox -Identity $Identity -PropertySets All -RecipientTypeDetails "RoomMailbox,SharedMailbox,UserMailbox" -ErrorAction Stop
        }

        if ($null -eq $Mailbox)
        {
            Write-Verbose -Message "The specified Mailbox $($Identity) does not exist."
            return $nullResult
        }
        else
        {
            #region EmailAddresses
            $CurrentEmailAddresses = @()

            foreach ($email in $Mailbox.EmailAddresses)
            {
                $emailValue = $email.Split(':')[1]
                if ($emailValue -and $emailValue -ne $Mailbox.PrimarySMTPAddress)
                {
                    $CurrentEmailAddresses += $emailValue
                }
            }
            #endregion

            $result = @{
                Identity                                = $Identity
                Ensure                                  = 'Present'
                Alias                                   = $Mailbox.Alias
                DisplayName                             = $Mailbox.DisplayName
                DistinguishedName                       = $Mailbox.DistinguishedName
                EmailAddresses                          = $CurrentEmailAddresses
                ExchangeVersion                         = $Mailbox.ExchangeVersion
                ExternalDirectoryObjectId               = $Mailbox.ExternalDirectoryObjectId
                Guid                                    = $Mailbox.Guid
                Id                                      = $Mailbox.Id
                Name                                    = $Mailbox.Name
                OrganizationId                          = $Mailbox.OrganizationId
                PrimarySmtpAddress                      = $Mailbox.PrimarySmtpAddress
                RecipientType                           = $Mailbox.RecipientType
                RecipientTypeDetails                    = $Mailbox.RecipientTypeDetails
                UserPrincipalName                       = $Mailbox.UserPrincipalName
                AddressBookPolicy                       = $Mailbox.AddressBookPolicy
                AddressListMembership                   = $Mailbox.AddressListMembership -join ','
                GeneratedOfflineAddressBooks            = $Mailbox.GeneratedOfflineAddressBooks | Out-String
                HiddenFromAddressListsEnabled           = $Mailbox.HiddenFromAddressListsEnabled
                OfflineAddressBook                      = $Mailbox.OfflineAddressBook

                ArchiveDatabase                         = $Mailbox.ArchiveDatabase
                ArchiveDomain                           = $Mailbox.ArchiveDomain
                ArchiveGuid                             = $Mailbox.ArchiveGuid
                ArchiveName                             = $Mailbox.ArchiveName | Out-String
                ArchiveQuota                            = $Mailbox.ArchiveQuota
                ArchiveRelease                          = $Mailbox.ArchiveRelease
                ArchiveState                            = $Mailbox.ArchiveState
                ArchiveStatus                           = $Mailbox.ArchiveStatus
                ArchiveWarningQuota                     = $Mailbox.ArchiveWarningQuota
                AutoExpandingArchiveEnabled             = $Mailbox.AutoExpandingArchiveEnabled
                DisabledArchiveDatabase                 = $Mailbox.DisabledArchiveDatabase
                DisabledArchiveGuid                     = $Mailbox.DisabledArchiveGuid
                JournalArchiveAddress                   = $Mailbox.JournalArchiveAddress

                AuditAdmin                              = $Mailbox.AuditAdmin -join ','
                AuditDelegate                           = $Mailbox.AuditDelegate -join ','
                AuditEnabled                            = $Mailbox.AuditEnabled
                AuditLogAgeLimit                        = $Mailbox.AuditLogAgeLimit
                AuditOwner                              = $Mailbox.AuditOwner -join ','
                DefaultAuditSet                         = $Mailbox.DefaultAuditSet | Out-String

                CustomAttribute1                        = $Mailbox.CustomAttribute1
                CustomAttribute2                        = $Mailbox.CustomAttribute2
                CustomAttribute3                        = $Mailbox.CustomAttribute3
                CustomAttribute4                        = $Mailbox.CustomAttribute4
                CustomAttribute5                        = $Mailbox.CustomAttribute5
                CustomAttribute6                        = $Mailbox.CustomAttribute6
                CustomAttribute7                        = $Mailbox.CustomAttribute7
                CustomAttribute8                        = $Mailbox.CustomAttribute8
                CustomAttribute9                        = $Mailbox.CustomAttribute9
                CustomAttribute10                       = $Mailbox.CustomAttribute10
                CustomAttribute11                       = $Mailbox.CustomAttribute11
                CustomAttribute12                       = $Mailbox.CustomAttribute12
                CustomAttribute13                       = $Mailbox.CustomAttribute13
                CustomAttribute14                       = $Mailbox.CustomAttribute14
                CustomAttribute15                       = $Mailbox.CustomAttribute15
                ExtensionCustomAttribute1               = $Mailbox.ExtensionCustomAttribute1 | Out-String
                ExtensionCustomAttribute2               = $Mailbox.ExtensionCustomAttribute2 | Out-String
                ExtensionCustomAttribute3               = $Mailbox.ExtensionCustomAttribute3 | Out-String
                ExtensionCustomAttribute4               = $Mailbox.ExtensionCustomAttribute4 | Out-String
                ExtensionCustomAttribute5               = $Mailbox.ExtensionCustomAttribute5 | Out-String

                AcceptMessagesOnlyFrom                  = $Mailbox.AcceptMessagesOnlyFrom | Out-String
                AcceptMessagesOnlyFromDLMembers         = $Mailbox.AcceptMessagesOnlyFromDLMembers | Out-String
                AcceptMessagesOnlyFromSendersOrMembers  = $Mailbox.AcceptMessagesOnlyFromSendersOrMembers | Out-String
                DeliverToMailboxAndForward              = $Mailbox.DeliverToMailboxAndForward
                DowngradeHighPriorityMessagesEnabled    = $Mailbox.DowngradeHighPriorityMessagesEnabled
                ForwardingAddress                       = $Mailbox.ForwardingAddress
                ForwardingSmtpAddress                   = $Mailbox.ForwardingSmtpAddress
                GrantSendOnBehalfTo                     = $Mailbox.GrantSendOnBehalfTo | Out-String
                MaxBlockedSenders                       = $Mailbox.MaxBlockedSenders
                MaxReceiveSize                          = $Mailbox.MaxReceiveSize
                MaxSafeSenders                          = $Mailbox.MaxSafeSenders
                MaxSendSize                             = $Mailbox.MaxSendSize
                MessageCopyForSendOnBehalfEnabled       = $Mailbox.MessageCopyForSendOnBehalfEnabled
                MessageCopyForSentAsEnabled             = $Mailbox.MessageCopyForSentAsEnabled
                MessageRecallProcessingEnabled          = $Mailbox.MessageRecallProcessingEnabled
                MessageTrackingReadStatusEnabled        = $Mailbox.MessageTrackingReadStatusEnabled
                RecipientLimits                         = $Mailbox.RecipientLimits
                RejectMessagesFrom                      = $Mailbox.RejectMessagesFrom | Out-String
                RejectMessagesFromDLMembers             = $Mailbox.RejectMessagesFromDLMembers | Out-String
                RejectMessagesFromSendersOrMembers      = $Mailbox.RejectMessagesFromSendersOrMembers | Out-String
                RulesQuota                              = $Mailbox.RulesQuota

                ComplianceTagHoldApplied                = $Mailbox.ComplianceTagHoldApplied
                DelayHoldApplied                        = $Mailbox.DelayHoldApplied
                InPlaceHolds                            = $Mailbox.InPlaceHolds | Out-String
                InactiveMailboxRetireTime               = $Mailbox.InactiveMailboxRetireTime
                LitigationHoldDate                      = $Mailbox.LitigationHoldDate
                LitigationHoldDuration                  = $Mailbox.LitigationHoldDuration
                LitigationHoldEnabled                   = $Mailbox.LitigationHoldEnabled
                LitigationHoldOwner                     = $Mailbox.LitigationHoldOwner

                BypassModerationFromSendersOrMembers    = $Mailbox.BypassModerationFromSendersOrMembers | Out-String
                ModeratedBy                             = $Mailbox.ModeratedBy | Out-String
                ModerationEnabled                       = $Mailbox.ModerationEnabled
                SendModerationNotifications             = $Mailbox.SendModerationNotifications

                MailboxMoveBatchName                    = $Mailbox.MailboxMoveBatchName
                MailboxMoveFlags                        = $Mailbox.MailboxMoveFlags
                MailboxMoveRemoteHostName               = $Mailbox.MailboxMoveRemoteHostName
                MailboxMoveSourceMDB                    = $Mailbox.MailboxMoveSourceMDB
                MailboxMoveStatus                       = $Mailbox.MailboxMoveStatus
                MailboxMoveTargetMDB                    = $Mailbox.MailboxMoveTargetMDB

                DataEncryptionPolicy                    = $Mailbox.DataEncryptionPolicy
                EmailAddressPolicyEnabled               = $Mailbox.EmailAddressPolicyEnabled
                ManagedFolderMailboxPolicy              = $Mailbox.ManagedFolderMailboxPolicy
                PoliciesExcluded                        = $Mailbox.PoliciesExcluded | Out-String
                PoliciesIncluded                        = $Mailbox.PoliciesIncluded | Out-String
                RemoteAccountPolicy                     = $Mailbox.RemoteAccountPolicy
                RetentionPolicy                         = $Mailbox.RetentionPolicy
                RetentionUrl                            = $Mailbox.RetentionUrl
                RoleAssignmentPolicy                    = $Mailbox.RoleAssignmentPolicy
                SharingPolicy                           = $Mailbox.SharingPolicy
                ThrottlingPolicy                        = $Mailbox.ThrottlingPolicy

                DefaultPublicFolderMailbox              = $Mailbox.DefaultPublicFolderMailbox
                EffectivePublicFolderMailbox            = $Mailbox.EffectivePublicFolderMailbox
                IsExcludedFromServingHierarchy          = $Mailbox.IsExcludedFromServingHierarchy
                IsHierarchyReady                        = $Mailbox.IsHierarchyReady
                IsHierarchySyncEnabled                  = $Mailbox.IsHierarchySyncEnabled
                IsRootPublicFolderMailbox               = $Mailbox.IsRootPublicFolderMailbox

                CalendarLoggingQuota                    = $Mailbox.CalendarLoggingQuota
                IssueWarningQuota                       = $Mailbox.IssueWarningQuota
                ProhibitSendQuota                       = $Mailbox.ProhibitSendQuota
                ProhibitSendReceiveQuota                = $Mailbox.ProhibitSendReceiveQuota
                RecoverableItemsQuota                   = $Mailbox.RecoverableItemsQuota
                RecoverableItemsWarningQuota            = $Mailbox.RecoverableItemsWarningQuota
                UseDatabaseQuotaDefaults                = $Mailbox.UseDatabaseQuotaDefaults

                IsResource                              = $Mailbox.IsResource
                ResourceCapacity                        = $Mailbox.ResourceCapacity
                ResourceCustom                          = $Mailbox.ResourceCustom | Out-String
                ResourceType                            = $Mailbox.ResourceType
                RoomMailboxAccountEnabled               = $Mailbox.RoomMailboxAccountEnabled

                EndDateForRetentionHold                 = $Mailbox.EndDateForRetentionHold
                OrphanSoftDeleteTrackingTime            = $Mailbox.OrphanSoftDeleteTrackingTime
                RetainDeletedItemsFor                   = $Mailbox.RetainDeletedItemsFor
                RetainDeletedItemsUntilBackup           = $Mailbox.RetainDeletedItemsUntilBackup
                RetentionComment                        = $Mailbox.RetentionComment
                RetentionHoldEnabled                    = $Mailbox.RetentionHoldEnabled
                SingleItemRecoveryEnabled               = $Mailbox.SingleItemRecoveryEnabled
                StartDateForRetentionHold               = $Mailbox.StartDateForRetentionHold
                UseDatabaseRetentionDefaults            = $Mailbox.UseDatabaseRetentionDefaults

                AntispamBypassEnabled                   = $Mailbox.AntispamBypassEnabled
                SCLDeleteEnabled                        = $Mailbox.SCLDeleteEnabled
                SCLDeleteThreshold                      = $Mailbox.SCLDeleteThreshold
                SCLJunkEnabled                          = $Mailbox.SCLJunkEnabled
                SCLJunkThreshold                        = $Mailbox.SCLJunkThreshold
                SCLQuarantineEnabled                    = $Mailbox.SCLQuarantineEnabled
                SCLQuarantineThreshold                  = $Mailbox.SCLQuarantineThreshold
                SCLRejectEnabled                        = $Mailbox.SCLRejectEnabled
                SCLRejectThreshold                      = $Mailbox.SCLRejectThreshold

                IncludeInGarbageCollection              = $Mailbox.IncludeInGarbageCollection
                IsInactiveMailbox                       = $Mailbox.IsInactiveMailbox
                IsSoftDeletedByDisable                  = $Mailbox.IsSoftDeletedByDisable
                IsSoftDeletedByRemove                   = $Mailbox.IsSoftDeletedByRemove
                WhenSoftDeleted                         = $Mailbox.WhenSoftDeleted

                ArchiveDatabaseGuid                     = $Mailbox.ArchiveDatabaseGuid
                DatabaseGuid                            = $Mailbox.DatabaseGuid
                ExchangeGuid                            = $Mailbox.ExchangeGuid

                Credential                              = $Credential
                ApplicationId                           = $ApplicationId
                CertificateThumbprint                   = $CertificateThumbprint
                CertificatePath                         = $CertificatePath
                CertificatePassword                     = $CertificatePassword
                Managedidentity                         = $ManagedIdentity.IsPresent
                TenantId                                = $TenantId
            }

            Write-Verbose -Message "Found Mailbox $($Identity)"

            Write-Verbose -Message "!!!DEBUG SendModerationNotifications $($SendModerationNotifications)"

            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
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

        ########################
        #Minimum property set
        ########################
        [Parameter()]
        [System.String]
        $Alias,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $DistinguishedName,

        [Parameter()]
        [System.String[]]
        $EmailAddresses = @(),

        [Parameter()]
        [System.String]
        $ExchangeVersion,

        [Parameter()]
        [System.String]
        $ExternalDirectoryObjectId,

        [Parameter()]
        [System.String]
        $Guid,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $OrganizationId,

        [Parameter()]
        [System.String]
        $PrimarySmtpAddress,

        [Parameter()]
        [System.String]
        $RecipientType,

        [Parameter()]
        [System.String]
        [ValidateSet('DiscoveryMailbox', 'EquipmentMailbox','GroupMailbox','LegacyMailbox','LinkedMailbox','LinkedRoomMailbox','RoomMailbox','SchedulingMailbox','SharedMailbox','TeamMailbox','UserMailbox')]
        $RecipientTypeDetails,

        [Parameter()]
        [System.String]
        $UserPrincipalName,

        ###########################
        #Address list property set
        ###########################
        [Parameter()]
        [System.String]
        $AddressBookPolicy,

        [Parameter()]
        [System.String]
        $AddressListMembership,

        [Parameter()]
        [System.String]
        $GeneratedOfflineAddressBooks,

        [Parameter()]
        [System.String]
        $HiddenFromAddressListsEnabled,

        [Parameter()]
        [System.String]
        $OfflineAddressBook,

        ########################
        #Archive property set
        ########################
        [Parameter()]
        [System.String]
        $ArchiveDatabase,

        [Parameter()]
        [System.String]
        $ArchiveDomain,

        [Parameter()]
        [System.String]
        $ArchiveGuid,

        [Parameter()]
        [System.String]
        $ArchiveName,

        [Parameter()]
        [System.String]
        $ArchiveQuota,

        [Parameter()]
        [System.String]
        $ArchiveRelease,

        [Parameter()]
        [System.String]
        $ArchiveState,

        [Parameter()]
        [System.String]
        $ArchiveStatus,

        [Parameter()]
        [System.String]
        $ArchiveWarningQuota,

        [Parameter()]
        [System.String]
        $AutoExpandingArchiveEnabled,

        [Parameter()]
        [System.String]
        $DisabledArchiveDatabase,

        [Parameter()]
        [System.String]
        $DisabledArchiveGuid,

        [Parameter()]
        [System.String]
        $JournalArchiveAddress,

        ########################
        #Audit property set
        ########################
        [Parameter()]
        [System.String]
        [ValidateSet('None', 'AddFolderPermissions ', 'ApplyRecord', 'Copy', 'Create', 'FolderBind', 'HardDelete', 'MessageBind', 'ModifyFolderPermissions', 'Move', 'MoveToDeletedItems', 'RecordDelete', 'RemoveFolderPermissions', 'SendAs', 'SendOnBehalf', 'SoftDelete', 'Update', 'UpdateFolderPermissions', 'UpdateCalendarDelegation', 'UpdateInboxRules')]
        $AuditAdmin,

        [Parameter()]
        [System.String]
        [ValidateSet('None', 'AddFolderPermissions ', 'ApplyRecord', 'Create', 'FolderBind', 'HardDelete', 'ModifyFolderPermissions', 'Move', 'MoveToDeletedItems', 'RecordDelete', 'RemoveFolderPermissions', 'SendAs', 'SendOnBehalf', 'SoftDelete', 'Update', 'UpdateFolderPermissions', 'UpdateInboxRules')]
        $AuditDelegate,

        [Parameter()]
        [System.String]
        $AuditEnabled,

        [Parameter()]
        [System.String]
        $AuditLogAgeLimit,

        [Parameter()]
        [System.String]
        $AuditOwner,

        [Parameter()]
        [System.String]
        $DefaultAuditSet,

        ########################
        #Custom property set
        ########################
        [Parameter()]
        [System.String]
        $CustomAttribute1,

        [Parameter()]
        [System.String]
        $CustomAttribute2,

        [Parameter()]
        [System.String]
        $CustomAttribute3,

        [Parameter()]
        [System.String]
        $CustomAttribute4,

        [Parameter()]
        [System.String]
        $CustomAttribute5,

        [Parameter()]
        [System.String]
        $CustomAttribute6,

        [Parameter()]
        [System.String]
        $CustomAttribute7,

        [Parameter()]
        [System.String]
        $CustomAttribute8,

        [Parameter()]
        [System.String]
        $CustomAttribute9,

        [Parameter()]
        [System.String]
        $CustomAttribute10,

        [Parameter()]
        [System.String]
        $CustomAttribute11,

        [Parameter()]
        [System.String]
        $CustomAttribute12,

        [Parameter()]
        [System.String]
        $CustomAttribute13,

        [Parameter()]
        [System.String]
        $CustomAttribute14,

        [Parameter()]
        [System.String]
        $CustomAttribute15,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute1,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute2,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute3,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute4,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute5,

        ########################
        #Delivery property set
        ########################
        [Parameter()]
        [System.String]
        $AcceptMessagesOnlyFrom,

        [Parameter()]
        [System.String]
        $AcceptMessagesOnlyFromDLMembers,

        [Parameter()]
        [System.String]
        $AcceptMessagesOnlyFromSendersOrMembers,

        [Parameter()]
        [System.String]
        $DeliverToMailboxAndForward,

        [Parameter()]
        [System.String]
        $DowngradeHighPriorityMessagesEnabled,

        [Parameter()]
        [System.String]
        $ForwardingAddress,

        [Parameter()]
        [System.String]
        $ForwardingSmtpAddress,

        [Parameter()]
        [System.String]
        $GrantSendOnBehalfTo,

        [Parameter()]
        [System.String]
        $MaxBlockedSenders,

        [Parameter()]
        [System.String]
        $MaxReceiveSize,

        [Parameter()]
        [System.String]
        $MaxSafeSenders,

        [Parameter()]
        [System.String]
        $MaxSendSize,

        [Parameter()]
        [System.String]
        $MessageCopyForSendOnBehalfEnabled,

        [Parameter()]
        [System.String]
        $MessageCopyForSentAsEnabled,

        [Parameter()]
        [System.String]
        $MessageRecallProcessingEnabled,

        [Parameter()]
        [System.String]
        $MessageTrackingReadStatusEnabled,

        [Parameter()]
        [System.String]
        $RecipientLimits,

        [Parameter()]
        [System.String]
        $RejectMessagesFrom,

        [Parameter()]
        [System.String]
        $RejectMessagesFromDLMembers,

        [Parameter()]
        [System.String]
        $RejectMessagesFromSendersOrMembers,

        [Parameter()]
        [System.String]
        $RulesQuota,

        ########################
        #Hold property set
        ########################
        [Parameter()]
        [System.String]
        $ComplianceTagHoldApplied,

        [Parameter()]
        [System.String]
        $DelayHoldApplied,

        [Parameter()]
        [System.String]
        $InPlaceHolds,

        [Parameter()]
        [System.String]
        $InactiveMailboxRetireTime,

        [Parameter()]
        [System.String]
        $LitigationHoldDate,

        [Parameter()]
        [System.String]
        $LitigationHoldDuration,

        [Parameter()]
        [System.String]
        $LitigationHoldEnabled,

        [Parameter()]
        [System.String]
        $LitigationHoldOwner,

        ########################
        #Moderation property set
        ########################
        [Parameter()]
        [System.String]
        $BypassModerationFromSendersOrMembers,

        [Parameter()]
        [System.String]
        $ModeratedBy,

        [Parameter()]
        [System.String]
        $ModerationEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet('Always', 'Internal', 'Never')]
        $SendModerationNotifications,

        ########################
        #Move property set
        ########################
        [Parameter()]
        [System.String]
        $MailboxMoveBatchName,

        [Parameter()]
        [System.String]
        $MailboxMoveFlags,

        [Parameter()]
        [System.String]
        $MailboxMoveRemoteHostName,

        [Parameter()]
        [System.String]
        $MailboxMoveSourceMDB,

        [Parameter()]
        [System.String]
        $MailboxMoveStatus,

        [Parameter()]
        [System.String]
        $MailboxMoveTargetMDB,

        ########################
        #Policy property set
        ########################
        [Parameter()]
        [System.String]
        $DataEncryptionPolicy,

        [Parameter()]
        [System.String]
        $EmailAddressPolicyEnabled,

        [Parameter()]
        [System.String]
        $ManagedFolderMailboxPolicy,

        [Parameter()]
        [System.String]
        $PoliciesExcluded,

        [Parameter()]
        [System.String]
        $PoliciesIncluded,

        [Parameter()]
        [System.String]
        $RemoteAccountPolicy,

        [Parameter()]
        [System.String]
        $RetentionPolicy,

        [Parameter()]
        [System.String]
        $RetentionUrl,

        [Parameter()]
        [System.String]
        $RoleAssignmentPolicy,

        [Parameter()]
        [System.String]
        $SharingPolicy,

        [Parameter()]
        [System.String]
        $ThrottlingPolicy,

        ##########################
        #PublicFolder property set
        ##########################
        [Parameter()]
        [System.String]
        $DefaultPublicFolderMailbox,

        [Parameter()]
        [System.String]
        $EffectivePublicFolderMailbox,

        [Parameter()]
        [System.String]
        $IsExcludedFromServingHierarchy,

        [Parameter()]
        [System.String]
        $IsHierarchyReady,

        [Parameter()]
        [System.String]
        $IsHierarchySyncEnabled,

        [Parameter()]
        [System.String]
        $IsRootPublicFolderMailbox,

        ########################
        #Quota property set
        ########################
        [Parameter()]
        [System.String]
        $CalendarLoggingQuota,

        [Parameter()]
        [System.String]
        $IssueWarningQuota,

        [Parameter()]
        [System.String]
        $ProhibitSendQuota,

        [Parameter()]
        [System.String]
        $ProhibitSendReceiveQuota,

        [Parameter()]
        [System.String]
        $RecoverableItemsQuota,

        [Parameter()]
        [System.String]
        $RecoverableItemsWarningQuota,

        [Parameter()]
        [System.String]
        $UseDatabaseQuotaDefaults,

        ########################
        #Resource property set
        ########################
        [Parameter()]
        [System.String]
        $IsResource,

        [Parameter()]
        [System.String]
        $ResourceCapacity,

        [Parameter()]
        [System.String]
        $ResourceCustom,

        [Parameter()]
        [System.String]
        $ResourceType,

        [Parameter()]
        [System.String]
        $RoomMailboxAccountEnabled,

        ########################
        #Retention property set
        ########################
        [Parameter()]
        [System.String]
        $EndDateForRetentionHold,

        [Parameter()]
        [System.String]
        $OrphanSoftDeleteTrackingTime,

        [Parameter()]
        [System.String]
        $RetainDeletedItemsFor,

        [Parameter()]
        [System.String]
        $RetainDeletedItemsUntilBackup,

        [Parameter()]
        [System.String]
        $RetentionComment,

        [Parameter()]
        [System.String]
        $RetentionHoldEnabled,

        [Parameter()]
        [System.String]
        $SingleItemRecoveryEnabled,

        [Parameter()]
        [System.String]
        $StartDateForRetentionHold,

        [Parameter()]
        [System.String]
        $UseDatabaseRetentionDefaults,

        ########################
        #SCL property set
        ########################
        [Parameter()]
        [System.String]
        $AntispamBypassEnabled,

        [Parameter()]
        [System.String]
        $SCLDeleteEnabled,

        [Parameter()]
        [System.String]
        $SCLDeleteThreshold,

        [Parameter()]
        [System.String]
        $SCLJunkEnabled,

        [Parameter()]
        [System.String]
        $SCLJunkThreshold,

        [Parameter()]
        [System.String]
        $SCLQuarantineEnabled,

        [Parameter()]
        [System.String]
        $SCLQuarantineThreshold,

        [Parameter()]
        [System.String]
        $SCLRejectEnabled,

        [Parameter()]
        [System.String]
        $SCLRejectThreshold,

        ########################
        #SoftDelete property set
        ########################
        [Parameter()]
        [System.String]
        $IncludeInGarbageCollection,

        [Parameter()]
        [System.String]
        $IsInactiveMailbox,

        [Parameter()]
        [System.String]
        $IsSoftDeletedByDisable,

        [Parameter()]
        [System.String]
        $IsSoftDeletedByRemove,

        [Parameter()]
        [System.String]
        $WhenSoftDeleted,

        ############################
        #StatisticsSeed property set
        ############################
        [Parameter()]
        [System.String]
        $ArchiveDatabaseGuid,

        [Parameter()]
        [System.String]
        $DatabaseGuid,

        [Parameter()]
        [System.String]
        $ExchangeGuid,

        ############################
        #Others
        ############################

        [Parameter()]
        [System.String]
        $Archive,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $InactiveMailboxOnly,

        [Parameter()]
        [System.String]
        $IncludeInactiveMailbox,

        [Parameter()]
        [System.String]
        $MailboxPlan,

        [Parameter()]
        [System.String]
        $OrganizationalUnit,

        [Parameter()]
        [System.String]
        $Properties,

        [Parameter()]
        [System.String]
        $ResultSize,

        [Parameter()]
        [System.String]
        $SoftDeletedMailbox,

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
        $ManagedIdentity
    )

    Write-Verbose -Message "Setting configuration of Office 365 Mailbox $DisplayName"
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

    $currentMailbox = Get-TargetResource @PSBoundParameters

    #region Validation
    foreach ($secondaryAlias in $EmailAddresses)
    {
        if ($secondaryAlias.ToLower() -eq $PrimarySMTPAddress.ToLower())
        {
            throw 'You cannot have the EmailAddresses list contain the PrimarySMTPAddress'
        }
    }
    #endregion

    $CurrentParameters = $PSBoundParameters
    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $MailboxParams = [System.Collections.Hashtable]($PSBoundParameters)
    $MailboxParams.Remove('Ensure') | Out-Null
    $MailboxParams.Remove('Credential') | Out-Null
    $MailboxParams.Remove('ApplicationId') | Out-Null
    $MailboxParams.Remove('TenantId') | Out-Null
    $MailboxParams.Remove('CertificateThumbprint') | Out-Null
    $MailboxParams.Remove('CertificatePath') | Out-Null
    $MailboxParams.Remove('CertificatePassword') | Out-Null
    $MailboxParams.Remove('ManagedIdentity') | Out-Null

    # CASE: Mailbox doesn't exist but should;
    if ($Ensure -eq 'Present' -and $currentMailbox.Ensure -eq 'Absent')
    {

        Write-Verbose -Message "$($RecipientTypeDetails) '$($DisplayName)' does not exist but it should. Creating it."
        $emails = ''
        foreach ($secondaryAlias in $EmailAddresses)
        {
            $emails += $secondaryAlias + ','
        }
        $emails += $PrimarySMTPAddress
        $proxyAddresses = $emails -Split ','

        $CurrentParameters.EmailAddresses = $proxyAddresses

        #Generic parameters for all types of mailboxes for the New-Mailbox cmdlet
        $NewMailBoxParameters = @{
            Name                              = $Name
            DisplayName                       = $DisplayName
            PrimarySMTPAddress                = $PrimarySMTPAddress
            RoleAssignmentPolicy              = $RoleAssignmentPolicy
            SendModerationNotifications       = $SendModerationNotifications
        }

        #region Validation of parameters
        if ($Alias)
        {
            $NewMailBoxParameters.Add('Alias', $Alias)
        }

        #Moderation is only available for DistributionGroup
        #if ($ModerationEnabled)
        #{
        #    Write-Verbose -Message "ModerationEnabled = '$($ModerationEnabled)'"
        #    $NewMailBoxParameters.Add('ModerationEnabled', $ModerationEnabled)
        #    $NewMailBoxParameters.Add('ModeratedBy', $ModeratedBy)
        #}
        #endregion

        #region Specific parameters for other types of mailboxes for the New-Mailbox cmdlet
        switch ($RecipientTypeDetails)
        {
            'RoomMailbox'
            {
                $NewMailBoxParameters.Add('ResourceCapacity', $ResourceCapacity)
                $NewMailBoxParameters.Add('Room', $true)
            }
            'SharedMailbox'
            {
                $NewMailBoxParameters.Add('Shared', $true)
            }
        }
        #endregion

        #Skipped parameters from the New-Mailbox cmdlet
        #Archive,Discovery,Equipment,FirstName,HoldForMigration,ImmutableId,Initials,LastName,MailboxPlan,MailboxRegion,MicrosoftOnlineServicesID,Migration,Office,Password,Phone,PublicFolder,RemotePowerShellEnabled,ResetPasswordOnNextLogon,OrganizationalUnit,InactiveMailbox,IsExcludedFromServingHierarchy

        New-MailBox @NewMailBoxParameters

        #Generic parameters for all types of mailboxes for the Set-Mailbox cmdlet
        $SetMailBoxParameters = @{
            DisplayName                       = $DisplayName
            Identity                          = $Identity
        }

        #region Parameters of parameters only available in the Set-Mailbox cmdlet
        if($EmailAddresses)
        {
            #Set-Mailbox -Identity $DisplayName -EmailAddresses @{add = $EmailAddresses }
            $SetMailBoxParameters.Add('EmailAddresses', @{add = $EmailAddresses })
        }

        if($AcceptMessagesOnlyFrom)
        {
            $SetMailBoxParameters.Add('AcceptMessagesOnlyFrom', @{add = $AcceptMessagesOnlyFrom -Split ','})
        }

        #You can't use the AcceptMessagesOnlyFrom and AcceptMessagesOnlyFromSendersOrMembers parameters in the same command
        #Skipped parameters from the New-Mailbox cmdlet
        #AcceptMessagesOnlyFromSendersOrMembers

        Set-Mailbox @SetMailBoxParameters
        #endregion
    }
    # CASE: Mailbox exists but it shouldn't;
    elseif ($Ensure -eq 'Absent' -and $currentMailbox.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Mailbox '$($DisplayName)' exists but it shouldn't. Deleting it."
        Remove-Mailbox -Identity $DisplayName -Confirm:$false
    }
    # CASE: Mailbox exists and it should, but has different values than the desired ones
    elseif ($Ensure -eq 'Present' -and $currentMailbox.Ensure -eq 'Present')
    {
        # CASE: EmailAddresses need to be updated
        Write-Verbose -Message "Mailbox '$($DisplayName)' already exists, but needs updating."
        $current = $currentMailbox.EmailAddresses
        $desired = $EmailAddresses
        $diff = Compare-Object -ReferenceObject $current -DifferenceObject $desired
        if ($diff)
        {
            # Add EmailAddresses
            Write-Verbose -Message "Updating the list of EmailAddresses for the Mailbox '$($DisplayName)'"
            $emails = ''
            $emailAddressesToAdd = $diff | Where-Object -FilterScript { $_.SideIndicator -eq '=>' }
            if ($null -ne $emailAddressesToAdd)
            {
                $emailsToAdd = ''
                foreach ($secondaryAlias in $emailAddressesToAdd)
                {
                    $emailsToAdd += $secondaryAlias.InputObject + ','
                }
                $emailsToAdd += $PrimarySMTPAddress
                $proxyAddresses = $emailsToAdd -Split ','

                Write-Verbose -Message "Adding the following EmailAddresses: $emailsToAdd"
                Set-Mailbox -Identity $DisplayName -EmailAddresses @{add = $proxyAddresses }
            }
            # Remove EmailAddresses
            $emailAddressesToRemove = $diff | Where-Object -FilterScript { $_.SideIndicator -eq '<=' }
            if ($null -ne $emailAddressesToRemove)
            {
                $emailsToRemoved = ''
                foreach ($secondaryAlias in $emailAddressesToRemove)
                {
                    $emailsToRemoved += $secondaryAlias.InputObject + ','
                }
                $emailsToRemoved += $PrimarySMTPAddress
                $proxyAddresses = $emailsToRemoved -Split ','

                Write-Verbose -Message "Removing the following EmailAddresses: $emailsToRemoved"
                Set-Mailbox -Identity $DisplayName -EmailAddresses @{remove = $proxyAddresses }
            }
        }
        # CASE: Alias need to be updated
        $current = $currentMailbox.Alias
        $desired = $Alias
        $diff = Compare-Object -ReferenceObject $current -DifferenceObject $desired
        if ($diff)
        {
            Write-Verbose -Message "Updating Alias for the Mailbox '$($DisplayName)'"
            Set-Mailbox -Identity $DisplayName -Alias $Alias
        }
        # CASE: PrimarySMTPAddress need to be updated
        $current = $currentMailbox.PrimarySMTPAddress
        $desired = $PrimarySMTPAddress
        $diff = Compare-Object -ReferenceObject $current -DifferenceObject $desired
        if ($diff)
        {
            Write-Verbose -Message "Updating PrimarySmtpAddress for the Mailbox from $($mailbox.PrimarySMTPAddress) to $PrimarySMTPAddress"
            Set-Mailbox -Identity $mailbox.guid.guid -WindowsEmailAddress $PrimarySMTPAddress
        }
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

        ########################
        #Minimum property set
        ########################
        [Parameter()]
        [System.String]
        $Alias,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $DistinguishedName,

        [Parameter()]
        [System.String[]]
        $EmailAddresses,

        [Parameter()]
        [System.String]
        $ExchangeVersion,

        [Parameter()]
        [System.String]
        $ExternalDirectoryObjectId,

        [Parameter()]
        [System.String]
        $Guid,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $OrganizationId,

        [Parameter()]
        [System.String]
        $PrimarySmtpAddress,

        [Parameter()]
        [System.String]
        $RecipientType,

        [Parameter()]
        [System.String]
        [ValidateSet('DiscoveryMailbox', 'EquipmentMailbox','GroupMailbox','LegacyMailbox','LinkedMailbox','LinkedRoomMailbox','RoomMailbox','SchedulingMailbox','SharedMailbox','TeamMailbox','UserMailbox')]
        $RecipientTypeDetails,

        [Parameter()]
        [System.String]
        $UserPrincipalName,

        ###########################
        #Address list property set
        ###########################
        [Parameter()]
        [System.String]
        $AddressBookPolicy,

        [Parameter()]
        [System.String]
        $AddressListMembership,

        [Parameter()]
        [System.String]
        $GeneratedOfflineAddressBooks,

        [Parameter()]
        [System.String]
        $HiddenFromAddressListsEnabled,

        [Parameter()]
        [System.String]
        $OfflineAddressBook,

        ########################
        #Archive property set
        ########################
        [Parameter()]
        [System.String]
        $ArchiveDatabase,

        [Parameter()]
        [System.String]
        $ArchiveDomain,

        [Parameter()]
        [System.String]
        $ArchiveGuid,

        [Parameter()]
        [System.String]
        $ArchiveName,

        [Parameter()]
        [System.String]
        $ArchiveQuota,

        [Parameter()]
        [System.String]
        $ArchiveRelease,

        [Parameter()]
        [System.String]
        $ArchiveState,

        [Parameter()]
        [System.String]
        $ArchiveStatus,

        [Parameter()]
        [System.String]
        $ArchiveWarningQuota,

        [Parameter()]
        [System.String]
        $AutoExpandingArchiveEnabled,

        [Parameter()]
        [System.String]
        $DisabledArchiveDatabase,

        [Parameter()]
        [System.String]
        $DisabledArchiveGuid,

        [Parameter()]
        [System.String]
        $JournalArchiveAddress,

        ########################
        #Audit property set
        ########################
        [Parameter()]
        [System.String]
        [ValidateSet('None', 'AddFolderPermissions ', 'ApplyRecord', 'Copy', 'Create', 'FolderBind', 'HardDelete', 'MessageBind', 'ModifyFolderPermissions', 'Move', 'MoveToDeletedItems', 'RecordDelete', 'RemoveFolderPermissions', 'SendAs', 'SendOnBehalf', 'SoftDelete', 'Update', 'UpdateFolderPermissions', 'UpdateCalendarDelegation', 'UpdateInboxRules')]
        $AuditAdmin,

        [Parameter()]
        [System.String]
        [ValidateSet('None', 'AddFolderPermissions ', 'ApplyRecord', 'Create', 'FolderBind', 'HardDelete', 'ModifyFolderPermissions', 'Move', 'MoveToDeletedItems', 'RecordDelete', 'RemoveFolderPermissions', 'SendAs', 'SendOnBehalf', 'SoftDelete', 'Update', 'UpdateFolderPermissions', 'UpdateInboxRules')]
        $AuditDelegate,

        [Parameter()]
        [System.String]
        $AuditEnabled,

        [Parameter()]
        [System.String]
        $AuditLogAgeLimit,

        [Parameter()]
        [System.String]
        $AuditOwner,

        [Parameter()]
        [System.String]
        $DefaultAuditSet,

        ########################
        #Custom property set
        ########################
        [Parameter()]
        [System.String]
        $CustomAttribute1,

        [Parameter()]
        [System.String]
        $CustomAttribute2,

        [Parameter()]
        [System.String]
        $CustomAttribute3,

        [Parameter()]
        [System.String]
        $CustomAttribute4,

        [Parameter()]
        [System.String]
        $CustomAttribute5,

        [Parameter()]
        [System.String]
        $CustomAttribute6,

        [Parameter()]
        [System.String]
        $CustomAttribute7,

        [Parameter()]
        [System.String]
        $CustomAttribute8,

        [Parameter()]
        [System.String]
        $CustomAttribute9,

        [Parameter()]
        [System.String]
        $CustomAttribute10,

        [Parameter()]
        [System.String]
        $CustomAttribute11,

        [Parameter()]
        [System.String]
        $CustomAttribute12,

        [Parameter()]
        [System.String]
        $CustomAttribute13,

        [Parameter()]
        [System.String]
        $CustomAttribute14,

        [Parameter()]
        [System.String]
        $CustomAttribute15,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute1,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute2,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute3,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute4,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute5,

        ########################
        #Delivery property set
        ########################
        [Parameter()]
        [System.String]
        $AcceptMessagesOnlyFrom,

        [Parameter()]
        [System.String]
        $AcceptMessagesOnlyFromDLMembers,

        [Parameter()]
        [System.String]
        $AcceptMessagesOnlyFromSendersOrMembers,

        [Parameter()]
        [System.String]
        $DeliverToMailboxAndForward,

        [Parameter()]
        [System.String]
        $DowngradeHighPriorityMessagesEnabled,

        [Parameter()]
        [System.String]
        $ForwardingAddress,

        [Parameter()]
        [System.String]
        $ForwardingSmtpAddress,

        [Parameter()]
        [System.String]
        $GrantSendOnBehalfTo,

        [Parameter()]
        [System.String]
        $MaxBlockedSenders,

        [Parameter()]
        [System.String]
        $MaxReceiveSize,

        [Parameter()]
        [System.String]
        $MaxSafeSenders,

        [Parameter()]
        [System.String]
        $MaxSendSize,

        [Parameter()]
        [System.String]
        $MessageCopyForSendOnBehalfEnabled,

        [Parameter()]
        [System.String]
        $MessageCopyForSentAsEnabled,

        [Parameter()]
        [System.String]
        $MessageRecallProcessingEnabled,

        [Parameter()]
        [System.String]
        $MessageTrackingReadStatusEnabled,

        [Parameter()]
        [System.String]
        $RecipientLimits,

        [Parameter()]
        [System.String]
        $RejectMessagesFrom,

        [Parameter()]
        [System.String]
        $RejectMessagesFromDLMembers,

        [Parameter()]
        [System.String]
        $RejectMessagesFromSendersOrMembers,

        [Parameter()]
        [System.String]
        $RulesQuota,

        ########################
        #Hold property set
        ########################
        [Parameter()]
        [System.String]
        $ComplianceTagHoldApplied,

        [Parameter()]
        [System.String]
        $DelayHoldApplied,

        [Parameter()]
        [System.String]
        $InPlaceHolds,

        [Parameter()]
        [System.String]
        $InactiveMailboxRetireTime,

        [Parameter()]
        [System.String]
        $LitigationHoldDate,

        [Parameter()]
        [System.String]
        $LitigationHoldDuration,

        [Parameter()]
        [System.String]
        $LitigationHoldEnabled,

        [Parameter()]
        [System.String]
        $LitigationHoldOwner,

        ########################
        #Moderation property set
        ########################
        [Parameter()]
        [System.String]
        $BypassModerationFromSendersOrMembers,

        [Parameter()]
        [System.String]
        $ModeratedBy,

        [Parameter()]
        [System.String]
        $ModerationEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet('Always', 'Internal', 'Never')]
        $SendModerationNotifications,

        ########################
        #Move property set
        ########################
        [Parameter()]
        [System.String]
        $MailboxMoveBatchName,

        [Parameter()]
        [System.String]
        $MailboxMoveFlags,

        [Parameter()]
        [System.String]
        $MailboxMoveRemoteHostName,

        [Parameter()]
        [System.String]
        $MailboxMoveSourceMDB,

        [Parameter()]
        [System.String]
        $MailboxMoveStatus,

        [Parameter()]
        [System.String]
        $MailboxMoveTargetMDB,

        ########################
        #Policy property set
        ########################
        [Parameter()]
        [System.String]
        $DataEncryptionPolicy,

        [Parameter()]
        [System.String]
        $EmailAddressPolicyEnabled,

        [Parameter()]
        [System.String]
        $ManagedFolderMailboxPolicy,

        [Parameter()]
        [System.String]
        $PoliciesExcluded,

        [Parameter()]
        [System.String]
        $PoliciesIncluded,

        [Parameter()]
        [System.String]
        $RemoteAccountPolicy,

        [Parameter()]
        [System.String]
        $RetentionPolicy,

        [Parameter()]
        [System.String]
        $RetentionUrl,

        [Parameter()]
        [System.String]
        $RoleAssignmentPolicy,

        [Parameter()]
        [System.String]
        $SharingPolicy,

        [Parameter()]
        [System.String]
        $ThrottlingPolicy,

        ##########################
        #PublicFolder property set
        ##########################
        [Parameter()]
        [System.String]
        $DefaultPublicFolderMailbox,

        [Parameter()]
        [System.String]
        $EffectivePublicFolderMailbox,

        [Parameter()]
        [System.String]
        $IsExcludedFromServingHierarchy,

        [Parameter()]
        [System.String]
        $IsHierarchyReady,

        [Parameter()]
        [System.String]
        $IsHierarchySyncEnabled,

        [Parameter()]
        [System.String]
        $IsRootPublicFolderMailbox,

        ########################
        #Quota property set
        ########################
        [Parameter()]
        [System.String]
        $CalendarLoggingQuota,

        [Parameter()]
        [System.String]
        $IssueWarningQuota,

        [Parameter()]
        [System.String]
        $ProhibitSendQuota,

        [Parameter()]
        [System.String]
        $ProhibitSendReceiveQuota,

        [Parameter()]
        [System.String]
        $RecoverableItemsQuota,

        [Parameter()]
        [System.String]
        $RecoverableItemsWarningQuota,

        [Parameter()]
        [System.String]
        $UseDatabaseQuotaDefaults,

        ########################
        #Resource property set
        ########################
        [Parameter()]
        [System.String]
        $IsResource,

        [Parameter()]
        [System.String]
        $ResourceCapacity,

        [Parameter()]
        [System.String]
        $ResourceCustom,

        [Parameter()]
        [System.String]
        $ResourceType,

        [Parameter()]
        [System.String]
        $RoomMailboxAccountEnabled,

        ########################
        #Retention property set
        ########################
        [Parameter()]
        [System.String]
        $EndDateForRetentionHold,

        [Parameter()]
        [System.String]
        $OrphanSoftDeleteTrackingTime,

        [Parameter()]
        [System.String]
        $RetainDeletedItemsFor,

        [Parameter()]
        [System.String]
        $RetainDeletedItemsUntilBackup,

        [Parameter()]
        [System.String]
        $RetentionComment,

        [Parameter()]
        [System.String]
        $RetentionHoldEnabled,

        [Parameter()]
        [System.String]
        $SingleItemRecoveryEnabled,

        [Parameter()]
        [System.String]
        $StartDateForRetentionHold,

        [Parameter()]
        [System.String]
        $UseDatabaseRetentionDefaults,

        ########################
        #SCL property set
        ########################
        [Parameter()]
        [System.String]
        $AntispamBypassEnabled,

        [Parameter()]
        [System.String]
        $SCLDeleteEnabled,

        [Parameter()]
        [System.String]
        $SCLDeleteThreshold,

        [Parameter()]
        [System.String]
        $SCLJunkEnabled,

        [Parameter()]
        [System.String]
        $SCLJunkThreshold,

        [Parameter()]
        [System.String]
        $SCLQuarantineEnabled,

        [Parameter()]
        [System.String]
        $SCLQuarantineThreshold,

        [Parameter()]
        [System.String]
        $SCLRejectEnabled,

        [Parameter()]
        [System.String]
        $SCLRejectThreshold,

        ########################
        #SoftDelete property set
        ########################
        [Parameter()]
        [System.String]
        $IncludeInGarbageCollection,

        [Parameter()]
        [System.String]
        $IsInactiveMailbox,

        [Parameter()]
        [System.String]
        $IsSoftDeletedByDisable,

        [Parameter()]
        [System.String]
        $IsSoftDeletedByRemove,

        [Parameter()]
        [System.String]
        $WhenSoftDeleted,

        ############################
        #StatisticsSeed property set
        ############################
        [Parameter()]
        [System.String]
        $ArchiveDatabaseGuid,

        [Parameter()]
        [System.String]
        $DatabaseGuid,

        [Parameter()]
        [System.String]
        $ExchangeGuid,

        ############################
        #Others
        ############################

        [Parameter()]
        [System.String]
        $Archive,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $InactiveMailboxOnly,

        [Parameter()]
        [System.String]
        $IncludeInactiveMailbox,

        [Parameter()]
        [System.String]
        $MailboxPlan,

        [Parameter()]
        [System.String]
        $OrganizationalUnit,

        [Parameter()]
        [System.String]
        $Properties,

        [Parameter()]
        [System.String]
        $ResultSize,

        [Parameter()]
        [System.String]
        $SoftDeletedMailbox,

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

    Write-Verbose -Message "Testing configuration of Office 365 Mailbox $DisplayName"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @('Ensure', `
            'DisplayName', `
            'Alias', `
            'PrimarySMTPAddress',
        'EmailAddresses')

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
        [System.String]
        $Identity,

        ########################
        #Minimum property set
        ########################
        [Parameter()]
        [System.String]
        $Alias,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $DistinguishedName,

        [Parameter()]
        [System.String[]]
        $EmailAddresses,

        [Parameter()]
        [System.String]
        $ExchangeVersion,

        [Parameter()]
        [System.String]
        $ExternalDirectoryObjectId,

        [Parameter()]
        [System.String]
        $Guid,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $OrganizationId,

        [Parameter()]
        [System.String]
        $PrimarySmtpAddress,

        [Parameter()]
        [System.String]
        $RecipientType,

        [Parameter()]
        [System.String]
        [ValidateSet('DiscoveryMailbox', 'EquipmentMailbox','GroupMailbox','LegacyMailbox','LinkedMailbox','LinkedRoomMailbox','RoomMailbox','SchedulingMailbox','SharedMailbox','TeamMailbox','UserMailbox')]
        $RecipientTypeDetails,

        [Parameter()]
        [System.String]
        $UserPrincipalName,

        ###########################
        #Address list property set
        ###########################
        [Parameter()]
        [System.String]
        $AddressBookPolicy,

        [Parameter()]
        [System.String]
        $AddressListMembership,

        [Parameter()]
        [System.String]
        $GeneratedOfflineAddressBooks,

        [Parameter()]
        [System.String]
        $HiddenFromAddressListsEnabled,

        [Parameter()]
        [System.String]
        $OfflineAddressBook,

        ########################
        #Archive property set
        ########################
        [Parameter()]
        [System.String]
        $ArchiveDatabase,

        [Parameter()]
        [System.String]
        $ArchiveDomain,

        [Parameter()]
        [System.String]
        $ArchiveGuid,

        [Parameter()]
        [System.String]
        $ArchiveName,

        [Parameter()]
        [System.String]
        $ArchiveQuota,

        [Parameter()]
        [System.String]
        $ArchiveRelease,

        [Parameter()]
        [System.String]
        $ArchiveState,

        [Parameter()]
        [System.String]
        $ArchiveStatus,

        [Parameter()]
        [System.String]
        $ArchiveWarningQuota,

        [Parameter()]
        [System.String]
        $AutoExpandingArchiveEnabled,

        [Parameter()]
        [System.String]
        $DisabledArchiveDatabase,

        [Parameter()]
        [System.String]
        $DisabledArchiveGuid,

        [Parameter()]
        [System.String]
        $JournalArchiveAddress,

        ########################
        #Audit property set
        ########################
        [Parameter()]
        [System.String]
        [ValidateSet('None', 'AddFolderPermissions ', 'ApplyRecord', 'Copy', 'Create', 'FolderBind', 'HardDelete', 'MessageBind', 'ModifyFolderPermissions', 'Move', 'MoveToDeletedItems', 'RecordDelete', 'RemoveFolderPermissions', 'SendAs', 'SendOnBehalf', 'SoftDelete', 'Update', 'UpdateFolderPermissions', 'UpdateCalendarDelegation', 'UpdateInboxRules')]
        $AuditAdmin,

        [Parameter()]
        [System.String]
        [ValidateSet('None', 'AddFolderPermissions ', 'ApplyRecord', 'Create', 'FolderBind', 'HardDelete', 'ModifyFolderPermissions', 'Move', 'MoveToDeletedItems', 'RecordDelete', 'RemoveFolderPermissions', 'SendAs', 'SendOnBehalf', 'SoftDelete', 'Update', 'UpdateFolderPermissions', 'UpdateInboxRules')]
        $AuditDelegate,

        [Parameter()]
        [System.String]
        $AuditEnabled,

        [Parameter()]
        [System.String]
        $AuditLogAgeLimit,

        [Parameter()]
        [System.String]
        $AuditOwner,

        [Parameter()]
        [System.String]
        $DefaultAuditSet,

        ########################
        #Custom property set
        ########################
        [Parameter()]
        [System.String]
        $CustomAttribute1,

        [Parameter()]
        [System.String]
        $CustomAttribute2,

        [Parameter()]
        [System.String]
        $CustomAttribute3,

        [Parameter()]
        [System.String]
        $CustomAttribute4,

        [Parameter()]
        [System.String]
        $CustomAttribute5,

        [Parameter()]
        [System.String]
        $CustomAttribute6,

        [Parameter()]
        [System.String]
        $CustomAttribute7,

        [Parameter()]
        [System.String]
        $CustomAttribute8,

        [Parameter()]
        [System.String]
        $CustomAttribute9,

        [Parameter()]
        [System.String]
        $CustomAttribute10,

        [Parameter()]
        [System.String]
        $CustomAttribute11,

        [Parameter()]
        [System.String]
        $CustomAttribute12,

        [Parameter()]
        [System.String]
        $CustomAttribute13,

        [Parameter()]
        [System.String]
        $CustomAttribute14,

        [Parameter()]
        [System.String]
        $CustomAttribute15,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute1,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute2,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute3,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute4,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute5,

        ########################
        #Delivery property set
        ########################
        [Parameter()]
        [System.String]
        $AcceptMessagesOnlyFrom,

        [Parameter()]
        [System.String]
        $AcceptMessagesOnlyFromDLMembers,

        [Parameter()]
        [System.String]
        $AcceptMessagesOnlyFromSendersOrMembers,

        [Parameter()]
        [System.String]
        $DeliverToMailboxAndForward,

        [Parameter()]
        [System.String]
        $DowngradeHighPriorityMessagesEnabled,

        [Parameter()]
        [System.String]
        $ForwardingAddress,

        [Parameter()]
        [System.String]
        $ForwardingSmtpAddress,

        [Parameter()]
        [System.String]
        $GrantSendOnBehalfTo,

        [Parameter()]
        [System.String]
        $MaxBlockedSenders,

        [Parameter()]
        [System.String]
        $MaxReceiveSize,

        [Parameter()]
        [System.String]
        $MaxSafeSenders,

        [Parameter()]
        [System.String]
        $MaxSendSize,

        [Parameter()]
        [System.String]
        $MessageCopyForSendOnBehalfEnabled,

        [Parameter()]
        [System.String]
        $MessageCopyForSentAsEnabled,

        [Parameter()]
        [System.String]
        $MessageRecallProcessingEnabled,

        [Parameter()]
        [System.String]
        $MessageTrackingReadStatusEnabled,

        [Parameter()]
        [System.String]
        $RecipientLimits,

        [Parameter()]
        [System.String]
        $RejectMessagesFrom,

        [Parameter()]
        [System.String]
        $RejectMessagesFromDLMembers,

        [Parameter()]
        [System.String]
        $RejectMessagesFromSendersOrMembers,

        [Parameter()]
        [System.String]
        $RulesQuota,

        ########################
        #Hold property set
        ########################
        [Parameter()]
        [System.String]
        $ComplianceTagHoldApplied,

        [Parameter()]
        [System.String]
        $DelayHoldApplied,

        [Parameter()]
        [System.String]
        $InPlaceHolds,

        [Parameter()]
        [System.String]
        $InactiveMailboxRetireTime,

        [Parameter()]
        [System.String]
        $LitigationHoldDate,

        [Parameter()]
        [System.String]
        $LitigationHoldDuration,

        [Parameter()]
        [System.String]
        $LitigationHoldEnabled,

        [Parameter()]
        [System.String]
        $LitigationHoldOwner,

        ########################
        #Moderation property set
        ########################
        [Parameter()]
        [System.String]
        $BypassModerationFromSendersOrMembers,

        [Parameter()]
        [System.String]
        $ModeratedBy,

        [Parameter()]
        [System.String]
        $ModerationEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet('Always', 'Internal', 'Never')]
        $SendModerationNotifications,

        ########################
        #Move property set
        ########################
        [Parameter()]
        [System.String]
        $MailboxMoveBatchName,

        [Parameter()]
        [System.String]
        $MailboxMoveFlags,

        [Parameter()]
        [System.String]
        $MailboxMoveRemoteHostName,

        [Parameter()]
        [System.String]
        $MailboxMoveSourceMDB,

        [Parameter()]
        [System.String]
        $MailboxMoveStatus,

        [Parameter()]
        [System.String]
        $MailboxMoveTargetMDB,

        ########################
        #Policy property set
        ########################
        [Parameter()]
        [System.String]
        $DataEncryptionPolicy,

        [Parameter()]
        [System.String]
        $EmailAddressPolicyEnabled,

        [Parameter()]
        [System.String]
        $ManagedFolderMailboxPolicy,

        [Parameter()]
        [System.String]
        $PoliciesExcluded,

        [Parameter()]
        [System.String]
        $PoliciesIncluded,

        [Parameter()]
        [System.String]
        $RemoteAccountPolicy,

        [Parameter()]
        [System.String]
        $RetentionPolicy,

        [Parameter()]
        [System.String]
        $RetentionUrl,

        [Parameter()]
        [System.String]
        $RoleAssignmentPolicy,

        [Parameter()]
        [System.String]
        $SharingPolicy,

        [Parameter()]
        [System.String]
        $ThrottlingPolicy,

        ##########################
        #PublicFolder property set
        ##########################
        [Parameter()]
        [System.String]
        $DefaultPublicFolderMailbox,

        [Parameter()]
        [System.String]
        $EffectivePublicFolderMailbox,

        [Parameter()]
        [System.String]
        $IsExcludedFromServingHierarchy,

        [Parameter()]
        [System.String]
        $IsHierarchyReady,

        [Parameter()]
        [System.String]
        $IsHierarchySyncEnabled,

        [Parameter()]
        [System.String]
        $IsRootPublicFolderMailbox,

        ########################
        #Quota property set
        ########################
        [Parameter()]
        [System.String]
        $CalendarLoggingQuota,

        [Parameter()]
        [System.String]
        $IssueWarningQuota,

        [Parameter()]
        [System.String]
        $ProhibitSendQuota,

        [Parameter()]
        [System.String]
        $ProhibitSendReceiveQuota,

        [Parameter()]
        [System.String]
        $RecoverableItemsQuota,

        [Parameter()]
        [System.String]
        $RecoverableItemsWarningQuota,

        [Parameter()]
        [System.String]
        $UseDatabaseQuotaDefaults,

        ########################
        #Resource property set
        ########################
        [Parameter()]
        [System.String]
        $IsResource,

        [Parameter()]
        [System.String]
        $ResourceCapacity,

        [Parameter()]
        [System.String]
        $ResourceCustom,

        [Parameter()]
        [System.String]
        $ResourceType,

        [Parameter()]
        [System.String]
        $RoomMailboxAccountEnabled,

        ########################
        #Retention property set
        ########################
        [Parameter()]
        [System.String]
        $EndDateForRetentionHold,

        [Parameter()]
        [System.String]
        $OrphanSoftDeleteTrackingTime,

        [Parameter()]
        [System.String]
        $RetainDeletedItemsFor,

        [Parameter()]
        [System.String]
        $RetainDeletedItemsUntilBackup,

        [Parameter()]
        [System.String]
        $RetentionComment,

        [Parameter()]
        [System.String]
        $RetentionHoldEnabled,

        [Parameter()]
        [System.String]
        $SingleItemRecoveryEnabled,

        [Parameter()]
        [System.String]
        $StartDateForRetentionHold,

        [Parameter()]
        [System.String]
        $UseDatabaseRetentionDefaults,

        ########################
        #SCL property set
        ########################
        [Parameter()]
        [System.String]
        $AntispamBypassEnabled,

        [Parameter()]
        [System.String]
        $SCLDeleteEnabled,

        [Parameter()]
        [System.String]
        $SCLDeleteThreshold,

        [Parameter()]
        [System.String]
        $SCLJunkEnabled,

        [Parameter()]
        [System.String]
        $SCLJunkThreshold,

        [Parameter()]
        [System.String]
        $SCLQuarantineEnabled,

        [Parameter()]
        [System.String]
        $SCLQuarantineThreshold,

        [Parameter()]
        [System.String]
        $SCLRejectEnabled,

        [Parameter()]
        [System.String]
        $SCLRejectThreshold,

        ########################
        #SoftDelete property set
        ########################
        [Parameter()]
        [System.String]
        $IncludeInGarbageCollection,

        [Parameter()]
        [System.String]
        $IsInactiveMailbox,

        [Parameter()]
        [System.String]
        $IsSoftDeletedByDisable,

        [Parameter()]
        [System.String]
        $IsSoftDeletedByRemove,

        [Parameter()]
        [System.String]
        $WhenSoftDeleted,

        ############################
        #StatisticsSeed property set
        ############################
        [Parameter()]
        [System.String]
        $ArchiveDatabaseGuid,

        [Parameter()]
        [System.String]
        $DatabaseGuid,

        [Parameter()]
        [System.String]
        $ExchangeGuid,

        ############################
        #Others
        ############################

        [Parameter()]
        [System.String]
        $Archive,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $InactiveMailboxOnly,

        [Parameter()]
        [System.String]
        $IncludeInactiveMailbox,

        [Parameter()]
        [System.String]
        $MailboxPlan,

        [Parameter()]
        [System.String]
        $OrganizationalUnit,

        [Parameter()]
        [System.String]
        $Properties,

        [Parameter()]
        [System.String]
        $ResultSize,

        [Parameter()]
        [System.String]
        $SoftDeletedMailbox,

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
        $ManagedIdentity
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
        $Script:ExportMode = $true


        [array]$Script:Mailboxes = Get-EXOMailbox -PropertySets All -ResultSize Unlimited -RecipientTypeDetails 'RoomMailbox,SharedMailbox,UserMailbox' -ErrorAction Stop

        #Should include a switch for the different propertySets https://learn.microsoft.com/en-us/powershell/exchange/cmdlet-property-sets?view=exchange-ps#get-exomailbox-property-sets
        #[array]$Mailboxes = Get-EXOMailbox -PropertySets All -ResultSize Unlimited -RecipientTypeDetails 'RoomMailbox,SharedMailbox,UserMailbox' -ErrorAction Stop

        #TODO SharedMailbox has it's own ressource
        #TODO add support for all type of mailboxes.
        #-RecipientTypeDetails
        #The RecipientTypeDetails parameter filters the results by the specified mailbox subtype. Valid values are:

        #DiscoveryMailbox
        #EquipmentMailbox
        #GroupMailbox
        #LegacyMailbox
        #LinkedMailbox
        #LinkedRoomMailbox
        #RoomMailbox
        #SchedulingMailbox
        #SharedMailbox
        #TeamMailbox
        #UserMailbox

        if ($Mailboxes.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        $dscContent = ''
        $i = 1
        foreach ($Mailbox in $Mailboxes)
        {
            Write-Host "    |---[$i/$($Mailboxes.Count)] $($Mailbox.Identity.Split('-')[0])" -NoNewline
            $Params = @{
                Identity                                = $Mailbox.Identity
                Alias                                   = $Mailbox.Alias
                DisplayName                             = $Mailbox.DisplayName
                DistinguishedName                       = $Mailbox.DistinguishedName
                EmailAddresses                          = $Mailbox.EmailAddresses
                ExchangeVersion                         = $Mailbox.ExchangeVersion
                ExternalDirectoryObjectId               = $Mailbox.ExternalDirectoryObjectId
                Guid                                    = $Mailbox.Guid
                Id                                      = $Mailbox.Id
                Name                                    = $Mailbox.Name
                OrganizationId                          = $Mailbox.OrganizationId
                PrimarySmtpAddress                      = $Mailbox.PrimarySmtpAddress
                RecipientType                           = $Mailbox.RecipientType
                RecipientTypeDetails                    = $Mailbox.RecipientTypeDetails
                UserPrincipalName                       = $Mailbox.UserPrincipalName
                AddressBookPolicy                       = $Mailbox.AddressBookPolicy
                AddressListMembership                   = $Mailbox.AddressListMembership -join ','
                GeneratedOfflineAddressBooks            = $Mailbox.GeneratedOfflineAddressBooks | Out-String
                HiddenFromAddressListsEnabled           = $Mailbox.HiddenFromAddressListsEnabled
                OfflineAddressBook                      = $Mailbox.OfflineAddressBook

                ArchiveDatabase                         = $Mailbox.ArchiveDatabase
                ArchiveDomain                           = $Mailbox.ArchiveDomain
                ArchiveGuid                             = $Mailbox.ArchiveGuid
                ArchiveName                             = $Mailbox.ArchiveName | Out-String
                ArchiveQuota                            = $Mailbox.ArchiveQuota
                ArchiveRelease                          = $Mailbox.ArchiveRelease
                ArchiveState                            = $Mailbox.ArchiveState
                ArchiveStatus                           = $Mailbox.ArchiveStatus
                ArchiveWarningQuota                     = $Mailbox.ArchiveWarningQuota
                AutoExpandingArchiveEnabled             = $Mailbox.AutoExpandingArchiveEnabled
                DisabledArchiveDatabase                 = $Mailbox.DisabledArchiveDatabase
                DisabledArchiveGuid                     = $Mailbox.DisabledArchiveGuid
                JournalArchiveAddress                   = $Mailbox.JournalArchiveAddress

                AuditAdmin                              = $Mailbox.AuditAdmin -join ','
                AuditDelegate                           = $Mailbox.AuditDelegate -join ','
                AuditEnabled                            = $Mailbox.AuditEnabled
                AuditLogAgeLimit                        = $Mailbox.AuditLogAgeLimit
                AuditOwner                              = $Mailbox.AuditOwner -join ','
                DefaultAuditSet                         = $Mailbox.DefaultAuditSet | Out-String

                CustomAttribute1                        = $Mailbox.CustomAttribute1
                CustomAttribute2                        = $Mailbox.CustomAttribute2
                CustomAttribute3                        = $Mailbox.CustomAttribute3
                CustomAttribute4                        = $Mailbox.CustomAttribute4
                CustomAttribute5                        = $Mailbox.CustomAttribute5
                CustomAttribute6                        = $Mailbox.CustomAttribute6
                CustomAttribute7                        = $Mailbox.CustomAttribute7
                CustomAttribute8                        = $Mailbox.CustomAttribute8
                CustomAttribute9                        = $Mailbox.CustomAttribute9
                CustomAttribute10                       = $Mailbox.CustomAttribute10
                CustomAttribute11                       = $Mailbox.CustomAttribute11
                CustomAttribute12                       = $Mailbox.CustomAttribute12
                CustomAttribute13                       = $Mailbox.CustomAttribute13
                CustomAttribute14                       = $Mailbox.CustomAttribute14
                CustomAttribute15                       = $Mailbox.CustomAttribute15
                ExtensionCustomAttribute1               = $Mailbox.ExtensionCustomAttribute1 | Out-String
                ExtensionCustomAttribute2               = $Mailbox.ExtensionCustomAttribute2 | Out-String
                ExtensionCustomAttribute3               = $Mailbox.ExtensionCustomAttribute3 | Out-String
                ExtensionCustomAttribute4               = $Mailbox.ExtensionCustomAttribute4 | Out-String
                ExtensionCustomAttribute5               = $Mailbox.ExtensionCustomAttribute5 | Out-String

                AcceptMessagesOnlyFrom                  = $Mailbox.AcceptMessagesOnlyFrom
                AcceptMessagesOnlyFromDLMembers         = $Mailbox.AcceptMessagesOnlyFromDLMembers
                AcceptMessagesOnlyFromSendersOrMembers  = $Mailbox.AcceptMessagesOnlyFromSendersOrMembers
                DeliverToMailboxAndForward              = $Mailbox.DeliverToMailboxAndForward
                DowngradeHighPriorityMessagesEnabled    = $Mailbox.DowngradeHighPriorityMessagesEnabled
                ForwardingAddress                       = $Mailbox.ForwardingAddress
                ForwardingSmtpAddress                   = $Mailbox.ForwardingSmtpAddress
                GrantSendOnBehalfTo                     = $Mailbox.GrantSendOnBehalfTo | Out-String
                MaxBlockedSenders                       = $Mailbox.MaxBlockedSenders
                MaxReceiveSize                          = $Mailbox.MaxReceiveSize
                MaxSafeSenders                          = $Mailbox.MaxSafeSenders
                MaxSendSize                             = $Mailbox.MaxSendSize
                MessageCopyForSendOnBehalfEnabled       = $Mailbox.MessageCopyForSendOnBehalfEnabled
                MessageCopyForSentAsEnabled             = $Mailbox.MessageCopyForSentAsEnabled
                MessageRecallProcessingEnabled          = $Mailbox.MessageRecallProcessingEnabled
                MessageTrackingReadStatusEnabled        = $Mailbox.MessageTrackingReadStatusEnabled
                RecipientLimits                         = $Mailbox.RecipientLimits
                RejectMessagesFrom                      = $Mailbox.RejectMessagesFrom | Out-String
                RejectMessagesFromDLMembers             = $Mailbox.RejectMessagesFromDLMembers | Out-String
                RejectMessagesFromSendersOrMembers      = $Mailbox.RejectMessagesFromSendersOrMembers | Out-String
                RulesQuota                              = $Mailbox.RulesQuota

                ComplianceTagHoldApplied                = $Mailbox.ComplianceTagHoldApplied
                DelayHoldApplied                        = $Mailbox.DelayHoldApplied
                InPlaceHolds                            = $Mailbox.InPlaceHolds | Out-String
                InactiveMailboxRetireTime               = $Mailbox.InactiveMailboxRetireTime
                LitigationHoldDate                      = $Mailbox.LitigationHoldDate
                LitigationHoldDuration                  = $Mailbox.LitigationHoldDuration
                LitigationHoldEnabled                   = $Mailbox.LitigationHoldEnabled
                LitigationHoldOwner                     = $Mailbox.LitigationHoldOwner

                BypassModerationFromSendersOrMembers    = $Mailbox.BypassModerationFromSendersOrMembers | Out-String
                ModeratedBy                             = $Mailbox.ModeratedBy | Out-String
                ModerationEnabled                       = $Mailbox.ModerationEnabled
                SendModerationNotifications             = $Mailbox.SendModerationNotifications

                MailboxMoveBatchName                    = $Mailbox.MailboxMoveBatchName
                MailboxMoveFlags                        = $Mailbox.MailboxMoveFlags
                MailboxMoveRemoteHostName               = $Mailbox.MailboxMoveRemoteHostName
                MailboxMoveSourceMDB                    = $Mailbox.MailboxMoveSourceMDB
                MailboxMoveStatus                       = $Mailbox.MailboxMoveStatus
                MailboxMoveTargetMDB                    = $Mailbox.MailboxMoveTargetMDB

                DataEncryptionPolicy                    = $Mailbox.DataEncryptionPolicy
                EmailAddressPolicyEnabled               = $Mailbox.EmailAddressPolicyEnabled
                ManagedFolderMailboxPolicy              = $Mailbox.ManagedFolderMailboxPolicy
                PoliciesExcluded                        = $Mailbox.PoliciesExcluded | Out-String
                PoliciesIncluded                        = $Mailbox.PoliciesIncluded | Out-String
                RemoteAccountPolicy                     = $Mailbox.RemoteAccountPolicy
                RetentionPolicy                         = $Mailbox.RetentionPolicy
                RetentionUrl                            = $Mailbox.RetentionUrl
                RoleAssignmentPolicy                    = $Mailbox.RoleAssignmentPolicy
                SharingPolicy                           = $Mailbox.SharingPolicy
                ThrottlingPolicy                        = $Mailbox.ThrottlingPolicy

                DefaultPublicFolderMailbox              = $Mailbox.DefaultPublicFolderMailbox
                EffectivePublicFolderMailbox            = $Mailbox.EffectivePublicFolderMailbox
                IsExcludedFromServingHierarchy          = $Mailbox.IsExcludedFromServingHierarchy
                IsHierarchyReady                        = $Mailbox.IsHierarchyReady
                IsHierarchySyncEnabled                  = $Mailbox.IsHierarchySyncEnabled
                IsRootPublicFolderMailbox               = $Mailbox.IsRootPublicFolderMailbox

                CalendarLoggingQuota                    = $Mailbox.CalendarLoggingQuota
                IssueWarningQuota                       = $Mailbox.IssueWarningQuota
                ProhibitSendQuota                       = $Mailbox.ProhibitSendQuota
                ProhibitSendReceiveQuota                = $Mailbox.ProhibitSendReceiveQuota
                RecoverableItemsQuota                   = $Mailbox.RecoverableItemsQuota
                RecoverableItemsWarningQuota            = $Mailbox.RecoverableItemsWarningQuota
                UseDatabaseQuotaDefaults                = $Mailbox.UseDatabaseQuotaDefaults

                IsResource                              = $Mailbox.IsResource
                ResourceCapacity                        = $Mailbox.ResourceCapacity
                ResourceCustom                          = $Mailbox.ResourceCustom | Out-String
                ResourceType                            = $Mailbox.ResourceType
                RoomMailboxAccountEnabled               = $Mailbox.RoomMailboxAccountEnabled

                EndDateForRetentionHold                 = $Mailbox.EndDateForRetentionHold
                OrphanSoftDeleteTrackingTime            = $Mailbox.OrphanSoftDeleteTrackingTime
                RetainDeletedItemsFor                   = $Mailbox.RetainDeletedItemsFor
                RetainDeletedItemsUntilBackup           = $Mailbox.RetainDeletedItemsUntilBackup
                RetentionComment                        = $Mailbox.RetentionComment
                RetentionHoldEnabled                    = $Mailbox.RetentionHoldEnabled
                SingleItemRecoveryEnabled               = $Mailbox.SingleItemRecoveryEnabled
                StartDateForRetentionHold               = $Mailbox.StartDateForRetentionHold
                UseDatabaseRetentionDefaults            = $Mailbox.UseDatabaseRetentionDefaults

                AntispamBypassEnabled                   = $Mailbox.AntispamBypassEnabled
                SCLDeleteEnabled                        = $Mailbox.SCLDeleteEnabled
                SCLDeleteThreshold                      = $Mailbox.SCLDeleteThreshold
                SCLJunkEnabled                          = $Mailbox.SCLJunkEnabled
                SCLJunkThreshold                        = $Mailbox.SCLJunkThreshold
                SCLQuarantineEnabled                    = $Mailbox.SCLQuarantineEnabled
                SCLQuarantineThreshold                  = $Mailbox.SCLQuarantineThreshold
                SCLRejectEnabled                        = $Mailbox.SCLRejectEnabled
                SCLRejectThreshold                      = $Mailbox.SCLRejectThreshold

                IncludeInGarbageCollection              = $Mailbox.IncludeInGarbageCollection
                IsInactiveMailbox                       = $Mailbox.IsInactiveMailbox
                IsSoftDeletedByDisable                  = $Mailbox.IsSoftDeletedByDisable
                IsSoftDeletedByRemove                   = $Mailbox.IsSoftDeletedByRemove
                WhenSoftDeleted                         = $Mailbox.WhenSoftDeleted

                ArchiveDatabaseGuid                     = $Mailbox.ArchiveDatabaseGuid
                DatabaseGuid                            = $Mailbox.DatabaseGuid
                ExchangeGuid                            = $Mailbox.ExchangeGuid

                Credential                              = $Credential
                ApplicationId                           = $ApplicationId
                CertificateThumbprint                   = $CertificateThumbprint
                CertificatePath                         = $CertificatePath
                CertificatePassword                     = $CertificatePassword
                Managedidentity                         = $ManagedIdentity.IsPresent
                TenantId                                = $TenantId
            }

            $Results = Get-TargetResource @Params

            if ($Results -is [System.Collections.Hashtable] -and $Results.Count -gt 1)
            {
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
            }
            else
            {
                Write-Host $Global:M365DSCEmojiRedX
            }

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
