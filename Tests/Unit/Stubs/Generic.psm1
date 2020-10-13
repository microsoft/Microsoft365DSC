function Get-AzureADDirectorySetting
{
    [CmdletBinding()]
    param(
    )
}

function Get-AzureADDirectorySettingTemplate
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Id
    )
}

function Remove-AzureADDirectorySetting
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [System.String]
        $Id
    )
}

function New-AzureADDirectorySetting
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]
        $DirectorySetting
    )
}

function Set-AzureADDirectorySetting
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [System.String]
        $Id,

        [Parameter(Mandatory=$true)]
        [PSObject]
        $DirectorySetting
    )
}

function Set-AzureADMSGroupLifecyclePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        ${Id},

        [Parameter(Mandatory = $true)]
        [System.UInt32]
        $GroupLifetimeInDays,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('All', 'Selected', 'None')]
        $ManagedGroupTypes,

        [Parameter(Mandatory = $true)]
        [System.String[]]
        $AlternateNotificationEmails
    )
}
function Get-PSSession
{
    [CmdletBinding()]
    param(
    )
}

function Remove-PSSession
{
    [CmdletBinding()]
    param(
    )
}

function New-AzureADMSGroup
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $GroupTypes,

        [Parameter()]
        [System.String]
        $MembershipRule,

        [Parameter()]
        [ValidateSet('On', 'Paused')]
        [System.String]
        $MembershipRuleProcessingState,

        [Parameter()]
        [System.Boolean]
        $SecurityEnabled,

        [Parameter()]
        [System.Boolean]
        $MailEnabled,

        [Parameter()]
        [System.String]
        $MailNickname,

        [Parameter()]
        [ValidateSet('Public', 'Private', 'HiddenMembership')]
        [System.String]
        $Visibility
    )
}

function Set-AzureADMSGroup
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $ID,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $GroupTypes,

        [Parameter()]
        [System.String]
        $MembershipRule,

        [Parameter()]
        [ValidateSet('On', 'Paused')]
        [System.String]
        $MembershipRuleProcessingState,

        [Parameter()]
        [System.Boolean]
        $SecurityEnabled,

        [Parameter()]
        [System.Boolean]
        $MailEnabled,

        [Parameter()]
        [System.String]
        $MailNickname,

        [Parameter()]
        [ValidateSet('Public', 'Private', 'HiddenMembership')]
        [System.String]
        $Visibility
    )
}


function Get-SPOAdministrationUrl
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
}

function New-M365DSCConnection
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("Azure", "AzureAD", "SharePointOnline", "ExchangeOnline", 'Intune', `
                "SecurityComplianceCenter", "MSOnline", "PnP", "PowerPlatforms", `
                "MicrosoftTeams", "SkypeForBusiness")]
        [System.String]
        $Platform,

        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $InboundParameters,

        [Parameter()]
        [System.String]
        $Url,

        [Parameter()]
        [System.Boolean]
        $SkipModuleReload
    )
}

function Test-MSCloudLogin
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("Azure", "AzureAD", "SharePointOnline", "ExchangeOnline", `
                "SecurityComplianceCenter", "MSOnline", "PnP", "PowerPlatforms", `
                "MicrosoftTeams", "SkypeForBusiness")]
        [System.String]
        $Platform,

        [Parameter()]
        [System.String]
        $ConnectionUrl,

        [Parameter()]
        [Alias("o365Credential")]
        [System.Management.Automation.PSCredential]
        $CloudCredential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $UseModernAuth
    )
}

function Start-Job
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [Object]
        $ScriptBLock,

        [Parameter()]
        [System.String[]]
        $ArgumentList
    )
}

function Get-Job
{
    [CmdletBinding()]
    param()
}

#region Specific to tenants
function Get-AtpPolicyForO365
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (

    )
}

function Set-AtpPolicyForO365
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter()]
        [System.String]
        $Identity = 'Default',

        [Parameter()]
        [Boolean]
        $AllowClickThrough = $true,

        [Parameter()]
        [System.String[]]
        $BlockUrls = @(),

        [Parameter()]
        [Boolean]
        $EnableATPForSPOTeamsODB = $false,

        [Parameter()]
        [Boolean]
        $EnableSafeLinksForClients = $false,

        [Parameter()]
        [Boolean]
        $TrackClicks = $true
    )
}

function Set-AddressBookPolicy
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.String[]]
        $AddressLists,

        [Parameter()]
        [System.String]
        $GlobalAddressList,

        [Parameter()]
        [System.String]
        $OfflineAddressBook,

        [Parameter()]
        [System.String]
        $RoomList
    )
}

function New-AddressBookPolicy
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String[]]
        $AddressLists,

        [Parameter()]
        [System.String]
        $GlobalAddressList,

        [Parameter()]
        [System.String]
        $OfflineAddressBook,

        [Parameter()]
        [System.String]
        $RoomList
    )
}

function Remove-DkimSigningConfig
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
        $Confirm = $true
    )
}

function New-SafeAttachmentPolicy
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [ValidateSet('Block', 'Replace', 'Allow', 'DynamicDelivery')]
        [System.String]
        $Action = 'Block',

        [Parameter()]
        [Boolean]
        $ActionOnError = $false,

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [Boolean]
        $Enable = $false,

        [Parameter()]
        [Boolean]
        $Redirect = $false,

        [Parameter()]
        [System.String]
        $RedirectAddress
    )
}

function Set-MalwareFilterRule
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.String[]]
        $ExceptIfSentTo = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfSentToMemberOf = @(),

        [Parameter()]
        [System.String]
        $MalwareFilterPolicy,

        [Parameter()]
        [System.String]
        $Priority,

        [Parameter()]
        [System.String]
        $RecipientDomainIs,

        [Parameter()]
        [System.String[]]
        $SentTo = @(),

        [Parameter()]
        [System.String[]]
        $SentToMemberOf = @(),

        [Parameter()]
        [System.Boolean]
        $Confirm = $false
    )
}



function New-SafeAttachmentRule
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $SafeAttachmentPolicy,

        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.Boolean]
        $Enabled = $true,

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientDomainIs = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfSentTo = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfSentToMemberOf = @(),

        [Parameter()]
        [uint32]
        $Priority,

        [Parameter()]
        [System.String[]]
        $RecipientDomainIs = @(),

        [Parameter()]
        [System.String[]]
        $SentTo = @(),

        [Parameter()]
        [System.String[]]
        $SentToMemberOf = @()
    )
}

function New-SafeLinksPolicy
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [Boolean]
        $DoNotAllowClickThrough = $true,

        [Parameter()]
        [System.String[]]
        $DoNotRewriteUrls = @(),

        [Parameter()]
        [Boolean]
        $DoNotTrackUserClicks = $true,

        [Parameter()]
        [Boolean]
        $EnableForInternalSenders,

        [Parameter()]
        [Boolean]
        $IsEnabled,

        [Parameter()]
        [Boolean]
        $ScanUrls = $false
    )
}

function New-SafeLinksRule
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $SafeLinksPolicy,

        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.Boolean]
        $Enabled = $true,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientDomainIs = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfSentTo = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfSentToMemberOf = @(),

        [Parameter()]
        [uint32]
        $Priority,

        [Parameter()]
        [System.String[]]
        $RecipientDomainIs = @(),

        [Parameter()]
        [System.String[]]
        $SentTo = @(),

        [Parameter()]
        [System.String[]]
        $SentToMemberOf = @()
    )
}
function Set-SafeAttachmentPolicy
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [ValidateSet('Block', 'Replace', 'Allow', 'DynamicDelivery')]
        [System.String]
        $Action = 'Block',

        [Parameter()]
        [Boolean]
        $ActionOnError = $false,

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [Boolean]
        $Enable = $false,

        [Parameter()]
        [Boolean]
        $Redirect = $false,

        [Parameter()]
        [System.String]
        $RedirectAddress,

        [Parameter()]
        [System.Boolean]
        $Confirm = $false
    )
}

function Set-SafeAttachmentRule
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.String]
        $SafeAttachmentPolicy,

        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.Boolean]
        $Enabled = $true,

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientDomainIs = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfSentTo = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfSentToMemberOf = @(),

        [Parameter()]
        [uint32]
        $Priority,

        [Parameter()]
        [System.String[]]
        $RecipientDomainIs = @(),

        [Parameter()]
        [System.String[]]
        $SentTo = @(),

        [Parameter()]
        [System.String[]]
        $SentToMemberOf = @(),

        [Parameter()]
        [System.Boolean]
        $Confirm = $false
    )
}

function Set-SafeLinksPolicy
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [Boolean]
        $DoNotAllowClickThrough = $true,

        [Parameter()]
        [System.String[]]
        $DoNotRewriteUrls = @(),

        [Parameter()]
        [Boolean]
        $DoNotTrackUserClicks = $true,

        [Parameter()]
        [Boolean]
        $EnableForInternalSenders,

        [Parameter()]
        [Boolean]
        $IsEnabled,

        [Parameter()]
        [Boolean]
        $ScanUrls = $false,

        [Parameter()]
        [System.Boolean]
        $Confirm = $false
    )
}

function Set-SafeLinksRule
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.String]
        $SafeLinksPolicy,

        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.Boolean]
        $Enabled = $true,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientDomainIs = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfSentTo = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfSentToMemberOf = @(),

        [Parameter()]
        [uint32]
        $Priority,

        [Parameter()]
        [System.String[]]
        $RecipientDomainIs = @(),

        [Parameter()]
        [System.String[]]
        $SentTo = @(),

        [Parameter()]
        [System.String[]]
        $SentToMemberOf = @(),

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.Boolean]
        $Confirm = $false
    )
}

function Get-SafeAttachmentPolicy
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (

    )
}

function Get-SafeAttachmentRule
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (

    )
}

function Get-SafeLinksPolicy
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (

    )
}

function Get-SafeLinksRule
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (

    )
}


function get-MalwareFilterRule
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (

    )
}

function Remove-SafeAttachmentPolicy
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
        $Confirm = $false,

        [Parameter()]
        [Switch]
        $Force = $true
    )
}

function Remove-SafeAttachmentRule
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
        $Confirm = $false
    )
}

function Remove-SafeLinksPolicy
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
        $Confirm = $false
    )
}

function Remove-SafeLinksRule
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
        $Confirm = $false
    )
}
#endregion

function New-M365DSCLogEntry
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [System.String]
        $Error,

        [Parameter()]
        [System.String]
        $Message,

        [Parameter()]
        [System.String]
        $Source
    )
}

function Confirm-ImportedCmdletIsAvailable
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $CmdletName
    )
}

function Get-AllSPOPackages
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable[]])]
    param(
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
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
}

# EXOAddressBookPolicy cmdlets
function Get-AddressBookPolicy
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (

    )
}

# EXOOfflineAddressBook cmdlets
function Get-OfflineAddressBook
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (

    )
}

function Set-OfflineAddressBook
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [ValidateLength(1, 64)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String[]]
        $AddressLists = @(),

        [Parameter()]
        [System.String[]]
        $ConfiguredAttributes = @(),

        [Parameter()]
        [System.String]
        $DiffRetentionPeriod,

        [Parameter()]
        [System.Boolean]
        $IsDefault,

        [Parameter()]
        [System.Boolean]
        $Confirm
    )
}

function add-AvailabilityAddressSpace
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [ValidateSet('PerUserFB', 'OrgWideFB', 'OrgWideFBBasic', 'InternalProxy')]
        [System.String]
        $AccessMethod,

        [Parameter()]
        [System.String]
        $Credentials,

        [Parameter()]
        [System.String]
        $ForestName,

        [Parameter()]
        [System.String]
        $TargetAutodiscoverEpr
    )
}

function get-AvailabilityAddressSpace
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (

    )
}

function remove-AvailabilityAddressSpace
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [ValidateSet('PerUserFB', 'OrgWideFB', 'OrgWideFBBasic', 'InternalProxy')]
        [System.String]
        $AccessMethod,

        [Parameter()]
        [System.String]
        $Credentials,

        [Parameter()]
        [System.String]
        $ForestName,

        [Parameter()]
        [System.String]
        $TargetAutodiscoverEpr,

        [Parameter()]
        [System.Boolean]
        $Confirm
    )
}

function New-OfflineAddressBook
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
        [System.String[]]
        $AddressLists = @(),

        [Parameter()]
        [System.String[]]
        $ConfiguredAttributes = @(),

        [Parameter()]
        [System.String]
        $DiffRetentionPeriod,

        [Parameter()]
        [System.Boolean]
        $IsDefault,

        [Parameter()]
        [System.Boolean]
        $Confirm
    )
}

# EXOAddressBookPolicy cmdlets
function Get-AddressBookPolicy
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (

    )
}

function Set-AddressBookPolicy
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.String[]]
        $AddressLists,

        [Parameter()]
        [System.String]
        $GlobalAddressList,

        [Parameter()]
        [System.String]
        $OfflineAddressBook,

        [Parameter()]
        [System.String]
        $RoomList,

        [Parameter()]
        [System.Boolean]
        $Confirm
    )
}

function New-AddressBookPolicy
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String[]]
        $AddressLists,

        [Parameter()]
        [System.String]
        $GlobalAddressList,

        [Parameter()]
        [System.String]
        $OfflineAddressBook,

        [Parameter()]
        [System.String]
        $RoomList,

        [Parameter()]
        [System.Boolean]
        $Confirm
    )
}

# EXOGlobalAddressList cmdlets
function Get-GlobalAddressList
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (

    )
}

function Set-GlobalAddressList
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [ValidateLength(1, 64)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String[]]
        $ConditionalCompany,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute1,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute10,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute11,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute12,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute13,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute14,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute15,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute2,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute3,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute4,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute5,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute6,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute7,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute8,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute9,

        [Parameter()]
        [System.String[]]
        $ConditionalDepartment,

        [Parameter()]
        [System.String[]]
        $ConditionalStateOrProvince,

        [Parameter()]
        [ValidateSet('AllRecipients', 'MailboxUsers', 'MailContacts', 'MailGroups', 'MailUsers', 'Resources')]
        [System.String[]]
        $IncludedRecipients,

        [Parameter()]
        [System.String[]]
        $RecipientFilter,

        [Parameter()]
        [System.Boolean]
        $Confirm
    )
}

function New-GlobalAddressList
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
        [System.String[]]
        $ConditionalCompany,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute1,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute10,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute11,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute12,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute13,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute14,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute15,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute2,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute3,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute4,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute5,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute6,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute7,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute8,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute9,

        [Parameter()]
        [System.String[]]
        $ConditionalDepartment,

        [Parameter()]
        [System.String[]]
        $ConditionalStateOrProvince,

        [Parameter()]
        [ValidateSet('AllRecipients', 'MailboxUsers', 'MailContacts', 'MailGroups', 'MailUsers', 'Resources')]
        [System.String[]]
        $IncludedRecipients,

        [Parameter()]
        [System.String[]]
        $RecipientFilter,

        [Parameter()]
        [System.Boolean]
        $Confirm
    )
}
# EXOAddressList cmdlets
function Get-AddressList
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (

    )
}

function Set-AddressList
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [ValidateLength(1, 64)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String[]]
        $ConditionalCompany,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute1,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute10,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute11,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute12,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute13,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute14,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute15,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute2,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute3,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute4,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute5,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute6,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute7,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute8,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute9,

        [Parameter()]
        [System.String[]]
        $ConditionalDepartment,

        [Parameter()]
        [System.String[]]
        $ConditionalStateOrProvince,

        [Parameter()]
        [System.String[]]
        $DisplayName,

        [Parameter()]
        [ValidateSet('AllRecipients', 'MailboxUsers', 'MailContacts', 'MailGroups', 'MailUsers', 'Resources')]
        [System.String[]]
        $IncludedRecipients,

        [Parameter()]
        [System.String[]]
        $RecipientFilter,

        [Parameter()]
        [System.Boolean]
        $Confirm
    )
}

function New-AddressList
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
        [System.String[]]
        $ConditionalCompany,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute1,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute10,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute11,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute12,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute13,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute14,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute15,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute2,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute3,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute4,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute5,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute6,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute7,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute8,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute9,

        [Parameter()]
        [System.String[]]
        $ConditionalDepartment,

        [Parameter()]
        [System.String[]]
        $ConditionalStateOrProvince,

        [Parameter()]
        [System.String[]]
        $DisplayName,

        [Parameter()]
        [ValidateSet('AllRecipients', 'MailboxUsers', 'MailContacts', 'MailGroups', 'MailUsers', 'Resources')]
        [System.String[]]
        $IncludedRecipients,

        [Parameter()]
        [System.String[]]
        $RecipientFilter,

        [Parameter()]
        [System.Boolean]
        $Confirm
    )
}

function Connect-Graph
{
    [CmdletBinding()]
    Param(
        [Parameter()]
        [System.String[]]
        $Scopes
    )
}

function Get-MGGroupPlannerPlan
{
    [CmdletBinding()]
    Param(
        [Parameter()]
        [System.String]
        $GroupId
    )
}

function Update-MGPlannerPlan
{
    [CmdletBinding()]
    Param(
        [Parameter()]
        [System.String]
        $Owner,

        [Parameter()]
        [System.String]
        $Title,

        [Parameter()]
        [System.String]
        $PlannerPlanId
    )
}

function Get-MGPlannerTask
{
    [CmdletBinding()]
    Param(
        [Parameter()]
        [System.String]
        $PlannerTaskId
    )
}

function New-MGPlannerTask
{
    [CmdletBinding()]
    Param(
        [Parameter()]
        [System.String]
        $PlanId,

        [Parameter()]
        [System.String]
        $Title,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $StartDateTime,

        [Parameter()]
        [System.String]
        $CompletedDateTime,

        [Parameter()]
        [ValidateRange(0, 100)]
        [System.Uint32]
        $PercentComplete,

        [Parameter()]
        [ValidateRange(0, 10)]
        [System.UInt32]
        $Priority
    )
}

function Update-MGPlannerTask
{
    [CmdletBinding()]
    Param(
        [Parameter()]
        [System.String]
        $PlanId,

        [Parameter()]
        [System.String]
        $Title,

        [Parameter()]
        [System.String]
        $TaskId,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $StartDateTime,

        [Parameter()]
        [System.String]
        $CompletedDateTime,

        [Parameter()]
        [ValidateRange(0, 100)]
        [System.Uint32]
        $PercentComplete,

        [Parameter()]
        [ValidateRange(0, 10)]
        [System.UInt32]
        $Priority
    )
}

function Get-MgPlannerPlanBucket
{
    [CmdletBinding()]
    Param(
        [Parameter()]
        [System.String]
        $PlannerPlanId
    )
}

function New-MgPlannerBucket
{
    [CmdletBinding()]
    Param(
        [Parameter()]
        [System.String]
        $PlanId,

        [Parameter()]
        [System.String]
        $Name
    )
}

function Update-MgPlannerBucket
{
    [CmdletBinding()]
    Param(
        [Parameter()]
        [System.String]
        $PlanId,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $BucketId
    )
}
