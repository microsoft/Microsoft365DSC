#region
#endregion
#region
#endregion
#region
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
#region
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
#region
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
        [System.String]
        $LdapFilter,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $OnModernServer,

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
