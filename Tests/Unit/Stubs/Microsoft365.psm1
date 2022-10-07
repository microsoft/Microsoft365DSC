#region ExchangeOnline
function Add-AvailabilityAddressSpace
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credentials,

        [Parameter()]
        [System.String]
        $ForestName,

        [Parameter()]
        [System.Uri]
        $TargetAutodiscoverEpr,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $AccessMethod
    )
}
function Disable-JournalRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Enable-JournalRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Enable-OrganizationCustomization
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm
    )
}
function Get-AcceptedDomain
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-ActiveSyncDevice
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $SortBy,

        [Parameter()]
        [System.Object]
        $Mailbox,

        [Parameter()]
        [System.Object]
        $OrganizationalUnit,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $ResultSize
    )
}
function Get-ActiveSyncDeviceAccessRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-AddressBookPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-AdminAuditLogConfig
{
    [CmdletBinding()]
    param(

    )
}
function Get-AntiPhishPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Impersonation,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Advanced,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Spoof
    )
}
function Get-AntiPhishRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $State
    )
}
function Get-App
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Mailbox,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $OrganizationApp,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PrivateCatalog
    )
}
function Get-ApplicationAccessPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-AtpPolicyForO365
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-AuditConfig
{
    [CmdletBinding()]
    param(

    )
}
function Get-AuditConfigurationPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-AuthenticationPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-AvailabilityAddressSpace
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-AvailabilityConfig
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-CASMailbox
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RecalculateHasActiveSyncDevicePartnership,

        [Parameter()]
        [System.String]
        $SortBy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProtocolSettings,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ReadIsOptimizedForAccessibility,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.Object]
        $OrganizationalUnit,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ActiveSyncDebugLogging,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IgnoreDefaultScope,

        [Parameter()]
        [System.Object[]]
        $RecipientTypeDetails,

        [Parameter()]
        [System.Object]
        $ResultSize,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ActiveSyncSuppressReadReceipt,

        [Parameter()]
        [System.String]
        $Anr
    )
}
function Get-CASMailboxPlan
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $SortBy,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IgnoreDefaultScope,

        [Parameter()]
        [System.Object]
        $ResultSize,

        [Parameter()]
        [System.String]
        $Filter
    )
}
function Get-ClientAccessRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $DomainController
    )
}
function Get-ComplianceTag
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IncludingLabelState,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-DataClassification
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $ClassificationRuleCollectionIdentity
    )
}
function Get-DataEncryptionPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $DomainController
    )
}
function Get-DeviceConditionalAccessPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-DeviceConfigurationPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-DistributionGroup
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $SortBy,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.Object]
        $OrganizationalUnit,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object[]]
        $RecipientTypeDetails,

        [Parameter()]
        [System.Object]
        $ManagedBy,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Object]
        $ResultSize,

        [Parameter()]
        [System.String]
        $Anr
    )
}
function Get-DkimSigningConfig
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-EmailAddressPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-HostedConnectionFilterPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-HostedContentFilterPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-HostedContentFilterRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $State
    )
}
function Get-HostedOutboundSpamFilterPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-HostedOutboundSpamFilterRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $State
    )
}
function Get-InboundConnector
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-IntraOrganizationConnector
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-IRMConfiguration
{
    [CmdletBinding()]
    param(

    )
}
function Get-JournalRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-Mailbox
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IncludeInactiveMailbox,

        [Parameter()]
        [System.String]
        $SortBy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $InactiveMailboxOnly,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $GroupMailbox,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PublicFolder,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Archive,

        [Parameter()]
        [System.Object]
        $OrganizationalUnit,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $SoftDeletedMailbox,

        [Parameter()]
        [System.Object[]]
        $RecipientTypeDetails,

        [Parameter()]
        [System.Object]
        $ResultSize,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Object]
        $MailboxPlan,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Migration,

        [Parameter()]
        [System.String]
        $Anr
    )
}
function Get-MailboxPlan
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $SortBy,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IgnoreDefaultScope,

        [Parameter()]
        [System.Object]
        $ResultSize,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllMailboxPlanReleases
    )
}
function Get-MailboxRegionalConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $VerifyDefaultFolderNameLanguage,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $UseCustomRouting,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Archive,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-MailContact
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $SortBy,

        [Parameter()]
        [System.Object]
        $OrganizationalUnit,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object[]]
        $RecipientTypeDetails,

        [Parameter()]
        [System.Object]
        $ResultSize,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $Anr
    )
}
function Get-MalwareFilterPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-MalwareFilterRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $State
    )
}
function Get-ManagementRole
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $RoleType,

        [Parameter()]
        [System.String[]]
        $CmdletParameters,

        [Parameter()]
        [System.String[]]
        $ScriptParameters,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.String]
        $Cmdlet,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Recurse,

        [Parameter()]
        [System.String]
        $Script,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $GetChildren
    )
}
function Get-ManagementRoleAssignment
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $RoleAssigneeType,

        [Parameter()]
        [System.Object]
        $CustomRecipientWriteScope,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.Object]
        $RecipientWriteScope,

        [Parameter()]
        [System.Object]
        $WritableRecipient,

        [Parameter()]
        [System.Object]
        $ConfigWriteScope,

        [Parameter()]
        [System.Object]
        $RoleAssignee,

        [Parameter()]
        [System.Boolean]
        $Delegating,

        [Parameter()]
        [System.Boolean]
        $Exclusive,

        [Parameter()]
        [System.Object[]]
        $AssignmentMethod,

        [Parameter()]
        [System.Object]
        $Role,

        [Parameter()]
        [System.Object]
        $RecipientAdministrativeUnitScope,

        [Parameter()]
        [System.Object]
        $ExclusiveRecipientWriteScope,

        [Parameter()]
        [System.Object]
        $RecipientOrganizationalUnitScope,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $GetEffectiveUsers
    )
}
function Get-MessageClassification
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IncludeLocales
    )
}
function Get-MobileDevice
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $OWAforDevices,

        [Parameter()]
        [System.String]
        $SortBy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $UniversalOutlook,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ActiveSync,

        [Parameter()]
        [System.Object]
        $Mailbox,

        [Parameter()]
        [System.Object]
        $OrganizationalUnit,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RestApi,

        [Parameter()]
        [System.Object]
        $ResultSize,

        [Parameter()]
        [System.String]
        $Filter
    )
}
function Get-MobileDeviceMailboxPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-OMEConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-OnPremisesOrganization
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-OrganizationConfig
{
    [CmdletBinding()]
    param(

    )
}
function Get-OrganizationRelationship
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-OutboundConnector
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $IncludeTestModeConnectors,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $IsTransportRuleScoped
    )
}
function Get-OwaMailboxPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-PartnerApplication
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-PerimeterConfig
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-PolicyTipConfig
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Action,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Original,

        [Parameter()]
        [System.Globalization.CultureInfo]
        $Locale,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-QuarantinePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $QuarantinePolicyType
    )
}
function Get-RemoteDomain
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-ResourceConfig
{
    [CmdletBinding()]
    param(

    )
}
function Get-RoleAssignmentPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-SafeAttachmentPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-SafeAttachmentRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $State
    )
}
function Get-SafeLinksPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-SafeLinksRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $State
    )
}
function Get-ServicePrincipal
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Organization
    )
}
function Get-SharingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-SupervisoryReviewPolicyV2
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-SupervisoryReviewRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Policy
    )
}
function Get-TransportConfig
{
    [CmdletBinding()]
    param(

    )
}
function Get-TransportRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $DlpPolicy,

        [Parameter()]
        [System.Object]
        $ResultSize,

        [Parameter()]
        [System.Boolean]
        $ExcludeConditionActionDetails,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Object]
        $State,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-User
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $SortBy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PublicFolder,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsVIP,

        [Parameter()]
        [System.Object]
        $OrganizationalUnit,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object[]]
        $RecipientTypeDetails,

        [Parameter()]
        [System.Object]
        $ResultSize,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $Anr
    )
}
function New-ActiveSyncDeviceAccessRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $QueryString,

        [Parameter()]
        [System.Object]
        $Characteristic,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $AccessLevel
    )
}
function New-AntiPhishPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $EnableFirstContactSafetyTips,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $MakeDefault,

        [Parameter()]
        [System.Int32]
        $PhishThresholdLevel,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Boolean]
        $EnableTargetedDomainsProtection,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.Boolean]
        $EnableViaTag,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object]
        $TargetedDomainsToProtect,

        [Parameter()]
        [System.Boolean]
        $EnableSpoofIntelligence,

        [Parameter()]
        [System.Boolean]
        $EnableSimilarUsersSafetyTips,

        [Parameter()]
        [System.Object]
        $ExcludedDomains,

        [Parameter()]
        [System.Object]
        $MailboxIntelligenceProtectionAction,

        [Parameter()]
        [System.Object]
        $TargetedDomainActionRecipients,

        [Parameter()]
        [System.Boolean]
        $EnableMailboxIntelligence,

        [Parameter()]
        [System.String]
        $TargetedDomainQuarantineTag,

        [Parameter()]
        [System.String]
        $SimilarUsersSafetyTipsCustomText,

        [Parameter()]
        [System.Object]
        $ImpersonationProtectionState,

        [Parameter()]
        [System.Object]
        $TargetedDomainProtectionAction,

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [System.Object]
        $TargetedUsersToProtect,

        [Parameter()]
        [System.Object]
        $TargetedUserProtectionAction,

        [Parameter()]
        [System.Object]
        $RecommendedPolicyType,

        [Parameter()]
        [System.Object]
        $MailboxIntelligenceProtectionActionRecipients,

        [Parameter()]
        [System.String]
        $MailboxIntelligenceQuarantineTag,

        [Parameter()]
        [System.String]
        $UnusualCharactersSafetyTipsCustomText,

        [Parameter()]
        [System.Boolean]
        $EnableSimilarDomainsSafetyTips,

        [Parameter()]
        [System.String]
        $SpoofQuarantineTag,

        [Parameter()]
        [System.Boolean]
        $EnableUnauthenticatedSender,

        [Parameter()]
        [System.String]
        $PolicyTag,

        [Parameter()]
        [System.String]
        $TargetedUserQuarantineTag,

        [Parameter()]
        [System.Boolean]
        $EnableOrganizationDomainsProtection,

        [Parameter()]
        [System.Boolean]
        $EnableMailboxIntelligenceProtection,

        [Parameter()]
        [System.Boolean]
        $EnableUnusualCharactersSafetyTips,

        [Parameter()]
        [System.Boolean]
        $EnableTargetedUserProtection,

        [Parameter()]
        [System.Object]
        $AuthenticationFailAction,

        [Parameter()]
        [System.Object]
        $TargetedUserActionRecipients,

        [Parameter()]
        [System.Object]
        $ExcludedSenders
    )
}
function New-AntiPhishRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Int32]
        $Priority,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object]
        $AntiPhishPolicy,

        [Parameter()]
        [System.Object[]]
        $SentToMemberOf,

        [Parameter()]
        [System.Object[]]
        $SentTo,

        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.Object[]]
        $RecipientDomainIs,

        [Parameter()]
        [System.Object[]]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSentTo,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSentToMemberOf,

        [Parameter()]
        [System.Boolean]
        $Enabled
    )
}
function New-App
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Etoken,

        [Parameter()]
        [System.IO.Stream]
        $FileStream,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.Uri]
        $Url,

        [Parameter()]
        [System.Object]
        $Mailbox,

        [Parameter()]
        [System.String]
        $MarketplaceServicesUrl,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PrivateCatalog,

        [Parameter()]
        [System.String]
        $MarketplaceCorrelationID,

        [Parameter()]
        [System.Object]
        $DefaultStateForUser,

        [Parameter()]
        [System.String]
        $MarketplaceQueryMarket,

        [Parameter()]
        [System.String]
        $MarketplaceUserProfileType,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $DownloadOnly,

        [Parameter()]
        [System.Object]
        $ProvidedTo,

        [Parameter()]
        [System.Object]
        $UserList,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $OrganizationApp,

        [Parameter()]
        [System.String]
        $MarketplaceAssetID,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Byte[]]
        $FileData,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowReadWriteMailbox
    )
}
function New-ApplicationAccessPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Object]
        $PolicyScopeGroupId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $AccessRight,

        [Parameter()]
        [System.String[]]
        $AppId
    )
}
function New-AuthenticationPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowBasicAuthPop,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowBasicAuthSmtp,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowBasicAuthMapi,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowBasicAuthImap,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowBasicAuthAutodiscover,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowBasicAuthPowershell,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowBasicAuthRpc,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowBasicAuthOfflineAddressBook,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowBasicAuthReportingWebServices,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowBasicAuthOutlookService,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowBasicAuthActiveSync,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowBasicAuthWebServices
    )
}
function New-AvailabilityConfig
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $OrgWideAccount
    )
}
function New-ClientAccessRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Action,

        [Parameter()]
        [System.Object]
        $AnyOfClientIPAddressesOrRanges,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.Object]
        $ExceptAnyOfClientIPAddressesOrRanges,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $UserRecipientFilter,

        [Parameter()]
        [System.Object]
        $ExceptAnyOfProtocols,

        [Parameter()]
        [System.Int32]
        $Priority,

        [Parameter()]
        [System.Object]
        $ExceptUsernameMatchesAnyOfPatterns,

        [Parameter()]
        [System.Object]
        $UsernameMatchesAnyOfPatterns,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $AnyOfAuthenticationTypes,

        [Parameter()]
        [System.Object]
        $AnyOfProtocols,

        [Parameter()]
        [System.Object]
        $ExceptAnyOfAuthenticationTypes,

        [Parameter()]
        [System.Object]
        $Scope
    )
}
function New-DataClassification
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Globalization.CultureInfo]
        $Locale,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Fingerprints,

        [Parameter()]
        [System.Object]
        $ClassificationRuleCollectionIdentity
    )
}
function New-DataEncryptionPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object]
        $DomainController,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $AzureKeyIDs,

        [Parameter()]
        [System.Boolean]
        $Enabled
    )
}
function New-DistributionGroup
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $ModeratedBy,

        [Parameter()]
        [System.Boolean]
        $RequireSenderAuthenticationEnabled,

        [Parameter()]
        [System.Boolean]
        $ModerationEnabled,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Object]
        $MemberDepartRestriction,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IgnoreNamingPolicy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RoomList,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $HiddenGroupMembershipEnabled,

        [Parameter()]
        [System.Boolean]
        $BypassNestedModerationEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $CopyOwnerToMember,

        [Parameter()]
        [System.Boolean]
        $BccBlocked,

        [Parameter()]
        [System.Object]
        $Members,

        [Parameter()]
        [System.Object]
        $Description,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.Object]
        $MemberJoinRestriction,

        [Parameter()]
        [System.Object]
        $Type,

        [Parameter()]
        [System.Object]
        $ManagedBy,

        [Parameter()]
        [System.String]
        $Alias,

        [Parameter()]
        [System.Object]
        $PrimarySmtpAddress,

        [Parameter()]
        [System.Object]
        $SendModerationNotifications,

        [Parameter()]
        [System.Object]
        $OrganizationalUnit
    )
}
function New-DkimSigningConfig
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [System.Object]
        $BodyCanonicalization,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $HeaderCanonicalization,

        [Parameter()]
        [System.UInt16]
        $KeySize,

        [Parameter()]
        [System.Object]
        $DomainName,

        [Parameter()]
        [System.Boolean]
        $Enabled
    )
}
function New-EmailAddressPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Priority,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object]
        $EnabledEmailAddressTemplates,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $EnabledPrimarySMTPAddressTemplate,

        [Parameter()]
        [System.String]
        $ManagedByFilter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IncludeUnifiedGroupRecipients
    )
}
function New-HostedConnectionFilterPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $ConfigurationXmlRaw,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [System.Boolean]
        $EnableSafeList,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $IPBlockList,

        [Parameter()]
        [System.Object]
        $IPAllowList
    )
}
function New-HostedContentFilterPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Boolean]
        $InlineSafetyTipsEnabled,

        [Parameter()]
        [System.Object]
        $BulkSpamAction,

        [Parameter()]
        [System.String]
        $HighConfidencePhishQuarantineTag,

        [Parameter()]
        [System.Int32]
        $EndUserSpamNotificationFrequency,

        [Parameter()]
        [System.Int32]
        $EndUserSpamNotificationLimit,

        [Parameter()]
        [System.Int32]
        $BulkThreshold,

        [Parameter()]
        [System.Object]
        $TestModeBccToRecipients,

        [Parameter()]
        [System.String]
        $PhishQuarantineTag,

        [Parameter()]
        [System.String]
        $AddXHeaderValue,

        [Parameter()]
        [System.Object]
        $MarkAsSpamEmbedTagsInHtml,

        [Parameter()]
        [System.Object]
        $MarkAsSpamFramesInHtml,

        [Parameter()]
        [System.Object]
        $IncreaseScoreWithImageLinks,

        [Parameter()]
        [System.Boolean]
        $EnableLanguageBlockList,

        [Parameter()]
        [System.Object]
        $PhishSpamAction,

        [Parameter()]
        [System.String]
        $EndUserSpamNotificationCustomFromName,

        [Parameter()]
        [System.Object]
        $MarkAsSpamSensitiveWordList,

        [Parameter()]
        [System.String]
        $SpamQuarantineTag,

        [Parameter()]
        [System.Object]
        $MarkAsSpamNdrBackscatter,

        [Parameter()]
        [System.Object]
        $BlockedSenders,

        [Parameter()]
        [System.Object]
        $LanguageBlockList,

        [Parameter()]
        [System.Object]
        $HighConfidenceSpamAction,

        [Parameter()]
        [System.Object]
        $AllowedSenderDomains,

        [Parameter()]
        [System.Boolean]
        $PhishZapEnabled,

        [Parameter()]
        [System.Object]
        $IncreaseScoreWithBizOrInfoUrls,

        [Parameter()]
        [System.Object]
        $MarkAsSpamWebBugsInHtml,

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [System.Object]
        $RegionBlockList,

        [Parameter()]
        [System.Object]
        $MarkAsSpamFromAddressAuthFail,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object]
        $MarkAsSpamEmptyMessages,

        [Parameter()]
        [System.String]
        $BulkQuarantineTag,

        [Parameter()]
        [System.Object]
        $MarkAsSpamFormTagsInHtml,

        [Parameter()]
        [System.Object]
        $MarkAsSpamObjectTagsInHtml,

        [Parameter()]
        [System.Object]
        $EndUserSpamNotificationLanguage,

        [Parameter()]
        [System.Object]
        $IncreaseScoreWithRedirectToOtherPort,

        [Parameter()]
        [System.Int32]
        $QuarantineRetentionPeriod,

        [Parameter()]
        [System.Object]
        $HighConfidencePhishAction,

        [Parameter()]
        [System.Object]
        $RedirectToRecipients,

        [Parameter()]
        [System.Boolean]
        $SpamZapEnabled,

        [Parameter()]
        [System.Object]
        $TestModeAction,

        [Parameter()]
        [System.Boolean]
        $EnableRegionBlockList,

        [Parameter()]
        [System.String]
        $EndUserSpamNotificationCustomSubject,

        [Parameter()]
        [System.Object]
        $MarkAsSpamSpfRecordHardFail,

        [Parameter()]
        [System.Object]
        $EndUserSpamNotificationCustomFromAddress,

        [Parameter()]
        [System.Boolean]
        $DownloadLink,

        [Parameter()]
        [System.Object]
        $SpamAction,

        [Parameter()]
        [System.String]
        $ModifySubjectValue,

        [Parameter()]
        [System.Object]
        $IncreaseScoreWithNumericIps,

        [Parameter()]
        [System.Object]
        $AllowedSenders,

        [Parameter()]
        [System.Object]
        $MarkAsSpamJavaScriptInHtml,

        [Parameter()]
        [System.Object]
        $MarkAsSpamBulkMail,

        [Parameter()]
        [System.Object]
        $BlockedSenderDomains,

        [Parameter()]
        [System.Object]
        $RecommendedPolicyType,

        [Parameter()]
        [System.Boolean]
        $EnableEndUserSpamNotifications,

        [Parameter()]
        [System.String]
        $HighConfidenceSpamQuarantineTag
    )
}
function New-HostedContentFilterRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Int32]
        $Priority,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object[]]
        $SentToMemberOf,

        [Parameter()]
        [System.Object]
        $HostedContentFilterPolicy,

        [Parameter()]
        [System.Object[]]
        $SentTo,

        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.Object[]]
        $RecipientDomainIs,

        [Parameter()]
        [System.Object[]]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSentTo,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSentToMemberOf,

        [Parameter()]
        [System.Boolean]
        $Enabled
    )
}
function New-HostedOutboundSpamFilterRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Int32]
        $Priority,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object[]]
        $ExceptIfFromMemberOf,

        [Parameter()]
        [System.Object[]]
        $ExceptIfFrom,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSenderDomainIs,

        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.Object[]]
        $FromMemberOf,

        [Parameter()]
        [System.Object[]]
        $SenderDomainIs,

        [Parameter()]
        [System.Object]
        $HostedOutboundSpamFilterPolicy,

        [Parameter()]
        [System.Object[]]
        $From,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm
    )
}
function New-InboundConnector
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $RestrictDomainsToIPAddresses,

        [Parameter()]
        [System.Boolean]
        $CloudServicesMailEnabled,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.Object]
        $EFSkipMailGateway,

        [Parameter()]
        [System.Boolean]
        $EFTestMode,

        [Parameter()]
        [System.Object]
        $TrustedOrganizations,

        [Parameter()]
        [System.Object]
        $TlsSenderCertificateName,

        [Parameter()]
        [System.Object]
        $ScanAndDropRecipients,

        [Parameter()]
        [System.Object]
        $AssociatedAcceptedDomains,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [System.Boolean]
        $RequireTls,

        [Parameter()]
        [System.Object]
        $SenderDomains,

        [Parameter()]
        [System.Object]
        $SenderIPAddresses,

        [Parameter()]
        [System.Boolean]
        $EFSkipLastIP,

        [Parameter()]
        [System.Object]
        $EFUsers,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $ConnectorType,

        [Parameter()]
        [System.Boolean]
        $RestrictDomainsToCertificate,

        [Parameter()]
        [System.Object]
        $EFSkipIPs,

        [Parameter()]
        [System.Boolean]
        $TreatMessagesAsInternal,

        [Parameter()]
        [System.Object]
        $ConnectorSource,

        [Parameter()]
        [System.String]
        $Name
    )
}
function New-IntraOrganizationConnector
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object]
        $TargetAddressDomains,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Uri]
        $TargetSharingEpr,

        [Parameter()]
        [System.Uri]
        $DiscoveryEndpoint,

        [Parameter()]
        [System.Boolean]
        $Enabled
    )
}
function New-JournalRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object]
        $Scope,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $JournalEmailAddress,

        [Parameter()]
        [System.Object]
        $Recipient,

        [Parameter()]
        [System.Boolean]
        $Enabled
    )
}
function New-Mailbox
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $MailboxRegion,

        [Parameter()]
        [System.Object]
        $ModeratedBy,

        [Parameter()]
        [System.Boolean]
        $ModerationEnabled,

        [Parameter()]
        [System.Boolean]
        $EnableRoomMailboxAccount,

        [Parameter()]
        [System.String]
        $Office,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Security.SecureString]
        $Password,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object]
        $RemovedMailbox,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PublicFolder,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.String]
        $LastName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $TargetAllMDBs,

        [Parameter()]
        [System.Object]
        $RoleAssignmentPolicy,

        [Parameter()]
        [System.Object]
        $ResourceCapacity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Archive,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Equipment,

        [Parameter()]
        [System.String]
        $ImmutableId,

        [Parameter()]
        [System.Security.SecureString]
        $RoomMailboxPassword,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Shared,

        [Parameter()]
        [System.Boolean]
        $IsExcludedFromServingHierarchy,

        [Parameter()]
        [System.Object]
        $MailboxPlan,

        [Parameter()]
        [System.Object]
        $MicrosoftOnlineServicesID,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Migration,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Room,

        [Parameter()]
        [System.String]
        $Initials,

        [Parameter()]
        [System.Object]
        $InactiveMailbox,

        [Parameter()]
        [System.String]
        $FederatedIdentity,

        [Parameter()]
        [System.Object]
        $ActiveSyncMailboxPolicy,

        [Parameter()]
        [System.Object]
        $OrganizationalUnit,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $HoldForMigration,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Discovery,

        [Parameter()]
        [System.Boolean]
        $ResetPasswordOnNextLogon,

        [Parameter()]
        [System.String]
        $FirstName,

        [Parameter()]
        [System.String]
        $Phone,

        [Parameter()]
        [System.Object]
        $PrimarySmtpAddress,

        [Parameter()]
        [System.Object]
        $SendModerationNotifications,

        [Parameter()]
        [System.String]
        $Alias,

        [Parameter()]
        [System.Boolean]
        $RemotePowerShellEnabled
    )
}
function New-MailContact
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $ModeratedBy,

        [Parameter()]
        [System.Boolean]
        $ModerationEnabled,

        [Parameter()]
        [System.Object]
        $MacAttachmentFormat,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $LastName,

        [Parameter()]
        [System.Boolean]
        $UsePreferMessageFormat,

        [Parameter()]
        [System.Object]
        $MessageBodyFormat,

        [Parameter()]
        [System.String]
        $Initials,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $ExternalEmailAddress,

        [Parameter()]
        [System.String]
        $Alias,

        [Parameter()]
        [System.Object]
        $MessageFormat,

        [Parameter()]
        [System.String]
        $FirstName,

        [Parameter()]
        [System.Object]
        $SendModerationNotifications,

        [Parameter()]
        [System.Object]
        $OrganizationalUnit
    )
}
function New-MalwareFilterPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $CustomFromName,

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $CustomExternalBody,

        [Parameter()]
        [System.String]
        $QuarantineTag,

        [Parameter()]
        [System.Boolean]
        $CustomNotifications,

        [Parameter()]
        [System.Boolean]
        $EnableExternalSenderAdminNotifications,

        [Parameter()]
        [System.Object]
        $InternalSenderAdminAddress,

        [Parameter()]
        [System.String[]]
        $FileTypes,

        [Parameter()]
        [System.Boolean]
        $EnableInternalSenderAdminNotifications,

        [Parameter()]
        [System.Object]
        $CustomFromAddress,

        [Parameter()]
        [System.String]
        $CustomExternalSubject,

        [Parameter()]
        [System.Boolean]
        $ZapEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $ExternalSenderAdminAddress,

        [Parameter()]
        [System.Object]
        $RecommendedPolicyType,

        [Parameter()]
        [System.Object]
        $FileTypeAction,

        [Parameter()]
        [System.String]
        $CustomInternalSubject,

        [Parameter()]
        [System.String]
        $CustomInternalBody,

        [Parameter()]
        [System.Boolean]
        $EnableFileFilter
    )
}
function New-MalwareFilterRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Int32]
        $Priority,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object[]]
        $SentToMemberOf,

        [Parameter()]
        [System.Object[]]
        $SentTo,

        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.Object[]]
        $RecipientDomainIs,

        [Parameter()]
        [System.Object]
        $MalwareFilterPolicy,

        [Parameter()]
        [System.Object[]]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSentTo,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSentToMemberOf,

        [Parameter()]
        [System.Boolean]
        $Enabled
    )
}
function New-ManagementRole
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $EnabledCmdlets,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Parent,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )
}
function New-ManagementRoleAssignment
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $CustomRecipientWriteScope,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $Policy,

        [Parameter()]
        [System.Object]
        $SecurityGroup,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Delegating,

        [Parameter()]
        [System.Object]
        $User,

        [Parameter()]
        [System.Object]
        $RecipientRelativeWriteScope,

        [Parameter()]
        [System.Object]
        $App,

        [Parameter()]
        [System.Object]
        $Role,

        [Parameter()]
        [System.Object]
        $CustomResourceScope,

        [Parameter()]
        [System.Object]
        $RecipientAdministrativeUnitScope,

        [Parameter()]
        [System.Object]
        $ExclusiveRecipientWriteScope,

        [Parameter()]
        [System.Object]
        $RecipientOrganizationalUnitScope
    )
}
function New-MessageClassification
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $SenderDescription,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $RecipientDescription,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Globalization.CultureInfo]
        $Locale,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Boolean]
        $RetainClassificationEnabled,

        [Parameter()]
        [System.Boolean]
        $PermissionMenuVisible,

        [Parameter()]
        [System.Guid]
        $ClassificationID,

        [Parameter()]
        [System.Object]
        $DisplayPrecedence
    )
}
function New-MobileDeviceMailboxPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $AllowMicrosoftPushNotifications,

        [Parameter()]
        [System.Boolean]
        $AllowUnsignedApplications,

        [Parameter()]
        [System.Boolean]
        $AllowUnsignedInstallationPackages,

        [Parameter()]
        [System.Object]
        $MaxPasswordFailedAttempts,

        [Parameter()]
        [System.Boolean]
        $AllowExternalDeviceManagement,

        [Parameter()]
        [System.Boolean]
        $AllowIrDA,

        [Parameter()]
        [System.Boolean]
        $RequireSignedSMIMEMessages,

        [Parameter()]
        [System.Boolean]
        $AllowStorageCard,

        [Parameter()]
        [System.Int32]
        $PasswordHistory,

        [Parameter()]
        [System.Boolean]
        $AllowNonProvisionableDevices,

        [Parameter()]
        [System.Object]
        $UnapprovedInROMApplicationList,

        [Parameter()]
        [System.Boolean]
        $RequireEncryptedSMIMEMessages,

        [Parameter()]
        [System.Boolean]
        $RequireDeviceEncryption,

        [Parameter()]
        [System.Boolean]
        $AllowInternetSharing,

        [Parameter()]
        [System.Boolean]
        $PasswordEnabled,

        [Parameter()]
        [System.Object]
        $RequireSignedSMIMEAlgorithm,

        [Parameter()]
        [System.Object]
        $MaxEmailHTMLBodyTruncationSize,

        [Parameter()]
        [System.Int32]
        $MinPasswordComplexCharacters,

        [Parameter()]
        [System.Boolean]
        $UNCAccessEnabled,

        [Parameter()]
        [System.Boolean]
        $AllowCamera,

        [Parameter()]
        [System.Boolean]
        $IrmEnabled,

        [Parameter()]
        [System.Object]
        $PasswordExpiration,

        [Parameter()]
        [System.Boolean]
        $AllowBrowser,

        [Parameter()]
        [System.Object]
        $MaxEmailAgeFilter,

        [Parameter()]
        [System.Boolean]
        $RequireManualSyncWhenRoaming,

        [Parameter()]
        [System.Boolean]
        $AlphanumericPasswordRequired,

        [Parameter()]
        [System.Object]
        $AllowSMIMEEncryptionAlgorithmNegotiation,

        [Parameter()]
        [System.Object]
        $MaxEmailBodyTruncationSize,

        [Parameter()]
        [System.Object]
        $AllowBluetooth,

        [Parameter()]
        [System.Object]
        $RequireEncryptionSMIMEAlgorithm,

        [Parameter()]
        [System.Object]
        $DevicePolicyRefreshInterval,

        [Parameter()]
        [System.Boolean]
        $AllowGooglePushNotifications,

        [Parameter()]
        [System.Boolean]
        $AllowMobileOTAUpdate,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object]
        $MaxAttachmentSize,

        [Parameter()]
        [System.Boolean]
        $AllowSimplePassword,

        [Parameter()]
        [System.Boolean]
        $AllowConsumerEmail,

        [Parameter()]
        [System.Boolean]
        $AllowDesktopSync,

        [Parameter()]
        [System.Boolean]
        $RequireStorageCardEncryption,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Boolean]
        $AttachmentsEnabled,

        [Parameter()]
        [System.Boolean]
        $AllowSMIMESoftCerts,

        [Parameter()]
        [System.Boolean]
        $AllowRemoteDesktop,

        [Parameter()]
        [System.Boolean]
        $PasswordRecoveryEnabled,

        [Parameter()]
        [System.Object]
        $MaxCalendarAgeFilter,

        [Parameter()]
        [System.Boolean]
        $AllowWiFi,

        [Parameter()]
        [System.Boolean]
        $AllowApplePushNotifications,

        [Parameter()]
        [System.Boolean]
        $AllowPOPIMAPEmail,

        [Parameter()]
        [System.Boolean]
        $IsDefault,

        [Parameter()]
        [System.Object]
        $MaxInactivityTimeLock,

        [Parameter()]
        [System.Object]
        $ApprovedApplicationList,

        [Parameter()]
        [System.Boolean]
        $AllowTextMessaging,

        [Parameter()]
        [System.Boolean]
        $WSSAccessEnabled,

        [Parameter()]
        [System.Boolean]
        $DeviceEncryptionEnabled,

        [Parameter()]
        [System.Object]
        $MinPasswordLength,

        [Parameter()]
        [System.Boolean]
        $AllowHTMLEmail
    )
}
function New-OMEConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Double]
        $ExternalMailExpiryInDays,

        [Parameter()]
        [System.String]
        $ReadButtonText,

        [Parameter()]
        [System.String]
        $PortalText,

        [Parameter()]
        [System.Byte[]]
        $Image,

        [Parameter()]
        [System.String]
        $IntroductionText,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $BackgroundColor,

        [Parameter()]
        [System.String]
        $DisclaimerText,

        [Parameter()]
        [System.String]
        $PrivacyStatementUrl,

        [Parameter()]
        [System.Boolean]
        $SocialIdSignIn,

        [Parameter()]
        [System.String]
        $EmailText,

        [Parameter()]
        [System.Boolean]
        $OTPEnabled,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function New-OnPremisesOrganization
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $InboundConnector,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object]
        $OutboundConnector,

        [Parameter()]
        [System.String]
        $OrganizationName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [System.Guid]
        $OrganizationGuid,

        [Parameter()]
        [System.Object]
        $OrganizationRelationship,

        [Parameter()]
        [System.Object]
        $HybridDomains
    )
}
function New-OrganizationRelationship
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $MailTipsAccessLevel,

        [Parameter()]
        [System.Uri]
        $TargetAutodiscoverEpr,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object]
        $FreeBusyAccessScope,

        [Parameter()]
        [System.Boolean]
        $DeliveryReportEnabled,

        [Parameter()]
        [System.String]
        $OAuthApplicationId,

        [Parameter()]
        [System.Boolean]
        $MailTipsAccessEnabled,

        [Parameter()]
        [System.Object]
        $OrganizationContact,

        [Parameter()]
        [System.Boolean]
        $ArchiveAccessEnabled,

        [Parameter()]
        [System.Boolean]
        $FreeBusyAccessEnabled,

        [Parameter()]
        [System.Object]
        $MailTipsAccessScope,

        [Parameter()]
        [System.Uri]
        $TargetOwaURL,

        [Parameter()]
        [System.Uri]
        $TargetApplicationUri,

        [Parameter()]
        [System.Boolean]
        $PhotosEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $MailboxMovePublishedScopes,

        [Parameter()]
        [System.Boolean]
        $MailboxMoveEnabled,

        [Parameter()]
        [System.Object]
        $MailboxMoveCapability,

        [Parameter()]
        [System.Uri]
        $TargetSharingEpr,

        [Parameter()]
        [System.Object]
        $FreeBusyAccessLevel,

        [Parameter()]
        [System.Object]
        $DomainNames
    )
}
function New-OutboundConnector
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $RouteAllMessagesViaOnPremises,

        [Parameter()]
        [System.Object]
        $RecipientDomains,

        [Parameter()]
        [System.Boolean]
        $CloudServicesMailEnabled,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.Guid]
        $LinkForModifiedConnector,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Boolean]
        $AllAcceptedDomains,

        [Parameter()]
        [System.Object]
        $TlsDomain,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [System.Boolean]
        $IsTransportRuleScoped,

        [Parameter()]
        [System.Boolean]
        $UseMXRecord,

        [Parameter()]
        [System.Object]
        $TlsSettings,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $ConnectorType,

        [Parameter()]
        [System.Object]
        $SmartHosts,

        [Parameter()]
        [System.Boolean]
        $SenderRewritingEnabled,

        [Parameter()]
        [System.Boolean]
        $TestMode,

        [Parameter()]
        [System.Object]
        $ConnectorSource
    )
}
function New-OwaMailboxPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsDefault
    )
}
function New-PartnerApplication
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $ApplicationIdentifier,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object]
        $LinkedAccount,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Boolean]
        $AcceptSecurityIdentifierInformation,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.Object]
        $AccountType
    )
}
function New-PolicyTipConfig
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Value,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm
    )
}
function New-QuarantinePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $MultiLanguageCustomDisclaimer,

        [Parameter()]
        [System.Object]
        $AdminNotificationLanguage,

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [System.Int32]
        $EndUserSpamNotificationFrequencyInDays,

        [Parameter()]
        [System.String]
        $CustomDisclaimer,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Int32]
        $EndUserQuarantinePermissionsValue,

        [Parameter()]
        [System.Boolean]
        $ESNEnabled,

        [Parameter()]
        [System.Object]
        $EndUserQuarantinePermissions,

        [Parameter()]
        [System.Boolean]
        $AdminNotificationsEnabled,

        [Parameter()]
        [System.Object]
        $EndUserSpamNotificationLanguage,

        [Parameter()]
        [System.Object]
        $DomainController,

        [Parameter()]
        [System.Object]
        $MultiLanguageSenderName,

        [Parameter()]
        [System.Object]
        $AdminQuarantinePermissionsList,

        [Parameter()]
        [System.Object]
        $MultiLanguageSetting,

        [Parameter()]
        [System.Int32]
        $QuarantineRetentionDays,

        [Parameter()]
        [System.Boolean]
        $OrganizationBrandingEnabled,

        [Parameter()]
        [System.Int32]
        $AdminNotificationFrequencyInDays,

        [Parameter()]
        [System.Object]
        $QuarantinePolicyType
    )
}
function New-RemoteDomain
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $DomainName
    )
}
function New-RoleAssignmentPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object[]]
        $Roles,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsDefault
    )
}
function New-SafeAttachmentPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Action,

        [Parameter()]
        [System.Object]
        $RecommendedPolicyType,

        [Parameter()]
        [System.Boolean]
        $Redirect,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $MakeBuiltInProtection,

        [Parameter()]
        [System.Boolean]
        $Enable,

        [Parameter()]
        [System.Object]
        $RedirectAddress,

        [Parameter()]
        [System.String]
        $QuarantineTag,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Boolean]
        $ActionOnError
    )
}
function New-SafeAttachmentRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Int32]
        $Priority,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object[]]
        $SentToMemberOf,

        [Parameter()]
        [System.Object[]]
        $SentTo,

        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.Object[]]
        $RecipientDomainIs,

        [Parameter()]
        [System.Object]
        $SafeAttachmentPolicy,

        [Parameter()]
        [System.Object[]]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSentTo,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSentToMemberOf,

        [Parameter()]
        [System.Boolean]
        $Enabled
    )
}
function New-SafeLinksPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $EnableOrganizationBranding,

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [System.Boolean]
        $UseTranslatedNotificationText,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $MakeBuiltInProtection,

        [Parameter()]
        [System.Object]
        $DoNotRewriteUrls,

        [Parameter()]
        [System.Boolean]
        $EnableSafeLinksForTeams,

        [Parameter()]
        [System.Boolean]
        $DisableUrlRewrite,

        [Parameter()]
        [System.Boolean]
        $EnableSafeLinksForOffice,

        [Parameter()]
        [System.Boolean]
        $TrackClicks,

        [Parameter()]
        [System.Boolean]
        $AllowClickThrough,

        [Parameter()]
        [System.Object]
        $RecommendedPolicyType,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $CustomNotificationText,

        [Parameter()]
        [System.Boolean]
        $DeliverMessageAfterScan,

        [Parameter()]
        [System.Boolean]
        $EnableSafeLinksForEmail,

        [Parameter()]
        [System.Boolean]
        $ScanUrls,

        [Parameter()]
        [System.Boolean]
        $EnableForInternalSenders
    )
}
function New-SafeLinksRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Int32]
        $Priority,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object[]]
        $SentToMemberOf,

        [Parameter()]
        [System.Object[]]
        $SentTo,

        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.Object[]]
        $RecipientDomainIs,

        [Parameter()]
        [System.Object[]]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.Object]
        $SafeLinksPolicy,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSentTo,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSentToMemberOf,

        [Parameter()]
        [System.Boolean]
        $Enabled
    )
}
function New-SharingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Domains,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Default,

        [Parameter()]
        [System.Boolean]
        $Enabled
    )
}
function New-TransportRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $ActivationDate,

        [Parameter()]
        [System.Object[]]
        $AddToRecipients,

        [Parameter()]
        [System.Object]
        $ApplyHtmlDisclaimerFallbackAction,

        [Parameter()]
        [System.Object[]]
        $ExceptIfRecipientADAttributeContainsWords,

        [Parameter()]
        [System.Object]
        $AttachmentSizeOver,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSenderADAttributeContainsWords,

        [Parameter()]
        [System.Object]
        $SetSCL,

        [Parameter()]
        [System.Object[]]
        $AnyOfToHeaderMemberOf,

        [Parameter()]
        [System.Boolean]
        $Disconnect,

        [Parameter()]
        [System.Int32]
        $Priority,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSentToMemberOf,

        [Parameter()]
        [System.Object[]]
        $ExceptIfAnyOfCcHeader,

        [Parameter()]
        [System.Object[]]
        $ExceptIfAttachmentMatchesPatterns,

        [Parameter()]
        [System.Object[]]
        $RecipientDomainIs,

        [Parameter()]
        [System.Object]
        $ManagerForEvaluatedUser,

        [Parameter()]
        [System.Object[]]
        $ExceptIfHeaderMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfFromScope,

        [Parameter()]
        [System.Object]
        $AdComparisonAttribute,

        [Parameter()]
        [System.Object[]]
        $ExceptIfAttachmentContainsWords,

        [Parameter()]
        [System.Object[]]
        $ExceptIfHeaderContainsWords,

        [Parameter()]
        [System.Object[]]
        $HeaderMatchesPatterns,

        [Parameter()]
        [System.Object]
        $AddManagerAsRecipientType,

        [Parameter()]
        [System.Boolean]
        $DeleteMessage,

        [Parameter()]
        [System.Boolean]
        $HasSenderOverride,

        [Parameter()]
        [System.Object]
        $SmtpRejectMessageRejectStatusCode,

        [Parameter()]
        [System.String]
        $ExceptIfHasClassification,

        [Parameter()]
        [System.Boolean]
        $Quarantine,

        [Parameter()]
        [System.Object[]]
        $ExceptIfAnyOfRecipientAddressMatchesPatterns,

        [Parameter()]
        [System.Object[]]
        $ExceptIfRecipientInSenderList,

        [Parameter()]
        [System.Object]
        $RecipientAddressType,

        [Parameter()]
        [System.Object[]]
        $ExceptIfContentCharacterSetContainsWords,

        [Parameter()]
        [System.Object[]]
        $BlindCopyTo,

        [Parameter()]
        [System.Object]
        $ApplyHtmlDisclaimerLocation,

        [Parameter()]
        [System.Object]
        $ExceptIfMessageTypeMatches,

        [Parameter()]
        [System.Object]
        $SenderIpRanges,

        [Parameter()]
        [System.Collections.Hashtable[]]
        $ExceptIfMessageContainsDataClassifications,

        [Parameter()]
        [System.Object[]]
        $ModerateMessageByUser,

        [Parameter()]
        [System.Boolean]
        $HasNoClassification,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSenderInRecipientList,

        [Parameter()]
        [System.Object]
        $HeaderContainsMessageHeader,

        [Parameter()]
        [System.Object]
        $RemoveHeader,

        [Parameter()]
        [System.String]
        $HasClassification,

        [Parameter()]
        [System.Collections.Hashtable[]]
        $MessageContainsDataClassifications,

        [Parameter()]
        [System.Object[]]
        $ExceptIfFromMemberOf,

        [Parameter()]
        [System.Object]
        $RuleSubType,

        [Parameter()]
        [System.Object]
        $SentToScope,

        [Parameter()]
        [System.Object[]]
        $AnyOfToCcHeaderMemberOf,

        [Parameter()]
        [System.Object[]]
        $From,

        [Parameter()]
        [System.Object[]]
        $ExceptIfAnyOfRecipientAddressContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfWithImportance,

        [Parameter()]
        [System.Object[]]
        $ContentCharacterSetContainsWords,

        [Parameter()]
        [System.Object[]]
        $SubjectContainsWords,

        [Parameter()]
        [System.Object]
        $RejectMessageEnhancedStatusCode,

        [Parameter()]
        [System.Object[]]
        $SenderADAttributeMatchesPatterns,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSenderADAttributeMatchesPatterns,

        [Parameter()]
        [System.Object[]]
        $IncidentReportContent,

        [Parameter()]
        [System.Boolean]
        $UseLegacyRegex,

        [Parameter()]
        [System.Object[]]
        $FromMemberOf,

        [Parameter()]
        [System.Object[]]
        $AttachmentContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfSCLOver,

        [Parameter()]
        [System.Object[]]
        $ExceptIfBetweenMemberOf1,

        [Parameter()]
        [System.Object]
        $GenerateNotification,

        [Parameter()]
        [System.Object]
        $NotifySender,

        [Parameter()]
        [System.Boolean]
        $ExceptIfAttachmentIsPasswordProtected,

        [Parameter()]
        [System.Object[]]
        $ExceptIfAttachmentNameMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderManagementRelationship,

        [Parameter()]
        [System.String]
        $SetAuditSeverity,

        [Parameter()]
        [System.Object[]]
        $AttachmentPropertyContainsWords,

        [Parameter()]
        [System.Object[]]
        $ExceptIfAnyOfToHeader,

        [Parameter()]
        [System.Object]
        $ApplyRightsProtectionCustomizationTemplate,

        [Parameter()]
        [System.Object]
        $SetHeaderName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Boolean]
        $RouteMessageOutboundRequireTls,

        [Parameter()]
        [System.Object]
        $WithImportance,

        [Parameter()]
        [System.Object]
        $RuleErrorAction,

        [Parameter()]
        [System.Object]
        $FromScope,

        [Parameter()]
        [System.Object[]]
        $AttachmentNameMatchesPatterns,

        [Parameter()]
        [System.Object[]]
        $SentTo,

        [Parameter()]
        [System.Object[]]
        $ExceptIfFromAddressMatchesPatterns,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.Object]
        $ExceptIfAttachmentSizeOver,

        [Parameter()]
        [System.Object]
        $ExceptIfManagerForEvaluatedUser,

        [Parameter()]
        [System.Boolean]
        $RemoveOMEv2,

        [Parameter()]
        [System.Object[]]
        $ExceptIfFromAddressContainsWords,

        [Parameter()]
        [System.Boolean]
        $AttachmentHasExecutableContent,

        [Parameter()]
        [System.Object]
        $RouteMessageOutboundConnector,

        [Parameter()]
        [System.Object[]]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSenderDomainIs,

        [Parameter()]
        [System.Object]
        $SenderManagementRelationship,

        [Parameter()]
        [System.Object[]]
        $ExceptIfBetweenMemberOf2,

        [Parameter()]
        [System.Object[]]
        $RedirectMessageTo,

        [Parameter()]
        [System.Boolean]
        $ApplyOME,

        [Parameter()]
        [System.Object[]]
        $SenderDomainIs,

        [Parameter()]
        [System.Object[]]
        $SenderADAttributeContainsWords,

        [Parameter()]
        [System.Object[]]
        $ExceptIfAnyOfCcHeaderMemberOf,

        [Parameter()]
        [System.Object]
        $ApplyHtmlDisclaimerText,

        [Parameter()]
        [System.Boolean]
        $ExceptIfAttachmentHasExecutableContent,

        [Parameter()]
        [System.Boolean]
        $ExceptIfAttachmentIsUnsupported,

        [Parameter()]
        [System.Boolean]
        $RemoveOME,

        [Parameter()]
        [System.Object]
        $RejectMessageReasonText,

        [Parameter()]
        [System.Object[]]
        $RecipientAddressContainsWords,

        [Parameter()]
        [System.Object]
        $GenerateIncidentReport,

        [Parameter()]
        [System.Object[]]
        $FromAddressContainsWords,

        [Parameter()]
        [System.Boolean]
        $RemoveRMSAttachmentEncryption,

        [Parameter()]
        [System.Object[]]
        $RecipientAddressMatchesPatterns,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSubjectContainsWords,

        [Parameter()]
        [System.Object[]]
        $ExceptIfFrom,

        [Parameter()]
        [System.Object[]]
        $AnyOfToCcHeader,

        [Parameter()]
        [System.Object]
        $ExceptIfSentToScope,

        [Parameter()]
        [System.Object[]]
        $ExceptIfAnyOfToCcHeaderMemberOf,

        [Parameter()]
        [System.Boolean]
        $ModerateMessageByManager,

        [Parameter()]
        [System.Object]
        $AdComparisonOperator,

        [Parameter()]
        [System.Object]
        $MessageSizeOver,

        [Parameter()]
        [System.Object[]]
        $BetweenMemberOf2,

        [Parameter()]
        [System.Object[]]
        $SubjectMatchesPatterns,

        [Parameter()]
        [System.Boolean]
        $AttachmentProcessingLimitExceeded,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSubjectMatchesPatterns,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object[]]
        $ExceptIfRecipientAddressContainsWords,

        [Parameter()]
        [System.Object]
        $HeaderMatchesMessageHeader,

        [Parameter()]
        [System.Object[]]
        $AnyOfRecipientAddressContainsWords,

        [Parameter()]
        [System.Object[]]
        $HeaderContainsWords,

        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.Object[]]
        $SentToMemberOf,

        [Parameter()]
        [System.Object]
        $ExceptIfAdComparisonAttribute,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSentTo,

        [Parameter()]
        [System.Object]
        $ExceptIfAdComparisonOperator,

        [Parameter()]
        [System.Object[]]
        $ExceptIfAnyOfToHeaderMemberOf,

        [Parameter()]
        [System.Object]
        $Mode,

        [Parameter()]
        [System.Object[]]
        $RecipientInSenderList,

        [Parameter()]
        [System.Object[]]
        $SubjectOrBodyMatchesPatterns,

        [Parameter()]
        [System.Object[]]
        $ExceptIfAttachmentExtensionMatchesWords,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSubjectOrBodyMatchesPatterns,

        [Parameter()]
        [System.Object[]]
        $ExceptIfRecipientAddressMatchesPatterns,

        [Parameter()]
        [System.Boolean]
        $ExceptIfHasNoClassification,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderIpRanges,

        [Parameter()]
        [System.Object[]]
        $ExceptIfRecipientADAttributeMatchesPatterns,

        [Parameter()]
        [System.Boolean]
        $StopRuleProcessing,

        [Parameter()]
        [System.Object[]]
        $RecipientADAttributeContainsWords,

        [Parameter()]
        [System.Boolean]
        $AttachmentIsUnsupported,

        [Parameter()]
        [System.Object]
        $ExpiryDate,

        [Parameter()]
        [System.Object[]]
        $AttachmentExtensionMatchesWords,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSubjectOrBodyContainsWords,

        [Parameter()]
        [System.Object]
        $LogEventText,

        [Parameter()]
        [System.Object[]]
        $ExceptIfManagerAddresses,

        [Parameter()]
        [System.Object[]]
        $SenderInRecipientList,

        [Parameter()]
        [System.Object[]]
        $ExceptIfAnyOfToCcHeader,

        [Parameter()]
        [System.Object[]]
        $AttachmentMatchesPatterns,

        [Parameter()]
        [System.String]
        $DlpPolicy,

        [Parameter()]
        [System.Object[]]
        $ManagerAddresses,

        [Parameter()]
        [System.Object]
        $SenderAddressLocation,

        [Parameter()]
        [System.Object[]]
        $CopyTo,

        [Parameter()]
        [System.Object[]]
        $SubjectOrBodyContainsWords,

        [Parameter()]
        [System.String]
        $ApplyClassification,

        [Parameter()]
        [System.Object[]]
        $RecipientADAttributeMatchesPatterns,

        [Parameter()]
        [System.Object]
        $SetHeaderValue,

        [Parameter()]
        [System.Boolean]
        $AttachmentIsPasswordProtected,

        [Parameter()]
        [System.Object[]]
        $BetweenMemberOf1,

        [Parameter()]
        [System.Object]
        $ExceptIfMessageSizeOver,

        [Parameter()]
        [System.Object[]]
        $AnyOfCcHeader,

        [Parameter()]
        [System.Boolean]
        $ExceptIfAttachmentProcessingLimitExceeded,

        [Parameter()]
        [System.Object[]]
        $FromAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfHeaderMatchesMessageHeader,

        [Parameter()]
        [System.Object]
        $SmtpRejectMessageRejectText,

        [Parameter()]
        [System.Object[]]
        $AnyOfCcHeaderMemberOf,

        [Parameter()]
        [System.Object[]]
        $AnyOfToHeader,

        [Parameter()]
        [System.Boolean]
        $ExceptIfHasSenderOverride,

        [Parameter()]
        [System.Object]
        $SCLOver,

        [Parameter()]
        [System.Object]
        $PrependSubject,

        [Parameter()]
        [System.Object]
        $ApplyRightsProtectionTemplate,

        [Parameter()]
        [System.Object]
        $MessageTypeMatches,

        [Parameter()]
        [System.Object[]]
        $ExceptIfAttachmentPropertyContainsWords,

        [Parameter()]
        [System.Object[]]
        $AnyOfRecipientAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfHeaderContainsMessageHeader
    )
}
function Remove-ActiveSyncDevice
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-ActiveSyncDeviceAccessRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-AntiPhishPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-AntiPhishRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-App
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Mailbox,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $OrganizationApp,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PrivateCatalog
    )
}
function Remove-ApplicationAccessPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-AuditConfigurationPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm
    )
}
function Remove-AuthenticationPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-AvailabilityAddressSpace
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-AvailabilityConfig
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-ClientAccessRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-DataClassification
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-DistributionGroup
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $BypassSecurityGroupManagerCheck
    )
}
function Remove-EmailAddressPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-HostedConnectionFilterPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-HostedContentFilterPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-HostedContentFilterRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-HostedOutboundSpamFilterRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-InboundConnector
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-IntraOrganizationConnector
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-JournalRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-Mailbox
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PublicFolder,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PermanentlyDelete,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RemoveCNFPublicFolderMailboxPermanently,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Migration
    )
}
function Remove-MailContact
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-MalwareFilterPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-MalwareFilterRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-ManagementRole
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Recurse
    )
}
function Remove-ManagementRoleAssignment
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-MessageClassification
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-MobileDevice
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-MobileDeviceMailboxPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-OMEConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-OnPremisesOrganization
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-OrganizationRelationship
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-OutboundConnector
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-OwaMailboxPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-PartnerApplication
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-PolicyTipConfig
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-QuarantinePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $DomainController
    )
}
function Remove-RemoteDomain
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-RoleAssignmentPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-SafeAttachmentPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-SafeAttachmentRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-SafeLinksPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-SafeLinksRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-SharingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Remove-TransportRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Set-AcceptedDomain
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $CanHaveCloudCache,

        [Parameter()]
        [System.Boolean]
        $EnableNego2Authentication,

        [Parameter()]
        [System.Boolean]
        $OutboundOnly,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $MatchSubDomains,

        [Parameter()]
        [System.Object]
        $DomainType
    )
}
function Set-ActiveSyncDeviceAccessRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $AccessLevel
    )
}
function Set-AdminAuditLogConfig
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Boolean]
        $UnifiedAuditLogIngestionEnabled
    )
}
function Set-AntiPhishPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $EnableFirstContactSafetyTips,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $MakeDefault,

        [Parameter()]
        [System.Int32]
        $PhishThresholdLevel,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Boolean]
        $EnableTargetedDomainsProtection,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.Boolean]
        $EnableViaTag,

        [Parameter()]
        [System.Object]
        $MailboxIntelligenceProtectionAction,

        [Parameter()]
        [System.Object]
        $TargetedDomainsToProtect,

        [Parameter()]
        [System.Boolean]
        $EnableSpoofIntelligence,

        [Parameter()]
        [System.Boolean]
        $EnableSimilarUsersSafetyTips,

        [Parameter()]
        [System.Object]
        $ExcludedDomains,

        [Parameter()]
        [System.String]
        $PolicyTag,

        [Parameter()]
        [System.Object]
        $TargetedDomainActionRecipients,

        [Parameter()]
        [System.Boolean]
        $EnableMailboxIntelligence,

        [Parameter()]
        [System.String]
        $TargetedDomainQuarantineTag,

        [Parameter()]
        [System.Boolean]
        $EnableSimilarDomainsSafetyTips,

        [Parameter()]
        [System.Object]
        $ImpersonationProtectionState,

        [Parameter()]
        [System.Object]
        $TargetedDomainProtectionAction,

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [System.Object]
        $TargetedUserProtectionAction,

        [Parameter()]
        [System.Object]
        $MailboxIntelligenceProtectionActionRecipients,

        [Parameter()]
        [System.String]
        $MailboxIntelligenceQuarantineTag,

        [Parameter()]
        [System.Object]
        $TargetedUsersToProtect,

        [Parameter()]
        [System.String]
        $SpoofQuarantineTag,

        [Parameter()]
        [System.Boolean]
        $EnableUnauthenticatedSender,

        [Parameter()]
        [System.String]
        $TargetedUserQuarantineTag,

        [Parameter()]
        [System.Boolean]
        $EnableOrganizationDomainsProtection,

        [Parameter()]
        [System.Boolean]
        $EnableMailboxIntelligenceProtection,

        [Parameter()]
        [System.Boolean]
        $EnableUnusualCharactersSafetyTips,

        [Parameter()]
        [System.Boolean]
        $EnableTargetedUserProtection,

        [Parameter()]
        [System.Object]
        $AuthenticationFailAction,

        [Parameter()]
        [System.Object]
        $TargetedUserActionRecipients,

        [Parameter()]
        [System.Object]
        $ExcludedSenders
    )
}
function Set-AntiPhishRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Int32]
        $Priority,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object[]]
        $SentToMemberOf,

        [Parameter()]
        [System.Object]
        $AntiPhishPolicy,

        [Parameter()]
        [System.Object[]]
        $SentTo,

        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.Object[]]
        $RecipientDomainIs,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object[]]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSentTo,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSentToMemberOf
    )
}
function Set-App
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $UserList,

        [Parameter()]
        [System.Object]
        $DefaultStateForUser,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $OrganizationApp,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PrivateCatalog,

        [Parameter()]
        [System.Object]
        $ProvidedTo
    )
}
function Set-ApplicationAccessPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Set-AtpPolicyForO365
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $AllowSafeDocsOpen,

        [Parameter()]
        [System.Object]
        $BlockUrls,

        [Parameter()]
        [System.Boolean]
        $EnableATPForSPOTeamsODB,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $EnableSafeDocs,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm
    )
}
function Set-AuthenticationPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowBasicAuthPop,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowBasicAuthSmtp,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowBasicAuthMapi,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowBasicAuthImap,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowBasicAuthAutodiscover,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowBasicAuthPowershell,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowBasicAuthRpc,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowBasicAuthOfflineAddressBook,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowBasicAuthReportingWebServices,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowBasicAuthOutlookService,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowBasicAuthActiveSync,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowBasicAuthWebServices
    )
}
function Set-AvailabilityConfig
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $OrgWideAccount
    )
}
function Set-CASMailbox
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $IsOptimizedForAccessibility,

        [Parameter()]
        [System.Boolean]
        $ImapEnabled,

        [Parameter()]
        [System.Boolean]
        $ImapSuppressReadReceipt,

        [Parameter()]
        [System.Boolean]
        $ActiveSyncSuppressReadReceipt,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $EwsBlockList,

        [Parameter()]
        [System.Object]
        $EwsAllowEntourage,

        [Parameter()]
        [System.Object]
        $OwaMailboxPolicy,

        [Parameter()]
        [System.Boolean]
        $PopUseProtocolDefaults,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $SmtpClientAuthenticationDisabled,

        [Parameter()]
        [System.Boolean]
        $PopForceICalForCalendarRetrievalOption,

        [Parameter()]
        [System.Boolean]
        $ImapForceICalForCalendarRetrievalOption,

        [Parameter()]
        [System.Boolean]
        $ShowGalAsDefaultView,

        [Parameter()]
        [System.Object]
        $ActiveSyncBlockedDeviceIDs,

        [Parameter()]
        [System.Boolean]
        $MAPIEnabled,

        [Parameter()]
        [System.Object]
        $EwsAllowOutlook,

        [Parameter()]
        [System.Boolean]
        $PopEnabled,

        [Parameter()]
        [System.Object]
        $ActiveSyncAllowedDeviceIDs,

        [Parameter()]
        [System.Object]
        $EwsEnabled,

        [Parameter()]
        [System.Object]
        $OutlookMobileEnabled,

        [Parameter()]
        [System.Object]
        $EwsAllowMacOutlook,

        [Parameter()]
        [System.Object]
        $EwsApplicationAccessPolicy,

        [Parameter()]
        [System.Object]
        $OneWinNativeOutlookEnabled,

        [Parameter()]
        [System.Boolean]
        $OWAEnabled,

        [Parameter()]
        [System.Boolean]
        $PublicFolderClientAccess,

        [Parameter()]
        [System.Object]
        $ActiveSyncMailboxPolicy,

        [Parameter()]
        [System.Object]
        $UniversalOutlookEnabled,

        [Parameter()]
        [System.Boolean]
        $ImapUseProtocolDefaults,

        [Parameter()]
        [System.Boolean]
        $ActiveSyncDebugLogging,

        [Parameter()]
        [System.Boolean]
        $OWAforDevicesEnabled,

        [Parameter()]
        [System.Object]
        $ImapMessagesRetrievalMimeFormat,

        [Parameter()]
        [System.Boolean]
        $ActiveSyncEnabled,

        [Parameter()]
        [System.Object]
        $MacOutlookEnabled,

        [Parameter()]
        [System.Boolean]
        $PopSuppressReadReceipt,

        [Parameter()]
        [System.Object]
        $EwsAllowList,

        [Parameter()]
        [System.Object]
        $PopMessagesRetrievalMimeFormat
    )
}
function set-CASMailboxPlan
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $ImapEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $OwaMailboxPolicy,

        [Parameter()]
        [System.Boolean]
        $PopEnabled,

        [Parameter()]
        [System.Boolean]
        $ActiveSyncEnabled
    )
}
function Set-ClientAccessRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $UsernameMatchesAnyOfPatterns,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Action,

        [Parameter()]
        [System.Object]
        $AnyOfClientIPAddressesOrRanges,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.Object]
        $ExceptAnyOfClientIPAddressesOrRanges,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $UserRecipientFilter,

        [Parameter()]
        [System.Object]
        $ExceptAnyOfProtocols,

        [Parameter()]
        [System.Int32]
        $Priority,

        [Parameter()]
        [System.Object]
        $ExceptUsernameMatchesAnyOfPatterns,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $AnyOfAuthenticationTypes,

        [Parameter()]
        [System.Object]
        $AnyOfProtocols,

        [Parameter()]
        [System.Object]
        $ExceptAnyOfAuthenticationTypes,

        [Parameter()]
        [System.Object]
        $Scope
    )
}
function Set-DataClassification
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Globalization.CultureInfo]
        $Locale,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsDefault,

        [Parameter()]
        [System.Object]
        $Fingerprints,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Set-DataEncryptionPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object]
        $DomainController,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PermanentDataPurgeRequested,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.String]
        $PermanentDataPurgeReason,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String]
        $PermanentDataPurgeContact,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Refresh
    )
}
function Set-DistributionGroup
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $EmailAddresses,

        [Parameter()]
        [System.Object]
        $RejectMessagesFromDLMembers,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RoomList,

        [Parameter()]
        [System.Object]
        $AcceptMessagesOnlyFromSendersOrMembers,

        [Parameter()]
        [System.String]
        $CustomAttribute10,

        [Parameter()]
        [System.Object]
        $ExtensionCustomAttribute5,

        [Parameter()]
        [System.String]
        $CustomAttribute8,

        [Parameter()]
        [System.String]
        $CustomAttribute5,

        [Parameter()]
        [System.Boolean]
        $BccBlocked,

        [Parameter()]
        [System.Object]
        $AcceptMessagesOnlyFromDLMembers,

        [Parameter()]
        [System.String]
        $SimpleDisplayName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IgnoreNamingPolicy,

        [Parameter()]
        [System.Boolean]
        $ReportToManagerEnabled,

        [Parameter()]
        [System.String]
        $MailTip,

        [Parameter()]
        [System.Object]
        $ModeratedBy,

        [Parameter()]
        [System.Object]
        $GrantSendOnBehalfTo,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ResetMigrationToUnifiedGroup,

        [Parameter()]
        [System.Object]
        $AcceptMessagesOnlyFrom,

        [Parameter()]
        [System.Boolean]
        $BypassNestedModerationEnabled,

        [Parameter()]
        [System.Boolean]
        $ModerationEnabled,

        [Parameter()]
        [System.Object]
        $MemberDepartRestriction,

        [Parameter()]
        [System.Object]
        $ExtensionCustomAttribute4,

        [Parameter()]
        [System.String]
        $CustomAttribute15,

        [Parameter()]
        [System.Object]
        $RejectMessagesFromSendersOrMembers,

        [Parameter()]
        [System.Object]
        $WindowsEmailAddress,

        [Parameter()]
        [System.String]
        $Alias,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $ReportToOriginatorEnabled,

        [Parameter()]
        [System.Object]
        $BypassModerationFromSendersOrMembers,

        [Parameter()]
        [System.Object]
        $RejectMessagesFrom,

        [Parameter()]
        [System.String]
        $CustomAttribute1,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ForceUpgrade,

        [Parameter()]
        [System.Object]
        $ManagedBy,

        [Parameter()]
        [System.Object]
        $Description,

        [Parameter()]
        [System.Object]
        $ExtensionCustomAttribute1,

        [Parameter()]
        [System.String]
        $CustomAttribute14,

        [Parameter()]
        [System.Boolean]
        $RequireSenderAuthenticationEnabled,

        [Parameter()]
        [System.String]
        $CustomAttribute9,

        [Parameter()]
        [System.String]
        $CustomAttribute6,

        [Parameter()]
        [System.Boolean]
        $SendOofMessageToOriginatorEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $BypassSecurityGroupManagerCheck,

        [Parameter()]
        [System.Object]
        $ExtensionCustomAttribute2,

        [Parameter()]
        [System.String]
        $CustomAttribute13,

        [Parameter()]
        [System.String]
        $CustomAttribute2,

        [Parameter()]
        [System.Object]
        $PrimarySmtpAddress,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $SendModerationNotifications,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $HiddenGroupMembershipEnabled,

        [Parameter()]
        [System.Object]
        $MemberJoinRestriction,

        [Parameter()]
        [System.Boolean]
        $HiddenFromAddressListsEnabled,

        [Parameter()]
        [System.Object]
        $MailTipTranslations,

        [Parameter()]
        [System.String]
        $CustomAttribute7,

        [Parameter()]
        [System.String]
        $CustomAttribute4,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object]
        $ExtensionCustomAttribute3,

        [Parameter()]
        [System.String]
        $CustomAttribute12,

        [Parameter()]
        [System.String]
        $CustomAttribute3,

        [Parameter()]
        [System.String]
        $CustomAttribute11,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Set-DkimSigningConfig
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [System.Object]
        $BodyCanonicalization,

        [Parameter()]
        [System.Object]
        $HeaderCanonicalization,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PublishTxtRecords,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $Enabled
    )
}
function Set-EmailAddressPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Priority,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object]
        $EnabledEmailAddressTemplates,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ForceUpgrade,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $EnabledPrimarySMTPAddressTemplate,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Set-HostedConnectionFilterPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $ConfigurationXmlRaw,

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [System.Boolean]
        $EnableSafeList,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $IPBlockList,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $IPAllowList,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $MakeDefault
    )
}
function Set-HostedContentFilterPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Boolean]
        $InlineSafetyTipsEnabled,

        [Parameter()]
        [System.Object]
        $BulkSpamAction,

        [Parameter()]
        [System.String]
        $HighConfidencePhishQuarantineTag,

        [Parameter()]
        [System.Int32]
        $EndUserSpamNotificationFrequency,

        [Parameter()]
        [System.Int32]
        $EndUserSpamNotificationLimit,

        [Parameter()]
        [System.Int32]
        $BulkThreshold,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $MakeDefault,

        [Parameter()]
        [System.Object]
        $TestModeBccToRecipients,

        [Parameter()]
        [System.String]
        $PhishQuarantineTag,

        [Parameter()]
        [System.String]
        $AddXHeaderValue,

        [Parameter()]
        [System.Object]
        $MarkAsSpamEmbedTagsInHtml,

        [Parameter()]
        [System.Object]
        $MarkAsSpamFramesInHtml,

        [Parameter()]
        [System.Object]
        $IncreaseScoreWithImageLinks,

        [Parameter()]
        [System.Boolean]
        $EnableLanguageBlockList,

        [Parameter()]
        [System.Object]
        $PhishSpamAction,

        [Parameter()]
        [System.String]
        $EndUserSpamNotificationCustomFromName,

        [Parameter()]
        [System.Object]
        $MarkAsSpamSensitiveWordList,

        [Parameter()]
        [System.String]
        $SpamQuarantineTag,

        [Parameter()]
        [System.Object]
        $MarkAsSpamNdrBackscatter,

        [Parameter()]
        [System.Object]
        $BlockedSenders,

        [Parameter()]
        [System.Object]
        $LanguageBlockList,

        [Parameter()]
        [System.Object]
        $HighConfidenceSpamAction,

        [Parameter()]
        [System.Object]
        $AllowedSenderDomains,

        [Parameter()]
        [System.Boolean]
        $PhishZapEnabled,

        [Parameter()]
        [System.Object]
        $IncreaseScoreWithBizOrInfoUrls,

        [Parameter()]
        [System.Object]
        $MarkAsSpamWebBugsInHtml,

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [System.Object]
        $RegionBlockList,

        [Parameter()]
        [System.Object]
        $MarkAsSpamFromAddressAuthFail,

        [Parameter()]
        [System.Object]
        $MarkAsSpamEmptyMessages,

        [Parameter()]
        [System.String]
        $BulkQuarantineTag,

        [Parameter()]
        [System.Object]
        $MarkAsSpamFormTagsInHtml,

        [Parameter()]
        [System.Object]
        $MarkAsSpamObjectTagsInHtml,

        [Parameter()]
        [System.Object]
        $EndUserSpamNotificationLanguage,

        [Parameter()]
        [System.Object]
        $IncreaseScoreWithRedirectToOtherPort,

        [Parameter()]
        [System.Int32]
        $QuarantineRetentionPeriod,

        [Parameter()]
        [System.Object]
        $HighConfidencePhishAction,

        [Parameter()]
        [System.Object]
        $RedirectToRecipients,

        [Parameter()]
        [System.Boolean]
        $SpamZapEnabled,

        [Parameter()]
        [System.Object]
        $TestModeAction,

        [Parameter()]
        [System.Boolean]
        $EnableRegionBlockList,

        [Parameter()]
        [System.String]
        $EndUserSpamNotificationCustomSubject,

        [Parameter()]
        [System.Object]
        $MarkAsSpamSpfRecordHardFail,

        [Parameter()]
        [System.Object]
        $EndUserSpamNotificationCustomFromAddress,

        [Parameter()]
        [System.Boolean]
        $DownloadLink,

        [Parameter()]
        [System.Object]
        $SpamAction,

        [Parameter()]
        [System.String]
        $ModifySubjectValue,

        [Parameter()]
        [System.Object]
        $IncreaseScoreWithNumericIps,

        [Parameter()]
        [System.Object]
        $AllowedSenders,

        [Parameter()]
        [System.Object]
        $MarkAsSpamJavaScriptInHtml,

        [Parameter()]
        [System.Object]
        $MarkAsSpamBulkMail,

        [Parameter()]
        [System.Object]
        $BlockedSenderDomains,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $EnableEndUserSpamNotifications,

        [Parameter()]
        [System.String]
        $HighConfidenceSpamQuarantineTag
    )
}
function Set-HostedContentFilterRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Int32]
        $Priority,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object[]]
        $SentToMemberOf,

        [Parameter()]
        [System.Object]
        $HostedContentFilterPolicy,

        [Parameter()]
        [System.Object[]]
        $SentTo,

        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.Object[]]
        $RecipientDomainIs,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object[]]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSentTo,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSentToMemberOf
    )
}
function Set-HostedOutboundSpamFilterPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [System.Object]
        $BccSuspiciousOutboundAdditionalRecipients,

        [Parameter()]
        [System.Object]
        $NotifyOutboundSpamRecipients,

        [Parameter()]
        [System.UInt32]
        $RecipientLimitPerDay,

        [Parameter()]
        [System.Object]
        $ActionWhenThresholdReached,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.UInt32]
        $RecipientLimitExternalPerHour,

        [Parameter()]
        [System.Object]
        $AutoForwardingMode,

        [Parameter()]
        [System.Boolean]
        $NotifyOutboundSpam,

        [Parameter()]
        [System.UInt32]
        $RecipientLimitInternalPerHour,

        [Parameter()]
        [System.Boolean]
        $BccSuspiciousOutboundMail
    )
}
function Set-HostedOutboundSpamFilterRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Int32]
        $Priority,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object[]]
        $ExceptIfFromMemberOf,

        [Parameter()]
        [System.Object[]]
        $ExceptIfFrom,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSenderDomainIs,

        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.Object[]]
        $FromMemberOf,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object[]]
        $SenderDomainIs,

        [Parameter()]
        [System.Object]
        $HostedOutboundSpamFilterPolicy,

        [Parameter()]
        [System.Object[]]
        $From,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm
    )
}
function Set-InboundConnector
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $RestrictDomainsToIPAddresses,

        [Parameter()]
        [System.Boolean]
        $CloudServicesMailEnabled,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object]
        $EFSkipMailGateway,

        [Parameter()]
        [System.Boolean]
        $EFTestMode,

        [Parameter()]
        [System.Object]
        $TrustedOrganizations,

        [Parameter()]
        [System.Object]
        $TlsSenderCertificateName,

        [Parameter()]
        [System.Object]
        $ScanAndDropRecipients,

        [Parameter()]
        [System.Object]
        $AssociatedAcceptedDomains,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [System.Boolean]
        $RequireTls,

        [Parameter()]
        [System.Object]
        $SenderDomains,

        [Parameter()]
        [System.Object]
        $SenderIPAddresses,

        [Parameter()]
        [System.Boolean]
        $EFSkipLastIP,

        [Parameter()]
        [System.Object]
        $EFUsers,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $ConnectorType,

        [Parameter()]
        [System.Boolean]
        $RestrictDomainsToCertificate,

        [Parameter()]
        [System.Object]
        $EFSkipIPs,

        [Parameter()]
        [System.Boolean]
        $TreatMessagesAsInternal,

        [Parameter()]
        [System.Object]
        $ConnectorSource
    )
}
function Set-IntraOrganizationConnector
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $TargetAddressDomains,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Uri]
        $DiscoveryEndpoint,

        [Parameter()]
        [System.Uri]
        $TargetSharingEpr,

        [Parameter()]
        [System.Boolean]
        $Enabled
    )
}
function Set-IRMConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $TransportDecryptionSetting,

        [Parameter()]
        [System.Uri]
        $RMSOnlineKeySharingLocation,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Boolean]
        $AzureRMSLicensingEnabled,

        [Parameter()]
        [System.Boolean]
        $EnablePortalTrackingLogs,

        [Parameter()]
        [System.Boolean]
        $DecryptAttachmentForEncryptOnly,

        [Parameter()]
        [System.Boolean]
        $RejectIfRecipientHasNoRights,

        [Parameter()]
        [System.Boolean]
        $SimplifiedClientAccessEncryptOnlyDisabled,

        [Parameter()]
        [System.Boolean]
        $InternalLicensingEnabled,

        [Parameter()]
        [System.Boolean]
        $EDiscoverySuperUserEnabled,

        [Parameter()]
        [System.Boolean]
        $JournalReportDecryptionEnabled,

        [Parameter()]
        [System.Boolean]
        $EnablePdfEncryption,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Boolean]
        $AutomaticServiceUpdateEnabled,

        [Parameter()]
        [System.Boolean]
        $SimplifiedClientAccessDoNotForwardDisabled,

        [Parameter()]
        [System.Boolean]
        $SearchEnabled,

        [Parameter()]
        [System.Object]
        $LicensingLocation,

        [Parameter()]
        [System.Boolean]
        $SimplifiedClientAccessEnabled
    )
}
function Set-JournalRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object]
        $Scope,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $JournalEmailAddress,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Recipient
    )
}
function Set-Mailbox
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $EmailAddresses,

        [Parameter()]
        [System.Object]
        $RejectMessagesFromDLMembers,

        [Parameter()]
        [System.Object]
        $ResourceCapacity,

        [Parameter()]
        [System.Object]
        $AcceptMessagesOnlyFromSendersOrMembers,

        [Parameter()]
        [System.Object]
        $Type,

        [Parameter()]
        [System.Object]
        $UserCertificate,

        [Parameter()]
        [System.String]
        $CustomAttribute10,

        [Parameter()]
        [System.Boolean]
        $DeliverToMailboxAndForward,

        [Parameter()]
        [System.String]
        $RetentionUrl,

        [Parameter()]
        [System.Object]
        $ExtensionCustomAttribute5,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RecalculateInactiveMailbox,

        [Parameter()]
        [System.String]
        $CustomAttribute8,

        [Parameter()]
        [System.Boolean]
        $PitrEnabled,

        [Parameter()]
        [System.Object]
        $ProhibitSendReceiveQuota,

        [Parameter()]
        [System.String]
        $CustomAttribute5,

        [Parameter()]
        [System.Security.SecureString]
        $RoomMailboxPassword,

        [Parameter()]
        [System.Object]
        $UseDatabaseQuotaDefaults,

        [Parameter()]
        [System.Boolean]
        $ElcProcessingDisabled,

        [Parameter()]
        [System.String[]]
        $ExcludeFromOrgHolds,

        [Parameter()]
        [System.String]
        $MailboxRegion,

        [Parameter()]
        [System.String]
        $MailTip,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $GroupMailbox,

        [Parameter()]
        [System.Object]
        $ModeratedBy,

        [Parameter()]
        [System.String]
        $LitigationHoldOwner,

        [Parameter()]
        [System.Object]
        $GrantSendOnBehalfTo,

        [Parameter()]
        [System.Object]
        $UserSMimeCertificate,

        [Parameter()]
        [System.Object]
        $AuditLogAgeLimit,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RemoveDisabledArchive,

        [Parameter()]
        [System.Object]
        $Languages,

        [Parameter()]
        [System.Object]
        $JournalArchiveAddress,

        [Parameter()]
        [System.Object]
        $LitigationHoldDuration,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProvisionedForOfficeGraph,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $InactiveMailbox,

        [Parameter()]
        [System.String]
        $RetentionComment,

        [Parameter()]
        [System.Object]
        $MaxReceiveSize,

        [Parameter()]
        [System.Boolean]
        $MessageCopyForSendOnBehalfEnabled,

        [Parameter()]
        [System.String]
        $CustomAttribute15,

        [Parameter()]
        [System.Boolean]
        $LitigationHoldEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $UpdateEnforcedTimestamp,

        [Parameter()]
        [System.String]
        $ImmutableId,

        [Parameter()]
        [System.Object]
        $WindowsEmailAddress,

        [Parameter()]
        [System.Boolean]
        $UseDatabaseRetentionDefaults,

        [Parameter()]
        [System.Boolean]
        $SchedulerAssistant,

        [Parameter()]
        [System.String[]]
        $RemoveOrphanedHolds,

        [Parameter()]
        [System.Object]
        $RulesQuota,

        [Parameter()]
        [System.String]
        $Alias,

        [Parameter()]
        [System.String]
        $EnforcedTimestamps,

        [Parameter()]
        [System.Object]
        $RejectMessagesFromSendersOrMembers,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Object]
        $ResourceCustom,

        [Parameter()]
        [System.Boolean]
        $MessageCopyForSMTPClientSubmissionEnabled,

        [Parameter()]
        [System.Object]
        $BypassModerationFromSendersOrMembers,

        [Parameter()]
        [System.Object]
        $DefaultAuditSet,

        [Parameter()]
        [System.Object]
        $AcceptMessagesOnlyFromDLMembers,

        [Parameter()]
        [System.String]
        $CustomAttribute1,

        [Parameter()]
        [System.Int16]
        $PitrCopyIntervalInSeconds,

        [Parameter()]
        [System.Boolean]
        $CalendarRepairDisabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RemoveMailboxProvisioningConstraint,

        [Parameter()]
        [System.Object]
        $NonCompliantDevices,

        [Parameter()]
        [System.Boolean]
        $ModerationEnabled,

        [Parameter()]
        [System.Object]
        $AuditOwner,

        [Parameter()]
        [System.Object]
        $RejectMessagesFrom,

        [Parameter()]
        [System.Object]
        $ProhibitSendQuota,

        [Parameter()]
        [System.Boolean]
        $AccountDisabled,

        [Parameter()]
        [System.Object]
        $AcceptMessagesOnlyFrom,

        [Parameter()]
        [System.Object]
        $AuditDelegate,

        [Parameter()]
        [System.String]
        $CustomAttribute14,

        [Parameter()]
        [System.Boolean]
        $SingleItemRecoveryEnabled,

        [Parameter()]
        [System.Boolean]
        $RequireSenderAuthenticationEnabled,

        [Parameter()]
        [System.String]
        $CustomAttribute9,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.String]
        $CustomAttribute6,

        [Parameter()]
        [System.Object]
        $DataEncryptionPolicy,

        [Parameter()]
        [System.Object]
        $ExtensionCustomAttribute4,

        [Parameter()]
        [System.Object]
        $LitigationHoldDate,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Boolean]
        $EnableRoomMailboxAccount,

        [Parameter()]
        [System.Object]
        $RetainDeletedItemsFor,

        [Parameter()]
        [System.Object]
        $MicrosoftOnlineServicesID,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RemoveDelayReleaseHoldApplied,

        [Parameter()]
        [System.Object]
        $AuditAdmin,

        [Parameter()]
        [System.Object]
        $ExtensionCustomAttribute2,

        [Parameter()]
        [System.Object]
        $DefaultPublicFolderMailbox,

        [Parameter()]
        [System.Boolean]
        $RetentionHoldEnabled,

        [Parameter()]
        [System.String]
        $CustomAttribute13,

        [Parameter()]
        [System.Object]
        $RetentionPolicy,

        [Parameter()]
        [System.String]
        $CustomAttribute2,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RemoveDelayHoldApplied,

        [Parameter()]
        [System.Object]
        $ExternalOofOptions,

        [Parameter()]
        [System.Object]
        $IssueWarningQuota,

        [Parameter()]
        [System.Object]
        $StartDateForRetentionHold,

        [Parameter()]
        [System.Object]
        $SendModerationNotifications,

        [Parameter()]
        [System.Object]
        $EndDateForRetentionHold,

        [Parameter()]
        [System.Object]
        $RoleAssignmentPolicy,

        [Parameter()]
        [System.Boolean]
        $IsExcludedFromServingHierarchy,

        [Parameter()]
        [System.String]
        $Office,

        [Parameter()]
        [System.Object]
        $MaxSendSize,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ApplyMandatoryProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ExcludeFromAllOrgHolds,

        [Parameter()]
        [System.Object]
        $RecipientLimits,

        [Parameter()]
        [System.Object]
        $AddressBookPolicy,

        [Parameter()]
        [System.Boolean]
        $MessageCopyForSentAsEnabled,

        [Parameter()]
        [System.Boolean]
        $HiddenFromAddressListsEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PublicFolder,

        [Parameter()]
        [System.Object]
        $MailTipTranslations,

        [Parameter()]
        [System.String]
        $CustomAttribute7,

        [Parameter()]
        [System.Object]
        $SharingPolicy,

        [Parameter()]
        [System.String]
        $CustomAttribute4,

        [Parameter()]
        [System.Object]
        $ExtensionCustomAttribute1,

        [Parameter()]
        [System.Boolean]
        $CalendarVersionStoreDisabled,

        [Parameter()]
        [System.String]
        $SecondaryAddress,

        [Parameter()]
        [System.Object]
        $ArchiveName,

        [Parameter()]
        [System.Boolean]
        $AuditEnabled,

        [Parameter()]
        [System.Security.SecureString]
        $Password,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $StsRefreshTokensValidFrom,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object]
        $ExtensionCustomAttribute3,

        [Parameter()]
        [System.Object]
        $ForwardingAddress,

        [Parameter()]
        [System.String]
        $CustomAttribute12,

        [Parameter()]
        [System.String]
        $CustomAttribute3,

        [Parameter()]
        [System.String]
        $CustomAttribute11,

        [Parameter()]
        [System.String]
        $SimpleDisplayName,

        [Parameter()]
        [System.Object]
        $ForwardingSmtpAddress,

        [Parameter()]
        [System.Boolean]
        $MessageTrackingReadStatusEnabled
    )
}
function Set-MailboxPlan
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $IssueWarningQuota,

        [Parameter()]
        [System.Object]
        $RoleAssignmentPolicy,

        [Parameter()]
        [System.Object]
        $RetentionPolicy,

        [Parameter()]
        [System.Object]
        $MaxSendSize,

        [Parameter()]
        [System.Object]
        $ProhibitSendReceiveQuota,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $ProhibitSendQuota,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsDefault,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $RetainDeletedItemsFor,

        [Parameter()]
        [System.Object]
        $RecipientLimits,

        [Parameter()]
        [System.Object]
        $MaxReceiveSize,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )
}
function Set-MailboxRegionalConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $DateFormat,

        [Parameter()]
        [System.String]
        $TimeFormat,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $UseCustomRouting,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Archive,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $LocalizeDefaultFolderName,

        [Parameter()]
        [System.Object]
        $TimeZone,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Globalization.CultureInfo]
        $Language
    )
}
function Set-MailContact
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $WindowsEmailAddress,

        [Parameter()]
        [System.Object]
        $AcceptMessagesOnlyFromDLMembers,

        [Parameter()]
        [System.String]
        $CustomAttribute10,

        [Parameter()]
        [System.Boolean]
        $RequireSenderAuthenticationEnabled,

        [Parameter()]
        [System.Boolean]
        $ModerationEnabled,

        [Parameter()]
        [System.Object]
        $ExtensionCustomAttribute4,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $MacAttachmentFormat,

        [Parameter()]
        [System.String]
        $CustomAttribute8,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $CustomAttribute3,

        [Parameter()]
        [System.Object]
        $RejectMessagesFrom,

        [Parameter()]
        [System.String]
        $CustomAttribute11,

        [Parameter()]
        [System.Object]
        $MailTipTranslations,

        [Parameter()]
        [System.String]
        $CustomAttribute7,

        [Parameter()]
        [System.String]
        $CustomAttribute4,

        [Parameter()]
        [System.Object]
        $UseMapiRichTextFormat,

        [Parameter()]
        [System.String]
        $CustomAttribute5,

        [Parameter()]
        [System.Object]
        $AcceptMessagesOnlyFromSendersOrMembers,

        [Parameter()]
        [System.Boolean]
        $HiddenFromAddressListsEnabled,

        [Parameter()]
        [System.String]
        $CustomAttribute6,

        [Parameter()]
        [System.Boolean]
        $UsePreferMessageFormat,

        [Parameter()]
        [System.String]
        $CustomAttribute1,

        [Parameter()]
        [System.Object]
        $BypassModerationFromSendersOrMembers,

        [Parameter()]
        [System.String]
        $CustomAttribute13,

        [Parameter()]
        [System.Object]
        $ModeratedBy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $CustomAttribute14,

        [Parameter()]
        [System.String]
        $MailTip,

        [Parameter()]
        [System.Object]
        $MessageBodyFormat,

        [Parameter()]
        [System.Object]
        $AcceptMessagesOnlyFrom,

        [Parameter()]
        [System.Object]
        $ExtensionCustomAttribute3,

        [Parameter()]
        [System.String]
        $CustomAttribute15,

        [Parameter()]
        [System.Object]
        $ExtensionCustomAttribute1,

        [Parameter()]
        [System.Object]
        $MessageFormat,

        [Parameter()]
        [System.Object]
        $RejectMessagesFromDLMembers,

        [Parameter()]
        [System.Object]
        $ExtensionCustomAttribute5,

        [Parameter()]
        [System.Object]
        $ExternalEmailAddress,

        [Parameter()]
        [System.Object]
        $ExtensionCustomAttribute2,

        [Parameter()]
        [System.String]
        $SecondaryAddress,

        [Parameter()]
        [System.String]
        $CustomAttribute9,

        [Parameter()]
        [System.Object]
        $RejectMessagesFromSendersOrMembers,

        [Parameter()]
        [System.String]
        $Alias,

        [Parameter()]
        [System.String]
        $SimpleDisplayName,

        [Parameter()]
        [System.String]
        $CustomAttribute2,

        [Parameter()]
        [System.Object]
        $GrantSendOnBehalfTo,

        [Parameter()]
        [System.Object]
        $SendModerationNotifications,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object]
        $EmailAddresses,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ForceUpgrade,

        [Parameter()]
        [System.String]
        $CustomAttribute12
    )
}
function Set-MalwareFilterPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $MakeDefault,

        [Parameter()]
        [System.String]
        $CustomFromName,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [System.String]
        $CustomExternalBody,

        [Parameter()]
        [System.String]
        $QuarantineTag,

        [Parameter()]
        [System.Boolean]
        $CustomNotifications,

        [Parameter()]
        [System.Boolean]
        $EnableExternalSenderAdminNotifications,

        [Parameter()]
        [System.Object]
        $InternalSenderAdminAddress,

        [Parameter()]
        [System.String[]]
        $FileTypes,

        [Parameter()]
        [System.Boolean]
        $EnableInternalSenderAdminNotifications,

        [Parameter()]
        [System.Object]
        $CustomFromAddress,

        [Parameter()]
        [System.String]
        $CustomExternalSubject,

        [Parameter()]
        [System.Boolean]
        $ZapEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $ExternalSenderAdminAddress,

        [Parameter()]
        [System.Object]
        $FileTypeAction,

        [Parameter()]
        [System.String]
        $CustomInternalSubject,

        [Parameter()]
        [System.String]
        $CustomInternalBody,

        [Parameter()]
        [System.Boolean]
        $EnableFileFilter
    )
}
function Set-MalwareFilterRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Int32]
        $Priority,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object[]]
        $SentToMemberOf,

        [Parameter()]
        [System.Object[]]
        $SentTo,

        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.Object[]]
        $RecipientDomainIs,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object[]]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.Object]
        $MalwareFilterPolicy,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSentTo,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSentToMemberOf
    )
}
function Set-ManagementRoleAssignment
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $CustomRecipientWriteScope,

        [Parameter()]
        [System.String]
        $User,

        [Parameter()]
        [System.String]
        $Role,

        [Parameter()]
        [System.Object]
        $RecipientAdministrativeUnitScope,

        [Parameter()]
        [System.Object]
        $ExclusiveRecipientWriteScope,

        [Parameter()]
        [System.Object]
        $CustomResourceScope,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $RecipientRelativeWriteScope,

        [Parameter()]
        [System.Object]
        $RecipientOrganizationalUnitScope
    )
}
function Set-MessageClassification
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $SenderDescription,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $RecipientDescription,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Boolean]
        $RetainClassificationEnabled,

        [Parameter()]
        [System.Boolean]
        $PermissionMenuVisible,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Guid]
        $ClassificationID,

        [Parameter()]
        [System.Object]
        $DisplayPrecedence
    )
}
function Set-MobileDeviceMailboxPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $AllowMicrosoftPushNotifications,

        [Parameter()]
        [System.Boolean]
        $AllowUnsignedApplications,

        [Parameter()]
        [System.Boolean]
        $AllowUnsignedInstallationPackages,

        [Parameter()]
        [System.Object]
        $MaxPasswordFailedAttempts,

        [Parameter()]
        [System.Boolean]
        $AllowExternalDeviceManagement,

        [Parameter()]
        [System.Boolean]
        $AllowIrDA,

        [Parameter()]
        [System.Boolean]
        $AllowStorageCard,

        [Parameter()]
        [System.Int32]
        $PasswordHistory,

        [Parameter()]
        [System.Boolean]
        $AllowNonProvisionableDevices,

        [Parameter()]
        [System.Object]
        $UnapprovedInROMApplicationList,

        [Parameter()]
        [System.Boolean]
        $RequireEncryptedSMIMEMessages,

        [Parameter()]
        [System.Boolean]
        $RequireDeviceEncryption,

        [Parameter()]
        [System.Boolean]
        $AllowInternetSharing,

        [Parameter()]
        [System.Boolean]
        $PasswordEnabled,

        [Parameter()]
        [System.Object]
        $RequireSignedSMIMEAlgorithm,

        [Parameter()]
        [System.Object]
        $MaxEmailHTMLBodyTruncationSize,

        [Parameter()]
        [System.Int32]
        $MinPasswordComplexCharacters,

        [Parameter()]
        [System.Boolean]
        $UNCAccessEnabled,

        [Parameter()]
        [System.Boolean]
        $AllowCamera,

        [Parameter()]
        [System.Boolean]
        $IrmEnabled,

        [Parameter()]
        [System.Object]
        $PasswordExpiration,

        [Parameter()]
        [System.Boolean]
        $AllowBrowser,

        [Parameter()]
        [System.Object]
        $MaxEmailAgeFilter,

        [Parameter()]
        [System.Boolean]
        $RequireManualSyncWhenRoaming,

        [Parameter()]
        [System.Boolean]
        $AlphanumericPasswordRequired,

        [Parameter()]
        [System.Object]
        $AllowSMIMEEncryptionAlgorithmNegotiation,

        [Parameter()]
        [System.Boolean]
        $DeviceEncryptionEnabled,

        [Parameter()]
        [System.Object]
        $MaxEmailBodyTruncationSize,

        [Parameter()]
        [System.Object]
        $AllowBluetooth,

        [Parameter()]
        [System.Object]
        $RequireEncryptionSMIMEAlgorithm,

        [Parameter()]
        [System.Object]
        $DevicePolicyRefreshInterval,

        [Parameter()]
        [System.Boolean]
        $AllowGooglePushNotifications,

        [Parameter()]
        [System.Boolean]
        $AllowMobileOTAUpdate,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object]
        $MaxAttachmentSize,

        [Parameter()]
        [System.Boolean]
        $AllowSimplePassword,

        [Parameter()]
        [System.Boolean]
        $AllowConsumerEmail,

        [Parameter()]
        [System.Boolean]
        $AllowDesktopSync,

        [Parameter()]
        [System.Boolean]
        $PasswordRecoveryEnabled,

        [Parameter()]
        [System.Boolean]
        $RequireStorageCardEncryption,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Boolean]
        $AllowSMIMESoftCerts,

        [Parameter()]
        [System.Boolean]
        $AllowRemoteDesktop,

        [Parameter()]
        [System.Boolean]
        $AttachmentsEnabled,

        [Parameter()]
        [System.Object]
        $MaxCalendarAgeFilter,

        [Parameter()]
        [System.Boolean]
        $AllowWiFi,

        [Parameter()]
        [System.Boolean]
        $AllowApplePushNotifications,

        [Parameter()]
        [System.Boolean]
        $AllowPOPIMAPEmail,

        [Parameter()]
        [System.Boolean]
        $IsDefault,

        [Parameter()]
        [System.Object]
        $MaxInactivityTimeLock,

        [Parameter()]
        [System.Object]
        $ApprovedApplicationList,

        [Parameter()]
        [System.Boolean]
        $AllowTextMessaging,

        [Parameter()]
        [System.Boolean]
        $WSSAccessEnabled,

        [Parameter()]
        [System.Boolean]
        $RequireSignedSMIMEMessages,

        [Parameter()]
        [System.Object]
        $MinPasswordLength,

        [Parameter()]
        [System.Boolean]
        $AllowHTMLEmail,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Set-OMEConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Double]
        $ExternalMailExpiryInDays,

        [Parameter()]
        [System.String]
        $ReadButtonText,

        [Parameter()]
        [System.String]
        $PortalText,

        [Parameter()]
        [System.Byte[]]
        $Image,

        [Parameter()]
        [System.String]
        $IntroductionText,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $BackgroundColor,

        [Parameter()]
        [System.String]
        $DisclaimerText,

        [Parameter()]
        [System.String]
        $PrivacyStatementUrl,

        [Parameter()]
        [System.Boolean]
        $SocialIdSignIn,

        [Parameter()]
        [System.String]
        $EmailText,

        [Parameter()]
        [System.Boolean]
        $OTPEnabled,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Set-OnPremisesOrganization
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $InboundConnector,

        [Parameter()]
        [System.Object]
        $OutboundConnector,

        [Parameter()]
        [System.String]
        $OrganizationName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $OrganizationRelationship,

        [Parameter()]
        [System.Object]
        $HybridDomains
    )
}
function Set-Organization
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Boolean]
        $UnifiedAuditLogIngestionEnabled
    )
}
function Set-OrganizationConfig
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $FindTimeLockPollForAttendeesEnabled,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabledForYammer,

        [Parameter()]
        [System.Boolean]
        $PublicFolderShowClientControl,

        [Parameter()]
        [System.Boolean]
        $MailTipsGroupMetricsEnabled,

        [Parameter()]
        [System.Object]
        $PublicFoldersEnabled,

        [Parameter()]
        [System.Boolean]
        $ReadTrackingEnabled,

        [Parameter()]
        [System.Boolean]
        $ExchangeNotificationEnabled,

        [Parameter()]
        [System.Boolean]
        $BookingsNamingPolicyPrefixEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsExternalRecipientsTipsEnabled,

        [Parameter()]
        [System.Object]
        $FocusedInboxOn,

        [Parameter()]
        [System.Object]
        $EwsApplicationAccessPolicy,

        [Parameter()]
        [System.Boolean]
        $OAuth2ClientProfileEnabled,

        [Parameter()]
        [System.Boolean]
        $MobileAppEducationEnabled,

        [Parameter()]
        [System.Boolean]
        $EnableOutlookEvents,

        [Parameter()]
        [System.Boolean]
        $BookingsExposureOfStaffDetailsRestricted,

        [Parameter()]
        [System.Boolean]
        $ElcProcessingDisabled,

        [Parameter()]
        [System.Boolean]
        $UnblockUnsafeSenderPromptEnabled,

        [Parameter()]
        [System.Boolean]
        $AutoEnableArchiveMailbox,

        [Parameter()]
        [System.Object]
        $DefaultAuthenticationPolicy,

        [Parameter()]
        [System.Boolean]
        $RefreshSessionEnabled,

        [Parameter()]
        [System.Boolean]
        $SmtpActionableMessagesEnabled,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabledForTeams,

        [Parameter()]
        [System.Boolean]
        $ComplianceMLBgdCrawlEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsAllTipsEnabled,

        [Parameter()]
        [System.Object]
        $RemotePublicFolderMailboxes,

        [Parameter()]
        [System.Boolean]
        $BlockMoveMessagesForGroupFolders,

        [Parameter()]
        [System.Int32]
        $DefaultMinutesToReduceShortEventsBy,

        [Parameter()]
        [System.Object]
        $EwsAllowEntourage,

        [Parameter()]
        [System.Boolean]
        $OutlookGifPickerDisabled,

        [Parameter()]
        [System.Object]
        $OnlineMeetingsByDefaultEnabled,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabledForOutlook,

        [Parameter()]
        [System.Object]
        $DefaultPublicFolderProhibitPostQuota,

        [Parameter()]
        [System.Object]
        $ExchangeNotificationRecipients,

        [Parameter()]
        [System.Boolean]
        $MessageRemindersEnabled,

        [Parameter()]
        [System.Boolean]
        $DirectReportsGroupAutoCreationEnabled,

        [Parameter()]
        [System.Boolean]
        $AuditDisabled,

        [Parameter()]
        [System.Boolean]
        $BookingsAuthEnabled,

        [Parameter()]
        [System.Boolean]
        $OutlookMobileGCCRestrictionsEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Boolean]
        $BookingsCreationOfCustomQuestionsRestricted,

        [Parameter()]
        [System.Boolean]
        $BookingsSmsMicrosoftEnabled,

        [Parameter()]
        [System.Boolean]
        $WebPushNotificationsDisabled,

        [Parameter()]
        [System.Boolean]
        $ActivityBasedAuthenticationTimeoutEnabled,

        [Parameter()]
        [System.Boolean]
        $BookingsAddressEntryRestricted,

        [Parameter()]
        [System.String]
        $BookingsNamingPolicyPrefix,

        [Parameter()]
        [System.Object]
        $DefaultPublicFolderDeletedItemRetention,

        [Parameter()]
        [System.Int32]
        $PreferredInternetCodePageForShiftJis,

        [Parameter()]
        [System.Object]
        $ShortenEventScopeDefault,

        [Parameter()]
        [System.Object]
        $HierarchicalAddressBookRoot,

        [Parameter()]
        [System.Boolean]
        $IsAgendaMailEnabled,

        [Parameter()]
        [System.Boolean]
        $FindTimeOnlineMeetingOptionDisabled,

        [Parameter()]
        [System.Object]
        $EwsEnabled,

        [Parameter()]
        [System.Boolean]
        $FindTimeAttendeeAuthenticationEnabled,

        [Parameter()]
        [System.Boolean]
        $OutlookMobileHelpShiftEnabled,

        [Parameter()]
        [System.Boolean]
        $LeanPopoutEnabled,

        [Parameter()]
        [System.Object]
        $DistributionGroupNameBlockedWordsList,

        [Parameter()]
        [System.Int32]
        $RequiredCharsetCoverage,

        [Parameter()]
        [System.Boolean]
        $AsyncSendEnabled,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabledForSharepoint,

        [Parameter()]
        [System.Boolean]
        $BookingsBlockedWordsEnabled,

        [Parameter()]
        [System.Boolean]
        $ActivityBasedAuthenticationTimeoutWithSingleSignOnEnabled,

        [Parameter()]
        [System.Boolean]
        $WorkspaceTenantEnabled,

        [Parameter()]
        [System.Boolean]
        $BookingsNamingPolicyEnabled,

        [Parameter()]
        [System.Object]
        $DefaultPublicFolderAgeLimit,

        [Parameter()]
        [System.String]
        $VisibleMeetingUpdateProperties,

        [Parameter()]
        [System.Boolean]
        $OutlookPayEnabled,

        [Parameter()]
        [System.UInt32]
        $MailTipsLargeAudienceThreshold,

        [Parameter()]
        [System.Object]
        $DefaultGroupAccessType,

        [Parameter()]
        [System.Boolean]
        $CalendarVersionStoreEnabled,

        [Parameter()]
        [System.Boolean]
        $BookingsPaymentsEnabled,

        [Parameter()]
        [System.Boolean]
        $MessageHighlightsEnabled,

        [Parameter()]
        [System.Boolean]
        $WebSuggestedRepliesDisabled,

        [Parameter()]
        [System.Boolean]
        $DisablePlusAddressInRecipients,

        [Parameter()]
        [System.Object]
        $DistributionGroupNamingPolicy,

        [Parameter()]
        [System.Boolean]
        $PublicComputersDetectionEnabled,

        [Parameter()]
        [System.Boolean]
        $BookingsSocialSharingRestricted,

        [Parameter()]
        [System.String]
        $BookingsNamingPolicySuffix,

        [Parameter()]
        [System.Boolean]
        $BookingsNamingPolicySuffixEnabled,

        [Parameter()]
        [System.Boolean]
        $BookingsMembershipApprovalRequired,

        [Parameter()]
        [System.Boolean]
        $IsGroupMemberAllowedToEditContent,

        [Parameter()]
        [System.Object]
        $DefaultPublicFolderMovedItemRetention,

        [Parameter()]
        [System.Object]
        $DistributionGroupDefaultOU,

        [Parameter()]
        [System.Boolean]
        $OutlookTextPredictionDisabled,

        [Parameter()]
        [System.Boolean]
        $SharedDomainEmailAddressFlowEnabled,

        [Parameter()]
        [System.Boolean]
        $ConnectorsActionableMessagesEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsMailboxSourcedTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $BookingsEnabled,

        [Parameter()]
        [System.Boolean]
        $EndUserDLUpgradeFlowsDisabled,

        [Parameter()]
        [System.Object]
        $RecallReadMessagesEnabled,

        [Parameter()]
        [System.Boolean]
        $BookingsPhoneNumberEntryRestricted,

        [Parameter()]
        [System.Boolean]
        $AppsForOfficeEnabled,

        [Parameter()]
        [System.Boolean]
        $EnableForwardingAddressSyncForMailboxes,

        [Parameter()]
        [System.Object]
        $EwsAllowOutlook,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AutoExpandingArchive,

        [Parameter()]
        [System.Boolean]
        $LinkPreviewEnabled,

        [Parameter()]
        [System.Boolean]
        $BookingsSearchEngineIndexDisabled,

        [Parameter()]
        [System.Object]
        $EwsAllowMacOutlook,

        [Parameter()]
        [System.Object]
        $EwsAllowList,

        [Parameter()]
        [System.Object]
        $DefaultPublicFolderMaxItemSize,

        [Parameter()]
        [System.Boolean]
        $MatchSenderOrganizerProperties,

        [Parameter()]
        [System.Int32]
        $DefaultMinutesToReduceLongEventsBy,

        [Parameter()]
        [System.Object]
        $IPListBlocked,

        [Parameter()]
        [System.Boolean]
        $BookingsNotesEntryRestricted,

        [Parameter()]
        [System.Boolean]
        $SendFromAliasEnabled,

        [Parameter()]
        [System.Boolean]
        $AutodiscoverPartialDirSync,

        [Parameter()]
        [System.Object]
        $ActivityBasedAuthenticationTimeoutInterval,

        [Parameter()]
        [System.Boolean]
        $OutlookMobileSingleAccountEnabled,

        [Parameter()]
        [System.Boolean]
        $IsGroupFoldersAndRulesEnabled,

        [Parameter()]
        [System.Boolean]
        $MaskClientIpInReceivedHeadersEnabled,

        [Parameter()]
        [System.Boolean]
        $PerTenantSwitchToESTSEnabled,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabled,

        [Parameter()]
        [System.Object]
        $EwsBlockList,

        [Parameter()]
        [System.Boolean]
        $CustomerLockboxEnabled,

        [Parameter()]
        [System.Uri]
        $SiteMailboxCreationURL,

        [Parameter()]
        [System.Int32]
        $ByteEncoderTypeFor7BitCharsets,

        [Parameter()]
        [System.Boolean]
        $FindTimeAutoScheduleDisabled,

        [Parameter()]
        [System.Object]
        $DefaultPublicFolderIssueWarningQuota
    )
}
function Set-OrganizationRelationship
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $MailTipsAccessLevel,

        [Parameter()]
        [System.Uri]
        $TargetAutodiscoverEpr,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object]
        $FreeBusyAccessScope,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Boolean]
        $DeliveryReportEnabled,

        [Parameter()]
        [System.String]
        $OAuthApplicationId,

        [Parameter()]
        [System.Boolean]
        $MailTipsAccessEnabled,

        [Parameter()]
        [System.Boolean]
        $ArchiveAccessEnabled,

        [Parameter()]
        [System.Boolean]
        $FreeBusyAccessEnabled,

        [Parameter()]
        [System.Object]
        $MailTipsAccessScope,

        [Parameter()]
        [System.Uri]
        $TargetOwaURL,

        [Parameter()]
        [System.Uri]
        $TargetApplicationUri,

        [Parameter()]
        [System.Object]
        $OrganizationContact,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $MailboxMovePublishedScopes,

        [Parameter()]
        [System.Boolean]
        $MailboxMoveEnabled,

        [Parameter()]
        [System.Object]
        $MailboxMoveCapability,

        [Parameter()]
        [System.Uri]
        $TargetSharingEpr,

        [Parameter()]
        [System.Object]
        $FreeBusyAccessLevel,

        [Parameter()]
        [System.Object]
        $DomainNames,

        [Parameter()]
        [System.Boolean]
        $PhotosEnabled
    )
}
function Set-OutboundConnector
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $RouteAllMessagesViaOnPremises,

        [Parameter()]
        [System.Object]
        $RecipientDomains,

        [Parameter()]
        [System.Boolean]
        $CloudServicesMailEnabled,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Boolean]
        $AllAcceptedDomains,

        [Parameter()]
        [System.Object]
        $TlsDomain,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [System.Boolean]
        $IsTransportRuleScoped,

        [Parameter()]
        [System.Boolean]
        $IsValidated,

        [Parameter()]
        [System.Boolean]
        $UseMXRecord,

        [Parameter()]
        [System.Object]
        $LastValidationTimestamp,

        [Parameter()]
        [System.Object]
        $TlsSettings,

        [Parameter()]
        [System.String[]]
        $ValidationRecipients,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $ConnectorType,

        [Parameter()]
        [System.Object]
        $SmartHosts,

        [Parameter()]
        [System.Boolean]
        $SenderRewritingEnabled,

        [Parameter()]
        [System.Boolean]
        $TestMode,

        [Parameter()]
        [System.Object]
        $ConnectorSource
    )
}
function Set-OwaMailboxPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Int32]
        $DefaultClientLanguage,

        [Parameter()]
        [System.Boolean]
        $ContactsEnabled,

        [Parameter()]
        [System.Boolean]
        $PersonalAccountCalendarsEnabled,

        [Parameter()]
        [System.Object]
        $ConditionalAccessPolicy,

        [Parameter()]
        [System.Boolean]
        $MessagePreviewsDisabled,

        [Parameter()]
        [System.Boolean]
        $ExplicitLogonEnabled,

        [Parameter()]
        [System.Boolean]
        $ShowOnlineArchiveEnabled,

        [Parameter()]
        [System.Object]
        $BlockedFileTypes,

        [Parameter()]
        [System.Boolean]
        $OneDriveAttachmentsEnabled,

        [Parameter()]
        [System.Boolean]
        $LinkedInEnabled,

        [Parameter()]
        [System.Boolean]
        $DirectFileAccessOnPrivateComputersEnabled,

        [Parameter()]
        [System.String[]]
        $AllowedOrganizationAccountDomains,

        [Parameter()]
        [System.Boolean]
        $ChangePasswordEnabled,

        [Parameter()]
        [System.Boolean]
        $PlacesEnabled,

        [Parameter()]
        [System.String]
        $BookingsMailboxDomain,

        [Parameter()]
        [System.Boolean]
        $WacViewingOnPublicComputersEnabled,

        [Parameter()]
        [System.Boolean]
        $OutlookBetaToggleEnabled,

        [Parameter()]
        [System.Boolean]
        $SMimeSuppressNameChecksEnabled,

        [Parameter()]
        [System.String]
        $ExternalSPMySiteHostURL,

        [Parameter()]
        [System.Boolean]
        $ReferenceAttachmentsEnabled,

        [Parameter()]
        [System.Object]
        $ForceSaveMimeTypes,

        [Parameter()]
        [System.Boolean]
        $CalendarEnabled,

        [Parameter()]
        [System.Boolean]
        $SpellCheckerEnabled,

        [Parameter()]
        [System.Boolean]
        $DisplayPhotosEnabled,

        [Parameter()]
        [System.Boolean]
        $TasksEnabled,

        [Parameter()]
        [System.Boolean]
        $GroupCreationEnabled,

        [Parameter()]
        [System.Object]
        $ForceSaveFileTypes,

        [Parameter()]
        [System.Object]
        $ChangeSettingsAccountEnabled,

        [Parameter()]
        [System.Object]
        $AdditionalAccountsEnabled,

        [Parameter()]
        [System.Boolean]
        $TeamsnapCalendarsEnabled,

        [Parameter()]
        [System.Boolean]
        $WacViewingOnPrivateComputersEnabled,

        [Parameter()]
        [System.Boolean]
        $TextMessagingEnabled,

        [Parameter()]
        [System.Boolean]
        $SearchFoldersEnabled,

        [Parameter()]
        [System.Boolean]
        $UserVoiceEnabled,

        [Parameter()]
        [System.Boolean]
        $ForceWacViewingFirstOnPublicComputers,

        [Parameter()]
        [System.Boolean]
        $GlobalAddressListEnabled,

        [Parameter()]
        [System.Boolean]
        $IRMEnabled,

        [Parameter()]
        [System.Boolean]
        $DirectFileAccessOnPublicComputersEnabled,

        [Parameter()]
        [System.Boolean]
        $WacOMEXEnabled,

        [Parameter()]
        [System.Boolean]
        $JournalEnabled,

        [Parameter()]
        [System.Boolean]
        $NpsSurveysEnabled,

        [Parameter()]
        [System.Object]
        $ItemsToOtherAccountsEnabled,

        [Parameter()]
        [System.Boolean]
        $WSSAccessOnPublicComputersEnabled,

        [Parameter()]
        [System.Boolean]
        $SignaturesEnabled,

        [Parameter()]
        [System.Boolean]
        $WacExternalServicesEnabled,

        [Parameter()]
        [System.String]
        $InternalSPMySiteHostURL,

        [Parameter()]
        [System.Boolean]
        $RemindersAndNotificationsEnabled,

        [Parameter()]
        [System.Boolean]
        $SatisfactionEnabled,

        [Parameter()]
        [System.Object]
        $InstantMessagingType,

        [Parameter()]
        [System.Boolean]
        $ActiveSyncIntegrationEnabled,

        [Parameter()]
        [System.Object]
        $PersonalAccountsEnabled,

        [Parameter()]
        [System.String]
        $DefaultTheme,

        [Parameter()]
        [System.Boolean]
        $SetPhotoEnabled,

        [Parameter()]
        [System.Boolean]
        $ClassicAttachmentsEnabled,

        [Parameter()]
        [System.Boolean]
        $ForceWacViewingFirstOnPrivateComputers,

        [Parameter()]
        [System.Object]
        $AllowedMimeTypes,

        [Parameter()]
        [System.Boolean]
        $AllowCopyContactsToDeviceAddressBook,

        [Parameter()]
        [System.Object]
        $OutboundCharset,

        [Parameter()]
        [System.Boolean]
        $LocalEventsEnabled,

        [Parameter()]
        [System.Boolean]
        $ReportJunkEmailEnabled,

        [Parameter()]
        [System.Boolean]
        $UseISO885915,

        [Parameter()]
        [System.Boolean]
        $RecoverDeletedItemsEnabled,

        [Parameter()]
        [System.Boolean]
        $NotesEnabled,

        [Parameter()]
        [System.Boolean]
        $OrganizationEnabled,

        [Parameter()]
        [System.Object]
        $WebPartsFrameOptionsType,

        [Parameter()]
        [System.Object]
        $ActionForUnknownFileAndMIMETypes,

        [Parameter()]
        [System.Boolean]
        $WacEditingEnabled,

        [Parameter()]
        [System.Boolean]
        $PublicFoldersEnabled,

        [Parameter()]
        [System.Boolean]
        $BookingsMailboxCreationEnabled,

        [Parameter()]
        [System.Boolean]
        $ForceSaveAttachmentFilteringEnabled,

        [Parameter()]
        [System.Int32]
        $LogonAndErrorLanguage,

        [Parameter()]
        [System.Boolean]
        $WSSAccessOnPrivateComputersEnabled,

        [Parameter()]
        [System.Boolean]
        $AllAddressListsEnabled,

        [Parameter()]
        [System.Boolean]
        $ExternalImageProxyEnabled,

        [Parameter()]
        [System.Boolean]
        $ProjectMocaEnabled,

        [Parameter()]
        [System.Boolean]
        $DelegateAccessEnabled,

        [Parameter()]
        [System.Boolean]
        $PremiumClientEnabled,

        [Parameter()]
        [System.Object]
        $BlockedMimeTypes,

        [Parameter()]
        [System.Boolean]
        $UMIntegrationEnabled,

        [Parameter()]
        [System.Boolean]
        $FeedbackEnabled,

        [Parameter()]
        [System.Boolean]
        $SilverlightEnabled,

        [Parameter()]
        [System.Boolean]
        $WeatherEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsDefault,

        [Parameter()]
        [System.Boolean]
        $UseGB18030,

        [Parameter()]
        [System.Object]
        $AllowOfflineOn,

        [Parameter()]
        [System.Object]
        $AllowedFileTypes,

        [Parameter()]
        [System.String]
        $SetPhotoURL,

        [Parameter()]
        [System.Boolean]
        $RulesEnabled,

        [Parameter()]
        [System.Object]
        $OneWinNativeOutlookEnabled,

        [Parameter()]
        [System.Boolean]
        $FreCardsEnabled,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Boolean]
        $ThemeSelectionEnabled,

        [Parameter()]
        [System.Boolean]
        $InstantMessagingEnabled,

        [Parameter()]
        [System.Boolean]
        $AdditionalStorageProvidersAvailable,

        [Parameter()]
        [System.Boolean]
        $InterestingCalendarsEnabled,

        [Parameter()]
        [System.Boolean]
        $OWALightEnabled,

        [Parameter()]
        [System.Boolean]
        $PrintWithoutDownloadEnabled,

        [Parameter()]
        [System.Boolean]
        $SaveAttachmentsToCloudEnabled,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $PhoneticSupportEnabled,

        [Parameter()]
        [System.Boolean]
        $SkipCreateUnifiedGroupCustomSharepointClassification,

        [Parameter()]
        [System.Boolean]
        $OnSendAddinsEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $DisableFacebook
    )
}
function Set-PartnerApplication
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $ApplicationIdentifier,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object]
        $LinkedAccount,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Boolean]
        $AcceptSecurityIdentifierInformation,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.String[]]
        $ActAsPermissions,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.Object]
        $AccountType
    )
}
function Set-PerimeterConfig
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $GatewayIPAddresses
    )
}
function Set-PolicyTipConfig
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Value,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Set-QuarantinePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $MultiLanguageCustomDisclaimer,

        [Parameter()]
        [System.Object]
        $AdminNotificationLanguage,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Int32]
        $EndUserSpamNotificationFrequencyInDays,

        [Parameter()]
        [System.String]
        $CustomDisclaimer,

        [Parameter()]
        [System.Int32]
        $EndUserQuarantinePermissionsValue,

        [Parameter()]
        [System.Boolean]
        $ESNEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IgnoreDehydratedFlag,

        [Parameter()]
        [System.Object]
        $EndUserQuarantinePermissions,

        [Parameter()]
        [System.Boolean]
        $AdminNotificationsEnabled,

        [Parameter()]
        [System.Object]
        $EndUserSpamNotificationLanguage,

        [Parameter()]
        [System.Object]
        $DomainController,

        [Parameter()]
        [System.Object]
        $MultiLanguageSenderName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $AdminQuarantinePermissionsList,

        [Parameter()]
        [System.Object]
        $MultiLanguageSetting,

        [Parameter()]
        [System.Int32]
        $QuarantineRetentionDays,

        [Parameter()]
        [System.Boolean]
        $OrganizationBrandingEnabled,

        [Parameter()]
        [System.Int32]
        $AdminNotificationFrequencyInDays
    )
}
function Set-RemoteDomain
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $AutoReplyEnabled,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $TNEFEnabled,

        [Parameter()]
        [System.Boolean]
        $DeliveryReportEnabled,

        [Parameter()]
        [System.Object]
        $RequiredCharsetCoverage,

        [Parameter()]
        [System.Boolean]
        $MeetingForwardNotificationEnabled,

        [Parameter()]
        [System.Object]
        $ContentType,

        [Parameter()]
        [System.Object]
        $ByteEncoderTypeFor7BitCharsets,

        [Parameter()]
        [System.Boolean]
        $AutoForwardEnabled,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Boolean]
        $TrustedMailInboundEnabled,

        [Parameter()]
        [System.Object]
        $LineWrapSize,

        [Parameter()]
        [System.String]
        $CharacterSet,

        [Parameter()]
        [System.Object]
        $PreferredInternetCodePageForShiftJis,

        [Parameter()]
        [System.String]
        $NonMimeCharacterSet,

        [Parameter()]
        [System.Boolean]
        $TargetDeliveryDomain,

        [Parameter()]
        [System.Boolean]
        $TrustedMailOutboundEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Boolean]
        $DisplaySenderName,

        [Parameter()]
        [System.Object]
        $AllowedOOFType,

        [Parameter()]
        [System.Boolean]
        $NDREnabled,

        [Parameter()]
        [System.Boolean]
        $NDRDiagnosticInfoEnabled,

        [Parameter()]
        [System.Boolean]
        $IsInternal,

        [Parameter()]
        [System.Boolean]
        $UseSimpleDisplayName
    )
}
function Set-ResourceConfig
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $ResourcePropertySchema
    )
}
function Set-RoleAssignmentPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsDefault,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Set-SafeAttachmentPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Action,

        [Parameter()]
        [System.Boolean]
        $Redirect,

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [System.Boolean]
        $Enable,

        [Parameter()]
        [System.Object]
        $RedirectAddress,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.String]
        $QuarantineTag,

        [Parameter()]
        [System.Boolean]
        $ActionOnError
    )
}
function Set-SafeAttachmentRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Int32]
        $Priority,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object[]]
        $SentToMemberOf,

        [Parameter()]
        [System.Object[]]
        $SentTo,

        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.Object[]]
        $RecipientDomainIs,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $SafeAttachmentPolicy,

        [Parameter()]
        [System.Object[]]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSentTo,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSentToMemberOf
    )
}
function Set-SafeLinksPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $EnableOrganizationBranding,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [System.Boolean]
        $UseTranslatedNotificationText,

        [Parameter()]
        [System.Boolean]
        $DisableUrlRewrite,

        [Parameter()]
        [System.Object]
        $DoNotRewriteUrls,

        [Parameter()]
        [System.Boolean]
        $EnableSafeLinksForTeams,

        [Parameter()]
        [System.Boolean]
        $EnableSafeLinksForOffice,

        [Parameter()]
        [System.Boolean]
        $TrackClicks,

        [Parameter()]
        [System.Boolean]
        $AllowClickThrough,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $CustomNotificationText,

        [Parameter()]
        [System.Boolean]
        $DeliverMessageAfterScan,

        [Parameter()]
        [System.Boolean]
        $EnableSafeLinksForEmail,

        [Parameter()]
        [System.Boolean]
        $ScanUrls,

        [Parameter()]
        [System.Boolean]
        $EnableForInternalSenders
    )
}
function Set-SafeLinksRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Int32]
        $Priority,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object[]]
        $SentToMemberOf,

        [Parameter()]
        [System.Object[]]
        $SentTo,

        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.Object[]]
        $RecipientDomainIs,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object[]]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.Object]
        $SafeLinksPolicy,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSentTo,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSentToMemberOf
    )
}
function Set-SharingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Domains,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Default,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $Enabled
    )
}
function Set-TransportConfig
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $InternalDelayDsnEnabled,

        [Parameter()]
        [System.Boolean]
        $InternalDsnSendHtml,

        [Parameter()]
        [System.Boolean]
        $ExternalDelayDsnEnabled,

        [Parameter()]
        [System.Object]
        $DSNConversionMode,

        [Parameter()]
        [System.Boolean]
        $SmtpClientAuthenticationDisabled,

        [Parameter()]
        [System.Globalization.CultureInfo]
        $InternalDsnDefaultLanguage,

        [Parameter()]
        [System.Object]
        $MessageExpiration,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Boolean]
        $ReplyAllStormProtectionEnabled,

        [Parameter()]
        [System.Boolean]
        $InternalDsnLanguageDetectionEnabled,

        [Parameter()]
        [System.Boolean]
        $AddressBookPolicyRoutingEnabled,

        [Parameter()]
        [System.Boolean]
        $ExternalDsnLanguageDetectionEnabled,

        [Parameter()]
        [System.Boolean]
        $ExternalDsnSendHtml,

        [Parameter()]
        [System.Boolean]
        $Rfc2231EncodingEnabled,

        [Parameter()]
        [System.Object]
        $HeaderPromotionModeSetting,

        [Parameter()]
        [System.Boolean]
        $VoicemailJournalingEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $JournalingReportNdrTo,

        [Parameter()]
        [System.Boolean]
        $ConvertDisclaimerWrapperToEml,

        [Parameter()]
        [System.Object]
        $InternalDsnReportingAuthority,

        [Parameter()]
        [System.Int32]
        $JournalMessageExpirationDays,

        [Parameter()]
        [System.Object]
        $MaxRecipientEnvelopeLimit,

        [Parameter()]
        [System.Int32]
        $ReplyAllStormDetectionMinimumReplies,

        [Parameter()]
        [System.Object]
        $ExternalDsnReportingAuthority,

        [Parameter()]
        [System.Globalization.CultureInfo]
        $ExternalDsnDefaultLanguage,

        [Parameter()]
        [System.Object]
        $AllowLegacyTLSClients,

        [Parameter()]
        [System.Boolean]
        $ClearCategories,

        [Parameter()]
        [System.Int32]
        $ReplyAllStormBlockDurationHours,

        [Parameter()]
        [System.Object]
        $ExternalPostmasterAddress,

        [Parameter()]
        [System.Int32]
        $ReplyAllStormDetectionMinimumRecipients
    )
}
function Set-TransportRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $ActivationDate,

        [Parameter()]
        [System.Object[]]
        $AddToRecipients,

        [Parameter()]
        [System.Object]
        $ApplyHtmlDisclaimerFallbackAction,

        [Parameter()]
        [System.Object[]]
        $ExceptIfRecipientADAttributeContainsWords,

        [Parameter()]
        [System.Object]
        $AttachmentSizeOver,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSenderADAttributeContainsWords,

        [Parameter()]
        [System.Object]
        $SetSCL,

        [Parameter()]
        [System.Object[]]
        $AnyOfToHeaderMemberOf,

        [Parameter()]
        [System.Boolean]
        $Disconnect,

        [Parameter()]
        [System.Int32]
        $Priority,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSentToMemberOf,

        [Parameter()]
        [System.Object[]]
        $ExceptIfAnyOfCcHeader,

        [Parameter()]
        [System.Object[]]
        $ExceptIfAttachmentMatchesPatterns,

        [Parameter()]
        [System.Object[]]
        $RecipientDomainIs,

        [Parameter()]
        [System.Object]
        $ManagerForEvaluatedUser,

        [Parameter()]
        [System.Object[]]
        $ExceptIfHeaderMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfFromScope,

        [Parameter()]
        [System.Object]
        $AdComparisonAttribute,

        [Parameter()]
        [System.Object[]]
        $ExceptIfHeaderContainsWords,

        [Parameter()]
        [System.Object[]]
        $HeaderMatchesPatterns,

        [Parameter()]
        [System.Object]
        $AddManagerAsRecipientType,

        [Parameter()]
        [System.Boolean]
        $DeleteMessage,

        [Parameter()]
        [System.Boolean]
        $HasSenderOverride,

        [Parameter()]
        [System.Object]
        $SmtpRejectMessageRejectStatusCode,

        [Parameter()]
        [System.String]
        $ExceptIfHasClassification,

        [Parameter()]
        [System.Boolean]
        $Quarantine,

        [Parameter()]
        [System.Object[]]
        $ExceptIfAnyOfRecipientAddressMatchesPatterns,

        [Parameter()]
        [System.Object[]]
        $ExceptIfRecipientInSenderList,

        [Parameter()]
        [System.Object]
        $RecipientAddressType,

        [Parameter()]
        [System.Object[]]
        $ExceptIfContentCharacterSetContainsWords,

        [Parameter()]
        [System.Object[]]
        $BlindCopyTo,

        [Parameter()]
        [System.Object]
        $ApplyHtmlDisclaimerLocation,

        [Parameter()]
        [System.Object]
        $ExceptIfMessageTypeMatches,

        [Parameter()]
        [System.Object]
        $SenderIpRanges,

        [Parameter()]
        [System.Collections.Hashtable[]]
        $ExceptIfMessageContainsDataClassifications,

        [Parameter()]
        [System.Object[]]
        $ModerateMessageByUser,

        [Parameter()]
        [System.Boolean]
        $HasNoClassification,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSenderInRecipientList,

        [Parameter()]
        [System.Object]
        $HeaderContainsMessageHeader,

        [Parameter()]
        [System.Object]
        $RemoveHeader,

        [Parameter()]
        [System.String]
        $HasClassification,

        [Parameter()]
        [System.Collections.Hashtable[]]
        $MessageContainsDataClassifications,

        [Parameter()]
        [System.Object[]]
        $ExceptIfFromMemberOf,

        [Parameter()]
        [System.Object]
        $RuleSubType,

        [Parameter()]
        [System.Object[]]
        $AnyOfRecipientAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $SentToScope,

        [Parameter()]
        [System.Object[]]
        $AnyOfToCcHeaderMemberOf,

        [Parameter()]
        [System.Object[]]
        $From,

        [Parameter()]
        [System.Object[]]
        $ExceptIfAnyOfRecipientAddressContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfWithImportance,

        [Parameter()]
        [System.Object[]]
        $ContentCharacterSetContainsWords,

        [Parameter()]
        [System.Object[]]
        $SubjectContainsWords,

        [Parameter()]
        [System.Object]
        $RejectMessageEnhancedStatusCode,

        [Parameter()]
        [System.Object[]]
        $SenderADAttributeMatchesPatterns,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSenderADAttributeMatchesPatterns,

        [Parameter()]
        [System.Object[]]
        $IncidentReportContent,

        [Parameter()]
        [System.Object[]]
        $FromMemberOf,

        [Parameter()]
        [System.Object[]]
        $AttachmentContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfSCLOver,

        [Parameter()]
        [System.Object[]]
        $ExceptIfBetweenMemberOf1,

        [Parameter()]
        [System.Object]
        $GenerateNotification,

        [Parameter()]
        [System.Object]
        $NotifySender,

        [Parameter()]
        [System.Boolean]
        $ExceptIfAttachmentIsPasswordProtected,

        [Parameter()]
        [System.Object[]]
        $ExceptIfAttachmentNameMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderManagementRelationship,

        [Parameter()]
        [System.String]
        $SetAuditSeverity,

        [Parameter()]
        [System.Object[]]
        $AttachmentPropertyContainsWords,

        [Parameter()]
        [System.Object[]]
        $ExceptIfAnyOfToHeader,

        [Parameter()]
        [System.Object]
        $ApplyRightsProtectionCustomizationTemplate,

        [Parameter()]
        [System.Object]
        $SetHeaderName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Boolean]
        $RouteMessageOutboundRequireTls,

        [Parameter()]
        [System.Object]
        $WithImportance,

        [Parameter()]
        [System.Object]
        $RuleErrorAction,

        [Parameter()]
        [System.Object]
        $FromScope,

        [Parameter()]
        [System.Object[]]
        $AttachmentNameMatchesPatterns,

        [Parameter()]
        [System.Object[]]
        $SentTo,

        [Parameter()]
        [System.Object[]]
        $ExceptIfFromAddressMatchesPatterns,

        [Parameter()]
        [System.Object[]]
        $AnyOfCcHeaderMemberOf,

        [Parameter()]
        [System.Object]
        $ExceptIfAttachmentSizeOver,

        [Parameter()]
        [System.Object]
        $ExceptIfManagerForEvaluatedUser,

        [Parameter()]
        [System.Boolean]
        $RemoveOMEv2,

        [Parameter()]
        [System.Object[]]
        $ExceptIfFromAddressContainsWords,

        [Parameter()]
        [System.Boolean]
        $AttachmentHasExecutableContent,

        [Parameter()]
        [System.Object]
        $RouteMessageOutboundConnector,

        [Parameter()]
        [System.Object[]]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSenderDomainIs,

        [Parameter()]
        [System.Object]
        $SenderManagementRelationship,

        [Parameter()]
        [System.Object[]]
        $ExceptIfBetweenMemberOf2,

        [Parameter()]
        [System.Object[]]
        $RedirectMessageTo,

        [Parameter()]
        [System.Boolean]
        $ApplyOME,

        [Parameter()]
        [System.Object[]]
        $SenderDomainIs,

        [Parameter()]
        [System.Object[]]
        $SenderADAttributeContainsWords,

        [Parameter()]
        [System.Object[]]
        $ExceptIfAnyOfCcHeaderMemberOf,

        [Parameter()]
        [System.Object]
        $ApplyHtmlDisclaimerText,

        [Parameter()]
        [System.Boolean]
        $ExceptIfAttachmentHasExecutableContent,

        [Parameter()]
        [System.Boolean]
        $ExceptIfAttachmentIsUnsupported,

        [Parameter()]
        [System.Boolean]
        $RemoveOME,

        [Parameter()]
        [System.Object]
        $RejectMessageReasonText,

        [Parameter()]
        [System.Object[]]
        $RecipientAddressContainsWords,

        [Parameter()]
        [System.Object]
        $GenerateIncidentReport,

        [Parameter()]
        [System.Object[]]
        $FromAddressContainsWords,

        [Parameter()]
        [System.Boolean]
        $RemoveRMSAttachmentEncryption,

        [Parameter()]
        [System.Object[]]
        $RecipientAddressMatchesPatterns,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSubjectContainsWords,

        [Parameter()]
        [System.Object[]]
        $ExceptIfFrom,

        [Parameter()]
        [System.Object[]]
        $AnyOfToCcHeader,

        [Parameter()]
        [System.Object]
        $ExceptIfSentToScope,

        [Parameter()]
        [System.Object[]]
        $ExceptIfAnyOfToCcHeaderMemberOf,

        [Parameter()]
        [System.Boolean]
        $ModerateMessageByManager,

        [Parameter()]
        [System.Object]
        $AdComparisonOperator,

        [Parameter()]
        [System.Object]
        $MessageSizeOver,

        [Parameter()]
        [System.Object[]]
        $BetweenMemberOf2,

        [Parameter()]
        [System.Object[]]
        $SubjectMatchesPatterns,

        [Parameter()]
        [System.Boolean]
        $AttachmentProcessingLimitExceeded,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSubjectMatchesPatterns,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object[]]
        $ExceptIfRecipientAddressContainsWords,

        [Parameter()]
        [System.Object]
        $HeaderMatchesMessageHeader,

        [Parameter()]
        [System.Object[]]
        $AnyOfRecipientAddressContainsWords,

        [Parameter()]
        [System.Object[]]
        $HeaderContainsWords,

        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.Object[]]
        $SentToMemberOf,

        [Parameter()]
        [System.Object]
        $ExceptIfAdComparisonAttribute,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSentTo,

        [Parameter()]
        [System.Object]
        $ExceptIfAdComparisonOperator,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object[]]
        $ExceptIfAnyOfToHeaderMemberOf,

        [Parameter()]
        [System.Object]
        $Mode,

        [Parameter()]
        [System.Object[]]
        $RecipientInSenderList,

        [Parameter()]
        [System.Object[]]
        $SubjectOrBodyMatchesPatterns,

        [Parameter()]
        [System.Object[]]
        $ExceptIfAttachmentExtensionMatchesWords,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSubjectOrBodyMatchesPatterns,

        [Parameter()]
        [System.Object[]]
        $ExceptIfRecipientAddressMatchesPatterns,

        [Parameter()]
        [System.Boolean]
        $ExceptIfHasNoClassification,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderIpRanges,

        [Parameter()]
        [System.Object[]]
        $ExceptIfRecipientADAttributeMatchesPatterns,

        [Parameter()]
        [System.Object[]]
        $RecipientADAttributeContainsWords,

        [Parameter()]
        [System.Boolean]
        $AttachmentIsUnsupported,

        [Parameter()]
        [System.Object]
        $ExpiryDate,

        [Parameter()]
        [System.Object[]]
        $AttachmentExtensionMatchesWords,

        [Parameter()]
        [System.Object[]]
        $ExceptIfSubjectOrBodyContainsWords,

        [Parameter()]
        [System.Object]
        $LogEventText,

        [Parameter()]
        [System.Object[]]
        $ExceptIfManagerAddresses,

        [Parameter()]
        [System.Object[]]
        $SenderInRecipientList,

        [Parameter()]
        [System.Object[]]
        $ExceptIfAnyOfToCcHeader,

        [Parameter()]
        [System.Object[]]
        $AttachmentMatchesPatterns,

        [Parameter()]
        [System.String]
        $DlpPolicy,

        [Parameter()]
        [System.Object[]]
        $ManagerAddresses,

        [Parameter()]
        [System.Object]
        $SenderAddressLocation,

        [Parameter()]
        [System.Object[]]
        $CopyTo,

        [Parameter()]
        [System.Object[]]
        $SubjectOrBodyContainsWords,

        [Parameter()]
        [System.String]
        $ApplyClassification,

        [Parameter()]
        [System.Object[]]
        $RecipientADAttributeMatchesPatterns,

        [Parameter()]
        [System.Object]
        $SetHeaderValue,

        [Parameter()]
        [System.Boolean]
        $AttachmentIsPasswordProtected,

        [Parameter()]
        [System.Object[]]
        $BetweenMemberOf1,

        [Parameter()]
        [System.Object]
        $ExceptIfMessageSizeOver,

        [Parameter()]
        [System.Object[]]
        $AnyOfCcHeader,

        [Parameter()]
        [System.Boolean]
        $ExceptIfAttachmentProcessingLimitExceeded,

        [Parameter()]
        [System.Object[]]
        $FromAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfHeaderMatchesMessageHeader,

        [Parameter()]
        [System.Object]
        $SmtpRejectMessageRejectText,

        [Parameter()]
        [System.Object[]]
        $ExceptIfAttachmentContainsWords,

        [Parameter()]
        [System.Object[]]
        $AnyOfToHeader,

        [Parameter()]
        [System.Boolean]
        $ExceptIfHasSenderOverride,

        [Parameter()]
        [System.Object]
        $SCLOver,

        [Parameter()]
        [System.Object]
        $PrependSubject,

        [Parameter()]
        [System.Object]
        $ApplyRightsProtectionTemplate,

        [Parameter()]
        [System.Object]
        $MessageTypeMatches,

        [Parameter()]
        [System.Object[]]
        $ExceptIfAttachmentPropertyContainsWords,

        [Parameter()]
        [System.Boolean]
        $StopRuleProcessing,

        [Parameter()]
        [System.Object]
        $ExceptIfHeaderContainsMessageHeader
    )
}
function Set-User
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Company,

        [Parameter()]
        [System.String]
        $Phone,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.String]
        $Office,

        [Parameter()]
        [System.Object]
        $CountryOrRegion,

        [Parameter()]
        [System.Object]
        $AuthenticationPolicy,

        [Parameter()]
        [System.Object]
        $OtherTelephone,

        [Parameter()]
        [System.String]
        $Pager,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $PhoneticDisplayName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ClearDataEncryptionPolicy,

        [Parameter()]
        [System.String]
        $Fax,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.String]
        $LastName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RemoveMailboxProvisioningConstraint,

        [Parameter()]
        [System.Boolean]
        $ResetPasswordOnNextLogon,

        [Parameter()]
        [System.Boolean]
        $BlockCloudCache,

        [Parameter()]
        [System.Object]
        $SeniorityIndex,

        [Parameter()]
        [System.String]
        $City,

        [Parameter()]
        [System.Boolean]
        $VIP,

        [Parameter()]
        [System.String]
        $Title,

        [Parameter()]
        [System.String]
        $MobilePhone,

        [Parameter()]
        [System.String]
        $AssistantName,

        [Parameter()]
        [System.Object]
        $OtherHomePhone,

        [Parameter()]
        [System.String]
        $StateOrProvince,

        [Parameter()]
        [System.String]
        $Initials,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $WebPage,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PermanentlyClearPreviousMailboxInfo,

        [Parameter()]
        [System.String]
        $MailboxRegion,

        [Parameter()]
        [System.Object]
        $Manager,

        [Parameter()]
        [System.Object]
        $StsRefreshTokensValidFrom,

        [Parameter()]
        [System.Object]
        $OtherFax,

        [Parameter()]
        [System.String]
        $SimpleDisplayName,

        [Parameter()]
        [System.Object]
        $MailboxRegionSuffix,

        [Parameter()]
        [System.String]
        $HomePhone,

        [Parameter()]
        [System.String]
        $Department,

        [Parameter()]
        [System.String]
        $FirstName,

        [Parameter()]
        [System.Object]
        $PostOfficeBox,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PublicFolder,

        [Parameter()]
        [System.Object]
        $WindowsEmailAddress,

        [Parameter()]
        [System.Boolean]
        $RemotePowerShellEnabled,

        [Parameter()]
        [System.String]
        $PostalCode,

        [Parameter()]
        [System.Object]
        $GeoCoordinates,

        [Parameter()]
        [System.String]
        $StreetAddress,

        [Parameter()]
        [System.Object]
        $DesiredWorkloads,

        [Parameter()]
        [System.Boolean]
        $CanHaveCloudCache
    )
}
#endregion
#region MicrosoftGraph
function Get-MgApplication
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.String]
        $ConsistencyLevel,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgApplicationOwner
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.String]
        $ConsistencyLevel,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgServicePrincipal
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.String]
        $ServicePrincipalId,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.String]
        $ConsistencyLevel,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgServicePrincipalAppRoleAssignment
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $AppRoleAssignmentId,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.String]
        $ServicePrincipalId,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.String]
        $ConsistencyLevel,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function New-MgApplication
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PSObject]
        $OptionalClaims,

        [Parameter()]
        [PSObject]
        $HomeRealmDiscoveryPolicies,

        [Parameter()]
        [PSObject]
        $Spa,

        [Parameter()]
        [PSObject]
        $Synchronization,

        [Parameter()]
        [System.String]
        $DefaultRedirectUri,

        [Parameter()]
        [System.DateTime]
        $CreatedDateTime,

        [Parameter()]
        [System.String]
        $ApplicationTemplateId,

        [Parameter()]
        [System.String]
        $SignInAudience,

        [Parameter()]
        [PSObject]
        $VerifiedPublisher,

        [Parameter()]
        [System.String[]]
        $IdentifierUris,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsDeviceOnlyAuthSupported,

        [Parameter()]
        [System.String]
        $TokenEncryptionKeyId,

        [Parameter()]
        [System.String]
        $UniqueName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [PSObject]
        $TokenIssuancePolicies,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $Api,

        [Parameter()]
        [System.String]
        $PublisherDomain,

        [Parameter()]
        [System.String]
        $GroupMembershipClaims,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String[]]
        $Tags,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [PSObject]
        $Owners,

        [Parameter()]
        [PSObject]
        $FederatedIdentityCredentials,

        [Parameter()]
        [PSObject]
        $TokenLifetimePolicies,

        [Parameter()]
        [PSObject]
        $AppManagementPolicies,

        [Parameter()]
        [System.String]
        $DisabledByMicrosoftStatus,

        [Parameter()]
        [PSObject]
        $PasswordCredentials,

        [Parameter()]
        [PSObject]
        $PublicClient,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [PSObject]
        $RequiredResourceAccess,

        [Parameter()]
        [PSObject]
        $ParentalControlSettings,

        [Parameter()]
        [PSObject]
        $Web,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsFallbackPublicClient,

        [Parameter()]
        [PSObject]
        $AddIns,

        [Parameter()]
        [System.DateTime]
        $DeletedDateTime,

        [Parameter()]
        [PSObject]
        $RequestSignatureVerification,

        [Parameter()]
        [System.String]
        $LogoInputFile,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [PSObject]
        $AppRoles,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.String]
        $ServiceManagementReference,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [PSObject]
        $ExtensionProperties,

        [Parameter()]
        [PSObject]
        $Windows,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [PSObject]
        $ConnectorGroup,

        [Parameter()]
        [PSObject]
        $CreatedOnBehalfOf,

        [Parameter()]
        [PSObject]
        $KeyCredentials,

        [Parameter()]
        [PSObject]
        $Certification,

        [Parameter()]
        [PSObject]
        $OnPremisesPublishing,

        [Parameter()]
        [System.String]
        $SamlMetadataUrl,

        [Parameter()]
        [PSObject]
        $Info,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Oauth2RequirePostResponse,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $AppId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
function New-MgApplicationOwnerByRef
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.String]
        $OdataId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
function New-MgServicePrincipal
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $ServicePrincipalNames,

        [Parameter()]
        [System.String[]]
        $AlternativeNames,

        [Parameter()]
        [System.String]
        $AppDescription,

        [Parameter()]
        [PSObject]
        $HomeRealmDiscoveryPolicies,

        [Parameter()]
        [PSObject]
        $Oauth2PermissionScopes,

        [Parameter()]
        [PSObject]
        $Synchronization,

        [Parameter()]
        [PSObject]
        $AppRoleAssignments,

        [Parameter()]
        [PSObject]
        $LicenseDetails,

        [Parameter()]
        [System.String]
        $SignInAudience,

        [Parameter()]
        [System.String]
        $PublisherName,

        [Parameter()]
        [PSObject]
        $VerifiedPublisher,

        [Parameter()]
        [System.String[]]
        $NotificationEmailAddresses,

        [Parameter()]
        [PSObject]
        $ClaimsMappingPolicies,

        [Parameter()]
        [System.String]
        $TokenEncryptionKeyId,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DisabledByMicrosoftStatus,

        [Parameter()]
        [PSObject]
        $TokenIssuancePolicies,

        [Parameter()]
        [System.String]
        $PreferredTokenSigningKeyThumbprint,

        [Parameter()]
        [System.String]
        $AppDisplayName,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $AppRoleAssignedTo,

        [Parameter()]
        [System.String]
        $Homepage,

        [Parameter()]
        [System.String]
        $ServicePrincipalType,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [PSObject]
        $SamlSingleSignOnSettings,

        [Parameter()]
        [System.String[]]
        $Tags,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [PSObject]
        $Owners,

        [Parameter()]
        [PSObject]
        $OwnedObjects,

        [Parameter()]
        [PSObject]
        $FederatedIdentityCredentials,

        [Parameter()]
        [System.String]
        $LoginUrl,

        [Parameter()]
        [PSObject]
        $TokenLifetimePolicies,

        [Parameter()]
        [PSObject]
        $AppManagementPolicies,

        [Parameter()]
        [PSObject]
        $CreatedObjects,

        [Parameter()]
        [System.DateTime]
        $PreferredTokenSigningKeyEndDateTime,

        [Parameter()]
        [System.String]
        $ErrorUrl,

        [Parameter()]
        [PSObject]
        $DelegatedPermissionClassifications,

        [Parameter()]
        [PSObject]
        $PasswordCredentials,

        [Parameter()]
        [PSObject]
        $MemberOf,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [PSObject]
        $PublishedPermissionScopes,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $SamlMetadataUrl,

        [Parameter()]
        [System.DateTime]
        $DeletedDateTime,

        [Parameter()]
        [System.String]
        $AppOwnerOrganizationId,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [PSObject]
        $TransitiveMemberOf,

        [Parameter()]
        [PSObject]
        $AppRoles,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String[]]
        $ReplyUrls,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AppRoleAssignmentRequired,

        [Parameter()]
        [System.String]
        $ApplicationTemplateId,

        [Parameter()]
        [PSObject]
        $KeyCredentials,

        [Parameter()]
        [PSObject]
        $Oauth2PermissionGrants,

        [Parameter()]
        [PSObject]
        $ResourceSpecificApplicationPermissions,

        [Parameter()]
        [PSObject]
        $PasswordSingleSignOnSettings,

        [Parameter()]
        [PSObject]
        $AddIns,

        [Parameter()]
        [PSObject]
        $Info,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AccountEnabled,

        [Parameter()]
        [System.String]
        $PreferredSingleSignOnMode,

        [Parameter()]
        [System.Collections.Hashtable]
        $CustomSecurityAttributes,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [PSObject]
        $Endpoints,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $AppId,

        [Parameter()]
        [System.String]
        $LogoutUrl,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
function Remove-MgApplication
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $IfMatch,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Remove-MgApplicationOwnerByRef
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $IfMatch,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $DirectoryObjectId,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
function Remove-MgServicePrincipal
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $IfMatch,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $ServicePrincipalId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
function Update-MgApplication
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PSObject]
        $OptionalClaims,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [PSObject]
        $HomeRealmDiscoveryPolicies,

        [Parameter()]
        [PSObject]
        $Spa,

        [Parameter()]
        [System.String[]]
        $Tags,

        [Parameter()]
        [System.String]
        $DefaultRedirectUri,

        [Parameter()]
        [System.DateTime]
        $CreatedDateTime,

        [Parameter()]
        [System.String]
        $ApplicationTemplateId,

        [Parameter()]
        [System.String]
        $SignInAudience,

        [Parameter()]
        [PSObject]
        $VerifiedPublisher,

        [Parameter()]
        [System.String[]]
        $IdentifierUris,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsDeviceOnlyAuthSupported,

        [Parameter()]
        [System.String]
        $TokenEncryptionKeyId,

        [Parameter()]
        [System.String]
        $UniqueName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [PSObject]
        $TokenIssuancePolicies,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $Api,

        [Parameter()]
        [System.String]
        $PublisherDomain,

        [Parameter()]
        [System.String]
        $GroupMembershipClaims,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [PSObject]
        $Owners,

        [Parameter()]
        [PSObject]
        $FederatedIdentityCredentials,

        [Parameter()]
        [PSObject]
        $TokenLifetimePolicies,

        [Parameter()]
        [PSObject]
        $AppManagementPolicies,

        [Parameter()]
        [System.String]
        $DisabledByMicrosoftStatus,

        [Parameter()]
        [PSObject]
        $PasswordCredentials,

        [Parameter()]
        [PSObject]
        $PublicClient,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [PSObject]
        $RequiredResourceAccess,

        [Parameter()]
        [PSObject]
        $ParentalControlSettings,

        [Parameter()]
        [PSObject]
        $Web,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsFallbackPublicClient,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [PSObject]
        $Synchronization,

        [Parameter()]
        [System.DateTime]
        $DeletedDateTime,

        [Parameter()]
        [PSObject]
        $RequestSignatureVerification,

        [Parameter()]
        [System.String]
        $LogoInputFile,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [PSObject]
        $AppRoles,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.String]
        $ServiceManagementReference,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [PSObject]
        $ExtensionProperties,

        [Parameter()]
        [PSObject]
        $Windows,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [PSObject]
        $ConnectorGroup,

        [Parameter()]
        [PSObject]
        $AddIns,

        [Parameter()]
        [PSObject]
        $CreatedOnBehalfOf,

        [Parameter()]
        [PSObject]
        $KeyCredentials,

        [Parameter()]
        [PSObject]
        $Certification,

        [Parameter()]
        [PSObject]
        $OnPremisesPublishing,

        [Parameter()]
        [System.String]
        $SamlMetadataUrl,

        [Parameter()]
        [PSObject]
        $Info,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Oauth2RequirePostResponse,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $AppId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
function Update-MgServicePrincipal
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $ServicePrincipalNames,

        [Parameter()]
        [System.String[]]
        $AlternativeNames,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.String]
        $AppDescription,

        [Parameter()]
        [PSObject]
        $HomeRealmDiscoveryPolicies,

        [Parameter()]
        [PSObject]
        $Oauth2PermissionScopes,

        [Parameter()]
        [PSObject]
        $Synchronization,

        [Parameter()]
        [PSObject]
        $AppRoleAssignments,

        [Parameter()]
        [System.String]
        $ServicePrincipalId,

        [Parameter()]
        [PSObject]
        $LicenseDetails,

        [Parameter()]
        [System.String]
        $SignInAudience,

        [Parameter()]
        [System.String]
        $PublisherName,

        [Parameter()]
        [PSObject]
        $VerifiedPublisher,

        [Parameter()]
        [System.String[]]
        $NotificationEmailAddresses,

        [Parameter()]
        [PSObject]
        $ClaimsMappingPolicies,

        [Parameter()]
        [System.String]
        $TokenEncryptionKeyId,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DisabledByMicrosoftStatus,

        [Parameter()]
        [PSObject]
        $TokenIssuancePolicies,

        [Parameter()]
        [System.String]
        $PreferredTokenSigningKeyThumbprint,

        [Parameter()]
        [System.String]
        $AppDisplayName,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $AppRoleAssignedTo,

        [Parameter()]
        [System.String]
        $Homepage,

        [Parameter()]
        [System.String]
        $ServicePrincipalType,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [PSObject]
        $SamlSingleSignOnSettings,

        [Parameter()]
        [System.String[]]
        $Tags,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [PSObject]
        $OwnedObjects,

        [Parameter()]
        [PSObject]
        $FederatedIdentityCredentials,

        [Parameter()]
        [System.String]
        $LoginUrl,

        [Parameter()]
        [PSObject]
        $TokenLifetimePolicies,

        [Parameter()]
        [PSObject]
        $AppManagementPolicies,

        [Parameter()]
        [System.DateTime]
        $PreferredTokenSigningKeyEndDateTime,

        [Parameter()]
        [System.String]
        $ErrorUrl,

        [Parameter()]
        [PSObject]
        $DelegatedPermissionClassifications,

        [Parameter()]
        [PSObject]
        $PasswordCredentials,

        [Parameter()]
        [PSObject]
        $MemberOf,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [PSObject]
        $PublishedPermissionScopes,

        [Parameter()]
        [PSObject]
        $Endpoints,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [PSObject]
        $AddIns,

        [Parameter()]
        [System.DateTime]
        $DeletedDateTime,

        [Parameter()]
        [System.String]
        $AppOwnerOrganizationId,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [PSObject]
        $TransitiveMemberOf,

        [Parameter()]
        [PSObject]
        $AppRoles,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $AppId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String[]]
        $ReplyUrls,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AppRoleAssignmentRequired,

        [Parameter()]
        [System.String]
        $ApplicationTemplateId,

        [Parameter()]
        [PSObject]
        $KeyCredentials,

        [Parameter()]
        [PSObject]
        $Oauth2PermissionGrants,

        [Parameter()]
        [PSObject]
        $ResourceSpecificApplicationPermissions,

        [Parameter()]
        [PSObject]
        $PasswordSingleSignOnSettings,

        [Parameter()]
        [System.String]
        $SamlMetadataUrl,

        [Parameter()]
        [PSObject]
        $Info,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AccountEnabled,

        [Parameter()]
        [System.String]
        $PreferredSingleSignOnMode,

        [Parameter()]
        [PSObject]
        $Owners,

        [Parameter()]
        [System.Collections.Hashtable]
        $CustomSecurityAttributes,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [PSObject]
        $CreatedObjects,

        [Parameter()]
        [System.String]
        $LogoutUrl,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
#endregion
#region MicrosoftGraph
function Get-MgContext
{
    [CmdletBinding()]
    param(

    )
}
function Invoke-MgGraphRequest
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $InputFilePath,

        [Parameter()]
        [System.String]
        $StatusCodeVariable,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Authentication.Models.OutputType]
        $OutputType,

        [Parameter()]
        [System.Security.SecureString]
        $Token,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $SkipHttpErrorCheck,

        [Parameter()]
        [System.String]
        $UserAgent,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Authentication.Models.GraphRequestAuthenticationType]
        $Authentication,

        [Parameter()]
        [System.Uri]
        $Uri,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Authentication.Helpers.GraphRequestSession]
        $GraphRequestSession,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $InferOutputFileName,

        [Parameter()]
        [System.String]
        $OutputFilePath,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Authentication.Models.GraphRequestMethod]
        $Method,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.Object]
        $Body,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $SkipHeaderValidation,

        [Parameter()]
        [System.String]
        $ResponseHeadersVariable,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String]
        $SessionVariable,

        [Parameter()]
        [System.String]
        $ContentType,

        [Parameter()]
        [System.Collections.IDictionary]
        $Headers
    )
}
function Select-MgProfile
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm
    )
}
#endregion
#region MicrosoftGraph
function Get-MgDeviceManagement
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
function Get-MgDeviceManagementDeviceCategory
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [System.String]
        $DeviceCategoryId,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgDeviceManagementDeviceCompliancePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.String]
        $DeviceCompliancePolicyId
    )
}
function Get-MgDeviceManagementDeviceConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.String]
        $DeviceConfigurationId,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function New-MgDeviceManagementDeviceCategory
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
function New-MgDeviceManagementDeviceCompliancePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PSObject]
        $UserStatuses,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.DateTime]
        $LastModifiedDateTime,

        [Parameter()]
        [PSObject]
        $Assignments,

        [Parameter()]
        [System.DateTime]
        $CreatedDateTime,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [PSObject]
        $DeviceStatusOverview,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [PSObject]
        $UserStatusOverview,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Version,

        [Parameter()]
        [PSObject]
        $DeviceStatuses,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [PSObject]
        $ScheduledActionsForRule,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [PSObject]
        $DeviceSettingStateSummaries,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function New-MgDeviceManagementDeviceConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PSObject]
        $UserStatuses,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.DateTime]
        $LastModifiedDateTime,

        [Parameter()]
        [PSObject]
        $Assignments,

        [Parameter()]
        [System.DateTime]
        $CreatedDateTime,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [PSObject]
        $DeviceStatuses,

        [Parameter()]
        [PSObject]
        $DeviceStatusOverview,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [PSObject]
        $DeviceManagementApplicabilityRuleOSVersion,

        [Parameter()]
        [PSObject]
        $UserStatusOverview,

        [Parameter()]
        [PSObject]
        $GroupAssignments,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Version,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [PSObject]
        $DeviceSettingStateSummaries,

        [Parameter()]
        [PSObject]
        $DeviceManagementApplicabilityRuleDeviceMode,

        [Parameter()]
        [PSObject]
        $DeviceManagementApplicabilityRuleOSEdition,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Remove-MgDeviceManagementDeviceCategory
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $DeviceCategoryId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $IfMatch,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
function Remove-MgDeviceManagementDeviceCompliancePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $DeviceCompliancePolicyId,

        [Parameter()]
        [System.String]
        $IfMatch,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Remove-MgDeviceManagementDeviceConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $IfMatch,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $DeviceConfigurationId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Update-MgDeviceManagement
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PSObject]
        $TermsAndConditions,

        [Parameter()]
        [PSObject]
        $AndroidForWorkSettings,

        [Parameter()]
        [PSObject]
        $MicrosoftTunnelHealthThresholds,

        [Parameter()]
        [PSObject]
        $RoleScopeTags,

        [Parameter()]
        [PSObject]
        $ExchangeConnectors,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [PSObject]
        $GroupPolicyObjectFiles,

        [Parameter()]
        [PSObject]
        $WindowsAutopilotDeploymentProfiles,

        [Parameter()]
        [PSObject]
        $ResourceOperations,

        [Parameter()]
        [PSObject]
        $ConfigManagerCollections,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsBatteryHealthDevicePerformance,

        [Parameter()]
        [PSObject]
        $ZebraFotaConnector,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsDevicesWithoutCloudIdentity,

        [Parameter()]
        [PSObject]
        $VirtualEndpoint,

        [Parameter()]
        [PSObject]
        $ConfigurationCategories,

        [Parameter()]
        [PSObject]
        $ManagedDeviceEncryptionStates,

        [Parameter()]
        [PSObject]
        $MicrosoftTunnelSites,

        [Parameter()]
        [PSObject]
        $DeviceEnrollmentConfigurations,

        [Parameter()]
        [PSObject]
        $ExchangeOnPremisesPolicy,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsBatteryHealthAppImpact,

        [Parameter()]
        [PSObject]
        $WindowsInformationProtectionAppLearningSummaries,

        [Parameter()]
        [PSObject]
        $AndroidDeviceOwnerEnrollmentProfiles,

        [Parameter()]
        [PSObject]
        $ReusableSettings,

        [Parameter()]
        [PSObject]
        $GroupPolicyMigrationReports,

        [Parameter()]
        [PSObject]
        $WindowsInformationProtectionNetworkLearningSummaries,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsAppHealthApplicationPerformanceByAppVersionDeviceId,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsMetricHistory,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsWorkFromAnywhereMetrics,

        [Parameter()]
        [PSObject]
        $EmbeddedSimActivationCodePools,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsModelScores,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [PSObject]
        $CompliancePolicies,

        [Parameter()]
        [PSObject]
        $MobileThreatDefenseConnectors,

        [Parameter()]
        [PSObject]
        $ImportedWindowsAutopilotDeviceIdentities,

        [Parameter()]
        [PSObject]
        $DataProcessorServiceForWindowsFeaturesOnboarding,

        [Parameter()]
        [PSObject]
        $DeviceProtectionOverview,

        [Parameter()]
        [PSObject]
        $DepOnboardingSettings,

        [Parameter()]
        [PSObject]
        $GroupPolicyDefinitionFiles,

        [Parameter()]
        [PSObject]
        $RoleAssignments,

        [Parameter()]
        [PSObject]
        $WindowsDriverUpdateProfiles,

        [Parameter()]
        [PSObject]
        $CartToClassAssociations,

        [Parameter()]
        [PSObject]
        $DeviceManagementScripts,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.DeviceManagementSubscriptionState]
        $SubscriptionState,

        [Parameter()]
        [PSObject]
        $WindowsMalwareInformation,

        [Parameter()]
        [PSObject]
        $GroupPolicyDefinitions,

        [Parameter()]
        [PSObject]
        $DetectedApps,

        [Parameter()]
        [PSObject]
        $AdvancedThreatProtectionOnboardingStateSummary,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsDeviceScopes,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsBaselines,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsScoreHistory,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsAppHealthApplicationPerformance,

        [Parameter()]
        [System.DateTime]
        $AccountMoveCompletionDateTime,

        [Parameter()]
        [PSObject]
        $Reports,

        [Parameter()]
        [PSObject]
        $ConfigurationPolicies,

        [Parameter()]
        [PSObject]
        $AndroidManagedStoreAccountEnterpriseSettings,

        [Parameter()]
        [PSObject]
        $DeviceConfigurations,

        [Parameter()]
        [PSObject]
        $RemoteAssistanceSettings,

        [Parameter()]
        [PSObject]
        $CertificateConnectorDetails,

        [Parameter()]
        [PSObject]
        $AuditEvents,

        [Parameter()]
        [PSObject]
        $GroupPolicyConfigurations,

        [Parameter()]
        [System.Collections.Hashtable]
        $TenantAttachRbac,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsAppHealthApplicationPerformanceByOSVersion,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsAppHealthOverview,

        [Parameter()]
        [PSObject]
        $WindowsAutopilotSettings,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsBatteryHealthDeviceAppImpact,

        [Parameter()]
        [PSObject]
        $ConfigurationPolicyTemplates,

        [Parameter()]
        [PSObject]
        $DeviceShellScripts,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsDeviceMetricHistory,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsAppHealthOSVersionPerformance,

        [Parameter()]
        [PSObject]
        $RemoteAssistancePartners,

        [Parameter()]
        [PSObject]
        $AutopilotEvents,

        [Parameter()]
        [PSObject]
        $ComplianceManagementPartners,

        [Parameter()]
        [PSObject]
        $TroubleshootingEvents,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsBatteryHealthCapacityDetails,

        [Parameter()]
        [PSObject]
        $ManagedDeviceOverview,

        [Parameter()]
        [PSObject]
        $GroupPolicyUploadedDefinitionFiles,

        [Parameter()]
        [PSObject]
        $DeviceManagementPartners,

        [Parameter()]
        [PSObject]
        $AndroidManagedStoreAppConfigurationSchemas,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsResourcePerformance,

        [Parameter()]
        [PSObject]
        $MacOSSoftwareUpdateAccountSummaries,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsWorkFromAnywhereModelPerformance,

        [Parameter()]
        [PSObject]
        $ComplianceCategories,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [PSObject]
        $DeviceConfigurationConflictSummary,

        [Parameter()]
        [PSObject]
        $TelecomExpenseManagementPartners,

        [Parameter()]
        [PSObject]
        $Templates,

        [Parameter()]
        [PSObject]
        $MicrosoftTunnelConfigurations,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [PSObject]
        $WindowsMalwareOverview,

        [Parameter()]
        [PSObject]
        $ResourceAccessProfiles,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsBatteryHealthDeviceRuntimeHistory,

        [Parameter()]
        [PSObject]
        $Intents,

        [Parameter()]
        [PSObject]
        $WindowsFeatureUpdateProfiles,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsBatteryHealthRuntimeDetails,

        [Parameter()]
        [PSObject]
        $ComplianceSettings,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsDeviceScores,

        [Parameter()]
        [System.String]
        $IntuneAccountId,

        [Parameter()]
        [PSObject]
        $ConditionalAccessSettings,

        [Parameter()]
        [PSObject]
        $IosUpdateStatuses,

        [Parameter()]
        [PSObject]
        $ZebraFotaDeployments,

        [Parameter()]
        [PSObject]
        $CloudPcConnectivityIssues,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsImpactingProcess,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsDeviceStartupHistory,

        [Parameter()]
        [PSObject]
        $DerivedCredentials,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsBatteryHealthModelPerformance,

        [Parameter()]
        [PSObject]
        $DeviceCompliancePolicies,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [PSObject]
        $AndroidForWorkAppConfigurationSchemas,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [PSObject]
        $SettingDefinitions,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsSettings,

        [Parameter()]
        [PSObject]
        $ManagedDevices,

        [Parameter()]
        [PSObject]
        $AppleUserInitiatedEnrollmentProfiles,

        [Parameter()]
        [PSObject]
        $DeviceConfigurationDeviceStateSummaries,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsWorkFromAnywhereHardwareReadinessMetric,

        [Parameter()]
        [PSObject]
        $ReusablePolicySettings,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsAppHealthApplicationPerformanceByAppVersionDetails,

        [Parameter()]
        [PSObject]
        $OemWarrantyInformationOnboarding,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsRemoteConnection,

        [Parameter()]
        [PSObject]
        $ConfigurationSettings,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsDeviceScope,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsNotAutopilotReadyDevice,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsCategories,

        [Parameter()]
        [PSObject]
        $DeviceConfigurationRestrictedAppsViolations,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsDeviceStartupProcesses,

        [Parameter()]
        [PSObject]
        $MobileAppTroubleshootingEvents,

        [Parameter()]
        [PSObject]
        $OrganizationalMessageGuidedContents,

        [Parameter()]
        [PSObject]
        $ChromeOSOnboardingSettings,

        [Parameter()]
        [PSObject]
        $RoleDefinitions,

        [Parameter()]
        [PSObject]
        $ApplePushNotificationCertificate,

        [Parameter()]
        [PSObject]
        $DeviceCategories,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsAppHealthApplicationPerformanceByAppVersion,

        [Parameter()]
        [PSObject]
        $DeviceCompliancePolicySettingStateSummaries,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [PSObject]
        $AndroidForWorkEnrollmentProfiles,

        [Parameter()]
        [PSObject]
        $ComanagementEligibleDevices,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsRegressionSummary,

        [Parameter()]
        [PSObject]
        $NotificationMessageTemplates,

        [Parameter()]
        [PSObject]
        $IntuneBrand,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsOverview,

        [Parameter()]
        [PSObject]
        $TemplateSettings,

        [Parameter()]
        [PSObject]
        $RemoteActionAudits,

        [Parameter()]
        [PSObject]
        $WindowsUpdateCatalogItems,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsAppHealthDevicePerformanceDetails,

        [Parameter()]
        [PSObject]
        $AdminConsent,

        [Parameter()]
        [PSObject]
        $Monitoring,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [PSObject]
        $DeviceHealthScripts,

        [Parameter()]
        [PSObject]
        $ComanagedDevices,

        [Parameter()]
        [PSObject]
        $GroupPolicyCategories,

        [Parameter()]
        [PSObject]
        $DeviceConfigurationUserStateSummaries,

        [Parameter()]
        [PSObject]
        $DeviceConfigurationsAllManagedDeviceCertificateStates,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsAppHealthDevicePerformance,

        [Parameter()]
        [PSObject]
        $OrganizationalMessageDetails,

        [Parameter()]
        [PSObject]
        $DeviceCustomAttributeShellScripts,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsAppHealthDeviceModelPerformance,

        [Parameter()]
        [PSObject]
        $ZebraFotaArtifacts,

        [Parameter()]
        [PSObject]
        $ImportedDeviceIdentities,

        [Parameter()]
        [System.Int32]
        $MaximumDepTokens,

        [Parameter()]
        [PSObject]
        $SoftwareUpdateStatusSummary,

        [Parameter()]
        [PSObject]
        $WindowsQualityUpdateProfiles,

        [Parameter()]
        [PSObject]
        $AssignmentFilters,

        [Parameter()]
        [PSObject]
        $NdesConnectors,

        [Parameter()]
        [PSObject]
        $MicrosoftTunnelServerLogCollectionResponses,

        [Parameter()]
        [PSObject]
        $Settings,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsBatteryHealthOSPerformance,

        [Parameter()]
        [PSObject]
        $UserPfxCertificates,

        [Parameter()]
        [PSObject]
        $WindowsAutopilotDeviceIdentities,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsDeviceStartupProcessPerformance,

        [Parameter()]
        [PSObject]
        $IntuneBrandingProfiles,

        [Parameter()]
        [PSObject]
        $DomainJoinConnectors,

        [Parameter()]
        [PSObject]
        $Categories,

        [Parameter()]
        [PSObject]
        $ExchangeOnPremisesPolicies,

        [Parameter()]
        [PSObject]
        $DeviceCompliancePolicyDeviceStateSummary,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $UserExperienceAnalyticsDevicePerformance,

        [Parameter()]
        [PSObject]
        $DeviceComplianceScripts,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.DeviceManagementSubscriptions]
        $Subscriptions,

        [Parameter()]
        [PSObject]
        $ManagedDeviceCleanupSettings,

        [Parameter()]
        [PSObject]
        $DataSharingConsents
    )
}
function Update-MgDeviceManagementDeviceCategory
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $DeviceCategoryId,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Update-MgDeviceManagementDeviceCompliancePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PSObject]
        $UserStatuses,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.DateTime]
        $LastModifiedDateTime,

        [Parameter()]
        [PSObject]
        $Assignments,

        [Parameter()]
        [System.DateTime]
        $CreatedDateTime,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $DeviceCompliancePolicyId,

        [Parameter()]
        [PSObject]
        $DeviceStatusOverview,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [PSObject]
        $UserStatusOverview,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Version,

        [Parameter()]
        [PSObject]
        $DeviceStatuses,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [PSObject]
        $ScheduledActionsForRule,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [PSObject]
        $DeviceSettingStateSummaries,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Update-MgDeviceManagementDeviceConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PSObject]
        $UserStatuses,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.DateTime]
        $LastModifiedDateTime,

        [Parameter()]
        [PSObject]
        $Assignments,

        [Parameter()]
        [System.DateTime]
        $CreatedDateTime,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [PSObject]
        $DeviceStatuses,

        [Parameter()]
        [PSObject]
        $DeviceStatusOverview,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [PSObject]
        $DeviceManagementApplicabilityRuleOSVersion,

        [Parameter()]
        [PSObject]
        $UserStatusOverview,

        [Parameter()]
        [PSObject]
        $GroupAssignments,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Version,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [PSObject]
        $DeviceSettingStateSummaries,

        [Parameter()]
        [System.String]
        $DeviceConfigurationId,

        [Parameter()]
        [PSObject]
        $DeviceManagementApplicabilityRuleOSEdition,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [PSObject]
        $DeviceManagementApplicabilityRuleDeviceMode,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgDeviceManagementAssignmentFilter
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.String]
        $DeviceAndAppManagementAssignmentFilterId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgDeviceManagementConfigurationPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [System.String]
        $DeviceManagementConfigurationPolicyId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgDeviceManagementConfigurationPolicyAssignment
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.String]
        $DeviceManagementConfigurationPolicyId,

        [Parameter()]
        [System.String]
        $DeviceManagementConfigurationPolicyAssignmentId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgDeviceManagementConfigurationPolicySetting
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $DeviceManagementConfigurationSettingId,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.String]
        $DeviceManagementConfigurationPolicyId,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgDeviceManagementConfigurationPolicyTemplate
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.String]
        $DeviceManagementConfigurationPolicyTemplateId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgDeviceManagementConfigurationSetting
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.String]
        $DeviceManagementConfigurationSettingDefinitionId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgDeviceManagementIntent
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.String]
        $DeviceManagementIntentId,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgDeviceManagementIntentSetting
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $DeviceManagementSettingInstanceId,

        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.String]
        $DeviceManagementIntentId,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function New-MgDeviceManagementAssignmentFilter
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.DateTime]
        $LastModifiedDateTime,

        [Parameter()]
        [System.DateTime]
        $CreatedDateTime,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String[]]
        $RoleScopeTags,

        [Parameter()]
        [System.String]
        $Rule,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.DevicePlatformType]
        $Platform,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function New-MgDeviceManagementConfigurationPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.DateTime]
        $LastModifiedDateTime,

        [Parameter()]
        [PSObject]
        $Assignments,

        [Parameter()]
        [System.DateTime]
        $CreatedDateTime,

        [Parameter()]
        [PSObject]
        $Settings,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [PSObject]
        $TemplateReference,

        [Parameter()]
        [System.Int32]
        $SettingCount,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.DeviceManagementConfigurationPlatforms]
        $Platforms,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.DeviceManagementConfigurationTechnologies]
        $Technologies,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $CreationSource,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function New-MgDeviceManagementIntent
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.DateTime]
        $LastModifiedDateTime,

        [Parameter()]
        [PSObject]
        $Assignments,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [PSObject]
        $Settings,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsAssigned,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.String]
        $TemplateId,

        [Parameter()]
        [PSObject]
        $DeviceSettingStateSummaries,

        [Parameter()]
        [PSObject]
        $DeviceStates,

        [Parameter()]
        [PSObject]
        $Categories,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [PSObject]
        $DeviceStateSummary,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [PSObject]
        $UserStates,

        [Parameter()]
        [PSObject]
        $UserStateSummary,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Remove-MgDeviceManagementAssignmentFilter
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $IfMatch,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $DeviceAndAppManagementAssignmentFilterId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Remove-MgDeviceManagementConfigurationPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $DeviceManagementConfigurationPolicyId,

        [Parameter()]
        [System.String]
        $IfMatch,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Remove-MgDeviceManagementIntent
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $IfMatch,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $DeviceManagementIntentId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Update-MgDeviceManagementAssignmentFilter
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.DateTime]
        $LastModifiedDateTime,

        [Parameter()]
        [System.DateTime]
        $CreatedDateTime,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String[]]
        $RoleScopeTags,

        [Parameter()]
        [System.String]
        $Rule,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.DevicePlatformType]
        $Platform,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $DeviceAndAppManagementAssignmentFilterId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Update-MgDeviceManagementConfigurationPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.DateTime]
        $LastModifiedDateTime,

        [Parameter()]
        [PSObject]
        $Assignments,

        [Parameter()]
        [System.DateTime]
        $CreatedDateTime,

        [Parameter()]
        [PSObject]
        $Settings,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [PSObject]
        $TemplateReference,

        [Parameter()]
        [System.Int32]
        $SettingCount,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.DeviceManagementConfigurationTechnologies]
        $Technologies,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.DeviceManagementConfigurationPlatforms]
        $Platforms,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $CreationSource,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String]
        $DeviceManagementConfigurationPolicyId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Update-MgDeviceManagementConfigurationPolicyAssignment
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PSObject]
        $Target,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $SourceId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.DeviceAndAppManagementAssignmentSource]
        $Source,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $DeviceManagementConfigurationPolicyId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String]
        $DeviceManagementConfigurationPolicyAssignmentId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Update-MgDeviceManagementIntent
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.DateTime]
        $LastModifiedDateTime,

        [Parameter()]
        [PSObject]
        $Assignments,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [PSObject]
        $Settings,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsAssigned,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.String]
        $TemplateId,

        [Parameter()]
        [PSObject]
        $DeviceSettingStateSummaries,

        [Parameter()]
        [PSObject]
        $DeviceStates,

        [Parameter()]
        [PSObject]
        $Categories,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [PSObject]
        $DeviceStateSummary,

        [Parameter()]
        [System.String]
        $DeviceManagementIntentId,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [PSObject]
        $UserStates,

        [Parameter()]
        [PSObject]
        $UserStateSummary,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Update-MgDeviceManagementIntentSetting
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $DeviceManagementSettingInstanceId,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.String]
        $ValueJson,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.String]
        $DeviceManagementIntentId,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $DefinitionId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
#endregion
#region MicrosoftGraph
#endregion
#region MicrosoftGraph
function Get-MgDeviceManagementDeviceEnrollmentConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.String]
        $DeviceEnrollmentConfigurationId,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgRoleManagement
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
function Get-MgRoleManagementDirectory
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
function Get-MgRoleManagementDirectoryRoleAssignment
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $UnifiedRoleAssignmentId,

        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgRoleManagementDirectoryRoleDefinition
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [System.String]
        $UnifiedRoleDefinitionId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function New-MgDeviceManagementDeviceEnrollmentConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.DateTime]
        $LastModifiedDateTime,

        [Parameter()]
        [PSObject]
        $Assignments,

        [Parameter()]
        [System.DateTime]
        $CreatedDateTime,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $Priority,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Version,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.DeviceEnrollmentConfigurationType]
        $DeviceEnrollmentConfigurationType,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function New-MgRoleManagementDirectoryRoleAssignment
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PSObject]
        $Principal,

        [Parameter()]
        [System.String]
        $ResourceScope,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [PSObject]
        $DirectoryScope,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.String]
        $PrincipalId,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Condition,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $RoleDefinitionId,

        [Parameter()]
        [PSObject]
        $RoleDefinition,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [PSObject]
        $AppScope,

        [Parameter()]
        [System.String]
        $DirectoryScopeId,

        [Parameter()]
        [System.String]
        $PrincipalOrganizationId,

        [Parameter()]
        [System.String]
        $AppScopeId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function New-MgRoleManagementDirectoryRoleDefinition
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $ResourceScopes,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $TemplateId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.String]
        $Version,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsBuiltIn,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [PSObject]
        $InheritsPermissionsFrom,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [PSObject]
        $RolePermissions,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsEnabled,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Remove-MgDeviceManagementDeviceEnrollmentConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $IfMatch,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $DeviceEnrollmentConfigurationId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Remove-MgRoleManagementDirectory
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $IfMatch,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Remove-MgRoleManagementDirectoryRoleAssignment
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $UnifiedRoleAssignmentId,

        [Parameter()]
        [System.String]
        $IfMatch,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Remove-MgRoleManagementDirectoryRoleDefinition
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $UnifiedRoleDefinitionId,

        [Parameter()]
        [System.String]
        $IfMatch,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Update-MgDeviceManagementDeviceEnrollmentConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.DateTime]
        $LastModifiedDateTime,

        [Parameter()]
        [PSObject]
        $Assignments,

        [Parameter()]
        [System.DateTime]
        $CreatedDateTime,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $Priority,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Version,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $DeviceEnrollmentConfigurationId,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.DeviceEnrollmentConfigurationType]
        $DeviceEnrollmentConfigurationType,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Update-MgRoleManagement
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [PSObject]
        $DeviceManagement,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [PSObject]
        $EntitlementManagement,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [PSObject]
        $Directory,

        [Parameter()]
        [PSObject]
        $CloudPc,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties
    )
}
function Update-MgRoleManagementDirectory
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PSObject]
        $RoleAssignmentScheduleRequests,

        [Parameter()]
        [PSObject]
        $TransitiveRoleAssignments,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [PSObject]
        $RoleEligibilitySchedules,

        [Parameter()]
        [PSObject]
        $ResourceNamespaces,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [PSObject]
        $RoleDefinitions,

        [Parameter()]
        [PSObject]
        $RoleEligibilityScheduleInstances,

        [Parameter()]
        [PSObject]
        $RoleEligibilityScheduleRequests,

        [Parameter()]
        [PSObject]
        $RoleAssignmentSchedules,

        [Parameter()]
        [PSObject]
        $RoleAssignments,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [PSObject]
        $RoleAssignmentScheduleInstances,

        [Parameter()]
        [PSObject]
        $RoleAssignmentApprovals,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Update-MgRoleManagementDirectoryRoleDefinition
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $ResourceScopes,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.String]
        $UnifiedRoleDefinitionId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.String]
        $Version,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsBuiltIn,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [PSObject]
        $InheritsPermissionsFrom,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [PSObject]
        $RolePermissions,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $TemplateId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
#endregion
#region MicrosoftGraph
function Invoke-MgTargetDeviceAppMgtTargetedManagedAppConfigurationApp
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.TargetedManagedAppGroupType]
        $AppGroupType,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [PSObject]
        $Apps,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $TargetedManagedAppConfigurationId,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
function New-MgDeviceAppMgtAndroidManagedAppProtection
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppRemediationAction]
        $AppActionIfDevicePasscodeComplexityLessThanHigh,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $DisableAppPinIfDevicePinIsSet,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppDeviceThreatLevel]
        $MaximumAllowedDeviceThreatLevel,

        [Parameter()]
        [System.String]
        $CustomBrowserDisplayName,

        [Parameter()]
        [System.String]
        $MinimumRequiredPatchVersion,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppRemediationAction]
        $AppActionIfAndroidDeviceModelNotAllowed,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $DisableAppEncryptionIfDeviceEncryptionIsEnabled,

        [Parameter()]
        [System.Int32]
        $MinimumPinLength,

        [Parameter()]
        [System.DateTime]
        $CreatedDateTime,

        [Parameter()]
        [System.String]
        $MinimumWarningAppVersion,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedBrowserType]
        $ManagedBrowser,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.TimeSpan]
        $PeriodOnlineBeforeAccessCheck,

        [Parameter()]
        [System.Int32]
        $PreviousPinBlockCount,

        [Parameter()]
        [System.String]
        $MaximumWarningOSVersion,

        [Parameter()]
        [System.TimeSpan]
        $PeriodBeforePinReset,

        [Parameter()]
        [System.String]
        $MinimumWarningCompanyPortalVersion,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RequireClass3Biometrics,

        [Parameter()]
        [System.String]
        $MinimumWarningPatchVersion,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppRemediationAction]
        $AppActionIfDeviceComplianceRequired,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $SaveAsBlocked,

        [Parameter()]
        [System.String]
        $CustomDialerAppDisplayName,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppDataIngestionLocation[]]
        $AllowedDataIngestionLocations,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Int32]
        $DeployedAppCount,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppNotificationRestriction]
        $NotificationRestriction,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $CustomBrowserPackageId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $BiometricAuthenticationBlocked,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppRemediationAction]
        $AppActionIfDevicePasscodeComplexityLessThanMedium,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $DeviceComplianceRequired,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.TargetedManagedAppGroupType]
        $AppGroupType,

        [Parameter()]
        [System.TimeSpan]
        $PeriodOfflineBeforeAccessCheck,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppRemediationAction]
        $AppActionIfUnableToAuthenticateUser,

        [Parameter()]
        [System.String]
        $MinimumRequiredOSVersion,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RequirePinAfterBiometricChange,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $DataBackupBlocked,

        [Parameter()]
        [System.String]
        $MaximumRequiredOSVersion,

        [Parameter()]
        [System.String]
        $MinimumWipePatchVersion,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ContactSyncBlocked,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppClipboardSharingLevel]
        $AllowedOutboundClipboardSharingLevel,

        [Parameter()]
        [System.Int32]
        $MaximumPinRetries,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.AndroidManagedAppSafetyNetAppsVerificationType]
        $RequiredAndroidSafetyNetAppsVerificationType,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppRemediationAction]
        $AppActionIfMaximumPinRetriesExceeded,

        [Parameter()]
        [System.String]
        $MinimumWipeCompanyPortalVersion,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppDataTransferLevel]
        $AllowedOutboundDataTransferDestinations,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppRemediationAction]
        $AppActionIfAndroidDeviceManufacturerNotAllowed,

        [Parameter()]
        [System.String]
        $MinimumWipeAppVersion,

        [Parameter()]
        [System.String]
        $AllowedAndroidDeviceManufacturers,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $OrganizationalCredentialsRequired,

        [Parameter()]
        [System.String]
        $CustomDialerAppPackageId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppDataStorageLocation[]]
        $AllowedDataStorageLocations,

        [Parameter()]
        [System.Int32]
        $BlockAfterCompanyPortalUpdateDeferralInDays,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsAssigned,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppPhoneNumberRedirectLevel]
        $DialerRestrictionLevel,

        [Parameter()]
        [System.Int32]
        $AllowedOutboundClipboardSharingExceptionLength,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppRemediationAction]
        $AppActionIfAndroidSafetyNetDeviceAttestationFailed,

        [Parameter()]
        [System.String]
        $Version,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppRemediationAction]
        $AppActionIfAndroidSafetyNetAppsVerificationFailed,

        [Parameter()]
        [System.String]
        $MinimumWipeOSVersion,

        [Parameter()]
        [PSObject]
        $ApprovedKeyboards,

        [Parameter()]
        [System.TimeSpan]
        $PeriodOfflineBeforeWipeIsEnforced,

        [Parameter()]
        [System.TimeSpan]
        $PinRequiredInsteadOfBiometricTimeout,

        [Parameter()]
        [System.String]
        $MinimumRequiredAppVersion,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppRemediationAction]
        $MobileThreatDefenseRemediationAction,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $KeyboardsRestricted,

        [Parameter()]
        [PSObject]
        $DeploymentSummary,

        [Parameter()]
        [PSObject]
        $Apps,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ScreenCaptureBlocked,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppPinCharacterSet]
        $PinCharacterSet,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ManagedBrowserToOpenLinksRequired,

        [Parameter()]
        [System.String]
        $MaximumWipeOSVersion,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PrintBlocked,

        [Parameter()]
        [System.TimeSpan]
        $GracePeriodToBlockAppsDuringOffClockHours,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $SimplePinBlocked,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $EncryptAppData,

        [Parameter()]
        [System.String]
        $MinimumWarningOSVersion,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ConnectToVpnOnLaunch,

        [Parameter()]
        [System.Int32]
        $WipeAfterCompanyPortalUpdateDeferralInDays,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.AndroidManagedAppSafetyNetEvaluationType]
        $RequiredAndroidSafetyNetEvaluationType,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PinRequired,

        [Parameter()]
        [System.Int32]
        $WarnAfterCompanyPortalUpdateDeferralInDays,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppRemediationAction]
        $AppActionIfDevicePasscodeComplexityLessThanLow,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $FingerprintBlocked,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppRemediationAction]
        $AppActionIfDeviceLockNotSet,

        [Parameter()]
        [System.String]
        $MinimumRequiredCompanyPortalVersion,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $BlockDataIngestionIntoOrganizationDocuments,

        [Parameter()]
        [PSObject]
        $Assignments,

        [Parameter()]
        [System.DateTime]
        $LastModifiedDateTime,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppDataTransferLevel]
        $AllowedInboundDataTransferSources,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.AndroidManagedAppSafetyNetDeviceAttestationType]
        $RequiredAndroidSafetyNetDeviceAttestationType,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $FingerprintAndBiometricEnabled,

        [Parameter()]
        [System.String[]]
        $AllowedAndroidDeviceModels,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $DeviceLockRequired,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [PSObject]
        $ExemptedAppPackages,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.AppManagementLevel]
        $TargetedAppManagementLevels
    )
}
function Set-MgDeviceAppMgtTargetedManagedAppConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [PSObject]
        $Assignments,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $TargetedManagedAppConfigurationId,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
function Update-MgDeviceAppMgt
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PSObject]
        $TargetedManagedAppConfigurations,

        [Parameter()]
        [PSObject]
        $ManagedEBooks,

        [Parameter()]
        [PSObject]
        $MobileApps,

        [Parameter()]
        [PSObject]
        $EnterpriseCodeSigningCertificates,

        [Parameter()]
        [PSObject]
        $ManagedAppPolicies,

        [Parameter()]
        [PSObject]
        $DeviceAppManagementTasks,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [PSObject]
        $ManagedAppStatuses,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $MicrosoftStoreForBusinessLanguage,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [PSObject]
        $ManagedAppRegistrations,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [PSObject]
        $WindowsManagedAppProtections,

        [Parameter()]
        [PSObject]
        $DefaultManagedAppProtections,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsEnabledForMicrosoftStoreForBusiness,

        [Parameter()]
        [PSObject]
        $MobileAppCategories,

        [Parameter()]
        [PSObject]
        $ManagedEBookCategories,

        [Parameter()]
        [System.DateTime]
        $MicrosoftStoreForBusinessLastCompletedApplicationSyncTime,

        [Parameter()]
        [PSObject]
        $SymantecCodeSigningCertificate,

        [Parameter()]
        [PSObject]
        $IosManagedAppProtections,

        [Parameter()]
        [PSObject]
        $IosLobAppProvisioningConfigurations,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [PSObject]
        $WindowsInformationProtectionWipeActions,

        [Parameter()]
        [PSObject]
        $MdmWindowsInformationProtectionPolicies,

        [Parameter()]
        [PSObject]
        $WindowsManagementApp,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [PSObject]
        $SideLoadingKeys,

        [Parameter()]
        [PSObject]
        $PolicySets,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [PSObject]
        $WindowsInformationProtectionDeviceRegistrations,

        [Parameter()]
        [PSObject]
        $VppTokens,

        [Parameter()]
        [PSObject]
        $WindowsInformationProtectionPolicies,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.MicrosoftStoreForBusinessPortalSelectionOptions]
        $MicrosoftStoreForBusinessPortalSelection,

        [Parameter()]
        [PSObject]
        $AndroidManagedAppProtections,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.DateTime]
        $MicrosoftStoreForBusinessLastSuccessfulSyncDateTime,

        [Parameter()]
        [PSObject]
        $MobileAppConfigurations,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [PSObject]
        $WdacSupplementalPolicies
    )
}
function Update-MgDeviceAppMgtAndroidManagedAppProtection
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppRemediationAction]
        $AppActionIfDevicePasscodeComplexityLessThanHigh,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $DisableAppPinIfDevicePinIsSet,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppDeviceThreatLevel]
        $MaximumAllowedDeviceThreatLevel,

        [Parameter()]
        [System.String]
        $CustomBrowserDisplayName,

        [Parameter()]
        [System.String]
        $MinimumRequiredPatchVersion,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppRemediationAction]
        $AppActionIfAndroidDeviceModelNotAllowed,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $DisableAppEncryptionIfDeviceEncryptionIsEnabled,

        [Parameter()]
        [System.Int32]
        $MinimumPinLength,

        [Parameter()]
        [System.DateTime]
        $CreatedDateTime,

        [Parameter()]
        [PSObject]
        $DeploymentSummary,

        [Parameter()]
        [System.String]
        $MinimumWarningAppVersion,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedBrowserType]
        $ManagedBrowser,

        [Parameter()]
        [System.TimeSpan]
        $PeriodOnlineBeforeAccessCheck,

        [Parameter()]
        [System.Int32]
        $PreviousPinBlockCount,

        [Parameter()]
        [System.String]
        $MaximumWarningOSVersion,

        [Parameter()]
        [System.TimeSpan]
        $PeriodBeforePinReset,

        [Parameter()]
        [System.String]
        $MinimumWarningCompanyPortalVersion,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RequireClass3Biometrics,

        [Parameter()]
        [System.String]
        $MinimumWarningPatchVersion,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppRemediationAction]
        $AppActionIfDeviceComplianceRequired,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $SaveAsBlocked,

        [Parameter()]
        [System.String]
        $CustomDialerAppDisplayName,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppDataIngestionLocation[]]
        $AllowedDataIngestionLocations,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Int32]
        $DeployedAppCount,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppNotificationRestriction]
        $NotificationRestriction,

        [Parameter()]
        [System.String]
        $CustomBrowserPackageId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppRemediationAction]
        $AppActionIfDevicePasscodeComplexityLessThanMedium,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.AndroidManagedAppSafetyNetAppsVerificationType]
        $RequiredAndroidSafetyNetAppsVerificationType,

        [Parameter()]
        [PSObject]
        $ApprovedKeyboards,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $DeviceComplianceRequired,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.TargetedManagedAppGroupType]
        $AppGroupType,

        [Parameter()]
        [System.TimeSpan]
        $PeriodOfflineBeforeAccessCheck,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppRemediationAction]
        $AppActionIfUnableToAuthenticateUser,

        [Parameter()]
        [System.String]
        $MinimumRequiredOSVersion,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RequirePinAfterBiometricChange,

        [Parameter()]
        [System.String]
        $MaximumRequiredOSVersion,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ContactSyncBlocked,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppClipboardSharingLevel]
        $AllowedOutboundClipboardSharingLevel,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppRemediationAction]
        $AppActionIfDevicePasscodeComplexityLessThanLow,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppRemediationAction]
        $AppActionIfMaximumPinRetriesExceeded,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.String]
        $MinimumWipeCompanyPortalVersion,

        [Parameter()]
        [System.String]
        $AndroidManagedAppProtectionId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppDataTransferLevel]
        $AllowedOutboundDataTransferDestinations,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppRemediationAction]
        $AppActionIfAndroidDeviceManufacturerNotAllowed,

        [Parameter()]
        [System.String]
        $MinimumWipeAppVersion,

        [Parameter()]
        [System.String]
        $AllowedAndroidDeviceManufacturers,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $OrganizationalCredentialsRequired,

        [Parameter()]
        [System.String]
        $CustomDialerAppPackageId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppDataStorageLocation[]]
        $AllowedDataStorageLocations,

        [Parameter()]
        [System.String]
        $MinimumWipePatchVersion,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsAssigned,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppPhoneNumberRedirectLevel]
        $DialerRestrictionLevel,

        [Parameter()]
        [System.Int32]
        $AllowedOutboundClipboardSharingExceptionLength,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppRemediationAction]
        $AppActionIfAndroidSafetyNetDeviceAttestationFailed,

        [Parameter()]
        [System.String]
        $Version,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppRemediationAction]
        $AppActionIfAndroidSafetyNetAppsVerificationFailed,

        [Parameter()]
        [System.String]
        $MinimumWipeOSVersion,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $DataBackupBlocked,

        [Parameter()]
        [System.TimeSpan]
        $PeriodOfflineBeforeWipeIsEnforced,

        [Parameter()]
        [System.TimeSpan]
        $PinRequiredInsteadOfBiometricTimeout,

        [Parameter()]
        [System.String]
        $MinimumRequiredAppVersion,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppRemediationAction]
        $MobileThreatDefenseRemediationAction,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $BiometricAuthenticationBlocked,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [PSObject]
        $Apps,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ScreenCaptureBlocked,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.AndroidManagedAppSafetyNetDeviceAttestationType]
        $RequiredAndroidSafetyNetDeviceAttestationType,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppPinCharacterSet]
        $PinCharacterSet,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ManagedBrowserToOpenLinksRequired,

        [Parameter()]
        [System.String]
        $MaximumWipeOSVersion,

        [Parameter()]
        [System.TimeSpan]
        $GracePeriodToBlockAppsDuringOffClockHours,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $SimplePinBlocked,

        [Parameter()]
        [System.String]
        $MinimumWarningOSVersion,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $EncryptAppData,

        [Parameter()]
        [System.Int32]
        $MaximumPinRetries,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ConnectToVpnOnLaunch,

        [Parameter()]
        [System.Int32]
        $WipeAfterCompanyPortalUpdateDeferralInDays,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.AppManagementLevel]
        $TargetedAppManagementLevels,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.AndroidManagedAppSafetyNetEvaluationType]
        $RequiredAndroidSafetyNetEvaluationType,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PinRequired,

        [Parameter()]
        [System.Int32]
        $WarnAfterCompanyPortalUpdateDeferralInDays,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppRemediationAction]
        $AppActionIfDeviceLockNotSet,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $FingerprintBlocked,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $MinimumRequiredCompanyPortalVersion,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $BlockDataIngestionIntoOrganizationDocuments,

        [Parameter()]
        [PSObject]
        $Assignments,

        [Parameter()]
        [System.DateTime]
        $LastModifiedDateTime,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.ManagedAppDataTransferLevel]
        $AllowedInboundDataTransferSources,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $KeyboardsRestricted,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $FingerprintAndBiometricEnabled,

        [Parameter()]
        [System.String[]]
        $AllowedAndroidDeviceModels,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PrintBlocked,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $DeviceLockRequired,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [PSObject]
        $ExemptedAppPackages,

        [Parameter()]
        [System.Int32]
        $BlockAfterCompanyPortalUpdateDeferralInDays
    )
}
function Get-MgDeviceAppManagement
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
function Get-MgDeviceAppManagementAndroidManagedAppProtection
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $AndroidManagedAppProtectionId,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgDeviceAppManagementiOSManagedAppProtection
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.String]
        $IosManagedAppProtectionId,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgDeviceAppManagementTargetedManagedAppConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.String]
        $TargetedManagedAppConfigurationId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function New-MgDeviceAppManagementTargetedManagedAppConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Int32]
        $DeployedAppCount,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.DateTime]
        $LastModifiedDateTime,

        [Parameter()]
        [PSObject]
        $Assignments,

        [Parameter()]
        [System.DateTime]
        $CreatedDateTime,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsAssigned,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.String]
        $Version,

        [Parameter()]
        [PSObject]
        $DeploymentSummary,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.TargetedManagedAppGroupType]
        $AppGroupType,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $CustomSettings,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [PSObject]
        $Apps,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Remove-MgDeviceAppManagementAndroidManagedAppProtection
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $IfMatch,

        [Parameter()]
        [System.String]
        $AndroidManagedAppProtectionId,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Remove-MgDeviceAppManagementiOSManagedAppProtection
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $IfMatch,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.String]
        $IosManagedAppProtectionId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Remove-MgDeviceAppManagementTargetedManagedAppConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $TargetedManagedAppConfigurationId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $IfMatch,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
function Update-MgDeviceAppManagement
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.DateTime]
        $MicrosoftStoreForBusinessLastSuccessfulSyncDateTime,

        [Parameter()]
        [PSObject]
        $TargetedManagedAppConfigurations,

        [Parameter()]
        [PSObject]
        $PolicySets,

        [Parameter()]
        [PSObject]
        $ManagedEBooks,

        [Parameter()]
        [PSObject]
        $MobileApps,

        [Parameter()]
        [PSObject]
        $EnterpriseCodeSigningCertificates,

        [Parameter()]
        [PSObject]
        $ManagedAppPolicies,

        [Parameter()]
        [PSObject]
        $DeviceAppManagementTasks,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [PSObject]
        $ManagedAppStatuses,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [PSObject]
        $WindowsManagementApp,

        [Parameter()]
        [PSObject]
        $ManagedAppRegistrations,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [PSObject]
        $WindowsManagedAppProtections,

        [Parameter()]
        [PSObject]
        $DefaultManagedAppProtections,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsEnabledForMicrosoftStoreForBusiness,

        [Parameter()]
        [PSObject]
        $WindowsInformationProtectionWipeActions,

        [Parameter()]
        [System.String]
        $MicrosoftStoreForBusinessLanguage,

        [Parameter()]
        [PSObject]
        $ManagedEBookCategories,

        [Parameter()]
        [System.DateTime]
        $MicrosoftStoreForBusinessLastCompletedApplicationSyncTime,

        [Parameter()]
        [PSObject]
        $SymantecCodeSigningCertificate,

        [Parameter()]
        [PSObject]
        $IosManagedAppProtections,

        [Parameter()]
        [PSObject]
        $IosLobAppProvisioningConfigurations,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [PSObject]
        $MobileAppCategories,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [PSObject]
        $SideLoadingKeys,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [PSObject]
        $WindowsInformationProtectionDeviceRegistrations,

        [Parameter()]
        [PSObject]
        $VppTokens,

        [Parameter()]
        [PSObject]
        $WindowsInformationProtectionPolicies,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.MicrosoftStoreForBusinessPortalSelectionOptions]
        $MicrosoftStoreForBusinessPortalSelection,

        [Parameter()]
        [PSObject]
        $AndroidManagedAppProtections,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [PSObject]
        $MdmWindowsInformationProtectionPolicies,

        [Parameter()]
        [PSObject]
        $MobileAppConfigurations,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [PSObject]
        $WdacSupplementalPolicies
    )
}
function Update-MgDeviceAppManagementTargetedManagedAppConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PSObject]
        $DeploymentSummary,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.DateTime]
        $LastModifiedDateTime,

        [Parameter()]
        [PSObject]
        $Assignments,

        [Parameter()]
        [System.DateTime]
        $CreatedDateTime,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsAssigned,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.String]
        $Version,

        [Parameter()]
        [System.Int32]
        $DeployedAppCount,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.TargetedManagedAppGroupType]
        $AppGroupType,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $CustomSettings,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [PSObject]
        $Apps,

        [Parameter()]
        [System.String]
        $TargetedManagedAppConfigurationId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
#endregion
#region MicrosoftGraph
function Get-MgGroup
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.String]
        $ConsistencyLevel,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgGroupLifecyclePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $GroupLifecyclePolicyId,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgGroupMember
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.String]
        $ConsistencyLevel,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgGroupMemberOf
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.String]
        $ConsistencyLevel,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.String]
        $DirectoryObjectId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgGroupOwner
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.String]
        $ConsistencyLevel,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function New-MgGroup
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $Mail,

        [Parameter()]
        [System.String]
        $Visibility,

        [Parameter()]
        [PSObject]
        $PermissionGrants,

        [Parameter()]
        [System.String]
        $CreatedByAppId,

        [Parameter()]
        [PSObject]
        $Sites,

        [Parameter()]
        [PSObject]
        $AppRoleAssignments,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $SecurityEnabled,

        [Parameter()]
        [PSObject]
        $AssignedLabels,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [PSObject]
        $Calendar,

        [Parameter()]
        [System.String]
        $SecurityIdentifier,

        [Parameter()]
        [PSObject]
        $AssignedLicenses,

        [Parameter()]
        [System.String]
        $OnPremisesSamAccountName,

        [Parameter()]
        [System.DateTime]
        $RenewedDateTime,

        [Parameter()]
        [PSObject]
        $RejectedSenders,

        [Parameter()]
        [PSObject]
        $Extensions,

        [Parameter()]
        [System.String]
        $OrganizationId,

        [Parameter()]
        [System.Int32]
        $UnseenCount,

        [Parameter()]
        [System.String]
        $Classification,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AutoSubscribeNewMembers,

        [Parameter()]
        [System.String]
        $MailNickname,

        [Parameter()]
        [System.String[]]
        $ProxyAddresses,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.DateTime]
        $ExpirationDateTime,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $OnPremisesProvisioningErrors,

        [Parameter()]
        [System.String]
        $OnPremisesSecurityIdentifier,

        [Parameter()]
        [System.String[]]
        $ResourceBehaviorOptions,

        [Parameter()]
        [System.String]
        $PreferredLanguage,

        [Parameter()]
        [PSObject]
        $TransitiveMembers,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $HideFromAddressLists,

        [Parameter()]
        [PSObject]
        $Planner,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.DateTime]
        $OnPremisesLastSyncDateTime,

        [Parameter()]
        [System.Int32]
        $UnseenMessagesCount,

        [Parameter()]
        [PSObject]
        $Owners,

        [Parameter()]
        [PSObject]
        $GroupLifecyclePolicies,

        [Parameter()]
        [PSObject]
        $LicenseProcessingState,

        [Parameter()]
        [System.String]
        $OnPremisesDomainName,

        [Parameter()]
        [PSObject]
        $Settings,

        [Parameter()]
        [PSObject]
        $AcceptedSenders,

        [Parameter()]
        [PSObject]
        $Onenote,

        [Parameter()]
        [System.String]
        $MembershipRuleProcessingState,

        [Parameter()]
        [System.String]
        $AccessType,

        [Parameter()]
        [PSObject]
        $MemberOf,

        [Parameter()]
        [System.String[]]
        $ResourceProvisioningOptions,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $MailEnabled,

        [Parameter()]
        [PSObject]
        $Drives,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowExternalSenders,

        [Parameter()]
        [PSObject]
        $MembersWithLicenseErrors,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [PSObject]
        $WritebackConfiguration,

        [Parameter()]
        [PSObject]
        $Photo,

        [Parameter()]
        [System.String]
        $Theme,

        [Parameter()]
        [PSObject]
        $Events,

        [Parameter()]
        [System.DateTime]
        $DeletedDateTime,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $HasMembersWithLicenseErrors,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsManagementRestricted,

        [Parameter()]
        [PSObject]
        $TransitiveMemberOf,

        [Parameter()]
        [System.String[]]
        $InfoCatalogs,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $OnPremisesSyncEnabled,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsArchived,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsFavorite,

        [Parameter()]
        [PSObject]
        $Drive,

        [Parameter()]
        [System.String]
        $OnPremisesNetBiosName,

        [Parameter()]
        [PSObject]
        $CalendarView,

        [Parameter()]
        [PSObject]
        $Photos,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsAssignableToRole,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $HideFromOutlookClients,

        [Parameter()]
        [PSObject]
        $MembershipRuleProcessingStatus,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsSubscribedByMail,

        [Parameter()]
        [PSObject]
        $CreatedOnBehalfOf,

        [Parameter()]
        [PSObject]
        $Threads,

        [Parameter()]
        [PSObject]
        $Team,

        [Parameter()]
        [PSObject]
        $Members,

        [Parameter()]
        [System.String[]]
        $GroupTypes,

        [Parameter()]
        [System.Int32]
        $UnseenConversationsCount,

        [Parameter()]
        [System.String]
        $MembershipRule,

        [Parameter()]
        [System.String]
        $PreferredDataLocation,

        [Parameter()]
        [System.DateTime]
        $CreatedDateTime,

        [Parameter()]
        [PSObject]
        $Conversations,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [PSObject]
        $Endpoints,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
function New-MgGroupLifecyclePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $AlternateNotificationEmails,

        [Parameter()]
        [System.String]
        $ManagedGroupTypes,

        [Parameter()]
        [System.Int32]
        $GroupLifetimeInDays,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function New-MgGroupMember
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $DirectoryObjectId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
function New-MgGroupMemberByRef
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.String]
        $OdataId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
function New-MgGroupOwner
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $DirectoryObjectId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
function New-MgGroupOwnerByRef
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.String]
        $OdataId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
function Remove-MgGroup
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $IfMatch,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
function Remove-MgGroupLifecyclePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $GroupLifecyclePolicyId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $IfMatch,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Remove-MgGroupMemberByRef
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter()]
        [System.String]
        $IfMatch,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $DirectoryObjectId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
function Remove-MgGroupOwnerByRef
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter()]
        [System.String]
        $IfMatch,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $DirectoryObjectId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
function Set-MgGroupLicense
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String[]]
        $RemoveLicenses,

        [Parameter()]
        [PSObject]
        $AddLicenses,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
function Update-MgGroup
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $Mail,

        [Parameter()]
        [System.String]
        $Visibility,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [PSObject]
        $PermissionGrants,

        [Parameter()]
        [System.String]
        $CreatedByAppId,

        [Parameter()]
        [PSObject]
        $Sites,

        [Parameter()]
        [PSObject]
        $AppRoleAssignments,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $SecurityEnabled,

        [Parameter()]
        [PSObject]
        $AssignedLabels,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [PSObject]
        $Calendar,

        [Parameter()]
        [System.String]
        $SecurityIdentifier,

        [Parameter()]
        [PSObject]
        $AssignedLicenses,

        [Parameter()]
        [System.String]
        $OnPremisesSamAccountName,

        [Parameter()]
        [System.DateTime]
        $RenewedDateTime,

        [Parameter()]
        [PSObject]
        $RejectedSenders,

        [Parameter()]
        [PSObject]
        $Extensions,

        [Parameter()]
        [System.String]
        $OrganizationId,

        [Parameter()]
        [System.Int32]
        $UnseenCount,

        [Parameter()]
        [System.String]
        $Classification,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AutoSubscribeNewMembers,

        [Parameter()]
        [System.String]
        $MailNickname,

        [Parameter()]
        [System.String[]]
        $ProxyAddresses,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.DateTime]
        $ExpirationDateTime,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $OnPremisesProvisioningErrors,

        [Parameter()]
        [System.String]
        $OnPremisesSecurityIdentifier,

        [Parameter()]
        [System.String[]]
        $ResourceBehaviorOptions,

        [Parameter()]
        [System.String]
        $PreferredLanguage,

        [Parameter()]
        [PSObject]
        $TransitiveMembers,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $HideFromAddressLists,

        [Parameter()]
        [PSObject]
        $Planner,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.DateTime]
        $OnPremisesLastSyncDateTime,

        [Parameter()]
        [System.Int32]
        $UnseenMessagesCount,

        [Parameter()]
        [PSObject]
        $Owners,

        [Parameter()]
        [PSObject]
        $GroupLifecyclePolicies,

        [Parameter()]
        [PSObject]
        $LicenseProcessingState,

        [Parameter()]
        [System.String]
        $PreferredDataLocation,

        [Parameter()]
        [System.String]
        $OnPremisesDomainName,

        [Parameter()]
        [PSObject]
        $Settings,

        [Parameter()]
        [PSObject]
        $AcceptedSenders,

        [Parameter()]
        [PSObject]
        $Onenote,

        [Parameter()]
        [System.String]
        $MembershipRuleProcessingState,

        [Parameter()]
        [System.String]
        $AccessType,

        [Parameter()]
        [PSObject]
        $MemberOf,

        [Parameter()]
        [System.String[]]
        $ResourceProvisioningOptions,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $MailEnabled,

        [Parameter()]
        [PSObject]
        $Drives,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowExternalSenders,

        [Parameter()]
        [PSObject]
        $MembersWithLicenseErrors,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [PSObject]
        $WritebackConfiguration,

        [Parameter()]
        [PSObject]
        $Photo,

        [Parameter()]
        [System.String]
        $Theme,

        [Parameter()]
        [PSObject]
        $Events,

        [Parameter()]
        [System.DateTime]
        $DeletedDateTime,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $HasMembersWithLicenseErrors,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsManagementRestricted,

        [Parameter()]
        [PSObject]
        $TransitiveMemberOf,

        [Parameter()]
        [System.String[]]
        $InfoCatalogs,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $OnPremisesSyncEnabled,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsArchived,

        [Parameter()]
        [PSObject]
        $Drive,

        [Parameter()]
        [System.String]
        $OnPremisesNetBiosName,

        [Parameter()]
        [PSObject]
        $CalendarView,

        [Parameter()]
        [PSObject]
        $Photos,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsAssignableToRole,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $HideFromOutlookClients,

        [Parameter()]
        [PSObject]
        $MembershipRuleProcessingStatus,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsSubscribedByMail,

        [Parameter()]
        [PSObject]
        $CreatedOnBehalfOf,

        [Parameter()]
        [PSObject]
        $Threads,

        [Parameter()]
        [PSObject]
        $Team,

        [Parameter()]
        [PSObject]
        $Members,

        [Parameter()]
        [System.String[]]
        $GroupTypes,

        [Parameter()]
        [System.Int32]
        $UnseenConversationsCount,

        [Parameter()]
        [System.String]
        $MembershipRule,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsFavorite,

        [Parameter()]
        [System.DateTime]
        $CreatedDateTime,

        [Parameter()]
        [PSObject]
        $Conversations,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [PSObject]
        $Endpoints,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
function Update-MgGroupLifecyclePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $GroupLifetimeInDays,

        [Parameter()]
        [System.String]
        $AlternateNotificationEmails,

        [Parameter()]
        [System.String]
        $GroupLifecyclePolicyId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.String]
        $ManagedGroupTypes,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
#endregion
#region MicrosoftGraph
function Get-MgDevice
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $DeviceId,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.String]
        $ConsistencyLevel,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgDirectory
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
function Get-MgDirectoryRole
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.String]
        $DirectoryRoleId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgDirectoryRoleTemplate
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.String]
        $DirectoryRoleTemplateId,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgOrganization
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String]
        $OrganizationId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgSubscribedSku
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String]
        $SubscribedSkuId,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.String]
        $Search
    )
}
function New-MgDevice
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.DateTime]
        $RegistrationDateTime,

        [Parameter()]
        [System.String]
        $Status,

        [Parameter()]
        [PSObject]
        $UsageRights,

        [Parameter()]
        [System.String]
        $DeviceMetadata,

        [Parameter()]
        [System.String]
        $TrustType,

        [Parameter()]
        [System.Int32]
        $DeviceVersion,

        [Parameter()]
        [PSObject]
        $Extensions,

        [Parameter()]
        [PSObject]
        $AlternativeSecurityIds,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $Commands,

        [Parameter()]
        [System.String]
        $OperatingSystemVersion,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.DateTime]
        $OnPremisesLastSyncDateTime,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $DeviceId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsCompliant,

        [Parameter()]
        [System.String]
        $EnrollmentType,

        [Parameter()]
        [System.String]
        $ProfileType,

        [Parameter()]
        [PSObject]
        $ExtensionAttributes,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $OnPremisesSyncEnabled,

        [Parameter()]
        [PSObject]
        $MemberOf,

        [Parameter()]
        [System.String[]]
        $Hostnames,

        [Parameter()]
        [System.String[]]
        $PhysicalIds,

        [Parameter()]
        [System.DateTime]
        $ComplianceExpirationDateTime,

        [Parameter()]
        [System.DateTime]
        $DeletedDateTime,

        [Parameter()]
        [System.String]
        $DeviceCategory,

        [Parameter()]
        [System.String]
        $DomainName,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsManagementRestricted,

        [Parameter()]
        [PSObject]
        $TransitiveMemberOf,

        [Parameter()]
        [System.String]
        $Model,

        [Parameter()]
        [System.String[]]
        $SystemLabels,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [PSObject]
        $RegisteredOwners,

        [Parameter()]
        [PSObject]
        $RegisteredUsers,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.String]
        $OperatingSystem,

        [Parameter()]
        [System.String]
        $Manufacturer,

        [Parameter()]
        [System.String]
        $DeviceOwnership,

        [Parameter()]
        [System.DateTime]
        $ApproximateLastSignInDateTime,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsManaged,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $Platform,

        [Parameter()]
        [System.String]
        $EnrollmentProfileName,

        [Parameter()]
        [System.String]
        $MdmAppId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsRooted,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AccountEnabled,

        [Parameter()]
        [System.String]
        $ManagementType,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String]
        $Kind
    )
}
function New-MgDirectoryRole
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $RoleTemplateId,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [PSObject]
        $ScopedMembers,

        [Parameter()]
        [PSObject]
        $Members,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.DateTime]
        $DeletedDateTime,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function New-MgDirectoryRoleMemberByRef
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.String]
        $DirectoryRoleId,

        [Parameter()]
        [System.String]
        $OdataId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
function Remove-MgDevice
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $IfMatch,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $DeviceId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Remove-MgDirectoryRole
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $IfMatch,

        [Parameter()]
        [System.String]
        $DirectoryRoleId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
function Remove-MgDirectoryRoleMemberByRef
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $IfMatch,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.String]
        $DirectoryRoleId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $DirectoryObjectId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
function Update-MgDevice
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.DateTime]
        $RegistrationDateTime,

        [Parameter()]
        [System.String]
        $Status,

        [Parameter()]
        [PSObject]
        $UsageRights,

        [Parameter()]
        [System.String]
        $DeviceMetadata,

        [Parameter()]
        [System.String]
        $TrustType,

        [Parameter()]
        [System.Int32]
        $DeviceVersion,

        [Parameter()]
        [System.String]
        $OperatingSystem,

        [Parameter()]
        [PSObject]
        $Extensions,

        [Parameter()]
        [PSObject]
        $AlternativeSecurityIds,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $Commands,

        [Parameter()]
        [System.String]
        $OperatingSystemVersion,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.DateTime]
        $OnPremisesLastSyncDateTime,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $DeviceId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsCompliant,

        [Parameter()]
        [System.String]
        $EnrollmentType,

        [Parameter()]
        [System.String]
        $ProfileType,

        [Parameter()]
        [PSObject]
        $ExtensionAttributes,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $OnPremisesSyncEnabled,

        [Parameter()]
        [PSObject]
        $MemberOf,

        [Parameter()]
        [System.String[]]
        $Hostnames,

        [Parameter()]
        [System.String[]]
        $PhysicalIds,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.DateTime]
        $ComplianceExpirationDateTime,

        [Parameter()]
        [System.DateTime]
        $DeletedDateTime,

        [Parameter()]
        [System.String]
        $DeviceCategory,

        [Parameter()]
        [System.String]
        $DomainName,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsManagementRestricted,

        [Parameter()]
        [PSObject]
        $TransitiveMemberOf,

        [Parameter()]
        [System.String]
        $Model,

        [Parameter()]
        [System.String[]]
        $SystemLabels,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [PSObject]
        $RegisteredOwners,

        [Parameter()]
        [PSObject]
        $RegisteredUsers,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.String]
        $DeviceId1,

        [Parameter()]
        [System.String]
        $Manufacturer,

        [Parameter()]
        [System.String]
        $DeviceOwnership,

        [Parameter()]
        [System.DateTime]
        $ApproximateLastSignInDateTime,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsManaged,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $Platform,

        [Parameter()]
        [System.String]
        $EnrollmentProfileName,

        [Parameter()]
        [System.String]
        $MdmAppId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsRooted,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AccountEnabled,

        [Parameter()]
        [System.String]
        $ManagementType,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String]
        $Kind
    )
}
function Update-MgDirectory
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PSObject]
        $InboundSharedUserProfiles,

        [Parameter()]
        [PSObject]
        $SharedEmailDomains,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [PSObject]
        $OutboundSharedUserProfiles,

        [Parameter()]
        [PSObject]
        $FederationConfigurations,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [PSObject]
        $AdministrativeUnits,

        [Parameter()]
        [PSObject]
        $Recommendations,

        [Parameter()]
        [PSObject]
        $AttributeSets,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [PSObject]
        $DeletedItems,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [PSObject]
        $ImpactedResources,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [PSObject]
        $CustomSecurityAttributeDefinitions,

        [Parameter()]
        [PSObject]
        $FeatureRolloutPolicies,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Update-MgOrganization
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $PostalCode,

        [Parameter()]
        [PSObject]
        $VerifiedDomains,

        [Parameter()]
        [PSObject]
        $CertificateConnectorSetting,

        [Parameter()]
        [System.DateTime]
        $CreatedDateTime,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [PSObject]
        $Settings,

        [Parameter()]
        [System.String]
        $Street,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.String]
        $PreferredLanguage,

        [Parameter()]
        [System.String]
        $State,

        [Parameter()]
        [System.String]
        $City,

        [Parameter()]
        [System.String[]]
        $MarketingNotificationEmails,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [PSObject]
        $AssignedPlans,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.MdmAuthority]
        $MobileDeviceManagementAuthority,

        [Parameter()]
        [System.String]
        $TenantType,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsMultipleDataLocationsForServicesEnabled,

        [Parameter()]
        [System.String]
        $Country,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String[]]
        $SecurityComplianceNotificationMails,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [PSObject]
        $CertificateBasedAuthConfiguration,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [PSObject]
        $PrivacyProfile,

        [Parameter()]
        [PSObject]
        $Extensions,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [PSObject]
        $ProvisionedPlans,

        [Parameter()]
        [PSObject]
        $DirectorySizeQuota,

        [Parameter()]
        [System.String[]]
        $TechnicalNotificationMails,

        [Parameter()]
        [PSObject]
        $Branding,

        [Parameter()]
        [System.DateTime]
        $DeletedDateTime,

        [Parameter()]
        [System.String]
        $CountryLetterCode,

        [Parameter()]
        [System.String[]]
        $BusinessPhones,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $OnPremisesSyncEnabled,

        [Parameter()]
        [System.String]
        $OrganizationId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String[]]
        $SecurityComplianceNotificationPhones,

        [Parameter()]
        [System.DateTime]
        $OnPremisesLastSyncDateTime
    )
}
function Get-MgDirectorySetting
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $DirectorySettingId,

        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function New-MgDirectorySetting
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PSObject]
        $Values
    )
}
function Remove-MgDirectorySetting
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $DirectorySettingId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $IfMatch,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Update-MgDirectorySetting
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PSObject]
        $Values
    )
}
#endregion
#region MicrosoftGraph
function Get-MgAgreement
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [System.String]
        $AgreementId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
#endregion
#region MicrosoftGraph
function Get-MgIdentityConditionalAccessNamedLocation
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $NamedLocationId,

        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgIdentityConditionalAccessPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.String]
        $ConditionalAccessPolicyId,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgOauth2PermissionGrant
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [System.String]
        $OAuth2PermissionGrantId,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgPolicyAuthorizationPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.String]
        $AuthorizationPolicyId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgPolicyIdentitySecurityDefaultEnforcementPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
function Get-MgPolicyRoleManagementPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.String]
        $UnifiedRoleManagementPolicyId,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgPolicyRoleManagementPolicyAssignment
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $UnifiedRoleManagementPolicyAssignmentId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgPolicyRoleManagementPolicyRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $UnifiedRoleManagementPolicyRuleId,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.String]
        $UnifiedRoleManagementPolicyId,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgPolicyTokenLifetimePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.String]
        $TokenLifetimePolicyId,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function New-MgIdentityConditionalAccessPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.DateTime]
        $CreatedDateTime,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.DateTime]
        $ModifiedDateTime,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [PSObject]
        $SessionControls,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.String]
        $State,

        [Parameter()]
        [PSObject]
        $Conditions,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [PSObject]
        $GrantControls,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function New-MgPolicyTokenLifetimePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Definition,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsOrganizationDefault,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Collections.Hashtable]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.DateTime]
        $DeletedDateTime,

        [Parameter()]
        [PSObject]
        $AppliesTo,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Remove-MgIdentityConditionalAccessNamedLocation
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $IfMatch,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.String]
        $NamedLocationId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Remove-MgIdentityConditionalAccessPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $IfMatch,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $ConditionalAccessPolicyId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Remove-MgPolicyTokenLifetimePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $IfMatch,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $TokenLifetimePolicyId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Update-MgIdentityConditionalAccessPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.DateTime]
        $CreatedDateTime,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.DateTime]
        $ModifiedDateTime,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [PSObject]
        $SessionControls,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.String]
        $State,

        [Parameter()]
        [PSObject]
        $Conditions,

        [Parameter()]
        [System.String]
        $ConditionalAccessPolicyId,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [PSObject]
        $GrantControls,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Update-MgPolicyAuthorizationPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $BlockMsolPowerShell,

        [Parameter()]
        [System.String]
        $AuthorizationPolicyId,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowedToUseSspr,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowUserConsentForRiskyApps,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.String]
        $GuestUserRoleId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowedToSignUpEmailBasedSubscriptions,

        [Parameter()]
        [PSObject]
        $DefaultUserRoleOverrides,

        [Parameter()]
        [System.String]
        $AllowInvitesFrom,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowEmailVerifiedUsersToJoinOrganization,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.DateTime]
        $DeletedDateTime,

        [Parameter()]
        [System.String[]]
        $PermissionGrantPolicyIdsAssignedToDefaultUserRole,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [PSObject]
        $DefaultUserRolePermissions,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.String[]]
        $EnabledPreviewFeatures
    )
}
function Update-MgPolicyIdentitySecurityDefaultEnforcementPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.DateTime]
        $DeletedDateTime,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsEnabled,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Update-MgPolicyRoleManagementPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.DateTime]
        $LastModifiedDateTime,

        [Parameter()]
        [PSObject]
        $EffectiveRules,

        [Parameter()]
        [System.String]
        $UnifiedRoleManagementPolicyId,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.String]
        $ScopeType,

        [Parameter()]
        [System.String]
        $ScopeId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsOrganizationDefault,

        [Parameter()]
        [PSObject]
        $LastModifiedBy,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [PSObject]
        $Rules,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Update-MgPolicyRoleManagementPolicyRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PSObject]
        $Target,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $UnifiedRoleManagementPolicyRuleId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.String]
        $UnifiedRoleManagementPolicyId,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Update-MgPolicyTokenLifetimePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Definition,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.String]
        $TokenLifetimePolicyId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsOrganizationDefault,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Collections.Hashtable]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [PSObject]
        $AppliesTo,

        [Parameter()]
        [System.DateTime]
        $DeletedDateTime,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
#endregion
#region MicrosoftGraph
function Get-MgGroupPlanner
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
function Get-MgGroupPlannerPlan
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String]
        $PlannerPlanId,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgGroupPlannerPlanTask
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String]
        $PlannerPlanId,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgPlanner
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
function Get-MgPlannerPlan
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String]
        $PlannerPlanId,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgPlannerPlanBucket
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String]
        $PlannerPlanId,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function New-MgPlannerBucket
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $OrderHint,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $PlanId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [PSObject]
        $Tasks,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function New-MgPlannerPlan
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PSObject]
        $Buckets,

        [Parameter()]
        [System.DateTime]
        $CreatedDateTime,

        [Parameter()]
        [System.String]
        $Owner,

        [Parameter()]
        [System.Collections.Hashtable]
        $Contexts,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [PSObject]
        $Tasks,

        [Parameter()]
        [PSObject]
        $Container,

        [Parameter()]
        [PSObject]
        $CreatedBy,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Title,

        [Parameter()]
        [PSObject]
        $Details,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Update-MgPlanner
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PSObject]
        $Buckets,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $Tasks,

        [Parameter()]
        [PSObject]
        $Rosters,

        [Parameter()]
        [PSObject]
        $Plans,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Update-MgPlannerPlan
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $PlannerPlanId,

        [Parameter()]
        [PSObject]
        $Buckets,

        [Parameter()]
        [System.DateTime]
        $CreatedDateTime,

        [Parameter()]
        [System.String]
        $Owner,

        [Parameter()]
        [System.Collections.Hashtable]
        $Contexts,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [PSObject]
        $Tasks,

        [Parameter()]
        [PSObject]
        $Container,

        [Parameter()]
        [PSObject]
        $CreatedBy,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [PSObject]
        $Details,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Title,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
#endregion
#region MicrosoftGraph
function Get-MgTeam
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.String]
        $TeamId,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgTeamChannel
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [System.String]
        $ChannelId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.String]
        $TeamId,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgTeamChannelTab
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [System.String]
        $ChannelId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.String]
        $TeamId,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.String]
        $TeamsTabId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Remove-MgTeam
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $IfMatch,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $TeamId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Remove-MgTeamChannel
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $IfMatch,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $ChannelId,

        [Parameter()]
        [System.String]
        $TeamId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Remove-MgTeamChannelTab
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $IfMatch,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $ChannelId,

        [Parameter()]
        [System.String]
        $TeamsTabId,

        [Parameter()]
        [System.String]
        $TeamId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break
    )
}
#endregion
#region MicrosoftGraph
function Get-MgUser
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $UserId,

        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.String]
        $ConsistencyLevel,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Get-MgUserLicenseDetail
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $UserId,

        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.String]
        $LicenseDetailsId,

        [Parameter()]
        [System.Int32]
        $PageSize,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Skip,

        [Parameter()]
        [System.Int32]
        $Top,

        [Parameter()]
        [System.String]
        $CountVariable,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function New-MgUser
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsManagementRestricted,

        [Parameter()]
        [PSObject]
        $Todo,

        [Parameter()]
        [PSObject]
        $Insights,

        [Parameter()]
        [PSObject]
        $OnlineMeetings,

        [Parameter()]
        [PSObject]
        $AssignedPlans,

        [Parameter()]
        [System.String]
        $ExternalUserState,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.DateTime]
        $EmployeeHireDate,

        [Parameter()]
        [System.String]
        $OnPremisesImmutableId,

        [Parameter()]
        [PSObject]
        $RegisteredDevices,

        [Parameter()]
        [PSObject]
        $AppRoleAssignments,

        [Parameter()]
        [PSObject]
        $InformationProtection,

        [Parameter()]
        [PSObject]
        $Approvals,

        [Parameter()]
        [System.DateTime]
        $ExternalUserStateChangeDateTime,

        [Parameter()]
        [System.String[]]
        $ImAddresses,

        [Parameter()]
        [PSObject]
        $DeviceEnrollmentConfigurations,

        [Parameter()]
        [System.String[]]
        $Responsibilities,

        [Parameter()]
        [System.DateTime]
        $RefreshTokensValidFromDateTime,

        [Parameter()]
        [System.String]
        $OnPremisesDomainName,

        [Parameter()]
        [System.String]
        $State,

        [Parameter()]
        [PSObject]
        $Extensions,

        [Parameter()]
        [System.DateTime]
        $SignInSessionsValidFromDateTime,

        [Parameter()]
        [System.DateTime]
        $EmployeeLeaveDateTime,

        [Parameter()]
        [System.DateTime]
        $Birthday,

        [Parameter()]
        [System.String]
        $Mail,

        [Parameter()]
        [System.DateTime]
        $HireDate,

        [Parameter()]
        [PSObject]
        $MobileAppIntentAndStates,

        [Parameter()]
        [System.String[]]
        $InfoCatalogs,

        [Parameter()]
        [PSObject]
        $Chats,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [PSObject]
        $EmployeeOrgData,

        [Parameter()]
        [System.DateTime]
        $LastPasswordChangeDateTime,

        [Parameter()]
        [PSObject]
        $Manager,

        [Parameter()]
        [PSObject]
        $InferenceClassification,

        [Parameter()]
        [PSObject]
        $CalendarGroups,

        [Parameter()]
        [PSObject]
        $MailFolders,

        [Parameter()]
        [PSObject]
        $ScopedRoleMemberOf,

        [Parameter()]
        [System.String]
        $ConsentProvidedForMinor,

        [Parameter()]
        [PSObject]
        $SignInActivity,

        [Parameter()]
        [PSObject]
        $AgreementAcceptances,

        [Parameter()]
        [System.String]
        $EmployeeType,

        [Parameter()]
        [PSObject]
        $OwnedObjects,

        [Parameter()]
        [PSObject]
        $AuthorizationInfo,

        [Parameter()]
        [PSObject]
        $Photos,

        [Parameter()]
        [PSObject]
        $Oauth2PermissionGrants,

        [Parameter()]
        [System.String]
        $PreferredDataLocation,

        [Parameter()]
        [PSObject]
        $MailboxSettings,

        [Parameter()]
        [PSObject]
        $Notifications,

        [Parameter()]
        [System.String]
        $Country,

        [Parameter()]
        [System.String]
        $OnPremisesDistinguishedName,

        [Parameter()]
        [System.String[]]
        $Skills,

        [Parameter()]
        [System.String]
        $MobilePhone,

        [Parameter()]
        [System.String]
        $FaxNumber,

        [Parameter()]
        [System.DateTime]
        $DeletedDateTime,

        [Parameter()]
        [PSObject]
        $Settings,

        [Parameter()]
        [PSObject]
        $Profile,

        [Parameter()]
        [System.Int32]
        $DeviceEnrollmentLimit,

        [Parameter()]
        [System.String]
        $AboutMe,

        [Parameter()]
        [System.String]
        $GivenName,

        [Parameter()]
        [PSObject]
        $ContactFolders,

        [Parameter()]
        [PSObject]
        $People,

        [Parameter()]
        [PSObject]
        $WindowsInformationProtectionDeviceRegistrations,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsResourceAccount,

        [Parameter()]
        [System.String[]]
        $OtherMails,

        [Parameter()]
        [System.String]
        $PasswordPolicies,

        [Parameter()]
        [System.String]
        $CreationType,

        [Parameter()]
        [System.String]
        $OnPremisesUserPrincipalName,

        [Parameter()]
        [System.String]
        $PreferredLanguage,

        [Parameter()]
        [PSObject]
        $PendingAccessReviewInstances,

        [Parameter()]
        [System.DateTime]
        $OnPremisesLastSyncDateTime,

        [Parameter()]
        [System.String]
        $AgeGroup,

        [Parameter()]
        [PSObject]
        $Planner,

        [Parameter()]
        [PSObject]
        $Contacts,

        [Parameter()]
        [PSObject]
        $Calendars,

        [Parameter()]
        [PSObject]
        $Drive,

        [Parameter()]
        [System.String]
        $UsageLocation,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ShowInAddressList,

        [Parameter()]
        [System.String]
        $JobTitle,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AccountEnabled,

        [Parameter()]
        [System.String[]]
        $Schools,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $City,

        [Parameter()]
        [PSObject]
        $Teamwork,

        [Parameter()]
        [PSObject]
        $ManagedAppRegistrations,

        [Parameter()]
        [PSObject]
        $Messages,

        [Parameter()]
        [PSObject]
        $Print,

        [Parameter()]
        [PSObject]
        $Security,

        [Parameter()]
        [PSObject]
        $Identities,

        [Parameter()]
        [PSObject]
        $JoinedTeams,

        [Parameter()]
        [System.String]
        $MySite,

        [Parameter()]
        [System.String[]]
        $BusinessPhones,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [PSObject]
        $Analytics,

        [Parameter()]
        [System.String[]]
        $ProxyAddresses,

        [Parameter()]
        [System.String]
        $OfficeLocation,

        [Parameter()]
        [PSObject]
        $Presence,

        [Parameter()]
        [PSObject]
        $PasswordProfile,

        [Parameter()]
        [PSObject]
        $AppConsentRequestsForApproval,

        [Parameter()]
        [System.String]
        $UserType,

        [Parameter()]
        [PSObject]
        $TransitiveMemberOf,

        [Parameter()]
        [PSObject]
        $ManagedDevices,

        [Parameter()]
        [PSObject]
        $CreatedObjects,

        [Parameter()]
        [PSObject]
        $Photo,

        [Parameter()]
        [PSObject]
        $LicenseDetails,

        [Parameter()]
        [System.String]
        $StreetAddress,

        [Parameter()]
        [PSObject]
        $JoinedGroups,

        [Parameter()]
        [PSObject]
        $CloudPCs,

        [Parameter()]
        [System.Collections.Hashtable]
        $CustomSecurityAttributes,

        [Parameter()]
        [PSObject]
        $CalendarView,

        [Parameter()]
        [PSObject]
        $Onenote,

        [Parameter()]
        [System.String]
        $SecurityIdentifier,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [PSObject]
        $AppRoleAssignedResources,

        [Parameter()]
        [PSObject]
        $OwnedDevices,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [PSObject]
        $FollowedSites,

        [Parameter()]
        [PSObject]
        $Drives,

        [Parameter()]
        [PSObject]
        $UsageRights,

        [Parameter()]
        [PSObject]
        $MobileAppTroubleshootingEvents,

        [Parameter()]
        [System.String[]]
        $Interests,

        [Parameter()]
        [System.String]
        $LegalAgeGroupClassification,

        [Parameter()]
        [System.String]
        $OnPremisesSecurityIdentifier,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [PSObject]
        $Calendar,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $OnPremisesSyncEnabled,

        [Parameter()]
        [System.String]
        $Department,

        [Parameter()]
        [System.String]
        $CompanyName,

        [Parameter()]
        [PSObject]
        $MemberOf,

        [Parameter()]
        [PSObject]
        $DeviceKeys,

        [Parameter()]
        [System.String]
        $EmployeeId,

        [Parameter()]
        [PSObject]
        $AssignedLicenses,

        [Parameter()]
        [PSObject]
        $Events,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.String]
        $UserPrincipalName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [PSObject]
        $Tasks,

        [Parameter()]
        [PSObject]
        $ProvisionedPlans,

        [Parameter()]
        [PSObject]
        $OnPremisesProvisioningErrors,

        [Parameter()]
        [System.String]
        $MailNickname,

        [Parameter()]
        [PSObject]
        $OnPremisesExtensionAttributes,

        [Parameter()]
        [System.String[]]
        $PastProjects,

        [Parameter()]
        [System.DateTime]
        $CreatedDateTime,

        [Parameter()]
        [PSObject]
        $DirectReports,

        [Parameter()]
        [PSObject]
        $Authentication,

        [Parameter()]
        [PSObject]
        $TransitiveReports,

        [Parameter()]
        [PSObject]
        $LicenseAssignmentStates,

        [Parameter()]
        [PSObject]
        $Activities,

        [Parameter()]
        [PSObject]
        $Devices,

        [Parameter()]
        [PSObject]
        $Outlook,

        [Parameter()]
        [PSObject]
        $DeviceManagementTroubleshootingEvents,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String]
        $OnPremisesSamAccountName,

        [Parameter()]
        [System.String]
        $PreferredName,

        [Parameter()]
        [System.String]
        $PostalCode,

        [Parameter()]
        [System.String]
        $Surname
    )
}
function Remove-MgUser
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $IfMatch,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.String]
        $UserId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend
    )
}
function Update-MgUser
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsManagementRestricted,

        [Parameter()]
        [PSObject]
        $Todo,

        [Parameter()]
        [PSObject]
        $Insights,

        [Parameter()]
        [PSObject]
        $OnlineMeetings,

        [Parameter()]
        [PSObject]
        $InputObject,

        [Parameter()]
        [PSObject]
        $AssignedPlans,

        [Parameter()]
        [System.String]
        $ExternalUserState,

        [Parameter()]
        [PSObject]
        $BodyParameter,

        [Parameter()]
        [System.DateTime]
        $EmployeeHireDate,

        [Parameter()]
        [System.String]
        $OnPremisesImmutableId,

        [Parameter()]
        [PSObject]
        $RegisteredDevices,

        [Parameter()]
        [PSObject]
        $AppRoleAssignments,

        [Parameter()]
        [PSObject]
        $InformationProtection,

        [Parameter()]
        [PSObject]
        $Approvals,

        [Parameter()]
        [System.DateTime]
        $ExternalUserStateChangeDateTime,

        [Parameter()]
        [System.String[]]
        $ImAddresses,

        [Parameter()]
        [PSObject]
        $DeviceEnrollmentConfigurations,

        [Parameter()]
        [System.String[]]
        $Responsibilities,

        [Parameter()]
        [System.DateTime]
        $RefreshTokensValidFromDateTime,

        [Parameter()]
        [System.String]
        $OnPremisesDomainName,

        [Parameter()]
        [System.String]
        $State,

        [Parameter()]
        [PSObject]
        $Extensions,

        [Parameter()]
        [System.DateTime]
        $SignInSessionsValidFromDateTime,

        [Parameter()]
        [System.DateTime]
        $EmployeeLeaveDateTime,

        [Parameter()]
        [System.DateTime]
        $Birthday,

        [Parameter()]
        [System.String]
        $Mail,

        [Parameter()]
        [System.DateTime]
        $HireDate,

        [Parameter()]
        [PSObject]
        $MobileAppIntentAndStates,

        [Parameter()]
        [System.String[]]
        $InfoCatalogs,

        [Parameter()]
        [PSObject]
        $Chats,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [PSObject]
        $EmployeeOrgData,

        [Parameter()]
        [System.DateTime]
        $LastPasswordChangeDateTime,

        [Parameter()]
        [PSObject]
        $Manager,

        [Parameter()]
        [PSObject]
        $InferenceClassification,

        [Parameter()]
        [PSObject]
        $CalendarGroups,

        [Parameter()]
        [PSObject]
        $MailFolders,

        [Parameter()]
        [PSObject]
        $ScopedRoleMemberOf,

        [Parameter()]
        [System.String]
        $ConsentProvidedForMinor,

        [Parameter()]
        [PSObject]
        $AppRoleAssignedResources,

        [Parameter()]
        [PSObject]
        $SignInActivity,

        [Parameter()]
        [PSObject]
        $AgreementAcceptances,

        [Parameter()]
        [System.String]
        $EmployeeType,

        [Parameter()]
        [PSObject]
        $OwnedObjects,

        [Parameter()]
        [PSObject]
        $AuthorizationInfo,

        [Parameter()]
        [PSObject]
        $Photos,

        [Parameter()]
        [PSObject]
        $Oauth2PermissionGrants,

        [Parameter()]
        [System.String]
        $PreferredDataLocation,

        [Parameter()]
        [PSObject]
        $MailboxSettings,

        [Parameter()]
        [PSObject]
        $Notifications,

        [Parameter()]
        [System.String]
        $Country,

        [Parameter()]
        [System.String]
        $OnPremisesDistinguishedName,

        [Parameter()]
        [System.String[]]
        $Skills,

        [Parameter()]
        [System.String]
        $MobilePhone,

        [Parameter()]
        [System.String]
        $FaxNumber,

        [Parameter()]
        [System.DateTime]
        $DeletedDateTime,

        [Parameter()]
        [PSObject]
        $Settings,

        [Parameter()]
        [PSObject]
        $Profile,

        [Parameter()]
        [System.Int32]
        $DeviceEnrollmentLimit,

        [Parameter()]
        [System.String]
        $AboutMe,

        [Parameter()]
        [System.String]
        $GivenName,

        [Parameter()]
        [PSObject]
        $ContactFolders,

        [Parameter()]
        [PSObject]
        $People,

        [Parameter()]
        [PSObject]
        $WindowsInformationProtectionDeviceRegistrations,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsResourceAccount,

        [Parameter()]
        [System.String[]]
        $OtherMails,

        [Parameter()]
        [System.String]
        $PasswordPolicies,

        [Parameter()]
        [System.String]
        $CreationType,

        [Parameter()]
        [System.String]
        $OnPremisesUserPrincipalName,

        [Parameter()]
        [System.String]
        $PreferredLanguage,

        [Parameter()]
        [PSObject]
        $PendingAccessReviewInstances,

        [Parameter()]
        [System.DateTime]
        $OnPremisesLastSyncDateTime,

        [Parameter()]
        [System.String]
        $AgeGroup,

        [Parameter()]
        [PSObject]
        $Planner,

        [Parameter()]
        [PSObject]
        $Contacts,

        [Parameter()]
        [PSObject]
        $Calendars,

        [Parameter()]
        [PSObject]
        $Drive,

        [Parameter()]
        [System.String]
        $UsageLocation,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ShowInAddressList,

        [Parameter()]
        [System.String]
        $JobTitle,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AccountEnabled,

        [Parameter()]
        [System.String[]]
        $Schools,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $City,

        [Parameter()]
        [PSObject]
        $Teamwork,

        [Parameter()]
        [PSObject]
        $ManagedAppRegistrations,

        [Parameter()]
        [PSObject]
        $Messages,

        [Parameter()]
        [PSObject]
        $Print,

        [Parameter()]
        [PSObject]
        $Security,

        [Parameter()]
        [PSObject]
        $Identities,

        [Parameter()]
        [PSObject]
        $JoinedTeams,

        [Parameter()]
        [System.String]
        $MySite,

        [Parameter()]
        [System.String[]]
        $BusinessPhones,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [PSObject]
        $Analytics,

        [Parameter()]
        [System.String[]]
        $ProxyAddresses,

        [Parameter()]
        [System.String]
        $OfficeLocation,

        [Parameter()]
        [PSObject]
        $Presence,

        [Parameter()]
        [PSObject]
        $PasswordProfile,

        [Parameter()]
        [PSObject]
        $AppConsentRequestsForApproval,

        [Parameter()]
        [PSObject]
        $TransitiveMemberOf,

        [Parameter()]
        [PSObject]
        $ManagedDevices,

        [Parameter()]
        [PSObject]
        $CreatedObjects,

        [Parameter()]
        [PSObject]
        $Photo,

        [Parameter()]
        [PSObject]
        $LicenseDetails,

        [Parameter()]
        [System.String]
        $StreetAddress,

        [Parameter()]
        [PSObject]
        $JoinedGroups,

        [Parameter()]
        [PSObject]
        $CloudPCs,

        [Parameter()]
        [System.Collections.Hashtable]
        $CustomSecurityAttributes,

        [Parameter()]
        [PSObject]
        $CalendarView,

        [Parameter()]
        [PSObject]
        $Onenote,

        [Parameter()]
        [System.String]
        $SecurityIdentifier,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [PSObject]
        $OwnedDevices,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [PSObject]
        $FollowedSites,

        [Parameter()]
        [PSObject]
        $Drives,

        [Parameter()]
        [PSObject]
        $UsageRights,

        [Parameter()]
        [PSObject]
        $MobileAppTroubleshootingEvents,

        [Parameter()]
        [System.String[]]
        $Interests,

        [Parameter()]
        [System.String]
        $LegalAgeGroupClassification,

        [Parameter()]
        [System.String]
        $OnPremisesSecurityIdentifier,

        [Parameter()]
        [System.String]
        $UserId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [PSObject]
        $Calendar,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $OnPremisesSyncEnabled,

        [Parameter()]
        [System.String]
        $Department,

        [Parameter()]
        [System.String]
        $CompanyName,

        [Parameter()]
        [PSObject]
        $MemberOf,

        [Parameter()]
        [System.String]
        $EmployeeId,

        [Parameter()]
        [System.String]
        $PostalCode,

        [Parameter()]
        [PSObject]
        $AssignedLicenses,

        [Parameter()]
        [PSObject]
        $Events,

        [Parameter()]
        [PSObject]
        $DeviceKeys,

        [Parameter()]
        [System.String]
        $UserPrincipalName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [PSObject]
        $Tasks,

        [Parameter()]
        [PSObject]
        $ProvisionedPlans,

        [Parameter()]
        [PSObject]
        $OnPremisesProvisioningErrors,

        [Parameter()]
        [System.String]
        $MailNickname,

        [Parameter()]
        [PSObject]
        $OnPremisesExtensionAttributes,

        [Parameter()]
        [System.String[]]
        $PastProjects,

        [Parameter()]
        [System.DateTime]
        $CreatedDateTime,

        [Parameter()]
        [PSObject]
        $DirectReports,

        [Parameter()]
        [PSObject]
        $Authentication,

        [Parameter()]
        [PSObject]
        $TransitiveReports,

        [Parameter()]
        [PSObject]
        $LicenseAssignmentStates,

        [Parameter()]
        [PSObject]
        $Activities,

        [Parameter()]
        [PSObject]
        $Devices,

        [Parameter()]
        [PSObject]
        $Outlook,

        [Parameter()]
        [PSObject]
        $DeviceManagementTroubleshootingEvents,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.String]
        $OnPremisesSamAccountName,

        [Parameter()]
        [System.String]
        $PreferredName,

        [Parameter()]
        [System.String]
        $UserType,

        [Parameter()]
        [System.String]
        $Surname
    )
}
#endregion
#region SecurityComplianceCenter
function Get-AdminAuditLogConfig
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-AuditConfig
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $DomainController,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-AuditConfigurationPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $DomainController,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-AutoSensitivityLabelPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ForceValidate,

        [Parameter()]
        [System.Object]
        $IncludeTestModeResults,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IncludeProgressFeedback,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $DistributionDetail,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-AutoSensitivityLabelRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ForceValidate,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $IncludeExecutionRuleInformation,

        [Parameter()]
        [System.Object]
        $Policy,

        [Parameter()]
        [System.Object]
        $IncludeExecutionRuleGuids,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-CaseHoldPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IncludeBindingsOnly,

        [Parameter()]
        [System.Object]
        $Case,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IncludeBindings,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $DistributionDetail,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-CaseHoldRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Policy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-ComplianceCase
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $CaseType,

        [Parameter()]
        [System.Object]
        $RoleGroup,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RecentOnly,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $DomainController,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-ComplianceRetentionEvent
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $BeginDateTime,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PreviewOnly,

        [Parameter()]
        [System.Object]
        $EndDateTime,

        [Parameter()]
        [System.Object]
        $DomainController,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-ComplianceRetentionEventType
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $LoadTag,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-ComplianceSearch
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Case,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $ResultSize,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-ComplianceSearchAction
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Case,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Purge,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IncludeCredential,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Details,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Export,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Preview,

        [Parameter()]
        [System.Object]
        $ResultSize,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-ComplianceTag
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IncludingLabelState,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-DeviceConditionalAccessPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-DeviceConfigurationPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-DlpCompliancePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Summary,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ForceValidate,

        [Parameter()]
        [System.Object]
        $IncludeExtendedProperties,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $IRMUserRiskConfiguredAnyRule,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $DistributionDetail,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-DlpComplianceRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Policy,

        [Parameter()]
        [System.Object]
        $IncludeExecutionRuleGuids,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-FilePlanPropertyAuthority
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-FilePlanPropertyCategory
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-FilePlanPropertyCitation
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-FilePlanPropertyDepartment
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-FilePlanPropertyReferenceId
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-FilePlanPropertySubCategory
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-Label
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $IncludeDetailedLabelActions,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $SkipValidations,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-LabelPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ForceValidate,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-ManagementRole
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $RoleType,

        [Parameter()]
        [System.Object]
        $CmdletParameters,

        [Parameter()]
        [System.Object]
        $ScriptParameters,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Cmdlet,

        [Parameter()]
        [System.Object]
        $Script,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $GetChildren,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Recurse,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-RetentionCompliancePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $TeamsPolicyOnly,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ExcludeTeamsPolicy,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ErrorPolicyOnly,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $DistributionDetail,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RetentionRuleTypes,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-RetentionComplianceRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Policy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-SupervisoryReviewPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $ResultSize,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-SupervisoryReviewPolicyV2
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-SupervisoryReviewRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Policy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-User
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $SortBy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PublicFolder,

        [Parameter()]
        [System.Object]
        $Filter,

        [Parameter()]
        [System.Object]
        $RecipientTypeDetails,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $ResultSize,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-AuditConfigurationPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Workload,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $DomainController,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-AutoSensitivityLabelPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $PolicyTemplateInfo,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $SharePointLocation,

        [Parameter()]
        [System.Object]
        $Priority,

        [Parameter()]
        [System.Object]
        $ExchangeSenderException,

        [Parameter()]
        [System.Object]
        $SharePointLocationException,

        [Parameter()]
        [System.Object]
        $ExchangeLocation,

        [Parameter()]
        [System.Object]
        $OneDriveLocationException,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $UnifiedAuditLogEnabled,

        [Parameter()]
        [System.Object]
        $ApplySensitivityLabel,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $ExchangeSender,

        [Parameter()]
        [System.Object]
        $OneDriveLocation,

        [Parameter()]
        [System.Object]
        $ExchangeSenderMemberOf,

        [Parameter()]
        [System.Object]
        $ExchangeSenderMemberOfException,

        [Parameter()]
        [System.Object]
        $Mode,

        [Parameter()]
        [System.Object]
        $OverwriteLabel,

        [Parameter()]
        [System.Object]
        $ExternalMailRightsManagementOwner,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-AutoSensitivityLabelRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $RecipientDomainIs,

        [Parameter()]
        [System.Object]
        $HeaderMatchesPatterns,

        [Parameter()]
        [System.Object]
        $FromAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfFrom,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $FromAddressContainsWords,

        [Parameter()]
        [System.Object]
        $SentToMemberOf,

        [Parameter()]
        [System.Object]
        $ExceptIfProcessingLimitExceeded,

        [Parameter()]
        [System.Object]
        $ExpiryDate,

        [Parameter()]
        [System.Object]
        $ExceptIfContentContainsSensitiveInformation,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $ExceptIfAnyOfRecipientAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ProcessingLimitExceeded,

        [Parameter()]
        [System.Object]
        $ExceptIfAccessScope,

        [Parameter()]
        [System.Object]
        $Workload,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentIsUnsupported,

        [Parameter()]
        [System.Object]
        $From,

        [Parameter()]
        [System.Object]
        $Priority,

        [Parameter()]
        [System.Object]
        $Policy,

        [Parameter()]
        [System.Object]
        $ExceptIfContentExtensionMatchesWords,

        [Parameter()]
        [System.Object]
        $ContentExtensionMatchesWords,

        [Parameter()]
        [System.Object]
        $ExceptIfFromAddressContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfSentTo,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.Object]
        $ExceptIfAnyOfRecipientAddressContainsWords,

        [Parameter()]
        [System.Object]
        $AnyOfRecipientAddressContainsWords,

        [Parameter()]
        [System.Object]
        $SenderIPRanges,

        [Parameter()]
        [System.Object]
        $AnyOfRecipientAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderDomainIs,

        [Parameter()]
        [System.Object]
        $SenderDomainIs,

        [Parameter()]
        [System.Object]
        $ExceptIfSubjectMatchesPatterns,

        [Parameter()]
        [System.Object]
        $SentTo,

        [Parameter()]
        [System.Object]
        $ActivationDate,

        [Parameter()]
        [System.Object]
        $DocumentIsUnsupported,

        [Parameter()]
        [System.Object]
        $Disabled,

        [Parameter()]
        [System.Object]
        $RuleErrorAction,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $FromMemberOf,

        [Parameter()]
        [System.Object]
        $AccessScope,

        [Parameter()]
        [System.Object]
        $ExceptIfSentToMemberOf,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderIPRanges,

        [Parameter()]
        [System.Object]
        $ContentContainsSensitiveInformation,

        [Parameter()]
        [System.Object]
        $DocumentIsPasswordProtected,

        [Parameter()]
        [System.Object]
        $ExceptIfFromAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfHeaderMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ReportSeverityLevel,

        [Parameter()]
        [System.Object]
        $SubjectMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfFromMemberOf,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentIsPasswordProtected,

        [Parameter()]
        [System.Object]
        $ImmutableId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-CaseHoldPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $PublicFolderLocation,

        [Parameter()]
        [System.Object]
        $Case,

        [Parameter()]
        [System.Object]
        $ExchangeLocation,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $SharePointLocation,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-CaseHoldRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $Disabled,

        [Parameter()]
        [System.Object]
        $ContentMatchQuery,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $Policy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-ComplianceCase
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $CaseType,

        [Parameter()]
        [System.Object]
        $Description,

        [Parameter()]
        [System.Object]
        $SourceCaseType,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $ExternalId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $SecondaryCaseType,

        [Parameter()]
        [System.Object]
        $DomainController,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-ComplianceRetentionEvent
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $SharePointAssetIdQuery,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $EventDateTime,

        [Parameter()]
        [System.Object]
        $AssetId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PreviewOnly,

        [Parameter()]
        [System.Object]
        $EventType,

        [Parameter()]
        [System.Object]
        $EventTags,

        [Parameter()]
        [System.Object]
        $DomainController,

        [Parameter()]
        [System.Object]
        $ExchangeAssetIdQuery,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-ComplianceRetentionEventType
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-ComplianceSearch
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $RefinerNames,

        [Parameter()]
        [System.Object]
        $Description,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $IncludeUserAppContent,

        [Parameter()]
        [System.Object]
        $SharePointLocationExclusion,

        [Parameter()]
        [System.Object]
        $AllowNotFoundExchangeLocationsEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $SharePointLocation,

        [Parameter()]
        [System.Object]
        $ExchangeLocation,

        [Parameter()]
        [System.Object]
        $Case,

        [Parameter()]
        [System.Object]
        $PublicFolderLocation,

        [Parameter()]
        [System.Object]
        $IncludeOrgContent,

        [Parameter()]
        [System.Object]
        $HoldNames,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $ExchangeLocationExclusion,

        [Parameter()]
        [System.Object]
        $Language,

        [Parameter()]
        [System.Object]
        $ContentMatchQuery,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-ComplianceSearchAction
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $SearchName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IncludeCredential,

        [Parameter()]
        [System.Object]
        $IncludeSharePointDocumentVersions,

        [Parameter()]
        [System.Object]
        $ReferenceActionName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $FileTypeExclusionsForUnindexedItems,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RetryOnError,

        [Parameter()]
        [System.Object]
        $Version,

        [Parameter()]
        [System.Object]
        $JobOptions,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RetentionReport,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Purge,

        [Parameter()]
        [System.Object]
        $PurgeType,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Report,

        [Parameter()]
        [System.Object]
        $Region,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $EnableDedupe,

        [Parameter()]
        [System.Object]
        $Scope,

        [Parameter()]
        [System.Object]
        $SearchNames,

        [Parameter()]
        [System.Object]
        $ActionName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-ComplianceTag
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $RetentionType,

        [Parameter()]
        [System.Object]
        $Regulatory,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $FilePlanProperty,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $RetentionAction,

        [Parameter()]
        [System.Object]
        $FlowId,

        [Parameter()]
        [System.Object]
        $IsRecordUnlockedAsDefault,

        [Parameter()]
        [System.Object]
        $ComplianceTagForNextStage,

        [Parameter()]
        [System.Object]
        $Notes,

        [Parameter()]
        [System.Object]
        $EventType,

        [Parameter()]
        [System.Object]
        $IsRecordLabel,

        [Parameter()]
        [System.Object]
        $ReviewerEmail,

        [Parameter()]
        [System.Object]
        $RetentionDuration,

        [Parameter()]
        [System.Object]
        $MultiStageReviewProperty,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-DeviceConditionalAccessPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-DeviceConfigurationPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-DlpCompliancePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $PowerBIDlpLocationException,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $PolicyTemplateInfo,

        [Parameter()]
        [System.Object]
        $EndpointDlpLocationException,

        [Parameter()]
        [System.Object]
        $ExchangeSenderMemberOfException,

        [Parameter()]
        [System.Object]
        $OneDriveSharedByMemberOf,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $SharePointLocation,

        [Parameter()]
        [System.Object]
        $Priority,

        [Parameter()]
        [System.Object]
        $ExceptIfOneDriveSharedBy,

        [Parameter()]
        [System.Object]
        $ExchangeLocation,

        [Parameter()]
        [System.Object]
        $OneDriveLocationException,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $TeamsLocationException,

        [Parameter()]
        [System.Object]
        $OneDriveSharedBy,

        [Parameter()]
        [System.Object]
        $OnPremisesScannerDlpLocation,

        [Parameter()]
        [System.Object]
        $EndpointDlpLocation,

        [Parameter()]
        [System.Object]
        $ExceptIfOneDriveSharedByMemberOf,

        [Parameter()]
        [System.Object]
        $PowerBIDlpLocation,

        [Parameter()]
        [System.Object]
        $ThirdPartyAppDlpLocation,

        [Parameter()]
        [System.Object]
        $OneDriveLocation,

        [Parameter()]
        [System.Object]
        $OnPremisesScannerDlpLocationException,

        [Parameter()]
        [System.Object]
        $ExchangeSenderMemberOf,

        [Parameter()]
        [System.Object]
        $TeamsLocation,

        [Parameter()]
        [System.Object]
        $ThirdPartyAppDlpLocationException,

        [Parameter()]
        [System.Object]
        $SharePointLocationException,

        [Parameter()]
        [System.Object]
        $Mode,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-DlpComplianceRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $ActivationDate,

        [Parameter()]
        [System.Object]
        $ProcessingLimitExceeded,

        [Parameter()]
        [System.Object]
        $ImmutableId,

        [Parameter()]
        [System.Object]
        $NotifyUser,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentIsPasswordProtected,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientADAttributeContainsWords,

        [Parameter()]
        [System.Object]
        $RecipientADAttributeMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentNameMatchesPatterns,

        [Parameter()]
        [System.Object]
        $SubjectContainsWords,

        [Parameter()]
        [System.Object]
        $NotifyEndpointUser,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderADAttributeContainsWords,

        [Parameter()]
        [System.Object]
        $NotifyEmailCustomSubject,

        [Parameter()]
        [System.Object]
        $FromMemberOf,

        [Parameter()]
        [System.Object]
        $ContentIsShared,

        [Parameter()]
        [System.Object]
        $ExceptIfSentToMemberOf,

        [Parameter()]
        [System.Object]
        $AddRecipients,

        [Parameter()]
        [System.Object]
        $ExceptIfUnscannableDocumentExtensionIs,

        [Parameter()]
        [System.Object]
        $RecipientDomainIs,

        [Parameter()]
        [System.Object]
        $SenderADAttributeContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfHeaderMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfFromScope,

        [Parameter()]
        [System.Object]
        $ExceptIfHeaderContainsWords,

        [Parameter()]
        [System.Object]
        $HeaderMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ContentPropertyContainsWords,

        [Parameter()]
        [System.Object]
        $HasSenderOverride,

        [Parameter()]
        [System.Object]
        $SetHeader,

        [Parameter()]
        [System.Object]
        $ExceptIfSubjectOrBodyMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ThirdPartyAppDlpRestrictions,

        [Parameter()]
        [System.Object]
        $Quarantine,

        [Parameter()]
        [System.Object]
        $ExceptIfAnyOfRecipientAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfContentCharacterSetContainsWords,

        [Parameter()]
        [System.Object]
        $EncryptRMSTemplate,

        [Parameter()]
        [System.Object]
        $ExceptIfAccessScope,

        [Parameter()]
        [System.Object]
        $ExceptIfMessageTypeMatches,

        [Parameter()]
        [System.Object]
        $SenderIPRanges,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentNameMatchesWords,

        [Parameter()]
        [System.Object]
        $ExceptIfContentFileTypeMatches,

        [Parameter()]
        [System.Object]
        $ExceptIfContentExtensionMatchesWords,

        [Parameter()]
        [System.Object]
        $RemoveHeader,

        [Parameter()]
        [System.Object]
        $ApplyHtmlDisclaimer,

        [Parameter()]
        [System.Object]
        $ExceptIfFromMemberOf,

        [Parameter()]
        [System.Object]
        $Moderate,

        [Parameter()]
        [System.Object]
        $ExceptIfContentContainsSensitiveInformation,

        [Parameter()]
        [System.Object]
        $GenerateAlert,

        [Parameter()]
        [System.Object]
        $PrependSubject,

        [Parameter()]
        [System.Object]
        $From,

        [Parameter()]
        [System.Object]
        $ExceptIfWithImportance,

        [Parameter()]
        [System.Object]
        $ContentCharacterSetContainsWords,

        [Parameter()]
        [System.Object]
        $ContentContainsSensitiveInformation,

        [Parameter()]
        [System.Object]
        $EndpointDlpRestrictions,

        [Parameter()]
        [System.Object]
        $SenderADAttributeMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderADAttributeMatchesPatterns,

        [Parameter()]
        [System.Object]
        $IncidentReportContent,

        [Parameter()]
        [System.Object]
        $DocumentContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfFrom,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentIsUnsupported,

        [Parameter()]
        [System.Object]
        $RestrictBrowserAccess,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentCreatedBy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $RuleErrorAction,

        [Parameter()]
        [System.Object]
        $FromScope,

        [Parameter()]
        [System.Object]
        $SentTo,

        [Parameter()]
        [System.Object]
        $ExceptIfFromAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $NotifyPolicyTipCustomText,

        [Parameter()]
        [System.Object]
        $ExceptIfFromAddressContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfProcessingLimitExceeded,

        [Parameter()]
        [System.Object]
        $DocumentNameMatchesPatterns,

        [Parameter()]
        [System.Object]
        $Priority,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderDomainIs,

        [Parameter()]
        [System.Object]
        $RedirectMessageTo,

        [Parameter()]
        [System.Object]
        $RemoveRMSTemplate,

        [Parameter()]
        [System.Object]
        $UnscannableDocumentExtensionIs,

        [Parameter()]
        [System.Object]
        $DocumentCreatedBy,

        [Parameter()]
        [System.Object]
        $ReportSeverityLevel,

        [Parameter()]
        [System.Object]
        $SenderDomainIs,

        [Parameter()]
        [System.Object]
        $MessageSizeOver,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentMatchesPatterns,

        [Parameter()]
        [System.Object]
        $DocumentNameMatchesWords,

        [Parameter()]
        [System.Object]
        $ExceptIfContentPropertyContainsWords,

        [Parameter()]
        [System.Object]
        $GenerateIncidentReport,

        [Parameter()]
        [System.Object]
        $FromAddressContainsWords,

        [Parameter()]
        [System.Object]
        $AnyOfRecipientAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfSubjectContainsWords,

        [Parameter()]
        [System.Object]
        $SubjectOrBodyMatchesPatterns,

        [Parameter()]
        [System.Object]
        $AdvancedRule,

        [Parameter()]
        [System.Object]
        $DocumentMatchesPatterns,

        [Parameter()]
        [System.Object]
        $EndpointDlpBrowserRestrictions,

        [Parameter()]
        [System.Object]
        $SubjectMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfSubjectMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfContentIsShared,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $ExceptIfAnyOfRecipientAddressContainsWords,

        [Parameter()]
        [System.Object]
        $AnyOfRecipientAddressContainsWords,

        [Parameter()]
        [System.Object]
        $HeaderContainsWords,

        [Parameter()]
        [System.Object]
        $AlertProperties,

        [Parameter()]
        [System.Object]
        $ContentExtensionMatchesWords,

        [Parameter()]
        [System.Object]
        $WithImportance,

        [Parameter()]
        [System.Object]
        $ExceptIfSentTo,

        [Parameter()]
        [System.Object]
        $DocumentIsUnsupported,

        [Parameter()]
        [System.Object]
        $DocumentCreatedByMemberOf,

        [Parameter()]
        [System.Object]
        $ContentIsNotLabeled,

        [Parameter()]
        [System.Object]
        $AccessScope,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentSizeOver,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $NotifyAllowOverride,

        [Parameter()]
        [System.Object]
        $NotifyOverrideRequirements,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderIPRanges,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientADAttributeMatchesPatterns,

        [Parameter()]
        [System.Object]
        $RecipientADAttributeContainsWords,

        [Parameter()]
        [System.Object]
        $OnPremisesScannerDlpRestrictions,

        [Parameter()]
        [System.Object]
        $ExpiryDate,

        [Parameter()]
        [System.Object]
        $StopPolicyProcessing,

        [Parameter()]
        [System.Object]
        $SentToMemberOf,

        [Parameter()]
        [System.Object]
        $DocumentSizeOver,

        [Parameter()]
        [System.Object]
        $ModifySubject,

        [Parameter()]
        [System.Object]
        $Disabled,

        [Parameter()]
        [System.Object]
        $ContentFileTypeMatches,

        [Parameter()]
        [System.Object]
        $NotifyEmailCustomText,

        [Parameter()]
        [System.Object]
        $BlockAccess,

        [Parameter()]
        [System.Object]
        $SenderAddressLocation,

        [Parameter()]
        [System.Object]
        $SubjectOrBodyContainsWords,

        [Parameter()]
        [System.Object]
        $NotifyPolicyTipCustomTextTranslations,

        [Parameter()]
        [System.Object]
        $Policy,

        [Parameter()]
        [System.Object]
        $NotifyUserType,

        [Parameter()]
        [System.Object]
        $NonBifurcatingAccessScope,

        [Parameter()]
        [System.Object]
        $DocumentIsPasswordProtected,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentContainsWords,

        [Parameter()]
        [System.Object]
        $FromAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $BlockAccessScope,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentCreatedByMemberOf,

        [Parameter()]
        [System.Object]
        $ExceptIfHasSenderOverride,

        [Parameter()]
        [System.Object]
        $ExceptIfSubjectOrBodyContainsWords,

        [Parameter()]
        [System.Object]
        $MessageTypeMatches,

        [Parameter()]
        [System.Object]
        $ExceptIfMessageSizeOver,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-FilePlanPropertyAuthority
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-FilePlanPropertyCategory
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-FilePlanPropertyCitation
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $CitationUrl,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $CitationJurisdiction,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-FilePlanPropertyDepartment
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-FilePlanPropertyReferenceId
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-FilePlanPropertySubCategory
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $ParentId,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-Label
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $EncryptionEncryptOnly,

        [Parameter()]
        [System.Object]
        $EncryptionDoubleKeyEncryptionUrl,

        [Parameter()]
        [System.Object]
        $ApplyContentMarkingHeaderText,

        [Parameter()]
        [System.Object]
        $ContentType,

        [Parameter()]
        [System.Object]
        $Setting,

        [Parameter()]
        [System.Object]
        $EncryptionEnabled,

        [Parameter()]
        [System.Object]
        $SiteAndGroupProtectionEnabled,

        [Parameter()]
        [System.Object]
        $ApplyContentMarkingFooterFontSize,

        [Parameter()]
        [System.Object]
        $ApplyWaterMarkingFontSize,

        [Parameter()]
        [System.Object]
        $ApplyContentMarkingHeaderFontColor,

        [Parameter()]
        [System.Object]
        $EncryptionContentExpiredOnDateInDaysOrNever,

        [Parameter()]
        [System.Object]
        $ApplyWaterMarkingText,

        [Parameter()]
        [System.Object]
        $ApplyWaterMarkingFontName,

        [Parameter()]
        [System.Object]
        $SiteAndGroupProtectionLevel,

        [Parameter()]
        [System.Object]
        $ApplyContentMarkingFooterText,

        [Parameter()]
        [System.Object]
        $ColumnAssetCondition,

        [Parameter()]
        [System.Object]
        $SiteAndGroupProtectionAllowEmailFromGuestUsers,

        [Parameter()]
        [System.Object]
        $SiteAndGroupProtectionAllowLimitedAccess,

        [Parameter()]
        [System.Object]
        $EncryptionDoNotForward,

        [Parameter()]
        [System.Object]
        $EncryptionAipTemplateScopes,

        [Parameter()]
        [System.Object]
        $ParentId,

        [Parameter()]
        [System.Object]
        $DisplayName,

        [Parameter()]
        [System.Object]
        $SchematizedDataCondition,

        [Parameter()]
        [System.Object]
        $ApplyContentMarkingFooterEnabled,

        [Parameter()]
        [System.Object]
        $Settings,

        [Parameter()]
        [System.Object]
        $MigrationId,

        [Parameter()]
        [System.Object]
        $ApplyWaterMarkingLayout,

        [Parameter()]
        [System.Object]
        $ApplyContentMarkingFooterMargin,

        [Parameter()]
        [System.Object]
        $EncryptionRightsDefinitions,

        [Parameter()]
        [System.Object]
        $ApplyContentMarkingFooterFontColor,

        [Parameter()]
        [System.Object]
        $ApplyContentMarkingFooterFontName,

        [Parameter()]
        [System.Object]
        $ApplyContentMarkingHeaderMargin,

        [Parameter()]
        [System.Object]
        $EncryptionLinkedTemplateId,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $ApplyContentMarkingHeaderAlignment,

        [Parameter()]
        [System.Object]
        $LabelActions,

        [Parameter()]
        [System.Object]
        $ApplyContentMarkingHeaderFontSize,

        [Parameter()]
        [System.Object]
        $LocaleSettings,

        [Parameter()]
        [System.Object]
        $AdvancedSettings,

        [Parameter()]
        [System.Object]
        $EncryptionProtectionType,

        [Parameter()]
        [System.Object]
        $ApplyContentMarkingHeaderFontName,

        [Parameter()]
        [System.Object]
        $ApplyContentMarkingFooterAlignment,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $SiteExternalSharingControlType,

        [Parameter()]
        [System.Object]
        $SiteAndGroupProtectionAllowAccessToGuestUsers,

        [Parameter()]
        [System.Object]
        $SiteAndGroupProtectionPrivacy,

        [Parameter()]
        [System.Object]
        $EncryptionPromptUser,

        [Parameter()]
        [System.Object]
        $Tooltip,

        [Parameter()]
        [System.Object]
        $SiteAndGroupProtectionBlockAccess,

        [Parameter()]
        [System.Object]
        $EncryptionOfflineAccessDays,

        [Parameter()]
        [System.Object]
        $ApplyContentMarkingHeaderEnabled,

        [Parameter()]
        [System.Object]
        $EncryptionTemplateId,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $SiteAndGroupProtectionAllowFullAccess,

        [Parameter()]
        [System.Object]
        $ApplyWaterMarkingFontColor,

        [Parameter()]
        [System.Object]
        $EncryptionRightsUrl,

        [Parameter()]
        [System.Object]
        $Conditions,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $ApplyWaterMarkingEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-LabelPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Labels,

        [Parameter()]
        [System.Object]
        $ModernGroupLocationException,

        [Parameter()]
        [System.Object]
        $Settings,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $AdvancedSettings,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $SharePointLocation,

        [Parameter()]
        [System.Object]
        $Setting,

        [Parameter()]
        [System.Object]
        $ExchangeLocation,

        [Parameter()]
        [System.Object]
        $OneDriveLocationException,

        [Parameter()]
        [System.Object]
        $PublicFolderLocation,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $MigrationId,

        [Parameter()]
        [System.Object]
        $ModernGroupLocation,

        [Parameter()]
        [System.Object]
        $ExchangeLocationException,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $OneDriveLocation,

        [Parameter()]
        [System.Object]
        $SkypeLocation,

        [Parameter()]
        [System.Object]
        $SkypeLocationException,

        [Parameter()]
        [System.Object]
        $SharePointLocationException,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-RetentionCompliancePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $ExchangeLocationException,

        [Parameter()]
        [System.Object]
        $TeamsChannelLocation,

        [Parameter()]
        [System.Object]
        $ModernGroupLocationException,

        [Parameter()]
        [System.Object]
        $Applications,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Object]
        $PolicyTemplateInfo,

        [Parameter()]
        [System.Object]
        $RetainCloudAttachment,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $SharePointLocation,

        [Parameter()]
        [System.Object]
        $ExchangeLocation,

        [Parameter()]
        [System.Object]
        $OneDriveLocationException,

        [Parameter()]
        [System.Object]
        $PublicFolderLocation,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $ModernGroupLocation,

        [Parameter()]
        [System.Object]
        $TeamsChatLocationException,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $TeamsChatLocation,

        [Parameter()]
        [System.Object]
        $OneDriveLocation,

        [Parameter()]
        [System.Object]
        $SkypeLocation,

        [Parameter()]
        [System.Object]
        $TeamsChannelLocationException,

        [Parameter()]
        [System.Object]
        $SkypeLocationException,

        [Parameter()]
        [System.Object]
        $SharePointLocationException,

        [Parameter()]
        [System.Object]
        $AdaptiveScopeLocation,

        [Parameter()]
        [System.Object]
        $RestrictiveRetention,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-RetentionComplianceRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $RetentionDuration,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $PublishComplianceTag,

        [Parameter()]
        [System.Object]
        $RetentionComplianceAction,

        [Parameter()]
        [System.Object]
        $ContentMatchQuery,

        [Parameter()]
        [System.Object]
        $ApplyComplianceTag,

        [Parameter()]
        [System.Object]
        $ExpirationDateOption,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $MachineLearningModelIDs,

        [Parameter()]
        [System.Object]
        $ExcludedItemClasses,

        [Parameter()]
        [System.Object]
        $ContentContainsSensitiveInformation,

        [Parameter()]
        [System.Object]
        $Policy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $RetentionDurationDisplayHint,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-SupervisoryReviewPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Description,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $Condition,

        [Parameter()]
        [System.Object]
        $PolicyType,

        [Parameter()]
        [System.Object]
        $Reviewers,

        [Parameter()]
        [System.Object]
        $SamplingRate,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-SupervisoryReviewPolicyV2
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $UserReportingWorkloads,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Object]
        $Reviewers,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-SupervisoryReviewRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $ContentSources,

        [Parameter()]
        [System.Object]
        $Condition,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $Ocr,

        [Parameter()]
        [System.Object]
        $ContentContainsSensitiveInformation,

        [Parameter()]
        [System.Object]
        $ContentMatchesDataModel,

        [Parameter()]
        [System.Object]
        $Policy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $CcsiDataModelOperator,

        [Parameter()]
        [System.Object]
        $SamplingRate,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-AuditConfigurationPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $DomainController,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-AutoSensitivityLabelPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-AutoSensitivityLabelRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-CaseHoldPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ForceDeletion,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-CaseHoldRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ForceDeletion,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-ComplianceCase
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $DomainController,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-ComplianceRetentionEvent
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PreviewOnly,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ForceDeletion,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-ComplianceRetentionEventType
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ForceDeletion,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-ComplianceSearch
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-ComplianceSearchAction
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-ComplianceTag
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ForceDeletion,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-DeviceConditionalAccessPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-DeviceConfigurationPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-DlpCompliancePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-DlpComplianceRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-FilePlanPropertyAuthority
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ForceDeletion,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-FilePlanPropertyCategory
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ForceDeletion,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-FilePlanPropertyCitation
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ForceDeletion,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-FilePlanPropertyDepartment
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ForceDeletion,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-FilePlanPropertyReferenceId
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ForceDeletion,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-FilePlanPropertySubCategory
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ForceDeletion,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-Label
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-LabelPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-RetentionCompliancePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ForceDeletion,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-RetentionComplianceRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ForceDeletion,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-SupervisoryReviewPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-SupervisoryReviewPolicyV2
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ForceDeletion,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-AutoSensitivityLabelPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $AddExchangeLocation,

        [Parameter()]
        [System.Object]
        $SpoAipIntegrationEnabled,

        [Parameter()]
        [System.Object]
        $PolicyTemplateInfo,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Object]
        $RemoveOneDriveLocationException,

        [Parameter()]
        [System.Object]
        $AddSharePointLocation,

        [Parameter()]
        [System.Object]
        $ExchangeSenderException,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $Priority,

        [Parameter()]
        [System.Object]
        $RemoveSharePointLocation,

        [Parameter()]
        [System.Object]
        $AddOneDriveLocationException,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RetryDistribution,

        [Parameter()]
        [System.Object]
        $ExchangeSender,

        [Parameter()]
        [System.Object]
        $AddSharePointLocationException,

        [Parameter()]
        [System.Object]
        $ApplySensitivityLabel,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $RemoveSharePointLocationException,

        [Parameter()]
        [System.Object]
        $RemoveExchangeLocation,

        [Parameter()]
        [System.Object]
        $ExchangeSenderMemberOf,

        [Parameter()]
        [System.Object]
        $StartSimulation,

        [Parameter()]
        [System.Object]
        $ExchangeSenderMemberOfException,

        [Parameter()]
        [System.Object]
        $RemoveOneDriveLocation,

        [Parameter()]
        [System.Object]
        $AddOneDriveLocation,

        [Parameter()]
        [System.Object]
        $AutoEnableAfter,

        [Parameter()]
        [System.Object]
        $Mode,

        [Parameter()]
        [System.Object]
        $OverwriteLabel,

        [Parameter()]
        [System.Object]
        $ExternalMailRightsManagementOwner,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-AutoSensitivityLabelRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $RecipientDomainIs,

        [Parameter()]
        [System.Object]
        $HeaderMatchesPatterns,

        [Parameter()]
        [System.Object]
        $FromAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfFrom,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $FromAddressContainsWords,

        [Parameter()]
        [System.Object]
        $SentToMemberOf,

        [Parameter()]
        [System.Object]
        $ExceptIfProcessingLimitExceeded,

        [Parameter()]
        [System.Object]
        $ExpiryDate,

        [Parameter()]
        [System.Object]
        $ExceptIfContentContainsSensitiveInformation,

        [Parameter()]
        [System.Object]
        $ExceptIfAnyOfRecipientAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ProcessingLimitExceeded,

        [Parameter()]
        [System.Object]
        $ExceptIfAccessScope,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Workload,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentIsUnsupported,

        [Parameter()]
        [System.Object]
        $From,

        [Parameter()]
        [System.Object]
        $Priority,

        [Parameter()]
        [System.Object]
        $SenderDomainIs,

        [Parameter()]
        [System.Object]
        $ExceptIfContentExtensionMatchesWords,

        [Parameter()]
        [System.Object]
        $ContentExtensionMatchesWords,

        [Parameter()]
        [System.Object]
        $ExceptIfFromAddressContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfSentTo,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.Object]
        $ExceptIfAnyOfRecipientAddressContainsWords,

        [Parameter()]
        [System.Object]
        $AnyOfRecipientAddressContainsWords,

        [Parameter()]
        [System.Object]
        $SenderIPRanges,

        [Parameter()]
        [System.Object]
        $AnyOfRecipientAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderDomainIs,

        [Parameter()]
        [System.Object]
        $ExceptIfSubjectMatchesPatterns,

        [Parameter()]
        [System.Object]
        $SentTo,

        [Parameter()]
        [System.Object]
        $ActivationDate,

        [Parameter()]
        [System.Object]
        $DocumentIsUnsupported,

        [Parameter()]
        [System.Object]
        $Disabled,

        [Parameter()]
        [System.Object]
        $RuleErrorAction,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $FromMemberOf,

        [Parameter()]
        [System.Object]
        $AccessScope,

        [Parameter()]
        [System.Object]
        $ExceptIfSentToMemberOf,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderIPRanges,

        [Parameter()]
        [System.Object]
        $ContentContainsSensitiveInformation,

        [Parameter()]
        [System.Object]
        $DocumentIsPasswordProtected,

        [Parameter()]
        [System.Object]
        $ExceptIfFromAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfHeaderMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ReportSeverityLevel,

        [Parameter()]
        [System.Object]
        $SubjectMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfFromMemberOf,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentIsPasswordProtected,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-CaseHoldPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $RemoveExchangeLocation,

        [Parameter()]
        [System.Object]
        $RemoveSharePointLocation,

        [Parameter()]
        [System.Object]
        $AddExchangeLocation,

        [Parameter()]
        [System.Object]
        $AddSharePointLocation,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RetryDistribution,

        [Parameter()]
        [System.Object]
        $RemovePublicFolderLocation,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $AddPublicFolderLocation,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-CaseHoldRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Disabled,

        [Parameter()]
        [System.Object]
        $ContentMatchQuery,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-ComplianceCase
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $CaseType,

        [Parameter()]
        [System.Object]
        $Description,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $ExternalId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Reopen,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Close,

        [Parameter()]
        [System.Object]
        $DomainController,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-ComplianceRetentionEvent
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Action,

        [Parameter()]
        [System.Object]
        $SharePointAssetIdQuery,

        [Parameter()]
        [System.Object]
        $AssetId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $EventType,

        [Parameter()]
        [System.Object]
        $EventTags,

        [Parameter()]
        [System.Object]
        $DomainController,

        [Parameter()]
        [System.Object]
        $ExchangeAssetIdQuery,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-ComplianceRetentionEventType
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-ComplianceSearch
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $RefinerNames,

        [Parameter()]
        [System.Object]
        $ContentMatchQuery,

        [Parameter()]
        [System.Object]
        $Description,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $SharePointLocation,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $AddSharePointLocation,

        [Parameter()]
        [System.Object]
        $AddExchangeLocationExclusion,

        [Parameter()]
        [System.Object]
        $IncludeUserAppContent,

        [Parameter()]
        [System.Object]
        $SharePointLocationExclusion,

        [Parameter()]
        [System.Object]
        $AllowNotFoundExchangeLocationsEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $ExchangeLocationExclusion,

        [Parameter()]
        [System.Object]
        $AddSharePointLocationExclusion,

        [Parameter()]
        [System.Object]
        $RemovePublicFolderLocation,

        [Parameter()]
        [System.Object]
        $RemoveSharePointLocation,

        [Parameter()]
        [System.Object]
        $ExchangeLocation,

        [Parameter()]
        [System.Object]
        $PublicFolderLocation,

        [Parameter()]
        [System.Object]
        $RemoveSharePointLocationExclusion,

        [Parameter()]
        [System.Object]
        $IncludeOrgContent,

        [Parameter()]
        [System.Object]
        $RemoveExchangeLocationExclusion,

        [Parameter()]
        [System.Object]
        $HoldNames,

        [Parameter()]
        [System.Object]
        $RemoveExchangeLocation,

        [Parameter()]
        [System.Object]
        $AddExchangeLocation,

        [Parameter()]
        [System.Object]
        $Language,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-ComplianceTag
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $FilePlanProperty,

        [Parameter()]
        [System.Object]
        $RetentionDuration,

        [Parameter()]
        [System.Object]
        $Notes,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $MultiStageReviewProperty,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $FlowId,

        [Parameter()]
        [System.Object]
        $ReviewerEmail,

        [Parameter()]
        [System.Object]
        $EventType,

        [Parameter()]
        [System.Object]
        $ComplianceTagForNextStage,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-DeviceConditionalAccessPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RetryDistribution,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-DeviceConfigurationPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RetryDistribution,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-DlpCompliancePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $OneDriveSharedBy,

        [Parameter()]
        [System.Object]
        $RemovePowerBIDlpLocationException,

        [Parameter()]
        [System.Object]
        $RemoveTeamsLocation,

        [Parameter()]
        [System.Object]
        $RemoveThirdPartyAppDlpLocationException,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $RemoveEndpointDlpLocation,

        [Parameter()]
        [System.Object]
        $OneDriveSharedByMemberOf,

        [Parameter()]
        [System.Object]
        $PolicyTemplateInfo,

        [Parameter()]
        [System.Object]
        $AddExchangeLocation,

        [Parameter()]
        [System.Object]
        $AddTeamsLocation,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $RemoveThirdPartyAppDlpLocation,

        [Parameter()]
        [System.Object]
        $Priority,

        [Parameter()]
        [System.Object]
        $RemoveTeamsLocationException,

        [Parameter()]
        [System.Object]
        $RemoveOneDriveLocationException,

        [Parameter()]
        [System.Object]
        $RemoveSharePointLocation,

        [Parameter()]
        [System.Object]
        $ExceptIfOneDriveSharedBy,

        [Parameter()]
        [System.Object]
        $AddOneDriveLocationException,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RetryDistribution,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $AddEndpointDlpLocation,

        [Parameter()]
        [System.Object]
        $AddSharePointLocation,

        [Parameter()]
        [System.Object]
        $RemovePowerBIDlpLocation,

        [Parameter()]
        [System.Object]
        $AddPowerBIDlpLocation,

        [Parameter()]
        [System.Object]
        $AddThirdPartyAppDlpLocation,

        [Parameter()]
        [System.Object]
        $AddSharePointLocationException,

        [Parameter()]
        [System.Object]
        $AddTeamsLocationException,

        [Parameter()]
        [System.Object]
        $ExceptIfOneDriveSharedByMemberOf,

        [Parameter()]
        [System.Object]
        $AddThirdPartyAppDlpLocationException,

        [Parameter()]
        [System.Object]
        $AddEndpointDlpLocationException,

        [Parameter()]
        [System.Object]
        $AddOnPremisesScannerDlpLocation,

        [Parameter()]
        [System.Object]
        $AddPowerBIDlpLocationException,

        [Parameter()]
        [System.Object]
        $RemoveSharePointLocationException,

        [Parameter()]
        [System.Object]
        $RemoveExchangeLocation,

        [Parameter()]
        [System.Object]
        $ExchangeSenderMemberOf,

        [Parameter()]
        [System.Object]
        $ExchangeSenderMemberOfException,

        [Parameter()]
        [System.Object]
        $RemoveOneDriveLocation,

        [Parameter()]
        [System.Object]
        $RemoveOnPremisesScannerDlpLocationException,

        [Parameter()]
        [System.Object]
        $AddOneDriveLocation,

        [Parameter()]
        [System.Object]
        $RemoveOnPremisesScannerDlpLocation,

        [Parameter()]
        [System.Object]
        $Mode,

        [Parameter()]
        [System.Object]
        $RemoveEndpointDlpLocationException,

        [Parameter()]
        [System.Object]
        $AddOnPremisesScannerDlpLocationException,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-DlpComplianceRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $ActivationDate,

        [Parameter()]
        [System.Object]
        $ProcessingLimitExceeded,

        [Parameter()]
        [System.Object]
        $NotifyUser,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentIsPasswordProtected,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientADAttributeContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentNameMatchesPatterns,

        [Parameter()]
        [System.Object]
        $SubjectContainsWords,

        [Parameter()]
        [System.Object]
        $NotifyEndpointUser,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderADAttributeContainsWords,

        [Parameter()]
        [System.Object]
        $NotifyEmailCustomSubject,

        [Parameter()]
        [System.Object]
        $FromMemberOf,

        [Parameter()]
        [System.Object]
        $ContentIsShared,

        [Parameter()]
        [System.Object]
        $ExceptIfSentToMemberOf,

        [Parameter()]
        [System.Object]
        $AddRecipients,

        [Parameter()]
        [System.Object]
        $ExceptIfUnscannableDocumentExtensionIs,

        [Parameter()]
        [System.Object]
        $RecipientDomainIs,

        [Parameter()]
        [System.Object]
        $SenderADAttributeContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfHeaderMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfFromScope,

        [Parameter()]
        [System.Object]
        $ExceptIfHeaderContainsWords,

        [Parameter()]
        [System.Object]
        $HeaderMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ContentPropertyContainsWords,

        [Parameter()]
        [System.Object]
        $HasSenderOverride,

        [Parameter()]
        [System.Object]
        $SetHeader,

        [Parameter()]
        [System.Object]
        $ExceptIfSubjectOrBodyMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfHasSenderOverride,

        [Parameter()]
        [System.Object]
        $Quarantine,

        [Parameter()]
        [System.Object]
        $ExceptIfAnyOfRecipientAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfContentCharacterSetContainsWords,

        [Parameter()]
        [System.Object]
        $EncryptRMSTemplate,

        [Parameter()]
        [System.Object]
        $ExceptIfAccessScope,

        [Parameter()]
        [System.Object]
        $ExceptIfMessageTypeMatches,

        [Parameter()]
        [System.Object]
        $SenderIPRanges,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentNameMatchesWords,

        [Parameter()]
        [System.Object]
        $ExceptIfContentFileTypeMatches,

        [Parameter()]
        [System.Object]
        $ExceptIfContentExtensionMatchesWords,

        [Parameter()]
        [System.Object]
        $RemoveHeader,

        [Parameter()]
        [System.Object]
        $ApplyHtmlDisclaimer,

        [Parameter()]
        [System.Object]
        $ExceptIfFromMemberOf,

        [Parameter()]
        [System.Object]
        $Moderate,

        [Parameter()]
        [System.Object]
        $ExceptIfContentContainsSensitiveInformation,

        [Parameter()]
        [System.Object]
        $GenerateAlert,

        [Parameter()]
        [System.Object]
        $PrependSubject,

        [Parameter()]
        [System.Object]
        $From,

        [Parameter()]
        [System.Object]
        $ExceptIfWithImportance,

        [Parameter()]
        [System.Object]
        $ContentCharacterSetContainsWords,

        [Parameter()]
        [System.Object]
        $ContentContainsSensitiveInformation,

        [Parameter()]
        [System.Object]
        $EndpointDlpRestrictions,

        [Parameter()]
        [System.Object]
        $SenderADAttributeMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderADAttributeMatchesPatterns,

        [Parameter()]
        [System.Object]
        $IncidentReportContent,

        [Parameter()]
        [System.Object]
        $DocumentContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfFrom,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentIsUnsupported,

        [Parameter()]
        [System.Object]
        $RestrictBrowserAccess,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentCreatedBy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $RuleErrorAction,

        [Parameter()]
        [System.Object]
        $FromScope,

        [Parameter()]
        [System.Object]
        $SentTo,

        [Parameter()]
        [System.Object]
        $ExceptIfFromAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $NotifyPolicyTipCustomText,

        [Parameter()]
        [System.Object]
        $ExceptIfFromAddressContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfProcessingLimitExceeded,

        [Parameter()]
        [System.Object]
        $DocumentNameMatchesPatterns,

        [Parameter()]
        [System.Object]
        $Priority,

        [Parameter()]
        [System.Object]
        $OnPremisesScannerDlpRestrictions,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderDomainIs,

        [Parameter()]
        [System.Object]
        $RedirectMessageTo,

        [Parameter()]
        [System.Object]
        $RemoveRMSTemplate,

        [Parameter()]
        [System.Object]
        $UnscannableDocumentExtensionIs,

        [Parameter()]
        [System.Object]
        $DocumentCreatedBy,

        [Parameter()]
        [System.Object]
        $ReportSeverityLevel,

        [Parameter()]
        [System.Object]
        $SenderDomainIs,

        [Parameter()]
        [System.Object]
        $MessageSizeOver,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentMatchesPatterns,

        [Parameter()]
        [System.Object]
        $DocumentNameMatchesWords,

        [Parameter()]
        [System.Object]
        $ExceptIfContentPropertyContainsWords,

        [Parameter()]
        [System.Object]
        $GenerateIncidentReport,

        [Parameter()]
        [System.Object]
        $FromAddressContainsWords,

        [Parameter()]
        [System.Object]
        $AnyOfRecipientAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ContentIsNotLabeled,

        [Parameter()]
        [System.Object]
        $ExceptIfSubjectContainsWords,

        [Parameter()]
        [System.Object]
        $SubjectOrBodyMatchesPatterns,

        [Parameter()]
        [System.Object]
        $AdvancedRule,

        [Parameter()]
        [System.Object]
        $DocumentMatchesPatterns,

        [Parameter()]
        [System.Object]
        $EndpointDlpBrowserRestrictions,

        [Parameter()]
        [System.Object]
        $SubjectMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfSubjectMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfContentIsShared,

        [Parameter()]
        [System.Object]
        $ExceptIfAnyOfRecipientAddressContainsWords,

        [Parameter()]
        [System.Object]
        $AnyOfRecipientAddressContainsWords,

        [Parameter()]
        [System.Object]
        $HeaderContainsWords,

        [Parameter()]
        [System.Object]
        $AlertProperties,

        [Parameter()]
        [System.Object]
        $ContentExtensionMatchesWords,

        [Parameter()]
        [System.Object]
        $WithImportance,

        [Parameter()]
        [System.Object]
        $ExceptIfSentTo,

        [Parameter()]
        [System.Object]
        $DocumentIsUnsupported,

        [Parameter()]
        [System.Object]
        $DocumentCreatedByMemberOf,

        [Parameter()]
        [System.Object]
        $RecipientADAttributeMatchesPatterns,

        [Parameter()]
        [System.Object]
        $AccessScope,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentSizeOver,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $NotifyAllowOverride,

        [Parameter()]
        [System.Object]
        $NotifyOverrideRequirements,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderIPRanges,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientADAttributeMatchesPatterns,

        [Parameter()]
        [System.Object]
        $RecipientADAttributeContainsWords,

        [Parameter()]
        [System.Object]
        $ThirdPartyAppDlpRestrictions,

        [Parameter()]
        [System.Object]
        $ExpiryDate,

        [Parameter()]
        [System.Object]
        $StopPolicyProcessing,

        [Parameter()]
        [System.Object]
        $SentToMemberOf,

        [Parameter()]
        [System.Object]
        $DocumentSizeOver,

        [Parameter()]
        [System.Object]
        $ModifySubject,

        [Parameter()]
        [System.Object]
        $Disabled,

        [Parameter()]
        [System.Object]
        $ContentFileTypeMatches,

        [Parameter()]
        [System.Object]
        $NotifyEmailCustomText,

        [Parameter()]
        [System.Object]
        $BlockAccess,

        [Parameter()]
        [System.Object]
        $SenderAddressLocation,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $SubjectOrBodyContainsWords,

        [Parameter()]
        [System.Object]
        $NotifyPolicyTipCustomTextTranslations,

        [Parameter()]
        [System.Object]
        $NotifyUserType,

        [Parameter()]
        [System.Object]
        $NonBifurcatingAccessScope,

        [Parameter()]
        [System.Object]
        $DocumentIsPasswordProtected,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentContainsWords,

        [Parameter()]
        [System.Object]
        $FromAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $BlockAccessScope,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentCreatedByMemberOf,

        [Parameter()]
        [System.Object]
        $ExceptIfSubjectOrBodyContainsWords,

        [Parameter()]
        [System.Object]
        $MessageTypeMatches,

        [Parameter()]
        [System.Object]
        $ExceptIfMessageSizeOver,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-FilePlanPropertyCitation
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $DisplayName,

        [Parameter()]
        [System.Object]
        $CitationUrl,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $CitationJurisdiction,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-Label
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $EncryptionEncryptOnly,

        [Parameter()]
        [System.Object]
        $EncryptionDoubleKeyEncryptionUrl,

        [Parameter()]
        [System.Object]
        $ApplyContentMarkingHeaderText,

        [Parameter()]
        [System.Object]
        $ContentType,

        [Parameter()]
        [System.Object]
        $Setting,

        [Parameter()]
        [System.Object]
        $EncryptionEnabled,

        [Parameter()]
        [System.Object]
        $SiteAndGroupProtectionEnabled,

        [Parameter()]
        [System.Object]
        $ApplyContentMarkingFooterFontSize,

        [Parameter()]
        [System.Object]
        $ApplyWaterMarkingFontSize,

        [Parameter()]
        [System.Object]
        $ApplyContentMarkingHeaderFontColor,

        [Parameter()]
        [System.Object]
        $Conditions,

        [Parameter()]
        [System.Object]
        $EncryptionContentExpiredOnDateInDaysOrNever,

        [Parameter()]
        [System.Object]
        $ApplyWaterMarkingText,

        [Parameter()]
        [System.Object]
        $ApplyWaterMarkingFontName,

        [Parameter()]
        [System.Object]
        $SiteAndGroupProtectionLevel,

        [Parameter()]
        [System.Object]
        $ApplyContentMarkingFooterText,

        [Parameter()]
        [System.Object]
        $ColumnAssetCondition,

        [Parameter()]
        [System.Object]
        $SiteAndGroupProtectionAllowEmailFromGuestUsers,

        [Parameter()]
        [System.Object]
        $SiteAndGroupProtectionAllowLimitedAccess,

        [Parameter()]
        [System.Object]
        $EncryptionDoNotForward,

        [Parameter()]
        [System.Object]
        $ParentId,

        [Parameter()]
        [System.Object]
        $DisplayName,

        [Parameter()]
        [System.Object]
        $SchematizedDataCondition,

        [Parameter()]
        [System.Object]
        $ApplyContentMarkingFooterEnabled,

        [Parameter()]
        [System.Object]
        $Settings,

        [Parameter()]
        [System.Object]
        $MigrationId,

        [Parameter()]
        [System.Object]
        $ApplyWaterMarkingLayout,

        [Parameter()]
        [System.Object]
        $ApplyContentMarkingFooterMargin,

        [Parameter()]
        [System.Object]
        $EncryptionRightsDefinitions,

        [Parameter()]
        [System.Object]
        $ApplyContentMarkingFooterFontColor,

        [Parameter()]
        [System.Object]
        $PreviousLabel,

        [Parameter()]
        [System.Object]
        $ApplyContentMarkingFooterFontName,

        [Parameter()]
        [System.Object]
        $ApplyContentMarkingHeaderMargin,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $ApplyContentMarkingHeaderAlignment,

        [Parameter()]
        [System.Object]
        $LabelActions,

        [Parameter()]
        [System.Object]
        $ApplyContentMarkingHeaderFontSize,

        [Parameter()]
        [System.Object]
        $LocaleSettings,

        [Parameter()]
        [System.Object]
        $AdvancedSettings,

        [Parameter()]
        [System.Object]
        $EncryptionProtectionType,

        [Parameter()]
        [System.Object]
        $ApplyContentMarkingHeaderFontName,

        [Parameter()]
        [System.Object]
        $ApplyContentMarkingFooterAlignment,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $SiteExternalSharingControlType,

        [Parameter()]
        [System.Object]
        $Priority,

        [Parameter()]
        [System.Object]
        $SiteAndGroupProtectionAllowAccessToGuestUsers,

        [Parameter()]
        [System.Object]
        $SiteAndGroupProtectionPrivacy,

        [Parameter()]
        [System.Object]
        $EncryptionPromptUser,

        [Parameter()]
        [System.Object]
        $Tooltip,

        [Parameter()]
        [System.Object]
        $SiteAndGroupProtectionBlockAccess,

        [Parameter()]
        [System.Object]
        $EncryptionOfflineAccessDays,

        [Parameter()]
        [System.Object]
        $ApplyContentMarkingHeaderEnabled,

        [Parameter()]
        [System.Object]
        $SiteAndGroupProtectionAllowFullAccess,

        [Parameter()]
        [System.Object]
        $ApplyWaterMarkingFontColor,

        [Parameter()]
        [System.Object]
        $EncryptionRightsUrl,

        [Parameter()]
        [System.Object]
        $NextLabel,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $ApplyWaterMarkingEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-LabelPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Settings,

        [Parameter()]
        [System.Object]
        $AddExchangeLocation,

        [Parameter()]
        [System.Object]
        $PreviousLabelPolicy,

        [Parameter()]
        [System.Object]
        $AddExchangeLocationException,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $RemoveExchangeLocationException,

        [Parameter()]
        [System.Object]
        $Setting,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $RemoveOneDriveLocationException,

        [Parameter()]
        [System.Object]
        $AddSharePointLocation,

        [Parameter()]
        [System.Object]
        $AdvancedSettings,

        [Parameter()]
        [System.Object]
        $RemoveModernGroupLocation,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $AddLabels,

        [Parameter()]
        [System.Object]
        $RemovePublicFolderLocation,

        [Parameter()]
        [System.Object]
        $RemoveModernGroupLocationException,

        [Parameter()]
        [System.Object]
        $AddModernGroupLocationException,

        [Parameter()]
        [System.Object]
        $RemoveSharePointLocation,

        [Parameter()]
        [System.Object]
        $AddOneDriveLocationException,

        [Parameter()]
        [System.Object]
        $AddModernGroupLocation,

        [Parameter()]
        [System.Object]
        $AddSkypeLocation,

        [Parameter()]
        [System.Object]
        $AddPublicFolderLocation,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RetryDistribution,

        [Parameter()]
        [System.Object]
        $MigrationId,

        [Parameter()]
        [System.Object]
        $AddSharePointLocationException,

        [Parameter()]
        [System.Object]
        $RemoveSkypeLocationException,

        [Parameter()]
        [System.Object]
        $RemoveSharePointLocationException,

        [Parameter()]
        [System.Object]
        $NextLabelPolicy,

        [Parameter()]
        [System.Object]
        $RemoveExchangeLocation,

        [Parameter()]
        [System.Object]
        $RemoveSkypeLocation,

        [Parameter()]
        [System.Object]
        $RemoveOneDriveLocation,

        [Parameter()]
        [System.Object]
        $AddOneDriveLocation,

        [Parameter()]
        [System.Object]
        $AddSkypeLocationException,

        [Parameter()]
        [System.Object]
        $RemoveLabels,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-RetentionCompliancePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $AddExchangeLocation,

        [Parameter()]
        [System.Object]
        $AddExchangeLocationException,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $RemoveTeamsChatLocation,

        [Parameter()]
        [System.Object]
        $RemoveExchangeLocationException,

        [Parameter()]
        [System.Object]
        $Applications,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $RemoveOneDriveLocationException,

        [Parameter()]
        [System.Object]
        $PolicyTemplateInfo,

        [Parameter()]
        [System.Object]
        $AddTeamsChatLocationException,

        [Parameter()]
        [System.Object]
        $AddSkypeLocation,

        [Parameter()]
        [System.Object]
        $RemoveModernGroupLocation,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $RemovePublicFolderLocation,

        [Parameter()]
        [System.Object]
        $RemoveModernGroupLocationException,

        [Parameter()]
        [System.Object]
        $AddModernGroupLocationException,

        [Parameter()]
        [System.Object]
        $AddTeamsChatLocation,

        [Parameter()]
        [System.Object]
        $RemoveSharePointLocation,

        [Parameter()]
        [System.Object]
        $AddOneDriveLocationException,

        [Parameter()]
        [System.Object]
        $AddModernGroupLocation,

        [Parameter()]
        [System.Object]
        $AddTeamsChannelLocationException,

        [Parameter()]
        [System.Object]
        $AddPublicFolderLocation,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RetryDistribution,

        [Parameter()]
        [System.Object]
        $RemoveTeamsChatLocationException,

        [Parameter()]
        [System.Object]
        $AddSharePointLocation,

        [Parameter()]
        [System.Object]
        $RemoveTeamsChannelLocation,

        [Parameter()]
        [System.Object]
        $AddAdaptiveScopeLocation,

        [Parameter()]
        [System.Object]
        $AddSharePointLocationException,

        [Parameter()]
        [System.Object]
        $RemoveTeamsChannelLocationException,

        [Parameter()]
        [System.Object]
        $AddTeamsChannelLocation,

        [Parameter()]
        [System.Object]
        $RemoveSkypeLocationException,

        [Parameter()]
        [System.Object]
        $RemoveSharePointLocationException,

        [Parameter()]
        [System.Object]
        $RemoveExchangeLocation,

        [Parameter()]
        [System.Object]
        $RemoveAdaptiveScopeLocation,

        [Parameter()]
        [System.Object]
        $RemoveSkypeLocation,

        [Parameter()]
        [System.Object]
        $RemoveOneDriveLocation,

        [Parameter()]
        [System.Object]
        $AddOneDriveLocation,

        [Parameter()]
        [System.Object]
        $AddSkypeLocationException,

        [Parameter()]
        [System.Object]
        $RestrictiveRetention,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-RetentionComplianceRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $ContentDateFrom,

        [Parameter()]
        [System.Object]
        $RetentionDuration,

        [Parameter()]
        [System.Object]
        $ExcludedItemClasses,

        [Parameter()]
        [System.Object]
        $RetentionComplianceAction,

        [Parameter()]
        [System.Object]
        $ContentMatchQuery,

        [Parameter()]
        [System.Object]
        $ApplyComplianceTag,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $ExpirationDateOption,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $ContentContainsSensitiveInformation,

        [Parameter()]
        [System.Object]
        $ContentDateTo,

        [Parameter()]
        [System.Object]
        $RetentionDurationDisplayHint,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-SupervisoryReviewPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Description,

        [Parameter()]
        [System.Object]
        $AddReviewers,

        [Parameter()]
        [System.Object]
        $Condition,

        [Parameter()]
        [System.Object]
        $PolicyType,

        [Parameter()]
        [System.Object]
        $RemoveReviewers,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Reviewers,

        [Parameter()]
        [System.Object]
        $SamplingRate,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-SupervisoryReviewPolicyV2
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $AddReviewers,

        [Parameter()]
        [System.Object]
        $UserReportingWorkloads,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Object]
        $Reviewers,

        [Parameter()]
        [System.Object]
        $RetentionPeriodInDays,

        [Parameter()]
        [System.Object]
        $RemoveReviewers,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-SupervisoryReviewRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $ContentSources,

        [Parameter()]
        [System.Object]
        $ContentContainsSensitiveInformation,

        [Parameter()]
        [System.Object]
        $Condition,

        [Parameter()]
        [System.Object]
        $Ocr,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $ContentMatchesDataModel,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $CcsiDataModelOperator,

        [Parameter()]
        [System.Object]
        $SamplingRate,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Start-ComplianceSearch
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RetryOnError,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
#endregion
#region PnP
function Add-PnPApp
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Publish,

        [Parameter()]
        [System.Int32]
        $Timeout,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $SkipFeatureDeployment,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Overwrite,

        [Parameter()]
        [PnP.Framework.Enums.AppCatalogScope]
        $Scope,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.String]
        $Path
    )
}
function Add-PnPHubSiteAssociation
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.SitePipeBind]
        $HubSite,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.SitePipeBind]
        $Site,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
function Add-PnPOrgAssetsLibrary
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $ThumbnailUrl,

        [Parameter()]
        [Microsoft.SharePoint.Administration.OrgAssetType]
        $OrgAssetType,

        [Parameter()]
        [System.String]
        $LibraryUrl,

        [Parameter()]
        [Microsoft.Online.SharePoint.TenantAdministration.SPOTenantCdnType]
        $CdnType,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
function Add-PnPSiteDesign
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $ThumbnailUrl,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [PnP.PowerShell.Commands.Enums.SiteWebTemplate]
        $WebTemplate,

        [Parameter()]
        [System.Guid[]]
        $SiteScriptIds,

        [Parameter()]
        [System.String]
        $Title,

        [Parameter()]
        [System.String]
        $PreviewImageUrl,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.String]
        $PreviewImageAltText,

        [Parameter()]
        [System.Guid]
        $DesignPackageId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsDefault
    )
}
function Add-PnPSiteScript
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $Title,

        [Parameter()]
        [System.String]
        $Content,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
function Add-PnPTenantTheme
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Overwrite,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.ThemePipeBind]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $IsInverted,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.ThemePalettePipeBind]
        $Palette
    )
}
function Get-PnPApp
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.AppMetadataPipeBind]
        $Identity,

        [Parameter()]
        [PnP.Framework.Enums.AppCatalogScope]
        $Scope,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
function Get-PnPAuditing
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
function Get-PnPAvailableLanguage
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
function Get-PnPBrowserIdleSignout
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
function Get-PnPContext
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
function Get-PnPFile
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsFileObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsListItem,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsFile,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsMemoryStream,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.WebPipeBind]
        $Web,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ThrowExceptionIfFileNotFound,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.String]
        $Url,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsString,

        [Parameter()]
        [System.String]
        $Path,

        [Parameter()]
        [System.String]
        $Filename,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )
}
function Get-PnPGroup
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AssociatedOwnerGroup,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AssociatedMemberGroup,

        [Parameter()]
        [System.String[]]
        $Includes,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AssociatedVisitorGroup,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.WebPipeBind]
        $Web,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.GroupPipeBind]
        $Identity,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
function Get-PnPGroupPermissions
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.WebPipeBind]
        $Web,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.GroupPipeBind]
        $Identity,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
function Get-PnPHomeSite
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
function Get-PnPHubSite
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.HubSitePipeBind]
        $Identity,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
function Get-PnPOrgAssetsLibrary
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
function Get-PnPProperty
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.SharePoint.Client.ClientObject]
        $ClientObject,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.String[]]
        $Property
    )
}
function Get-PnPPropertyBag
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Folder,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.WebPipeBind]
        $Web,

        [Parameter()]
        [System.String]
        $Key,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
function Get-PnPSearchConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PnP.PowerShell.Commands.Search.BookmarkStatus]
        $BookmarkStatus,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.WebPipeBind]
        $Web,

        [Parameter()]
        [PnP.PowerShell.Commands.Enums.SearchConfigurationScope]
        $Scope,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.Boolean]
        $ExcludeVisualPromotedResults,

        [Parameter()]
        [PnP.PowerShell.Commands.Search.OutputFormat]
        $OutputFormat,

        [Parameter()]
        [System.String]
        $Path,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PromotedResultsToBookmarkCSV
    )
}
function Get-PnPSite
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.String[]]
        $Includes
    )
}
function Get-PnPSiteDesign
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.TenantSiteDesignPipeBind]
        $Identity,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
function Get-PnPSiteDesignRights
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.TenantSiteDesignPipeBind]
        $Identity,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
function Get-PnPSiteScript
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.TenantSiteDesignPipeBind]
        $SiteDesign,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.TenantSiteScriptPipeBind]
        $Identity,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
function Get-PnPStorageEntity
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PnP.PowerShell.Commands.Enums.StorageEntityScope]
        $Scope,

        [Parameter()]
        [System.String]
        $Key,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
function Get-PnPTenant
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
function Get-PnPTenantAppCatalogUrl
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
function Get-PnPTenantCdnEnabled
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Online.SharePoint.TenantAdministration.SPOTenantCdnType]
        $CdnType,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
function Get-PnPTenantCdnPolicies
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Online.SharePoint.TenantAdministration.SPOTenantCdnType]
        $CdnType,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
function Get-PnPTenantSite
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Detailed,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IncludeOneDriveSites,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $DisableSharingForNonOwnersStatus,

        [Parameter()]
        [System.String]
        $Template,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.SPOSitePipeBind]
        $Identity,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Boolean]
        $GroupIdDefined
    )
}
function Get-PnPTenantSyncClientRestriction
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
function Get-PnPTenantTheme
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJson
    )
}
function Get-PnPUser
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $WithRightsAssigned,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.WebPipeBind]
        $Web,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $WithRightsAssignedDetailed,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.UserPipeBind]
        $Identity,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.String[]]
        $Includes
    )
}
function Get-PnPUserProfileProperty
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Account,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
function Get-PnPWeb
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.WebPipeBind]
        $Identity,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.String[]]
        $Includes
    )
}
function Grant-PnPHubSiteRights
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Principals,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.HubSitePipeBind]
        $Identity,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
function Grant-PnPSiteDesignRights
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Principals,

        [Parameter()]
        [Microsoft.Online.SharePoint.TenantAdministration.TenantSiteDesignPrincipalRights]
        $Rights,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.TenantSiteDesignPipeBind]
        $Identity,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
function New-PnPGroup
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [PnP.PowerShell.Commands.Enums.AssociatedGroupType]
        $SetAssociatedGroup,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.WebPipeBind]
        $Web,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AutoAcceptRequestToJoinLeave,

        [Parameter()]
        [System.String]
        $Title,

        [Parameter()]
        [System.String]
        $Owner,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $OnlyAllowMembersViewMembership,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $DisallowMembersViewMembership,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowMembersEditMembership,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.String]
        $RequestToJoinEmail,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowRequestToJoinLeave
    )
}
function New-PnPTenantSite
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Template,

        [Parameter()]
        [System.Nullable`1[Microsoft.Online.SharePoint.TenantManagement.SharingCapabilities]]
        $SharingCapability,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Int64]
        $StorageQuota,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RemoveDeletedSite,

        [Parameter()]
        [System.String]
        $Title,

        [Parameter()]
        [System.String]
        $Owner,

        [Parameter()]
        [System.Int32]
        $TimeZone,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.String]
        $Url,

        [Parameter()]
        [System.Double]
        $ResourceQuota,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Wait,

        [Parameter()]
        [System.UInt32]
        $Lcid,

        [Parameter()]
        [System.Double]
        $ResourceQuotaWarningLevel,

        [Parameter()]
        [System.Int64]
        $StorageQuotaWarningLevel
    )
}
function Register-PnPHubSite
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Principals,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.SitePipeBind]
        $Site,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
function Remove-PnPApp
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.AppMetadataPipeBind]
        $Identity,

        [Parameter()]
        [PnP.Framework.Enums.AppCatalogScope]
        $Scope,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
function Remove-PnPGroup
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.WebPipeBind]
        $Web,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.GroupPipeBind]
        $Identity,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )
}
function Remove-PnPHomeSite
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )
}
function Remove-PnPHubSiteAssociation
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.SitePipeBind]
        $Site,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
function Remove-PnPOrgAssetsLibrary
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Online.SharePoint.TenantAdministration.SPOTenantCdnType]
        $CdnType,

        [Parameter()]
        [System.String]
        $LibraryUrl,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.Boolean]
        $ShouldRemoveFromCdn
    )
}
function Remove-PnPPropertyBagValue
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Folder,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.WebPipeBind]
        $Web,

        [Parameter()]
        [System.String]
        $Key,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )
}
function Remove-PnPSiteDesign
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.TenantSiteDesignPipeBind]
        $Identity,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )
}
function Remove-PnPStorageEntity
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PnP.PowerShell.Commands.Enums.StorageEntityScope]
        $Scope,

        [Parameter()]
        [System.String]
        $Key,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
function Remove-PnPTenantSite
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $FromRecycleBin,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $SkipRecycleBin,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.String]
        $Url,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )
}
function Remove-PnPTenantTheme
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.ThemePipeBind]
        $Identity,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
function Revoke-PnPSiteDesignRights
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Principals,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.TenantSiteDesignPipeBind]
        $Identity,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
function Set-PnPAuditing
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $CheckOutCheckInItems,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $TrimAuditLog,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $DisableAll,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $SearchContent,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $EditItems,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $EditContentTypesColumns,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $DeleteRestoreItems,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $EditUsersPermissions,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $EnableAll,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $MoveCopyItems,

        [Parameter()]
        [System.Int32]
        $RetentionTime
    )
}
function Set-PnPBrowserIdleSignout
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.TimeSpan]
        $WarnAfter,

        [Parameter()]
        [System.TimeSpan]
        $SignoutAfter,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.Boolean]
        $Enabled
    )
}
function Set-PnPGroup
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.WebPipeBind]
        $Web,

        [Parameter()]
        [System.String]
        $AddRole,

        [Parameter()]
        [System.String]
        $Title,

        [Parameter()]
        [System.String]
        $Owner,

        [Parameter()]
        [System.Boolean]
        $OnlyAllowMembersViewMembership,

        [Parameter()]
        [System.String]
        $RemoveRole,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.GroupPipeBind]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $AllowMembersEditMembership,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.Boolean]
        $AutoAcceptRequestToJoinLeave,

        [Parameter()]
        [System.String]
        $RequestToJoinEmail,

        [Parameter()]
        [PnP.PowerShell.Commands.Enums.AssociatedGroupType]
        $SetAssociatedGroup,

        [Parameter()]
        [System.Boolean]
        $AllowRequestToJoinLeave
    )
}
function Set-PnPGroupPermissions
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $AddRole,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.WebPipeBind]
        $Web,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.GroupPipeBind]
        $Identity,

        [Parameter()]
        [System.String[]]
        $RemoveRole,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.ListPipeBind]
        $List
    )
}
function Set-PnPHomeSite
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $HomeSiteUrl,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
function Set-PnPHubSite
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RequiresJoinApproval,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $HideNameInNavigation,

        [Parameter()]
        [System.String]
        $LogoUrl,

        [Parameter()]
        [System.Guid]
        $SiteDesignId,

        [Parameter()]
        [System.String]
        $Title,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.HubSitePipeBind]
        $Identity,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.Guid]
        $ParentHubSiteId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $EnablePermissionsSync
    )
}
function Set-PnPPropertyBagValue
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Folder,

        [Parameter()]
        [System.String]
        $Value,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Indexed,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.WebPipeBind]
        $Web,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.String]
        $Key
    )
}
function Set-PnPSearchConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Configuration,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.WebPipeBind]
        $Web,

        [Parameter()]
        [PnP.PowerShell.Commands.Enums.SearchConfigurationScope]
        $Scope,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.String]
        $Path
    )
}
function Set-PnPSite
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.Nullable`1[Microsoft.Online.SharePoint.TenantManagement.SharingCapabilities]]
        $SharingCapability,

        [Parameter()]
        [System.Nullable`1[System.Management.Automation.SwitchParameter]]
        $DisableFlows,

        [Parameter()]
        [System.Nullable`1[Microsoft.Online.SharePoint.TenantManagement.MediaTranscriptionPolicyType]]
        $MediaTranscription,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $DisableSharingForNonOwners,

        [Parameter()]
        [System.Nullable`1[System.Management.Automation.SwitchParameter]]
        $NoScriptSite,

        [Parameter()]
        [System.String]
        $Classification,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $DefaultLinkToExistingAccessReset,

        [Parameter()]
        [System.Nullable`1[System.Guid]]
        $SensitivityLabel,

        [Parameter()]
        [System.Nullable`1[Microsoft.Online.SharePoint.TenantManagement.SharingPermissionType]]
        $DefaultLinkPermission,

        [Parameter()]
        [System.Boolean]
        $DefaultLinkToExistingAccess,

        [Parameter()]
        [System.Nullable`1[System.Int64]]
        $StorageWarningLevel,

        [Parameter()]
        [System.Nullable`1[System.Management.Automation.SwitchParameter]]
        $CommentsOnSitePagesDisabled,

        [Parameter()]
        [System.String]
        $LogoFilePath,

        [Parameter()]
        [System.Nullable`1[Microsoft.Online.SharePoint.TenantAdministration.RestrictedToRegion]]
        $RestrictedToGeo,

        [Parameter()]
        [System.Nullable`1[PnP.Framework.SiteLockState]]
        $LockState,

        [Parameter()]
        [System.Nullable`1[Microsoft.Online.SharePoint.TenantAdministration.AppViewsPolicy]]
        $DisableAppViews,

        [Parameter()]
        [System.Nullable`1[System.Management.Automation.SwitchParameter]]
        $SocialBarOnSitePagesDisabled,

        [Parameter()]
        [System.String[]]
        $Owners,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Wait,

        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $AnonymousLinkExpirationInDays,

        [Parameter()]
        [System.Nullable`1[Microsoft.Online.SharePoint.TenantAdministration.CompanyWideSharingLinksPolicy]]
        $DisableCompanyWideSharingLinks,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $OverrideTenantAnonymousLinkExpirationPolicy,

        [Parameter()]
        [System.Nullable`1[System.Management.Automation.SwitchParameter]]
        $AllowSelfServiceUpgrade,

        [Parameter()]
        [System.Nullable`1[System.Int64]]
        $StorageMaximumLevel,

        [Parameter()]
        [System.Nullable`1[System.UInt32]]
        $LocaleId,

        [Parameter()]
        [System.Nullable`1[Microsoft.Online.SharePoint.TenantManagement.SharingLinkType]]
        $DefaultSharingLinkType
    )
}
function Set-PnPSiteDesign
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $ThumbnailUrl,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [PnP.PowerShell.Commands.Enums.SiteWebTemplate]
        $WebTemplate,

        [Parameter()]
        [System.Int32]
        $Version,

        [Parameter()]
        [System.String]
        $Title,

        [Parameter()]
        [System.Guid[]]
        $SiteScriptIds,

        [Parameter()]
        [System.String]
        $PreviewImageUrl,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.TenantSiteDesignPipeBind]
        $Identity,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.String]
        $PreviewImageAltText,

        [Parameter()]
        [System.Nullable`1[System.Guid]]
        $DesignPackageId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsDefault
    )
}
function Set-PnPSiteScript
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Int32]
        $Version,

        [Parameter()]
        [System.String]
        $Content,

        [Parameter()]
        [System.String]
        $Title,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.TenantSiteScriptPipeBind]
        $Identity,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
function Set-PnPStorageEntity
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $Value,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [PnP.PowerShell.Commands.Enums.StorageEntityScope]
        $Scope,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.String]
        $Key
    )
}
function Set-PnPTenant
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $ExternalServicesEnabled,

        [Parameter()]
        [System.Boolean]
        $UsePersistentCookiesForExplorerView,

        [Parameter()]
        [System.Int32]
        $MinCompatibilityLevel,

        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $RequireAnonymousLinksExpireInDays,

        [Parameter()]
        [System.Nullable`1[Microsoft.SharePoint.Client.AnonymousLinkType]]
        $FolderAnonymousLinkType,

        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $OrphanedPersonalSitesRetentionPeriod,

        [Parameter()]
        [System.Boolean]
        $CommentsOnListItemsDisabled,

        [Parameter()]
        [System.Boolean]
        $OwnerAnonymousNotification,

        [Parameter()]
        [System.Nullable`1[Microsoft.Online.SharePoint.TenantManagement.SPOConditionalAccessPolicyType]]
        $ConditionalAccessPolicy,

        [Parameter()]
        [System.Boolean]
        $NotificationsInSharePointEnabled,

        [Parameter()]
        [System.Boolean]
        $AllowFilesWithKeepLabelToBeDeletedODB,

        [Parameter()]
        [System.Boolean]
        $ShowAllUsersClaim,

        [Parameter()]
        [System.Boolean]
        $ViewInFileExplorerEnabled,

        [Parameter()]
        [System.Boolean]
        $RequireAcceptingAccountMatchInvitedAccount,

        [Parameter()]
        [System.Nullable`1[Microsoft.Online.SharePoint.TenantManagement.SharingPermissionType]]
        $DefaultLinkPermission,

        [Parameter()]
        [System.Boolean]
        $StopNew2013Workflows,

        [Parameter()]
        [System.Boolean]
        $DisableCustomAppAuthentication,

        [Parameter()]
        [System.Guid[]]
        $DisabledWebPartIds,

        [Parameter()]
        [System.Boolean]
        $NotificationsInOneDriveForBusinessEnabled,

        [Parameter()]
        [System.Boolean]
        $EnableAutoNewsDigest,

        [Parameter()]
        [System.Boolean]
        $NotifyOwnersWhenItemsReshared,

        [Parameter()]
        [System.Boolean]
        $SearchResolveExactEmailOrUPN,

        [Parameter()]
        [System.Boolean]
        $AllowFilesWithKeepLabelToBeDeletedSPO,

        [Parameter()]
        [System.Boolean]
        $EnableAIPIntegration,

        [Parameter()]
        [System.Boolean]
        $FilePickerExternalImageSearchEnabled,

        [Parameter()]
        [System.Boolean]
        $ExternalUserExpirationRequired,

        [Parameter()]
        [System.Nullable`1[Microsoft.Online.SharePoint.TenantManagement.SpecialCharactersState]]
        $SpecialCharactersStateInFileFolderNames,

        [Parameter()]
        [System.Nullable`1[Microsoft.SharePoint.Client.SharingState]]
        $ODBAccessRequests,

        [Parameter()]
        [System.String]
        $NoAccessRedirectUrl,

        [Parameter()]
        [System.Boolean]
        $ShowPeoplePickerSuggestionsForGuestUsers,

        [Parameter()]
        [System.Boolean]
        $SocialBarOnSitePagesDisabled,

        [Parameter()]
        [System.Boolean]
        $PublicCdnEnabled,

        [Parameter()]
        [System.Nullable`1[Microsoft.Online.SharePoint.TenantManagement.SensitiveByDefaultState]]
        $MarkNewFilesSensitiveByDefault,

        [Parameter()]
        [System.String]
        $SharingBlockedDomainList,

        [Parameter()]
        [System.Guid[]]
        $DisabledModernListTemplateIds,

        [Parameter()]
        [System.String]
        $SharingAllowedDomainList,

        [Parameter()]
        [System.Nullable`1[Microsoft.Online.SharePoint.TenantManagement.SharingLinkType]]
        $DefaultSharingLinkType,

        [Parameter()]
        [System.String]
        $BccExternalSharingInvitationsList,

        [Parameter()]
        [System.String]
        $SignInAccelerationDomain,

        [Parameter()]
        [System.Boolean]
        $ProvisionSharedWithEveryoneFolder,

        [Parameter()]
        [System.Nullable`1[Microsoft.Online.SharePoint.TenantManagement.SharingDomainRestrictionModes]]
        $SharingDomainRestrictionMode,

        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $EmailAttestationReAuthDays,

        [Parameter()]
        [System.Boolean]
        $ShowEveryoneExceptExternalUsersClaim,

        [Parameter()]
        [System.Boolean]
        $OneDriveForGuestsEnabled,

        [Parameter()]
        [System.String]
        $StartASiteFormUrl,

        [Parameter()]
        [System.Boolean]
        $IsFluidEnabled,

        [Parameter()]
        [System.Boolean]
        $EmailAttestationRequired,

        [Parameter()]
        [System.Boolean]
        $AllowDownloadingNonWebViewableFiles,

        [Parameter()]
        [System.Boolean]
        $UseFindPeopleInPeoplePicker,

        [Parameter()]
        [System.Boolean]
        $ShowEveryoneClaim,

        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $IPAddressWACTokenLifetime,

        [Parameter()]
        [System.Boolean]
        $HideDefaultThemes,

        [Parameter()]
        [System.Boolean]
        $ApplyAppEnforcedRestrictionsToAdHocRecipients,

        [Parameter()]
        [System.Boolean]
        $OfficeClientADALDisabled,

        [Parameter()]
        [System.Boolean]
        $BccExternalSharingInvitations,

        [Parameter()]
        [System.Boolean]
        $IPAddressEnforcement,

        [Parameter()]
        [System.Nullable`1[Microsoft.Online.SharePoint.TenantManagement.SharingCapabilities]]
        $SharingCapability,

        [Parameter()]
        [System.Boolean]
        $NotifyOwnersWhenInvitationsAccepted,

        [Parameter()]
        [System.String]
        $IPAddressAllowList,

        [Parameter()]
        [System.Boolean]
        $DisallowInfectedFileDownload,

        [Parameter()]
        [System.Boolean]
        $DisableBackToClassic,

        [Parameter()]
        [System.Boolean]
        $AllowEditing,

        [Parameter()]
        [System.Boolean]
        $DisableAddToOneDrive,

        [Parameter()]
        [System.Boolean]
        $InformationBarriersSuspension,

        [Parameter()]
        [System.Boolean]
        $PreventExternalUsersFromResharing,

        [Parameter()]
        [System.Boolean]
        $DisablePersonalListCreation,

        [Parameter()]
        [System.Nullable`1[Microsoft.SharePoint.Client.SharingState]]
        $ODBMembersCanShare,

        [Parameter()]
        [System.Boolean]
        $CommentsOnFilesDisabled,

        [Parameter()]
        [System.Boolean]
        $LegacyAuthProtocolsEnabled,

        [Parameter()]
        [System.Nullable`1[Microsoft.SharePoint.Client.AnonymousLinkType]]
        $FileAnonymousLinkType,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.String]
        $PublicCdnAllowedFileTypes,

        [Parameter()]
        [System.Boolean]
        $CommentsOnSitePagesDisabled,

        [Parameter()]
        [System.Boolean]
        $UserVoiceForFeedbackEnabled,

        [Parameter()]
        [System.Guid[]]
        $EnableModernListTemplateIds,

        [Parameter()]
        [System.Nullable`1[System.Int64]]
        $OneDriveStorageQuota,

        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $ExternalUserExpireInDays,

        [Parameter()]
        [System.Boolean]
        $EnableGuestSignInAcceleration,

        [Parameter()]
        [System.Int32]
        $MaxCompatibilityLevel,

        [Parameter()]
        [System.Boolean]
        $DisplayStartASiteOption
    )
}
function Set-PnPTenantCdnEnabled
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $NoDefaultOrigins,

        [Parameter()]
        [PnP.PowerShell.Commands.Enums.CdnType]
        $CdnType,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.Boolean]
        $Enable
    )
}
function Set-PnPTenantCdnPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Online.SharePoint.TenantAdministration.SPOTenantCdnType]
        $CdnType,

        [Parameter()]
        [System.String]
        $PolicyValue,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [Microsoft.Online.SharePoint.TenantAdministration.SPOTenantCdnPolicyType]
        $PolicyType
    )
}
function Set-PnPTenantSite
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Int32]
        $ExternalUserExpirationInDays,

        [Parameter()]
        [Microsoft.Online.SharePoint.TenantManagement.SharingCapabilities]
        $SharingCapability,

        [Parameter()]
        [Microsoft.Online.SharePoint.TenantAdministration.FlowsPolicy]
        $DisableFlows,

        [Parameter()]
        [System.Nullable`1[Microsoft.Online.SharePoint.TenantManagement.MediaTranscriptionPolicyType]]
        $MediaTranscription,

        [Parameter()]
        [System.String]
        $ProtectionLevelName,

        [Parameter()]
        [System.Boolean]
        $AllowEditing,

        [Parameter()]
        [System.Double]
        $ResourceQuota,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $DisableSharingForNonOwners,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Wait,

        [Parameter()]
        [System.Double]
        $ResourceQuotaWarningLevel,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.Int64]
        $StorageQuotaWarningLevel,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.SPOSitePipeBind]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $DefaultLinkToExistingAccessReset,

        [Parameter()]
        [System.String]
        $SensitivityLabel,

        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $AnonymousLinkExpirationInDays,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RemoveLabel,

        [Parameter()]
        [Microsoft.Online.SharePoint.TenantManagement.SharingPermissionType]
        $DefaultLinkPermission,

        [Parameter()]
        [System.Boolean]
        $OverrideTenantExternalUserExpirationPolicy,

        [Parameter()]
        [System.Boolean]
        $AllowDownloadingNonWebViewableFiles,

        [Parameter()]
        [System.Guid[]]
        $RemoveInformationSegment,

        [Parameter()]
        [System.String]
        $Title,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $BlockDownloadOfNonViewableFiles,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $CommentsOnSitePagesDisabled,

        [Parameter()]
        [System.Guid]
        $HubSiteId,

        [Parameter()]
        [System.Guid[]]
        $AddInformationSegment,

        [Parameter()]
        [System.Boolean]
        $DefaultLinkToExistingAccess,

        [Parameter()]
        [Microsoft.Online.SharePoint.TenantAdministration.RestrictedToRegion]
        $RestrictedToGeo,

        [Parameter()]
        [System.Nullable`1[PnP.Framework.SiteLockState]]
        $LockState,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $DenyAddAndCustomizePages,

        [Parameter()]
        [Microsoft.Online.SharePoint.TenantAdministration.AppViewsPolicy]
        $DisableAppViews,

        [Parameter()]
        [System.String]
        $SharingBlockedDomainList,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $StorageQuotaReset,

        [Parameter()]
        [System.String[]]
        $Owners,

        [Parameter()]
        [PnP.PowerShell.Commands.Enums.InformationBarriersMode]
        $InformationBarriersMode,

        [Parameter()]
        [Microsoft.Online.SharePoint.TenantManagement.SPOLimitedAccessFileType]
        $LimitedAccessFileType,

        [Parameter()]
        [Microsoft.Online.SharePoint.TenantManagement.BlockDownloadLinksFileTypes]
        $BlockDownloadLinksFileType,

        [Parameter()]
        [Microsoft.Online.SharePoint.TenantAdministration.SiteUserInfoVisibilityPolicyValue]
        $OverrideBlockUserInfoVisibility,

        [Parameter()]
        [Microsoft.Online.SharePoint.TenantManagement.SharingDomainRestrictionModes]
        $SharingDomainRestrictionMode,

        [Parameter()]
        [PnP.PowerShell.Commands.Enums.PnPConditionalAccessPolicyType]
        $ConditionalAccessPolicy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $OverrideTenantAnonymousLinkExpirationPolicy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowSelfServiceUpgrade,

        [Parameter()]
        [System.Int64]
        $StorageQuota,

        [Parameter()]
        [System.String]
        $SharingAllowedDomainList,

        [Parameter()]
        [System.UInt32]
        $LocaleId,

        [Parameter()]
        [System.Boolean]
        $ShowPeoplePickerSuggestionsForGuestUsers,

        [Parameter()]
        [Microsoft.Online.SharePoint.TenantManagement.SharingLinkType]
        $DefaultSharingLinkType,

        [Parameter()]
        [System.Boolean]
        $EnablePWA,

        [Parameter()]
        [Microsoft.Online.SharePoint.TenantAdministration.CompanyWideSharingLinksPolicy]
        $DisableCompanyWideSharingLinks
    )
}
function Set-PnPTenantSyncClientRestriction
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Collections.Generic.List`1[System.Guid]]
        $DomainGuids,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $DisableReportProblemDialog,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Enable,

        [Parameter()]
        [PnP.PowerShell.Commands.Enums.GrooveBlockOption]
        $GrooveBlockOption,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $BlockMacSync,

        [Parameter()]
        [System.String[]]
        $ExcludedFileExtensions
    )
}
function Set-PnPUserProfileProperty
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Values
    )
}
function Unregister-PnPHubSite
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.SitePipeBind]
        $Site,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection
    )
}
#endregion
#region PowerPlatforms
function Get-AdminPowerApp
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $ApiVersion,

        [Parameter()]
        [System.String]
        $Owner,

        [Parameter()]
        [System.String[]]
        $Filter,

        [Parameter()]
        [System.String]
        $EnvironmentName,

        [Parameter()]
        [System.String]
        $AppName
    )
}
function Get-AdminPowerAppEnvironment
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Capacity,

        [Parameter()]
        [System.String]
        $InstanceId,

        [Parameter()]
        [System.Boolean]
        $ReturnCdsDatabaseType,

        [Parameter()]
        [System.String]
        $ApiVersion,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Default,

        [Parameter()]
        [System.String[]]
        $Filter,

        [Parameter()]
        [System.String]
        $EnvironmentName,

        [Parameter()]
        [System.String]
        $EnvironmentSku,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $GetProtectedEnvironment,

        [Parameter()]
        [System.String]
        $CreatedBy
    )
}
function Get-PowerAppTenantIsolationPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $ApiVersion
    )
}
function Get-TenantSettings
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $ApiVersion
    )
}
function New-AdminPowerAppEnvironment
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Int32]
        $TimeoutInMinutes,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProvisionDatabase,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $LanguageName,

        [Parameter()]
        [System.String]
        $RegionName,

        [Parameter()]
        [System.String]
        $LocationName,

        [Parameter()]
        [System.String]
        $CurrencyName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $ApiVersion,

        [Parameter()]
        [System.String[]]
        $Templates,

        [Parameter()]
        [System.String]
        $SecurityGroupId,

        [Parameter()]
        [System.String]
        $EnvironmentSku,

        [Parameter()]
        [System.Boolean]
        $WaitUntilFinished,

        [Parameter()]
        [System.String]
        $DomainName
    )
}
function Remove-AdminPowerApp
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $ApiVersion,

        [Parameter()]
        [System.String]
        $EnvironmentName,

        [Parameter()]
        [System.String]
        $AppName
    )
}
function Remove-AdminPowerAppEnvironment
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $EnvironmentName,

        [Parameter()]
        [System.String]
        $ApiVersion
    )
}
function Set-PowerAppTenantIsolationPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $ApiVersion,

        [Parameter()]
        [System.Object]
        $TenantIsolationPolicy
    )
}
function Set-TenantSettings
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $ApiVersion,

        [Parameter()]
        [System.Object]
        $RequestBody
    )
}
#endregion
#region MicrosoftTeams
function Add-TeamUser
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $User,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter()]
        [System.String]
        $Role
    )
}
function Get-Team
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $Archived,

        [Parameter()]
        [System.String]
        $User,

        [Parameter()]
        [System.String]
        $NumberOfThreads,

        [Parameter()]
        [System.String]
        $Visibility,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter()]
        [System.String]
        $MailNickName
    )
}
function Get-TeamChannel
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $MembershipType,

        [Parameter()]
        [System.String]
        $GroupId
    )
}
function Get-TeamUser
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter()]
        [System.String]
        $Role
    )
}
function New-Team
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $AllowGuestDeleteChannels,

        [Parameter()]
        [System.Boolean]
        $AllowUserDeleteMessages,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $MailNickName,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $AllowCreateUpdateChannels,

        [Parameter()]
        [System.Boolean]
        $AllowDeleteChannels,

        [Parameter()]
        [System.String]
        $Classification,

        [Parameter()]
        [System.Boolean]
        $AllowCreateUpdateRemoveConnectors,

        [Parameter()]
        [System.Boolean]
        $AllowUserEditMessages,

        [Parameter()]
        [System.Boolean]
        $AllowCreateUpdateRemoveTabs,

        [Parameter()]
        [System.Boolean]
        $AllowAddRemoveApps,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RetainCreatedGroup,

        [Parameter()]
        [System.Boolean]
        $AllowOwnerDeleteMessages,

        [Parameter()]
        [System.Boolean]
        $AllowTeamMentions,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter()]
        [System.Boolean]
        $AllowCreatePrivateChannels,

        [Parameter()]
        [System.Boolean]
        $AllowGuestCreateUpdateChannels,

        [Parameter()]
        [System.String]
        $Owner,

        [Parameter()]
        [System.String]
        $GiphyContentRating,

        [Parameter()]
        [System.Boolean]
        $AllowStickersAndMemes,

        [Parameter()]
        [System.Boolean]
        $ShowInTeamsSearchAndSuggestions,

        [Parameter()]
        [System.String]
        $Visibility,

        [Parameter()]
        [System.String]
        $Template,

        [Parameter()]
        [System.Boolean]
        $AllowGiphy,

        [Parameter()]
        [System.Boolean]
        $AllowChannelMentions,

        [Parameter()]
        [System.Boolean]
        $AllowCustomMemes
    )
}
function New-TeamChannel
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Owner,

        [Parameter()]
        [System.String]
        $MembershipType,

        [Parameter()]
        [System.String]
        $GroupId
    )
}
function Remove-Team
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $GroupId
    )
}
function Remove-TeamChannel
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $GroupId
    )
}
function Remove-TeamUser
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $User,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter()]
        [System.String]
        $Role
    )
}
function Set-Team
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $AllowGuestDeleteChannels,

        [Parameter()]
        [System.Boolean]
        $AllowUserDeleteMessages,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $MailNickName,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $AllowCreateUpdateChannels,

        [Parameter()]
        [System.Boolean]
        $AllowDeleteChannels,

        [Parameter()]
        [System.String]
        $Classification,

        [Parameter()]
        [System.Boolean]
        $AllowCreateUpdateRemoveConnectors,

        [Parameter()]
        [System.Boolean]
        $AllowUserEditMessages,

        [Parameter()]
        [System.Boolean]
        $AllowAddRemoveApps,

        [Parameter()]
        [System.Boolean]
        $AllowOwnerDeleteMessages,

        [Parameter()]
        [System.Boolean]
        $AllowTeamMentions,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter()]
        [System.Boolean]
        $AllowCreatePrivateChannels,

        [Parameter()]
        [System.Boolean]
        $AllowGuestCreateUpdateChannels,

        [Parameter()]
        [System.String]
        $GiphyContentRating,

        [Parameter()]
        [System.Boolean]
        $AllowStickersAndMemes,

        [Parameter()]
        [System.Boolean]
        $ShowInTeamsSearchAndSuggestions,

        [Parameter()]
        [System.String]
        $Visibility,

        [Parameter()]
        [System.Boolean]
        $AllowCreateUpdateRemoveTabs,

        [Parameter()]
        [System.Boolean]
        $AllowGiphy,

        [Parameter()]
        [System.Boolean]
        $AllowChannelMentions,

        [Parameter()]
        [System.Boolean]
        $AllowCustomMemes
    )
}
function Set-TeamChannel
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter()]
        [System.String]
        $CurrentDisplayName,

        [Parameter()]
        [System.String]
        $NewDisplayName
    )
}
function Get-CsOnlinePSTNGateway
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Get-CsOnlinePstnUsage
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Get-CsOnlineUser
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $SkipUserPolicies,

        [Parameter()]
        [Microsoft.Teams.ConfigAPI.Cmdlets.Models.AccountType]
        $AccountType,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $OnModernServer,

        [Parameter()]
        [System.String]
        $LdapFilter,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $OnOfficeCommunicationServer,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $SoftDeletedUsers,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Object]
        $OU,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $UnassignedUser,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode,

        [Parameter()]
        [System.UInt32]
        $ResultSize,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $UsePreferredDC
    )
}
function Get-CsOnlineVoiceRoute
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Get-CsOnlineVoiceRoutingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Get-CsTeamsCallingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Get-CsTeamsChannelsPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Get-CsTeamsClientConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Get-CsTeamsEmergencyCallingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Get-CsTeamsEmergencyCallRoutingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Get-CsTeamsEventsPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Get-CsTeamsGuestCallingConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Get-CsTeamsGuestMeetingConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Get-CsTeamsGuestMessagingConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Get-CsTeamsMeetingBroadcastConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ExposeSDNConfigurationJsonBlob,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Get-CsTeamsMeetingBroadcastPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Get-CsTeamsMeetingConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Get-CsTeamsMeetingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Get-CsTeamsMessagingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Get-CsTeamsUpdateManagementPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Get-CsTeamsUpgradeConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Get-CsTeamsUpgradePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Get-CsTenant
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.UInt32]
        $ResultSize,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode,

        [Parameter()]
        [System.Object]
        $Identity
    )
}
function Get-CsTenantDialPlan
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Get-CsTenantFederationConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Grant-CsTeamsUpgradePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [System.String]
        $PolicyName,

        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $Rank,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Global,

        [Parameter()]
        [System.Boolean]
        $MigrateMeetingsToTeams,

        [Parameter()]
        [System.String]
        $Group,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function New-CsOnlineVoiceRoute
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $BridgeSourcePhoneNumber,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Int32]
        $Priority,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Object]
        $OnlinePstnGatewayList,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $NumberPattern,

        [Parameter()]
        [System.Object]
        $OnlinePstnUsages,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function New-CsOnlineVoiceRoutingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $RouteType,

        [Parameter()]
        [System.Object]
        $OnlinePstnUsages,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function New-CsTeamsCallingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $AllowWebPSTNCalling,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $PreventTollBypass,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Boolean]
        $AllowCloudRecordingForCalls,

        [Parameter()]
        [System.String]
        $AllowCallRedirect,

        [Parameter()]
        [System.Boolean]
        $AllowCallGroups,

        [Parameter()]
        [System.String]
        $SpamFilteringEnabledType,

        [Parameter()]
        [System.Boolean]
        $AllowSIPDevicesCalling,

        [Parameter()]
        [System.String]
        $PopoutAppPathForIncomingPstnCalls,

        [Parameter()]
        [System.String]
        $BusyOnBusyEnabledType,

        [Parameter()]
        [System.String]
        $AllowVoicemail,

        [Parameter()]
        [System.String]
        $PopoutForIncomingPstnCalls,

        [Parameter()]
        [System.String]
        $MusicOnHoldEnabledType,

        [Parameter()]
        [System.Boolean]
        $AllowCallForwardingToUser,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode,

        [Parameter()]
        [System.Boolean]
        $AllowCallForwardingToPhone,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateCalling,

        [Parameter()]
        [System.String]
        $LiveCaptionsEnabledTypeForCalling,

        [Parameter()]
        [System.Boolean]
        $AllowDelegation,

        [Parameter()]
        [System.Int64]
        $CallRecordingExpirationDays,

        [Parameter()]
        [System.String]
        $AutoAnswerEnabledType,

        [Parameter()]
        [System.Boolean]
        $AllowTranscriptionForCalling
    )
}
function New-CsTeamsChannelsPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $AllowSharedChannelCreation,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $AllowChannelSharingToExternalUser,

        [Parameter()]
        [System.Boolean]
        $AllowOrgWideTeamCreation,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateChannelCreation,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateTeamDiscovery,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode,

        [Parameter()]
        [System.Boolean]
        $AllowUserToParticipateInExternalSharedChannel
    )
}
function New-CsTeamsEmergencyCallingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $NotificationGroup,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $NotificationDialOutNumber,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $EnhancedEmergencyServiceDisclaimer,

        [Parameter()]
        [System.Object]
        $NotificationMode,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode,

        [Parameter()]
        [System.String]
        $ExternalLocationLookupMode
    )
}
function New-CsTeamsEmergencyCallRoutingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $EmergencyNumbers,

        [Parameter()]
        [System.Boolean]
        $AllowEnhancedEmergencyServices,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function New-CsTeamsEmergencyNumber
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $EmergencyDialString,

        [Parameter()]
        [System.String]
        $OnlinePSTNUsage,

        [Parameter()]
        [System.String]
        $EmergencyDialMask,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function New-CsTeamsEventsPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $EventAccessType,

        [Parameter()]
        [System.String]
        $AllowWebinars,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function New-CsTeamsMeetingBroadcastPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $BroadcastAttendeeVisibilityMode,

        [Parameter()]
        [System.Boolean]
        $AllowBroadcastTranscription,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $BroadcastRecordingMode,

        [Parameter()]
        [System.Boolean]
        $AllowBroadcastScheduling,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm
    )
}
function New-CsTeamsMeetingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $TeamsCameraFarEndPTZMode,

        [Parameter()]
        [System.String]
        $AllowTrackingInReport,

        [Parameter()]
        [System.Boolean]
        $AllowMeetingCoach,

        [Parameter()]
        [System.Boolean]
        $AllowMeetNow,

        [Parameter()]
        [System.Boolean]
        $AllowIPAudio,

        [Parameter()]
        [System.Boolean]
        $AllowWhiteboard,

        [Parameter()]
        [System.Boolean]
        $AllowAnonymousUsersToDialOut,

        [Parameter()]
        [System.String]
        $StreamingAttendeeMode,

        [Parameter()]
        [System.Boolean]
        $AllowNetworkConfigurationSettingsLookup,

        [Parameter()]
        [System.Boolean]
        $AllowTranscription,

        [Parameter()]
        [System.String]
        $RoomAttributeUserOverride,

        [Parameter()]
        [System.String]
        $RoomPeopleNameUserOverride,

        [Parameter()]
        [System.String]
        $AllowUserToJoinExternalMeeting,

        [Parameter()]
        [System.Boolean]
        $AllowExternalParticipantGiveRequestControl,

        [Parameter()]
        [System.Boolean]
        $AllowAnonymousUsersToStartMeeting,

        [Parameter()]
        [System.String]
        $AutoAdmittedUsers,

        [Parameter()]
        [System.String]
        $AllowTasksFromTranscript,

        [Parameter()]
        [System.Boolean]
        $AllowMeetingRegistration,

        [Parameter()]
        [System.String]
        $ChannelRecordingDownload,

        [Parameter()]
        [System.String]
        $RecordingStorageMode,

        [Parameter()]
        [System.String]
        $ScreenSharingMode,

        [Parameter()]
        [System.String]
        $AllowCartCaptionsScheduling,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateMeetNow,

        [Parameter()]
        [System.String]
        $AllowEngagementReport,

        [Parameter()]
        [System.Boolean]
        $AllowWatermarkForCameraVideo,

        [Parameter()]
        [System.String]
        $PreferredMeetingProviderForIslandsMode,

        [Parameter()]
        [System.Boolean]
        $AllowOrganizersToOverrideLobbySettings,

        [Parameter()]
        [System.String]
        $LiveCaptionsEnabledType,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode,

        [Parameter()]
        [System.Boolean]
        $AllowNDIStreaming,

        [Parameter()]
        [System.String]
        $IPAudioMode,

        [Parameter()]
        [System.String]
        $AllowScreenContentDigitization,

        [Parameter()]
        [System.String]
        $BlockedAnonymousJoinClientTypes,

        [Parameter()]
        [System.String]
        $LiveInterpretationEnabledType,

        [Parameter()]
        [System.Int64]
        $NewMeetingRecordingExpirationDays,

        [Parameter()]
        [System.Boolean]
        $AllowAnonymousUsersToJoinMeeting,

        [Parameter()]
        [System.String]
        $MeetingInviteLanguages,

        [Parameter()]
        [System.String]
        $WhoCanRegister,

        [Parameter()]
        [System.Boolean]
        $AllowAvatarsInGallery,

        [Parameter()]
        [System.Boolean]
        $AllowCloudRecording,

        [Parameter()]
        [System.Boolean]
        $AllowWatermarkForScreenSharing,

        [Parameter()]
        [System.Boolean]
        $AllowIPVideo,

        [Parameter()]
        [System.String]
        $SpeakerAttributionMode,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $AllowImmersiveView,

        [Parameter()]
        [System.Boolean]
        $AllowOutlookAddIn,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $DesignatedPresenterRoleMode,

        [Parameter()]
        [System.String]
        $MeetingChatEnabledType,

        [Parameter()]
        [System.String]
        $QnAEngagementMode,

        [Parameter()]
        [System.Boolean]
        $AllowSharedNotes,

        [Parameter()]
        [System.Boolean]
        $AllowParticipantGiveRequestControl,

        [Parameter()]
        [System.UInt32]
        $MediaBitRateKb,

        [Parameter()]
        [System.String]
        $EnrollUserOverride,

        [Parameter()]
        [System.Boolean]
        $AllowPowerPointSharing,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateMeetingScheduling,

        [Parameter()]
        [System.Boolean]
        $AllowChannelMeetingScheduling,

        [Parameter()]
        [System.Boolean]
        $AllowMeetingReactions,

        [Parameter()]
        [System.String]
        $VideoFiltersMode,

        [Parameter()]
        [System.String]
        $InfoShownInReportMode,

        [Parameter()]
        [System.String]
        $LiveStreamingMode,

        [Parameter()]
        [System.Boolean]
        $AllowBreakoutRooms,

        [Parameter()]
        [System.Boolean]
        $AllowRecordingStorageOutsideRegion,

        [Parameter()]
        [System.Boolean]
        $AllowPSTNUsersToBypassLobby,

        [Parameter()]
        [System.Boolean]
        $AllowCarbonSummary,

        [Parameter()]
        [System.String]
        $IPVideoMode
    )
}
function New-CsTeamsMessagingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $AllowOwnerDeleteMessage,

        [Parameter()]
        [System.Boolean]
        $AllowSmartReply,

        [Parameter()]
        [System.Boolean]
        $AllowUserChat,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $AllowGiphy,

        [Parameter()]
        [System.Boolean]
        $AllowUserDeleteMessage,

        [Parameter()]
        [System.String]
        $ChannelsInChatListEnabledType,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $AllowStickers,

        [Parameter()]
        [System.Boolean]
        $AllowFullChatPermissionUserToDeleteAnyMessage,

        [Parameter()]
        [System.Boolean]
        $AllowUrlPreviews,

        [Parameter()]
        [System.Boolean]
        $AllowGiphyDisplay,

        [Parameter()]
        [System.Boolean]
        $AllowCommunicationComplianceEndUserReporting,

        [Parameter()]
        [System.String]
        $ChatPermissionRole,

        [Parameter()]
        [System.Boolean]
        $AllowImmersiveReader,

        [Parameter()]
        [System.Boolean]
        $AllowUserTranslation,

        [Parameter()]
        [System.Boolean]
        $AllowUserEditMessage,

        [Parameter()]
        [System.String]
        $AudioMessageEnabledType,

        [Parameter()]
        [System.Boolean]
        $AllowRemoveUser,

        [Parameter()]
        [System.Boolean]
        $AllowPasteInternetImage,

        [Parameter()]
        [System.String]
        $ReadReceiptsEnabledType,

        [Parameter()]
        [System.Boolean]
        $AllowMemes,

        [Parameter()]
        [System.Boolean]
        $AllowFluidCollaborate,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Boolean]
        $AllowPriorityMessages,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode,

        [Parameter()]
        [System.Boolean]
        $AllowVideoMessages,

        [Parameter()]
        [System.String]
        $GiphyRatingType,

        [Parameter()]
        [System.Boolean]
        $AllowSmartCompose,

        [Parameter()]
        [System.Boolean]
        $AllowUserDeleteChat
    )
}
function New-CsTeamsUpdateManagementPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $UpdateTime,

        [Parameter()]
        [System.DateTime]
        $UpdateTimeOfDay,

        [Parameter()]
        [System.Int64]
        $UpdateDayOfWeek,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Boolean]
        $AllowManagedUpdates,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $AllowPreview,

        [Parameter()]
        [System.String]
        $AllowPublicPreview,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function New-CsTenantDialPlan
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $OptimizeDeviceDialing,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $NormalizationRules,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $ExternalAccessPrefix,

        [Parameter()]
        [System.String]
        $SimpleName,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function New-CsVoiceNormalizationRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Int32]
        $Priority,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $Pattern,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $Parent,

        [Parameter()]
        [System.String]
        $Translation,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $InMemory,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode,

        [Parameter()]
        [System.Boolean]
        $IsInternalExtension
    )
}
function Remove-CsOnlineVoiceRoute
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Remove-CsOnlineVoiceRoutingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Remove-CsTeamsCallingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Remove-CsTeamsChannelsPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Remove-CsTeamsEmergencyCallingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Remove-CsTeamsEmergencyCallRoutingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Remove-CsTeamsEventsPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Remove-CsTeamsMeetingBroadcastPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Remove-CsTeamsMeetingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Remove-CsTeamsMessagingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Remove-CsTeamsUpdateManagementPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Remove-CsTenantDialPlan
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Set-CsOnlinePstnUsage
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Usage,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Set-CsOnlineVoiceRoute
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $BridgeSourcePhoneNumber,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Int32]
        $Priority,

        [Parameter()]
        [System.Object]
        $OnlinePstnGatewayList,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $NumberPattern,

        [Parameter()]
        [System.Object]
        $OnlinePstnUsages,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Set-CsOnlineVoiceRoutingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $RouteType,

        [Parameter()]
        [System.Object]
        $OnlinePstnUsages,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Set-CsTeamsCallingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $AllowWebPSTNCalling,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $PreventTollBypass,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Boolean]
        $AllowCloudRecordingForCalls,

        [Parameter()]
        [System.String]
        $AllowCallRedirect,

        [Parameter()]
        [System.Boolean]
        $AllowCallGroups,

        [Parameter()]
        [System.String]
        $SpamFilteringEnabledType,

        [Parameter()]
        [System.Boolean]
        $AllowSIPDevicesCalling,

        [Parameter()]
        [System.String]
        $PopoutAppPathForIncomingPstnCalls,

        [Parameter()]
        [System.String]
        $BusyOnBusyEnabledType,

        [Parameter()]
        [System.String]
        $AllowVoicemail,

        [Parameter()]
        [System.String]
        $PopoutForIncomingPstnCalls,

        [Parameter()]
        [System.String]
        $MusicOnHoldEnabledType,

        [Parameter()]
        [System.Boolean]
        $AllowCallForwardingToUser,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode,

        [Parameter()]
        [System.Boolean]
        $AllowCallForwardingToPhone,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateCalling,

        [Parameter()]
        [System.String]
        $LiveCaptionsEnabledTypeForCalling,

        [Parameter()]
        [System.Boolean]
        $AllowDelegation,

        [Parameter()]
        [System.Int64]
        $CallRecordingExpirationDays,

        [Parameter()]
        [System.String]
        $AutoAnswerEnabledType,

        [Parameter()]
        [System.Boolean]
        $AllowTranscriptionForCalling
    )
}
function Set-CsTeamsChannelsPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $AllowSharedChannelCreation,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $AllowChannelSharingToExternalUser,

        [Parameter()]
        [System.Boolean]
        $AllowOrgWideTeamCreation,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateChannelCreation,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateTeamDiscovery,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode,

        [Parameter()]
        [System.Boolean]
        $AllowUserToParticipateInExternalSharedChannel
    )
}
function Set-CsTeamsClientConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $AllowEmailIntoChannel,

        [Parameter()]
        [System.String]
        $RestrictedSenderList,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Boolean]
        $AllowGoogleDrive,

        [Parameter()]
        [System.Boolean]
        $AllowSkypeBusinessInterop,

        [Parameter()]
        [System.Boolean]
        $AllowScopedPeopleSearchandAccess,

        [Parameter()]
        [System.Boolean]
        $AllowGuestUser,

        [Parameter()]
        [System.Boolean]
        $AllowShareFile,

        [Parameter()]
        [System.Boolean]
        $AllowDropBox,

        [Parameter()]
        [System.Boolean]
        $AllowOrganizationTab,

        [Parameter()]
        [System.String]
        $ResourceAccountContentAccess,

        [Parameter()]
        [System.Boolean]
        $AllowRoleBasedChatPermissions,

        [Parameter()]
        [System.Boolean]
        $AllowEgnyte,

        [Parameter()]
        [System.Boolean]
        $AllowBox,

        [Parameter()]
        [System.Boolean]
        $AllowResourceAccountSendMessage,

        [Parameter()]
        [System.String]
        $ContentPin,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Set-CsTeamsEmergencyCallingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $NotificationGroup,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $NotificationDialOutNumber,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $EnhancedEmergencyServiceDisclaimer,

        [Parameter()]
        [System.Object]
        $NotificationMode,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode,

        [Parameter()]
        [System.String]
        $ExternalLocationLookupMode
    )
}
function Set-CsTeamsEmergencyCallRoutingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $EmergencyNumbers,

        [Parameter()]
        [System.Boolean]
        $AllowEnhancedEmergencyServices,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Set-CsTeamsEventsPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $EventAccessType,

        [Parameter()]
        [System.String]
        $AllowWebinars,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Set-CsTeamsGuestCallingConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateCalling,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Set-CsTeamsGuestMeetingConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $ScreenSharingMode,

        [Parameter()]
        [System.String]
        $LiveCaptionsEnabledType,

        [Parameter()]
        [System.Boolean]
        $AllowMeetNow,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Boolean]
        $AllowTranscription,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode,

        [Parameter()]
        [System.Boolean]
        $AllowIPVideo
    )
}
function Set-CsTeamsGuestMessagingConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $GiphyRatingType,

        [Parameter()]
        [System.Boolean]
        $AllowUserChat,

        [Parameter()]
        [System.Boolean]
        $AllowUserDeleteChat,

        [Parameter()]
        [System.Boolean]
        $AllowUserDeleteMessage,

        [Parameter()]
        [System.Boolean]
        $AllowGiphy,

        [Parameter()]
        [System.Boolean]
        $AllowStickers,

        [Parameter()]
        [System.Boolean]
        $AllowUserEditMessage,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $AllowImmersiveReader,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Boolean]
        $AllowMemes
    )
}
function Set-CsTeamsMeetingBroadcastConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $AllowSdnProviderForBroadcastMeeting,

        [Parameter()]
        [System.String]
        $SdnRuntimeConfiguration,

        [Parameter()]
        [System.String]
        $SdnProviderName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $SdnLicenseId,

        [Parameter()]
        [System.String]
        $SupportURL,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode,

        [Parameter()]
        [System.String]
        $SdnApiToken,

        [Parameter()]
        [System.String]
        $SdnApiTemplateUrl
    )
}
function Set-CsTeamsMeetingBroadcastPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $BroadcastAttendeeVisibilityMode,

        [Parameter()]
        [System.Boolean]
        $AllowBroadcastTranscription,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $BroadcastRecordingMode,

        [Parameter()]
        [System.Boolean]
        $AllowBroadcastScheduling,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm
    )
}
function Set-CsTeamsMeetingConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.UInt32]
        $ClientVideoPortRange,

        [Parameter()]
        [System.Boolean]
        $DisableAnonymousJoin,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $HelpURL,

        [Parameter()]
        [System.Boolean]
        $EnableQoS,

        [Parameter()]
        [System.UInt32]
        $ClientAppSharingPortRange,

        [Parameter()]
        [System.Boolean]
        $DisableAppInteractionForAnonymousUsers,

        [Parameter()]
        [System.String]
        $LogoURL,

        [Parameter()]
        [System.UInt32]
        $ClientAppSharingPort,

        [Parameter()]
        [System.String]
        $CustomFooterText,

        [Parameter()]
        [System.UInt32]
        $ClientVideoPort,

        [Parameter()]
        [System.UInt32]
        $ClientAudioPortRange,

        [Parameter()]
        [System.Boolean]
        $ClientMediaPortRangeEnabled,

        [Parameter()]
        [System.UInt32]
        $ClientAudioPort,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode,

        [Parameter()]
        [System.String]
        $LegalURL
    )
}
function Set-CsTeamsMeetingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $TeamsCameraFarEndPTZMode,

        [Parameter()]
        [System.String]
        $AllowTrackingInReport,

        [Parameter()]
        [System.Boolean]
        $AllowMeetingCoach,

        [Parameter()]
        [System.Boolean]
        $AllowMeetNow,

        [Parameter()]
        [System.Boolean]
        $AllowIPAudio,

        [Parameter()]
        [System.Boolean]
        $AllowWhiteboard,

        [Parameter()]
        [System.Boolean]
        $AllowAnonymousUsersToDialOut,

        [Parameter()]
        [System.String]
        $StreamingAttendeeMode,

        [Parameter()]
        [System.Boolean]
        $AllowNetworkConfigurationSettingsLookup,

        [Parameter()]
        [System.Boolean]
        $AllowTranscription,

        [Parameter()]
        [System.String]
        $RoomAttributeUserOverride,

        [Parameter()]
        [System.String]
        $RoomPeopleNameUserOverride,

        [Parameter()]
        [System.String]
        $AllowUserToJoinExternalMeeting,

        [Parameter()]
        [System.Boolean]
        $AllowExternalParticipantGiveRequestControl,

        [Parameter()]
        [System.Boolean]
        $AllowAnonymousUsersToStartMeeting,

        [Parameter()]
        [System.String]
        $AutoAdmittedUsers,

        [Parameter()]
        [System.String]
        $AllowTasksFromTranscript,

        [Parameter()]
        [System.Boolean]
        $AllowMeetingRegistration,

        [Parameter()]
        [System.String]
        $ChannelRecordingDownload,

        [Parameter()]
        [System.String]
        $RecordingStorageMode,

        [Parameter()]
        [System.String]
        $ScreenSharingMode,

        [Parameter()]
        [System.String]
        $AllowCartCaptionsScheduling,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateMeetNow,

        [Parameter()]
        [System.String]
        $AllowEngagementReport,

        [Parameter()]
        [System.Boolean]
        $AllowWatermarkForCameraVideo,

        [Parameter()]
        [System.String]
        $PreferredMeetingProviderForIslandsMode,

        [Parameter()]
        [System.Boolean]
        $AllowOrganizersToOverrideLobbySettings,

        [Parameter()]
        [System.String]
        $LiveCaptionsEnabledType,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode,

        [Parameter()]
        [System.Boolean]
        $AllowNDIStreaming,

        [Parameter()]
        [System.String]
        $IPAudioMode,

        [Parameter()]
        [System.String]
        $AllowScreenContentDigitization,

        [Parameter()]
        [System.String]
        $BlockedAnonymousJoinClientTypes,

        [Parameter()]
        [System.String]
        $LiveInterpretationEnabledType,

        [Parameter()]
        [System.Int64]
        $NewMeetingRecordingExpirationDays,

        [Parameter()]
        [System.Boolean]
        $AllowAnonymousUsersToJoinMeeting,

        [Parameter()]
        [System.String]
        $MeetingInviteLanguages,

        [Parameter()]
        [System.String]
        $WhoCanRegister,

        [Parameter()]
        [System.Boolean]
        $AllowAvatarsInGallery,

        [Parameter()]
        [System.Boolean]
        $AllowCloudRecording,

        [Parameter()]
        [System.Boolean]
        $AllowWatermarkForScreenSharing,

        [Parameter()]
        [System.Boolean]
        $AllowIPVideo,

        [Parameter()]
        [System.String]
        $SpeakerAttributionMode,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $AllowImmersiveView,

        [Parameter()]
        [System.Boolean]
        $AllowOutlookAddIn,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $DesignatedPresenterRoleMode,

        [Parameter()]
        [System.String]
        $MeetingChatEnabledType,

        [Parameter()]
        [System.String]
        $QnAEngagementMode,

        [Parameter()]
        [System.Boolean]
        $AllowSharedNotes,

        [Parameter()]
        [System.Boolean]
        $AllowParticipantGiveRequestControl,

        [Parameter()]
        [System.UInt32]
        $MediaBitRateKb,

        [Parameter()]
        [System.String]
        $EnrollUserOverride,

        [Parameter()]
        [System.Boolean]
        $AllowPowerPointSharing,

        [Parameter()]
        [System.Boolean]
        $AllowPrivateMeetingScheduling,

        [Parameter()]
        [System.Boolean]
        $AllowChannelMeetingScheduling,

        [Parameter()]
        [System.Boolean]
        $AllowMeetingReactions,

        [Parameter()]
        [System.String]
        $VideoFiltersMode,

        [Parameter()]
        [System.String]
        $InfoShownInReportMode,

        [Parameter()]
        [System.String]
        $LiveStreamingMode,

        [Parameter()]
        [System.Boolean]
        $AllowBreakoutRooms,

        [Parameter()]
        [System.Boolean]
        $AllowRecordingStorageOutsideRegion,

        [Parameter()]
        [System.Boolean]
        $AllowPSTNUsersToBypassLobby,

        [Parameter()]
        [System.Boolean]
        $AllowCarbonSummary,

        [Parameter()]
        [System.String]
        $IPVideoMode
    )
}
function Set-CsTeamsMessagingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $AllowOwnerDeleteMessage,

        [Parameter()]
        [System.Boolean]
        $AllowSmartReply,

        [Parameter()]
        [System.Boolean]
        $AllowUserChat,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $AllowGiphy,

        [Parameter()]
        [System.Boolean]
        $AllowUserDeleteMessage,

        [Parameter()]
        [System.String]
        $ChannelsInChatListEnabledType,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $AllowStickers,

        [Parameter()]
        [System.Boolean]
        $AllowFullChatPermissionUserToDeleteAnyMessage,

        [Parameter()]
        [System.Boolean]
        $AllowUrlPreviews,

        [Parameter()]
        [System.Boolean]
        $AllowGiphyDisplay,

        [Parameter()]
        [System.Boolean]
        $AllowCommunicationComplianceEndUserReporting,

        [Parameter()]
        [System.String]
        $ChatPermissionRole,

        [Parameter()]
        [System.Boolean]
        $AllowImmersiveReader,

        [Parameter()]
        [System.Boolean]
        $AllowUserTranslation,

        [Parameter()]
        [System.Boolean]
        $AllowUserEditMessage,

        [Parameter()]
        [System.String]
        $AudioMessageEnabledType,

        [Parameter()]
        [System.Boolean]
        $AllowRemoveUser,

        [Parameter()]
        [System.Boolean]
        $AllowPasteInternetImage,

        [Parameter()]
        [System.String]
        $ReadReceiptsEnabledType,

        [Parameter()]
        [System.Boolean]
        $AllowMemes,

        [Parameter()]
        [System.Boolean]
        $AllowFluidCollaborate,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Boolean]
        $AllowPriorityMessages,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode,

        [Parameter()]
        [System.Boolean]
        $AllowVideoMessages,

        [Parameter()]
        [System.String]
        $GiphyRatingType,

        [Parameter()]
        [System.Boolean]
        $AllowSmartCompose,

        [Parameter()]
        [System.Boolean]
        $AllowUserDeleteChat
    )
}
function Set-CsTeamsUpdateManagementPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $UpdateTime,

        [Parameter()]
        [System.DateTime]
        $UpdateTimeOfDay,

        [Parameter()]
        [System.Int64]
        $UpdateDayOfWeek,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Boolean]
        $AllowManagedUpdates,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $AllowPreview,

        [Parameter()]
        [System.String]
        $AllowPublicPreview,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Set-CsTeamsUpgradeConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Boolean]
        $DownloadTeams,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $SfBMeetingJoinUx,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Set-CsTenantDialPlan
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $OptimizeDeviceDialing,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $NormalizationRules,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $ExternalAccessPrefix,

        [Parameter()]
        [System.String]
        $SimpleName,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode
    )
}
function Set-CsTenantFederationConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $AllowTeamsConsumerInbound,

        [Parameter()]
        [System.Boolean]
        $SharedSipAddressSpace,

        [Parameter()]
        [System.Object]
        $BlockedDomains,

        [Parameter()]
        [System.Boolean]
        $TreatDiscoveredPartnersAsUnverified,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Boolean]
        $AllowTeamsConsumer,

        [Parameter()]
        [System.Object]
        $AllowedDomainsAsAList,

        [Parameter()]
        [System.Object]
        $AllowedDomains,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $AllowPublicUsers,

        [Parameter()]
        [System.String]
        $MsftInternalProcessingMode,

        [Parameter()]
        [System.Boolean]
        $AllowFederatedUsers,

        [Parameter()]
        [System.Boolean]
        $RestrictTeamsConsumerToExternalUserProfiles
    )
}
#endregion
