#region ExchangeOnline
function Add-AvailabilityAddressSpace
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Credentials,

        [Parameter()]
        [System.Object]
        $ForestName,

        [Parameter()]
        [System.Object]
        $TargetAutodiscoverEpr,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $AccessMethod,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Enable-OrganizationCustomization
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-AcceptedDomain
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
function Get-ActiveSyncDevice
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $SortBy,

        [Parameter()]
        [System.Object]
        $Mailbox,

        [Parameter()]
        [System.Object]
        $OrganizationalUnit,

        [Parameter()]
        [System.Object]
        $Filter,

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
function Get-ActiveSyncDeviceAccessRule
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
function Get-AddressBookPolicy
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
function Get-AdminAuditLogConfig
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Spoof,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $State,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $PrivateCatalog,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-ApplicationAccessPolicy
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
function Get-AtpPolicyForO365
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
function Get-AuditConfig
{
    [CmdletBinding()]
    param(
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
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-AuthenticationPolicy
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
function Get-AvailabilityAddressSpace
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
function Get-AvailabilityConfig
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
function Get-CASMailbox
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $ResultSize,

        [Parameter()]
        [System.Object]
        $SortBy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ReadIsOptimizedForAccessibility,

        [Parameter()]
        [System.Object]
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
        [System.Management.Automation.SwitchParameter]
        $ProtocolSettings,

        [Parameter()]
        [System.Object]
        $RecipientTypeDetails,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RecalculateHasActiveSyncDevicePartnership,

        [Parameter()]
        [System.Object]
        $Filter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ActiveSyncSuppressReadReceipt,

        [Parameter()]
        [System.Object]
        $Anr,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-CASMailboxPlan
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $SortBy,

        [Parameter()]
        [System.Object]
        $Credential,

        [Parameter()]
        [System.Object]
        $Filter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IgnoreDefaultScope,

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
        $DomainController,

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
function Get-DataClassification
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $ClassificationRuleCollectionIdentity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $DomainController,

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
function Get-DistributionGroup
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $SortBy,

        [Parameter()]
        [System.Object]
        $Credential,

        [Parameter()]
        [System.Object]
        $OrganizationalUnit,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $RecipientTypeDetails,

        [Parameter()]
        [System.Object]
        $ManagedBy,

        [Parameter()]
        [System.Object]
        $Filter,

        [Parameter()]
        [System.Object]
        $ResultSize,

        [Parameter()]
        [System.Object]
        $Anr,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-DkimSigningConfig
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
function Get-EmailAddressPolicy
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
function Get-HostedConnectionFilterPolicy
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
function Get-HostedContentFilterPolicy
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
function Get-HostedContentFilterRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $State,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-HostedOutboundSpamFilterPolicy
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
function Get-HostedOutboundSpamFilterRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $State,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-InboundConnector
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
function Get-IntraOrganizationConnector
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
function Get-IRMConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-JournalRule
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
function Get-Mailbox
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IncludeInactiveMailbox,

        [Parameter()]
        [System.Object]
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
        [System.Object]
        $RecipientTypeDetails,

        [Parameter()]
        [System.Object]
        $ResultSize,

        [Parameter()]
        [System.Object]
        $Filter,

        [Parameter()]
        [System.Object]
        $MailboxPlan,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Migration,

        [Parameter()]
        [System.Object]
        $Anr,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-MailboxPlan
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $SortBy,

        [Parameter()]
        [System.Object]
        $Credential,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IgnoreDefaultScope,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllMailboxPlanReleases,

        [Parameter()]
        [System.Object]
        $Filter,

        [Parameter()]
        [System.Object]
        $ResultSize,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Archive,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-MalwareFilterPolicy
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
function Get-MalwareFilterRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $State,

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
function Get-MessageClassification
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IncludeLocales,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        [System.Object]
        $SortBy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $UniversalOutlook,

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
        $ActiveSync,

        [Parameter()]
        [System.Object]
        $ResultSize,

        [Parameter()]
        [System.Object]
        $Filter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RestApi,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-MobileDeviceMailboxPolicy
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
function Get-OMEConfiguration
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
function Get-OnPremisesOrganization
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
function Get-OrganizationConfig
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-OrganizationRelationship
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
function Get-OutboundConnector
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $IncludeTestModeConnectors,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $IsTransportRuleScoped,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-OwaMailboxPolicy
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
function Get-PartnerApplication
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
function Get-PerimeterConfig
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
function Get-PolicyTipConfig
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Locale,

        [Parameter()]
        [System.Object]
        $Action,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Original,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $QuarantinePolicyType,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-RemoteDomain
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
function Get-ResourceConfig
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-RoleAssignmentPolicy
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
function Get-SafeAttachmentPolicy
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
function Get-SafeAttachmentRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $State,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-SafeLinksPolicy
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
function Get-SafeLinksRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $State,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-SharingPolicy
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
function Get-TransportConfig
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-TransportRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $DlpPolicy,

        [Parameter()]
        [System.Object]
        $ExcludeConditionActionDetails,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $State,

        [Parameter()]
        [System.Object]
        $Filter,

        [Parameter()]
        [System.Object]
        $ResultSize,

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
        [System.Management.Automation.SwitchParameter]
        $IsVIP,

        [Parameter()]
        [System.Object]
        $OrganizationalUnit,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $RecipientTypeDetails,

        [Parameter()]
        [System.Object]
        $ResultSize,

        [Parameter()]
        [System.Object]
        $Filter,

        [Parameter()]
        [System.Object]
        $Anr,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-ActiveSyncDeviceAccessRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $QueryString,

        [Parameter()]
        [System.Object]
        $Characteristic,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $AccessLevel,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-AntiPhishPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $EnableFirstContactSafetyTips,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $MakeDefault,

        [Parameter()]
        [System.Object]
        $PhishThresholdLevel,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $EnableTargetedDomainsProtection,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Object]
        $EnableViaTag,

        [Parameter()]
        [System.Object]
        $MailboxIntelligenceProtectionAction,

        [Parameter()]
        [System.Object]
        $TargetedDomainsToProtect,

        [Parameter()]
        [System.Object]
        $EnableOrganizationDomainsProtection,

        [Parameter()]
        [System.Object]
        $EnableSpoofIntelligence,

        [Parameter()]
        [System.Object]
        $EnableSimilarUsersSafetyTips,

        [Parameter()]
        [System.Object]
        $ExcludedDomains,

        [Parameter()]
        [System.Object]
        $TargetedDomainActionRecipients,

        [Parameter()]
        [System.Object]
        $EnableMailboxIntelligence,

        [Parameter()]
        [System.Object]
        $TargetedDomainQuarantineTag,

        [Parameter()]
        [System.Object]
        $SimilarUsersSafetyTipsCustomText,

        [Parameter()]
        [System.Object]
        $ImpersonationProtectionState,

        [Parameter()]
        [System.Object]
        $TargetedDomainProtectionAction,

        [Parameter()]
        [System.Object]
        $AdminDisplayName,

        [Parameter()]
        [System.Object]
        $AuthenticationFailAction,

        [Parameter()]
        [System.Object]
        $TargetedUsersToProtect,

        [Parameter()]
        [System.Object]
        $SpoofQuarantineTag,

        [Parameter()]
        [System.Object]
        $RecommendedPolicyType,

        [Parameter()]
        [System.Object]
        $MailboxIntelligenceProtectionActionRecipients,

        [Parameter()]
        [System.Object]
        $MailboxIntelligenceQuarantineTag,

        [Parameter()]
        [System.Object]
        $UnusualCharactersSafetyTipsCustomText,

        [Parameter()]
        [System.Object]
        $EnableSimilarDomainsSafetyTips,

        [Parameter()]
        [System.Object]
        $EnableTargetedUserProtection,

        [Parameter()]
        [System.Object]
        $EnableUnauthenticatedSender,

        [Parameter()]
        [System.Object]
        $TargetedUserQuarantineTag,

        [Parameter()]
        [System.Object]
        $PolicyTag,

        [Parameter()]
        [System.Object]
        $EnableUnusualCharactersSafetyTips,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $EnableMailboxIntelligenceProtection,

        [Parameter()]
        [System.Object]
        $TargetedUserProtectionAction,

        [Parameter()]
        [System.Object]
        $TargetedUserActionRecipients,

        [Parameter()]
        [System.Object]
        $ExcludedSenders,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-AntiPhishRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Priority,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $SentToMemberOf,

        [Parameter()]
        [System.Object]
        $AntiPhishPolicy,

        [Parameter()]
        [System.Object]
        $SentTo,

        [Parameter()]
        [System.Object]
        $Comments,

        [Parameter()]
        [System.Object]
        $RecipientDomainIs,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.Object]
        $ExceptIfSentTo,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $ExceptIfSentToMemberOf,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-App
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Etoken,

        [Parameter()]
        [System.Object]
        $FileStream,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Object]
        $Url,

        [Parameter()]
        [System.Object]
        $Mailbox,

        [Parameter()]
        [System.Object]
        $MarketplaceServicesUrl,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PrivateCatalog,

        [Parameter()]
        [System.Object]
        $MarketplaceCorrelationID,

        [Parameter()]
        [System.Object]
        $DefaultStateForUser,

        [Parameter()]
        [System.Object]
        $MarketplaceQueryMarket,

        [Parameter()]
        [System.Object]
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
        [System.Object]
        $MarketplaceAssetID,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $FileData,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowReadWriteMailbox,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-ApplicationAccessPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Description,

        [Parameter()]
        [System.Object]
        $AppId,

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
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-AuthenticationPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowBasicAuthRpc,

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
        $AllowBasicAuthActiveSync,

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
        $AllowBasicAuthWebServices,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $OrgWideAccount,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-ClientAccessRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $UsernameMatchesAnyOfPatterns,

        [Parameter()]
        [System.Object]
        $Action,

        [Parameter()]
        [System.Object]
        $AnyOfClientIPAddressesOrRanges,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Object]
        $ExceptAnyOfClientIPAddressesOrRanges,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $UserRecipientFilter,

        [Parameter()]
        [System.Object]
        $ExceptAnyOfProtocols,

        [Parameter()]
        [System.Object]
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
        $Scope,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-DataClassification
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
        $Locale,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $ClassificationRuleCollectionIdentity,

        [Parameter()]
        [System.Object]
        $Fingerprints,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-DataEncryptionPolicy
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
        $AzureKeyIDs,

        [Parameter()]
        [System.Object]
        $DomainController,

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
function New-DistributionGroup
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $ModeratedBy,

        [Parameter()]
        [System.Object]
        $RequireSenderAuthenticationEnabled,

        [Parameter()]
        [System.Object]
        $ModerationEnabled,

        [Parameter()]
        [System.Object]
        $DisplayName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $MemberDepartRestriction,

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
        [System.Object]
        $BypassNestedModerationEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $CopyOwnerToMember,

        [Parameter()]
        [System.Object]
        $BccBlocked,

        [Parameter()]
        [System.Object]
        $Members,

        [Parameter()]
        [System.Object]
        $Description,

        [Parameter()]
        [System.Object]
        $MemberJoinRestriction,

        [Parameter()]
        [System.Object]
        $Type,

        [Parameter()]
        [System.Object]
        $Alias,

        [Parameter()]
        [System.Object]
        $ManagedBy,

        [Parameter()]
        [System.Object]
        $PrimarySmtpAddress,

        [Parameter()]
        [System.Object]
        $SendModerationNotifications,

        [Parameter()]
        [System.Object]
        $Notes,

        [Parameter()]
        [System.Object]
        $OrganizationalUnit,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-DkimSigningConfig
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $AdminDisplayName,

        [Parameter()]
        [System.Object]
        $BodyCanonicalization,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $KeySize,

        [Parameter()]
        [System.Object]
        $HeaderCanonicalization,

        [Parameter()]
        [System.Object]
        $DomainName,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $EnabledEmailAddressTemplates,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $EnabledPrimarySMTPAddressTemplate,

        [Parameter()]
        [System.Object]
        $ManagedByFilter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IncludeUnifiedGroupRecipients,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-HostedConnectionFilterPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $ConfigurationXmlRaw,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $AdminDisplayName,

        [Parameter()]
        [System.Object]
        $EnableSafeList,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $IPBlockList,

        [Parameter()]
        [System.Object]
        $IPAllowList,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        [System.Object]
        $InlineSafetyTipsEnabled,

        [Parameter()]
        [System.Object]
        $RegionBlockList,

        [Parameter()]
        [System.Object]
        $MarkAsSpamFromAddressAuthFail,

        [Parameter()]
        [System.Object]
        $HighConfidencePhishQuarantineTag,

        [Parameter()]
        [System.Object]
        $EndUserSpamNotificationFrequency,

        [Parameter()]
        [System.Object]
        $EndUserSpamNotificationLimit,

        [Parameter()]
        [System.Object]
        $BulkThreshold,

        [Parameter()]
        [System.Object]
        $PhishQuarantineTag,

        [Parameter()]
        [System.Object]
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
        [System.Object]
        $EnableLanguageBlockList,

        [Parameter()]
        [System.Object]
        $PhishSpamAction,

        [Parameter()]
        [System.Object]
        $EndUserSpamNotificationCustomFromName,

        [Parameter()]
        [System.Object]
        $MarkAsSpamSensitiveWordList,

        [Parameter()]
        [System.Object]
        $SpamQuarantineTag,

        [Parameter()]
        [System.Object]
        $SpamZapEnabled,

        [Parameter()]
        [System.Object]
        $BlockedSenders,

        [Parameter()]
        [System.Object]
        $HighConfidenceSpamAction,

        [Parameter()]
        [System.Object]
        $AllowedSenderDomains,

        [Parameter()]
        [System.Object]
        $IncreaseScoreWithBizOrInfoUrls,

        [Parameter()]
        [System.Object]
        $MarkAsSpamWebBugsInHtml,

        [Parameter()]
        [System.Object]
        $AdminDisplayName,

        [Parameter()]
        [System.Object]
        $MarkAsSpamJavaScriptInHtml,

        [Parameter()]
        [System.Object]
        $MarkAsSpamEmptyMessages,

        [Parameter()]
        [System.Object]
        $LanguageBlockList,

        [Parameter()]
        [System.Object]
        $MarkAsSpamNdrBackscatter,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $BulkQuarantineTag,

        [Parameter()]
        [System.Object]
        $MarkAsSpamFormTagsInHtml,

        [Parameter()]
        [System.Object]
        $MarkAsSpamObjectTagsInHtml,

        [Parameter()]
        [System.Object]
        $BulkSpamAction,

        [Parameter()]
        [System.Object]
        $EndUserSpamNotificationLanguage,

        [Parameter()]
        [System.Object]
        $IncreaseScoreWithRedirectToOtherPort,

        [Parameter()]
        [System.Object]
        $QuarantineRetentionPeriod,

        [Parameter()]
        [System.Object]
        $HighConfidencePhishAction,

        [Parameter()]
        [System.Object]
        $RedirectToRecipients,

        [Parameter()]
        [System.Object]
        $TestModeAction,

        [Parameter()]
        [System.Object]
        $EnableRegionBlockList,

        [Parameter()]
        [System.Object]
        $EndUserSpamNotificationCustomSubject,

        [Parameter()]
        [System.Object]
        $MarkAsSpamSpfRecordHardFail,

        [Parameter()]
        [System.Object]
        $EndUserSpamNotificationCustomFromAddress,

        [Parameter()]
        [System.Object]
        $DownloadLink,

        [Parameter()]
        [System.Object]
        $SpamAction,

        [Parameter()]
        [System.Object]
        $ModifySubjectValue,

        [Parameter()]
        [System.Object]
        $IncreaseScoreWithNumericIps,

        [Parameter()]
        [System.Object]
        $AllowedSenders,

        [Parameter()]
        [System.Object]
        $TestModeBccToRecipients,

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
        [System.Object]
        $PhishZapEnabled,

        [Parameter()]
        [System.Object]
        $EnableEndUserSpamNotifications,

        [Parameter()]
        [System.Object]
        $HighConfidenceSpamQuarantineTag,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-HostedContentFilterRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Priority,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $SentToMemberOf,

        [Parameter()]
        [System.Object]
        $HostedContentFilterPolicy,

        [Parameter()]
        [System.Object]
        $SentTo,

        [Parameter()]
        [System.Object]
        $Comments,

        [Parameter()]
        [System.Object]
        $RecipientDomainIs,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.Object]
        $ExceptIfSentTo,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $ExceptIfSentToMemberOf,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-HostedOutboundSpamFilterRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Priority,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $ExceptIfFrom,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderDomainIs,

        [Parameter()]
        [System.Object]
        $Comments,

        [Parameter()]
        [System.Object]
        $FromMemberOf,

        [Parameter()]
        [System.Object]
        $SenderDomainIs,

        [Parameter()]
        [System.Object]
        $HostedOutboundSpamFilterPolicy,

        [Parameter()]
        [System.Object]
        $ExceptIfFromMemberOf,

        [Parameter()]
        [System.Object]
        $From,

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
function New-InboundConnector
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $RestrictDomainsToIPAddresses,

        [Parameter()]
        [System.Object]
        $CloudServicesMailEnabled,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $EFSkipMailGateway,

        [Parameter()]
        [System.Object]
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
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $RequireTls,

        [Parameter()]
        [System.Object]
        $SenderDomains,

        [Parameter()]
        [System.Object]
        $SenderIPAddresses,

        [Parameter()]
        [System.Object]
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
        [System.Object]
        $RestrictDomainsToCertificate,

        [Parameter()]
        [System.Object]
        $EFSkipIPs,

        [Parameter()]
        [System.Object]
        $TreatMessagesAsInternal,

        [Parameter()]
        [System.Object]
        $ConnectorSource,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-IntraOrganizationConnector
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $TargetAddressDomains,

        [Parameter()]
        [System.Object]
        $DiscoveryEndpoint,

        [Parameter()]
        [System.Object]
        $TargetSharingEpr,

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
function New-JournalRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Scope,

        [Parameter()]
        [System.Object]
        $Name,

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
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-Mailbox
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $MailboxRegion,

        [Parameter()]
        [System.Object]
        $ModeratedBy,

        [Parameter()]
        [System.Object]
        $ModerationEnabled,

        [Parameter()]
        [System.Object]
        $Office,

        [Parameter()]
        [System.Object]
        $DisplayName,

        [Parameter()]
        [System.Object]
        $Password,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $TargetAllMDBs,

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
        [System.Object]
        $LastName,

        [Parameter()]
        [System.Object]
        $EnableRoomMailboxAccount,

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
        [System.Object]
        $ImmutableId,

        [Parameter()]
        [System.Object]
        $RoomMailboxPassword,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Shared,

        [Parameter()]
        [System.Object]
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
        [System.Object]
        $ResetPasswordOnNextLogon,

        [Parameter()]
        [System.Object]
        $Initials,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $FederatedIdentity,

        [Parameter()]
        [System.Object]
        $ActiveSyncMailboxPolicy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $HoldForMigration,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Discovery,

        [Parameter()]
        [System.Object]
        $Alias,

        [Parameter()]
        [System.Object]
        $FirstName,

        [Parameter()]
        [System.Object]
        $Phone,

        [Parameter()]
        [System.Object]
        $PrimarySmtpAddress,

        [Parameter()]
        [System.Object]
        $SendModerationNotifications,

        [Parameter()]
        [System.Object]
        $InactiveMailbox,

        [Parameter()]
        [System.Object]
        $OrganizationalUnit,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $RemotePowerShellEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-MalwareFilterPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $CustomFromName,

        [Parameter()]
        [System.Object]
        $AdminDisplayName,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $QuarantineTag,

        [Parameter()]
        [System.Object]
        $CustomNotifications,

        [Parameter()]
        [System.Object]
        $EnableExternalSenderAdminNotifications,

        [Parameter()]
        [System.Object]
        $InternalSenderAdminAddress,

        [Parameter()]
        [System.Object]
        $CustomExternalBody,

        [Parameter()]
        [System.Object]
        $FileTypes,

        [Parameter()]
        [System.Object]
        $EnableInternalSenderAdminNotifications,

        [Parameter()]
        [System.Object]
        $CustomFromAddress,

        [Parameter()]
        [System.Object]
        $CustomExternalSubject,

        [Parameter()]
        [System.Object]
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
        [System.Object]
        $CustomInternalSubject,

        [Parameter()]
        [System.Object]
        $CustomInternalBody,

        [Parameter()]
        [System.Object]
        $EnableFileFilter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-MalwareFilterRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Priority,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $SentToMemberOf,

        [Parameter()]
        [System.Object]
        $SentTo,

        [Parameter()]
        [System.Object]
        $Comments,

        [Parameter()]
        [System.Object]
        $RecipientDomainIs,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.Object]
        $MalwareFilterPolicy,

        [Parameter()]
        [System.Object]
        $ExceptIfSentTo,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $ExceptIfSentToMemberOf,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-ManagementRole
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
        $EnabledCmdlets,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Parent,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $RecipientAdministrativeUnitScope,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $Policy,

        [Parameter()]
        [System.Object]
        $User,

        [Parameter()]
        [System.Object]
        $ExclusiveRecipientWriteScope,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Delegating,

        [Parameter()]
        [System.Object]
        $SecurityGroup,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

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
        $RecipientOrganizationalUnitScope,

        [Parameter()]
        [System.Object]
        $RecipientRelativeWriteScope,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-MessageClassification
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Locale,

        [Parameter()]
        [System.Object]
        $DisplayName,

        [Parameter()]
        [System.Object]
        $RecipientDescription,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $PermissionMenuVisible,

        [Parameter()]
        [System.Object]
        $ClassificationID,

        [Parameter()]
        [System.Object]
        $SenderDescription,

        [Parameter()]
        [System.Object]
        $DisplayPrecedence,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $RetainClassificationEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-MobileDeviceMailboxPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $AllowMicrosoftPushNotifications,

        [Parameter()]
        [System.Object]
        $AllowUnsignedApplications,

        [Parameter()]
        [System.Object]
        $AllowUnsignedInstallationPackages,

        [Parameter()]
        [System.Object]
        $MaxPasswordFailedAttempts,

        [Parameter()]
        [System.Object]
        $AllowExternalDeviceManagement,

        [Parameter()]
        [System.Object]
        $RequireDeviceEncryption,

        [Parameter()]
        [System.Object]
        $RequireSignedSMIMEMessages,

        [Parameter()]
        [System.Object]
        $AllowStorageCard,

        [Parameter()]
        [System.Object]
        $AllowIrDA,

        [Parameter()]
        [System.Object]
        $PasswordHistory,

        [Parameter()]
        [System.Object]
        $AllowNonProvisionableDevices,

        [Parameter()]
        [System.Object]
        $UnapprovedInROMApplicationList,

        [Parameter()]
        [System.Object]
        $RequireEncryptedSMIMEMessages,

        [Parameter()]
        [System.Object]
        $AllowInternetSharing,

        [Parameter()]
        [System.Object]
        $PasswordEnabled,

        [Parameter()]
        [System.Object]
        $MaxEmailHTMLBodyTruncationSize,

        [Parameter()]
        [System.Object]
        $MinPasswordComplexCharacters,

        [Parameter()]
        [System.Object]
        $UNCAccessEnabled,

        [Parameter()]
        [System.Object]
        $AllowCamera,

        [Parameter()]
        [System.Object]
        $IrmEnabled,

        [Parameter()]
        [System.Object]
        $PasswordExpiration,

        [Parameter()]
        [System.Object]
        $AllowBrowser,

        [Parameter()]
        [System.Object]
        $MaxEmailAgeFilter,

        [Parameter()]
        [System.Object]
        $RequireSignedSMIMEAlgorithm,

        [Parameter()]
        [System.Object]
        $RequireManualSyncWhenRoaming,

        [Parameter()]
        [System.Object]
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
        [System.Object]
        $AllowGooglePushNotifications,

        [Parameter()]
        [System.Object]
        $AllowMobileOTAUpdate,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $MaxAttachmentSize,

        [Parameter()]
        [System.Object]
        $AllowSimplePassword,

        [Parameter()]
        [System.Object]
        $AllowConsumerEmail,

        [Parameter()]
        [System.Object]
        $AllowDesktopSync,

        [Parameter()]
        [System.Object]
        $RequireStorageCardEncryption,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $AttachmentsEnabled,

        [Parameter()]
        [System.Object]
        $AllowSMIMESoftCerts,

        [Parameter()]
        [System.Object]
        $AllowRemoteDesktop,

        [Parameter()]
        [System.Object]
        $PasswordRecoveryEnabled,

        [Parameter()]
        [System.Object]
        $MaxCalendarAgeFilter,

        [Parameter()]
        [System.Object]
        $AllowApplePushNotifications,

        [Parameter()]
        [System.Object]
        $AllowPOPIMAPEmail,

        [Parameter()]
        [System.Object]
        $IsDefault,

        [Parameter()]
        [System.Object]
        $MaxInactivityTimeLock,

        [Parameter()]
        [System.Object]
        $AllowWiFi,

        [Parameter()]
        [System.Object]
        $ApprovedApplicationList,

        [Parameter()]
        [System.Object]
        $AllowTextMessaging,

        [Parameter()]
        [System.Object]
        $WSSAccessEnabled,

        [Parameter()]
        [System.Object]
        $DeviceEncryptionEnabled,

        [Parameter()]
        [System.Object]
        $MinPasswordLength,

        [Parameter()]
        [System.Object]
        $AllowHTMLEmail,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-OMEConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $IntroductionText,

        [Parameter()]
        [System.Object]
        $ExternalMailExpiryInDays,

        [Parameter()]
        [System.Object]
        $ReadButtonText,

        [Parameter()]
        [System.Object]
        $PortalText,

        [Parameter()]
        [System.Object]
        $Image,

        [Parameter()]
        [System.Object]
        $OTPEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $BackgroundColor,

        [Parameter()]
        [System.Object]
        $DisclaimerText,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $PrivacyStatementUrl,

        [Parameter()]
        [System.Object]
        $SocialIdSignIn,

        [Parameter()]
        [System.Object]
        $EmailText,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $OutboundConnector,

        [Parameter()]
        [System.Object]
        $OrganizationName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $OrganizationGuid,

        [Parameter()]
        [System.Object]
        $OrganizationRelationship,

        [Parameter()]
        [System.Object]
        $HybridDomains,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-OrganizationRelationship
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $TargetApplicationUri,

        [Parameter()]
        [System.Object]
        $MailTipsAccessLevel,

        [Parameter()]
        [System.Object]
        $TargetAutodiscoverEpr,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $DeliveryReportEnabled,

        [Parameter()]
        [System.Object]
        $OAuthApplicationId,

        [Parameter()]
        [System.Object]
        $OrganizationContact,

        [Parameter()]
        [System.Object]
        $ArchiveAccessEnabled,

        [Parameter()]
        [System.Object]
        $FreeBusyAccessEnabled,

        [Parameter()]
        [System.Object]
        $MailTipsAccessScope,

        [Parameter()]
        [System.Object]
        $TargetOwaURL,

        [Parameter()]
        [System.Object]
        $MailTipsAccessEnabled,

        [Parameter()]
        [System.Object]
        $PhotosEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $MailboxMovePublishedScopes,

        [Parameter()]
        [System.Object]
        $MailboxMoveEnabled,

        [Parameter()]
        [System.Object]
        $MailboxMoveCapability,

        [Parameter()]
        [System.Object]
        $TargetSharingEpr,

        [Parameter()]
        [System.Object]
        $FreeBusyAccessLevel,

        [Parameter()]
        [System.Object]
        $DomainNames,

        [Parameter()]
        [System.Object]
        $FreeBusyAccessScope,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-OutboundConnector
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $RouteAllMessagesViaOnPremises,

        [Parameter()]
        [System.Object]
        $RecipientDomains,

        [Parameter()]
        [System.Object]
        $CloudServicesMailEnabled,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Object]
        $LinkForModifiedConnector,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $TestMode,

        [Parameter()]
        [System.Object]
        $AllAcceptedDomains,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $IsTransportRuleScoped,

        [Parameter()]
        [System.Object]
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
        [System.Object]
        $SenderRewritingEnabled,

        [Parameter()]
        [System.Object]
        $TlsDomain,

        [Parameter()]
        [System.Object]
        $ConnectorSource,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-OwaMailboxPolicy
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
        $IsDefault,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-PartnerApplication
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $ApplicationIdentifier,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $LinkedAccount,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $AcceptSecurityIdentifierInformation,

        [Parameter()]
        [System.Object]
        $AccountType,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-PolicyTipConfig
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $Value,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        [System.Object]
        $AdminDisplayName,

        [Parameter()]
        [System.Object]
        $EndUserSpamNotificationFrequencyInDays,

        [Parameter()]
        [System.Object]
        $CustomDisclaimer,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $EndUserQuarantinePermissionsValue,

        [Parameter()]
        [System.Object]
        $ESNEnabled,

        [Parameter()]
        [System.Object]
        $EndUserQuarantinePermissions,

        [Parameter()]
        [System.Object]
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
        [System.Object]
        $QuarantineRetentionDays,

        [Parameter()]
        [System.Object]
        $OrganizationBrandingEnabled,

        [Parameter()]
        [System.Object]
        $AdminNotificationFrequencyInDays,

        [Parameter()]
        [System.Object]
        $QuarantinePolicyType,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-RemoteDomain
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
        $DomainName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-RoleAssignmentPolicy
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
        $Roles,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsDefault,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-SafeAttachmentPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Redirect,

        [Parameter()]
        [System.Object]
        $RecommendedPolicyType,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $AdminDisplayName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $MakeBuiltInProtection,

        [Parameter()]
        [System.Object]
        $Enable,

        [Parameter()]
        [System.Object]
        $RedirectAddress,

        [Parameter()]
        [System.Object]
        $Action,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $QuarantineTag,

        [Parameter()]
        [System.Object]
        $ActionOnError,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-SafeAttachmentRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Priority,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $SentToMemberOf,

        [Parameter()]
        [System.Object]
        $SentTo,

        [Parameter()]
        [System.Object]
        $Comments,

        [Parameter()]
        [System.Object]
        $RecipientDomainIs,

        [Parameter()]
        [System.Object]
        $SafeAttachmentPolicy,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.Object]
        $ExceptIfSentTo,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $ExceptIfSentToMemberOf,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-SafeLinksPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $EnableOrganizationBranding,

        [Parameter()]
        [System.Object]
        $AdminDisplayName,

        [Parameter()]
        [System.Object]
        $UseTranslatedNotificationText,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $MakeBuiltInProtection,

        [Parameter()]
        [System.Object]
        $DoNotRewriteUrls,

        [Parameter()]
        [System.Object]
        $EnableSafeLinksForTeams,

        [Parameter()]
        [System.Object]
        $DisableUrlRewrite,

        [Parameter()]
        [System.Object]
        $TrackClicks,

        [Parameter()]
        [System.Object]
        $AllowClickThrough,

        [Parameter()]
        [System.Object]
        $RecommendedPolicyType,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $CustomNotificationText,

        [Parameter()]
        [System.Object]
        $DeliverMessageAfterScan,

        [Parameter()]
        [System.Object]
        $EnableSafeLinksForEmail,

        [Parameter()]
        [System.Object]
        $ScanUrls,

        [Parameter()]
        [System.Object]
        $EnableForInternalSenders,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-SafeLinksRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Priority,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $SentToMemberOf,

        [Parameter()]
        [System.Object]
        $SentTo,

        [Parameter()]
        [System.Object]
        $Comments,

        [Parameter()]
        [System.Object]
        $RecipientDomainIs,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.Object]
        $SafeLinksPolicy,

        [Parameter()]
        [System.Object]
        $ExceptIfSentTo,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $ExceptIfSentToMemberOf,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-SharingPolicy
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
        $Domains,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Default,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        [System.Object]
        $AddToRecipients,

        [Parameter()]
        [System.Object]
        $ApplyHtmlDisclaimerFallbackAction,

        [Parameter()]
        [System.Object]
        $RemoveRMSAttachmentEncryption,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientADAttributeContainsWords,

        [Parameter()]
        [System.Object]
        $RecipientADAttributeMatchesPatterns,

        [Parameter()]
        [System.Object]
        $AttachmentSizeOver,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderADAttributeContainsWords,

        [Parameter()]
        [System.Object]
        $SetSCL,

        [Parameter()]
        [System.Object]
        $AnyOfToHeaderMemberOf,

        [Parameter()]
        [System.Object]
        $Disconnect,

        [Parameter()]
        [System.Object]
        $ExceptIfSentToMemberOf,

        [Parameter()]
        [System.Object]
        $ExceptIfAnyOfCcHeader,

        [Parameter()]
        [System.Object]
        $ExceptIfAttachmentMatchesPatterns,

        [Parameter()]
        [System.Object]
        $RecipientDomainIs,

        [Parameter()]
        [System.Object]
        $ManagerForEvaluatedUser,

        [Parameter()]
        [System.Object]
        $SmtpRejectMessageRejectStatusCode,

        [Parameter()]
        [System.Object]
        $ExceptIfHeaderMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfFromScope,

        [Parameter()]
        [System.Object]
        $ADComparisonAttribute,

        [Parameter()]
        [System.Object]
        $ExceptIfAttachmentContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfHeaderContainsWords,

        [Parameter()]
        [System.Object]
        $HeaderMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfAttachmentIsPasswordProtected,

        [Parameter()]
        [System.Object]
        $DeleteMessage,

        [Parameter()]
        [System.Object]
        $HasSenderOverride,

        [Parameter()]
        [System.Object]
        $ExceptIfSubjectOrBodyMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfHasClassification,

        [Parameter()]
        [System.Object]
        $Quarantine,

        [Parameter()]
        [System.Object]
        $ExceptIfAnyOfRecipientAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $RecipientAddressType,

        [Parameter()]
        [System.Object]
        $ExceptIfContentCharacterSetContainsWords,

        [Parameter()]
        [System.Object]
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
        [System.Object]
        $ExceptIfMessageContainsDataClassifications,

        [Parameter()]
        [System.Object]
        $ModerateMessageByUser,

        [Parameter()]
        [System.Object]
        $HasNoClassification,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderInRecipientList,

        [Parameter()]
        [System.Object]
        $HeaderContainsMessageHeader,

        [Parameter()]
        [System.Object]
        $RemoveHeader,

        [Parameter()]
        [System.Object]
        $HasClassification,

        [Parameter()]
        [System.Object]
        $MessageContainsDataClassifications,

        [Parameter()]
        [System.Object]
        $ExceptIfFromMemberOf,

        [Parameter()]
        [System.Object]
        $RuleSubType,

        [Parameter()]
        [System.Object]
        $SentToScope,

        [Parameter()]
        [System.Object]
        $AnyOfToCcHeaderMemberOf,

        [Parameter()]
        [System.Object]
        $From,

        [Parameter()]
        [System.Object]
        $ExceptIfAnyOfRecipientAddressContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfWithImportance,

        [Parameter()]
        [System.Object]
        $ContentCharacterSetContainsWords,

        [Parameter()]
        [System.Object]
        $SubjectContainsWords,

        [Parameter()]
        [System.Object]
        $RejectMessageEnhancedStatusCode,

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
        $UseLegacyRegex,

        [Parameter()]
        [System.Object]
        $FromMemberOf,

        [Parameter()]
        [System.Object]
        $AttachmentContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfSCLOver,

        [Parameter()]
        [System.Object]
        $ExceptIfBetweenMemberOf1,

        [Parameter()]
        [System.Object]
        $GenerateNotification,

        [Parameter()]
        [System.Object]
        $NotifySender,

        [Parameter()]
        [System.Object]
        $ExceptIfAttachmentNameMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderManagementRelationship,

        [Parameter()]
        [System.Object]
        $SetAuditSeverity,

        [Parameter()]
        [System.Object]
        $AttachmentPropertyContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfAnyOfToHeader,

        [Parameter()]
        [System.Object]
        $ApplyRightsProtectionCustomizationTemplate,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
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
        [System.Object]
        $AttachmentNameMatchesPatterns,

        [Parameter()]
        [System.Object]
        $SentTo,

        [Parameter()]
        [System.Object]
        $ExceptIfFromAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Object]
        $ExceptIfAttachmentSizeOver,

        [Parameter()]
        [System.Object]
        $ExceptIfManagerForEvaluatedUser,

        [Parameter()]
        [System.Object]
        $RemoveOMEv2,

        [Parameter()]
        [System.Object]
        $ExceptIfFromAddressContainsWords,

        [Parameter()]
        [System.Object]
        $AttachmentHasExecutableContent,

        [Parameter()]
        [System.Object]
        $RouteMessageOutboundConnector,

        [Parameter()]
        [System.Object]
        $SubjectMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderDomainIs,

        [Parameter()]
        [System.Object]
        $SenderManagementRelationship,

        [Parameter()]
        [System.Object]
        $ExceptIfBetweenMemberOf2,

        [Parameter()]
        [System.Object]
        $RedirectMessageTo,

        [Parameter()]
        [System.Object]
        $ApplyOME,

        [Parameter()]
        [System.Object]
        $AddManagerAsRecipientType,

        [Parameter()]
        [System.Object]
        $ExceptIfMessageSizeOver,

        [Parameter()]
        [System.Object]
        $RecipientInSenderList,

        [Parameter()]
        [System.Object]
        $SenderADAttributeContainsWords,

        [Parameter()]
        [System.Object]
        $MessageSizeOver,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientInSenderList,

        [Parameter()]
        [System.Object]
        $ExceptIfAttachmentHasExecutableContent,

        [Parameter()]
        [System.Object]
        $ExceptIfAttachmentIsUnsupported,

        [Parameter()]
        [System.Object]
        $RemoveOME,

        [Parameter()]
        [System.Object]
        $RejectMessageReasonText,

        [Parameter()]
        [System.Object]
        $RecipientAddressContainsWords,

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
        $ApplyHtmlDisclaimerText,

        [Parameter()]
        [System.Object]
        $RecipientAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfSubjectContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfFrom,

        [Parameter()]
        [System.Object]
        $AnyOfToCcHeader,

        [Parameter()]
        [System.Object]
        $ExceptIfSentToScope,

        [Parameter()]
        [System.Object]
        $ExceptIfAnyOfToCcHeaderMemberOf,

        [Parameter()]
        [System.Object]
        $ModerateMessageByManager,

        [Parameter()]
        [System.Object]
        $ADComparisonOperator,

        [Parameter()]
        [System.Object]
        $BetweenMemberOf2,

        [Parameter()]
        [System.Object]
        $SetHeaderName,

        [Parameter()]
        [System.Object]
        $AttachmentProcessingLimitExceeded,

        [Parameter()]
        [System.Object]
        $ExceptIfAnyOfCcHeaderMemberOf,

        [Parameter()]
        [System.Object]
        $ExceptIfSubjectMatchesPatterns,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientAddressContainsWords,

        [Parameter()]
        [System.Object]
        $HeaderMatchesMessageHeader,

        [Parameter()]
        [System.Object]
        $AnyOfRecipientAddressContainsWords,

        [Parameter()]
        [System.Object]
        $HeaderContainsWords,

        [Parameter()]
        [System.Object]
        $Comments,

        [Parameter()]
        [System.Object]
        $SentToMemberOf,

        [Parameter()]
        [System.Object]
        $ExceptIfADComparisonAttribute,

        [Parameter()]
        [System.Object]
        $ExceptIfSentTo,

        [Parameter()]
        [System.Object]
        $ExceptIfADComparisonOperator,

        [Parameter()]
        [System.Object]
        $ExceptIfAnyOfToHeaderMemberOf,

        [Parameter()]
        [System.Object]
        $Mode,

        [Parameter()]
        [System.Object]
        $ExceptIfAnyOfToCcHeader,

        [Parameter()]
        [System.Object]
        $SubjectOrBodyMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfAttachmentExtensionMatchesWords,

        [Parameter()]
        [System.Object]
        $SenderDomainIs,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfHasNoClassification,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderIpRanges,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientADAttributeMatchesPatterns,

        [Parameter()]
        [System.Object]
        $RecipientADAttributeContainsWords,

        [Parameter()]
        [System.Object]
        $AttachmentIsUnsupported,

        [Parameter()]
        [System.Object]
        $ExpiryDate,

        [Parameter()]
        [System.Object]
        $AttachmentExtensionMatchesWords,

        [Parameter()]
        [System.Object]
        $ExceptIfSubjectOrBodyContainsWords,

        [Parameter()]
        [System.Object]
        $LogEventText,

        [Parameter()]
        [System.Object]
        $ExceptIfManagerAddresses,

        [Parameter()]
        [System.Object]
        $SenderInRecipientList,

        [Parameter()]
        [System.Object]
        $AttachmentMatchesPatterns,

        [Parameter()]
        [System.Object]
        $DlpPolicy,

        [Parameter()]
        [System.Object]
        $ManagerAddresses,

        [Parameter()]
        [System.Object]
        $SenderAddressLocation,

        [Parameter()]
        [System.Object]
        $CopyTo,

        [Parameter()]
        [System.Object]
        $SubjectOrBodyContainsWords,

        [Parameter()]
        [System.Object]
        $ApplyClassification,

        [Parameter()]
        [System.Object]
        $SetHeaderValue,

        [Parameter()]
        [System.Object]
        $Priority,

        [Parameter()]
        [System.Object]
        $AttachmentIsPasswordProtected,

        [Parameter()]
        [System.Object]
        $BetweenMemberOf1,

        [Parameter()]
        [System.Object]
        $AnyOfCcHeader,

        [Parameter()]
        [System.Object]
        $ExceptIfAttachmentProcessingLimitExceeded,

        [Parameter()]
        [System.Object]
        $FromAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfHeaderMatchesMessageHeader,

        [Parameter()]
        [System.Object]
        $SmtpRejectMessageRejectText,

        [Parameter()]
        [System.Object]
        $AnyOfCcHeaderMemberOf,

        [Parameter()]
        [System.Object]
        $AnyOfToHeader,

        [Parameter()]
        [System.Object]
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
        [System.Object]
        $ExceptIfAttachmentPropertyContainsWords,

        [Parameter()]
        [System.Object]
        $StopRuleProcessing,

        [Parameter()]
        [System.Object]
        $ExceptIfHeaderContainsMessageHeader,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-AntiPhishPolicy
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
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $PrivateCatalog,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

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
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $BypassSecurityGroupManagerCheck,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-Mailbox
{
    [CmdletBinding()]
    param(
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
        $Migration,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-ManagementRole
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
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Recurse,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-ManagementRoleAssignment
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
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-MobileDeviceMailboxPolicy
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
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-OwaMailboxPolicy
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
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $DomainController,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-SafeAttachmentPolicy
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
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Remove-SafeLinksPolicy
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
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-AcceptedDomain
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $OutboundOnly,

        [Parameter()]
        [System.Object]
        $EnableNego2Authentication,

        [Parameter()]
        [System.Object]
        $CanHaveCloudCache,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $DomainType,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $MatchSubDomains,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $AccessLevel,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-AdminAuditLogConfig
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $UnifiedAuditLogIngestionEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-AntiPhishPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $EnableFirstContactSafetyTips,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $MakeDefault,

        [Parameter()]
        [System.Object]
        $PhishThresholdLevel,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $EnableTargetedDomainsProtection,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Object]
        $EnableViaTag,

        [Parameter()]
        [System.Object]
        $MailboxIntelligenceProtectionAction,

        [Parameter()]
        [System.Object]
        $TargetedDomainsToProtect,

        [Parameter()]
        [System.Object]
        $TargetedUsersToProtect,

        [Parameter()]
        [System.Object]
        $EnableSpoofIntelligence,

        [Parameter()]
        [System.Object]
        $EnableSimilarUsersSafetyTips,

        [Parameter()]
        [System.Object]
        $ExcludedDomains,

        [Parameter()]
        [System.Object]
        $PolicyTag,

        [Parameter()]
        [System.Object]
        $TargetedDomainActionRecipients,

        [Parameter()]
        [System.Object]
        $EnableMailboxIntelligence,

        [Parameter()]
        [System.Object]
        $TargetedUserQuarantineTag,

        [Parameter()]
        [System.Object]
        $TargetedDomainQuarantineTag,

        [Parameter()]
        [System.Object]
        $ImpersonationProtectionState,

        [Parameter()]
        [System.Object]
        $TargetedDomainProtectionAction,

        [Parameter()]
        [System.Object]
        $AdminDisplayName,

        [Parameter()]
        [System.Object]
        $AuthenticationFailAction,

        [Parameter()]
        [System.Object]
        $TargetedUserProtectionAction,

        [Parameter()]
        [System.Object]
        $MailboxIntelligenceProtectionActionRecipients,

        [Parameter()]
        [System.Object]
        $MailboxIntelligenceQuarantineTag,

        [Parameter()]
        [System.Object]
        $EnableSimilarDomainsSafetyTips,

        [Parameter()]
        [System.Object]
        $SpoofQuarantineTag,

        [Parameter()]
        [System.Object]
        $EnableUnauthenticatedSender,

        [Parameter()]
        [System.Object]
        $EnableTargetedUserProtection,

        [Parameter()]
        [System.Object]
        $EnableOrganizationDomainsProtection,

        [Parameter()]
        [System.Object]
        $EnableUnusualCharactersSafetyTips,

        [Parameter()]
        [System.Object]
        $EnableMailboxIntelligenceProtection,

        [Parameter()]
        [System.Object]
        $TargetedUserActionRecipients,

        [Parameter()]
        [System.Object]
        $ExcludedSenders,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-AntiPhishRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Priority,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $SentToMemberOf,

        [Parameter()]
        [System.Object]
        $AntiPhishPolicy,

        [Parameter()]
        [System.Object]
        $SentTo,

        [Parameter()]
        [System.Object]
        $Comments,

        [Parameter()]
        [System.Object]
        $RecipientDomainIs,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.Object]
        $ExceptIfSentTo,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $ExceptIfSentToMemberOf,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $DefaultStateForUser,

        [Parameter()]
        [System.Object]
        $UserList,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $OrganizationApp,

        [Parameter()]
        [System.Object]
        $ProvidedTo,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PrivateCatalog,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-ApplicationAccessPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Description,

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
function Set-AtpPolicyForO365
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $BlockUrls,

        [Parameter()]
        [System.Object]
        $EnableATPForSPOTeamsODB,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $EnableSafeDocs,

        [Parameter()]
        [System.Object]
        $AllowSafeDocsOpen,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-AuthenticationPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowBasicAuthRpc,

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
        $AllowBasicAuthActiveSync,

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
        $AllowBasicAuthWebServices,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $OrgWideAccount,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-CASMailbox
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $IsOptimizedForAccessibility,

        [Parameter()]
        [System.Object]
        $ImapEnabled,

        [Parameter()]
        [System.Object]
        $ImapSuppressReadReceipt,

        [Parameter()]
        [System.Object]
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
        [System.Object]
        $PopUseProtocolDefaults,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $SmtpClientAuthenticationDisabled,

        [Parameter()]
        [System.Object]
        $PopForceICalForCalendarRetrievalOption,

        [Parameter()]
        [System.Object]
        $ImapForceICalForCalendarRetrievalOption,

        [Parameter()]
        [System.Object]
        $ShowGalAsDefaultView,

        [Parameter()]
        [System.Object]
        $OutlookMobileEnabled,

        [Parameter()]
        [System.Object]
        $ActiveSyncBlockedDeviceIDs,

        [Parameter()]
        [System.Object]
        $MAPIEnabled,

        [Parameter()]
        [System.Object]
        $EwsAllowOutlook,

        [Parameter()]
        [System.Object]
        $PopEnabled,

        [Parameter()]
        [System.Object]
        $ActiveSyncAllowedDeviceIDs,

        [Parameter()]
        [System.Object]
        $EwsEnabled,

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
        [System.Object]
        $PublicFolderClientAccess,

        [Parameter()]
        [System.Object]
        $OWAEnabled,

        [Parameter()]
        [System.Object]
        $ActiveSyncEnabled,

        [Parameter()]
        [System.Object]
        $ActiveSyncMailboxPolicy,

        [Parameter()]
        [System.Object]
        $UniversalOutlookEnabled,

        [Parameter()]
        [System.Object]
        $ImapUseProtocolDefaults,

        [Parameter()]
        [System.Object]
        $ActiveSyncDebugLogging,

        [Parameter()]
        [System.Object]
        $OWAforDevicesEnabled,

        [Parameter()]
        [System.Object]
        $ImapMessagesRetrievalMimeFormat,

        [Parameter()]
        [System.Object]
        $MacOutlookEnabled,

        [Parameter()]
        [System.Object]
        $PopSuppressReadReceipt,

        [Parameter()]
        [System.Object]
        $EwsAllowList,

        [Parameter()]
        [System.Object]
        $PopMessagesRetrievalMimeFormat,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function set-CASMailboxPlan
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $ImapEnabled,

        [Parameter()]
        [System.Object]
        $OwaMailboxPolicy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $PopEnabled,

        [Parameter()]
        [System.Object]
        $ActiveSyncEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Object]
        $ExceptAnyOfClientIPAddressesOrRanges,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $UserRecipientFilter,

        [Parameter()]
        [System.Object]
        $ExceptAnyOfProtocols,

        [Parameter()]
        [System.Object]
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
        $Scope,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-DataClassification
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
        $Locale,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Fingerprints,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsDefault,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-DataEncryptionPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $PermanentDataPurgeContact,

        [Parameter()]
        [System.Object]
        $Description,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $Name,

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
        [System.Management.Automation.SwitchParameter]
        $Refresh,

        [Parameter()]
        [System.Object]
        $PermanentDataPurgeReason,

        [Parameter()]
        [System.Object]
        $DomainController,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        [System.Object]
        $ModerationEnabled,

        [Parameter()]
        [System.Object]
        $AcceptMessagesOnlyFromSendersOrMembers,

        [Parameter()]
        [System.Object]
        $ExtensionCustomAttribute5,

        [Parameter()]
        [System.Object]
        $CustomAttribute8,

        [Parameter()]
        [System.Object]
        $CustomAttribute5,

        [Parameter()]
        [System.Object]
        $BccBlocked,

        [Parameter()]
        [System.Object]
        $SimpleDisplayName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IgnoreNamingPolicy,

        [Parameter()]
        [System.Object]
        $ReportToManagerEnabled,

        [Parameter()]
        [System.Object]
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
        [System.Object]
        $BypassNestedModerationEnabled,

        [Parameter()]
        [System.Object]
        $MemberDepartRestriction,

        [Parameter()]
        [System.Object]
        $ExtensionCustomAttribute4,

        [Parameter()]
        [System.Object]
        $CustomAttribute15,

        [Parameter()]
        [System.Object]
        $RejectMessagesFromSendersOrMembers,

        [Parameter()]
        [System.Object]
        $WindowsEmailAddress,

        [Parameter()]
        [System.Object]
        $RejectMessagesFrom,

        [Parameter()]
        [System.Object]
        $Alias,

        [Parameter()]
        [System.Object]
        $DisplayName,

        [Parameter()]
        [System.Object]
        $ReportToOriginatorEnabled,

        [Parameter()]
        [System.Object]
        $BypassModerationFromSendersOrMembers,

        [Parameter()]
        [System.Object]
        $AcceptMessagesOnlyFromDLMembers,

        [Parameter()]
        [System.Object]
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
        [System.Object]
        $CustomAttribute14,

        [Parameter()]
        [System.Object]
        $RequireSenderAuthenticationEnabled,

        [Parameter()]
        [System.Object]
        $CustomAttribute9,

        [Parameter()]
        [System.Object]
        $CustomAttribute6,

        [Parameter()]
        [System.Object]
        $SendOofMessageToOriginatorEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $BypassSecurityGroupManagerCheck,

        [Parameter()]
        [System.Object]
        $CustomAttribute7,

        [Parameter()]
        [System.Object]
        $ExtensionCustomAttribute2,

        [Parameter()]
        [System.Object]
        $CustomAttribute13,

        [Parameter()]
        [System.Object]
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
        [System.Object]
        $MailTipTranslations,

        [Parameter()]
        [System.Object]
        $CustomAttribute4,

        [Parameter()]
        [System.Object]
        $CustomAttribute10,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $ExtensionCustomAttribute3,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RoomList,

        [Parameter()]
        [System.Object]
        $CustomAttribute12,

        [Parameter()]
        [System.Object]
        $CustomAttribute3,

        [Parameter()]
        [System.Object]
        $CustomAttribute11,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $HiddenFromAddressListsEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-DkimSigningConfig
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $AdminDisplayName,

        [Parameter()]
        [System.Object]
        $BodyCanonicalization,

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
        [System.Object]
        $HeaderCanonicalization,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        [System.Object]
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
        [System.Object]
        $EnabledPrimarySMTPAddressTemplate,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-HostedConnectionFilterPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $ConfigurationXmlRaw,

        [Parameter()]
        [System.Object]
        $AdminDisplayName,

        [Parameter()]
        [System.Object]
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
        $MakeDefault,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        [System.Object]
        $InlineSafetyTipsEnabled,

        [Parameter()]
        [System.Object]
        $RegionBlockList,

        [Parameter()]
        [System.Object]
        $MarkAsSpamFromAddressAuthFail,

        [Parameter()]
        [System.Object]
        $HighConfidencePhishQuarantineTag,

        [Parameter()]
        [System.Object]
        $EndUserSpamNotificationFrequency,

        [Parameter()]
        [System.Object]
        $EndUserSpamNotificationLimit,

        [Parameter()]
        [System.Object]
        $BulkThreshold,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $MakeDefault,

        [Parameter()]
        [System.Object]
        $PhishQuarantineTag,

        [Parameter()]
        [System.Object]
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
        [System.Object]
        $EnableLanguageBlockList,

        [Parameter()]
        [System.Object]
        $PhishSpamAction,

        [Parameter()]
        [System.Object]
        $EndUserSpamNotificationCustomFromName,

        [Parameter()]
        [System.Object]
        $MarkAsSpamSensitiveWordList,

        [Parameter()]
        [System.Object]
        $SpamQuarantineTag,

        [Parameter()]
        [System.Object]
        $SpamZapEnabled,

        [Parameter()]
        [System.Object]
        $BlockedSenders,

        [Parameter()]
        [System.Object]
        $HighConfidenceSpamAction,

        [Parameter()]
        [System.Object]
        $AllowedSenderDomains,

        [Parameter()]
        [System.Object]
        $IncreaseScoreWithBizOrInfoUrls,

        [Parameter()]
        [System.Object]
        $MarkAsSpamWebBugsInHtml,

        [Parameter()]
        [System.Object]
        $AdminDisplayName,

        [Parameter()]
        [System.Object]
        $MarkAsSpamJavaScriptInHtml,

        [Parameter()]
        [System.Object]
        $MarkAsSpamEmptyMessages,

        [Parameter()]
        [System.Object]
        $LanguageBlockList,

        [Parameter()]
        [System.Object]
        $MarkAsSpamNdrBackscatter,

        [Parameter()]
        [System.Object]
        $BulkQuarantineTag,

        [Parameter()]
        [System.Object]
        $MarkAsSpamFormTagsInHtml,

        [Parameter()]
        [System.Object]
        $MarkAsSpamObjectTagsInHtml,

        [Parameter()]
        [System.Object]
        $BulkSpamAction,

        [Parameter()]
        [System.Object]
        $EndUserSpamNotificationLanguage,

        [Parameter()]
        [System.Object]
        $IncreaseScoreWithRedirectToOtherPort,

        [Parameter()]
        [System.Object]
        $QuarantineRetentionPeriod,

        [Parameter()]
        [System.Object]
        $HighConfidencePhishAction,

        [Parameter()]
        [System.Object]
        $RedirectToRecipients,

        [Parameter()]
        [System.Object]
        $TestModeAction,

        [Parameter()]
        [System.Object]
        $EnableRegionBlockList,

        [Parameter()]
        [System.Object]
        $EndUserSpamNotificationCustomSubject,

        [Parameter()]
        [System.Object]
        $MarkAsSpamSpfRecordHardFail,

        [Parameter()]
        [System.Object]
        $EndUserSpamNotificationCustomFromAddress,

        [Parameter()]
        [System.Object]
        $DownloadLink,

        [Parameter()]
        [System.Object]
        $SpamAction,

        [Parameter()]
        [System.Object]
        $ModifySubjectValue,

        [Parameter()]
        [System.Object]
        $IncreaseScoreWithNumericIps,

        [Parameter()]
        [System.Object]
        $AllowedSenders,

        [Parameter()]
        [System.Object]
        $TestModeBccToRecipients,

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
        [System.Object]
        $PhishZapEnabled,

        [Parameter()]
        [System.Object]
        $EnableEndUserSpamNotifications,

        [Parameter()]
        [System.Object]
        $HighConfidenceSpamQuarantineTag,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-HostedContentFilterRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Priority,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $SentToMemberOf,

        [Parameter()]
        [System.Object]
        $HostedContentFilterPolicy,

        [Parameter()]
        [System.Object]
        $SentTo,

        [Parameter()]
        [System.Object]
        $Comments,

        [Parameter()]
        [System.Object]
        $RecipientDomainIs,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.Object]
        $ExceptIfSentTo,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $ExceptIfSentToMemberOf,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-HostedOutboundSpamFilterPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $AdminDisplayName,

        [Parameter()]
        [System.Object]
        $BccSuspiciousOutboundAdditionalRecipients,

        [Parameter()]
        [System.Object]
        $NotifyOutboundSpamRecipients,

        [Parameter()]
        [System.Object]
        $RecipientLimitInternalPerHour,

        [Parameter()]
        [System.Object]
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
        [System.Object]
        $AutoForwardingMode,

        [Parameter()]
        [System.Object]
        $NotifyOutboundSpam,

        [Parameter()]
        [System.Object]
        $BccSuspiciousOutboundMail,

        [Parameter()]
        [System.Object]
        $RecipientLimitExternalPerHour,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-HostedOutboundSpamFilterRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Priority,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $ExceptIfFrom,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderDomainIs,

        [Parameter()]
        [System.Object]
        $Comments,

        [Parameter()]
        [System.Object]
        $FromMemberOf,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $SenderDomainIs,

        [Parameter()]
        [System.Object]
        $HostedOutboundSpamFilterPolicy,

        [Parameter()]
        [System.Object]
        $ExceptIfFromMemberOf,

        [Parameter()]
        [System.Object]
        $From,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-InboundConnector
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $RestrictDomainsToIPAddresses,

        [Parameter()]
        [System.Object]
        $CloudServicesMailEnabled,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $EFTestMode,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Object]
        $EFSkipMailGateway,

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
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $RequireTls,

        [Parameter()]
        [System.Object]
        $SenderDomains,

        [Parameter()]
        [System.Object]
        $SenderIPAddresses,

        [Parameter()]
        [System.Object]
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
        [System.Object]
        $RestrictDomainsToCertificate,

        [Parameter()]
        [System.Object]
        $EFSkipIPs,

        [Parameter()]
        [System.Object]
        $TreatMessagesAsInternal,

        [Parameter()]
        [System.Object]
        $ConnectorSource,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        [System.Object]
        $DiscoveryEndpoint,

        [Parameter()]
        [System.Object]
        $TargetSharingEpr,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $RMSOnlineKeySharingLocation,

        [Parameter()]
        [System.Object]
        $SimplifiedClientAccessDoNotForwardDisabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $AzureRMSLicensingEnabled,

        [Parameter()]
        [System.Object]
        $EnablePortalTrackingLogs,

        [Parameter()]
        [System.Object]
        $DecryptAttachmentForEncryptOnly,

        [Parameter()]
        [System.Object]
        $RejectIfRecipientHasNoRights,

        [Parameter()]
        [System.Object]
        $InternalLicensingEnabled,

        [Parameter()]
        [System.Object]
        $EDiscoverySuperUserEnabled,

        [Parameter()]
        [System.Object]
        $JournalReportDecryptionEnabled,

        [Parameter()]
        [System.Object]
        $EnablePdfEncryption,

        [Parameter()]
        [System.Object]
        $AutomaticServiceUpdateEnabled,

        [Parameter()]
        [System.Object]
        $SimplifiedClientAccessEncryptOnlyDisabled,

        [Parameter()]
        [System.Object]
        $SearchEnabled,

        [Parameter()]
        [System.Object]
        $LicensingLocation,

        [Parameter()]
        [System.Object]
        $SimplifiedClientAccessEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-JournalRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Scope,

        [Parameter()]
        [System.Object]
        $Name,

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
        $Recipient,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $AuditOwner,

        [Parameter()]
        [System.Object]
        $AcceptMessagesOnlyFromSendersOrMembers,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $GroupMailbox,

        [Parameter()]
        [System.Object]
        $UserCertificate,

        [Parameter()]
        [System.Object]
        $CustomAttribute12,

        [Parameter()]
        [System.Object]
        $CustomAttribute10,

        [Parameter()]
        [System.Object]
        $DeliverToMailboxAndForward,

        [Parameter()]
        [System.Object]
        $RetentionUrl,

        [Parameter()]
        [System.Object]
        $ExtensionCustomAttribute5,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RecalculateInactiveMailbox,

        [Parameter()]
        [System.Object]
        $CustomAttribute8,

        [Parameter()]
        [System.Object]
        $PitrEnabled,

        [Parameter()]
        [System.Object]
        $ProhibitSendReceiveQuota,

        [Parameter()]
        [System.Object]
        $CustomAttribute5,

        [Parameter()]
        [System.Object]
        $RoomMailboxPassword,

        [Parameter()]
        [System.Object]
        $SimpleDisplayName,

        [Parameter()]
        [System.Object]
        $ElcProcessingDisabled,

        [Parameter()]
        [System.Object]
        $ExcludeFromOrgHolds,

        [Parameter()]
        [System.Object]
        $Type,

        [Parameter()]
        [System.Object]
        $MailTip,

        [Parameter()]
        [System.Object]
        $IssueWarningQuota,

        [Parameter()]
        [System.Object]
        $ModeratedBy,

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
        [System.Object]
        $SingleItemRecoveryEnabled,

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
        [System.Object]
        $ModerationEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $InactiveMailbox,

        [Parameter()]
        [System.Object]
        $RetentionComment,

        [Parameter()]
        [System.Object]
        $MaxReceiveSize,

        [Parameter()]
        [System.Object]
        $MessageCopyForSendOnBehalfEnabled,

        [Parameter()]
        [System.Object]
        $CustomAttribute15,

        [Parameter()]
        [System.Object]
        $LitigationHoldEnabled,

        [Parameter()]
        [System.Object]
        $PitrCopyIntervalInSeconds,

        [Parameter()]
        [System.Object]
        $ImmutableId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PublicFolder,

        [Parameter()]
        [System.Object]
        $UseDatabaseRetentionDefaults,

        [Parameter()]
        [System.Object]
        $SchedulerAssistant,

        [Parameter()]
        [System.Object]
        $RemoveOrphanedHolds,

        [Parameter()]
        [System.Object]
        $RejectMessagesFrom,

        [Parameter()]
        [System.Object]
        $RulesQuota,

        [Parameter()]
        [System.Object]
        $Alias,

        [Parameter()]
        [System.Object]
        $EnforcedTimestamps,

        [Parameter()]
        [System.Object]
        $RejectMessagesFromSendersOrMembers,

        [Parameter()]
        [System.Object]
        $DisplayName,

        [Parameter()]
        [System.Object]
        $ResourceCustom,

        [Parameter()]
        [System.Object]
        $MessageCopyForSMTPClientSubmissionEnabled,

        [Parameter()]
        [System.Object]
        $DefaultPublicFolderMailbox,

        [Parameter()]
        [System.Object]
        $BypassModerationFromSendersOrMembers,

        [Parameter()]
        [System.Object]
        $ProhibitSendQuota,

        [Parameter()]
        [System.Object]
        $DefaultAuditSet,

        [Parameter()]
        [System.Object]
        $AcceptMessagesOnlyFromDLMembers,

        [Parameter()]
        [System.Object]
        $WindowsEmailAddress,

        [Parameter()]
        [System.Object]
        $CustomAttribute1,

        [Parameter()]
        [System.Object]
        $CalendarRepairDisabled,

        [Parameter()]
        [System.Object]
        $StsRefreshTokensValidFrom,

        [Parameter()]
        [System.Object]
        $UseDatabaseQuotaDefaults,

        [Parameter()]
        [System.Object]
        $AddressBookPolicy,

        [Parameter()]
        [System.Object]
        $MailboxRegion,

        [Parameter()]
        [System.Object]
        $NonCompliantDevices,

        [Parameter()]
        [System.Object]
        $ResourceCapacity,

        [Parameter()]
        [System.Object]
        $LitigationHoldOwner,

        [Parameter()]
        [System.Object]
        $ExtensionCustomAttribute1,

        [Parameter()]
        [System.Object]
        $AccountDisabled,

        [Parameter()]
        [System.Object]
        $AcceptMessagesOnlyFrom,

        [Parameter()]
        [System.Object]
        $AuditDelegate,

        [Parameter()]
        [System.Object]
        $CustomAttribute14,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ApplyMandatoryProperties,

        [Parameter()]
        [System.Object]
        $RequireSenderAuthenticationEnabled,

        [Parameter()]
        [System.Object]
        $CustomAttribute9,

        [Parameter()]
        [System.Object]
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
        [System.Object]
        $EnableRoomMailboxAccount,

        [Parameter()]
        [System.Object]
        $RetentionPolicy,

        [Parameter()]
        [System.Object]
        $RetainDeletedItemsFor,

        [Parameter()]
        [System.Object]
        $MicrosoftOnlineServicesID,

        [Parameter()]
        [System.Object]
        $MessageTrackingReadStatusEnabled,

        [Parameter()]
        [System.Object]
        $AuditAdmin,

        [Parameter()]
        [System.Object]
        $ExtensionCustomAttribute2,

        [Parameter()]
        [System.Object]
        $RetentionHoldEnabled,

        [Parameter()]
        [System.Object]
        $CustomAttribute13,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $CustomAttribute2,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RemoveDelayHoldApplied,

        [Parameter()]
        [System.Object]
        $ExternalOofOptions,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RemoveMailboxProvisioningConstraint,

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
        [System.Object]
        $IsExcludedFromServingHierarchy,

        [Parameter()]
        [System.Object]
        $Office,

        [Parameter()]
        [System.Object]
        $MaxSendSize,

        [Parameter()]
        [System.Object]
        $RecipientLimits,

        [Parameter()]
        [System.Object]
        $MessageCopyForSentAsEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProvisionedForOfficeGraph,

        [Parameter()]
        [System.Object]
        $MailTipTranslations,

        [Parameter()]
        [System.Object]
        $CustomAttribute7,

        [Parameter()]
        [System.Object]
        $SharingPolicy,

        [Parameter()]
        [System.Object]
        $CustomAttribute4,

        [Parameter()]
        [System.Object]
        $CalendarVersionStoreDisabled,

        [Parameter()]
        [System.Object]
        $SecondaryAddress,

        [Parameter()]
        [System.Object]
        $ArchiveName,

        [Parameter()]
        [System.Object]
        $StartDateForRetentionHold,

        [Parameter()]
        [System.Object]
        $AuditEnabled,

        [Parameter()]
        [System.Object]
        $Password,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $ExtensionCustomAttribute3,

        [Parameter()]
        [System.Object]
        $ForwardingAddress,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ExcludeFromAllOrgHolds,

        [Parameter()]
        [System.Object]
        $CustomAttribute3,

        [Parameter()]
        [System.Object]
        $CustomAttribute11,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RemoveDelayReleaseHoldApplied,

        [Parameter()]
        [System.Object]
        $ForwardingSmtpAddress,

        [Parameter()]
        [System.Object]
        $HiddenFromAddressListsEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $UpdateEnforcedTimestamp,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-MailboxPlan
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $RoleAssignmentPolicy,

        [Parameter()]
        [System.Object]
        $IssueWarningQuota,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $MaxSendSize,

        [Parameter()]
        [System.Object]
        $RetentionPolicy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $ProhibitSendQuota,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $RetainDeletedItemsFor,

        [Parameter()]
        [System.Object]
        $ProhibitSendReceiveQuota,

        [Parameter()]
        [System.Object]
        $RecipientLimits,

        [Parameter()]
        [System.Object]
        $MaxReceiveSize,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsDefault,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-MailboxRegionalConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $DateFormat,

        [Parameter()]
        [System.Object]
        $TimeFormat,

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
        [System.Object]
        $Language,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        [System.Object]
        $CustomFromName,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $AdminDisplayName,

        [Parameter()]
        [System.Object]
        $QuarantineTag,

        [Parameter()]
        [System.Object]
        $CustomNotifications,

        [Parameter()]
        [System.Object]
        $EnableExternalSenderAdminNotifications,

        [Parameter()]
        [System.Object]
        $InternalSenderAdminAddress,

        [Parameter()]
        [System.Object]
        $CustomExternalBody,

        [Parameter()]
        [System.Object]
        $FileTypes,

        [Parameter()]
        [System.Object]
        $EnableInternalSenderAdminNotifications,

        [Parameter()]
        [System.Object]
        $CustomFromAddress,

        [Parameter()]
        [System.Object]
        $CustomExternalSubject,

        [Parameter()]
        [System.Object]
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
        [System.Object]
        $CustomInternalSubject,

        [Parameter()]
        [System.Object]
        $CustomInternalBody,

        [Parameter()]
        [System.Object]
        $EnableFileFilter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-MalwareFilterRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Priority,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $SentToMemberOf,

        [Parameter()]
        [System.Object]
        $SentTo,

        [Parameter()]
        [System.Object]
        $Comments,

        [Parameter()]
        [System.Object]
        $RecipientDomainIs,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.Object]
        $MalwareFilterPolicy,

        [Parameter()]
        [System.Object]
        $ExceptIfSentTo,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $ExceptIfSentToMemberOf,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-MessageClassification
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $DisplayName,

        [Parameter()]
        [System.Object]
        $RecipientDescription,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $PermissionMenuVisible,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $ClassificationID,

        [Parameter()]
        [System.Object]
        $SenderDescription,

        [Parameter()]
        [System.Object]
        $DisplayPrecedence,

        [Parameter()]
        [System.Object]
        $RetainClassificationEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-MobileDeviceMailboxPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $AllowMicrosoftPushNotifications,

        [Parameter()]
        [System.Object]
        $AllowUnsignedApplications,

        [Parameter()]
        [System.Object]
        $AllowUnsignedInstallationPackages,

        [Parameter()]
        [System.Object]
        $MaxPasswordFailedAttempts,

        [Parameter()]
        [System.Object]
        $AllowExternalDeviceManagement,

        [Parameter()]
        [System.Object]
        $RequireDeviceEncryption,

        [Parameter()]
        [System.Object]
        $RequireSignedSMIMEMessages,

        [Parameter()]
        [System.Object]
        $AllowStorageCard,

        [Parameter()]
        [System.Object]
        $AllowIrDA,

        [Parameter()]
        [System.Object]
        $PasswordHistory,

        [Parameter()]
        [System.Object]
        $AllowNonProvisionableDevices,

        [Parameter()]
        [System.Object]
        $UnapprovedInROMApplicationList,

        [Parameter()]
        [System.Object]
        $RequireEncryptedSMIMEMessages,

        [Parameter()]
        [System.Object]
        $AllowInternetSharing,

        [Parameter()]
        [System.Object]
        $PasswordEnabled,

        [Parameter()]
        [System.Object]
        $MaxEmailHTMLBodyTruncationSize,

        [Parameter()]
        [System.Object]
        $MinPasswordComplexCharacters,

        [Parameter()]
        [System.Object]
        $UNCAccessEnabled,

        [Parameter()]
        [System.Object]
        $AllowCamera,

        [Parameter()]
        [System.Object]
        $IrmEnabled,

        [Parameter()]
        [System.Object]
        $PasswordExpiration,

        [Parameter()]
        [System.Object]
        $AllowBrowser,

        [Parameter()]
        [System.Object]
        $MaxEmailAgeFilter,

        [Parameter()]
        [System.Object]
        $RequireSignedSMIMEAlgorithm,

        [Parameter()]
        [System.Object]
        $RequireManualSyncWhenRoaming,

        [Parameter()]
        [System.Object]
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
        [System.Object]
        $AllowGooglePushNotifications,

        [Parameter()]
        [System.Object]
        $AllowMobileOTAUpdate,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $MaxAttachmentSize,

        [Parameter()]
        [System.Object]
        $AllowSimplePassword,

        [Parameter()]
        [System.Object]
        $AllowConsumerEmail,

        [Parameter()]
        [System.Object]
        $AllowDesktopSync,

        [Parameter()]
        [System.Object]
        $RequireStorageCardEncryption,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $AttachmentsEnabled,

        [Parameter()]
        [System.Object]
        $AllowSMIMESoftCerts,

        [Parameter()]
        [System.Object]
        $AllowRemoteDesktop,

        [Parameter()]
        [System.Object]
        $PasswordRecoveryEnabled,

        [Parameter()]
        [System.Object]
        $MaxCalendarAgeFilter,

        [Parameter()]
        [System.Object]
        $AllowApplePushNotifications,

        [Parameter()]
        [System.Object]
        $AllowPOPIMAPEmail,

        [Parameter()]
        [System.Object]
        $IsDefault,

        [Parameter()]
        [System.Object]
        $MaxInactivityTimeLock,

        [Parameter()]
        [System.Object]
        $AllowWiFi,

        [Parameter()]
        [System.Object]
        $ApprovedApplicationList,

        [Parameter()]
        [System.Object]
        $AllowTextMessaging,

        [Parameter()]
        [System.Object]
        $WSSAccessEnabled,

        [Parameter()]
        [System.Object]
        $DeviceEncryptionEnabled,

        [Parameter()]
        [System.Object]
        $MinPasswordLength,

        [Parameter()]
        [System.Object]
        $AllowHTMLEmail,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-OMEConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $IntroductionText,

        [Parameter()]
        [System.Object]
        $ExternalMailExpiryInDays,

        [Parameter()]
        [System.Object]
        $ReadButtonText,

        [Parameter()]
        [System.Object]
        $PortalText,

        [Parameter()]
        [System.Object]
        $Image,

        [Parameter()]
        [System.Object]
        $OTPEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $BackgroundColor,

        [Parameter()]
        [System.Object]
        $DisclaimerText,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $PrivacyStatementUrl,

        [Parameter()]
        [System.Object]
        $SocialIdSignIn,

        [Parameter()]
        [System.Object]
        $EmailText,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        [System.Object]
        $OrganizationName,

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
        $OrganizationRelationship,

        [Parameter()]
        [System.Object]
        $HybridDomains,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-Organization
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $UnifiedAuditLogIngestionEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-OrganizationConfig
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $FindTimeLockPollForAttendeesEnabled,

        [Parameter()]
        [System.Object]
        $ConnectorsEnabledForYammer,

        [Parameter()]
        [System.Object]
        $PublicFolderShowClientControl,

        [Parameter()]
        [System.Object]
        $MailTipsGroupMetricsEnabled,

        [Parameter()]
        [System.Object]
        $PublicFoldersEnabled,

        [Parameter()]
        [System.Object]
        $VisibleMeetingUpdateProperties,

        [Parameter()]
        [System.Object]
        $WorkspaceTenantEnabled,

        [Parameter()]
        [System.Object]
        $ReadTrackingEnabled,

        [Parameter()]
        [System.Object]
        $ExchangeNotificationEnabled,

        [Parameter()]
        [System.Object]
        $BookingsNamingPolicyPrefixEnabled,

        [Parameter()]
        [System.Object]
        $MailTipsExternalRecipientsTipsEnabled,

        [Parameter()]
        [System.Object]
        $FocusedInboxOn,

        [Parameter()]
        [System.Object]
        $EwsApplicationAccessPolicy,

        [Parameter()]
        [System.Object]
        $BookingsNamingPolicyPrefix,

        [Parameter()]
        [System.Object]
        $MobileAppEducationEnabled,

        [Parameter()]
        [System.Object]
        $EnableOutlookEvents,

        [Parameter()]
        [System.Object]
        $BookingsExposureOfStaffDetailsRestricted,

        [Parameter()]
        [System.Object]
        $ElcProcessingDisabled,

        [Parameter()]
        [System.Object]
        $UnblockUnsafeSenderPromptEnabled,

        [Parameter()]
        [System.Object]
        $AutoEnableArchiveMailbox,

        [Parameter()]
        [System.Object]
        $RefreshSessionEnabled,

        [Parameter()]
        [System.Object]
        $ActivityBasedAuthenticationTimeoutEnabled,

        [Parameter()]
        [System.Object]
        $SmtpActionableMessagesEnabled,

        [Parameter()]
        [System.Object]
        $ConnectorsEnabledForTeams,

        [Parameter()]
        [System.Object]
        $ComplianceMLBgdCrawlEnabled,

        [Parameter()]
        [System.Object]
        $MailTipsAllTipsEnabled,

        [Parameter()]
        [System.Object]
        $OAuth2ClientProfileEnabled,

        [Parameter()]
        [System.Object]
        $RemotePublicFolderMailboxes,

        [Parameter()]
        [System.Object]
        $BlockMoveMessagesForGroupFolders,

        [Parameter()]
        [System.Object]
        $DefaultMinutesToReduceShortEventsBy,

        [Parameter()]
        [System.Object]
        $EwsAllowEntourage,

        [Parameter()]
        [System.Object]
        $OutlookGifPickerDisabled,

        [Parameter()]
        [System.Object]
        $OnlineMeetingsByDefaultEnabled,

        [Parameter()]
        [System.Object]
        $DefaultPublicFolderProhibitPostQuota,

        [Parameter()]
        [System.Object]
        $ExchangeNotificationRecipients,

        [Parameter()]
        [System.Object]
        $MessageRemindersEnabled,

        [Parameter()]
        [System.Object]
        $DirectReportsGroupAutoCreationEnabled,

        [Parameter()]
        [System.Object]
        $LinkPreviewEnabled,

        [Parameter()]
        [System.Object]
        $BookingsAuthEnabled,

        [Parameter()]
        [System.Object]
        $OutlookMobileGCCRestrictionsEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $BookingsCreationOfCustomQuestionsRestricted,

        [Parameter()]
        [System.Object]
        $BookingsSmsMicrosoftEnabled,

        [Parameter()]
        [System.Object]
        $DefaultGroupAccessType,

        [Parameter()]
        [System.Object]
        $ConnectorsEnabledForOutlook,

        [Parameter()]
        [System.Object]
        $BookingsAddressEntryRestricted,

        [Parameter()]
        [System.Object]
        $DefaultPublicFolderDeletedItemRetention,

        [Parameter()]
        [System.Object]
        $BookingsNotesEntryRestricted,

        [Parameter()]
        [System.Object]
        $ShortenEventScopeDefault,

        [Parameter()]
        [System.Object]
        $AuditDisabled,

        [Parameter()]
        [System.Object]
        $RequiredCharsetCoverage,

        [Parameter()]
        [System.Object]
        $IsAgendaMailEnabled,

        [Parameter()]
        [System.Object]
        $FindTimeOnlineMeetingOptionDisabled,

        [Parameter()]
        [System.Object]
        $EwsEnabled,

        [Parameter()]
        [System.Object]
        $FindTimeAttendeeAuthenticationEnabled,

        [Parameter()]
        [System.Object]
        $OutlookMobileHelpShiftEnabled,

        [Parameter()]
        [System.Object]
        $LeanPopoutEnabled,

        [Parameter()]
        [System.Object]
        $DistributionGroupNameBlockedWordsList,

        [Parameter()]
        [System.Object]
        $PreferredInternetCodePageForShiftJis,

        [Parameter()]
        [System.Object]
        $AsyncSendEnabled,

        [Parameter()]
        [System.Object]
        $ConnectorsEnabledForSharepoint,

        [Parameter()]
        [System.Object]
        $BookingsBlockedWordsEnabled,

        [Parameter()]
        [System.Object]
        $ActivityBasedAuthenticationTimeoutWithSingleSignOnEnabled,

        [Parameter()]
        [System.Object]
        $HierarchicalAddressBookRoot,

        [Parameter()]
        [System.Object]
        $BookingsNamingPolicyEnabled,

        [Parameter()]
        [System.Object]
        $DefaultPublicFolderAgeLimit,

        [Parameter()]
        [System.Object]
        $DefaultAuthenticationPolicy,

        [Parameter()]
        [System.Object]
        $OutlookPayEnabled,

        [Parameter()]
        [System.Object]
        $MailTipsLargeAudienceThreshold,

        [Parameter()]
        [System.Object]
        $BookingsSearchEngineIndexDisabled,

        [Parameter()]
        [System.Object]
        $CalendarVersionStoreEnabled,

        [Parameter()]
        [System.Object]
        $BookingsPaymentsEnabled,

        [Parameter()]
        [System.Object]
        $MessageHighlightsEnabled,

        [Parameter()]
        [System.Object]
        $WebSuggestedRepliesDisabled,

        [Parameter()]
        [System.Object]
        $DistributionGroupNamingPolicy,

        [Parameter()]
        [System.Object]
        $PublicComputersDetectionEnabled,

        [Parameter()]
        [System.Object]
        $BookingsSocialSharingRestricted,

        [Parameter()]
        [System.Object]
        $BookingsNamingPolicySuffix,

        [Parameter()]
        [System.Object]
        $BookingsNamingPolicySuffixEnabled,

        [Parameter()]
        [System.Object]
        $BookingsMembershipApprovalRequired,

        [Parameter()]
        [System.Object]
        $IsGroupMemberAllowedToEditContent,

        [Parameter()]
        [System.Object]
        $DefaultPublicFolderMovedItemRetention,

        [Parameter()]
        [System.Object]
        $DistributionGroupDefaultOU,

        [Parameter()]
        [System.Object]
        $OutlookTextPredictionDisabled,

        [Parameter()]
        [System.Object]
        $SharedDomainEmailAddressFlowEnabled,

        [Parameter()]
        [System.Object]
        $ConnectorsActionableMessagesEnabled,

        [Parameter()]
        [System.Object]
        $MailTipsMailboxSourcedTipsEnabled,

        [Parameter()]
        [System.Object]
        $BookingsEnabled,

        [Parameter()]
        [System.Object]
        $WebPushNotificationsDisabled,

        [Parameter()]
        [System.Object]
        $EndUserDLUpgradeFlowsDisabled,

        [Parameter()]
        [System.Object]
        $BookingsPhoneNumberEntryRestricted,

        [Parameter()]
        [System.Object]
        $AppsForOfficeEnabled,

        [Parameter()]
        [System.Object]
        $EnableForwardingAddressSyncForMailboxes,

        [Parameter()]
        [System.Object]
        $EwsAllowOutlook,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AutoExpandingArchive,

        [Parameter()]
        [System.Object]
        $EwsAllowMacOutlook,

        [Parameter()]
        [System.Object]
        $EwsAllowList,

        [Parameter()]
        [System.Object]
        $DisablePlusAddressInRecipients,

        [Parameter()]
        [System.Object]
        $MatchSenderOrganizerProperties,

        [Parameter()]
        [System.Object]
        $DefaultMinutesToReduceLongEventsBy,

        [Parameter()]
        [System.Object]
        $IPListBlocked,

        [Parameter()]
        [System.Object]
        $RecallReadMessagesEnabled,

        [Parameter()]
        [System.Object]
        $SendFromAliasEnabled,

        [Parameter()]
        [System.Object]
        $AutodiscoverPartialDirSync,

        [Parameter()]
        [System.Object]
        $ActivityBasedAuthenticationTimeoutInterval,

        [Parameter()]
        [System.Object]
        $IsGroupFoldersAndRulesEnabled,

        [Parameter()]
        [System.Object]
        $MaskClientIpInReceivedHeadersEnabled,

        [Parameter()]
        [System.Object]
        $PerTenantSwitchToESTSEnabled,

        [Parameter()]
        [System.Object]
        $ConnectorsEnabled,

        [Parameter()]
        [System.Object]
        $EwsBlockList,

        [Parameter()]
        [System.Object]
        $CustomerLockboxEnabled,

        [Parameter()]
        [System.Object]
        $SiteMailboxCreationURL,

        [Parameter()]
        [System.Object]
        $DefaultPublicFolderMaxItemSize,

        [Parameter()]
        [System.Object]
        $ByteEncoderTypeFor7BitCharsets,

        [Parameter()]
        [System.Object]
        $FindTimeAutoScheduleDisabled,

        [Parameter()]
        [System.Object]
        $DefaultPublicFolderIssueWarningQuota,

        [Parameter()]
        [System.Object]
        $OutlookMobileSingleAccountEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-OrganizationRelationship
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $TargetApplicationUri,

        [Parameter()]
        [System.Object]
        $TargetAutodiscoverEpr,

        [Parameter()]
        [System.Object]
        $MailTipsAccessLevel,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $DeliveryReportEnabled,

        [Parameter()]
        [System.Object]
        $OAuthApplicationId,

        [Parameter()]
        [System.Object]
        $OrganizationContact,

        [Parameter()]
        [System.Object]
        $ArchiveAccessEnabled,

        [Parameter()]
        [System.Object]
        $FreeBusyAccessEnabled,

        [Parameter()]
        [System.Object]
        $MailTipsAccessScope,

        [Parameter()]
        [System.Object]
        $TargetOwaURL,

        [Parameter()]
        [System.Object]
        $MailTipsAccessEnabled,

        [Parameter()]
        [System.Object]
        $PhotosEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $MailboxMovePublishedScopes,

        [Parameter()]
        [System.Object]
        $MailboxMoveEnabled,

        [Parameter()]
        [System.Object]
        $MailboxMoveCapability,

        [Parameter()]
        [System.Object]
        $TargetSharingEpr,

        [Parameter()]
        [System.Object]
        $FreeBusyAccessLevel,

        [Parameter()]
        [System.Object]
        $DomainNames,

        [Parameter()]
        [System.Object]
        $FreeBusyAccessScope,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-OutboundConnector
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $RouteAllMessagesViaOnPremises,

        [Parameter()]
        [System.Object]
        $RecipientDomains,

        [Parameter()]
        [System.Object]
        $CloudServicesMailEnabled,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $TestMode,

        [Parameter()]
        [System.Object]
        $AllAcceptedDomains,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $IsTransportRuleScoped,

        [Parameter()]
        [System.Object]
        $IsValidated,

        [Parameter()]
        [System.Object]
        $UseMXRecord,

        [Parameter()]
        [System.Object]
        $LastValidationTimestamp,

        [Parameter()]
        [System.Object]
        $TlsSettings,

        [Parameter()]
        [System.Object]
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
        [System.Object]
        $SenderRewritingEnabled,

        [Parameter()]
        [System.Object]
        $TlsDomain,

        [Parameter()]
        [System.Object]
        $ConnectorSource,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        [System.Object]
        $DefaultClientLanguage,

        [Parameter()]
        [System.Object]
        $WacExternalServicesEnabled,

        [Parameter()]
        [System.Object]
        $ContactsEnabled,

        [Parameter()]
        [System.Object]
        $PersonalAccountCalendarsEnabled,

        [Parameter()]
        [System.Object]
        $ConditionalAccessPolicy,

        [Parameter()]
        [System.Object]
        $MessagePreviewsDisabled,

        [Parameter()]
        [System.Object]
        $ExplicitLogonEnabled,

        [Parameter()]
        [System.Object]
        $ShowOnlineArchiveEnabled,

        [Parameter()]
        [System.Object]
        $WebPartsFrameOptionsType,

        [Parameter()]
        [System.Object]
        $BlockedFileTypes,

        [Parameter()]
        [System.Object]
        $OneDriveAttachmentsEnabled,

        [Parameter()]
        [System.Object]
        $LinkedInEnabled,

        [Parameter()]
        [System.Object]
        $DirectFileAccessOnPrivateComputersEnabled,

        [Parameter()]
        [System.Object]
        $AllowedOrganizationAccountDomains,

        [Parameter()]
        [System.Object]
        $ChangePasswordEnabled,

        [Parameter()]
        [System.Object]
        $SignaturesEnabled,

        [Parameter()]
        [System.Object]
        $AllowedMimeTypes,

        [Parameter()]
        [System.Object]
        $WacViewingOnPublicComputersEnabled,

        [Parameter()]
        [System.Object]
        $WacEditingEnabled,

        [Parameter()]
        [System.Object]
        $OutlookBetaToggleEnabled,

        [Parameter()]
        [System.Object]
        $SMimeSuppressNameChecksEnabled,

        [Parameter()]
        [System.Object]
        $ExternalSPMySiteHostURL,

        [Parameter()]
        [System.Object]
        $ReferenceAttachmentsEnabled,

        [Parameter()]
        [System.Object]
        $NotesEnabled,

        [Parameter()]
        [System.Object]
        $JournalEnabled,

        [Parameter()]
        [System.Object]
        $SpellCheckerEnabled,

        [Parameter()]
        [System.Object]
        $DisplayPhotosEnabled,

        [Parameter()]
        [System.Object]
        $TasksEnabled,

        [Parameter()]
        [System.Object]
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
        [System.Object]
        $TeamsnapCalendarsEnabled,

        [Parameter()]
        [System.Object]
        $WacViewingOnPrivateComputersEnabled,

        [Parameter()]
        [System.Object]
        $TextMessagingEnabled,

        [Parameter()]
        [System.Object]
        $SearchFoldersEnabled,

        [Parameter()]
        [System.Object]
        $UserVoiceEnabled,

        [Parameter()]
        [System.Object]
        $ForceWacViewingFirstOnPublicComputers,

        [Parameter()]
        [System.Object]
        $GlobalAddressListEnabled,

        [Parameter()]
        [System.Object]
        $IRMEnabled,

        [Parameter()]
        [System.Object]
        $DirectFileAccessOnPublicComputersEnabled,

        [Parameter()]
        [System.Object]
        $NpsSurveysEnabled,

        [Parameter()]
        [System.Object]
        $ItemsToOtherAccountsEnabled,

        [Parameter()]
        [System.Object]
        $WSSAccessOnPublicComputersEnabled,

        [Parameter()]
        [System.Object]
        $ForceSaveMimeTypes,

        [Parameter()]
        [System.Object]
        $WacOMEXEnabled,

        [Parameter()]
        [System.Object]
        $PlacesEnabled,

        [Parameter()]
        [System.Object]
        $InternalSPMySiteHostURL,

        [Parameter()]
        [System.Object]
        $SatisfactionEnabled,

        [Parameter()]
        [System.Object]
        $InstantMessagingType,

        [Parameter()]
        [System.Object]
        $ActiveSyncIntegrationEnabled,

        [Parameter()]
        [System.Object]
        $PersonalAccountsEnabled,

        [Parameter()]
        [System.Object]
        $DefaultTheme,

        [Parameter()]
        [System.Object]
        $SetPhotoEnabled,

        [Parameter()]
        [System.Object]
        $ClassicAttachmentsEnabled,

        [Parameter()]
        [System.Object]
        $AllowCopyContactsToDeviceAddressBook,

        [Parameter()]
        [System.Object]
        $UseISO885915,

        [Parameter()]
        [System.Object]
        $OutboundCharset,

        [Parameter()]
        [System.Object]
        $LocalEventsEnabled,

        [Parameter()]
        [System.Object]
        $CalendarEnabled,

        [Parameter()]
        [System.Object]
        $ForceWacViewingFirstOnPrivateComputers,

        [Parameter()]
        [System.Object]
        $RecoverDeletedItemsEnabled,

        [Parameter()]
        [System.Object]
        $InstantMessagingEnabled,

        [Parameter()]
        [System.Object]
        $OrganizationEnabled,

        [Parameter()]
        [System.Object]
        $DelegateAccessEnabled,

        [Parameter()]
        [System.Object]
        $ActionForUnknownFileAndMIMETypes,

        [Parameter()]
        [System.Object]
        $RemindersAndNotificationsEnabled,

        [Parameter()]
        [System.Object]
        $PublicFoldersEnabled,

        [Parameter()]
        [System.Object]
        $BookingsMailboxCreationEnabled,

        [Parameter()]
        [System.Object]
        $ForceSaveAttachmentFilteringEnabled,

        [Parameter()]
        [System.Object]
        $LogonAndErrorLanguage,

        [Parameter()]
        [System.Object]
        $WSSAccessOnPrivateComputersEnabled,

        [Parameter()]
        [System.Object]
        $AllAddressListsEnabled,

        [Parameter()]
        [System.Object]
        $ExternalImageProxyEnabled,

        [Parameter()]
        [System.Object]
        $ProjectMocaEnabled,

        [Parameter()]
        [System.Object]
        $PremiumClientEnabled,

        [Parameter()]
        [System.Object]
        $BlockedMimeTypes,

        [Parameter()]
        [System.Object]
        $UMIntegrationEnabled,

        [Parameter()]
        [System.Object]
        $FeedbackEnabled,

        [Parameter()]
        [System.Object]
        $SilverlightEnabled,

        [Parameter()]
        [System.Object]
        $WeatherEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsDefault,

        [Parameter()]
        [System.Object]
        $UseGB18030,

        [Parameter()]
        [System.Object]
        $AllowOfflineOn,

        [Parameter()]
        [System.Object]
        $AllowedFileTypes,

        [Parameter()]
        [System.Object]
        $SetPhotoURL,

        [Parameter()]
        [System.Object]
        $RulesEnabled,

        [Parameter()]
        [System.Object]
        $OneWinNativeOutlookEnabled,

        [Parameter()]
        [System.Object]
        $FreCardsEnabled,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $ThemeSelectionEnabled,

        [Parameter()]
        [System.Object]
        $AdditionalStorageProvidersAvailable,

        [Parameter()]
        [System.Object]
        $InterestingCalendarsEnabled,

        [Parameter()]
        [System.Object]
        $OWALightEnabled,

        [Parameter()]
        [System.Object]
        $PrintWithoutDownloadEnabled,

        [Parameter()]
        [System.Object]
        $SaveAttachmentsToCloudEnabled,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $ReportJunkEmailEnabled,

        [Parameter()]
        [System.Object]
        $SkipCreateUnifiedGroupCustomSharepointClassification,

        [Parameter()]
        [System.Object]
        $OnSendAddinsEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $DisableFacebook,

        [Parameter()]
        [System.Object]
        $PhoneticSupportEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-PartnerApplication
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $ApplicationIdentifier,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $LinkedAccount,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $AcceptSecurityIdentifierInformation,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $AccountType,

        [Parameter()]
        [System.Object]
        $ActAsPermissions,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $GatewayIPAddresses,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-PolicyTipConfig
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Value,

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
        [System.Object]
        $EndUserSpamNotificationFrequencyInDays,

        [Parameter()]
        [System.Object]
        $CustomDisclaimer,

        [Parameter()]
        [System.Object]
        $EndUserQuarantinePermissionsValue,

        [Parameter()]
        [System.Object]
        $ESNEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IgnoreDehydratedFlag,

        [Parameter()]
        [System.Object]
        $EndUserQuarantinePermissions,

        [Parameter()]
        [System.Object]
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
        [System.Object]
        $QuarantineRetentionDays,

        [Parameter()]
        [System.Object]
        $OrganizationBrandingEnabled,

        [Parameter()]
        [System.Object]
        $AdminNotificationFrequencyInDays,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-RemoteDomain
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $AutoReplyEnabled,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $TNEFEnabled,

        [Parameter()]
        [System.Object]
        $DeliveryReportEnabled,

        [Parameter()]
        [System.Object]
        $RequiredCharsetCoverage,

        [Parameter()]
        [System.Object]
        $MeetingForwardNotificationEnabled,

        [Parameter()]
        [System.Object]
        $ContentType,

        [Parameter()]
        [System.Object]
        $ByteEncoderTypeFor7BitCharsets,

        [Parameter()]
        [System.Object]
        $AutoForwardEnabled,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $TrustedMailInboundEnabled,

        [Parameter()]
        [System.Object]
        $LineWrapSize,

        [Parameter()]
        [System.Object]
        $CharacterSet,

        [Parameter()]
        [System.Object]
        $PreferredInternetCodePageForShiftJis,

        [Parameter()]
        [System.Object]
        $NonMimeCharacterSet,

        [Parameter()]
        [System.Object]
        $NDREnabled,

        [Parameter()]
        [System.Object]
        $TargetDeliveryDomain,

        [Parameter()]
        [System.Object]
        $TrustedMailOutboundEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $DisplaySenderName,

        [Parameter()]
        [System.Object]
        $AllowedOOFType,

        [Parameter()]
        [System.Object]
        $NDRDiagnosticInfoEnabled,

        [Parameter()]
        [System.Object]
        $IsInternal,

        [Parameter()]
        [System.Object]
        $UseSimpleDisplayName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        $ResourcePropertySchema,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-RoleAssignmentPolicy
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
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsDefault,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-SafeAttachmentPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Redirect,

        [Parameter()]
        [System.Object]
        $AdminDisplayName,

        [Parameter()]
        [System.Object]
        $Enable,

        [Parameter()]
        [System.Object]
        $RedirectAddress,

        [Parameter()]
        [System.Object]
        $Action,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $QuarantineTag,

        [Parameter()]
        [System.Object]
        $ActionOnError,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-SafeAttachmentRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Priority,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $SentToMemberOf,

        [Parameter()]
        [System.Object]
        $SentTo,

        [Parameter()]
        [System.Object]
        $Comments,

        [Parameter()]
        [System.Object]
        $RecipientDomainIs,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $SafeAttachmentPolicy,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.Object]
        $ExceptIfSentTo,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $ExceptIfSentToMemberOf,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-SafeLinksPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $EnableOrganizationBranding,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $AdminDisplayName,

        [Parameter()]
        [System.Object]
        $UseTranslatedNotificationText,

        [Parameter()]
        [System.Object]
        $DisableUrlRewrite,

        [Parameter()]
        [System.Object]
        $DoNotRewriteUrls,

        [Parameter()]
        [System.Object]
        $EnableSafeLinksForTeams,

        [Parameter()]
        [System.Object]
        $TrackClicks,

        [Parameter()]
        [System.Object]
        $AllowClickThrough,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $CustomNotificationText,

        [Parameter()]
        [System.Object]
        $DeliverMessageAfterScan,

        [Parameter()]
        [System.Object]
        $EnableSafeLinksForEmail,

        [Parameter()]
        [System.Object]
        $ScanUrls,

        [Parameter()]
        [System.Object]
        $EnableForInternalSenders,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-SafeLinksRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Priority,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $SentToMemberOf,

        [Parameter()]
        [System.Object]
        $SentTo,

        [Parameter()]
        [System.Object]
        $Comments,

        [Parameter()]
        [System.Object]
        $RecipientDomainIs,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.Object]
        $SafeLinksPolicy,

        [Parameter()]
        [System.Object]
        $ExceptIfSentTo,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $ExceptIfSentToMemberOf,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-SharingPolicy
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
        $Domains,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Default,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Enabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-TransportConfig
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $InternalDelayDsnEnabled,

        [Parameter()]
        [System.Object]
        $InternalDsnSendHtml,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $ExternalDelayDsnEnabled,

        [Parameter()]
        [System.Object]
        $DSNConversionMode,

        [Parameter()]
        [System.Object]
        $SmtpClientAuthenticationDisabled,

        [Parameter()]
        [System.Object]
        $ReplyAllStormBlockDurationHours,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $ReplyAllStormProtectionEnabled,

        [Parameter()]
        [System.Object]
        $AddressBookPolicyRoutingEnabled,

        [Parameter()]
        [System.Object]
        $ExternalDsnLanguageDetectionEnabled,

        [Parameter()]
        [System.Object]
        $ExternalDsnSendHtml,

        [Parameter()]
        [System.Object]
        $Rfc2231EncodingEnabled,

        [Parameter()]
        [System.Object]
        $InternalDsnLanguageDetectionEnabled,

        [Parameter()]
        [System.Object]
        $AllowLegacyTLSClients,

        [Parameter()]
        [System.Object]
        $VoicemailJournalingEnabled,

        [Parameter()]
        [System.Object]
        $HeaderPromotionModeSetting,

        [Parameter()]
        [System.Object]
        $JournalingReportNdrTo,

        [Parameter()]
        [System.Object]
        $ConvertDisclaimerWrapperToEml,

        [Parameter()]
        [System.Object]
        $InternalDsnReportingAuthority,

        [Parameter()]
        [System.Object]
        $JournalMessageExpirationDays,

        [Parameter()]
        [System.Object]
        $MaxRecipientEnvelopeLimit,

        [Parameter()]
        [System.Object]
        $ReplyAllStormDetectionMinimumReplies,

        [Parameter()]
        [System.Object]
        $ExternalDsnReportingAuthority,

        [Parameter()]
        [System.Object]
        $ExternalDsnDefaultLanguage,

        [Parameter()]
        [System.Object]
        $InternalDsnDefaultLanguage,

        [Parameter()]
        [System.Object]
        $ExternalPostmasterAddress,

        [Parameter()]
        [System.Object]
        $ClearCategories,

        [Parameter()]
        [System.Object]
        $ReplyAllStormDetectionMinimumRecipients,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        [System.Object]
        $AddToRecipients,

        [Parameter()]
        [System.Object]
        $ApplyHtmlDisclaimerFallbackAction,

        [Parameter()]
        [System.Object]
        $RemoveRMSAttachmentEncryption,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientADAttributeContainsWords,

        [Parameter()]
        [System.Object]
        $RecipientADAttributeMatchesPatterns,

        [Parameter()]
        [System.Object]
        $AttachmentSizeOver,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderADAttributeContainsWords,

        [Parameter()]
        [System.Object]
        $SetSCL,

        [Parameter()]
        [System.Object]
        $AnyOfToHeaderMemberOf,

        [Parameter()]
        [System.Object]
        $Disconnect,

        [Parameter()]
        [System.Object]
        $ExceptIfSentToMemberOf,

        [Parameter()]
        [System.Object]
        $ExceptIfAnyOfCcHeader,

        [Parameter()]
        [System.Object]
        $ExceptIfAttachmentMatchesPatterns,

        [Parameter()]
        [System.Object]
        $RecipientDomainIs,

        [Parameter()]
        [System.Object]
        $ManagerForEvaluatedUser,

        [Parameter()]
        [System.Object]
        $SmtpRejectMessageRejectStatusCode,

        [Parameter()]
        [System.Object]
        $ExceptIfHeaderMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfFromScope,

        [Parameter()]
        [System.Object]
        $ADComparisonAttribute,

        [Parameter()]
        [System.Object]
        $ExceptIfHeaderContainsWords,

        [Parameter()]
        [System.Object]
        $HeaderMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfAttachmentIsPasswordProtected,

        [Parameter()]
        [System.Object]
        $DeleteMessage,

        [Parameter()]
        [System.Object]
        $HasSenderOverride,

        [Parameter()]
        [System.Object]
        $ExceptIfSubjectOrBodyMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfHasClassification,

        [Parameter()]
        [System.Object]
        $Quarantine,

        [Parameter()]
        [System.Object]
        $ExceptIfAnyOfRecipientAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $RecipientAddressType,

        [Parameter()]
        [System.Object]
        $ExceptIfContentCharacterSetContainsWords,

        [Parameter()]
        [System.Object]
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
        [System.Object]
        $ExceptIfMessageContainsDataClassifications,

        [Parameter()]
        [System.Object]
        $ModerateMessageByUser,

        [Parameter()]
        [System.Object]
        $HasNoClassification,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderInRecipientList,

        [Parameter()]
        [System.Object]
        $HeaderContainsMessageHeader,

        [Parameter()]
        [System.Object]
        $RemoveHeader,

        [Parameter()]
        [System.Object]
        $HasClassification,

        [Parameter()]
        [System.Object]
        $MessageContainsDataClassifications,

        [Parameter()]
        [System.Object]
        $ExceptIfFromMemberOf,

        [Parameter()]
        [System.Object]
        $RuleSubType,

        [Parameter()]
        [System.Object]
        $SentToScope,

        [Parameter()]
        [System.Object]
        $AnyOfToCcHeaderMemberOf,

        [Parameter()]
        [System.Object]
        $From,

        [Parameter()]
        [System.Object]
        $ExceptIfAnyOfRecipientAddressContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfWithImportance,

        [Parameter()]
        [System.Object]
        $ContentCharacterSetContainsWords,

        [Parameter()]
        [System.Object]
        $SubjectContainsWords,

        [Parameter()]
        [System.Object]
        $RejectMessageEnhancedStatusCode,

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
        $FromMemberOf,

        [Parameter()]
        [System.Object]
        $AttachmentContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfSCLOver,

        [Parameter()]
        [System.Object]
        $ExceptIfBetweenMemberOf1,

        [Parameter()]
        [System.Object]
        $GenerateNotification,

        [Parameter()]
        [System.Object]
        $NotifySender,

        [Parameter()]
        [System.Object]
        $ExceptIfAttachmentNameMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderManagementRelationship,

        [Parameter()]
        [System.Object]
        $SetAuditSeverity,

        [Parameter()]
        [System.Object]
        $AttachmentPropertyContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfAnyOfToHeader,

        [Parameter()]
        [System.Object]
        $ApplyRightsProtectionCustomizationTemplate,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
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
        [System.Object]
        $AttachmentNameMatchesPatterns,

        [Parameter()]
        [System.Object]
        $SentTo,

        [Parameter()]
        [System.Object]
        $ExceptIfFromAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $AnyOfCcHeaderMemberOf,

        [Parameter()]
        [System.Object]
        $ExceptIfAttachmentSizeOver,

        [Parameter()]
        [System.Object]
        $ExceptIfManagerForEvaluatedUser,

        [Parameter()]
        [System.Object]
        $RemoveOMEv2,

        [Parameter()]
        [System.Object]
        $ExceptIfFromAddressContainsWords,

        [Parameter()]
        [System.Object]
        $AttachmentHasExecutableContent,

        [Parameter()]
        [System.Object]
        $RouteMessageOutboundConnector,

        [Parameter()]
        [System.Object]
        $SubjectMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderDomainIs,

        [Parameter()]
        [System.Object]
        $SenderManagementRelationship,

        [Parameter()]
        [System.Object]
        $ExceptIfBetweenMemberOf2,

        [Parameter()]
        [System.Object]
        $RedirectMessageTo,

        [Parameter()]
        [System.Object]
        $ApplyOME,

        [Parameter()]
        [System.Object]
        $AddManagerAsRecipientType,

        [Parameter()]
        [System.Object]
        $ExceptIfMessageSizeOver,

        [Parameter()]
        [System.Object]
        $RecipientInSenderList,

        [Parameter()]
        [System.Object]
        $SenderADAttributeContainsWords,

        [Parameter()]
        [System.Object]
        $MessageSizeOver,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientInSenderList,

        [Parameter()]
        [System.Object]
        $ExceptIfAttachmentHasExecutableContent,

        [Parameter()]
        [System.Object]
        $ExceptIfAttachmentIsUnsupported,

        [Parameter()]
        [System.Object]
        $RemoveOME,

        [Parameter()]
        [System.Object]
        $RejectMessageReasonText,

        [Parameter()]
        [System.Object]
        $RecipientAddressContainsWords,

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
        $ApplyHtmlDisclaimerText,

        [Parameter()]
        [System.Object]
        $RecipientAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfSubjectContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfFrom,

        [Parameter()]
        [System.Object]
        $AnyOfToCcHeader,

        [Parameter()]
        [System.Object]
        $ExceptIfSentToScope,

        [Parameter()]
        [System.Object]
        $ExceptIfAnyOfToCcHeaderMemberOf,

        [Parameter()]
        [System.Object]
        $ModerateMessageByManager,

        [Parameter()]
        [System.Object]
        $ADComparisonOperator,

        [Parameter()]
        [System.Object]
        $BetweenMemberOf2,

        [Parameter()]
        [System.Object]
        $SetHeaderName,

        [Parameter()]
        [System.Object]
        $AttachmentProcessingLimitExceeded,

        [Parameter()]
        [System.Object]
        $ExceptIfAnyOfCcHeaderMemberOf,

        [Parameter()]
        [System.Object]
        $ExceptIfSubjectMatchesPatterns,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientAddressContainsWords,

        [Parameter()]
        [System.Object]
        $HeaderMatchesMessageHeader,

        [Parameter()]
        [System.Object]
        $AnyOfRecipientAddressContainsWords,

        [Parameter()]
        [System.Object]
        $HeaderContainsWords,

        [Parameter()]
        [System.Object]
        $Comments,

        [Parameter()]
        [System.Object]
        $SentToMemberOf,

        [Parameter()]
        [System.Object]
        $ExceptIfADComparisonAttribute,

        [Parameter()]
        [System.Object]
        $ExceptIfSentTo,

        [Parameter()]
        [System.Object]
        $ExceptIfADComparisonOperator,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $ExceptIfAnyOfToHeaderMemberOf,

        [Parameter()]
        [System.Object]
        $Mode,

        [Parameter()]
        [System.Object]
        $ExceptIfAnyOfToCcHeader,

        [Parameter()]
        [System.Object]
        $SubjectOrBodyMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfAttachmentExtensionMatchesWords,

        [Parameter()]
        [System.Object]
        $SenderDomainIs,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfHasNoClassification,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderIpRanges,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientADAttributeMatchesPatterns,

        [Parameter()]
        [System.Object]
        $RecipientADAttributeContainsWords,

        [Parameter()]
        [System.Object]
        $AttachmentIsUnsupported,

        [Parameter()]
        [System.Object]
        $ExpiryDate,

        [Parameter()]
        [System.Object]
        $AttachmentExtensionMatchesWords,

        [Parameter()]
        [System.Object]
        $ExceptIfSubjectOrBodyContainsWords,

        [Parameter()]
        [System.Object]
        $LogEventText,

        [Parameter()]
        [System.Object]
        $ExceptIfManagerAddresses,

        [Parameter()]
        [System.Object]
        $SenderInRecipientList,

        [Parameter()]
        [System.Object]
        $AttachmentMatchesPatterns,

        [Parameter()]
        [System.Object]
        $DlpPolicy,

        [Parameter()]
        [System.Object]
        $ManagerAddresses,

        [Parameter()]
        [System.Object]
        $SenderAddressLocation,

        [Parameter()]
        [System.Object]
        $CopyTo,

        [Parameter()]
        [System.Object]
        $SubjectOrBodyContainsWords,

        [Parameter()]
        [System.Object]
        $ApplyClassification,

        [Parameter()]
        [System.Object]
        $SetHeaderValue,

        [Parameter()]
        [System.Object]
        $Priority,

        [Parameter()]
        [System.Object]
        $AttachmentIsPasswordProtected,

        [Parameter()]
        [System.Object]
        $BetweenMemberOf1,

        [Parameter()]
        [System.Object]
        $AnyOfCcHeader,

        [Parameter()]
        [System.Object]
        $ExceptIfAttachmentProcessingLimitExceeded,

        [Parameter()]
        [System.Object]
        $FromAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfHeaderMatchesMessageHeader,

        [Parameter()]
        [System.Object]
        $SmtpRejectMessageRejectText,

        [Parameter()]
        [System.Object]
        $ExceptIfAttachmentContainsWords,

        [Parameter()]
        [System.Object]
        $AnyOfToHeader,

        [Parameter()]
        [System.Object]
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
        [System.Object]
        $ExceptIfAttachmentPropertyContainsWords,

        [Parameter()]
        [System.Object]
        $StopRuleProcessing,

        [Parameter()]
        [System.Object]
        $ExceptIfHeaderContainsMessageHeader,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-User
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $MailboxRegion,

        [Parameter()]
        [System.Object]
        $Phone,

        [Parameter()]
        [System.Object]
        $DisplayName,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
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
        [System.Object]
        $Pager,

        [Parameter()]
        [System.Object]
        $PhoneticDisplayName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ClearDataEncryptionPolicy,

        [Parameter()]
        [System.Object]
        $Fax,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $Company,

        [Parameter()]
        [System.Object]
        $StsRefreshTokensValidFrom,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RemoveMailboxProvisioningConstraint,

        [Parameter()]
        [System.Object]
        $ResetPasswordOnNextLogon,

        [Parameter()]
        [System.Object]
        $BlockCloudCache,

        [Parameter()]
        [System.Object]
        $SeniorityIndex,

        [Parameter()]
        [System.Object]
        $City,

        [Parameter()]
        [System.Object]
        $StreetAddress,

        [Parameter()]
        [System.Object]
        $Title,

        [Parameter()]
        [System.Object]
        $MobilePhone,

        [Parameter()]
        [System.Object]
        $AssistantName,

        [Parameter()]
        [System.Object]
        $VIP,

        [Parameter()]
        [System.Object]
        $StateOrProvince,

        [Parameter()]
        [System.Object]
        $Manager,

        [Parameter()]
        [System.Object]
        $Initials,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $WebPage,

        [Parameter()]
        [System.Object]
        $LastName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PermanentlyClearPreviousMailboxInfo,

        [Parameter()]
        [System.Object]
        $MailboxRegionSuffix,

        [Parameter()]
        [System.Object]
        $HomePhone,

        [Parameter()]
        [System.Object]
        $OtherFax,

        [Parameter()]
        [System.Object]
        $SimpleDisplayName,

        [Parameter()]
        [System.Object]
        $Department,

        [Parameter()]
        [System.Object]
        $OtherHomePhone,

        [Parameter()]
        [System.Object]
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
        [System.Object]
        $Notes,

        [Parameter()]
        [System.Object]
        $RemotePowerShellEnabled,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $GeoCoordinates,

        [Parameter()]
        [System.Object]
        $PostalCode,

        [Parameter()]
        [System.Object]
        $DesiredWorkloads,

        [Parameter()]
        [System.Object]
        $CanHaveCloudCache,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        [Microsoft.Graph.PowerShell.Models.IApplicationsIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IApplicationsIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IApplicationsIdentity]
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
        $AppRoleAssignmentId,

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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOptionalClaims]
        $OptionalClaims,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphHomeRealmDiscoveryPolicy[]]
        $HomeRealmDiscoveryPolicies,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphSpaApplication]
        $Spa,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphSynchronization]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphVerifiedPublisher]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphTokenIssuancePolicy[]]
        $TokenIssuancePolicies,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphApiApplication]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $Owners,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphFederatedIdentityCredential[]]
        $FederatedIdentityCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphTokenLifetimePolicy[]]
        $TokenLifetimePolicies,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppManagementPolicy[]]
        $AppManagementPolicies,

        [Parameter()]
        [System.String]
        $DisabledByMicrosoftStatus,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPasswordCredential[]]
        $PasswordCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPublicClientApplication]
        $PublicClient,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphRequiredResourceAccess[]]
        $RequiredResourceAccess,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphParentalControlSettings]
        $ParentalControlSettings,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphWebApplication]
        $Web,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsFallbackPublicClient,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAddIn[]]
        $AddIns,

        [Parameter()]
        [System.DateTime]
        $DeletedDateTime,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphRequestSignatureVerification]
        $RequestSignatureVerification,

        [Parameter()]
        [System.String]
        $LogoInputFile,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppRole[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphExtensionProperty[]]
        $ExtensionProperties,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphWindowsApplication]
        $Windows,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphConnectorGroup]
        $ConnectorGroup,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject]
        $CreatedOnBehalfOf,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphKeyCredential[]]
        $KeyCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphCertification]
        $Certification,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOnPremisesPublishing]
        $OnPremisesPublishing,

        [Parameter()]
        [System.String]
        $SamlMetadataUrl,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphInformationalUrl]
        $Info,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Oauth2RequirePostResponse,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphApplication1]
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
        [System.Collections.Hashtable]
        $BodyParameter,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IApplicationsIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphHomeRealmDiscoveryPolicy[]]
        $HomeRealmDiscoveryPolicies,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPermissionScope[]]
        $Oauth2PermissionScopes,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphSynchronization]
        $Synchronization,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppRoleAssignment[]]
        $AppRoleAssignments,

        [Parameter()]
        [System.String]
        $ApplicationTemplateId,

        [Parameter()]
        [System.String]
        $SignInAudience,

        [Parameter()]
        [System.String]
        $PublisherName,

        [Parameter()]
        [System.String]
        $ErrorUrl,

        [Parameter()]
        [System.String[]]
        $NotificationEmailAddresses,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphLicenseDetails[]]
        $LicenseDetails,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphClaimsMappingPolicy[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphTokenIssuancePolicy[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppRoleAssignment[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphSamlSingleSignOnSettings]
        $SamlSingleSignOnSettings,

        [Parameter()]
        [System.String[]]
        $Tags,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $Owners,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $OwnedObjects,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphFederatedIdentityCredential[]]
        $FederatedIdentityCredentials,

        [Parameter()]
        [System.String]
        $LoginUrl,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphTokenLifetimePolicy[]]
        $TokenLifetimePolicies,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppManagementPolicy[]]
        $AppManagementPolicies,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $CreatedObjects,

        [Parameter()]
        [System.DateTime]
        $PreferredTokenSigningKeyEndDateTime,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDelegatedPermissionClassification[]]
        $DelegatedPermissionClassifications,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPasswordCredential[]]
        $PasswordCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $MemberOf,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPermissionScope[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $TransitiveMemberOf,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppRole[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphKeyCredential[]]
        $KeyCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOAuth2PermissionGrant[]]
        $Oauth2PermissionGrants,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphResourceSpecificPermission[]]
        $ResourceSpecificApplicationPermissions,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPasswordSingleSignOnSettings]
        $PasswordSingleSignOnSettings,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAddIn[]]
        $AddIns,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphInformationalUrl]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphEndpoint[]]
        $Endpoints,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphServicePrincipal]
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
        [Microsoft.Graph.PowerShell.Models.IApplicationsIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IApplicationsIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOptionalClaims]
        $OptionalClaims,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IApplicationsIdentity]
        $InputObject,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphHomeRealmDiscoveryPolicy[]]
        $HomeRealmDiscoveryPolicies,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphSpaApplication]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphVerifiedPublisher]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphTokenIssuancePolicy[]]
        $TokenIssuancePolicies,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphApiApplication]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $Owners,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphFederatedIdentityCredential[]]
        $FederatedIdentityCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphTokenLifetimePolicy[]]
        $TokenLifetimePolicies,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppManagementPolicy[]]
        $AppManagementPolicies,

        [Parameter()]
        [System.String]
        $DisabledByMicrosoftStatus,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPasswordCredential[]]
        $PasswordCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPublicClientApplication]
        $PublicClient,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Oauth2RequirePostResponse,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphRequiredResourceAccess[]]
        $RequiredResourceAccess,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphParentalControlSettings]
        $ParentalControlSettings,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphWebApplication]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphSynchronization]
        $Synchronization,

        [Parameter()]
        [System.DateTime]
        $DeletedDateTime,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphRequestSignatureVerification]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppRole[]]
        $AppRoles,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphExtensionProperty[]]
        $ExtensionProperties,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphWindowsApplication]
        $Windows,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject]
        $CreatedOnBehalfOf,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphConnectorGroup]
        $ConnectorGroup,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAddIn[]]
        $AddIns,

        [Parameter()]
        [System.String]
        $ServiceManagementReference,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphKeyCredential[]]
        $KeyCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphCertification]
        $Certification,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOnPremisesPublishing]
        $OnPremisesPublishing,

        [Parameter()]
        [System.String]
        $SamlMetadataUrl,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphInformationalUrl]
        $Info,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphApplication1]
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
        [Microsoft.Graph.PowerShell.Models.IApplicationsIdentity]
        $InputObject,

        [Parameter()]
        [System.String]
        $AppDescription,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphHomeRealmDiscoveryPolicy[]]
        $HomeRealmDiscoveryPolicies,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPermissionScope[]]
        $Oauth2PermissionScopes,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphSynchronization]
        $Synchronization,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppRoleAssignment[]]
        $AppRoleAssignments,

        [Parameter()]
        [System.String]
        $ServicePrincipalId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphLicenseDetails[]]
        $LicenseDetails,

        [Parameter()]
        [System.String]
        $SignInAudience,

        [Parameter()]
        [System.String]
        $PublisherName,

        [Parameter()]
        [System.String[]]
        $NotificationEmailAddresses,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphClaimsMappingPolicy[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphTokenIssuancePolicy[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppRoleAssignment[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphSamlSingleSignOnSettings]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $OwnedObjects,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphFederatedIdentityCredential[]]
        $FederatedIdentityCredentials,

        [Parameter()]
        [System.String]
        $LoginUrl,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphTokenLifetimePolicy[]]
        $TokenLifetimePolicies,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppManagementPolicy[]]
        $AppManagementPolicies,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $CreatedObjects,

        [Parameter()]
        [System.DateTime]
        $PreferredTokenSigningKeyEndDateTime,

        [Parameter()]
        [System.String]
        $ErrorUrl,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDelegatedPermissionClassification[]]
        $DelegatedPermissionClassifications,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPasswordCredential[]]
        $PasswordCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $MemberOf,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPermissionScope[]]
        $PublishedPermissionScopes,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphEndpoint[]]
        $Endpoints,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAddIn[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $TransitiveMemberOf,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppRole[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphKeyCredential[]]
        $KeyCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOAuth2PermissionGrant[]]
        $Oauth2PermissionGrants,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphResourceSpecificPermission[]]
        $ResourceSpecificApplicationPermissions,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPasswordSingleSignOnSettings]
        $PasswordSingleSignOnSettings,

        [Parameter()]
        [System.String]
        $SamlMetadataUrl,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphInformationalUrl]
        $Info,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AccountEnabled,

        [Parameter()]
        [System.String]
        $PreferredSingleSignOnMode,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $Owners,

        [Parameter()]
        [System.Collections.Hashtable]
        $CustomSecurityAttributes,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphServicePrincipal]
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
function Connect-Graph
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $UseDeviceAuthentication,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Security.Cryptography.X509Certificates.X509Certificate2]
        $Certificate,

        [Parameter()]
        [System.String[]]
        $Scopes,

        [Parameter()]
        [System.String]
        $ClientId,

        [Parameter()]
        [System.String]
        $AccessToken,

        [Parameter()]
        [System.Double]
        $ClientTimeout,

        [Parameter()]
        [System.String]
        $CertificateName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ForceRefresh,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.String]
        $Environment,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Authentication.ContextScope]
        $ContextScope
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
        [Microsoft.Graph.PowerShell.Models.IDeviceManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IDeviceManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IDeviceManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceCategory]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceComplianceUserStatus[]]
        $UserStatuses,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.DateTime]
        $LastModifiedDateTime,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceCompliancePolicyAssignment[]]
        $Assignments,

        [Parameter()]
        [System.DateTime]
        $CreatedDateTime,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceComplianceDeviceOverview]
        $DeviceStatusOverview,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceComplianceUserOverview]
        $UserStatusOverview,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Version,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceComplianceDeviceStatus[]]
        $DeviceStatuses,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceComplianceScheduledActionForRule[]]
        $ScheduledActionsForRule,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceCompliancePolicy]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphSettingStateDeviceSummary[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceConfigurationUserStatus[]]
        $UserStatuses,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.DateTime]
        $LastModifiedDateTime,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceConfigurationAssignment[]]
        $Assignments,

        [Parameter()]
        [System.DateTime]
        $CreatedDateTime,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceConfigurationDeviceStatus[]]
        $DeviceStatuses,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceConfigurationDeviceOverview]
        $DeviceStatusOverview,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $SupportsScopeTags,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementApplicabilityRuleOSVersion]
        $DeviceManagementApplicabilityRuleOSVersion,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceConfigurationUserOverview]
        $UserStatusOverview,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceConfigurationGroupAssignment[]]
        $GroupAssignments,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Version,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphSettingStateDeviceSummary[]]
        $DeviceSettingStateSummaries,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementApplicabilityRuleDeviceMode]
        $DeviceManagementApplicabilityRuleDeviceMode,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementApplicabilityRuleOSEdition]
        $DeviceManagementApplicabilityRuleOSEdition,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceConfiguration]
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
        [System.String[]]
        $RoleScopeTagIds,

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
        [Microsoft.Graph.PowerShell.Models.IDeviceManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IDeviceManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IDeviceManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphTermsAndConditions[]]
        $TermsAndConditions,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAndroidForWorkSettings]
        $AndroidForWorkSettings,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphMicrosoftTunnelHealthThreshold[]]
        $MicrosoftTunnelHealthThresholds,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphRoleScopeTag[]]
        $RoleScopeTags,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementExchangeConnector[]]
        $ExchangeConnectors,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagement]
        $BodyParameter,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphGroupPolicyObjectFile[]]
        $GroupPolicyObjectFiles,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphWindowsAutopilotDeploymentProfile[]]
        $WindowsAutopilotDeploymentProfiles,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphResourceOperation[]]
        $ResourceOperations,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphConfigManagerCollection[]]
        $ConfigManagerCollections,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsBatteryHealthDevicePerformance[]]
        $UserExperienceAnalyticsBatteryHealthDevicePerformance,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphZebraFotaConnector]
        $ZebraFotaConnector,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphVirtualEndpoint]
        $VirtualEndpoint,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementConfigurationCategory[]]
        $ConfigurationCategories,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphManagedDeviceEncryptionState[]]
        $ManagedDeviceEncryptionStates,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphMicrosoftTunnelSite[]]
        $MicrosoftTunnelSites,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceEnrollmentConfiguration[]]
        $DeviceEnrollmentConfigurations,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementExchangeOnPremisesPolicy]
        $ExchangeOnPremisesPolicy,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsBatteryHealthAppImpact[]]
        $UserExperienceAnalyticsBatteryHealthAppImpact,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphWindowsInformationProtectionAppLearningSummary[]]
        $WindowsInformationProtectionAppLearningSummaries,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAndroidDeviceOwnerEnrollmentProfile[]]
        $AndroidDeviceOwnerEnrollmentProfiles,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementConfigurationSettingDefinition[]]
        $ReusableSettings,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphGroupPolicyMigrationReport[]]
        $GroupPolicyMigrationReports,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphWindowsInformationProtectionNetworkLearningSummary[]]
        $WindowsInformationProtectionNetworkLearningSummaries,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsAppHealthAppPerformanceByAppVersionDeviceId[]]
        $UserExperienceAnalyticsAppHealthApplicationPerformanceByAppVersionDeviceId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsMetricHistory[]]
        $UserExperienceAnalyticsMetricHistory,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsWorkFromAnywhereMetric[]]
        $UserExperienceAnalyticsWorkFromAnywhereMetrics,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphEmbeddedSimActivationCodePool[]]
        $EmbeddedSimActivationCodePools,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsModelScores[]]
        $UserExperienceAnalyticsModelScores,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementCompliancePolicy[]]
        $CompliancePolicies,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphMobileThreatDefenseConnector[]]
        $MobileThreatDefenseConnectors,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementConfigurationPolicy[]]
        $ConfigurationPolicies,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceProtectionOverview]
        $DeviceProtectionOverview,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDepOnboardingSetting[]]
        $DepOnboardingSettings,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphGroupPolicyDefinitionFile[]]
        $GroupPolicyDefinitionFiles,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceAndAppManagementRoleAssignment[]]
        $RoleAssignments,

        [Parameter()]
        [System.DateTime]
        $LastReportAggregationDateTime,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphWindowsDriverUpdateProfile[]]
        $WindowsDriverUpdateProfiles,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphCartToClassAssociation[]]
        $CartToClassAssociations,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementScript[]]
        $DeviceManagementScripts,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.DeviceManagementSubscriptionState]
        $SubscriptionState,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphWindowsMalwareInformation[]]
        $WindowsMalwareInformation,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphGroupPolicyDefinition[]]
        $GroupPolicyDefinitions,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDetectedApp[]]
        $DetectedApps,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAdvancedThreatProtectionOnboardingStateSummary]
        $AdvancedThreatProtectionOnboardingStateSummary,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsDeviceScope[]]
        $UserExperienceAnalyticsDeviceScopes,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsBaseline[]]
        $UserExperienceAnalyticsBaselines,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsScoreHistory[]]
        $UserExperienceAnalyticsScoreHistory,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsAppHealthApplicationPerformance[]]
        $UserExperienceAnalyticsAppHealthApplicationPerformance,

        [Parameter()]
        [System.DateTime]
        $AccountMoveCompletionDateTime,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementReports]
        $Reports,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementSettings]
        $Settings,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceConfiguration[]]
        $DeviceConfigurations,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphRemoteAssistanceSettings]
        $RemoteAssistanceSettings,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphCertificateConnectorDetails[]]
        $CertificateConnectorDetails,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAuditEvent[]]
        $AuditEvents,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphGroupPolicyConfiguration[]]
        $GroupPolicyConfigurations,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceCategory[]]
        $DeviceCategories,

        [Parameter()]
        [System.Collections.Hashtable]
        $TenantAttachRbac,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsAppHealthAppPerformanceByOSVersion[]]
        $UserExperienceAnalyticsAppHealthApplicationPerformanceByOSVersion,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsCategory]
        $UserExperienceAnalyticsAppHealthOverview,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphWindowsAutopilotSettings]
        $WindowsAutopilotSettings,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsBatteryHealthDeviceAppImpact[]]
        $UserExperienceAnalyticsBatteryHealthDeviceAppImpact,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementConfigurationPolicyTemplate[]]
        $ConfigurationPolicyTemplates,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphApplePushNotificationCertificate]
        $ApplePushNotificationCertificate,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsMetricHistory[]]
        $UserExperienceAnalyticsDeviceMetricHistory,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsAppHealthOSVersionPerformance[]]
        $UserExperienceAnalyticsAppHealthOSVersionPerformance,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphRemoteAssistancePartner[]]
        $RemoteAssistancePartners,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementAutopilotEvent[]]
        $AutopilotEvents,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphComplianceManagementPartner[]]
        $ComplianceManagementPartners,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsDeviceWithoutCloudIdentity[]]
        $UserExperienceAnalyticsDevicesWithoutCloudIdentity,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementTroubleshootingEvent[]]
        $TroubleshootingEvents,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsBatteryHealthCapacityDetails]
        $UserExperienceAnalyticsBatteryHealthCapacityDetails,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphManagedDeviceOverview]
        $ManagedDeviceOverview,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphGroupPolicyUploadedDefinitionFile[]]
        $GroupPolicyUploadedDefinitionFiles,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementPartner[]]
        $DeviceManagementPartners,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAndroidManagedStoreAppConfigurationSchema[]]
        $AndroidManagedStoreAppConfigurationSchemas,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsResourcePerformance[]]
        $UserExperienceAnalyticsResourcePerformance,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphMacOSSoftwareUpdateAccountSummary[]]
        $MacOSSoftwareUpdateAccountSummaries,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsWorkFromAnywhereModelPerformance[]]
        $UserExperienceAnalyticsWorkFromAnywhereModelPerformance,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementConfigurationCategory[]]
        $ComplianceCategories,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceConfigurationConflictSummary[]]
        $DeviceConfigurationConflictSummary,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphTelecomExpenseManagementPartner[]]
        $TelecomExpenseManagementPartners,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementTemplate[]]
        $Templates,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphMicrosoftTunnelConfiguration[]]
        $MicrosoftTunnelConfigurations,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphWindowsMalwareOverview]
        $WindowsMalwareOverview,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementResourceAccessProfileBase[]]
        $ResourceAccessProfiles,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsBatteryHealthDeviceRuntimeHistory[]]
        $UserExperienceAnalyticsBatteryHealthDeviceRuntimeHistory,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementIntent[]]
        $Intents,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphWindowsFeatureUpdateProfile[]]
        $WindowsFeatureUpdateProfiles,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsBatteryHealthRuntimeDetails]
        $UserExperienceAnalyticsBatteryHealthRuntimeDetails,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementConfigurationSettingDefinition[]]
        $ComplianceSettings,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsDeviceScores[]]
        $UserExperienceAnalyticsDeviceScores,

        [Parameter()]
        [System.String]
        $IntuneAccountId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOnPremisesConditionalAccessSettings]
        $ConditionalAccessSettings,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphIosUpdateDeviceStatus[]]
        $IosUpdateStatuses,

        [Parameter()]
        [System.DateTime]
        $DeviceComplianceReportSummarizationDateTime,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphZebraFotaDeployment[]]
        $ZebraFotaDeployments,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphCloudPcConnectivityIssue[]]
        $CloudPcConnectivityIssues,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsImpactingProcess[]]
        $UserExperienceAnalyticsImpactingProcess,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsDeviceStartupHistory[]]
        $UserExperienceAnalyticsDeviceStartupHistory,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementDerivedCredentialSettings[]]
        $DerivedCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsBatteryHealthModelPerformance[]]
        $UserExperienceAnalyticsBatteryHealthModelPerformance,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceCompliancePolicy[]]
        $DeviceCompliancePolicies,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAndroidForWorkAppConfigurationSchema[]]
        $AndroidForWorkAppConfigurationSchemas,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementSettingDefinition[]]
        $SettingDefinitions,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsSettings]
        $UserExperienceAnalyticsSettings,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAndroidManagedStoreAccountEnterpriseSettings]
        $AndroidManagedStoreAccountEnterpriseSettings,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphManagedDevice[]]
        $ManagedDevices,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppleUserInitiatedEnrollmentProfile[]]
        $AppleUserInitiatedEnrollmentProfiles,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceConfigurationDeviceStateSummary]
        $DeviceConfigurationDeviceStateSummaries,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsWorkFromAnywhereHardwareReadinessMetric]
        $UserExperienceAnalyticsWorkFromAnywhereHardwareReadinessMetric,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementReusablePolicySetting[]]
        $ReusablePolicySettings,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsAppHealthAppPerformanceByAppVersionDetails[]]
        $UserExperienceAnalyticsAppHealthApplicationPerformanceByAppVersionDetails,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOemWarrantyInformationOnboarding[]]
        $OemWarrantyInformationOnboarding,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsRemoteConnection[]]
        $UserExperienceAnalyticsRemoteConnection,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementConfigurationSettingDefinition[]]
        $ConfigurationSettings,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsDeviceScope]
        $UserExperienceAnalyticsDeviceScope,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsNotAutopilotReadyDevice[]]
        $UserExperienceAnalyticsNotAutopilotReadyDevice,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsCategory[]]
        $UserExperienceAnalyticsCategories,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphRestrictedAppsViolation[]]
        $DeviceConfigurationRestrictedAppsViolations,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsDeviceStartupProcess[]]
        $UserExperienceAnalyticsDeviceStartupProcesses,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphMobileAppTroubleshootingEvent[]]
        $MobileAppTroubleshootingEvents,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOrganizationalMessageGuidedContent[]]
        $OrganizationalMessageGuidedContents,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphChromeOSOnboardingSettings[]]
        $ChromeOSOnboardingSettings,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphRoleDefinition[]]
        $RoleDefinitions,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceShellScript[]]
        $DeviceShellScripts,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphImportedWindowsAutopilotDeviceIdentity[]]
        $ImportedWindowsAutopilotDeviceIdentities,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsAppHealthAppPerformanceByAppVersion[]]
        $UserExperienceAnalyticsAppHealthApplicationPerformanceByAppVersion,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceCompliancePolicySettingStateSummary[]]
        $DeviceCompliancePolicySettingStateSummaries,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAndroidForWorkEnrollmentProfile[]]
        $AndroidForWorkEnrollmentProfiles,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphComanagementEligibleDevice[]]
        $ComanagementEligibleDevices,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsRegressionSummary]
        $UserExperienceAnalyticsRegressionSummary,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphNotificationMessageTemplate[]]
        $NotificationMessageTemplates,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphIntuneBrand]
        $IntuneBrand,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsOverview]
        $UserExperienceAnalyticsOverview,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementConfigurationSettingTemplate[]]
        $TemplateSettings,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphRemoteActionAudit[]]
        $RemoteActionAudits,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphWindowsUpdateCatalogItem[]]
        $WindowsUpdateCatalogItems,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsAppHealthDevicePerformanceDetails[]]
        $UserExperienceAnalyticsAppHealthDevicePerformanceDetails,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAdminConsent]
        $AdminConsent,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $LegacyPcManangementEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceHealthScript[]]
        $DeviceHealthScripts,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphManagedDevice1[]]
        $ComanagedDevices,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphGroupPolicyCategory[]]
        $GroupPolicyCategories,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceAndAppManagementAssignmentFilter[]]
        $AssignmentFilters,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceConfigurationUserStateSummary]
        $DeviceConfigurationUserStateSummaries,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphManagedAllDeviceCertificateState[]]
        $DeviceConfigurationsAllManagedDeviceCertificateStates,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsAppHealthDevicePerformance[]]
        $UserExperienceAnalyticsAppHealthDevicePerformance,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOrganizationalMessageDetail[]]
        $OrganizationalMessageDetails,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceCustomAttributeShellScript[]]
        $DeviceCustomAttributeShellScripts,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsAppHealthDeviceModelPerformance[]]
        $UserExperienceAnalyticsAppHealthDeviceModelPerformance,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphZebraFotaArtifact[]]
        $ZebraFotaArtifacts,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphImportedDeviceIdentity[]]
        $ImportedDeviceIdentities,

        [Parameter()]
        [System.Int32]
        $MaximumDepTokens,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphSoftwareUpdateStatusSummary]
        $SoftwareUpdateStatusSummary,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphWindowsQualityUpdateProfile[]]
        $WindowsQualityUpdateProfiles,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $UnlicensedAdminstratorsEnabled,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphNdesConnector[]]
        $NdesConnectors,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphMicrosoftTunnelServerLogCollectionResponse[]]
        $MicrosoftTunnelServerLogCollectionResponses,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsBatteryHealthOSPerformance[]]
        $UserExperienceAnalyticsBatteryHealthOSPerformance,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserPfxCertificate[]]
        $UserPfxCertificates,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphWindowsAutopilotDeviceIdentity[]]
        $WindowsAutopilotDeviceIdentities,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsDeviceStartupProcessPerformance[]]
        $UserExperienceAnalyticsDeviceStartupProcessPerformance,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphIntuneBrandingProfile[]]
        $IntuneBrandingProfiles,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementDomainJoinConnector[]]
        $DomainJoinConnectors,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementSettingCategory[]]
        $Categories,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementExchangeOnPremisesPolicy[]]
        $ExchangeOnPremisesPolicies,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceCompliancePolicyDeviceStateSummary]
        $DeviceCompliancePolicyDeviceStateSummary,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserExperienceAnalyticsDevicePerformance[]]
        $UserExperienceAnalyticsDevicePerformance,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceComplianceScript[]]
        $DeviceComplianceScripts,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.DeviceManagementSubscriptions]
        $Subscriptions,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphManagedDeviceCleanupSettings]
        $ManagedDeviceCleanupSettings,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDataSharingConsent[]]
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
        [Microsoft.Graph.PowerShell.Models.IDeviceManagementIdentity]
        $InputObject,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceCategory]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceComplianceUserStatus[]]
        $UserStatuses,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.DateTime]
        $LastModifiedDateTime,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceCompliancePolicyAssignment[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceComplianceDeviceOverview]
        $DeviceStatusOverview,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IDeviceManagementIdentity]
        $InputObject,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceComplianceUserOverview]
        $UserStatusOverview,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.Int32]
        $Version,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceComplianceDeviceStatus[]]
        $DeviceStatuses,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceComplianceScheduledActionForRule[]]
        $ScheduledActionsForRule,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceCompliancePolicy]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphSettingStateDeviceSummary[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceConfigurationUserStatus[]]
        $UserStatuses,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.DateTime]
        $LastModifiedDateTime,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceConfigurationAssignment[]]
        $Assignments,

        [Parameter()]
        [System.DateTime]
        $CreatedDateTime,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceConfigurationDeviceStatus[]]
        $DeviceStatuses,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceConfigurationDeviceOverview]
        $DeviceStatusOverview,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IDeviceManagementIdentity]
        $InputObject,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $SupportsScopeTags,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementApplicabilityRuleOSVersion]
        $DeviceManagementApplicabilityRuleOSVersion,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceConfigurationUserOverview]
        $UserStatusOverview,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceConfigurationGroupAssignment[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphSettingStateDeviceSummary[]]
        $DeviceSettingStateSummaries,

        [Parameter()]
        [System.String]
        $DeviceConfigurationId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementApplicabilityRuleOSEdition]
        $DeviceManagementApplicabilityRuleOSEdition,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceConfiguration]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementApplicabilityRuleDeviceMode]
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
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

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
        [Microsoft.Graph.PowerShell.Models.IDeviceManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IDeviceManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IDeviceManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IDeviceManagementIdentity]
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
function Get-MgDeviceManagementConfigurationSetting
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IDeviceManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IDeviceManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IDeviceManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceAndAppManagementAssignmentFilter]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementConfigurationPolicyAssignment[]]
        $Assignments,

        [Parameter()]
        [System.DateTime]
        $CreatedDateTime,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementConfigurationSetting[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementConfigurationPolicyTemplateReference]
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
        [System.Management.Automation.SwitchParameter]
        $IsAssigned,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $CreationSource,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementConfigurationPolicy]
        $BodyParameter,

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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementIntentAssignment[]]
        $Assignments,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementSettingInstance[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementIntentDeviceSettingStateSummary[]]
        $DeviceSettingStateSummaries,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementIntentDeviceState[]]
        $DeviceStates,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementIntentSettingCategory[]]
        $Categories,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementIntentDeviceStateSummary]
        $DeviceStateSummary,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementIntent]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementIntentUserState[]]
        $UserStates,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementIntentUserStateSummary]
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
        [Microsoft.Graph.PowerShell.Models.IDeviceManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IDeviceManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IDeviceManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IDeviceManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceAndAppManagementAssignmentFilter]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementConfigurationPolicyAssignment[]]
        $Assignments,

        [Parameter()]
        [System.DateTime]
        $CreatedDateTime,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementConfigurationSetting[]]
        $Settings,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IDeviceManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementConfigurationPolicyTemplateReference]
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
        [System.Management.Automation.SwitchParameter]
        $IsAssigned,

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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementConfigurationPolicy]
        $BodyParameter,

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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceAndAppManagementAssignmentTarget1]
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
        [Microsoft.Graph.PowerShell.Models.IDeviceManagementIdentity]
        $InputObject,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.DeviceAndAppManagementAssignmentSource]
        $Source,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementConfigurationPolicyAssignment]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementIntentAssignment[]]
        $Assignments,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementSettingInstance[]]
        $Settings,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IDeviceManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementIntentDeviceSettingStateSummary[]]
        $DeviceSettingStateSummaries,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementIntentDeviceState[]]
        $DeviceStates,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementIntentSettingCategory[]]
        $Categories,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementIntentDeviceStateSummary]
        $DeviceStateSummary,

        [Parameter()]
        [System.String]
        $DeviceManagementIntentId,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementIntent]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementIntentUserState[]]
        $UserStates,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementIntentUserStateSummary]
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
        [Microsoft.Graph.PowerShell.Models.IDeviceManagementIdentity]
        $InputObject,

        [Parameter()]
        [System.String]
        $DeviceManagementIntentId,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementSettingInstance]
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
        [Microsoft.Graph.PowerShell.Models.IDeviceManagementEnrolmentIdentity]
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
function Get-MgRoleManagementDirectoryRoleDefinition
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IDeviceManagementEnrolmentIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphEnrollmentConfigurationAssignment[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceEnrollmentConfiguration1]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUnifiedRoleDefinition1]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUnifiedRoleDefinition1[]]
        $InheritsPermissionsFrom,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUnifiedRolePermission[]]
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
        [Microsoft.Graph.PowerShell.Models.IDeviceManagementEnrolmentIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IDeviceManagementEnrolmentIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphEnrollmentConfigurationAssignment[]]
        $Assignments,

        [Parameter()]
        [System.DateTime]
        $CreatedDateTime,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IDeviceManagementEnrolmentIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceEnrollmentConfiguration1]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphRoleManagement]
        $BodyParameter,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphRbacApplicationMultiple]
        $DeviceManagement,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphRbacApplication1]
        $EntitlementManagement,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphRbacApplication1]
        $Directory,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphRbacApplicationMultiple]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUnifiedRoleAssignmentScheduleRequest[]]
        $RoleAssignmentScheduleRequests,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUnifiedRoleAssignment1[]]
        $TransitiveRoleAssignments,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUnifiedRoleEligibilitySchedule[]]
        $RoleEligibilitySchedules,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUnifiedRbacResourceNamespace[]]
        $ResourceNamespaces,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUnifiedRoleDefinition1[]]
        $RoleDefinitions,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUnifiedRoleEligibilityScheduleInstance[]]
        $RoleEligibilityScheduleInstances,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUnifiedRoleEligibilityScheduleRequest[]]
        $RoleEligibilityScheduleRequests,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUnifiedRoleAssignmentSchedule[]]
        $RoleAssignmentSchedules,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUnifiedRoleAssignment[]]
        $RoleAssignments,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphRbacApplication1]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUnifiedRoleAssignmentScheduleInstance[]]
        $RoleAssignmentScheduleInstances,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphApproval[]]
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
        [Microsoft.Graph.PowerShell.Models.IDeviceManagementEnrolmentIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUnifiedRoleDefinition1]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUnifiedRoleDefinition1[]]
        $InheritsPermissionsFrom,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUnifiedRolePermission[]]
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
        [Microsoft.Graph.PowerShell.Models.IPathsXzr66BDeviceappmanagementTargetedmanagedappconfigurationsTargetedmanagedappconfigurationIdMicrosoftGraphTargetappsPostRequestbodyContentApplicationJsonSchema]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphManagedMobileApp[]]
        $Apps,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IDevicesCorporateManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphKeyValuePair[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphManagedAppPolicyDeploymentSummary]
        $DeploymentSummary,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphManagedMobileApp[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphTargetedManagedAppPolicyAssignment1[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAndroidManagedAppProtection1]
        $BodyParameter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $DeviceLockRequired,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphKeyValuePair[]]
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
        [Microsoft.Graph.PowerShell.Models.IPathsZxn05FDeviceappmanagementTargetedmanagedappconfigurationsTargetedmanagedappconfigurationIdMicrosoftGraphAssignPostRequestbodyContentApplicationJsonSchema]
        $BodyParameter,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphTargetedManagedAppPolicyAssignment1[]]
        $Assignments,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IDevicesCorporateManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphTargetedManagedAppConfiguration1[]]
        $TargetedManagedAppConfigurations,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphManagedEBook1[]]
        $ManagedEBooks,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphMobileApp1[]]
        $MobileApps,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphEnterpriseCodeSigningCertificate[]]
        $EnterpriseCodeSigningCertificates,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphManagedAppPolicy1[]]
        $ManagedAppPolicies,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceAppManagementTask[]]
        $DeviceAppManagementTasks,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphManagedAppStatus[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphManagedAppRegistration1[]]
        $ManagedAppRegistrations,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphWindowsManagedAppProtection[]]
        $WindowsManagedAppProtections,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDefaultManagedAppProtection1[]]
        $DefaultManagedAppProtections,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsEnabledForMicrosoftStoreForBusiness,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphMobileAppCategory[]]
        $MobileAppCategories,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphManagedEBookCategory[]]
        $ManagedEBookCategories,

        [Parameter()]
        [System.DateTime]
        $MicrosoftStoreForBusinessLastCompletedApplicationSyncTime,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphSymantecCodeSigningCertificate]
        $SymantecCodeSigningCertificate,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphIosManagedAppProtection1[]]
        $IosManagedAppProtections,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphIosLobAppProvisioningConfiguration[]]
        $IosLobAppProvisioningConfigurations,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceAppManagement1]
        $BodyParameter,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphWindowsInformationProtectionWipeAction[]]
        $WindowsInformationProtectionWipeActions,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphMdmWindowsInformationProtectionPolicy1[]]
        $MdmWindowsInformationProtectionPolicies,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphWindowsManagementApp]
        $WindowsManagementApp,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphSideLoadingKey[]]
        $SideLoadingKeys,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPolicySet[]]
        $PolicySets,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphWindowsInformationProtectionDeviceRegistration[]]
        $WindowsInformationProtectionDeviceRegistrations,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphVppToken1[]]
        $VppTokens,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphWindowsInformationProtectionPolicy1[]]
        $WindowsInformationProtectionPolicies,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.MicrosoftStoreForBusinessPortalSelectionOptions]
        $MicrosoftStoreForBusinessPortalSelection,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAndroidManagedAppProtection1[]]
        $AndroidManagedAppProtections,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [System.DateTime]
        $MicrosoftStoreForBusinessLastSuccessfulSyncDateTime,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphManagedDeviceMobileAppConfiguration1[]]
        $MobileAppConfigurations,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphWindowsDefenderApplicationControlSupplementalPolicy[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphManagedAppPolicyDeploymentSummary]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphKeyValuePair[]]
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
        [Microsoft.Graph.PowerShell.Models.IDevicesCorporateManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphManagedMobileApp[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphTargetedManagedAppPolicyAssignment1[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAndroidManagedAppProtection1]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphKeyValuePair[]]
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
        [Microsoft.Graph.PowerShell.Models.IDevicesCorporateManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IDevicesCorporateManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IDevicesCorporateManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphTargetedManagedAppPolicyAssignment[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphManagedAppPolicyDeploymentSummary]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphKeyValuePair[]]
        $CustomSettings,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphTargetedManagedAppConfiguration]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphManagedMobileApp[]]
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
        [Microsoft.Graph.PowerShell.Models.IDevicesCorporateManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IDevicesCorporateManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IDevicesCorporateManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphTargetedManagedAppConfiguration[]]
        $TargetedManagedAppConfigurations,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPolicySet[]]
        $PolicySets,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphManagedEBook[]]
        $ManagedEBooks,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphMobileApp[]]
        $MobileApps,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphEnterpriseCodeSigningCertificate[]]
        $EnterpriseCodeSigningCertificates,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphManagedAppPolicy[]]
        $ManagedAppPolicies,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceAppManagementTask[]]
        $DeviceAppManagementTasks,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphManagedAppStatus[]]
        $ManagedAppStatuses,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphWindowsManagementApp]
        $WindowsManagementApp,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphManagedAppRegistration[]]
        $ManagedAppRegistrations,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphWindowsManagedAppProtection[]]
        $WindowsManagedAppProtections,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDefaultManagedAppProtection[]]
        $DefaultManagedAppProtections,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsEnabledForMicrosoftStoreForBusiness,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphWindowsInformationProtectionWipeAction[]]
        $WindowsInformationProtectionWipeActions,

        [Parameter()]
        [System.String]
        $MicrosoftStoreForBusinessLanguage,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphManagedEBookCategory[]]
        $ManagedEBookCategories,

        [Parameter()]
        [System.DateTime]
        $MicrosoftStoreForBusinessLastCompletedApplicationSyncTime,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphSymantecCodeSigningCertificate]
        $SymantecCodeSigningCertificate,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphIosManagedAppProtection[]]
        $IosManagedAppProtections,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphIosLobAppProvisioningConfiguration[]]
        $IosLobAppProvisioningConfigurations,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceAppManagement]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphMobileAppCategory[]]
        $MobileAppCategories,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphSideLoadingKey[]]
        $SideLoadingKeys,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphWindowsInformationProtectionDeviceRegistration[]]
        $WindowsInformationProtectionDeviceRegistrations,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphVppToken[]]
        $VppTokens,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphWindowsInformationProtectionPolicy[]]
        $WindowsInformationProtectionPolicies,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Support.MicrosoftStoreForBusinessPortalSelectionOptions]
        $MicrosoftStoreForBusinessPortalSelection,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAndroidManagedAppProtection[]]
        $AndroidManagedAppProtections,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphMdmWindowsInformationProtectionPolicy[]]
        $MdmWindowsInformationProtectionPolicies,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphManagedDeviceMobileAppConfiguration[]]
        $MobileAppConfigurations,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphWindowsDefenderApplicationControlSupplementalPolicy[]]
        $WdacSupplementalPolicies
    )
}
function Update-MgDeviceAppManagementTargetedManagedAppConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphManagedAppPolicyDeploymentSummary]
        $DeploymentSummary,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.DateTime]
        $LastModifiedDateTime,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphTargetedManagedAppPolicyAssignment[]]
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
        [Microsoft.Graph.PowerShell.Models.IDevicesCorporateManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphKeyValuePair[]]
        $CustomSettings,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphTargetedManagedAppConfiguration]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphManagedMobileApp[]]
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
        [Microsoft.Graph.PowerShell.Models.IGroupsIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IGroupsIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphResourceSpecificPermissionGrant[]]
        $PermissionGrants,

        [Parameter()]
        [System.String]
        $CreatedByAppId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphSite1[]]
        $Sites,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppRoleAssignment[]]
        $AppRoleAssignments,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $SecurityEnabled,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAssignedLabel[]]
        $AssignedLabels,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphCalendar]
        $Calendar,

        [Parameter()]
        [System.String]
        $SecurityIdentifier,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAssignedLicense[]]
        $AssignedLicenses,

        [Parameter()]
        [System.String]
        $OnPremisesSamAccountName,

        [Parameter()]
        [System.DateTime]
        $RenewedDateTime,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $RejectedSenders,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphExtension[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOnPremisesProvisioningError[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $TransitiveMembers,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $HideFromAddressLists,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPlannerGroup]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $Owners,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphGroupLifecyclePolicy[]]
        $GroupLifecyclePolicies,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphLicenseProcessingState]
        $LicenseProcessingState,

        [Parameter()]
        [System.String]
        $OnPremisesDomainName,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphGroupSetting[]]
        $Settings,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $AcceptedSenders,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOnenote]
        $Onenote,

        [Parameter()]
        [System.String]
        $MembershipRuleProcessingState,

        [Parameter()]
        [System.String]
        $AccessType,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $MemberOf,

        [Parameter()]
        [System.String[]]
        $ResourceProvisioningOptions,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $MailEnabled,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDrive1[]]
        $Drives,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowExternalSenders,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $MembersWithLicenseErrors,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphGroupWritebackConfiguration]
        $WritebackConfiguration,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphProfilePhoto]
        $Photo,

        [Parameter()]
        [System.String]
        $Theme,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphEvent1[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDrive1]
        $Drive,

        [Parameter()]
        [System.String]
        $OnPremisesNetBiosName,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphEvent1[]]
        $CalendarView,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphProfilePhoto[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphMembershipRuleProcessingStatus]
        $MembershipRuleProcessingStatus,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsSubscribedByMail,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject]
        $CreatedOnBehalfOf,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphConversationThread[]]
        $Threads,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphTeam1]
        $Team,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphConversation[]]
        $Conversations,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphEndpoint[]]
        $Endpoints,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphGroup]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphGroupLifecyclePolicy]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject]
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
        [Microsoft.Graph.PowerShell.Models.IGroupsIdentity]
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
        [System.Collections.Hashtable]
        $BodyParameter,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IGroupsIdentity]
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
function New-MgGroupOwner
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject]
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
        [Microsoft.Graph.PowerShell.Models.IGroupsIdentity]
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
        [System.Collections.Hashtable]
        $BodyParameter,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IGroupsIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IGroupsIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IGroupsIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IGroupsIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IGroupsIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IPaths6Fg5LiGroupsGroupIdMicrosoftGraphAssignlicensePostRequestbodyContentApplicationJsonSchema]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAssignedLicense[]]
        $AddLicenses,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IGroupsIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IGroupsIdentity]
        $InputObject,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphResourceSpecificPermissionGrant[]]
        $PermissionGrants,

        [Parameter()]
        [System.String]
        $CreatedByAppId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphSite1[]]
        $Sites,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppRoleAssignment[]]
        $AppRoleAssignments,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $SecurityEnabled,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAssignedLabel[]]
        $AssignedLabels,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphCalendar]
        $Calendar,

        [Parameter()]
        [System.String]
        $SecurityIdentifier,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAssignedLicense[]]
        $AssignedLicenses,

        [Parameter()]
        [System.String]
        $OnPremisesSamAccountName,

        [Parameter()]
        [System.DateTime]
        $RenewedDateTime,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $RejectedSenders,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphExtension[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOnPremisesProvisioningError[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $TransitiveMembers,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $HideFromAddressLists,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPlannerGroup]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $Owners,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphGroupLifecyclePolicy[]]
        $GroupLifecyclePolicies,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphLicenseProcessingState]
        $LicenseProcessingState,

        [Parameter()]
        [System.String]
        $PreferredDataLocation,

        [Parameter()]
        [System.String]
        $OnPremisesDomainName,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphGroupSetting[]]
        $Settings,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $AcceptedSenders,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOnenote]
        $Onenote,

        [Parameter()]
        [System.String]
        $MembershipRuleProcessingState,

        [Parameter()]
        [System.String]
        $AccessType,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $MemberOf,

        [Parameter()]
        [System.String[]]
        $ResourceProvisioningOptions,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $MailEnabled,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDrive1[]]
        $Drives,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowExternalSenders,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $MembersWithLicenseErrors,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphGroupWritebackConfiguration]
        $WritebackConfiguration,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphProfilePhoto]
        $Photo,

        [Parameter()]
        [System.String]
        $Theme,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphEvent1[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDrive1]
        $Drive,

        [Parameter()]
        [System.String]
        $OnPremisesNetBiosName,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphEvent1[]]
        $CalendarView,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphProfilePhoto[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphMembershipRuleProcessingStatus]
        $MembershipRuleProcessingStatus,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IsSubscribedByMail,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject]
        $CreatedOnBehalfOf,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphConversationThread[]]
        $Threads,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphTeam1]
        $Team,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphConversation[]]
        $Conversations,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphEndpoint[]]
        $Endpoints,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphGroup]
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
        [Microsoft.Graph.PowerShell.Models.IGroupsIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphGroupLifecyclePolicy]
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
        [Microsoft.Graph.PowerShell.Models.IIdentityDirectoryManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IIdentityDirectoryManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IIdentityDirectoryManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IIdentityDirectoryManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IIdentityDirectoryManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUsageRight[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphExtension[]]
        $Extensions,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAlternativeSecurityId[]]
        $AlternativeSecurityIds,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphCommand[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOnPremisesExtensionAttributes]
        $ExtensionAttributes,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $OnPremisesSyncEnabled,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $RegisteredOwners,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDevice]
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
        [Microsoft.Graph.PowerShell.Models.IIdentityDirectoryManagementIdentity]
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
function Update-MgDevice
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IIdentityDirectoryManagementIdentity]
        $InputObject,

        [Parameter()]
        [System.DateTime]
        $RegistrationDateTime,

        [Parameter()]
        [System.String]
        $Status,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUsageRight[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphExtension[]]
        $Extensions,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAlternativeSecurityId[]]
        $AlternativeSecurityIds,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphCommand[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOnPremisesExtensionAttributes]
        $ExtensionAttributes,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $OnPremisesSyncEnabled,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $RegisteredOwners,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDevice]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphInboundSharedUserProfile[]]
        $InboundSharedUserProfiles,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphSharedEmailDomain[]]
        $SharedEmailDomains,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOutboundSharedUserProfile[]]
        $OutboundSharedUserProfiles,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphIdentityProviderBase[]]
        $FederationConfigurations,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAdministrativeUnit[]]
        $AdministrativeUnits,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphRecommendation[]]
        $Recommendations,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAttributeSet[]]
        $AttributeSets,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectory1]
        $BodyParameter,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $DeletedItems,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphRecommendationResource[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphCustomSecurityAttributeDefinition[]]
        $CustomSecurityAttributeDefinitions,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphFeatureRolloutPolicy[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphVerifiedDomain[]]
        $VerifiedDomains,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphCertificateConnectorSetting]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOrganizationSettings]
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
        [Microsoft.Graph.PowerShell.Models.IIdentityDirectoryManagementIdentity]
        $InputObject,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAssignedPlan[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOrganization1]
        $BodyParameter,

        [Parameter()]
        [System.String[]]
        $SecurityComplianceNotificationMails,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphCertificateBasedAuthConfiguration[]]
        $CertificateBasedAuthConfiguration,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPrivacyProfile]
        $PrivacyProfile,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphExtension[]]
        $Extensions,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphProvisionedPlan[]]
        $ProvisionedPlans,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectorySizeQuota]
        $DirectorySizeQuota,

        [Parameter()]
        [System.String[]]
        $TechnicalNotificationMails,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOrganizationalBranding]
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
        [Microsoft.Graph.PowerShell.Models.IIdentityDirectoryManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphSettingValue[]]
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
        [Microsoft.Graph.PowerShell.Models.IIdentityDirectoryManagementIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphSettingValue[]]
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
        [Microsoft.Graph.PowerShell.Models.IIdentityGovernanceIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IIdentitySignInsIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IIdentitySignInsIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IIdentitySignInsIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IIdentitySignInsIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IIdentitySignInsIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IIdentitySignInsIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IIdentitySignInsIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IIdentitySignInsIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphConditionalAccessSessionControls]
        $SessionControls,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.String]
        $State,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphConditionalAccessConditionSet]
        $Conditions,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphConditionalAccessPolicy]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphConditionalAccessGrantControls]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
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
        [Microsoft.Graph.PowerShell.Models.IIdentitySignInsIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IIdentitySignInsIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IIdentitySignInsIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IIdentitySignInsIdentity]
        $InputObject,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ProxyUseDefaultCredentials,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphConditionalAccessSessionControls]
        $SessionControls,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [System.String]
        $State,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphConditionalAccessConditionSet]
        $Conditions,

        [Parameter()]
        [System.String]
        $ConditionalAccessPolicyId,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphConditionalAccessPolicy]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphConditionalAccessGrantControls]
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
        [Microsoft.Graph.PowerShell.Models.IIdentitySignInsIdentity]
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
        $GuestUserRoleId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowedToSignUpEmailBasedSubscriptions,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDefaultUserRoleOverride[]]
        $DefaultUserRoleOverrides,

        [Parameter()]
        [System.String]
        $AllowInvitesFrom,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAuthorizationPolicy]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDefaultUserRolePermissions]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphIdentitySecurityDefaultsEnforcementPolicy]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUnifiedRoleManagementPolicyRule[]]
        $EffectiveRules,

        [Parameter()]
        [System.String]
        $UnifiedRoleManagementPolicyId,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IIdentitySignInsIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphIdentity]
        $LastModifiedBy,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUnifiedRoleManagementPolicy]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUnifiedRoleManagementPolicyRule[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUnifiedRoleManagementPolicyRuleTarget]
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
        [Microsoft.Graph.PowerShell.Models.IIdentitySignInsIdentity]
        $InputObject,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUnifiedRoleManagementPolicyRule]
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
        [Microsoft.Graph.PowerShell.Models.IIdentitySignInsIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
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
        [Microsoft.Graph.PowerShell.Models.IPlannerIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IPlannerIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IPlannerIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPlannerTask[]]
        $Tasks,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPlannerBucket]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPlannerBucket[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPlannerTask[]]
        $Tasks,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPlannerPlanContainer]
        $Container,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphIdentitySet]
        $CreatedBy,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPlannerPlan]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Title,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPlannerPlanDetails]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPlannerBucket[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPlannerTask[]]
        $Tasks,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPlannerRoster[]]
        $Rosters,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPlannerPlan[]]
        $Plans,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPlanner1]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPlannerBucket[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPlannerTask[]]
        $Tasks,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPlannerPlanContainer]
        $Container,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphIdentitySet]
        $CreatedBy,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IPlannerIdentity]
        $InputObject,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPlannerPlan]
        $BodyParameter,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPlannerPlanDetails]
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
        [Microsoft.Graph.PowerShell.Models.ITeamsIdentity]
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
        [Microsoft.Graph.PowerShell.Models.ITeamsIdentity]
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
        [Microsoft.Graph.PowerShell.Models.ITeamsIdentity]
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
        [Microsoft.Graph.PowerShell.Models.ITeamsIdentity]
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
        [Microsoft.Graph.PowerShell.Models.ITeamsIdentity]
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
        [Microsoft.Graph.PowerShell.Models.ITeamsIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IUsersIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IUsersIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphTodo]
        $Todo,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOfficeGraphInsights]
        $Insights,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOnlineMeeting1[]]
        $OnlineMeetings,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAssignedPlan[]]
        $AssignedPlans,

        [Parameter()]
        [System.String]
        $ExternalUserState,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUser]
        $BodyParameter,

        [Parameter()]
        [System.DateTime]
        $EmployeeHireDate,

        [Parameter()]
        [System.String]
        $OnPremisesImmutableId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $RegisteredDevices,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppRoleAssignment1[]]
        $AppRoleAssignments,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphInformationProtection]
        $InformationProtection,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphApproval[]]
        $Approvals,

        [Parameter()]
        [System.DateTime]
        $ExternalUserStateChangeDateTime,

        [Parameter()]
        [System.String[]]
        $ImAddresses,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceEnrollmentConfiguration[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphExtension[]]
        $Extensions,

        [Parameter()]
        [System.DateTime]
        $SignInSessionsValidFromDateTime,

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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphMobileAppIntentAndState[]]
        $MobileAppIntentAndStates,

        [Parameter()]
        [System.String[]]
        $InfoCatalogs,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphChat1[]]
        $Chats,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphEmployeeOrgData]
        $EmployeeOrgData,

        [Parameter()]
        [System.DateTime]
        $LastPasswordChangeDateTime,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject]
        $Manager,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphInferenceClassification]
        $InferenceClassification,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphCalendarGroup1[]]
        $CalendarGroups,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphMailFolder1[]]
        $MailFolders,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphScopedRoleMembership[]]
        $ScopedRoleMemberOf,

        [Parameter()]
        [System.String]
        $ConsentProvidedForMinor,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphSignInActivity]
        $SignInActivity,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAgreementAcceptance[]]
        $AgreementAcceptances,

        [Parameter()]
        [System.String]
        $EmployeeType,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $OwnedObjects,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAuthorizationInfo]
        $AuthorizationInfo,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphProfilePhoto[]]
        $Photos,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOAuth2PermissionGrant1[]]
        $Oauth2PermissionGrants,

        [Parameter()]
        [System.String]
        $PreferredDataLocation,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphMailboxSettings1]
        $MailboxSettings,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphNotification[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserSettings1]
        $Settings,

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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphContactFolder1[]]
        $ContactFolders,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelinePrepend,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPerson1[]]
        $People,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphWindowsInformationProtectionDeviceRegistration[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAccessReviewInstance[]]
        $PendingAccessReviewInstances,

        [Parameter()]
        [System.DateTime]
        $OnPremisesLastSyncDateTime,

        [Parameter()]
        [System.String]
        $AgeGroup,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPlannerUser1]
        $Planner,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphContact1[]]
        $Contacts,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphCalendar1[]]
        $Calendars,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDrive1]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserTeamwork1]
        $Teamwork,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphManagedAppRegistration1[]]
        $ManagedAppRegistrations,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphMessage1[]]
        $Messages,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserPrint]
        $Print,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphSecurity]
        $Security,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphObjectIdentity[]]
        $Identities,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphTeam1[]]
        $JoinedTeams,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphTasks]
        $Tasks,

        [Parameter()]
        [System.String]
        $MySite,

        [Parameter()]
        [System.String[]]
        $BusinessPhones,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserAnalytics]
        $Analytics,

        [Parameter()]
        [System.String[]]
        $ProxyAddresses,

        [Parameter()]
        [System.String]
        $OfficeLocation,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPresence1]
        $Presence,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPasswordProfile]
        $PasswordProfile,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppConsentRequest[]]
        $AppConsentRequestsForApproval,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $TransitiveMemberOf,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphManagedDevice1[]]
        $ManagedDevices,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $CreatedObjects,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphProfilePhoto]
        $Photo,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphLicenseDetails[]]
        $LicenseDetails,

        [Parameter()]
        [System.String]
        $StreetAddress,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphGroup[]]
        $JoinedGroups,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphCloudPc[]]
        $CloudPCs,

        [Parameter()]
        [System.Collections.Hashtable]
        $CustomSecurityAttributes,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphEvent1[]]
        $CalendarView,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOnenote1]
        $Onenote,

        [Parameter()]
        [System.String]
        $SecurityIdentifier,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphServicePrincipal[]]
        $AppRoleAssignedResources,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $OwnedDevices,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphSite1[]]
        $FollowedSites,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDrive1[]]
        $Drives,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphMobileAppTroubleshootingEvent[]]
        $MobileAppTroubleshootingEvents,

        [Parameter()]
        [System.String[]]
        $Interests,

        [Parameter()]
        [System.String]
        $LegalAgeGroupClassification,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.String]
        $OnPremisesSecurityIdentifier,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Runtime.SendAsyncStep[]]
        $HttpPipelineAppend,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphCalendar1]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $MemberOf,

        [Parameter()]
        [System.String]
        $EmployeeId,

        [Parameter()]
        [System.String]
        $PostalCode,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAssignedLicense[]]
        $AssignedLicenses,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphEvent1[]]
        $Events,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceKey[]]
        $DeviceKeys,

        [Parameter()]
        [System.String]
        $UserPrincipalName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Break,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUsageRight[]]
        $UsageRights,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphProvisionedPlan[]]
        $ProvisionedPlans,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOnPremisesProvisioningError[]]
        $OnPremisesProvisioningErrors,

        [Parameter()]
        [System.String]
        $MailNickname,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOnPremisesExtensionAttributes]
        $OnPremisesExtensionAttributes,

        [Parameter()]
        [System.String[]]
        $PastProjects,

        [Parameter()]
        [System.DateTime]
        $CreatedDateTime,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $DirectReports,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAuthentication1]
        $Authentication,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $TransitiveReports,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphLicenseAssignmentState[]]
        $LicenseAssignmentStates,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserActivity1[]]
        $Activities,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDevice[]]
        $Devices,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOutlookUser1]
        $Outlook,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementTroubleshootingEvent1[]]
        $DeviceManagementTroubleshootingEvents,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphProfile]
        $Profile,

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
        [Microsoft.Graph.PowerShell.Models.IUsersIdentity]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphTodo]
        $Todo,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOfficeGraphInsights]
        $Insights,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOnlineMeeting1[]]
        $OnlineMeetings,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IUsersIdentity]
        $InputObject,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAssignedPlan[]]
        $AssignedPlans,

        [Parameter()]
        [System.String]
        $ExternalUserState,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUser]
        $BodyParameter,

        [Parameter()]
        [System.DateTime]
        $EmployeeHireDate,

        [Parameter()]
        [System.String]
        $OnPremisesImmutableId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $RegisteredDevices,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppRoleAssignment1[]]
        $AppRoleAssignments,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphInformationProtection]
        $InformationProtection,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphApproval[]]
        $Approvals,

        [Parameter()]
        [System.DateTime]
        $ExternalUserStateChangeDateTime,

        [Parameter()]
        [System.String[]]
        $ImAddresses,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceEnrollmentConfiguration[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphExtension[]]
        $Extensions,

        [Parameter()]
        [System.DateTime]
        $SignInSessionsValidFromDateTime,

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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphMobileAppIntentAndState[]]
        $MobileAppIntentAndStates,

        [Parameter()]
        [System.String[]]
        $InfoCatalogs,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphChat1[]]
        $Chats,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphEmployeeOrgData]
        $EmployeeOrgData,

        [Parameter()]
        [System.DateTime]
        $LastPasswordChangeDateTime,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject]
        $Manager,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphInferenceClassification]
        $InferenceClassification,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphCalendarGroup1[]]
        $CalendarGroups,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphMailFolder1[]]
        $MailFolders,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphScopedRoleMembership[]]
        $ScopedRoleMemberOf,

        [Parameter()]
        [System.String]
        $ConsentProvidedForMinor,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphSignInActivity]
        $SignInActivity,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAgreementAcceptance[]]
        $AgreementAcceptances,

        [Parameter()]
        [System.String]
        $EmployeeType,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $OwnedObjects,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAuthorizationInfo]
        $AuthorizationInfo,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphProfilePhoto[]]
        $Photos,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOAuth2PermissionGrant1[]]
        $Oauth2PermissionGrants,

        [Parameter()]
        [System.String]
        $PreferredDataLocation,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphMailboxSettings1]
        $MailboxSettings,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphNotification[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserSettings1]
        $Settings,

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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphContactFolder1[]]
        $ContactFolders,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPerson1[]]
        $People,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphWindowsInformationProtectionDeviceRegistration[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAccessReviewInstance[]]
        $PendingAccessReviewInstances,

        [Parameter()]
        [System.DateTime]
        $OnPremisesLastSyncDateTime,

        [Parameter()]
        [System.String]
        $AgeGroup,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPlannerUser1]
        $Planner,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphContact1[]]
        $Contacts,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphCalendar1[]]
        $Calendars,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDrive1]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserTeamwork1]
        $Teamwork,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphManagedAppRegistration1[]]
        $ManagedAppRegistrations,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphMessage1[]]
        $Messages,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserPrint]
        $Print,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphSecurity]
        $Security,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphObjectIdentity[]]
        $Identities,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphTeam1[]]
        $JoinedTeams,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphTasks]
        $Tasks,

        [Parameter()]
        [System.String]
        $MySite,

        [Parameter()]
        [System.String[]]
        $BusinessPhones,

        [Parameter()]
        [System.Uri]
        $Proxy,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserAnalytics]
        $Analytics,

        [Parameter()]
        [System.String[]]
        $ProxyAddresses,

        [Parameter()]
        [System.String]
        $OfficeLocation,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPresence1]
        $Presence,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphPasswordProfile]
        $PasswordProfile,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAppConsentRequest[]]
        $AppConsentRequestsForApproval,

        [Parameter()]
        [System.String]
        $UserType,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $TransitiveMemberOf,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphManagedDevice1[]]
        $ManagedDevices,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $CreatedObjects,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphProfilePhoto]
        $Photo,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphLicenseDetails[]]
        $LicenseDetails,

        [Parameter()]
        [System.String]
        $StreetAddress,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphGroup[]]
        $JoinedGroups,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphCloudPc[]]
        $CloudPCs,

        [Parameter()]
        [System.Collections.Hashtable]
        $CustomSecurityAttributes,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphEvent1[]]
        $CalendarView,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOnenote1]
        $Onenote,

        [Parameter()]
        [System.String]
        $SecurityIdentifier,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphServicePrincipal[]]
        $AppRoleAssignedResources,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $OwnedDevices,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphSite1[]]
        $FollowedSites,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDrive1[]]
        $Drives,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphMobileAppTroubleshootingEvent[]]
        $MobileAppTroubleshootingEvents,

        [Parameter()]
        [System.String[]]
        $Interests,

        [Parameter()]
        [System.String]
        $LegalAgeGroupClassification,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphCalendar1]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $MemberOf,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceKey[]]
        $DeviceKeys,

        [Parameter()]
        [System.String]
        $EmployeeId,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAssignedLicense[]]
        $AssignedLicenses,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphEvent1[]]
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
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUsageRight[]]
        $UsageRights,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphProvisionedPlan[]]
        $ProvisionedPlans,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOnPremisesProvisioningError[]]
        $OnPremisesProvisioningErrors,

        [Parameter()]
        [System.String]
        $MailNickname,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOnPremisesExtensionAttributes]
        $OnPremisesExtensionAttributes,

        [Parameter()]
        [System.String[]]
        $PastProjects,

        [Parameter()]
        [System.DateTime]
        $CreatedDateTime,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $DirectReports,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphAuthentication1]
        $Authentication,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDirectoryObject[]]
        $TransitiveReports,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphLicenseAssignmentState[]]
        $LicenseAssignmentStates,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUserActivity1[]]
        $Activities,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDevice[]]
        $Devices,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphOutlookUser1]
        $Outlook,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementTroubleshootingEvent1[]]
        $DeviceManagementTroubleshootingEvents,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PassThru,

        [Parameter()]
        [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphProfile]
        $Profile,

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
        [System.Object]
        $ForceValidate,

        [Parameter()]
        [System.Object]
        $IncludeExtendedProperties,

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
        [System.Object]
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
        $IsRecordUnlockedAsDefault,

        [Parameter()]
        [System.Object]
        $ComplianceTagForNextStage,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

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
        $OnPremisesScannerDlpRestrictions,

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
        $ExceptIfSentToMemberOf,

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
        $EventType,

        [Parameter()]
        [System.Object]
        $ReviewerEmail,

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
        $ExceptIfDocumentMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfSentToMemberOf,

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
        $MessageSizeOver,

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
        [System.Boolean]
        $AllowCarbonSummary,

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
        [System.Boolean]
        $AllowPrivateMeetNow,

        [Parameter()]
        [System.String]
        $AllowEngagementReport,

        [Parameter()]
        [System.Boolean]
        $AllowPSTNUsersToBypassLobby,

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
        [System.String]
        $AutoAdmittedUsers,

        [Parameter()]
        [System.Boolean]
        $AllowCloudRecording,

        [Parameter()]
        [System.Boolean]
        $AllowIPVideo,

        [Parameter()]
        [System.String]
        $SpeakerAttributionMode,

        [Parameter()]
        [System.String]
        $AllowCartCaptionsScheduling,

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
        $AllowMeetingReactions,

        [Parameter()]
        [System.Boolean]
        $AllowChannelMeetingScheduling,

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
        [System.String]
        $Identity,

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
        [System.Boolean]
        $AllowCarbonSummary,

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
        [System.Boolean]
        $AllowPrivateMeetNow,

        [Parameter()]
        [System.String]
        $AllowEngagementReport,

        [Parameter()]
        [System.Boolean]
        $AllowPSTNUsersToBypassLobby,

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
        [System.String]
        $AutoAdmittedUsers,

        [Parameter()]
        [System.Boolean]
        $AllowCloudRecording,

        [Parameter()]
        [System.Boolean]
        $AllowIPVideo,

        [Parameter()]
        [System.String]
        $SpeakerAttributionMode,

        [Parameter()]
        [System.String]
        $AllowCartCaptionsScheduling,

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
        $AllowMeetingReactions,

        [Parameter()]
        [System.Boolean]
        $AllowChannelMeetingScheduling,

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
        [System.String]
        $Identity,

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
