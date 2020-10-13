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
        [System.Boolean]
        $Disabled,

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
        [System.String]
        $ApplyContentMarkingFooterFontName,

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
        [System.String]
        $ApplyContentMarkingHeaderFontName,

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
        [System.String]
        $ApplyWaterMarkingFontName,

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
        [System.String]
        $EncryptionAipTemplateScopes,

        [Parameter()]
        [System.String]
        $EncryptionContentExpiredOnDateInDaysOrNever,

        [Parameter()]
        [System.Boolean]
        $EncryptionDoNotForward,

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
        [ValidateSet('Public', 'Private')]
        [System.String]
        $SiteAndGroupProtectionPrivacy,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of Sensitivity Label for $Name"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    if ($Global:CurrentModeIsExport)
    {
        $ConnectionMode = New-M365DSCConnection -Platform 'SecurityComplianceCenter' `
            -InboundParameters $PSBoundParameters `
            -SkipModuleReload $true
    }
    else
    {
        $ConnectionMode = New-M365DSCConnection -Platform 'SecurityComplianceCenter' `
            -InboundParameters $PSBoundParameters
    }
    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'

    try
    {
        try
        {
            $label = Get-Label -Identity $Name -ErrorAction SilentlyContinue `
                -IncludeDetailedLabelActions $true
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
                $parentLabel = Get-Label -Identity $label.ParentId -ErrorAction SilentlyContinue
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
            if($null -ne $label.EncryptionRightsDefinitions)
            {
                $EncryptionRightsDefinitionsValue = Convert-EncryptionRightDefinition -RightsDefinition $label.EncryptionRightsDefinitions
            }
            Write-Verbose "Found existing Sensitivity Label $($Name)"
            $result = @{
                Name                                           = $label.Name
                Comment                                        = $label.Comment
                ParentId                                       = $parentLabelID
                AdvancedSettings                               = $advancedSettingsValue
                DisplayName                                    = $label.DisplayName
                LocaleSettings                                 = $localeSettingsValue
                Priority                                       = $label.Priority
                Tooltip                                        = $label.Tooltip
                Disabled                                       = $label.Disabled
                GlobalAdminAccount                             = $GlobalAdminAccount
                Ensure                                         = 'Present'
                ApplyContentMarkingFooterAlignment             = $label.ApplyContentMarkingFooterAlignment
                ApplyContentMarkingFooterEnabled               = $label.ApplyContentMarkingFooterEnabled
                ApplyContentMarkingFooterFontColor             = $label.ApplyContentMarkingFooterFontColor
                ApplyContentMarkingFooterFontName              = $label.ApplyContentMarkingFooterFontName
                ApplyContentMarkingFooterFontSize              = $label.ApplyContentMarkingFooterFontSize
                ApplyContentMarkingFooterMargin                = $label.ApplyContentMarkingFooterMargin
                ApplyContentMarkingFooterText                  = $label.ApplyContentMarkingFooterText
                ApplyContentMarkingHeaderAlignment             = $label.ApplyContentMarkingHeaderAlignment
                ApplyContentMarkingHeaderEnabled               = $label.ApplyContentMarkingHeaderEnabled
                ApplyContentMarkingHeaderFontColor             = $label.ApplyContentMarkingHeaderFontColor
                ApplyContentMarkingHeaderFontName              = $label.ApplyContentMarkingHeaderFontName
                ApplyContentMarkingHeaderFontSize              = $label.ApplyContentMarkingHeaderFontSize
                ApplyContentMarkingHeaderMargin                = $label.ApplyContentMarkingHeaderMargin
                ApplyContentMarkingHeaderText                  = $label.ApplyContentMarkingHeaderText
                ApplyWaterMarkingEnabled                       = $label.ApplyWaterMarkingEnabled
                ApplyWaterMarkingFontColor                     = $label.ApplyWaterMarkingFontColor
                ApplyWaterMarkingFontName                      = $label.ApplyWaterMarkingFontName
                ApplyWaterMarkingFontSize                      = $label.ApplyWaterMarkingFontSize
                ApplyWaterMarkingLayout                        = $label.ApplyWaterMarkingLayout
                ApplyWaterMarkingText                          = $label.ApplyWaterMarkingText
                EncryptionAipTemplateScopes                    = $label.EncryptionAipTemplateScopes
                EncryptionContentExpiredOnDateInDaysOrNever    = $label.EncryptionContentExpiredOnDateInDaysOrNever
                EncryptionDoNotForward                         = $label.EncryptionDoNotForward
                EncryptionEnabled                              = $label.EncryptionEnabled
                EncryptionOfflineAccessDays                    = $label.EncryptionOfflineAccessDays
                EncryptionPromptUser                           = $label.EncryptionPromptUser
                EncryptionProtectionType                       = $label.EncryptionProtectionType
                EncryptionRightsDefinitions                    = $EncryptionRightsDefinitionsValue
                EncryptionRightsUrl                            = $label.EncryptionRightsUrl
                SiteAndGroupProtectionAllowAccessToGuestUsers  = $label.SiteAndGroupProtectionAllowAccessToGuestUsers
                SiteAndGroupProtectionAllowEmailFromGuestUsers = $label.SiteAndGroupProtectionAllowEmailFromGuestUsers
                SiteAndGroupProtectionAllowFullAccess          = $label.SiteAndGroupProtectionAllowFullAccess
                SiteAndGroupProtectionAllowLimitedAccess       = $label.SiteAndGroupProtectionAllowLimitedAccess
                SiteAndGroupProtectionBlockAccess              = $label.SiteAndGroupProtectionBlockAccess
                SiteAndGroupProtectionEnabled                  = $label.SiteAndGroupProtectionEnabled
                SiteAndGroupProtectionPrivacy                  = $label.SiteAndGroupProtectionPrivacy
            }

            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
            return $result
        }
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
        [System.Boolean]
        $Disabled,

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
        [System.String]
        $ApplyContentMarkingFooterFontName,

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
        [System.String]
        $ApplyContentMarkingHeaderFontName,

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
        [System.String]
        $ApplyWaterMarkingFontName,

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
        [System.String]
        $EncryptionAipTemplateScopes,

        [Parameter()]
        [System.String]
        $EncryptionContentExpiredOnDateInDaysOrNever,

        [Parameter()]
        [System.Boolean]
        $EncryptionDoNotForward,

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
        [ValidateSet('Public', 'Private')]
        [System.String]
        $SiteAndGroupProtectionPrivacy,


        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of Sensitivity label for $Name"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'SecurityComplianceCenter' `
        -InboundParameters $PSBoundParameters

    $label = Get-TargetResource @PSBoundParameters

    if ($PSBoundParameters.ContainsKey("Disabled"))
    {
        Write-Verbose -Message "The Disabled parameter is no longer available and will be depricated."
    }


    if (('Present' -eq $Ensure) -and ('Absent' -eq $label.Ensure))
    {
        $CreationParams = $PSBoundParameters

        if ($PSBoundParameters.ContainsKey("AdvancedSettings"))
        {
            $advanced = Convert-CIMToAdvancedSettings $AdvancedSettings
            $CreationParams["AdvancedSettings"] = $advanced
        }

        if ($PSBoundParameters.ContainsKey("LocaleSettings"))
        {
            $locale = Convert-CIMToLocaleSettings $LocaleSettings
            $CreationParams["LocaleSettings"] = $locale
        }

        $CreationParams.Remove("GlobalAdminAccount")
        $CreationParams.Remove("Ensure")
        $CreationParams.Remove("Priority")
        $CreationParams.Remove("Disabled")

        Write-Verbose "Creating new Sensitivity label $Name calling the New-Label cmdlet."

        try
        {
            New-Label @CreationParams
            ## Can't set priority until label created
            if ($PSBoundParameters.ContainsKey("Priority"))
            {
                Start-Sleep 5
                Set-label -Identity $Name -priority $Priority
            }
        }
        catch
        {
            Write-Warning "New-Label is not available in tenant $($GlobalAdminAccount.UserName.Split('@')[0])"
        }
    }
    elseif (('Present' -eq $Ensure) -and ('Present' -eq $label.Ensure))
    {
        $SetParams = $PSBoundParameters

        if ($PSBoundParameters.ContainsKey("AdvancedSettings"))
        {
            $advanced = Convert-CIMToAdvancedSettings  $AdvancedSettings
            $SetParams["AdvancedSettings"] = $advanced
        }

        if ($PSBoundParameters.ContainsKey("LocaleSettings"))
        {
            $locale = Convert-CIMToLocaleSettings $LocaleSettings
            $SetParams["LocaleSettings"] = $locale
        }

        #Remove unused parameters for Set-Label cmdlet
        $SetParams.Remove("GlobalAdminAccount")
        $SetParams.Remove("Ensure")
        $SetParams.Remove("Name")
        $SetParams.Remove("Disabled")

        try
        {
            Set-Label @SetParams -Identity $Name
        }
        catch
        {
            Write-Warning "Set-Label is not available in tenant $($GlobalAdminAccount.UserName.Split('@')[0])"
        }
    }
    elseif (('Absent' -eq $Ensure) -and ('Present' -eq $label.Ensure))
    {
        # If the label exists and it shouldn't, simply remove it;Need to force deletoion
        Write-Verbose -message "Deleting Sensitivity label $Name."

        try
        {
            Remove-Label -Identity $Name -Confirm:$false
            Remove-Label -Identity $Name -Confirm:$false -forcedeletion:$true
        }
        catch
        {
            Write-Warning "Remove-Label is not available in tenant $($GlobalAdminAccount.UserName.Split('@')[0])"
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
        [System.Boolean]
        $Disabled,

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
        [System.String]
        $ApplyContentMarkingFooterFontName,

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
        [System.String]
        $ApplyContentMarkingHeaderFontName,

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
        [System.String]
        $ApplyWaterMarkingFontName,

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
        [System.String]
        $EncryptionAipTemplateScopes,

        [Parameter()]
        [System.String]
        $EncryptionContentExpiredOnDateInDaysOrNever,

        [Parameter()]
        [System.Boolean]
        $EncryptionDoNotForward,

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
        [ValidateSet('Public', 'Private')]
        [System.String]
        $SiteAndGroupProtectionPrivacy,


        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of Sensitivity label for $Name"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null
    $ValuesToCheck.Remove('AdvancedSettings') | Out-Null
    $ValuesToCheck.Remove('LocaleSettings') | Out-Null
    $ValuesToCheck.Remove('Disabled') | Out-Null

    if ($null -ne $AdvancedSettings)
    {
        $TestAdvancedSettings = Test-AdvancedSettings -DesiredProperty $AdvancedSettings -CurrentProperty $CurrentValues.AdvancedSettings
        if ($false -eq $TestAdvancedSettings)
        {
            return $false
        }
    }

    if ($null -ne $LocaleSettings)
    {
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
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'SecurityComplianceCenter' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

    try
    {
        [array]$labels = Get-Label -ErrorAction Stop

        $dscContent = ""
        $i = 1
        Write-Host "`r`n" -NoNewLine
        foreach ($label in $labels)
        {
            Write-Host "    |---[$i/$($labels.Count)] $($label.Name)" -NoNewLine

            $Params = @{
                Name               = $label.Name
                GlobalAdminAccount = $GlobalAdminAccount
            }
            $Results = Get-TargetResource @Params

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
                -GlobalAdminAccount $GlobalAdminAccount
            if ($null -ne $Results.AdvancedSettings)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "AdvancedSettings"
            }
            if ($null -ne $Results.LocaleSettings)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "LocaleSettings"
            }

            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $dscContent += $currentDSCBlock
            $i++
        }
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return ""
    }
    return $dscContent
}

function Convert-JSONToLocaleSettings
{
    [CmdletBinding()]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    Param(
        [parameter(Mandatory = $true)]
        $JSONLocalSettings
    )
    $localeSettings = $JSONLocalSettings | Convertfrom-Json

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
                Value = $setting.Value
            }
            $settings += $entry
        }
        $result.Add("Settings", $settings)
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
    Param(
        [parameter(Mandatory = $true)]
        [System.String[]]
        $AdvancedSettings
    )
    $settings = @()
    foreach ($setting in $AdvancedSettings)
    {
        $settingString = $setting.Replace("[", "").Replace("]", "")
        $settingKey = $settingString.Split(",")[0]

        if ($settingKey -ne 'displayname')
        {
            $startPos = $settingString.IndexOf(",", 0) + 1
            $valueString = $settingString.Substring($startPos, $settingString.Length - $startPos).Trim()
            $values = $valueString.Split(",")

            $entry = @{
                Key   = $settingKey
                Value = $values
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
    Param(
        [parameter(Mandatory = $true)]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AdvancedSettings
    )

    $entry = @{ }
    foreach ($obj in $AdvancedSettings)
    {
        $settingsValues = ""
        foreach ($objVal in $obj.Value)
        {
            $settingsValues += $objVal
            $settingsValues += ","
        }
        $entry[$obj.Key] = $settingsValues.Substring(0, ($settingsValues.Length - 1))
    }

    return $entry
}

function Convert-EncryptionRightDefinition
{
    [CmdletBinding()]
    [OutputType([System.String])]
    Param(
        [parameter(Mandatory = $true)]
        [System.String]
        $RightsDefinition
    )

    $EncryptionRights = $RightsDefinition | ConvertFrom-Json
    foreach ($right in $EncryptionRights)
    {
        $StringContent += "$($right.Identity):$($right.Rights);"
    }
    if ($StringContent.EndsWith(";"))
    {
        $StringContent = $StringContent.Substring(0,($StringContent.Length-1))
    }
    return $StringContent

}

function Convert-CIMToLocaleSettings
{
    [CmdletBinding()]
    [OutputType([System.Collections.ArrayList])]
    Param(
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
        foreach ($setting in $localset.Settings)
        {
            $settingEntry = @{
                Key   = $setting.Key
                Value = $setting.Value
            }
            $settings += $settingEntry
        }
        $localeEntries.Add("Settings", $settings)
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
    param(
        [Parameter (Mandatory = $true)]
        $DesiredProperty,

        [Parameter (Mandatory = $true)]
        $CurrentProperty
    )

    $foundSettings = $true
    foreach ($desiredSetting in $DesiredProperty)
    {
        $foundKey = $CurrentProperty | Where-Object { $_.Key -eq $desiredSetting.Key }
        if ($null -ne $foundKey)
        {
            if ($foundKey.Value.ToString() -ne $desiredSetting.Value.ToString())
            {
                $foundSettings = $false
                break;
            }
        }
    }

    Write-Verbose -Message "Test AdvancedSettings  returns $foundSettings"
    return $foundSettings
}

function Test-LocaleSettings
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param(
        [Parameter (Mandatory = $true)]
        $DesiredProperty,
        [Parameter (Mandatory = $true)]
        $CurrentProperty
    )

    $foundSettings = $true
    foreach ($desiredSetting in $DesiredProperty)
    {
        $foundKey = $CurrentProperty | Where-Object { $_.LocaleKey -eq $desiredSetting.localeKey }
        foreach ($setting in $desiredSetting.Settings)
        {
            if ($null -ne $foundKey)
            {
                $myLabel = $foundKey.Settings | Where-Object { $_.Key -eq $setting.Key -and $_.Value -eq $setting.Value }

                if ($null -eq $myLabel)
                {
                    $foundSettings = $false
                    break;
                }
            }
            else
            {
                $foundSettings = $false
                break;

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
    $StringContent += "            )"
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
        $StringContent += "                    Settings  = @(`r`n"
        foreach ($Setting in $LocaleSetting.Settings)
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
    $StringContent += "            )"
    return $StringContent
}

Export-ModuleMember -Function *-TargetResource
