#region AzureAD
function Add-AzureADGroupOwner
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $RefObjectId,

        [Parameter()]
        [System.String]
        $ObjectId
    )
}
function Get-AzureADApplication
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $SearchString,

        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $Top,

        [Parameter()]
        [System.String]
        $ObjectId,

        [Parameter()]
        [System.Boolean]
        $All,

        [Parameter()]
        [System.String]
        $Filter
    )
}
function Get-AzureADApplicationOwner
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $Top,

        [Parameter()]
        [System.String]
        $ObjectId,

        [Parameter()]
        [System.Boolean]
        $All
    )
}
function Get-AzureADDirectoryRole
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $ObjectId
    )
}
function Get-AzureADDirectoryRoleTemplate
{
    [CmdletBinding()]
    param(

    )
}
function Get-AzureADDirectorySetting
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $Top,

        [Parameter()]
        [System.Boolean]
        $All
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
function Get-AzureADGroup
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $SearchString,

        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $Top,

        [Parameter()]
        [System.String]
        $ObjectId,

        [Parameter()]
        [System.Boolean]
        $All,

        [Parameter()]
        [System.String]
        $Filter
    )
}
function Get-AzureADGroupMember
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $Top,

        [Parameter()]
        [System.String]
        $ObjectId,

        [Parameter()]
        [System.Boolean]
        $All
    )
}
function Get-AzureADGroupOwner
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $Top,

        [Parameter()]
        [System.String]
        $ObjectId,

        [Parameter()]
        [System.Boolean]
        $All
    )
}
function Get-AzureADMSConditionalAccessPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $PolicyId
    )
}
function Get-AzureADMSGroup
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $SearchString,

        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $Top,

        [Parameter()]
        [System.Boolean]
        $All,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $Select
    )
}
function Get-AzureADMSGroupLifecyclePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Id
    )
}
function Get-AzureADMSNamedLocationPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $PolicyId
    )
}
function Get-AzureADMSRoleDefinition
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $SearchString,

        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $Top,

        [Parameter()]
        [System.Boolean]
        $All,

        [Parameter()]
        [System.String]
        $Filter
    )
}
function Get-AzureADPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $Top,

        [Parameter()]
        [System.Boolean]
        $All
    )
}
function Get-AzureADServiceAppRoleAssignedTo
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $Top,

        [Parameter()]
        [System.String]
        $ObjectId,

        [Parameter()]
        [System.Boolean]
        $All
    )
}
function Get-AzureADServicePrincipal
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $SearchString,

        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $Top,

        [Parameter()]
        [System.String]
        $ObjectId,

        [Parameter()]
        [System.Boolean]
        $All,

        [Parameter()]
        [System.String]
        $Filter
    )
}
function Get-AzureADServicePrincipalOAuth2PermissionGrant
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $Top,

        [Parameter()]
        [System.String]
        $ObjectId,

        [Parameter()]
        [System.Boolean]
        $All
    )
}
function Get-AzureADSubscribedSku
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $ObjectId
    )
}
function Get-AzureADTenantDetail
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $Top,

        [Parameter()]
        [System.Boolean]
        $All
    )
}
function Get-AzureADUser
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $SearchString,

        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $Top,

        [Parameter()]
        [System.String]
        $ObjectId,

        [Parameter()]
        [System.Boolean]
        $All,

        [Parameter()]
        [System.String]
        $Filter
    )
}
function Get-AzureADUserLicenseDetail
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $ObjectId
    )
}
function New-AzureADApplication
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Collections.Generic.List`1[Microsoft.Open.AzureAD.Model.AddIn]]
        $AddIns,

        [Parameter()]
        [System.String]
        $SignInAudience,

        [Parameter()]
        [System.Boolean]
        $Oauth2AllowImplicitFlow,

        [Parameter()]
        [System.String[]]
        $ReplyUrls,

        [Parameter()]
        [System.String]
        $WwwHomepage,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $IsDisabled,

        [Parameter()]
        [System.Boolean]
        $AllowGuestsSignIn,

        [Parameter()]
        [System.String[]]
        $KnownClientApplications,

        [Parameter()]
        [System.String]
        $PublisherDomain,

        [Parameter()]
        [System.String[]]
        $OrgRestrictions,

        [Parameter()]
        [Microsoft.Open.AzureAD.Model.ParentalControlSettings]
        $ParentalControlSettings,

        [Parameter()]
        [Microsoft.Open.AzureAD.Model.OptionalClaims]
        $OptionalClaims,

        [Parameter()]
        [System.Boolean]
        $Oauth2AllowUrlPathMatching,

        [Parameter()]
        [System.Collections.Generic.List`1[Microsoft.Open.AzureAD.Model.KeyCredential]]
        $KeyCredentials,

        [Parameter()]
        [System.String[]]
        $IdentifierUris,

        [Parameter()]
        [System.String]
        $GroupMembershipClaims,

        [Parameter()]
        [System.Collections.Generic.List`1[Microsoft.Open.AzureAD.Model.OAuth2Permission]]
        $Oauth2Permissions,

        [Parameter()]
        [System.String]
        $LogoutUrl,

        [Parameter()]
        [System.String]
        $ErrorUrl,

        [Parameter()]
        [System.String]
        $SamlMetadataUrl,

        [Parameter()]
        [System.Boolean]
        $IsDeviceOnlyAuthSupported,

        [Parameter()]
        [System.Collections.Generic.List`1[Microsoft.Open.AzureAD.Model.PreAuthorizedApplication]]
        $PreAuthorizedApplications,

        [Parameter()]
        [System.Boolean]
        $AvailableToOtherTenants,

        [Parameter()]
        [System.Boolean]
        $AllowPassthroughUsers,

        [Parameter()]
        [System.Collections.Generic.List`1[Microsoft.Open.AzureAD.Model.RequiredResourceAccess]]
        $RequiredResourceAccess,

        [Parameter()]
        [System.Boolean]
        $PublicClient,

        [Parameter()]
        [System.String]
        $RecordConsentConditions,

        [Parameter()]
        [System.Boolean]
        $Oauth2RequirePostResponse,

        [Parameter()]
        [System.String]
        $AppLogoUrl,

        [Parameter()]
        [System.Collections.Generic.List`1[Microsoft.Open.AzureAD.Model.PasswordCredential]]
        $PasswordCredentials,

        [Parameter()]
        [System.String]
        $Homepage,

        [Parameter()]
        [System.Collections.Generic.List`1[Microsoft.Open.AzureAD.Model.AppRole]]
        $AppRoles,

        [Parameter()]
        [Microsoft.Open.AzureAD.Model.InformationalUrl]
        $InformationalUrls
    )
}
function New-AzureADDirectorySetting
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Open.MSGraph.Model.DirectorySetting]
        $DirectorySetting
    )
}
function New-AzureADMSConditionalAccessPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $CreatedDateTime,

        [Parameter()]
        [Microsoft.Open.MSGraph.Model.ConditionalAccessSessionControls]
        $SessionControls,

        [Parameter()]
        [Microsoft.Open.MSGraph.Model.ConditionalAccessGrantControls]
        $GrantControls,

        [Parameter()]
        [System.String]
        $ModifiedDateTime,

        [Parameter()]
        [System.String]
        $State,

        [Parameter()]
        [Microsoft.Open.MSGraph.Model.ConditionalAccessConditionSet]
        $Conditions
    )
}
function New-AzureADMSGroup
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
        $MembershipRuleProcessingState,

        [Parameter()]
        [System.String[]]
        $GroupTypes,

        [Parameter()]
        [System.Boolean]
        $SecurityEnabled,

        [Parameter()]
        [System.String]
        $Visibility,

        [Parameter()]
        [System.Boolean]
        $MailEnabled,

        [Parameter()]
        [System.String]
        $MailNickname,

        [Parameter()]
        [System.String]
        $MembershipRule,

        [Parameter()]
        [System.Boolean]
        $IsAssignableToRole,

        [Parameter()]
        [System.String]
        $LabelId
    )
}
function New-AzureADMSGroupLifecyclePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $AlternateNotificationEmails,

        [Parameter()]
        [System.String]
        $ManagedGroupTypes,

        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $GroupLifetimeInDays
    )
}
function New-AzureADMSNamedLocationPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $OdataType,

        [Parameter()]
        [System.Boolean]
        $IsTrusted,

        [Parameter()]
        [System.Object[]]
        $IpRanges,

        [Parameter()]
        [System.Object[]]
        $CountriesAndRegions,

        [Parameter()]
        [System.Boolean]
        $IncludeUnknownCountriesAndRegions
    )
}
function New-AzureADMSRoleDefinition
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $TemplateId,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Version,

        [Parameter()]
        [System.Object[]]
        $RolePermissions,

        [Parameter()]
        [System.Object[]]
        $InheritsPermissionsFrom,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $IsEnabled,

        [Parameter()]
        [System.String[]]
        $ResourceScopes
    )
}
function New-AzureADPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Definition,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Type,

        [Parameter()]
        [System.Object[]]
        $KeyCredentials,

        [Parameter()]
        [System.Boolean]
        $IsOrganizationDefault,

        [Parameter()]
        [System.String]
        $AlternativeIdentifier
    )
}
function New-AzureADServicePrincipal
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $PublisherName,

        [Parameter()]
        [System.String[]]
        $ReplyUrls,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $ServicePrincipalType,

        [Parameter()]
        [System.Boolean]
        $AppRoleAssignmentRequired,

        [Parameter()]
        [System.Collections.Generic.List`1[Microsoft.Open.AzureAD.Model.KeyCredential]]
        $KeyCredentials,

        [Parameter()]
        [System.String[]]
        $ServicePrincipalNames,

        [Parameter()]
        [System.String]
        $LogoutUrl,

        [Parameter()]
        [System.String]
        $ErrorUrl,

        [Parameter()]
        [System.String]
        $SamlMetadataUrl,

        [Parameter()]
        [System.String]
        $AccountEnabled,

        [Parameter()]
        [System.String[]]
        $Tags,

        [Parameter()]
        [System.String[]]
        $AlternativeNames,

        [Parameter()]
        [System.Collections.Generic.List`1[Microsoft.Open.AzureAD.Model.PasswordCredential]]
        $PasswordCredentials,

        [Parameter()]
        [System.String]
        $Homepage,

        [Parameter()]
        [System.String]
        $AppId
    )
}
function New-AzureADUser
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $PostalCode,

        [Parameter()]
        [System.String]
        $MailNickName,

        [Parameter()]
        [System.Boolean]
        $ShowInAddressList,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Mobile,

        [Parameter()]
        [System.String]
        $JobTitle,

        [Parameter()]
        [System.String]
        $ConsentProvidedForMinor,

        [Parameter()]
        [System.String]
        $PhysicalDeliveryOfficeName,

        [Parameter()]
        [System.String[]]
        $OtherMails,

        [Parameter()]
        [System.String]
        $PasswordPolicies,

        [Parameter()]
        [System.Boolean]
        $IsCompromised,

        [Parameter()]
        [System.Collections.Generic.List`1[Microsoft.Open.AzureAD.Model.SignInName]]
        $SignInNames,

        [Parameter()]
        [System.String]
        $UserState,

        [Parameter()]
        [System.String]
        $PreferredLanguage,

        [Parameter()]
        [System.String]
        $State,

        [Parameter()]
        [System.String]
        $TelephoneNumber,

        [Parameter()]
        [System.String]
        $AgeGroup,

        [Parameter()]
        [System.Collections.Generic.Dictionary`2[System.String, System.String]]
        $ExtensionProperty,

        [Parameter()]
        [System.String]
        $UsageLocation,

        [Parameter()]
        [System.String]
        $UserStateChangedOn,

        [Parameter()]
        [System.Boolean]
        $AccountEnabled,

        [Parameter()]
        [System.String]
        $Country,

        [Parameter()]
        [System.String]
        $GivenName,

        [Parameter()]
        [System.String]
        $UserType,

        [Parameter()]
        [System.String]
        $StreetAddress,

        [Parameter()]
        [Microsoft.Open.AzureAD.Model.PasswordProfile]
        $PasswordProfile,

        [Parameter()]
        [System.String]
        $City,

        [Parameter()]
        [System.String]
        $Department,

        [Parameter()]
        [System.String]
        $CompanyName,

        [Parameter()]
        [System.String]
        $FacsimileTelephoneNumber,

        [Parameter()]
        [System.String]
        $Surname,

        [Parameter()]
        [System.String]
        $UserPrincipalName,

        [Parameter()]
        [System.String]
        $CreationType,

        [Parameter()]
        [System.String]
        $ImmutableId
    )
}
function Remove-AzureADApplication
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $ObjectId
    )
}
function Remove-AzureADDirectorySetting
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Id
    )
}
function Remove-AzureADMSConditionalAccessPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $PolicyId
    )
}
function Remove-AzureADMSGroup
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Id
    )
}
function Remove-AzureADMSGroupLifecyclePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Id
    )
}
function Remove-AzureADMSNamedLocationPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $PolicyId
    )
}
function Remove-AzureADMSRoleDefinition
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Id
    )
}
function Remove-AzureADPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Id
    )
}
function Remove-AzureADServicePrincipal
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $ObjectId
    )
}
function Remove-AzureADUser
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $ObjectId
    )
}
function Set-AzureADApplication
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Collections.Generic.List`1[Microsoft.Open.AzureAD.Model.AddIn]]
        $AddIns,

        [Parameter()]
        [System.String]
        $SignInAudience,

        [Parameter()]
        [System.Boolean]
        $Oauth2AllowImplicitFlow,

        [Parameter()]
        [System.String[]]
        $ReplyUrls,

        [Parameter()]
        [System.String]
        $WwwHomepage,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $IsDisabled,

        [Parameter()]
        [System.Boolean]
        $AllowGuestsSignIn,

        [Parameter()]
        [System.String[]]
        $KnownClientApplications,

        [Parameter()]
        [System.String]
        $PublisherDomain,

        [Parameter()]
        [System.String[]]
        $OrgRestrictions,

        [Parameter()]
        [Microsoft.Open.AzureAD.Model.ParentalControlSettings]
        $ParentalControlSettings,

        [Parameter()]
        [Microsoft.Open.AzureAD.Model.OptionalClaims]
        $OptionalClaims,

        [Parameter()]
        [System.Boolean]
        $Oauth2AllowUrlPathMatching,

        [Parameter()]
        [System.Collections.Generic.List`1[Microsoft.Open.AzureAD.Model.KeyCredential]]
        $KeyCredentials,

        [Parameter()]
        [System.String[]]
        $IdentifierUris,

        [Parameter()]
        [System.String]
        $GroupMembershipClaims,

        [Parameter()]
        [System.Collections.Generic.List`1[Microsoft.Open.AzureAD.Model.OAuth2Permission]]
        $Oauth2Permissions,

        [Parameter()]
        [System.String]
        $LogoutUrl,

        [Parameter()]
        [System.String]
        $ErrorUrl,

        [Parameter()]
        [System.String]
        $SamlMetadataUrl,

        [Parameter()]
        [System.Boolean]
        $IsDeviceOnlyAuthSupported,

        [Parameter()]
        [System.Collections.Generic.List`1[Microsoft.Open.AzureAD.Model.PreAuthorizedApplication]]
        $PreAuthorizedApplications,

        [Parameter()]
        [System.Boolean]
        $AvailableToOtherTenants,

        [Parameter()]
        [System.Boolean]
        $AllowPassthroughUsers,

        [Parameter()]
        [System.Collections.Generic.List`1[Microsoft.Open.AzureAD.Model.RequiredResourceAccess]]
        $RequiredResourceAccess,

        [Parameter()]
        [System.Boolean]
        $PublicClient,

        [Parameter()]
        [System.String]
        $ObjectId,

        [Parameter()]
        [System.String]
        $RecordConsentConditions,

        [Parameter()]
        [System.Boolean]
        $Oauth2RequirePostResponse,

        [Parameter()]
        [System.String]
        $AppLogoUrl,

        [Parameter()]
        [System.Collections.Generic.List`1[Microsoft.Open.AzureAD.Model.PasswordCredential]]
        $PasswordCredentials,

        [Parameter()]
        [System.String]
        $Homepage,

        [Parameter()]
        [System.Collections.Generic.List`1[Microsoft.Open.AzureAD.Model.AppRole]]
        $AppRoles,

        [Parameter()]
        [Microsoft.Open.AzureAD.Model.InformationalUrl]
        $InformationalUrls
    )
}
function Set-AzureADDirectorySetting
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Open.MSGraph.Model.DirectorySetting]
        $DirectorySetting
    )
}
function Set-AzureADMSConditionalAccessPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $CreatedDateTime,

        [Parameter()]
        [Microsoft.Open.MSGraph.Model.ConditionalAccessSessionControls]
        $SessionControls,

        [Parameter()]
        [Microsoft.Open.MSGraph.Model.ConditionalAccessGrantControls]
        $GrantControls,

        [Parameter()]
        [System.String]
        $ModifiedDateTime,

        [Parameter()]
        [System.String]
        $State,

        [Parameter()]
        [Microsoft.Open.MSGraph.Model.ConditionalAccessConditionSet]
        $Conditions,

        [Parameter()]
        [System.String]
        $PolicyId
    )
}
function Set-AzureADMSGroup
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $MembershipRule,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $MailNickname,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String[]]
        $GroupTypes,

        [Parameter()]
        [System.Boolean]
        $SecurityEnabled,

        [Parameter()]
        [System.String]
        $LabelId,

        [Parameter()]
        [System.String]
        $Visibility,

        [Parameter()]
        [System.Boolean]
        $MailEnabled,

        [Parameter()]
        [System.String]
        $MembershipRuleProcessingState,

        [Parameter()]
        [System.Boolean]
        $IsAssignableToRole
    )
}
function Set-AzureADMSGroupLifecyclePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $AlternateNotificationEmails,

        [Parameter()]
        [System.String]
        $ManagedGroupTypes,

        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $GroupLifetimeInDays
    )
}
function Set-AzureADMSNamedLocationPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $IncludeUnknownCountriesAndRegions,

        [Parameter()]
        [System.String]
        $OdataType,

        [Parameter()]
        [System.Boolean]
        $IsTrusted,

        [Parameter()]
        [System.Object[]]
        $CountriesAndRegions,

        [Parameter()]
        [System.String]
        $PolicyId,

        [Parameter()]
        [System.Object[]]
        $IpRanges
    )
}
function Set-AzureADMSRoleDefinition
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $TemplateId,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Version,

        [Parameter()]
        [System.Object[]]
        $RolePermissions,

        [Parameter()]
        [System.Object[]]
        $InheritsPermissionsFrom,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $IsEnabled,

        [Parameter()]
        [System.String[]]
        $ResourceScopes,

        [Parameter()]
        [System.String]
        $Id
    )
}
function Set-AzureADPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $Definition,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Type,

        [Parameter()]
        [System.Object[]]
        $KeyCredentials,

        [Parameter()]
        [System.Boolean]
        $IsOrganizationDefault,

        [Parameter()]
        [System.String]
        $AlternativeIdentifier
    )
}
function Set-AzureADServicePrincipal
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String[]]
        $AlternativeNames,

        [Parameter()]
        [System.String]
        $PublisherName,

        [Parameter()]
        [System.String[]]
        $ReplyUrls,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $ServicePrincipalType,

        [Parameter()]
        [System.Boolean]
        $AppRoleAssignmentRequired,

        [Parameter()]
        [System.Collections.Generic.List`1[Microsoft.Open.AzureAD.Model.KeyCredential]]
        $KeyCredentials,

        [Parameter()]
        [System.String[]]
        $ServicePrincipalNames,

        [Parameter()]
        [System.String]
        $LogoutUrl,

        [Parameter()]
        [System.String]
        $ErrorUrl,

        [Parameter()]
        [System.String]
        $SamlMetadataUrl,

        [Parameter()]
        [System.String]
        $AccountEnabled,

        [Parameter()]
        [System.String[]]
        $Tags,

        [Parameter()]
        [System.String]
        $ObjectId,

        [Parameter()]
        [System.String]
        $Homepage,

        [Parameter()]
        [System.Collections.Generic.List`1[Microsoft.Open.AzureAD.Model.PasswordCredential]]
        $PasswordCredentials,

        [Parameter()]
        [System.String]
        $AppId
    )
}
function Set-AzureADTenantDetail
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Open.AzureAD.Model.PrivacyProfile]
        $PrivacyProfile,

        [Parameter()]
        [System.String[]]
        $SecurityComplianceNotificationPhones,

        [Parameter()]
        [System.String[]]
        $TechnicalNotificationMails,

        [Parameter()]
        [System.String[]]
        $SecurityComplianceNotificationMails,

        [Parameter()]
        [System.String[]]
        $MarketingNotificationEmails
    )
}
function Set-AzureADUser
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $PostalCode,

        [Parameter()]
        [System.String]
        $ObjectId,

        [Parameter()]
        [System.String]
        $MailNickName,

        [Parameter()]
        [System.Boolean]
        $ShowInAddressList,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Mobile,

        [Parameter()]
        [System.String]
        $JobTitle,

        [Parameter()]
        [System.String]
        $ConsentProvidedForMinor,

        [Parameter()]
        [System.String]
        $PhysicalDeliveryOfficeName,

        [Parameter()]
        [System.String[]]
        $OtherMails,

        [Parameter()]
        [System.String]
        $PasswordPolicies,

        [Parameter()]
        [System.Boolean]
        $IsCompromised,

        [Parameter()]
        [System.Collections.Generic.List`1[Microsoft.Open.AzureAD.Model.SignInName]]
        $SignInNames,

        [Parameter()]
        [System.String]
        $UserState,

        [Parameter()]
        [System.String]
        $PreferredLanguage,

        [Parameter()]
        [System.String]
        $State,

        [Parameter()]
        [System.String]
        $TelephoneNumber,

        [Parameter()]
        [System.String]
        $AgeGroup,

        [Parameter()]
        [System.Collections.Generic.Dictionary`2[System.String, System.String]]
        $ExtensionProperty,

        [Parameter()]
        [System.String]
        $UsageLocation,

        [Parameter()]
        [System.String]
        $UserStateChangedOn,

        [Parameter()]
        [System.Boolean]
        $AccountEnabled,

        [Parameter()]
        [System.String]
        $Country,

        [Parameter()]
        [System.String]
        $GivenName,

        [Parameter()]
        [System.String]
        $UserType,

        [Parameter()]
        [System.String]
        $StreetAddress,

        [Parameter()]
        [Microsoft.Open.AzureAD.Model.PasswordProfile]
        $PasswordProfile,

        [Parameter()]
        [System.String]
        $City,

        [Parameter()]
        [System.String]
        $Department,

        [Parameter()]
        [System.String]
        $CompanyName,

        [Parameter()]
        [System.String]
        $FacsimileTelephoneNumber,

        [Parameter()]
        [System.String]
        $Surname,

        [Parameter()]
        [System.String]
        $UserPrincipalName,

        [Parameter()]
        [System.String]
        $CreationType,

        [Parameter()]
        [System.String]
        $ImmutableId
    )
}
function Set-AzureADUserLicense
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $ObjectId,

        [Parameter()]
        [Microsoft.Open.AzureAD.Model.AssignedLicenses]
        $AssignedLicenses
    )
}
function Set-AzureADUserPassword
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Security.SecureString]
        $Password,

        [Parameter()]
        [System.Boolean]
        $ForceChangePasswordNextLogin,

        [Parameter()]
        [System.String]
        $ObjectId,

        [Parameter()]
        [System.Boolean]
        $EnforceChangePasswordPolicy
    )
}
#endregion
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
function Add-UnifiedGroupLinks
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $LinkType,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Links,

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
function Get-UnifiedGroup
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $SortBy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IncludeSoftDeletedGroups,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IncludeAllProperties,

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
        [System.Object]
        $Anr,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-UnifiedGroupLinks
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $LinkType,

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
        [System.Object]
        $EnableMailboxIntelligenceProtection,

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
        $TargetedUserProtectionAction,

        [Parameter()]
        [System.Object]
        $RecommendedPolicyType,

        [Parameter()]
        [System.Object]
        $MailboxIntelligenceProtectionActionRecipients,

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
        $PolicyTag,

        [Parameter()]
        [System.Object]
        $EnableUnusualCharactersSafetyTips,

        [Parameter()]
        [System.Object]
        $Name,

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
        [System.Object]
        $HighConfidenceSpamAction,

        [Parameter()]
        [System.Object]
        $TestModeAction,

        [Parameter()]
        [System.Object]
        $QuarantineRetentionPeriod,

        [Parameter()]
        [System.Object]
        $MarkAsSpamWebBugsInHtml,

        [Parameter()]
        [System.Object]
        $EndUserSpamNotificationCustomFromName,

        [Parameter()]
        [System.Object]
        $MarkAsSpamFromAddressAuthFail,

        [Parameter()]
        [System.Object]
        $EndUserSpamNotificationCustomFromAddress,

        [Parameter()]
        [System.Object]
        $IncreaseScoreWithRedirectToOtherPort,

        [Parameter()]
        [System.Object]
        $BulkThreshold,

        [Parameter()]
        [System.Object]
        $EnableLanguageBlockList,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $EndUserSpamNotificationCustomSubject,

        [Parameter()]
        [System.Object]
        $MarkAsSpamSensitiveWordList,

        [Parameter()]
        [System.Object]
        $MarkAsSpamFormTagsInHtml,

        [Parameter()]
        [System.Object]
        $MarkAsSpamNdrBackscatter,

        [Parameter()]
        [System.Object]
        $AddXHeaderValue,

        [Parameter()]
        [System.Object]
        $BulkSpamAction,

        [Parameter()]
        [System.Object]
        $ModifySubjectValue,

        [Parameter()]
        [System.Object]
        $IncreaseScoreWithImageLinks,

        [Parameter()]
        [System.Object]
        $MarkAsSpamEmptyMessages,

        [Parameter()]
        [System.Object]
        $MarkAsSpamSpfRecordHardFail,

        [Parameter()]
        [System.Object]
        $PhishSpamAction,

        [Parameter()]
        [System.Object]
        $HighConfidencePhishAction,

        [Parameter()]
        [System.Object]
        $MarkAsSpamJavaScriptInHtml,

        [Parameter()]
        [System.Object]
        $EnableRegionBlockList,

        [Parameter()]
        [System.Object]
        $EnableEndUserSpamNotifications,

        [Parameter()]
        [System.Object]
        $RedirectToRecipients,

        [Parameter()]
        [System.Object]
        $AllowedSenderDomains,

        [Parameter()]
        [System.Object]
        $MarkAsSpamObjectTagsInHtml,

        [Parameter()]
        [System.Object]
        $MarkAsSpamFramesInHtml,

        [Parameter()]
        [System.Object]
        $TestModeBccToRecipients,

        [Parameter()]
        [System.Object]
        $MarkAsSpamEmbedTagsInHtml,

        [Parameter()]
        [System.Object]
        $EndUserSpamNotificationLanguage,

        [Parameter()]
        [System.Object]
        $EndUserSpamNotificationLimit,

        [Parameter()]
        [System.Object]
        $SpamAction,

        [Parameter()]
        [System.Object]
        $InlineSafetyTipsEnabled,

        [Parameter()]
        [System.Object]
        $RecommendedPolicyType,

        [Parameter()]
        [System.Object]
        $SpamZapEnabled,

        [Parameter()]
        [System.Object]
        $PhishZapEnabled,

        [Parameter()]
        [System.Object]
        $BlockedSenders,

        [Parameter()]
        [System.Object]
        $AllowedSenders,

        [Parameter()]
        [System.Object]
        $LanguageBlockList,

        [Parameter()]
        [System.Object]
        $RegionBlockList,

        [Parameter()]
        [System.Object]
        $IncreaseScoreWithBizOrInfoUrls,

        [Parameter()]
        [System.Object]
        $AdminDisplayName,

        [Parameter()]
        [System.Object]
        $EndUserSpamNotificationFrequency,

        [Parameter()]
        [System.Object]
        $IncreaseScoreWithNumericIps,

        [Parameter()]
        [System.Object]
        $BlockedSenderDomains,

        [Parameter()]
        [System.Object]
        $MarkAsSpamBulkMail,

        [Parameter()]
        [System.Object]
        $DownloadLink,

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
        $Action,

        [Parameter()]
        [System.Object]
        $CustomExternalBody,

        [Parameter()]
        [System.Object]
        $EnableExternalSenderNotifications,

        [Parameter()]
        [System.Object]
        $CustomNotifications,

        [Parameter()]
        [System.Object]
        $EnableInternalSenderNotifications,

        [Parameter()]
        [System.Object]
        $EnableExternalSenderAdminNotifications,

        [Parameter()]
        [System.Object]
        $InternalSenderAdminAddress,

        [Parameter()]
        [System.Object]
        $CustomAlertText,

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
        $ExcludedUrls,

        [Parameter()]
        [System.Object]
        $AdminDisplayName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $UseTranslatedNotificationText,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $DoNotTrackUserClicks,

        [Parameter()]
        [System.Object]
        $DoNotRewriteUrls,

        [Parameter()]
        [System.Object]
        $WhiteListedUrls,

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
        [System.Object]
        $DoNotAllowClickThrough,

        [Parameter()]
        [System.Object]
        $CustomNotificationText,

        [Parameter()]
        [System.Object]
        $DeliverMessageAfterScan,

        [Parameter()]
        [System.Object]
        $ScanUrls,

        [Parameter()]
        [System.Object]
        $IsEnabled,

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
function New-UnifiedGroup
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $MailboxRegion,

        [Parameter()]
        [System.Object]
        $RequireSenderAuthenticationEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ConvertClosedDlToPrivateGroup,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ExoErrorAsWarning,

        [Parameter()]
        [System.Object]
        $DisplayName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Classification,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $HiddenGroupMembershipEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AutoSubscribeNewMembers,

        [Parameter()]
        [System.Object]
        $ExecutingUser,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $SuppressWarmupMessage,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $SubscriptionEnabled,

        [Parameter()]
        [System.Object]
        $DlIdentity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AlwaysSubscribeMembersToCalendarEvents,

        [Parameter()]
        [System.Object]
        $Members,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $DeleteDlAfterMigration,

        [Parameter()]
        [System.Object]
        $Owner,

        [Parameter()]
        [System.Object]
        $Notes,

        [Parameter()]
        [System.Object]
        $Alias,

        [Parameter()]
        [System.Object]
        $ManagedBy,

        [Parameter()]
        [System.Object]
        $Language,

        [Parameter()]
        [System.Object]
        $PrimarySmtpAddress,

        [Parameter()]
        [System.Object]
        $DataEncryptionPolicy,

        [Parameter()]
        [System.Object]
        $AccessType,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $EmailAddresses,

        [Parameter()]
        [System.Object]
        $SensitivityLabelId,

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
function Remove-UnifiedGroup
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
function Remove-UnifiedGroupLinks
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $LinkType,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Links,

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
        $EnableSimilarDomainsSafetyTips,

        [Parameter()]
        [System.Object]
        $EnableTargetedUserProtection,

        [Parameter()]
        [System.Object]
        $EnableUnauthenticatedSender,

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
        $TrackClicks,

        [Parameter()]
        [System.Object]
        $EnableATPForSPOTeamsODB,

        [Parameter()]
        [System.Object]
        $BlockUrls,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $AllowClickThrough,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $EnableSafeLinksForO365Clients,

        [Parameter()]
        [System.Object]
        $EnableSafeLinksForWebAccessCompanion,

        [Parameter()]
        [System.Object]
        $EnableSafeDocs,

        [Parameter()]
        [System.Object]
        $AllowSafeDocsOpen,

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
        [System.Object]
        $HighConfidenceSpamAction,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $MakeDefault,

        [Parameter()]
        [System.Object]
        $QuarantineRetentionPeriod,

        [Parameter()]
        [System.Object]
        $MarkAsSpamWebBugsInHtml,

        [Parameter()]
        [System.Object]
        $EndUserSpamNotificationCustomFromName,

        [Parameter()]
        [System.Object]
        $MarkAsSpamFromAddressAuthFail,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $EndUserSpamNotificationCustomFromAddress,

        [Parameter()]
        [System.Object]
        $IncreaseScoreWithRedirectToOtherPort,

        [Parameter()]
        [System.Object]
        $BulkThreshold,

        [Parameter()]
        [System.Object]
        $EnableLanguageBlockList,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $PhishZapEnabled,

        [Parameter()]
        [System.Object]
        $EndUserSpamNotificationCustomSubject,

        [Parameter()]
        [System.Object]
        $MarkAsSpamSensitiveWordList,

        [Parameter()]
        [System.Object]
        $MarkAsSpamFormTagsInHtml,

        [Parameter()]
        [System.Object]
        $MarkAsSpamNdrBackscatter,

        [Parameter()]
        [System.Object]
        $AddXHeaderValue,

        [Parameter()]
        [System.Object]
        $BulkSpamAction,

        [Parameter()]
        [System.Object]
        $ModifySubjectValue,

        [Parameter()]
        [System.Object]
        $IncreaseScoreWithImageLinks,

        [Parameter()]
        [System.Object]
        $MarkAsSpamEmptyMessages,

        [Parameter()]
        [System.Object]
        $MarkAsSpamSpfRecordHardFail,

        [Parameter()]
        [System.Object]
        $PhishSpamAction,

        [Parameter()]
        [System.Object]
        $HighConfidencePhishAction,

        [Parameter()]
        [System.Object]
        $MarkAsSpamJavaScriptInHtml,

        [Parameter()]
        [System.Object]
        $EnableRegionBlockList,

        [Parameter()]
        [System.Object]
        $EnableEndUserSpamNotifications,

        [Parameter()]
        [System.Object]
        $TestModeAction,

        [Parameter()]
        [System.Object]
        $RedirectToRecipients,

        [Parameter()]
        [System.Object]
        $AllowedSenderDomains,

        [Parameter()]
        [System.Object]
        $MarkAsSpamObjectTagsInHtml,

        [Parameter()]
        [System.Object]
        $MarkAsSpamFramesInHtml,

        [Parameter()]
        [System.Object]
        $TestModeBccToRecipients,

        [Parameter()]
        [System.Object]
        $MarkAsSpamEmbedTagsInHtml,

        [Parameter()]
        [System.Object]
        $EndUserSpamNotificationLanguage,

        [Parameter()]
        [System.Object]
        $EndUserSpamNotificationLimit,

        [Parameter()]
        [System.Object]
        $SpamAction,

        [Parameter()]
        [System.Object]
        $InlineSafetyTipsEnabled,

        [Parameter()]
        [System.Object]
        $SpamZapEnabled,

        [Parameter()]
        [System.Object]
        $BlockedSenders,

        [Parameter()]
        [System.Object]
        $OverrideJMF,

        [Parameter()]
        [System.Object]
        $AllowedSenders,

        [Parameter()]
        [System.Object]
        $LanguageBlockList,

        [Parameter()]
        [System.Object]
        $RegionBlockList,

        [Parameter()]
        [System.Object]
        $IncreaseScoreWithBizOrInfoUrls,

        [Parameter()]
        [System.Object]
        $AdminDisplayName,

        [Parameter()]
        [System.Object]
        $EndUserSpamNotificationFrequency,

        [Parameter()]
        [System.Object]
        $IncreaseScoreWithNumericIps,

        [Parameter()]
        [System.Object]
        $BlockedSenderDomains,

        [Parameter()]
        [System.Object]
        $MarkAsSpamBulkMail,

        [Parameter()]
        [System.Object]
        $DownloadLink,

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
        $ProhibitSendReceiveQuota,

        [Parameter()]
        [System.Object]
        $CustomAttribute5,

        [Parameter()]
        [System.Object]
        $RoomMailboxPassword,

        [Parameter()]
        [System.Object]
        $MessageRecallProcessingEnabled,

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
        [System.Management.Automation.SwitchParameter]
        $UpdateEnforcedTimestamp,

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
        $SharingPolicy,

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
        $SimpleDisplayName,

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
        $WindowsEmailAddress,

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
        $Action,

        [Parameter()]
        [System.Object]
        $CustomExternalBody,

        [Parameter()]
        [System.Object]
        $EnableExternalSenderNotifications,

        [Parameter()]
        [System.Object]
        $CustomNotifications,

        [Parameter()]
        [System.Object]
        $EnableInternalSenderNotifications,

        [Parameter()]
        [System.Object]
        $EnableExternalSenderAdminNotifications,

        [Parameter()]
        [System.Object]
        $InternalSenderAdminAddress,

        [Parameter()]
        [System.Object]
        $CustomAlertText,

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
        $RequiredCharsetCoverage,

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
        $DefaultPublicFolderDeletedItemRetention,

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
        $OAuth2ClientProfileEnabled,

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
        $RemotePublicFolderMailboxes,

        [Parameter()]
        [System.Object]
        $PreferredInternetCodePageForShiftJis,

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
        [System.Object]
        $BookingsCreationOfCustomQuestionsRestricted,

        [Parameter()]
        [System.Object]
        $WebPushNotificationsDisabled,

        [Parameter()]
        [System.Object]
        $ConnectorsEnabledForOutlook,

        [Parameter()]
        [System.Object]
        $BookingsAddressEntryRestricted,

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
        $AllowPlusAddressInRecipients,

        [Parameter()]
        [System.Object]
        $LeanPopoutEnabled,

        [Parameter()]
        [System.Object]
        $DistributionGroupNameBlockedWordsList,

        [Parameter()]
        [System.Object]
        $AsyncSendEnabled,

        [Parameter()]
        [System.Object]
        $ConnectorsEnabledForSharepoint,

        [Parameter()]
        [System.Object]
        $ActivityBasedAuthenticationTimeoutWithSingleSignOnEnabled,

        [Parameter()]
        [System.Object]
        $HierarchicalAddressBookRoot,

        [Parameter()]
        [System.Object]
        $WebSuggestedRepliesDisabled,

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
        $DefaultGroupAccessType,

        [Parameter()]
        [System.Object]
        $CalendarVersionStoreEnabled,

        [Parameter()]
        [System.Object]
        $BookingsPaymentsEnabled,

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
        $BookingsMembershipApprovalRequired,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

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
        $ConnectorsActionableMessagesEnabled,

        [Parameter()]
        [System.Object]
        $MailTipsMailboxSourcedTipsEnabled,

        [Parameter()]
        [System.Object]
        $BookingsEnabled,

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
        $MatchSenderOrganizerProperties,

        [Parameter()]
        [System.Object]
        $DefaultMinutesToReduceLongEventsBy,

        [Parameter()]
        [System.Object]
        $IPListBlocked,

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
        $OutlookMobileHelpShiftEnabled,

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
        $OutlookBetaToggleEnabled,

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
        $ForceWacViewingFirstOnPublicComputers,

        [Parameter()]
        [System.Object]
        $PlacesEnabled,

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
        $WSSAccessOnPublicComputersEnabled,

        [Parameter()]
        [System.Object]
        $ForceSaveMimeTypes,

        [Parameter()]
        [System.Object]
        $WacOMEXEnabled,

        [Parameter()]
        [System.Object]
        $WacExternalServicesEnabled,

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
        $WacEditingEnabled,

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
        $RemindersAndNotificationsEnabled,

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
        $ExcludedUrls,

        [Parameter()]
        [System.Object]
        $AdminDisplayName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $UseTranslatedNotificationText,

        [Parameter()]
        [System.Object]
        $DoNotTrackUserClicks,

        [Parameter()]
        [System.Object]
        $DoNotRewriteUrls,

        [Parameter()]
        [System.Object]
        $WhiteListedUrls,

        [Parameter()]
        [System.Object]
        $TrackClicks,

        [Parameter()]
        [System.Object]
        $AllowClickThrough,

        [Parameter()]
        [System.Object]
        $DoNotAllowClickThrough,

        [Parameter()]
        [System.Object]
        $CustomNotificationText,

        [Parameter()]
        [System.Object]
        $DeliverMessageAfterScan,

        [Parameter()]
        [System.Object]
        $ScanUrls,

        [Parameter()]
        [System.Object]
        $IsEnabled,

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
#endregion
#region Intune
function Get-Organization
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $MaxPageSize,

        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $Skip,

        [Parameter()]
        [System.String[]]
        $OrderBy,

        [Parameter()]
        [System.String[]]
        $Expand,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $Top,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.String[]]
        $Select,

        [Parameter()]
        [System.String]
        $organizationId
    )
}
function Invoke-MSGraphRequest
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $HttpMethod,

        [Parameter()]
        [System.Object]
        $Content,

        [Parameter()]
        [System.Object]
        $Headers,

        [Parameter()]
        [System.String]
        $Url
    )
}
function New-Organization
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $postalCode,

        [Parameter()]
        [System.DateTimeOffset]
        $createdDateTime,

        [Parameter()]
        [System.String]
        $displayName,

        [Parameter()]
        [System.String[]]
        $businessPhones,

        [Parameter()]
        [System.String]
        $street,

        [Parameter()]
        [System.String]
        $preferredLanguage,

        [Parameter()]
        [System.String]
        $state,

        [Parameter()]
        [System.String]
        $city,

        [Parameter()]
        [System.String[]]
        $marketingNotificationEmails,

        [Parameter()]
        [System.Object[]]
        $verifiedDomains,

        [Parameter()]
        [System.Object[]]
        $assignedPlans,

        [Parameter()]
        [System.String]
        $mobileDeviceManagementAuthority,

        [Parameter()]
        [System.String]
        $country,

        [Parameter()]
        [System.String[]]
        $securityComplianceNotificationMails,

        [Parameter()]
        [System.String]
        $ODataType,

        [Parameter()]
        [System.Object]
        $privacyProfile,

        [Parameter()]
        [System.Object[]]
        $extensions,

        [Parameter()]
        [System.DateTimeOffset]
        $deletedDateTime,

        [Parameter()]
        [System.Object[]]
        $provisionedPlans,

        [Parameter()]
        [System.String[]]
        $technicalNotificationMails,

        [Parameter()]
        [System.String]
        $countryLetterCode,

        [Parameter()]
        [System.Boolean]
        $onPremisesSyncEnabled,

        [Parameter()]
        [System.String[]]
        $securityComplianceNotificationPhones,

        [Parameter()]
        [System.DateTimeOffset]
        $onPremisesLastSyncDateTime
    )
}
function Remove-Organization
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $organizationId
    )
}
function Get-IntuneAppConfigurationPolicyTargeted
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $MaxPageSize,

        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $Skip,

        [Parameter()]
        [System.String]
        $targetedManagedAppConfigurationId,

        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $Top,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $Search
    )
}
function Get-IntuneAppProtectionPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $MaxPageSize,

        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $Skip,

        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $Top,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $managedAppPolicyId,

        [Parameter()]
        [System.String]
        $Search
    )
}
function Get-IntuneDeviceCategory
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $deviceCategoryId,

        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $Skip,

        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $MaxPageSize,

        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $Top,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $Search
    )
}
function Get-IntuneDeviceCompliancePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $MaxPageSize,

        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $Skip,

        [Parameter()]
        [System.String]
        $deviceCompliancePolicyId,

        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $Top,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $Search
    )
}
function Get-IntuneDeviceConfigurationPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $MaxPageSize,

        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $Skip,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.String]
        $deviceConfigurationId,

        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $Top,

        [Parameter()]
        [System.String]
        $Filter
    )
}
function Get-IntuneDeviceEnrollmentConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $MaxPageSize,

        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $Skip,

        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $Top,

        [Parameter()]
        [System.String]
        $deviceEnrollmentConfigurationId,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $Search
    )
}
function New-IntuneAppConfigurationPolicyTargeted
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $description,

        [Parameter()]
        [System.String]
        $displayName,

        [Parameter()]
        [System.Object[]]
        $customSettings,

        [Parameter()]
        [System.String]
        $version,

        [Parameter()]
        [System.Object[]]
        $apps,

        [Parameter()]
        [System.DateTimeOffset]
        $createdDateTime,

        [Parameter()]
        [System.Object]
        $deploymentSummary,

        [Parameter()]
        [System.String]
        $ODataType,

        [Parameter()]
        [System.Boolean]
        $isAssigned,

        [Parameter()]
        [System.DateTimeOffset]
        $lastModifiedDateTime,

        [Parameter()]
        [System.Int32]
        $deployedAppCount,

        [Parameter()]
        [System.Object[]]
        $assignments
    )
}
function New-IntuneDeviceCategory
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $description,

        [Parameter()]
        [System.String]
        $displayName,

        [Parameter()]
        [System.String]
        $ODataType
    )
}
function New-IntuneDeviceCompliancePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $passcodeBlockSimple,

        [Parameter()]
        [System.Boolean]
        $firewallEnabled,

        [Parameter()]
        [System.String]
        $mobileOsMinimumVersion,

        [Parameter()]
        [System.Int32]
        $passcodeExpirationDays,

        [Parameter()]
        [System.Boolean]
        $bitLockerEnabled,

        [Parameter()]
        [System.String]
        $minAndroidSecurityPatchLevel,

        [Parameter()]
        [System.Object[]]
        $userStatuses,

        [Parameter()]
        [System.Object[]]
        $deviceSettingStateSummaries,

        [Parameter()]
        [System.String]
        $ODataType,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $iosCompliancePolicy,

        [Parameter()]
        [System.DateTimeOffset]
        $createdDateTime,

        [Parameter()]
        [System.Boolean]
        $firewallEnableStealthMode,

        [Parameter()]
        [System.String]
        $passwordRequiredType,

        [Parameter()]
        [System.String]
        $osMinimumVersion,

        [Parameter()]
        [System.String]
        $deviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $windowsPhone81CompliancePolicy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $windows81CompliancePolicy,

        [Parameter()]
        [System.Boolean]
        $securityRequireGooglePlayServices,

        [Parameter()]
        [System.String]
        $mobileOsMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $securityDisableUsbDebugging,

        [Parameter()]
        [System.Boolean]
        $storageRequireEncryption,

        [Parameter()]
        [System.Int32]
        $passcodeMinimumLength,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $windows10CompliancePolicy,

        [Parameter()]
        [System.Object]
        $userStatusOverview,

        [Parameter()]
        [System.Boolean]
        $codeIntegrityEnabled,

        [Parameter()]
        [System.Boolean]
        $securityRequireUpToDateSecurityProviders,

        [Parameter()]
        [System.Boolean]
        $securityBlockJailbrokenDevices,

        [Parameter()]
        [System.Int32]
        $passcodeMinimumCharacterSetCount,

        [Parameter()]
        [System.Boolean]
        $securityRequireSafetyNetAttestationBasicIntegrity,

        [Parameter()]
        [System.String]
        $displayName,

        [Parameter()]
        [System.Int32]
        $passcodePreviousPasscodeBlockCount,

        [Parameter()]
        [System.Int32]
        $passcodeMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int32]
        $passwordExpirationDays,

        [Parameter()]
        [System.Boolean]
        $securityRequireCompanyPortalAppIntegrity,

        [Parameter()]
        [System.String]
        $description,

        [Parameter()]
        [System.Boolean]
        $securityPreventInstallAppsFromUnknownSources,

        [Parameter()]
        [System.Int32]
        $passwordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Boolean]
        $firewallBlockAllIncoming,

        [Parameter()]
        [System.Boolean]
        $passwordRequiredToUnlockFromIdle,

        [Parameter()]
        [System.Boolean]
        $securityRequireSafetyNetAttestationCertifiedDevice,

        [Parameter()]
        [System.Int32]
        $passwordMinimumCharacterSetCount,

        [Parameter()]
        [System.Boolean]
        $earlyLaunchAntiMalwareDriverEnabled,

        [Parameter()]
        [System.Boolean]
        $passwordBlockSimple,

        [Parameter()]
        [System.Boolean]
        $requireHealthyDeviceReport,

        [Parameter()]
        [System.String]
        $passcodeRequiredType,

        [Parameter()]
        [System.Int32]
        $version,

        [Parameter()]
        [System.Boolean]
        $passwordRequired,

        [Parameter()]
        [System.Boolean]
        $passwordRequireToUnlockFromIdle,

        [Parameter()]
        [System.Object[]]
        $assignments,

        [Parameter()]
        [System.Int32]
        $passwordMinimumLength,

        [Parameter()]
        [System.Boolean]
        $systemIntegrityProtectionEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $androidCompliancePolicy,

        [Parameter()]
        [System.Object[]]
        $deviceStatuses,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $macOSCompliancePolicy,

        [Parameter()]
        [System.Boolean]
        $passcodeRequired,

        [Parameter()]
        [System.Boolean]
        $deviceThreatProtectionEnabled,

        [Parameter()]
        [System.Boolean]
        $managedEmailProfileRequired,

        [Parameter()]
        [System.Boolean]
        $secureBootEnabled,

        [Parameter()]
        [System.Boolean]
        $securityRequireVerifyApps,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $androidWorkProfileCompliancePolicy,

        [Parameter()]
        [System.Object]
        $deviceStatusOverview,

        [Parameter()]
        [System.DateTimeOffset]
        $lastModifiedDateTime,

        [Parameter()]
        [System.Object[]]
        $scheduledActionsForRule,

        [Parameter()]
        [System.String]
        $osMaximumVersion,

        [Parameter()]
        [System.Int32]
        $passwordMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $windows10MobileCompliancePolicy
    )
}
function Remove-IntuneAppConfigurationPolicyTargeted
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $targetedManagedAppConfigurationId
    )
}
function Remove-IntuneAppProtectionPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $managedAppPolicyId
    )
}
function Remove-IntuneDeviceCategory
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $deviceCategoryId
    )
}
function Remove-IntuneDeviceCompliancePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $deviceCompliancePolicyId
    )
}
function Remove-IntuneDeviceConfigurationPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $deviceConfigurationId
    )
}
function Remove-IntuneDeviceEnrollmentConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $deviceEnrollmentConfigurationId
    )
}
function Update-IntuneAppConfigurationPolicyTargeted
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $description,

        [Parameter()]
        [System.String]
        $displayName,

        [Parameter()]
        [System.Object[]]
        $customSettings,

        [Parameter()]
        [System.String]
        $version,

        [Parameter()]
        [System.Object[]]
        $apps,

        [Parameter()]
        [System.DateTimeOffset]
        $createdDateTime,

        [Parameter()]
        [System.Object]
        $deploymentSummary,

        [Parameter()]
        [System.String]
        $ODataType,

        [Parameter()]
        [System.Boolean]
        $isAssigned,

        [Parameter()]
        [System.String]
        $targetedManagedAppConfigurationId,

        [Parameter()]
        [System.DateTimeOffset]
        $lastModifiedDateTime,

        [Parameter()]
        [System.Int32]
        $deployedAppCount,

        [Parameter()]
        [System.Object[]]
        $assignments
    )
}
function Update-IntuneDeviceCategory
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $deviceCategoryId,

        [Parameter()]
        [System.String]
        $description,

        [Parameter()]
        [System.String]
        $displayName,

        [Parameter()]
        [System.String]
        $ODataType
    )
}
function Update-IntuneDeviceCompliancePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $passcodeBlockSimple,

        [Parameter()]
        [System.Boolean]
        $firewallEnabled,

        [Parameter()]
        [System.String]
        $mobileOsMinimumVersion,

        [Parameter()]
        [System.Int32]
        $passcodeExpirationDays,

        [Parameter()]
        [System.Boolean]
        $bitLockerEnabled,

        [Parameter()]
        [System.String]
        $minAndroidSecurityPatchLevel,

        [Parameter()]
        [System.Object[]]
        $userStatuses,

        [Parameter()]
        [System.Object[]]
        $deviceSettingStateSummaries,

        [Parameter()]
        [System.String]
        $ODataType,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $iosCompliancePolicy,

        [Parameter()]
        [System.DateTimeOffset]
        $createdDateTime,

        [Parameter()]
        [System.Boolean]
        $firewallEnableStealthMode,

        [Parameter()]
        [System.String]
        $passwordRequiredType,

        [Parameter()]
        [System.String]
        $osMinimumVersion,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $windowsPhone81CompliancePolicy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $windows81CompliancePolicy,

        [Parameter()]
        [System.Boolean]
        $securityRequireGooglePlayServices,

        [Parameter()]
        [System.String]
        $mobileOsMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $securityDisableUsbDebugging,

        [Parameter()]
        [System.Boolean]
        $storageRequireEncryption,

        [Parameter()]
        [System.Int32]
        $passcodeMinimumLength,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $windows10CompliancePolicy,

        [Parameter()]
        [System.Object]
        $userStatusOverview,

        [Parameter()]
        [System.Boolean]
        $codeIntegrityEnabled,

        [Parameter()]
        [System.Boolean]
        $securityRequireUpToDateSecurityProviders,

        [Parameter()]
        [System.Boolean]
        $securityBlockJailbrokenDevices,

        [Parameter()]
        [System.Int32]
        $passcodeMinimumCharacterSetCount,

        [Parameter()]
        [System.Boolean]
        $securityRequireSafetyNetAttestationBasicIntegrity,

        [Parameter()]
        [System.String]
        $displayName,

        [Parameter()]
        [System.DateTimeOffset]
        $lastModifiedDateTime,

        [Parameter()]
        [System.Int32]
        $passcodePreviousPasscodeBlockCount,

        [Parameter()]
        [System.Int32]
        $passcodeMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int32]
        $passwordExpirationDays,

        [Parameter()]
        [System.Boolean]
        $securityRequireCompanyPortalAppIntegrity,

        [Parameter()]
        [System.String]
        $description,

        [Parameter()]
        [System.Boolean]
        $securityPreventInstallAppsFromUnknownSources,

        [Parameter()]
        [System.Int32]
        $passwordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Boolean]
        $firewallBlockAllIncoming,

        [Parameter()]
        [System.Object]
        $deviceStatusOverview,

        [Parameter()]
        [System.Boolean]
        $securityRequireSafetyNetAttestationCertifiedDevice,

        [Parameter()]
        [System.Int32]
        $passwordMinimumCharacterSetCount,

        [Parameter()]
        [System.Boolean]
        $earlyLaunchAntiMalwareDriverEnabled,

        [Parameter()]
        [System.Boolean]
        $passwordBlockSimple,

        [Parameter()]
        [System.Boolean]
        $requireHealthyDeviceReport,

        [Parameter()]
        [System.String]
        $passcodeRequiredType,

        [Parameter()]
        [System.Int32]
        $version,

        [Parameter()]
        [System.Boolean]
        $passwordRequired,

        [Parameter()]
        [System.Boolean]
        $passwordRequireToUnlockFromIdle,

        [Parameter()]
        [System.Object[]]
        $assignments,

        [Parameter()]
        [System.Int32]
        $passwordMinimumLength,

        [Parameter()]
        [System.Boolean]
        $systemIntegrityProtectionEnabled,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $androidCompliancePolicy,

        [Parameter()]
        [System.Object[]]
        $deviceStatuses,

        [Parameter()]
        [System.String]
        $deviceCompliancePolicyId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $macOSCompliancePolicy,

        [Parameter()]
        [System.Boolean]
        $passcodeRequired,

        [Parameter()]
        [System.Boolean]
        $deviceThreatProtectionEnabled,

        [Parameter()]
        [System.Boolean]
        $secureBootEnabled,

        [Parameter()]
        [System.Boolean]
        $securityRequireVerifyApps,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $androidWorkProfileCompliancePolicy,

        [Parameter()]
        [System.Boolean]
        $managedEmailProfileRequired,

        [Parameter()]
        [System.String]
        $deviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.Object[]]
        $scheduledActionsForRule,

        [Parameter()]
        [System.String]
        $osMaximumVersion,

        [Parameter()]
        [System.Int32]
        $passwordMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Boolean]
        $passwordRequiredToUnlockFromIdle,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $windows10MobileCompliancePolicy
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
        [System.Management.Automation.SwitchParameter]
        $LocalStore,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $Filter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-CsOnlinePstnUsage
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $LocalStore,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $Filter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-CsOnlineUser
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Credential,

        [Parameter()]
        [System.Object]
        $LdapFilter,

        [Parameter()]
        [System.Object]
        $Filter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $OnModernServer,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $OnOfficeCommunicationServer,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $OU,

        [Parameter()]
        [System.Object]
        $DomainController,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $UnassignedUser,

        [Parameter()]
        [System.Object]
        $ResultSize,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $UsePreferredDC,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $SkipUserPolicies,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-CsOnlineVoiceRoute
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $LocalStore,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $Filter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-CsOnlineVoiceRoutingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $LocalStore,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $Filter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-CsTeamsCallingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $LocalStore,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $Filter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-CsTeamsChannelsPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $LocalStore,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $Filter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-CsTeamsClientConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $LocalStore,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $Filter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-CsTeamsEmergencyCallingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $LocalStore,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $Filter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-CsTeamsEmergencyCallRoutingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $LocalStore,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $Filter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-CsTeamsGuestCallingConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $LocalStore,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $Filter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-CsTeamsGuestMeetingConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $LocalStore,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $Filter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-CsTeamsGuestMessagingConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $LocalStore,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $Filter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        [System.Management.Automation.SwitchParameter]
        $LocalStore,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $Filter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-CsTeamsMeetingBroadcastPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $LocalStore,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $Filter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-CsTeamsMeetingConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $LocalStore,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $Filter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-CsTeamsMeetingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $LocalStore,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $Filter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-CsTeamsMessagingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $LocalStore,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $Filter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-CsTeamsUpgradeConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $LocalStore,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $Filter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-CsTeamsUpgradePolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $LocalStore,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $Filter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-CsTenant
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Filter,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $DomainController,

        [Parameter()]
        [System.Object]
        $ResultSize,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Get-CsTenantDialPlan
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $LocalStore,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $Filter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $PolicyName,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Global,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $MigrateMeetingsToTeams,

        [Parameter()]
        [System.Object]
        $DomainController,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-CsOnlineVoiceRoute
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $BridgeSourcePhoneNumber,

        [Parameter()]
        [System.Object]
        $Description,

        [Parameter()]
        [System.Object]
        $Priority,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $OnlinePstnGatewayList,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $InMemory,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $NumberPattern,

        [Parameter()]
        [System.Object]
        $OnlinePstnUsages,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-CsOnlineVoiceRoutingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $RouteType,

        [Parameter()]
        [System.Object]
        $OnlinePstnUsages,

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
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $InMemory,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-CsTeamsCallingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $AllowWebPSTNCalling,

        [Parameter()]
        [System.Object]
        $Description,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $InMemory,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $AllowCloudRecordingForCalls,

        [Parameter()]
        [System.Object]
        $LiveCaptionsEnabledTypeForCalling,

        [Parameter()]
        [System.Object]
        $AllowCallGroups,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $SafeTransferEnabled,

        [Parameter()]
        [System.Object]
        $SpamFilteringEnabledType,

        [Parameter()]
        [System.Object]
        $BusyOnBusyEnabledType,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $AllowVoicemail,

        [Parameter()]
        [System.Object]
        $MusicOnHoldEnabledType,

        [Parameter()]
        [System.Object]
        $PreventTollBypass,

        [Parameter()]
        [System.Object]
        $AllowCallForwardingToUser,

        [Parameter()]
        [System.Object]
        $AllowCallForwardingToPhone,

        [Parameter()]
        [System.Object]
        $AllowPrivateCalling,

        [Parameter()]
        [System.Object]
        $CallRecordingExpirationDays,

        [Parameter()]
        [System.Object]
        $AllowDelegation,

        [Parameter()]
        [System.Object]
        $AutoAnswerEnabledType,

        [Parameter()]
        [System.Object]
        $AllowTranscriptionForCalling,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-CsTeamsChannelsPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $AllowPrivateChannelCreation,

        [Parameter()]
        [System.Object]
        $Description,

        [Parameter()]
        [System.Object]
        $AllowChannelSharingToExternalUser,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $InMemory,

        [Parameter()]
        [System.Object]
        $AllowSharedChannelCreation,

        [Parameter()]
        [System.Object]
        $AllowPrivateTeamDiscovery,

        [Parameter()]
        [System.Object]
        $AllowOrgWideTeamCreation,

        [Parameter()]
        [System.Object]
        $AllowUserToParticipateInExternalSharedChannel,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-CsTeamsEmergencyCallingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Description,

        [Parameter()]
        [System.Object]
        $NotificationGroup,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $NotificationDialOutNumber,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $InMemory,

        [Parameter()]
        [System.Object]
        $NotificationMode,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $ExternalLocationLookupMode,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-CsTeamsEmergencyCallRoutingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $EmergencyNumbers,

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
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $InMemory,

        [Parameter()]
        [System.Object]
        $AllowEnhancedEmergencyServices,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-CsTeamsEmergencyNumber
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $EmergencyDialString,

        [Parameter()]
        [System.Object]
        $EmergencyDialMask,

        [Parameter()]
        [System.Object]
        $OnlinePSTNUsage,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-CsTeamsMeetingBroadcastPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Description,

        [Parameter()]
        [System.Object]
        $BroadcastRecordingMode,

        [Parameter()]
        [System.Object]
        $BroadcastAttendeeVisibilityMode,

        [Parameter()]
        [System.Object]
        $AllowBroadcastTranscription,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $InMemory,

        [Parameter()]
        [System.Object]
        $AllowBroadcastScheduling,

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
function New-CsTeamsMeetingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $TeamsCameraFarEndPTZMode,

        [Parameter()]
        [System.Object]
        $AllowTrackingInReport,

        [Parameter()]
        [System.Object]
        $MeetingRecordingExpirationDays,

        [Parameter()]
        [System.Object]
        $AllowMeetNow,

        [Parameter()]
        [System.Object]
        $AllowIPAudio,

        [Parameter()]
        [System.Object]
        $AllowWhiteboard,

        [Parameter()]
        [System.Object]
        $AllowAnonymousUsersToDialOut,

        [Parameter()]
        [System.Object]
        $StreamingAttendeeMode,

        [Parameter()]
        [System.Object]
        $AllowTranscription,

        [Parameter()]
        [System.Object]
        $RoomAttributeUserOverride,

        [Parameter()]
        [System.Object]
        $AllowUserToJoinExternalMeeting,

        [Parameter()]
        [System.Object]
        $AllowExternalParticipantGiveRequestControl,

        [Parameter()]
        [System.Object]
        $AllowAnonymousUsersToStartMeeting,

        [Parameter()]
        [System.Object]
        $MeetingInviteLanguage2,

        [Parameter()]
        [System.Object]
        $AllowMeetingRegistration,

        [Parameter()]
        [System.Object]
        $RecordingStorageMode,

        [Parameter()]
        [System.Object]
        $ScreenSharingMode,

        [Parameter()]
        [System.Object]
        $RoomPeopleNameUserOverride,

        [Parameter()]
        [System.Object]
        $AllowPrivateMeetNow,

        [Parameter()]
        [System.Object]
        $AllowEngagementReport,

        [Parameter()]
        [System.Object]
        $AllowNDIStreaming,

        [Parameter()]
        [System.Object]
        $AllowPSTNUsersToBypassLobby,

        [Parameter()]
        [System.Object]
        $PreferredMeetingProviderForIslandsMode,

        [Parameter()]
        [System.Object]
        $AllowOrganizersToOverrideLobbySettings,

        [Parameter()]
        [System.Object]
        $LiveCaptionsEnabledType,

        [Parameter()]
        [System.Object]
        $Description,

        [Parameter()]
        [System.Object]
        $AllowMeetingCoach,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $MeetingInviteLanguage1,

        [Parameter()]
        [System.Object]
        $AllowScreenContentDigitization,

        [Parameter()]
        [System.Object]
        $WhoCanRegister,

        [Parameter()]
        [System.Object]
        $AutoAdmittedUsers,

        [Parameter()]
        [System.Object]
        $AllowCloudRecording,

        [Parameter()]
        [System.Object]
        $AllowIPVideo,

        [Parameter()]
        [System.Object]
        $SpeakerAttributionMode,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $AllowOutlookAddIn,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $IPAudioMode,

        [Parameter()]
        [System.Object]
        $DesignatedPresenterRoleMode,

        [Parameter()]
        [System.Object]
        $MeetingChatEnabledType,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $AllowParticipantGiveRequestControl,

        [Parameter()]
        [System.Object]
        $MediaBitRateKb,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $InMemory,

        [Parameter()]
        [System.Object]
        $EnrollUserOverride,

        [Parameter()]
        [System.Object]
        $AllowSharedNotes,

        [Parameter()]
        [System.Object]
        $AllowPowerPointSharing,

        [Parameter()]
        [System.Object]
        $AllowPrivateMeetingScheduling,

        [Parameter()]
        [System.Object]
        $AllowMeetingReactions,

        [Parameter()]
        [System.Object]
        $AllowChannelMeetingScheduling,

        [Parameter()]
        [System.Object]
        $VideoFiltersMode,

        [Parameter()]
        [System.Object]
        $LiveStreamingMode,

        [Parameter()]
        [System.Object]
        $AllowBreakoutRooms,

        [Parameter()]
        [System.Object]
        $AllowRecordingStorageOutsideRegion,

        [Parameter()]
        [System.Object]
        $AllowCarbonSummary,

        [Parameter()]
        [System.Object]
        $IPVideoMode,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-CsTeamsMessagingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $AllowOwnerDeleteMessage,

        [Parameter()]
        [System.Object]
        $AllowSmartReply,

        [Parameter()]
        [System.Object]
        $AllowUserChat,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $InMemory,

        [Parameter()]
        [System.Object]
        $AllowGiphy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $AllowUserDeleteMessage,

        [Parameter()]
        [System.Object]
        $ChannelsInChatListEnabledType,

        [Parameter()]
        [System.Object]
        $AllowMemes,

        [Parameter()]
        [System.Object]
        $Description,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $AllowStickers,

        [Parameter()]
        [System.Object]
        $AllowSmartCompose,

        [Parameter()]
        [System.Object]
        $AllowFullChatPermissionUserToDeleteAnyMessage,

        [Parameter()]
        [System.Object]
        $AllowUrlPreviews,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $AllowImmersiveReader,

        [Parameter()]
        [System.Object]
        $AllowUserTranslation,

        [Parameter()]
        [System.Object]
        $AllowUserEditMessage,

        [Parameter()]
        [System.Object]
        $AudioMessageEnabledType,

        [Parameter()]
        [System.Object]
        $AllowRemoveUser,

        [Parameter()]
        [System.Object]
        $AllowPasteInternetImage,

        [Parameter()]
        [System.Object]
        $ReadReceiptsEnabledType,

        [Parameter()]
        [System.Object]
        $ChatPermissionRole,

        [Parameter()]
        [System.Object]
        $AllowGiphyDisplay,

        [Parameter()]
        [System.Object]
        $AllowFluidCollaborate,

        [Parameter()]
        [System.Object]
        $AllowPriorityMessages,

        [Parameter()]
        [System.Object]
        $GiphyRatingType,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function New-CsTenantDialPlan
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $OptimizeDeviceDialing,

        [Parameter()]
        [System.Object]
        $Description,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $NormalizationRules,

        [Parameter()]
        [System.Object]
        $SimpleName,

        [Parameter()]
        [System.Object]
        $ExternalAccessPrefix,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $InMemory,

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
function New-CsVoiceNormalizationRule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Description,

        [Parameter()]
        [System.Object]
        $Priority,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $Pattern,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Parent,

        [Parameter()]
        [System.Object]
        $Translation,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $InMemory,

        [Parameter()]
        [System.Object]
        $IsInternalExtension,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $Instance,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-CsOnlineVoiceRoute
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $BridgeSourcePhoneNumber,

        [Parameter()]
        [System.Object]
        $Description,

        [Parameter()]
        [System.Object]
        $Priority,

        [Parameter()]
        [System.Object]
        $OnlinePstnGatewayList,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $NumberPattern,

        [Parameter()]
        [System.Object]
        $OnlinePstnUsages,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $Instance,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-CsOnlineVoiceRoutingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $RouteType,

        [Parameter()]
        [System.Object]
        $OnlinePstnUsages,

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
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $Instance,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-CsTeamsCallingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $AllowWebPSTNCalling,

        [Parameter()]
        [System.Object]
        $Description,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $PreventTollBypass,

        [Parameter()]
        [System.Object]
        $Instance,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $AllowCloudRecordingForCalls,

        [Parameter()]
        [System.Object]
        $LiveCaptionsEnabledTypeForCalling,

        [Parameter()]
        [System.Object]
        $AllowCallGroups,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $SafeTransferEnabled,

        [Parameter()]
        [System.Object]
        $SpamFilteringEnabledType,

        [Parameter()]
        [System.Object]
        $BusyOnBusyEnabledType,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $AllowVoicemail,

        [Parameter()]
        [System.Object]
        $MusicOnHoldEnabledType,

        [Parameter()]
        [System.Object]
        $AllowCallForwardingToUser,

        [Parameter()]
        [System.Object]
        $AllowCallForwardingToPhone,

        [Parameter()]
        [System.Object]
        $AllowPrivateCalling,

        [Parameter()]
        [System.Object]
        $CallRecordingExpirationDays,

        [Parameter()]
        [System.Object]
        $AllowDelegation,

        [Parameter()]
        [System.Object]
        $AutoAnswerEnabledType,

        [Parameter()]
        [System.Object]
        $AllowTranscriptionForCalling,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-CsTeamsChannelsPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $AllowPrivateChannelCreation,

        [Parameter()]
        [System.Object]
        $Description,

        [Parameter()]
        [System.Object]
        $AllowChannelSharingToExternalUser,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $AllowPrivateTeamDiscovery,

        [Parameter()]
        [System.Object]
        $AllowSharedChannelCreation,

        [Parameter()]
        [System.Object]
        $AllowOrgWideTeamCreation,

        [Parameter()]
        [System.Object]
        $AllowUserToParticipateInExternalSharedChannel,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $Instance,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-CsTeamsClientConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $AllowEmailIntoChannel,

        [Parameter()]
        [System.Object]
        $RestrictedSenderList,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Instance,

        [Parameter()]
        [System.Object]
        $AllowGoogleDrive,

        [Parameter()]
        [System.Object]
        $AllowScopedPeopleSearchandAccess,

        [Parameter()]
        [System.Object]
        $AllowSkypeBusinessInterop,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $AllowShareFile,

        [Parameter()]
        [System.Object]
        $AllowGuestUser,

        [Parameter()]
        [System.Object]
        $AllowOrganizationTab,

        [Parameter()]
        [System.Object]
        $ResourceAccountContentAccess,

        [Parameter()]
        [System.Object]
        $AllowRoleBasedChatPermissions,

        [Parameter()]
        [System.Object]
        $AllowEgnyte,

        [Parameter()]
        [System.Object]
        $AllowBox,

        [Parameter()]
        [System.Object]
        $AllowResourceAccountSendMessage,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $ContentPin,

        [Parameter()]
        [System.Object]
        $AllowDropBox,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-CsTeamsEmergencyCallingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Description,

        [Parameter()]
        [System.Object]
        $NotificationGroup,

        [Parameter()]
        [System.Object]
        $ExternalLocationLookupMode,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $NotificationDialOutNumber,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $NotificationMode,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $Instance,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-CsTeamsEmergencyCallRoutingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $EmergencyNumbers,

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
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $AllowEnhancedEmergencyServices,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $Instance,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
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
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $AllowPrivateCalling,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $Instance,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-CsTeamsGuestMeetingConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $LiveCaptionsEnabledType,

        [Parameter()]
        [System.Object]
        $ScreenSharingMode,

        [Parameter()]
        [System.Object]
        $AllowMeetNow,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $AllowTranscription,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $AllowIPVideo,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $Instance,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-CsTeamsGuestMessagingConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $AllowMemes,

        [Parameter()]
        [System.Object]
        $AllowImmersiveReader,

        [Parameter()]
        [System.Object]
        $AllowGiphy,

        [Parameter()]
        [System.Object]
        $AllowStickers,

        [Parameter()]
        [System.Object]
        $AllowUserEditMessage,

        [Parameter()]
        [System.Object]
        $AllowUserDeleteMessage,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $AllowUserChat,

        [Parameter()]
        [System.Object]
        $GiphyRatingType,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $Instance,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-CsTeamsMeetingBroadcastConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $SupportURL,

        [Parameter()]
        [System.Object]
        $AllowSdnProviderForBroadcastMeeting,

        [Parameter()]
        [System.Object]
        $SdnProviderName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $SdnRuntimeConfiguration,

        [Parameter()]
        [System.Object]
        $SdnApiToken,

        [Parameter()]
        [System.Object]
        $SdnApiTemplateUrl,

        [Parameter()]
        [System.Object]
        $SdnLicenseId,

        [Parameter()]
        [System.Object]
        $Instance,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-CsTeamsMeetingBroadcastPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $Description,

        [Parameter()]
        [System.Object]
        $BroadcastRecordingMode,

        [Parameter()]
        [System.Object]
        $BroadcastAttendeeVisibilityMode,

        [Parameter()]
        [System.Object]
        $AllowBroadcastTranscription,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $AllowBroadcastScheduling,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $Instance,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-CsTeamsMeetingConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $ClientVideoPortRange,

        [Parameter()]
        [System.Object]
        $DisableAnonymousJoin,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Instance,

        [Parameter()]
        [System.Object]
        $ClientAppSharingPortRange,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $EnableQoS,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $DisableAppInteractionForAnonymousUsers,

        [Parameter()]
        [System.Object]
        $LogoURL,

        [Parameter()]
        [System.Object]
        $ClientAppSharingPort,

        [Parameter()]
        [System.Object]
        $ClientVideoPort,

        [Parameter()]
        [System.Object]
        $ClientAudioPortRange,

        [Parameter()]
        [System.Object]
        $ClientMediaPortRangeEnabled,

        [Parameter()]
        [System.Object]
        $ClientAudioPort,

        [Parameter()]
        [System.Object]
        $CustomFooterText,

        [Parameter()]
        [System.Object]
        $HelpURL,

        [Parameter()]
        [System.Object]
        $LegalURL,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-CsTeamsMeetingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $TeamsCameraFarEndPTZMode,

        [Parameter()]
        [System.Object]
        $AllowTrackingInReport,

        [Parameter()]
        [System.Object]
        $MeetingRecordingExpirationDays,

        [Parameter()]
        [System.Object]
        $AllowMeetNow,

        [Parameter()]
        [System.Object]
        $AllowIPAudio,

        [Parameter()]
        [System.Object]
        $AllowWhiteboard,

        [Parameter()]
        [System.Object]
        $AllowAnonymousUsersToDialOut,

        [Parameter()]
        [System.Object]
        $StreamingAttendeeMode,

        [Parameter()]
        [System.Object]
        $AllowTranscription,

        [Parameter()]
        [System.Object]
        $RoomAttributeUserOverride,

        [Parameter()]
        [System.Object]
        $AllowUserToJoinExternalMeeting,

        [Parameter()]
        [System.Object]
        $AllowExternalParticipantGiveRequestControl,

        [Parameter()]
        [System.Object]
        $AllowAnonymousUsersToStartMeeting,

        [Parameter()]
        [System.Object]
        $MeetingInviteLanguage2,

        [Parameter()]
        [System.Object]
        $AllowMeetingRegistration,

        [Parameter()]
        [System.Object]
        $RecordingStorageMode,

        [Parameter()]
        [System.Object]
        $ScreenSharingMode,

        [Parameter()]
        [System.Object]
        $RoomPeopleNameUserOverride,

        [Parameter()]
        [System.Object]
        $AllowPrivateMeetNow,

        [Parameter()]
        [System.Object]
        $AllowEngagementReport,

        [Parameter()]
        [System.Object]
        $AllowNDIStreaming,

        [Parameter()]
        [System.Object]
        $AllowPSTNUsersToBypassLobby,

        [Parameter()]
        [System.Object]
        $PreferredMeetingProviderForIslandsMode,

        [Parameter()]
        [System.Object]
        $AllowOrganizersToOverrideLobbySettings,

        [Parameter()]
        [System.Object]
        $LiveCaptionsEnabledType,

        [Parameter()]
        [System.Object]
        $Description,

        [Parameter()]
        [System.Object]
        $AllowMeetingCoach,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $MeetingInviteLanguage1,

        [Parameter()]
        [System.Object]
        $AllowScreenContentDigitization,

        [Parameter()]
        [System.Object]
        $WhoCanRegister,

        [Parameter()]
        [System.Object]
        $AutoAdmittedUsers,

        [Parameter()]
        [System.Object]
        $AllowCloudRecording,

        [Parameter()]
        [System.Object]
        $AllowIPVideo,

        [Parameter()]
        [System.Object]
        $SpeakerAttributionMode,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $AllowOutlookAddIn,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $IPAudioMode,

        [Parameter()]
        [System.Object]
        $DesignatedPresenterRoleMode,

        [Parameter()]
        [System.Object]
        $MeetingChatEnabledType,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $AllowParticipantGiveRequestControl,

        [Parameter()]
        [System.Object]
        $MediaBitRateKb,

        [Parameter()]
        [System.Object]
        $EnrollUserOverride,

        [Parameter()]
        [System.Object]
        $AllowSharedNotes,

        [Parameter()]
        [System.Object]
        $AllowPowerPointSharing,

        [Parameter()]
        [System.Object]
        $AllowPrivateMeetingScheduling,

        [Parameter()]
        [System.Object]
        $AllowMeetingReactions,

        [Parameter()]
        [System.Object]
        $AllowChannelMeetingScheduling,

        [Parameter()]
        [System.Object]
        $VideoFiltersMode,

        [Parameter()]
        [System.Object]
        $LiveStreamingMode,

        [Parameter()]
        [System.Object]
        $AllowBreakoutRooms,

        [Parameter()]
        [System.Object]
        $AllowRecordingStorageOutsideRegion,

        [Parameter()]
        [System.Object]
        $AllowCarbonSummary,

        [Parameter()]
        [System.Object]
        $IPVideoMode,

        [Parameter()]
        [System.Object]
        $Instance,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-CsTeamsMessagingPolicy
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $AllowOwnerDeleteMessage,

        [Parameter()]
        [System.Object]
        $AllowSmartReply,

        [Parameter()]
        [System.Object]
        $AllowUserChat,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $AllowGiphy,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Instance,

        [Parameter()]
        [System.Object]
        $AllowUserDeleteMessage,

        [Parameter()]
        [System.Object]
        $ChannelsInChatListEnabledType,

        [Parameter()]
        [System.Object]
        $AllowMemes,

        [Parameter()]
        [System.Object]
        $Description,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $AllowStickers,

        [Parameter()]
        [System.Object]
        $AllowSmartCompose,

        [Parameter()]
        [System.Object]
        $AllowFullChatPermissionUserToDeleteAnyMessage,

        [Parameter()]
        [System.Object]
        $AllowUrlPreviews,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $AllowImmersiveReader,

        [Parameter()]
        [System.Object]
        $AllowUserTranslation,

        [Parameter()]
        [System.Object]
        $AllowUserEditMessage,

        [Parameter()]
        [System.Object]
        $AudioMessageEnabledType,

        [Parameter()]
        [System.Object]
        $AllowRemoveUser,

        [Parameter()]
        [System.Object]
        $AllowPasteInternetImage,

        [Parameter()]
        [System.Object]
        $ReadReceiptsEnabledType,

        [Parameter()]
        [System.Object]
        $ChatPermissionRole,

        [Parameter()]
        [System.Object]
        $AllowGiphyDisplay,

        [Parameter()]
        [System.Object]
        $AllowFluidCollaborate,

        [Parameter()]
        [System.Object]
        $AllowPriorityMessages,

        [Parameter()]
        [System.Object]
        $GiphyRatingType,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-CsTeamsUpgradeConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $SfBMeetingJoinUx,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $DownloadTeams,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $Instance,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsJob
    )
}
function Set-CsTenantDialPlan
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $OptimizeDeviceDialing,

        [Parameter()]
        [System.Object]
        $Description,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $NormalizationRules,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $ExternalAccessPrefix,

        [Parameter()]
        [System.Object]
        $Tenant,

        [Parameter()]
        [System.Object]
        $SimpleName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Object]
        $Instance,

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
        $Description,

        [Parameter()]
        [System.String]
        $PreviewImageUrl,

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
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.String]
        $PreviewImageAltText,

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
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AsListItem,

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
        $AsFile
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
        [PnP.PowerShell.Commands.Base.PipeBinds.WebPipeBind]
        $Web,

        [Parameter()]
        [PnP.PowerShell.Commands.Enums.SearchConfigurationScope]
        $Scope,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [PnP.PowerShell.Commands.Search.OutputFormat]
        $OutputFormat,

        [Parameter()]
        [System.String]
        $Path
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
        [System.Management.Automation.SwitchParameter]
        $AutoAcceptRequestToJoinLeave,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.WebPipeBind]
        $Web,

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
        [PnP.PowerShell.Commands.Enums.AssociatedGroupType]
        $SetAssociatedGroup,

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
function Set-PnPGroup
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
        [System.String]
        $AddRole,

        [Parameter()]
        [System.Boolean]
        $AllowMembersEditMembership,

        [Parameter()]
        [System.String]
        $Title,

        [Parameter()]
        [System.String]
        $Owner,

        [Parameter()]
        [System.Boolean]
        $AutoAcceptRequestToJoinLeave,

        [Parameter()]
        [System.Boolean]
        $OnlyAllowMembersViewMembership,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PipeBinds.GroupPipeBind]
        $Identity,

        [Parameter()]
        [System.String]
        $RemoveRole,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.String]
        $RequestToJoinEmail,

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
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.String]
        $Url
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
        $SiteDesignId
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
        [System.Nullable`1[System.Management.Automation.SwitchParameter]]
        $DisableFlows,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $DisableSharingForNonOwners,

        [Parameter()]
        [System.Nullable`1[Microsoft.Online.SharePoint.TenantManagement.SharingCapabilities]]
        $Sharing,

        [Parameter()]
        [System.Nullable`1[System.Management.Automation.SwitchParameter]]
        $NoScriptSite,

        [Parameter()]
        [System.String]
        $LogoFilePath,

        [Parameter()]
        [System.String]
        $Classification,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $DefaultLinkToExistingAccessReset,

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
        $DefaultSharingLinkType,

        [Parameter()]
        [System.Nullable`1[Microsoft.Online.SharePoint.TenantAdministration.CompanyWideSharingLinksPolicy]]
        $DisableCompanyWideSharingLinks
    )
}
function Set-PnPSiteDesign
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $PreviewImageUrl,

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
        [PnP.PowerShell.Commands.Base.PipeBinds.TenantSiteDesignPipeBind]
        $Identity,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [System.String]
        $PreviewImageAltText,

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
        [System.Nullable`1[Microsoft.SharePoint.Client.AnonymousLinkType]]
        $FileAnonymousLinkType,

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
        $DisallowInfectedFileDownload,

        [Parameter()]
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

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
        $ShowAllUsersClaim,

        [Parameter()]
        [System.Boolean]
        $RequireAcceptingAccountMatchInvitedAccount,

        [Parameter()]
        [System.Nullable`1[Microsoft.Online.SharePoint.TenantManagement.SharingPermissionType]]
        $DefaultLinkPermission,

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
        $EnableGuestSignInAcceleration,

        [Parameter()]
        [System.Boolean]
        $SearchResolveExactEmailOrUPN,

        [Parameter()]
        [System.Boolean]
        $EnableAIPIntegration,

        [Parameter()]
        [System.Boolean]
        $FilePickerExternalImageSearchEnabled,

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
        $SocialBarOnSitePagesDisabled,

        [Parameter()]
        [System.Boolean]
        $PublicCdnEnabled,

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
        [System.Int32]
        $MinCompatibilityLevel,

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
        $CommentsOnListItemsDisabled,

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
        $DisplayStartASiteOption,

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
        $ShowPeoplePickerSuggestionsForGuestUsers,

        [Parameter()]
        [System.Boolean]
        $AllowEditing,

        [Parameter()]
        [System.Boolean]
        $PreventExternalUsersFromResharing,

        [Parameter()]
        [System.Boolean]
        $CommentsOnFilesDisabled,

        [Parameter()]
        [System.Boolean]
        $LegacyAuthProtocolsEnabled,

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
        [System.Nullable`1[System.Int32]]
        $EmailAttestationReAuthDays,

        [Parameter()]
        [System.Nullable`1[System.Int64]]
        $OneDriveStorageQuota,

        [Parameter()]
        [System.Int32]
        $MaxCompatibilityLevel,

        [Parameter()]
        [System.Nullable`1[Microsoft.SharePoint.Client.SharingState]]
        $ODBMembersCanShare,

        [Parameter()]
        [System.String]
        $SharingBlockedDomainList
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
        [PnP.PowerShell.Commands.Base.PnPConnection]
        $Connection,

        [Parameter()]
        [Microsoft.Online.SharePoint.TenantManagement.SharingCapabilities]
        $SharingCapability,

        [Parameter()]
        [Microsoft.Online.SharePoint.TenantAdministration.FlowsPolicy]
        $DisableFlows,

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
        [System.Int32]
        $ExternalUserExpirationInDays,

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
        $DefaultLinkToExistingAccess,

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
        $AllowDownloadingNonWebViewableFiles,

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
        [Microsoft.Online.SharePoint.TenantAdministration.SiteUserInfoVisibilityPolicyValue]
        $OverrideBlockUserInfoVisibility,

        [Parameter()]
        [Microsoft.Online.SharePoint.TenantManagement.SPOLimitedAccessFileType]
        $LimitedAccessFileType,

        [Parameter()]
        [Microsoft.Online.SharePoint.TenantManagement.BlockDownloadLinksFileTypes]
        $BlockDownloadLinksFileType,

        [Parameter()]
        [System.Nullable`1[System.Int32]]
        $AnonymousLinkExpirationInDays,

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
        [System.String]
        $InstanceId,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $GetProtectedEnvironment,

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
        [System.Boolean]
        $ReturnCdsDatabaseType,

        [Parameter()]
        [System.String]
        $CreatedBy
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
        $FilePlanProperty,

        [Parameter()]
        [System.Object]
        $RetentionDuration,

        [Parameter()]
        [System.Object]
        $IsRecordLabel,

        [Parameter()]
        [System.Object]
        $Name,

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
        $RetentionType,

        [Parameter()]
        [System.Object]
        $MultiStageReviewProperty,

        [Parameter()]
        [System.Object]
        $EventType,

        [Parameter()]
        [System.Object]
        $RetentionAction,

        [Parameter()]
        [System.Object]
        $Regulatory,

        [Parameter()]
        [System.Object]
        $ReviewerEmail,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

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
        $OneDriveSharedBy,

        [Parameter()]
        [System.Object]
        $Priority,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $Name,

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
        $ExceptIfOneDriveSharedBy,

        [Parameter()]
        [System.Object]
        $ThirdPartyAppDlpLocationException,

        [Parameter()]
        [System.Object]
        $ExchangeLocation,

        [Parameter()]
        [System.Object]
        $OneDriveLocationException,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $TeamsLocationException,

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
        $Mode,

        [Parameter()]
        [System.Object]
        $SharePointLocationException,

        [Parameter()]
        [System.Object]
        $TeamsLocation,

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
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $DocumentNameMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfSubjectOrBodyMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.Object]
        $MessageSizeOver,

        [Parameter()]
        [System.Object]
        $ExceptIfContentContainsSensitiveInformation,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentNameMatchesWords,

        [Parameter()]
        [System.Object]
        $ExceptIfFromAddressContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfProcessingLimitExceeded,

        [Parameter()]
        [System.Object]
        $AnyOfRecipientAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $UnscannableDocumentExtensionIs,

        [Parameter()]
        [System.Object]
        $RedirectMessageTo,

        [Parameter()]
        [System.Object]
        $DocumentNameMatchesWords,

        [Parameter()]
        [System.Object]
        $RecipientADAttributeMatchesPatterns,

        [Parameter()]
        [System.Object]
        $NotifyAllowOverride,

        [Parameter()]
        [System.Object]
        $WithImportance,

        [Parameter()]
        [System.Object]
        $SubjectOrBodyMatchesPatterns,

        [Parameter()]
        [System.Object]
        $NotifyUser,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfAnyOfRecipientAddressContainsWords,

        [Parameter()]
        [System.Object]
        $EncryptRMSTemplate,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderIPRanges,

        [Parameter()]
        [System.Object]
        $FromAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $SenderIPRanges,

        [Parameter()]
        [System.Object]
        $ExceptIfFrom,

        [Parameter()]
        [System.Object]
        $DocumentIsPasswordProtected,

        [Parameter()]
        [System.Object]
        $NotifyEmailCustomText,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderADAttributeContainsWords,

        [Parameter()]
        [System.Object]
        $GenerateAlert,

        [Parameter()]
        [System.Object]
        $ExceptIfSubjectMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ContentExtensionMatchesWords,

        [Parameter()]
        [System.Object]
        $ExceptIfMessageSizeOver,

        [Parameter()]
        [System.Object]
        $HasSenderOverride,

        [Parameter()]
        [System.Object]
        $NotifyPolicyTipCustomTextTranslations,

        [Parameter()]
        [System.Object]
        $ExceptIfWithImportance,

        [Parameter()]
        [System.Object]
        $HeaderContainsWords,

        [Parameter()]
        [System.Object]
        $ImmutableId,

        [Parameter()]
        [System.Object]
        $BlockAccessScope,

        [Parameter()]
        [System.Object]
        $ExceptIfSubjectOrBodyContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfMessageTypeMatches,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentSizeOver,

        [Parameter()]
        [System.Object]
        $ExceptIfFromMemberOf,

        [Parameter()]
        [System.Object]
        $ExceptIfFromAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfAccessScope,

        [Parameter()]
        [System.Object]
        $PrependSubject,

        [Parameter()]
        [System.Object]
        $ExceptIfHeaderMatchesPatterns,

        [Parameter()]
        [System.Object]
        $AnyOfRecipientAddressContainsWords,

        [Parameter()]
        [System.Object]
        $DocumentMatchesPatterns,

        [Parameter()]
        [System.Object]
        $NotifyEmailCustomSubject,

        [Parameter()]
        [System.Object]
        $IncidentReportContent,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentIsPasswordProtected,

        [Parameter()]
        [System.Object]
        $GenerateIncidentReport,

        [Parameter()]
        [System.Object]
        $ExceptIfUnscannableDocumentExtensionIs,

        [Parameter()]
        [System.Object]
        $From,

        [Parameter()]
        [System.Object]
        $AccessScope,

        [Parameter()]
        [System.Object]
        $RemoveRMSTemplate,

        [Parameter()]
        [System.Object]
        $FromScope,

        [Parameter()]
        [System.Object]
        $RecipientDomainIs,

        [Parameter()]
        [System.Object]
        $ActivationDate,

        [Parameter()]
        [System.Object]
        $ExceptIfContentPropertyContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentNameMatchesPatterns,

        [Parameter()]
        [System.Object]
        $SenderADAttributeContainsWords,

        [Parameter()]
        [System.Object]
        $Policy,

        [Parameter()]
        [System.Object]
        $ContentCharacterSetContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfSentToMemberOf,

        [Parameter()]
        [System.Object]
        $SenderADAttributeMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderADAttributeMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientADAttributeContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfSubjectContainsWords,

        [Parameter()]
        [System.Object]
        $Priority,

        [Parameter()]
        [System.Object]
        $Name,

        [Parameter()]
        [System.Object]
        $SubjectContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfHeaderContainsWords,

        [Parameter()]
        [System.Object]
        $RemoveHeader,

        [Parameter()]
        [System.Object]
        $ExceptIfContentCharacterSetContainsWords,

        [Parameter()]
        [System.Object]
        $SenderDomainIs,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientADAttributeMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ContentContainsSensitiveInformation,

        [Parameter()]
        [System.Object]
        $SubjectOrBodyContainsWords,

        [Parameter()]
        [System.Object]
        $Moderate,

        [Parameter()]
        [System.Object]
        $OnPremisesScannerDlpRestrictions,

        [Parameter()]
        [System.Object]
        $FromMemberOf,

        [Parameter()]
        [System.Object]
        $ExceptIfHasSenderOverride,

        [Parameter()]
        [System.Object]
        $ExceptIfFromScope,

        [Parameter()]
        [System.Object]
        $BlockAccess,

        [Parameter()]
        [System.Object]
        $SentToMemberOf,

        [Parameter()]
        [System.Object]
        $StopPolicyProcessing,

        [Parameter()]
        [System.Object]
        $Disabled,

        [Parameter()]
        [System.Object]
        $ReportSeverityLevel,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentIsUnsupported,

        [Parameter()]
        [System.Object]
        $MessageTypeMatches,

        [Parameter()]
        [System.Object]
        $RuleErrorAction,

        [Parameter()]
        [System.Object]
        $NotifyPolicyTipCustomText,

        [Parameter()]
        [System.Object]
        $ContentPropertyContainsWords,

        [Parameter()]
        [System.Object]
        $ProcessingLimitExceeded,

        [Parameter()]
        [System.Object]
        $SentTo,

        [Parameter()]
        [System.Object]
        $ThirdPartyAppDlpRestrictions,

        [Parameter()]
        [System.Object]
        $DocumentIsUnsupported,

        [Parameter()]
        [System.Object]
        $SetHeader,

        [Parameter()]
        [System.Object]
        $SubjectMatchesPatterns,

        [Parameter()]
        [System.Object]
        $HeaderMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfSentTo,

        [Parameter()]
        [System.Object]
        $ExpiryDate,

        [Parameter()]
        [System.Object]
        $ExceptIfContentExtensionMatchesWords,

        [Parameter()]
        [System.Object]
        $RecipientADAttributeContainsWords,

        [Parameter()]
        [System.Object]
        $EndpointDlpRestrictions,

        [Parameter()]
        [System.Object]
        $DocumentContainsWords,

        [Parameter()]
        [System.Object]
        $FromAddressContainsWords,

        [Parameter()]
        [System.Object]
        $AlertProperties,

        [Parameter()]
        [System.Object]
        $ApplyHtmlDisclaimer,

        [Parameter()]
        [System.Object]
        $DocumentSizeOver,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderDomainIs,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfAnyOfRecipientAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $AddRecipients,

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
        $ApplyContentMarkingFooterEnabled,

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
        $SqlAssetCondition,

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
        $Name,

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
        $ExchangeLocationException,

        [Parameter()]
        [System.Object]
        $TeamsChatLocationException,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

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
function New-SupervisoryReviewPolicyV2
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
        [System.Management.Automation.SwitchParameter]
        $UpdateStatistics,

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
        $RetentionDuration,

        [Parameter()]
        [System.Object]
        $FilePlanProperty,

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
        $RemoveThirdPartyAppDlpLocation,

        [Parameter()]
        [System.Object]
        $RemoveTeamsLocation,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Confirm,

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
        $AddThirdPartyAppDlpLocation,

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
        [System.Object]
        $AddEndpointDlpLocation,

        [Parameter()]
        [System.Object]
        $AddSharePointLocation,

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
        [System.Management.Automation.SwitchParameter]
        $Confirm,

        [Parameter()]
        [System.Object]
        $NotifyAllowOverride,

        [Parameter()]
        [System.Object]
        $DocumentNameMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfSubjectOrBodyMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.Object]
        $MessageSizeOver,

        [Parameter()]
        [System.Object]
        $ExceptIfContentContainsSensitiveInformation,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentNameMatchesWords,

        [Parameter()]
        [System.Object]
        $ExceptIfFromAddressContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfProcessingLimitExceeded,

        [Parameter()]
        [System.Object]
        $AnyOfRecipientAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $UnscannableDocumentExtensionIs,

        [Parameter()]
        [System.Object]
        $RedirectMessageTo,

        [Parameter()]
        [System.Object]
        $DocumentNameMatchesWords,

        [Parameter()]
        [System.Object]
        $RecipientADAttributeMatchesPatterns,

        [Parameter()]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Object]
        $WithImportance,

        [Parameter()]
        [System.Object]
        $SubjectOrBodyMatchesPatterns,

        [Parameter()]
        [System.Object]
        $NotifyUser,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfAnyOfRecipientAddressContainsWords,

        [Parameter()]
        [System.Object]
        $EncryptRMSTemplate,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderIPRanges,

        [Parameter()]
        [System.Object]
        $FromAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $SenderIPRanges,

        [Parameter()]
        [System.Object]
        $ExceptIfFrom,

        [Parameter()]
        [System.Object]
        $DocumentIsPasswordProtected,

        [Parameter()]
        [System.Object]
        $NotifyEmailCustomText,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderADAttributeContainsWords,

        [Parameter()]
        [System.Object]
        $GenerateAlert,

        [Parameter()]
        [System.Object]
        $ExceptIfSubjectMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ContentExtensionMatchesWords,

        [Parameter()]
        [System.Object]
        $ExceptIfMessageSizeOver,

        [Parameter()]
        [System.Object]
        $HasSenderOverride,

        [Parameter()]
        [System.Object]
        $NotifyPolicyTipCustomTextTranslations,

        [Parameter()]
        [System.Object]
        $ExceptIfWithImportance,

        [Parameter()]
        [System.Object]
        $HeaderContainsWords,

        [Parameter()]
        [System.Object]
        $BlockAccessScope,

        [Parameter()]
        [System.Object]
        $ExceptIfSubjectOrBodyContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfMessageTypeMatches,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentSizeOver,

        [Parameter()]
        [System.Object]
        $ExceptIfFromMemberOf,

        [Parameter()]
        [System.Object]
        $ExceptIfFromAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfAccessScope,

        [Parameter()]
        [System.Object]
        $PrependSubject,

        [Parameter()]
        [System.Object]
        $ExceptIfHeaderMatchesPatterns,

        [Parameter()]
        [System.Object]
        $AnyOfRecipientAddressContainsWords,

        [Parameter()]
        [System.Object]
        $DocumentMatchesPatterns,

        [Parameter()]
        [System.Object]
        $NotifyEmailCustomSubject,

        [Parameter()]
        [System.Object]
        $IncidentReportContent,

        [Parameter()]
        [System.Object]
        $Comment,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentIsPasswordProtected,

        [Parameter()]
        [System.Object]
        $GenerateIncidentReport,

        [Parameter()]
        [System.Object]
        $ExceptIfUnscannableDocumentExtensionIs,

        [Parameter()]
        [System.Object]
        $From,

        [Parameter()]
        [System.Object]
        $AccessScope,

        [Parameter()]
        [System.Object]
        $RemoveRMSTemplate,

        [Parameter()]
        [System.Object]
        $FromScope,

        [Parameter()]
        [System.Object]
        $RecipientDomainIs,

        [Parameter()]
        [System.Object]
        $ActivationDate,

        [Parameter()]
        [System.Object]
        $ExceptIfContentPropertyContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentNameMatchesPatterns,

        [Parameter()]
        [System.Object]
        $SenderADAttributeContainsWords,

        [Parameter()]
        [System.Object]
        $ContentCharacterSetContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfSentToMemberOf,

        [Parameter()]
        [System.Object]
        $SenderADAttributeMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderADAttributeMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientADAttributeContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfSubjectContainsWords,

        [Parameter()]
        [System.Object]
        $Priority,

        [Parameter()]
        [System.Object]
        $SubjectContainsWords,

        [Parameter()]
        [System.Object]
        $ExceptIfHeaderContainsWords,

        [Parameter()]
        [System.Object]
        $RemoveHeader,

        [Parameter()]
        [System.Object]
        $ExceptIfContentCharacterSetContainsWords,

        [Parameter()]
        [System.Object]
        $SenderDomainIs,

        [Parameter()]
        [System.Object]
        $ExceptIfRecipientADAttributeMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ContentContainsSensitiveInformation,

        [Parameter()]
        [System.Object]
        $SubjectOrBodyContainsWords,

        [Parameter()]
        [System.Object]
        $Moderate,

        [Parameter()]
        [System.Object]
        $OnPremisesScannerDlpRestrictions,

        [Parameter()]
        [System.Object]
        $FromMemberOf,

        [Parameter()]
        [System.Object]
        $ExceptIfHasSenderOverride,

        [Parameter()]
        [System.Object]
        $ExceptIfFromScope,

        [Parameter()]
        [System.Object]
        $BlockAccess,

        [Parameter()]
        [System.Object]
        $SentToMemberOf,

        [Parameter()]
        [System.Object]
        $StopPolicyProcessing,

        [Parameter()]
        [System.Object]
        $Disabled,

        [Parameter()]
        [System.Object]
        $ReportSeverityLevel,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentIsUnsupported,

        [Parameter()]
        [System.Object]
        $MessageTypeMatches,

        [Parameter()]
        [System.Object]
        $RuleErrorAction,

        [Parameter()]
        [System.Object]
        $NotifyPolicyTipCustomText,

        [Parameter()]
        [System.Object]
        $ContentPropertyContainsWords,

        [Parameter()]
        [System.Object]
        $ProcessingLimitExceeded,

        [Parameter()]
        [System.Object]
        $SentTo,

        [Parameter()]
        [System.Object]
        $ThirdPartyAppDlpRestrictions,

        [Parameter()]
        [System.Object]
        $DocumentIsUnsupported,

        [Parameter()]
        [System.Object]
        $SetHeader,

        [Parameter()]
        [System.Object]
        $SubjectMatchesPatterns,

        [Parameter()]
        [System.Object]
        $HeaderMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfSentTo,

        [Parameter()]
        [System.Object]
        $ExpiryDate,

        [Parameter()]
        [System.Object]
        $ExceptIfContentExtensionMatchesWords,

        [Parameter()]
        [System.Object]
        $RecipientADAttributeContainsWords,

        [Parameter()]
        [System.Object]
        $EndpointDlpRestrictions,

        [Parameter()]
        [System.Object]
        $DocumentContainsWords,

        [Parameter()]
        [System.Object]
        $FromAddressContainsWords,

        [Parameter()]
        [System.Object]
        $AlertProperties,

        [Parameter()]
        [System.Object]
        $ApplyHtmlDisclaimer,

        [Parameter()]
        [System.Object]
        $DocumentSizeOver,

        [Parameter()]
        [System.Object]
        $ExceptIfSenderDomainIs,

        [Parameter()]
        [System.Object]
        $ExceptIfDocumentMatchesPatterns,

        [Parameter()]
        [System.Object]
        $ExceptIfAnyOfRecipientAddressMatchesPatterns,

        [Parameter()]
        [System.Object]
        $AddRecipients,

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
        $ApplyContentMarkingFooterEnabled,

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
        $SqlAssetCondition,

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
        $AddSharePointLocation,

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
        $RemoveTeamsChannelLocationException,

        [Parameter()]
        [System.Object]
        $RemoveTeamsChannelLocation,

        [Parameter()]
        [System.Object]
        $AddSharePointLocationException,

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
