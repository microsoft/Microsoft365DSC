function Get-TargetResource
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
        $Comment,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AdvancedSettings,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $LocaleSettings,

        [Parameter()]
        [System.String]
        $ParentId,

        [Parameter()]
        [uint32]
        $Priority,

        [Parameter()]
        [System.String]
        $Tooltip,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [ValidateSet('Left', 'Center', 'Right')]
        [System.String]
        $ApplyContentMarkingFooterAlignment,

        [Parameter()]
        [System.Boolean]
        $ApplyContentMarkingFooterEnabled,

        [Parameter()]
        [System.String]
        $ApplyContentMarkingFooterFontColor,

        [Parameter()]
        [System.Int32]
        $ApplyContentMarkingFooterFontSize,

        [Parameter()]
        [System.Int32]
        $ApplyContentMarkingFooterMargin,

        [Parameter()]
        [System.String]
        $ApplyContentMarkingFooterText,

        [Parameter()]
        [ValidateSet('Left', 'Center', 'Right')]
        [System.String]
        $ApplyContentMarkingHeaderAlignment,

        [Parameter()]
        [System.Boolean]
        $ApplyContentMarkingHeaderEnabled,

        [Parameter()]
        [System.String]
        $ApplyContentMarkingHeaderFontColor,

        [Parameter()]
        [System.Int32]
        $ApplyContentMarkingHeaderFontSize,

        [Parameter()]
        [System.Int32]
        $ApplyContentMarkingHeaderMargin,

        [Parameter()]
        [System.String]
        $ApplyContentMarkingHeaderText,

        [Parameter()]
        [System.Boolean]
        $ApplyWaterMarkingEnabled,

        [Parameter()]
        [System.String]
        $ApplyWaterMarkingFontColor,

        [Parameter()]
        [System.Int32]
        $ApplyWaterMarkingFontSize,

        [Parameter()]
        [ValidateSet('Horizontal', 'Diagonal')]
        [System.String]
        $ApplyWaterMarkingLayout,

        [Parameter()]
        [System.String]
        $ApplyWaterMarkingText,

        [Parameter()]
        [ValidateSet('File, Email', 'Site, UnifiedGroup', 'PurviewAssets', 'Teamwork', 'SchematizedData')]
        [System.String[]]
        $ContentType,

        [Parameter()]
        [System.String]
        $EncryptionContentExpiredOnDateInDaysOrNever,

        [Parameter()]
        [System.Boolean]
        $EncryptionDoNotForward,

        [Parameter()]
        [System.Boolean]
        $EncryptionEncryptOnly,

        [Parameter()]
        [System.Boolean]
        $EncryptionEnabled,

        [Parameter()]
        [System.Int32]
        $EncryptionOfflineAccessDays,

        [Parameter()]
        [System.Boolean]
        $EncryptionPromptUser,

        [Parameter()]
        [System.String]
        $EncryptionProtectionType,

        [Parameter()]
        [System.String]
        $EncryptionRightsDefinitions,

        [Parameter()]
        [System.String]
        $EncryptionRightsUrl,

        [Parameter()]
        [System.Boolean]
        $SiteAndGroupProtectionAllowAccessToGuestUsers,

        [Parameter()]
        [System.Boolean]
        $SiteAndGroupProtectionAllowEmailFromGuestUsers,

        [Parameter()]
        [System.Boolean]
        $SiteAndGroupProtectionAllowFullAccess,

        [Parameter()]
        [System.Boolean]
        $SiteAndGroupProtectionAllowLimitedAccess,

        [Parameter()]
        [System.Boolean]
        $SiteAndGroupProtectionBlockAccess,

        [Parameter()]
        [System.Boolean]
        $SiteAndGroupProtectionEnabled,

        [Parameter()]
        [ValidateSet('Public', 'Private', 'Unspecified')]
        [System.String]
        $SiteAndGroupProtectionPrivacy,

        [Parameter()]
        [ValidateSet('ExternalUserAndGuestSharing', 'ExternalUserSharingOnly', 'ExistingExternalUserSharingOnly', 'Disabled')]
        [System.String]
        $SiteAndGroupExternalSharingControlType,

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
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration of Sensitivity Label for $Name"
    if ($Global:CurrentModeIsExport)
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'SecurityComplianceCenter' `
            -InboundParameters $PSBoundParameters `
            -SkipModuleReload $true
    }
    else
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'SecurityComplianceCenter' `
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
        try
        {
            $label = Get-Label -Identity $Name -ErrorAction SilentlyContinue `
                -IncludeDetailedLabelActions
        }
        catch
        {
            throw $_
        }

        if ($null -eq $label)
        {
            Write-Verbose -Message "Sensitivity label $($Name) does not exist."
            return $nullReturn
        }
        else
        {
            $parentLabelID = $null
            if ($null -ne $label.ParentId)
            {
                $parentLabel = Get-Label -Identity $label.ParentId -IncludeDetailedLabelActions -ErrorAction 'SilentlyContinue'
                $parentLabelID = $parentLabel.Name
            }
            if ($null -ne $label.LocaleSettings)
            {
                $localeSettingsValue = Convert-JSONToLocaleSettings -JSONLocalSettings $label.LocaleSettings
            }
            if ($null -ne $label.Settings)
            {
                $advancedSettingsValue = Convert-StringToAdvancedSettings -AdvancedSettings $label.Settings
            }
            Write-Verbose "Found existing Sensitivity Label $($Name)"

            [Array]$labelActions = $label.LabelActions
            $actions = @()
            foreach ($labelAction in $labelActions)
            {
                $action = ConvertFrom-Json ($labelAction | Out-String)
                $actions += $action
            }

            $encryption = ($actions | Where-Object -FilterScript { $_.Type -eq 'encrypt' }).Settings
            $header = ($actions | Where-Object -FilterScript { $_.Type -eq 'applycontentmarking' -and $_.Subtype -eq 'header' }).Settings
            $footer = ($actions | Where-Object -FilterScript { $_.Type -eq 'applycontentmarking' -and $_.Subtype -eq 'footer' }).Settings
            $watermark = ($actions | Where-Object -FilterScript { $_.Type -eq 'applywatermarking' }).Settings
            $protectgroup = ($actions | Where-Object -FilterScript { $_.Type -eq 'protectgroup' }).Settings
            $protectsite = ($actions | Where-Object -FilterScript { $_.Type -eq 'protectsite' }).Settings

            $ApplyContentMarkingFooterTextValue = $null
            $footerText = ($footer | Where-Object -FilterScript { $_.Key -eq 'text' }).Value
            if ([System.String]::IsNullOrEmpty($footerText) -eq $false)
            {
                $ApplyContentMarkingFooterTextValue = $footerText.Replace('$', '`$')
            }

            $ApplyContentMarkingHeaderTextValue = $null
            $headerText = ($header | Where-Object -FilterScript { $_.Key -eq 'text' }).Value
            if ([System.String]::IsNullOrEmpty($headerText) -eq $false)
            {
                $ApplyContentMarkingHeaderTextValue = $headerText.Replace('$', '`$')
            }

            $ApplyWaterMarkingTextValue = $null
            $watermarkText = ($watermark | Where-Object -FilterScript { $_.Key -eq 'text' }).Value
            if ([System.String]::IsNullOrEmpty($watermarkText) -eq $false)
            {
                $ApplyWaterMarkingTextValue = $watermarkText.Replace('$', '`$')
            }

            $currentContentType = @()
            switch -Regex ($label.ContentType)
            {
                'File, Email'
                {
                    $currentContentType += 'File, Email'
                }
                'Site, UnifiedGroup'
                {
                    $currentContentType += 'Site, UnifiedGroup'
                }
                'PurviewAssets'
                {
                    $currentContentType += 'PurviewAssets'
                }
                'Teamwork'
                {
                    $currentContentType += 'Teamwork'
                }
                'SchematizedData'
                {
                    $currentContentType += 'SchematizedData'
                }
            }

            # Encryption
            $entry = $encryption | Where-Object -FilterScript { $_.Key -eq 'disabled' }
            if ($null -ne $entry)
            {
                $encryptionEnabledValue = -not [Boolean]::Parse($entry.Value)
            }

            $entry = $encryption | Where-Object -FilterScript { $_.Key -eq 'contentexpiredondateindaysornever' }
            if ($null -ne $entry)
            {
                $contentExpiredOnDateValue = $entry.Value
            }

            $entry = $encryption | Where-Object -FilterScript { $_.Key -eq 'protectiontype' }
            if ($null -ne $entry)
            {
                $protectionTypeValue = $entry.Value
            }

            $entry = $encryption | Where-Object -FilterScript { $_.Key -eq 'offlineaccessdays' }
            if ($null -ne $entry)
            {
                $offlineAccessDaysValue = $entry.Value
            }

            $entry = $encryption | Where-Object -FilterScript { $_.Key -eq 'rightsdefinitions' }
            if ($null -ne $entry)
            {
                $EncryptionRightsDefinitionsValue = Convert-EncryptionRightDefinition -RightsDefinition $entry.Value
            }

            $entry = $encryption | Where-Object -FilterScript { $_.Key -eq 'donotforward' }
            if ($null -ne $entry)
            {
                $encryptionDoNotForwardValue = [Boolean]::Parse($entry.Value)
            }

            $entry = $encryption | Where-Object -FilterScript { $_.Key -eq 'encryptonly' }
            if ($null -ne $entry)
            {
                $encryptionEncryptOnlyValue = [Boolean]::Parse($entry.Value)
            }

            $entry = $encryption | Where-Object -FilterScript { $_.Key -eq 'promptuser' }
            if ($null -ne $entry)
            {
                $encryptionPromptUserValue = [Boolean]::Parse($entry.Value)
            }

            # Watermark
            $entry = $watermark | Where-Object -FilterScript { $_.Key -eq 'disabled' }
            if ($null -ne $entry)
            {
                $watermarkEnabledValue = -not [Boolean]::Parse($entry.Value)
            }

            # Watermark Footer
            $entry = $footer | Where-Object -FilterScript { $_.Key -eq 'disabled' }
            if ($null -ne $entry)
            {
                $footerEnabledValue = -not [Boolean]::Parse($entry.Value)
            }

            # Watermark Header
            $entry = $header | Where-Object -FilterScript { $_.Key -eq 'disabled' }
            if ($null -ne $entry)
            {
                $headerEnabledValue = -not [Boolean]::Parse($entry.Value)
            }

            # Site and Group
            $entry = $protectgroup | Where-Object -FilterScript { $_.Key -eq 'disabled' }
            if ($null -ne $entry)
            {
                $siteAndGroupEnabledValue = -not [Boolean]::Parse($entry.Value)
            }

            $entry = $protectgroup | Where-Object -FilterScript { $_.Key -eq 'allowaccesstoguestusers' }
            if ($null -ne $entry)
            {
                $siteAndGroupAccessToGuestUsersValue = [Boolean]::Parse($entry.Value)
            }

            $entry = $protectgroup | Where-Object -FilterScript { $_.Key -eq 'allowemailfromguestusers' }
            if ($null -ne $entry)
            {
                $siteAndGroupAllowEmailFromGuestUsers = [Boolean]::Parse($entry.Value)
            }

            $entry = $protectsite | Where-Object -FilterScript { $_.Key -eq 'allowfullaccess' }
            if ($null -ne $entry)
            {
                $siteAndGroupAllowFullAccess = [Boolean]::Parse($entry.Value)
            }

            $entry = $protectsite | Where-Object -FilterScript { $_.Key -eq 'allowlimitedaccess' }
            if ($null -ne $entry)
            {
                $siteAndGroupAllowLimitedAccess = [Boolean]::Parse($entry.Value)
            }

            $entry = $protectsite | Where-Object -FilterScript { $_.Key -eq 'blockaccess' }
            if ($null -ne $entry)
            {
                $siteAndGroupBlockAccess = [Boolean]::Parse($entry.Value)
            }

            $result = @{
                Name                                           = $label.Name
                Comment                                        = $label.Comment
                ParentId                                       = $parentLabelID
                AdvancedSettings                               = $advancedSettingsValue
                DisplayName                                    = $label.DisplayName
                LocaleSettings                                 = $localeSettingsValue
                Priority                                       = $label.Priority
                Tooltip                                        = $label.Tooltip
                Credential                                     = $Credential
                ApplicationId                                  = $ApplicationId
                TenantId                                       = $TenantId
                CertificateThumbprint                          = $CertificateThumbprint
                CertificatePath                                = $CertificatePath
                CertificatePassword                            = $CertificatePassword
                Ensure                                         = 'Present'
                ApplyContentMarkingFooterAlignment             = ($footer | Where-Object { $_.Key -eq 'alignment' }).Value
                ApplyContentMarkingFooterEnabled               = $footerEnabledValue
                ApplyContentMarkingFooterFontColor             = ($footer | Where-Object { $_.Key -eq 'fontcolor' }).Value
                ApplyContentMarkingFooterFontSize              = ($footer | Where-Object { $_.Key -eq 'fontsize' }).Value
                ApplyContentMarkingFooterMargin                = ($footer | Where-Object { $_.Key -eq 'margin' }).Value
                ApplyContentMarkingFooterText                  = $ApplyContentMarkingFooterTextValue
                ApplyContentMarkingHeaderAlignment             = ($header | Where-Object { $_.Key -eq 'alignment' }).Value
                ApplyContentMarkingHeaderEnabled               = $headerEnabledValue
                ApplyContentMarkingHeaderFontColor             = ($header | Where-Object { $_.Key -eq 'fontcolor' }).Value
                ApplyContentMarkingHeaderFontSize              = ($header | Where-Object { $_.Key -eq 'fontsize' }).Value
                ApplyContentMarkingHeaderMargin                = ($header | Where-Object { $_.Key -eq 'margin' }).Value
                #TODO ADD HEADER PLACEMENT?
                ApplyContentMarkingHeaderText                  = $ApplyContentMarkingHeaderTextValue
                ApplyWaterMarkingEnabled                       = $watermarkEnabledValue
                ApplyWaterMarkingFontColor                     = ($watermark | Where-Object { $_.Key -eq 'fontcolor' }).Value
                ApplyWaterMarkingFontSize                      = ($watermark | Where-Object { $_.Key -eq 'fontsize' }).Value
                ApplyWaterMarkingLayout                        = ($watermark | Where-Object { $_.Key -eq 'layout' }).Value
                ApplyWaterMarkingText                          = $ApplyWaterMarkingTextValue
                ContentType                                    = $currentContentType
                EncryptionContentExpiredOnDateInDaysOrNever    = $contentExpiredOnDateValue
                EncryptionDoNotForward                         = $encryptionDoNotForwardValue
                EncryptionEncryptOnly                          = $encryptionEncryptOnlyValue
                EncryptionEnabled                              = $encryptionEnabledValue
                EncryptionOfflineAccessDays                    = $offlineAccessDaysValue
                EncryptionPromptUser                           = $encryptionPromptUserValue
                EncryptionProtectionType                       = $protectionTypeValue
                EncryptionRightsDefinitions                    = $EncryptionRightsDefinitionsValue
                EncryptionRightsUrl                            = ($encryption | Where-Object { $_.Key -eq 'doublekeyencryptionurl' }).Value
                SiteAndGroupProtectionAllowAccessToGuestUsers  = $siteAndGroupAccessToGuestUsersValue
                SiteAndGroupProtectionAllowEmailFromGuestUsers = $siteAndGroupAllowEmailFromGuestUsers
                SiteAndGroupProtectionPrivacy                  = ($protectgroup | Where-Object { $_.Key -eq 'privacy' }).Value
                SiteAndGroupProtectionAllowFullAccess          = $siteAndGroupAllowFullAccess
                SiteAndGroupProtectionAllowLimitedAccess       = $siteAndGroupAllowLimitedAccess
                SiteAndGroupProtectionBlockAccess              = $siteAndGroupBlockAccess
                SiteAndGroupProtectionEnabled                  = $siteAndGroupEnabledValue
                SiteAndGroupExternalSharingControlType         = ($protectsite | Where-Object { $_.Key -eq 'externalsharingcontroltype' }).Value
                AccessTokens                                   = $AccessTokens
            }

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

        return $nullReturn
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AdvancedSettings,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $LocaleSettings,

        [Parameter()]
        [System.String]
        $ParentId,

        [Parameter()]
        [uint32]
        $Priority,

        [Parameter()]
        [System.String]
        $Tooltip,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [ValidateSet('Left', 'Center', 'Right')]
        [System.String]
        $ApplyContentMarkingFooterAlignment,

        [Parameter()]
        [System.Boolean]
        $ApplyContentMarkingFooterEnabled,

        [Parameter()]
        [System.String]
        $ApplyContentMarkingFooterFontColor,

        [Parameter()]
        [System.Int32]
        $ApplyContentMarkingFooterFontSize,

        [Parameter()]
        [System.Int32]
        $ApplyContentMarkingFooterMargin,

        [Parameter()]
        [System.String]
        $ApplyContentMarkingFooterText,

        [Parameter()]
        [ValidateSet('Left', 'Center', 'Right')]
        [System.String]
        $ApplyContentMarkingHeaderAlignment,

        [Parameter()]
        [System.Boolean]
        $ApplyContentMarkingHeaderEnabled,

        [Parameter()]
        [System.String]
        $ApplyContentMarkingHeaderFontColor,

        [Parameter()]
        [System.Int32]
        $ApplyContentMarkingHeaderFontSize,

        [Parameter()]
        [System.Int32]
        $ApplyContentMarkingHeaderMargin,

        [Parameter()]
        [System.String]
        $ApplyContentMarkingHeaderText,

        [Parameter()]
        [System.Boolean]
        $ApplyWaterMarkingEnabled,

        [Parameter()]
        [System.String]
        $ApplyWaterMarkingFontColor,

        [Parameter()]
        [System.Int32]
        $ApplyWaterMarkingFontSize,

        [Parameter()]
        [ValidateSet('Horizontal', 'Diagonal')]
        [System.String]
        $ApplyWaterMarkingLayout,

        [Parameter()]
        [System.String]
        $ApplyWaterMarkingText,

        [Parameter()]
        [ValidateSet('File, Email', 'Site, UnifiedGroup', 'PurviewAssets', 'Teamwork', 'SchematizedData')]
        [System.String[]]
        $ContentType,

        [Parameter()]
        [System.String]
        $EncryptionContentExpiredOnDateInDaysOrNever,

        [Parameter()]
        [System.Boolean]
        $EncryptionDoNotForward,

        [Parameter()]
        [System.Boolean]
        $EncryptionEncryptOnly,

        [Parameter()]
        [System.Boolean]
        $EncryptionEnabled,

        [Parameter()]
        [System.Int32]
        $EncryptionOfflineAccessDays,

        [Parameter()]
        [System.Boolean]
        $EncryptionPromptUser,

        [Parameter()]
        [System.String]
        $EncryptionProtectionType,

        [Parameter()]
        [System.String]
        $EncryptionRightsDefinitions,

        [Parameter()]
        [System.String]
        $EncryptionRightsUrl,

        [Parameter()]
        [System.Boolean]
        $SiteAndGroupProtectionAllowAccessToGuestUsers,

        [Parameter()]
        [System.Boolean]
        $SiteAndGroupProtectionAllowEmailFromGuestUsers,

        [Parameter()]
        [System.Boolean]
        $SiteAndGroupProtectionAllowFullAccess,

        [Parameter()]
        [System.Boolean]
        $SiteAndGroupProtectionAllowLimitedAccess,

        [Parameter()]
        [System.Boolean]
        $SiteAndGroupProtectionBlockAccess,

        [Parameter()]
        [System.Boolean]
        $SiteAndGroupProtectionEnabled,

        [Parameter()]
        [ValidateSet('Public', 'Private', 'Unspecified')]
        [System.String]
        $SiteAndGroupProtectionPrivacy,

        [Parameter()]
        [ValidateSet('ExternalUserAndGuestSharing', 'ExternalUserSharingOnly', 'ExistingExternalUserSharingOnly', 'Disabled')]
        [System.String]
        $SiteAndGroupExternalSharingControlType,

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
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting configuration of Sensitivity label for $Name"

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

    $ConnectionMode = New-M365DSCConnection -Workload 'SecurityComplianceCenter' `
        -InboundParameters $PSBoundParameters

    $label = Get-TargetResource @PSBoundParameters

    if (($SiteAndGroupProtectionAllowFullAccess -and $SiteAndGroupProtectionAllowLimitedAccess) -or `
        ($SiteAndGroupProtectionAllowFullAccess -and $SiteAndGroupProtectionBlockAccess) -or `
        ($SiteAndGroupProtectionBlockAccess -and $SiteAndGroupProtectionAllowLimitedAccess))
    {
        throw '[ERROR] Only one of these values can be set to true: SiteAndGroupProtectionAllowFullAccess, SiteAndGroupProtectionAllowLimitedAccess, SiteAndGroupProtectionBlockAccess'
    }

    if ($PSBoundParameters.ContainsKey('EncryptionProtectionType') -and `
        ($EncryptionProtectionType -ne 'UserDefined' -and `
            ($PSBoundParameters.ContainsKey('EncryptionDoNotForward') -or `
                    $PSBoundParameters.ContainsKey('EncryptionEncryptOnly') -or `
                    $PSBoundParameters.ContainsKey('EncryptionPromptUser'))))
    {
        Write-Warning -Message "You have specified EncryptionDoNotForward, EncryptionEncryptOnly or EncryptionPromptUser, but EncryptionProtectionType isn't set to UserDefined."
    }

    if (('Present' -eq $Ensure) -and ('Absent' -eq $label.Ensure))
    {
        Write-Verbose -Message "Label {$Name} doesn't already exist, creating it from the Set-TargetResource function."
        $CreationParams = ([Hashtable]$PSBoundParameters).Clone()

        if ($PSBoundParameters.ContainsKey('AdvancedSettings'))
        {
            $advanced = Convert-CIMToAdvancedSettings $AdvancedSettings
            $CreationParams['AdvancedSettings'] = $advanced
        }

        if ($PSBoundParameters.ContainsKey('LocaleSettings'))
        {
            $locale = Convert-CIMToLocaleSettings $LocaleSettings
            $CreationParams['LocaleSettings'] = $locale
        }

        if ($CreationParams.ContainsKey('SiteAndGroupExternalSharingControlType'))
        {
            $CreationParams.SiteExternalSharingControlType = $CreationParams.SiteAndGroupExternalSharingControlType
            $CreationParams.Remove('SiteAndGroupExternalSharingControlType')
        }

        $CreationParams.Remove('Priority') | Out-Null

        # Remove authentication parameters
        $CreationParams.Remove('Ensure') | Out-Null
        $CreationParams.Remove('Credential') | Out-Null
        $CreationParams.Remove('ApplicationId') | Out-Null
        $CreationParams.Remove('TenantId') | Out-Null
        $CreationParams.Remove('CertificatePath') | Out-Null
        $CreationParams.Remove('CertificatePassword') | Out-Null
        $CreationParams.Remove('CertificateThumbprint') | Out-Null
        $CreationParams.Remove('ManagedIdentity') | Out-Null
        $CreationParams.Remove('ApplicationSecret') | Out-Null
        $CreationParams.Remove('AccessTokens') | Out-Null

        try
        {
            Write-Verbose -Message "Creating Label {$Name}"
            New-Label @CreationParams

            ## Can't set priority until label created
            if ($PSBoundParameters.ContainsKey('Priority'))
            {
                Start-Sleep 5
                Write-Verbose -Message "Updating the priority for newly created label {$Name}"
                Set-label -Identity $Name -priority $Priority
            }
        }
        catch
        {
            Write-Warning "New-Label is not available in tenant $($Credential.UserName.Split('@')[1]): $_"
        }
    }
    elseif (('Present' -eq $Ensure) -and ('Present' -eq $label.Ensure))
    {
        Write-Verbose -Message "Label {$Name} already exist, updating it from the Set-TargetResource function."
        $SetParams = $PSBoundParameters

        if ($PSBoundParameters.ContainsKey('AdvancedSettings'))
        {
            $advanced = Convert-CIMToAdvancedSettings $AdvancedSettings
            $SetParams['AdvancedSettings'] = $advanced
        }

        if ($PSBoundParameters.ContainsKey('LocaleSettings'))
        {
            $locale = Convert-CIMToLocaleSettings $LocaleSettings
            $SetParams['LocaleSettings'] = $locale
        }

        if ($SetParams.ContainsKey('SiteAndGroupExternalSharingControlType'))
        {
            $SetParams.SiteExternalSharingControlType = $SetParams.SiteAndGroupExternalSharingControlType
            $SetParams.Remove('SiteAndGroupExternalSharingControlType')
        }

        #Remove unused parameters for Set-Label cmdlet
        $SetParams.Remove('Name') | Out-Null

        # Remove authentication parameters
        $SetParams.Remove('Ensure') | Out-Null
        $SetParams.Remove('Credential') | Out-Null
        $SetParams.Remove('ApplicationId') | Out-Null
        $SetParams.Remove('TenantId') | Out-Null
        $SetParams.Remove('CertificatePath') | Out-Null
        $SetParams.Remove('CertificatePassword') | Out-Null
        $SetParams.Remove('CertificateThumbprint') | Out-Null
        $SetParams.Remove('ManagedIdentity') | Out-Null
        $SetParams.Remove('ApplicationSecret') | Out-Null
        $SetParams.Remove('AccessTokens') | Out-Null

        try
        {
            Set-Label @SetParams -Identity $Name
        }
        catch
        {
            Write-Warning "Set-Label is not available in tenant $($Credential.UserName.Split('@')[1]): $_"
        }
    }
    elseif (('Absent' -eq $Ensure) -and ('Present' -eq $label.Ensure))
    {
        # If the label exists and it shouldn't, simply remove it;Need to force deletoion
        Write-Verbose -Message "Deleting Sensitivity label $Name."

        try
        {
            Remove-Label -Identity $Name -Confirm:$false
            Remove-Label -Identity $Name -Confirm:$false -forcedeletion:$true
        }
        catch
        {
            Write-Warning "Remove-Label is not available in tenant $($Credential.UserName.Split('@')[1]): $_"
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
        $Name,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AdvancedSettings,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $LocaleSettings,

        [Parameter()]
        [System.String]
        $ParentId,

        [Parameter()]
        [uint32]
        $Priority,

        [Parameter()]
        [System.String]
        $Tooltip,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [ValidateSet('Left', 'Center', 'Right')]
        [System.String]
        $ApplyContentMarkingFooterAlignment,

        [Parameter()]
        [System.Boolean]
        $ApplyContentMarkingFooterEnabled,

        [Parameter()]
        [System.String]
        $ApplyContentMarkingFooterFontColor,

        [Parameter()]
        [System.Int32]
        $ApplyContentMarkingFooterFontSize,

        [Parameter()]
        [System.Int32]
        $ApplyContentMarkingFooterMargin,

        [Parameter()]
        [System.String]
        $ApplyContentMarkingFooterText,

        [Parameter()]
        [ValidateSet('Left', 'Center', 'Right')]
        [System.String]
        $ApplyContentMarkingHeaderAlignment,

        [Parameter()]
        [System.Boolean]
        $ApplyContentMarkingHeaderEnabled,

        [Parameter()]
        [System.String]
        $ApplyContentMarkingHeaderFontColor,

        [Parameter()]
        [System.Int32]
        $ApplyContentMarkingHeaderFontSize,

        [Parameter()]
        [System.Int32]
        $ApplyContentMarkingHeaderMargin,

        [Parameter()]
        [System.String]
        $ApplyContentMarkingHeaderText,

        [Parameter()]
        [System.Boolean]
        $ApplyWaterMarkingEnabled,

        [Parameter()]
        [System.String]
        $ApplyWaterMarkingFontColor,

        [Parameter()]
        [System.Int32]
        $ApplyWaterMarkingFontSize,

        [Parameter()]
        [ValidateSet('Horizontal', 'Diagonal')]
        [System.String]
        $ApplyWaterMarkingLayout,

        [Parameter()]
        [System.String]
        $ApplyWaterMarkingText,

        [Parameter()]
        [ValidateSet('File, Email', 'Site, UnifiedGroup', 'PurviewAssets', 'Teamwork', 'SchematizedData')]
        [System.String[]]
        $ContentType,

        [Parameter()]
        [System.String]
        $EncryptionContentExpiredOnDateInDaysOrNever,

        [Parameter()]
        [System.Boolean]
        $EncryptionDoNotForward,

        [Parameter()]
        [System.Boolean]
        $EncryptionEncryptOnly,

        [Parameter()]
        [System.Boolean]
        $EncryptionEnabled,

        [Parameter()]
        [System.Int32]
        $EncryptionOfflineAccessDays,

        [Parameter()]
        [System.Boolean]
        $EncryptionPromptUser,

        [Parameter()]
        [System.String]
        $EncryptionProtectionType,

        [Parameter()]
        [System.String]
        $EncryptionRightsDefinitions,

        [Parameter()]
        [System.String]
        $EncryptionRightsUrl,

        [Parameter()]
        [System.Boolean]
        $SiteAndGroupProtectionAllowAccessToGuestUsers,

        [Parameter()]
        [System.Boolean]
        $SiteAndGroupProtectionAllowEmailFromGuestUsers,

        [Parameter()]
        [System.Boolean]
        $SiteAndGroupProtectionAllowFullAccess,

        [Parameter()]
        [System.Boolean]
        $SiteAndGroupProtectionAllowLimitedAccess,

        [Parameter()]
        [System.Boolean]
        $SiteAndGroupProtectionBlockAccess,

        [Parameter()]
        [System.Boolean]
        $SiteAndGroupProtectionEnabled,

        [Parameter()]
        [ValidateSet('Public', 'Private', 'Unspecified')]
        [System.String]
        $SiteAndGroupProtectionPrivacy,

        [Parameter()]
        [ValidateSet('ExternalUserAndGuestSharing', 'ExternalUserSharingOnly', 'ExistingExternalUserSharingOnly', 'Disabled')]
        [System.String]
        $SiteAndGroupExternalSharingControlType,

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

    Write-Verbose -Message "Testing configuration of Sensitivity label for $Name"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('AdvancedSettings') | Out-Null
    $ValuesToCheck.Remove('LocaleSettings') | Out-Null

    if ($null -ne $AdvancedSettings -and $null -ne $CurrentValues.AdvancedSettings)
    {
        Write-Verbose -Message 'Testing AdvancedSettings'
        $TestAdvancedSettings = Test-AdvancedSettings -DesiredProperty $AdvancedSettings -CurrentProperty $CurrentValues.AdvancedSettings
        if ($false -eq $TestAdvancedSettings)
        {
            return $false
        }
    }

    if ($null -ne $LocaleSettings -and $null -ne $CurrentValues.LocaleSettings)
    {
        Write-Verbose -Message 'Testing LocaleSettings'
        $localeSettingsSame = Test-LocaleSettings -DesiredProperty $LocaleSettings -CurrentProperty $CurrentValues.LocaleSettings
        if ($false -eq $localeSettingsSame)
        {
            return $false
        }
    }

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
        [System.String[]]
        $AccessTokens
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'SecurityComplianceCenter' `
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
        [array]$labels = Get-Label -ErrorAction Stop

        $dscContent = ''
        $i = 1
        if ($labels.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($label in $labels)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-Host "    |---[$i/$($labels.Count)] $($label.Name)" -NoNewline

            $Results = Get-TargetResource @PSBoundParameters -Name $label.Name

            if ($null -ne $Results.AdvancedSettings)
            {
                $Results.AdvancedSettings = ConvertTo-AdvancedSettingsString -AdvancedSettings $Results.AdvancedSettings
            }

            if ($null -ne $Results.LocaleSettings)
            {
                $Results.LocaleSettings = ConvertTo-LocaleSettingsString -LocaleSettings $Results.LocaleSettings
            }
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            if ($null -ne $Results.AdvancedSettings)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'AdvancedSettings'
            }
            if ($null -ne $Results.LocaleSettings)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'LocaleSettings'
            }

            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
        }
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
    return $dscContent
}

function Convert-JSONToLocaleSettings
{
    [CmdletBinding()]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    param
    (
        [parameter(Mandatory = $true)]
        $JSONLocalSettings
    )

    $localeSettings = $JSONLocalSettings | ConvertFrom-Json

    $entries = @()
    $settings = @()
    foreach ($localeSetting in $localeSettings)
    {
        $result = @{
            localeKey = $localeSetting.LocaleKey
        }
        foreach ($setting in $localeSetting.Settings)
        {
            $entry = @{
                Key   = $setting.Key
                Value = $setting.Value -replace "`r"
            }
            $settings += $entry
        }
        $result.Add('LabelSettings', $settings)
        $settings = @()
        $entries += $result
        $result = @{ }
    }
    return $entries
}

function Convert-StringToAdvancedSettings
{
    [CmdletBinding()]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String[]]
        $AdvancedSettings
    )

    $settings = @()
    foreach ($setting in $AdvancedSettings)
    {
        $settingString = $setting.Replace('[', '').Replace(']', '')
        $settingKey = $settingString.Split(',')[0]

        if ($settingKey -notin @('displayname', 'contenttype', 'tooltip'))
        {
            $startPos = $settingString.IndexOf(',', 0) + 1
            $valueString = $settingString.Substring($startPos, $settingString.Length - $startPos).Trim()
            $values = $valueString.Split(',')

            $entry = @{
                Key   = $settingKey
                Value = $values.Trim()
            }
            $settings += $entry
        }
    }
    return $settings
}

function Convert-CIMToAdvancedSettings
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AdvancedSettings
    )

    $entry = @{ }
    foreach ($obj in $AdvancedSettings)
    {
        $settingsValues = ''
        foreach ($objVal in $obj.Value)
        {
            $settingsValues += $objVal
            $settingsValues += ','
        }
        $entry[$obj.Key] = $settingsValues.Substring(0, ($settingsValues.Length - 1))
    }

    return $entry
}

function Convert-EncryptionRightDefinition
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $RightsDefinition
    )

    $EncryptionRights = $RightsDefinition | ConvertFrom-Json
    foreach ($right in $EncryptionRights)
    {
        $StringContent += "$($right.Identity):$($right.Rights);"
    }
    if ($StringContent.EndsWith(';'))
    {
        $StringContent = $StringContent.Substring(0, ($StringContent.Length - 1))
    }
    return $StringContent

}

function Convert-CIMToLocaleSettings
{
    [CmdletBinding()]
    [OutputType([System.Collections.ArrayList])]
    param
    (
        [parameter(Mandatory = $true)]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $localeSettings
    )

    $entry = [System.Collections.ArrayList]@()
    foreach ($localset in $localeSettings)
    {
        $localeEntries = [ordered]@{
            localeKey = $localset.LocaleKey
        }
        $settings = @()
        foreach ($setting in $localset.LabelSettings)
        {
            $settingEntry = @{
                Key   = $setting.Key
                Value = $setting.Value
            }
            $settings += $settingEntry
        }
        $localeEntries.Add('Settings', $settings)
        [void]$entry.Add(($localeEntries | ConvertTo-Json))
        $localeEntries = @{ }
        $settings = @( )
    }

    return $entry
}

function Test-AdvancedSettings
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter (Mandatory = $true)]
        $DesiredProperty,

        [Parameter (Mandatory = $true)]
        $CurrentProperty
    )

    $driftedSetting = @()
    $foundSettings = $true
    foreach ($desiredSetting in $DesiredProperty)
    {
        $foundKey = $CurrentProperty | Where-Object { $_.Key -eq $desiredSetting.Key }
        if ($null -ne $foundKey)
        {
            if ($desiredSetting.Value -is [Array])
            {
                if ($foundKey.Value -is [Array])
                {
                    $diff = Compare-Object -ReferenceObject $foundKey.Value -DifferenceObject $desiredSetting.Value
                    if ($diff.Count -ne 0)
                    {
                        $foundSettings = $false
                        $driftedSetting += $desiredSetting.Key
                    }
                }
                else
                {
                    if ($desiredSetting.Value.Count -ne 1 -or `
                            $foundKey.Value.ToString() -ne $desiredSetting.Value[0].ToString())
                    {
                        $foundSettings = $false
                        $driftedSetting += $desiredSetting.Key
                    }
                }
            }
            else
            {
                if ($foundKey.Value -is [Array])
                {
                    if ($foundKey.Value.Count -ne 1 -or `
                            $foundKey.Value[0].ToString() -ne $desiredSetting.Value.ToString())
                    {
                        $foundSettings = $false
                        $driftedSetting += $desiredSetting.Key
                    }
                }
                else
                {
                    if ($foundKey.Value.ToString() -ne $desiredSetting.Value.ToString())
                    {
                        $foundSettings = $false
                        $driftedSetting += $desiredSetting.Key
                    }
                }
            }
        }
        else
        {
            $foundSettings = $false
            $driftedSetting += $desiredSetting.Key
        }
    }

    if ($foundSettings -eq $false)
    {
        New-M365DSCLogEntry -Message "AdvancedSettings for label $Name do not match: $($driftedSetting -join ', ')" `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential
    }

    Write-Verbose -Message "Test AdvancedSettings returns $foundSettings"
    return $foundSettings
}

function Test-LocaleSettings
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter (Mandatory = $true)]
        $DesiredProperty,

        [Parameter (Mandatory = $true)]
        $CurrentProperty
    )

    $driftedSetting = @()
    $foundSettings = $true
    foreach ($desiredSetting in $DesiredProperty)
    {
        $foundKey = $CurrentProperty | Where-Object { $_.LocaleKey -eq $desiredSetting.localeKey }
        foreach ($setting in $desiredSetting.LabelSettings)
        {
            if ($null -ne $foundKey)
            {
                if ($setting.Value -is [Array])
                {
                    if ($setting.Value.Count -eq 1)
                    {
                        $myLabel = $foundKey.LabelSettings | Where-Object { $_.Key -eq $setting.Key -and $_.Value -eq $setting.Value[0] }
                    }
                    else
                    {
                        $foundSettings = $false
                        $driftedSetting += "$($desiredSetting.localeKey) ($($setting.Key))"
                    }
                }
                else
                {
                    $myLabel = $foundKey.LabelSettings | Where-Object { $_.Key -eq $setting.Key -and $_.Value -eq $setting.Value }
                }

                if ($null -eq $myLabel)
                {
                    $foundSettings = $false
                    $driftedSetting += "$($desiredSetting.localeKey) ($($setting.Key))"
                }
            }
            else
            {
                $foundSettings = $false
                $driftedSetting += "$($desiredSetting.localeKey) ($($setting.Key))"
            }
        }
    }

    Write-Verbose -Message "Test LocaleSettings returns $foundSettings"
    return $foundSettings
}

function ConvertTo-AdvancedSettingsString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        $AdvancedSettings
    )

    $StringContent = "@(`r`n"
    foreach ($advancedSetting in $AdvancedSettings)
    {
        $StringContent += "                MSFT_SCLabelSetting`r`n"
        $StringContent += "                {`r`n"
        $StringContent += "                    Key   = '$($advancedSetting.Key.Replace("'", "''"))'`r`n"
        $StringContent += "                    Value = '$($advancedSetting.Value.Replace("'", "''"))'`r`n"
        $StringContent += "                }`r`n"
    }
    $StringContent += '            )'
    return $StringContent
}

function ConvertTo-LocaleSettingsString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        $LocaleSettings
    )

    $StringContent = "@(`r`n"
    foreach ($LocaleSetting in $LocaleSettings)
    {
        $StringContent += "                MSFT_SCLabelLocaleSettings`r`n"
        $StringContent += "                {`r`n"
        $StringContent += "                    LocaleKey = '$($LocaleSetting.LocaleKey.Replace("'", "''"))'`r`n"
        $StringContent += "                    LabelSettings  = @(`r`n"
        foreach ($Setting in $LocaleSetting.LabelSettings)
        {
            $StringContent += "                        MSFT_SCLabelSetting`r`n"
            $StringContent += "                        {`r`n"
            $StringContent += "                            Key   = '$($Setting.Key.Replace("'", "''"))'`r`n"
            $StringContent += "                            Value = '$($Setting.Value.Replace("'", "''"))'`r`n"
            $StringContent += "                        }`r`n"
        }
        $StringContent += "                    )`r`n"
        $StringContent += "                }`r`n"
    }
    $StringContent += '            )'
    return $StringContent
}

Export-ModuleMember -Function *-TargetResource
