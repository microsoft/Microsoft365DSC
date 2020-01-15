function Close-SessionsAndReturnError
{
    [CmdletBinding()]
    param (
        [Parameter()]
        [String]
        $ExceptionMessage
    )

}
function Get-PSSession{
    [CmdletBinding()]
    param(
    )
}

function Remove-PSSession{
    [CmdletBinding()]
    param(
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

function Test-MSCloudLogin
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("Azure","AzureAD","SharePointOnline","ExchangeOnline", `
                    "SecurityComplianceCenter","MSOnline","PnP", "PowerPlatforms", `
                    "MicrosoftTeams","SkypeForBusiness")]
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

function New-Office365DSCLogEntry
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
