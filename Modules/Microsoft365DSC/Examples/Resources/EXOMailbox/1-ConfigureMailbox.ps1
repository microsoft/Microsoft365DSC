<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsCredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOMailbox "EXOMailbox-Adele Vance"
        {
            AcceptMessagesOnlyFrom                 = "";
            AcceptMessagesOnlyFromDLMembers        = "";
            AcceptMessagesOnlyFromSendersOrMembers = "";
            AddressListMembership                  = "\Offline Global Address List,\All Users,\Mailboxes(VLV),\All Mailboxes(VLV),\All Recipients(VLV),\Default Global Address List";
            Alias                                  = "AdeleV";
            AntispamBypassEnabled                  = $False;
            ApplicationId                          = $ConfigurationData.NonNodeData.ApplicationId;
            ArchiveGuid                            = "00000000-0000-0000-0000-000000000000";
            ArchiveName                            = "";
            ArchiveQuota                           = "100 GB (107,374,182,400 bytes)";
            ArchiveRelease                         = "";
            ArchiveState                           = "None";
            ArchiveStatus                          = "None";
            ArchiveWarningQuota                    = "90 GB (96,636,764,160 bytes)";
            AuditAdmin                             = "Update,MoveToDeletedItems,SoftDelete,HardDelete,SendAs,SendOnBehalf,Create,UpdateFolderPermissions,UpdateInboxRules,UpdateCalendarDelegation,ApplyRecord,MailItemsAccessed,Send";
            AuditDelegate                          = "Update,MoveToDeletedItems,SoftDelete,HardDelete,SendAs,SendOnBehalf,Create,UpdateFolderPermissions,UpdateInboxRules,ApplyRecord,MailItemsAccessed";
            AuditEnabled                           = $True;
            AuditLogAgeLimit                       = "90.00:00:00";
            AuditOwner                             = "Update,MoveToDeletedItems,SoftDelete,HardDelete,UpdateFolderPermissions,UpdateInboxRules,UpdateCalendarDelegation,ApplyRecord,MailItemsAccessed,Send";
            AutoExpandingArchiveEnabled            = $False;
            BypassModerationFromSendersOrMembers   = "";
            CalendarLoggingQuota                   = "6 GB (6,442,450,944 bytes)";
            CertificateThumbprint                  = $ConfigurationData.NonNodeData.CertificateThumbprint;
            ComplianceTagHoldApplied               = $False;
            CustomAttribute1                       = "";
            CustomAttribute10                      = "";
            CustomAttribute11                      = "";
            CustomAttribute12                      = "";
            CustomAttribute13                      = "";
            CustomAttribute14                      = "";
            CustomAttribute15                      = "";
            CustomAttribute2                       = "";
            CustomAttribute3                       = "";
            CustomAttribute4                       = "";
            CustomAttribute5                       = "";
            CustomAttribute6                       = "";
            CustomAttribute7                       = "";
            CustomAttribute8                       = "";
            CustomAttribute9                       = "";
            DefaultAuditSet                        = "Admin
Delegate
Owner
";
            DelayHoldApplied                       = $False;
            DeliverToMailboxAndForward             = $False;
            DisabledArchiveGuid                    = "00000000-0000-0000-0000-000000000000";
            DisplayName                            = "Adele Vance";
            DistinguishedName                      = "CN=AdeleV,OU=5g7sx3.onmicrosoft.com,OU=Microsoft Exchange Hosted Organizations,DC=NAMPR11A008,DC=PROD,DC=OUTLOOK,DC=COM";
            DowngradeHighPriorityMessagesEnabled   = $False;
            EmailAddresses                         = @("SPO_f955de6c-593d-409f-889a-dc45b2826bc3@SPO_f4e8115b-2acf-4c30-8d0a-8e5268c8174c");
            EmailAddressPolicyEnabled              = $False;
            Ensure                                 = "Present";
            ExchangeGuid                           = "00de9d65-ce46-4a2d-afca-73c2800d27ed";
            ExchangeVersion                        = "0.20 (15.0.0.0)";
            ExtensionCustomAttribute1              = "";
            ExtensionCustomAttribute2              = "";
            ExtensionCustomAttribute3              = "";
            ExtensionCustomAttribute4              = "";
            ExtensionCustomAttribute5              = "";
            ExternalDirectoryObjectId              = "4703c2e4-bbc1-4f88-bb4b-8c8dd53acb12";
            GeneratedOfflineAddressBooks           = "";
            GrantSendOnBehalfTo                    = "";
            Guid                                   = "303f52c6-5943-4edb-a110-a99796365f61";
            HiddenFromAddressListsEnabled          = $False;
            Id                                     = "AdeleV";
            Identity                               = "AdeleV";
            IncludeInGarbageCollection             = $False;
            InPlaceHolds                           = "";
            IsExcludedFromServingHierarchy         = $False;
            IsHierarchyReady                       = $True;
            IsHierarchySyncEnabled                 = $True;
            IsInactiveMailbox                      = $False;
            IsResource                             = $False;
            IsRootPublicFolderMailbox              = $False;
            IsSoftDeletedByDisable                 = $False;
            IsSoftDeletedByRemove                  = $False;
            IssueWarningQuota                      = "98 GB (105,226,698,752 bytes)";
            JournalArchiveAddress                  = "";
            LitigationHoldDuration                 = "Unlimited";
            LitigationHoldEnabled                  = $False;
            LitigationHoldOwner                    = "";
            MailboxMoveBatchName                   = "";
            MailboxMoveFlags                       = "None";
            MailboxMoveRemoteHostName              = "";
            MailboxMoveStatus                      = "None";
            MaxReceiveSize                         = "36 MB (37,748,736 bytes)";
            MaxSendSize                            = "35 MB (36,700,160 bytes)";
            MessageCopyForSendOnBehalfEnabled      = $False;
            MessageCopyForSentAsEnabled            = $False;
            MessageRecallProcessingEnabled         = $True;
            MessageTrackingReadStatusEnabled       = $True;
            ModeratedBy                            = "";
            ModerationEnabled                      = $False;
            Name                                   = "AdeleV";
            OrganizationId                         = "NAMPR11A008.PROD.OUTLOOK.COM/Microsoft Exchange Hosted Organizations/5g7sx3.onmicrosoft.com - NAMPR11A008.PROD.OUTLOOK.COM/ConfigurationUnits/5g7sx3.onmicrosoft.com/Configuration";
            PoliciesExcluded                       = "{26491cfc-9e50-4857-861b-0cb8df22b5d7}
";
            PoliciesIncluded                       = "";
            PrimarySmtpAddress                     = "AdeleV@5g7sx3.onmicrosoft.com";
            ProhibitSendQuota                      = "99 GB (106,300,440,576 bytes)";
            ProhibitSendReceiveQuota               = "100 GB (107,374,182,400 bytes)";
            RecipientLimits                        = "500";
            RecipientType                          = "UserMailbox";
            RecipientTypeDetails                   = "UserMailbox";
            RecoverableItemsQuota                  = "30 GB (32,212,254,720 bytes)";
            RecoverableItemsWarningQuota           = "20 GB (21,474,836,480 bytes)";
            RejectMessagesFrom                     = "";
            RejectMessagesFromDLMembers            = "";
            RejectMessagesFromSendersOrMembers     = "";
            ResourceCustom                         = "";
            RetainDeletedItemsFor                  = "14.00:00:00";
            RetainDeletedItemsUntilBackup          = $False;
            RetentionComment                       = "";
            RetentionHoldEnabled                   = $False;
            RetentionPolicy                        = "Default MRM Policy";
            RetentionUrl                           = "";
            RoleAssignmentPolicy                   = "Default Role Assignment Policy";
            RulesQuota                             = "256 KB (262,144 bytes)";
            SendModerationNotifications            = "Always";
            SharingPolicy                          = "Default Sharing Policy";
            SingleItemRecoveryEnabled              = $True;
            TenantId                               = $OrganizationName;
            UseDatabaseQuotaDefaults               = $False;
            UseDatabaseRetentionDefaults           = $False;
            UserPrincipalName                      = "AdeleV@5g7sx3.onmicrosoft.com";
        }
    }
}
