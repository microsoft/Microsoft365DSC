function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $CortanaEnabled,

        [Parameter()]
        [System.Boolean]
        $AppsAndServicesIsOfficeStoreEnabled,

        [Parameter()]
        [System.Boolean]
        $AppsAndServicesIsAppAndServicesTrialEnabled,

        [Parameter()]
        [System.Boolean]
        $DynamicsCustomerVoiceIsRestrictedSurveyAccessEnabled,

        [Parameter()]
        [System.Boolean]
        $DynamicsCustomerVoiceIsRecordIdentityByDefaultEnabled,

        [Parameter()]
        [System.Boolean]
        $DynamicsCustomerVoiceIsInOrgFormsPhishingScanEnabled,

        [Parameter()]
        [System.Boolean]
        $FormsIsExternalSendFormEnabled,

        [Parameter()]
        [System.Boolean]
        $FormsIsExternalShareCollaborationEnabled,

        [Parameter()]
        [System.Boolean]
        $FormsIsExternalShareResultEnabled,

        [Parameter()]
        [System.Boolean]
        $FormsIsExternalShareTemplateEnabled,

        [Parameter()]
        [System.Boolean]
        $FormsIsRecordIdentityByDefaultEnabled,

        [Parameter()]
        [System.Boolean]
        $FormsIsBingImageSearchEnabled,

        [Parameter()]
        [System.Boolean]
        $FormsIsInOrgFormsPhishingScanEnabled,

        [Parameter()]
        [System.Boolean]
        $M365WebEnableUsersToOpenFilesFrom3PStorage,

        [Parameter()]
        [System.Boolean]
        $PlannerAllowCalendarSharing,

        [Parameter()]
        [System.Boolean]
        $MicrosoftVivaBriefingEmail,

        [Parameter()]
        [System.Boolean]
        $ToDoIsPushNotificationEnabled,

        [Parameter()]
        [System.Boolean]
        $ToDoIsExternalJoinEnabled,

        [Parameter()]
        [System.Boolean]
        $ToDoIsExternalShareEnabled,

        [Parameter()]
        [System.Boolean]
        $VivaInsightsWebExperience,

        [Parameter()]
        [System.Boolean]
        $VivaInsightsDigestEmail,

        [Parameter()]
        [System.Boolean]
        $VivaInsightsOutlookAddInAndInlineSuggestions,

        [Parameter()]
        [System.Boolean]
        $VivaInsightsScheduleSendSuggestions,

        [Parameter()]
        [System.Boolean]
        $AdminCenterReportDisplayConcealedNames,

        [Parameter()]
        [System.String]
        [ValidateSet('current', 'monthlyEnterprise', 'semiAnnual')]
        $InstallationOptionsUpdateChannel,

        [Parameter()]
        [System.String[]]
        [ValidateSet('isVisioEnabled', 'isSkypeForBusinessEnabled', 'isProjectEnabled', 'isMicrosoft365AppsEnabled')]
        $InstallationOptionsAppsForWindows,

        [Parameter()]
        [System.String[]]
        [ValidateSet('isSkypeForBusinessEnabled', 'isMicrosoft365AppsEnabled')]
        $InstallationOptionsAppsForMac,

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    $ConnectionModeTasks = New-M365DSCConnection -Workload 'Tasks' `
        -InboundParameters $PSBoundParameters

    # Workaround for issue when if connected to S+C prior to calling cmdlet, an error about an invalid token is thrown.
    # If connected to S+C, then we need to re-initialize the connection to EXO.
    if ($Global:MSCloudLoginConnectionProfile.SecurityComplianceCenter.Connected -and `
        $Global:MSCloudLoginConnectionProfile.ExchangeOnline.Connected)
    {
        $Global:MSCloudLoginConnectionProfile.ExchangeOnline.Disconnect()
        $Global:MSCloudLoginConnectionProfile.SecurityComplianceCenter.Connected = $false
    }
    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

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

    $nullReturn = @{
        IsSingleInstance = $IsSingleInstance
        Ensure           = 'Absent'
    }

    $results = @{
        IsSingleInstance      = 'Yes'
        Credential            = $Credential
        ApplicationId         = $ApplicationId
        TenantId              = $TenantId
        ApplicationSecret     = $ApplicationSecret
        CertificateThumbprint = $CertificateThumbprint
        Managedidentity       = $ManagedIdentity.IsPresent
        AccessTokens          = $AccessTokens
    }
    try
    {
        $OfficeOnlineId = 'c1f33bc0-bdb4-4248-ba9b-096807ddb43e'
        $M365WebEnableUsersToOpenFilesFrom3PStorageValue = Get-MgServicePrincipal -Filter "appId eq '$OfficeOnlineId'" -Property 'AccountEnabled' -ErrorAction SilentlyContinue
        if ($null -eq $M365WebEnableUsersToOpenFilesFrom3PStorageValue)
        {
            Write-Verbose -Message "Registering the Office on the web Service Principal"
            New-MgServicePrincipal -AppId 'c1f33bc0-bdb4-4248-ba9b-096807ddb43e' -ErrorAction Stop | Out-Null
            $M365WebEnableUsersToOpenFilesFrom3PStorageValue = Get-MgServicePrincipal -Filter "appId eq '$OfficeOnlineId'" -Property 'AccountEnabled' -ErrorAction SilentlyContinue
        }

        if ($null -ne $M365WebEnableUsersToOpenFilesFrom3PStorageValue)
        {
            $results += @{
                M365WebEnableUsersToOpenFilesFrom3PStorage = $M365WebEnableUsersToOpenFilesFrom3PStorageValue.AccountEnabled
            }
        }

        # Planner iCal settings
        $PlannerSettings = Get-M365DSCO365OrgSettingsPlannerConfig
        if ($null -ne $PlannerSettings)
        {
            $results += @{
                PlannerAllowCalendarSharing = $PlannerSettings.allowCalendarSharing
            }
        }

        # Cortana settings
        $CortanaId = '0a0a29f9-0a25-49c7-94bf-c53c3f8fa69d'
        $CortanaEnabledValue = Get-MgServicePrincipal -Filter "appId eq '$CortanaId'" -Property 'AccountEnabled'
        if ($null -ne $CortanaEnabledValue)
        {
            $results += @{
                CortanaEnabled = $CortanaEnabledValue.AccountEnabled
            }
        }

        # DEPRECATED - Microsoft Viva Briefing Email
        <#
        $vivaBriefingEmailValue = $false
        try
        {
            $currentBriefingConfig = Get-DefaultTenantBriefingConfig -ErrorAction Stop -Verbose:$false
            if ($currentBriefingConfig.IsEnabledByDefault -eq 'opt-in')
            {
                $vivaBriefingEmailValue = $true
            }
        }
        catch
        {
            if ($_.Exception.Message -like "*Unexpected character encountered while parsing value*")
            {
                $vivaBriefingEmailValue = $true
            }
            elseif ($_.Exception.Message -like "*A task was canceled*")
            {
                $retries = 1
                $errorContent = $null
                while ($retries -le 5)
                {
                    try
                    {
                        Start-Sleep -Seconds 2
                        $currentBriefingConfig = Get-DefaultTenantBriefingConfig -ErrorAction Stop -Verbose:$false
                    }
                    catch
                    {
                        $errorContent = $_
                        $retries++
                    }
                }
                if ($null -eq $currentBriefingConfig)
                {
                    throw $errorContent
                }
                else
                {
                    if ($currentBriefingConfig.IsEnabledByDefault -eq 'opt-in')
                    {
                        $vivaBriefingEmailValue = $true
                    }
                }
            }
            else
            {
                throw $_
            }
        }
        $results += @{
            MicrosoftVivaBriefingEmail = $vivaBriefingEmailValue
        }#>

        # Viva Insights settings
        $currentVivaInsightsSettings = Get-DefaultTenantMyAnalyticsFeatureConfig -Verbose:$false
        if ($null -ne $currentVivaInsightsSettings)
        {
            $results += @{
                VivaInsightsDigestEmail                      = $currentVivaInsightsSettings.IsDigestEmailEnabled
                VivaInsightsOutlookAddInAndInlineSuggestions = $currentVivaInsightsSettings.IsAddInEnabled
                VivaInsightsScheduleSendSuggestions          = $currentVivaInsightsSettings.IsScheduleSendEnabled
                VivaInsightsWebExperience                    = $currentVivaInsightsSettings.IsDashboardEnabled
            }
        }

        $MRODeviceManagerService = 'ebe0c285-db95-403f-a1a3-a793bd6d7767'
        try
        {
            $servicePrincipal = Get-MgServicePrincipal -Filter "appid eq 'ebe0c285-db95-403f-a1a3-a793bd6d7767'"
            if ($null -eq $servicePrincipal)
            {
                Write-Verbose -Message "Registering the MRO Device Manager Service Principal"
                New-MgServicePrincipal -AppId 'ebe0c285-db95-403f-a1a3-a793bd6d7767' -ErrorAction Stop | Out-Null
            }
        }
        catch
        {
            Write-Verbose -Message $_
        }

        # Reports Display Settings
        $AdminCenterReportDisplayConcealedNamesValue = Get-M365DSCOrgSettingsAdminCenterReport
        if ($null -ne $AdminCenterReportDisplayConcealedNamesValue)
        {
            $results += @{
                AdminCenterReportDisplayConcealedNames = $AdminCenterReportDisplayConcealedNamesValue.displayConcealedNames
            }
        }

        # Installation Options
        $installationOptions = Get-M365DSCOrgSettingsInstallationOptions -AuthenticationOption $ConnectionModeTasks
        if ($null -ne $installationOptions)
        {
            $appsForWindowsValue = @()
            foreach ($key in $installationOptions.appsForWindows.Keys)
            {
                if ($installationOptions.appsForWindows.$key)
                {
                    $appsForWindowsValue += $key
                }
            }
            $appsForMacValue = @()
            foreach ($key in $installationOptions.appsForMac.Keys)
            {
                if ($installationOptions.appsForMac.$key)
                {
                    $appsForMacValue += $key
                }
            }

            $results += @{
                InstallationOptionsUpdateChannel  = $installationOptions.updateChannel
                InstallationOptionsAppsForWindows = $appsForWindowsValue
                InstallationOptionsAppsForMac     = $appsForMacValue
            }
        }

        # Forms
        $FormsSettings = Get-M365DSCOrgSettingsForms
        if ($null -ne $FormsSettings)
        {
            $results += @{
                FormsIsExternalSendFormEnabled                        = $FormsSettings.isExternalSendFormEnabled
                FormsIsExternalShareCollaborationEnabled              = $FormsSettings.isExternalShareCollaborationEnabled
                FormsIsExternalShareResultEnabled                     = $FormsSettings.isExternalShareResultEnabled
                FormsIsExternalShareTemplateEnabled                   = $FormsSettings.isExternalShareTemplateEnabled
                FormsIsRecordIdentityByDefaultEnabled                 = $FormsSettings.isRecordIdentityByDefaultEnabled
                FormsIsBingImageSearchEnabled                         = $FormsSettings.isBingImageSearchEnabled
                FormsIsInOrgFormsPhishingScanEnabled                  = $FormsSettings.isInOrgFormsPhishingScanEnabled
            }
        }

        # DynamicsCustomerVoice
        $DynamicCustomerVoiceSettings = Get-M365DSCOrgSettingsDynamicsCustomerVoice
        if ($null -ne $DynamicCustomerVoiceSettings)
        {
            $results += @{
                DynamicsCustomerVoiceIsRestrictedSurveyAccessEnabled  = $DynamicCustomerVoiceSettings.isRestrictedSurveyAccessEnabled
                DynamicsCustomerVoiceIsRecordIdentityByDefaultEnabled = $DynamicCustomerVoiceSettings.isRecordIdentityByDefaultEnabled
                DynamicsCustomerVoiceIsInOrgFormsPhishingScanEnabled  = $DynamicCustomerVoiceSettings.isInOrgFormsPhishingScanEnabled
            }
        }

        # Apps and Services
        $AppsAndServicesSettings = Get-M365DSCOrgSettingsAppsAndServices
        if ($null -ne $AppsAndServicesSettings)
        {
            $results += @{
                AppsAndServicesIsOfficeStoreEnabled                   = $AppsAndServicesSettings.isOfficeStoreEnabled
                AppsAndServicesIsAppAndServicesTrialEnabled           = $AppsAndServicesSettings.IsAppAndServicesTrialEnabled
            }
        }

        # To do
        $ToDoSettings = Get-M365DSCOrgSettingsToDo
        if ($null -ne $ToDoSettings)
        {
            $results += @{
                ToDoIsPushNotificationEnabled                         = $ToDoSettings.IsPushNotificationEnabled
                ToDoIsExternalJoinEnabled                             = $ToDoSettings.IsExternalJoinEnabled
                ToDoIsExternalShareEnabled                            = $ToDoSettings.IsExternalShareEnabled
            }
        }

        return $results
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
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $CortanaEnabled,

        [Parameter()]
        [System.Boolean]
        $AppsAndServicesIsOfficeStoreEnabled,

        [Parameter()]
        [System.Boolean]
        $AppsAndServicesIsAppAndServicesTrialEnabled,

        [Parameter()]
        [System.Boolean]
        $DynamicsCustomerVoiceIsRestrictedSurveyAccessEnabled,

        [Parameter()]
        [System.Boolean]
        $DynamicsCustomerVoiceIsRecordIdentityByDefaultEnabled,

        [Parameter()]
        [System.Boolean]
        $DynamicsCustomerVoiceIsInOrgFormsPhishingScanEnabled,

        [Parameter()]
        [System.Boolean]
        $FormsIsExternalSendFormEnabled,

        [Parameter()]
        [System.Boolean]
        $FormsIsExternalShareCollaborationEnabled,

        [Parameter()]
        [System.Boolean]
        $FormsIsExternalShareResultEnabled,

        [Parameter()]
        [System.Boolean]
        $FormsIsExternalShareTemplateEnabled,

        [Parameter()]
        [System.Boolean]
        $FormsIsRecordIdentityByDefaultEnabled,

        [Parameter()]
        [System.Boolean]
        $FormsIsBingImageSearchEnabled,

        [Parameter()]
        [System.Boolean]
        $FormsIsInOrgFormsPhishingScanEnabled,

        [Parameter()]
        [System.Boolean]
        $M365WebEnableUsersToOpenFilesFrom3PStorage,

        [Parameter()]
        [System.Boolean]
        $PlannerAllowCalendarSharing,

        [Parameter()]
        [System.Boolean]
        $MicrosoftVivaBriefingEmail,

        [Parameter()]
        [System.Boolean]
        $ToDoIsPushNotificationEnabled,

        [Parameter()]
        [System.Boolean]
        $ToDoIsExternalJoinEnabled,

        [Parameter()]
        [System.Boolean]
        $ToDoIsExternalShareEnabled,

        [Parameter()]
        [System.Boolean]
        $VivaInsightsWebExperience,

        [Parameter()]
        [System.Boolean]
        $VivaInsightsDigestEmail,

        [Parameter()]
        [System.Boolean]
        $VivaInsightsOutlookAddInAndInlineSuggestions,

        [Parameter()]
        [System.Boolean]
        $VivaInsightsScheduleSendSuggestions,

        [Parameter()]
        [System.Boolean]
        $AdminCenterReportDisplayConcealedNames,

        [Parameter()]
        [System.String]
        [ValidateSet('current', 'monthlyEnterprise', 'semiAnnual')]
        $InstallationOptionsUpdateChannel,

        [Parameter()]
        [System.String[]]
        [ValidateSet('isVisioEnabled', 'isSkypeForBusinessEnabled', 'isProjectEnabled', 'isMicrosoft365AppsEnabled')]
        $InstallationOptionsAppsForWindows,

        [Parameter()]
        [System.String[]]
        [ValidateSet('isSkypeForBusinessEnabled', 'isMicrosoft365AppsEnabled')]
        $InstallationOptionsAppsForMac,

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    if ($PSBoundParameters.ContainsKey('Ensure') -and $Ensure -eq 'Absent')
    {
        throw 'This resource is not able to remove the Org settings and therefore only accepts Ensure=Present.'
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

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters
    $currentValues = Get-TargetResource @PSBoundParameters

    if ($M365WebEnableUsersToOpenFilesFrom3PStorage -ne $currentValues.M365WebEnableUsersToOpenFilesFrom3PStorage)
    {
        Write-Verbose -Message "Updating the Microsoft 365 On the Web setting to {$M365WebEnableUsersToOpenFilesFrom3PStorage}"
        $OfficeOnlineId = 'c1f33bc0-bdb4-4248-ba9b-096807ddb43e'
        $M365WebEnableUsersToOpenFilesFrom3PStorageValue = Get-MgServicePrincipal -Filter "appId eq '$OfficeOnlineId'" -Property 'AccountEnabled, Id'
        Update-MgservicePrincipal -ServicePrincipalId $($M365WebEnableUsersToOpenFilesFrom3PStorageValue.Id) `
            -AccountEnabled:$M365WebEnableUsersToOpenFilesFrom3PStorage
    }
    if ($PlannerAllowCalendarSharing -ne $currentValues.PlannerAllowCalendarSharing)
    {
        Write-Verbose -Message "Updating the Planner Allow Calendar Sharing setting to {$PlannerAllowCalendarSharing}"
        Set-M365DSCO365OrgSettingsPlannerConfig -AllowCalendarSharing $PlannerAllowCalendarSharing
    }

    if ($currentValues.CortanaEnabled -and $CortanaEnabled -ne $currentValues.CortanaEnabled)
    {
        $CortanaId = '0a0a29f9-0a25-49c7-94bf-c53c3f8fa69d'
        $CortanaEnabledValue = Get-MgServicePrincipal -Filter "appId eq '$CortanaId'" -Property 'AccountEnabled, Id'

        if ($null -ne $CortanaEnabledValue.Id -and $CortanaEnabledValue.AccountEnabled)
        {
            Write-Verbose -Message "Updating the Cortana setting to {$CortanaEnabled}"
            Update-MgServicePrincipal -ServicePrincipalId $($CortanaEnabledValue.Id) `
                -AccountEnabled:$CortanaEnabled
        }
    }

    # Microsoft Viva Briefing Email
    if ($null -ne $MicrosoftVivaBriefingEmail)
    {
        Write-Verbose -Message "DEPRECATED - The MicrosoftVivaBriefingEmail parameter is deprecated and will be ignored."
    }
    #$briefingValue = 'opt-out'

    <# DEPRECATED
    if ($currentValues.MicrosoftVivaBriefingEmail -and $MicrosoftVivaBriefingEmail -ne $currentValues.MicrosoftVivaBriefingEmail)
    {
        Write-Verbose -Message "Updating Microsoft Viva Briefing Email settings."
        Set-DefaultTenantBriefingConfig -IsEnabledByDefault $briefingValue -Verbose:$false | Out-Null
    }#>

    # Viva Insights
    if ($currentValues.VivaInsightsWebExperience -ne $VivaInsightsWebExperience)
    {
        Write-Verbose -Message "Updating Viva Insights settings for Web Experience"
        Set-DefaultTenantMyAnalyticsFeatureConfig -Feature "Dashboard" -IsEnabled $VivaInsightsWebExperience -Verbose:$false | Out-Null
    }

    if ($currentValues.VivaInsightsDigestEmail -ne $VivaInsightsDigestEmail)
    {
        Write-Verbose -Message "Updating Viva Insights settings for Digest Email"
        Set-DefaultTenantMyAnalyticsFeatureConfig -Feature "Digest-email" -IsEnabled $VivaInsightsDigestEmail -Verbose:$false | Out-Null
    }

    if ($currentValues.VivaInsightsOutlookAddInAndInlineSuggestions -ne $VivaInsightsOutlookAddInAndInlineSuggestions)
    {
        Write-Verbose -Message "Updating Viva Insights settings for Addin and Inline Suggestions"
        Set-DefaultTenantMyAnalyticsFeatureConfig -Feature "Add-In" -IsEnabled $VivaInsightsOutlookAddInAndInlineSuggestions -Verbose:$false | Out-Null
    }

    if ($currentValues.VivaInsightsScheduleSendSuggestions -ne $VivaInsightsScheduleSendSuggestions)
    {
        Write-Verbose -Message "Updating Viva Insights settings for ScheduleSendSuggestions"
        Set-DefaultTenantMyAnalyticsFeatureConfig -Feature "Scheduled-send" -IsEnabled $VivaInsightsScheduleSendSuggestions -Verbose:$false | Out-Null
    }

    # Reports Display Names
    $AdminCenterReportDisplayConcealedNamesEnabled = Get-M365DSCOrgSettingsAdminCenterReport
    if ($AdminCenterReportDisplayConcealedNames -ne $AdminCenterReportDisplayConcealedNamesEnabled.displayConcealedNames)
    {
        Write-Verbose -Message "Updating the Admin Center Report Display Concealed Names setting to {$AdminCenterReportDisplayConcealedNames}"
        Update-M365DSCOrgSettingsAdminCenterReport -DisplayConcealedNames $AdminCenterReportDisplayConcealedNames
    }

    # Apps Installation
    if (($PSBoundParameters.ContainsKey("InstallationOptionsAppsForWindows") -or `
        $PSBoundParameters.ContainsKey("InstallationOptionsAppsForMac")) -and `
        ($null -ne (Compare-Object -ReferenceObject $currentValues.InstallationOptionsAppsForWindows -DifferenceObject $InstallationOptionsAppsForWindows) -or `
         $null -ne (Compare-Object -ReferenceObject $currentValues.InstallationOptionsAppsForMac -DifferenceObject $InstallationOptionsAppsForMac)))
    {
        $ConnectionModeTasks = New-M365DSCConnection -Workload 'Tasks' `
            -InboundParameters $PSBoundParameters
        $InstallationOptions = Get-M365DSCOrgSettingsInstallationOptions -AuthenticationOption $ConnectionModeTasks
        $InstallationOptionsToUpdate = @{
            updateChannel = ""
            appsForWindows = @{
                isMicrosoft365AppsEnabled = $false
                isProjectEnabled          = $false
                isSkypeForBusinessEnabled = $false
                isVisioEnabled            = $false
            }
            appsForMac = @{
                isMicrosoft365AppsEnabled = $false
                isSkypeForBusinessEnabled = $false
            }
        }

        if ($PSBoundParameters.ContainsKey("InstallationOptionsUpdateChannel") -and `
            ($InstallationOptionsUpdateChannel -ne $InstallationOptions.updateChannel))
        {
            $InstallationOptionsToUpdate.updateChannel = $InstallationOptionsUpdateChannel
        }
        else
        {
            $InstallationOptionsToUpdate.Remove('updateChannel') | Out-Null
        }

        if ($PSBoundParameters.ContainsKey("InstallationOptionsAppsForWindows"))
        {
            foreach ($key in $InstallationOptionsAppsForWindows)
            {
                $InstallationOptionsToUpdate.appsForWindows.$key = $true
            }
        }
        else
        {
            $InstallationOptionsToUpdate.Remove('appsForWindows') | Out-Null
        }

        if ($PSBoundParameters.ContainsKey("InstallationOptionsAppsForMac"))
        {
            foreach ($key in $InstallationOptionsAppsForMac)
            {
                $InstallationOptionsToUpdate.appsForMac.$key = $true
            }
        }
        else
        {
            $InstallationOptionsToUpdate.Remove('appsForMac') | Out-Null
        }

        if ($InstallationOptionsToUpdate.Keys.Count -gt 0)
        {
            Write-Verbose -Message "Updating O365 Installation Options with $(Convert-M365DscHashtableToString -Hashtable $InstallationOptionsToUpdate)"
            Update-M365DSCOrgSettingsInstallationOptions -Options $InstallationOptionsToUpdate `
                -AuthenticationOption $ConnectionModeTasks
        }
    }

    # Forms
    $FormsParametersToUpdate = @{}
    if ($FormsIsExternalSendFormEnabled -ne $currentValues.FormsIsExternalSendFormEnabled)
    {
        $FormsParametersToUpdate.Add('isExternalSendFormEnabled', $FormsIsExternalSendFormEnabled)
    }
    if ($FormsIsExternalShareCollaborationEnabled -ne $currentValues.FormsIsExternalShareCollaborationEnabled)
    {
        $FormsParametersToUpdate.Add('isExternalShareCollaborationEnabled', $FormsIsExternalShareCollaborationEnabled)
    }
    if ($FormsIsExternalShareResultEnabled -ne $currentValues.FormsIsExternalShareResultEnabled)
    {
        $FormsParametersToUpdate.Add('isExternalShareResultEnabled', $FormsIsExternalShareResultEnabled)
    }
    if ($FormsIsExternalShareTemplateEnabled -ne $currentValues.FormsIsExternalShareTemplateEnabled)
    {
        $FormsParametersToUpdate.Add('isExternalShareTemplateEnabled', $FormsIsExternalShareTemplateEnabled)
    }
    if ($FormsIsRecordIdentityByDefaultEnabled -ne $currentValues.FormsIsRecordIdentityByDefaultEnabled)
    {
        $FormsParametersToUpdate.Add('isRecordIdentityByDefaultEnabled', $FormsIsRecordIdentityByDefaultEnabled)
    }
    if ($FormsIsBingImageSearchEnabled -ne $currentValues.FormsIsBingImageSearchEnabled)
    {
        $FormsParametersToUpdate.Add('isBingImageSearchEnabled', $FormsIsBingImageSearchEnabled)
    }
    if ($FormsIsInOrgFormsPhishingScanEnabled -ne $currentValues.FormsIsInOrgFormsPhishingScanEnabled)
    {
        $FormsParametersToUpdate.Add('isInOrgFormsPhishingScanEnabled', $FormsIsInOrgFormsPhishingScanEnabled)
    }
    if ($FormsParametersToUpdate.Keys.Count -gt 0)
    {
        Write-Verbose -Message "Updating the Microsoft Forms settings with values:$(Convert-M365DscHashtableToString -Hashtable $FormsParametersToUpdate)"
        Update-M365DSCOrgSettingsForms -Options $FormsParametersToUpdate
    }

    # Dynamics Customer Voice Settings
    $DynamicsCustomerVoiceParametersToUpdate = @{}
    if ($DynamicsCustomerVoiceIsRestrictedSurveyAccessEnabled -ne $currentValues.DynamicsCustomerVoiceIsRestrictedSurveyAccessEnabled)
    {
        $DynamicsCustomerVoiceParametersToUpdate.Add('isRestrictedSurveyAccessEnabled', $DynamicsCustomerVoiceIsRestrictedSurveyAccessEnabled)
    }
    if ($DynamicsCustomerVoiceIsRecordIdentityByDefaultEnabled -ne $currentValues.DynamicsCustomerVoiceIsRecordIdentityByDefaultEnabled)
    {
        $DynamicsCustomerVoiceParametersToUpdate.Add('isRecordIdentityByDefaultEnabled', $DynamicsCustomerVoiceIsRecordIdentityByDefaultEnabled)
    }
    if ($DynamicsCustomerVoiceIsInOrgFormsPhishingScanEnabled -ne $currentValues.DynamicsCustomerVoiceIsInOrgFormsPhishingScanEnabled)
    {
        $DynamicsCustomerVoiceParametersToUpdate.Add('isInOrgFormsPhishingScanEnabled', $DynamicsCustomerVoiceIsInOrgFormsPhishingScanEnabled)
    }
    if ($DynamicsCustomerVoiceParametersToUpdate.Keys.Count -gt 0)
    {
        Write-Verbose -Message "Updating the Dynamics 365 Customer Voice settings with values:$(Convert-M365DscHashtableToString -Hashtable $DynamicsCustomerVoiceParametersToUpdate)"
        Update-M365DSCOrgSettingsDynamicsCustomerVoice -Options $DynamicsCustomerVoiceParametersToUpdate
    }

    # Apps And Services
    $AppsAndServicesParametersToUpdate = @{}
    if ($AppsAndServicesIsOfficeStoreEnabled -ne $currentValues.AppsAndServicesIsOfficeStoreEnabled)
    {
        $AppsAndServicesParametersToUpdate.Add('isOfficeStoreEnabled', $AppsAndServicesIsOfficeStoreEnabled)
    }
    if ($AppsAndServicesIsAppAndServicesTrialEnabled -ne $currentValues.AppsAndServicesIsAppAndServicesTrialEnabled)
    {
        $AppsAndServicesParametersToUpdate.Add('isAppAndServicesTrialEnabled', $AppsAndServicesIsAppAndServicesTrialEnabled)
    }
    if ($AppsAndServicesParametersToUpdate.Keys.Count -gt 0)
    {
        Write-Verbose -Message "Updating the Apps & Settings settings with values:$(Convert-M365DscHashtableToString -Hashtable $AppsAndServicesParametersToUpdate)"
        Update-M365DSCOrgSettingsAppsAndServices -Options $AppsAndServicesParametersToUpdate
    }

    # To Do
    $ToDoParametersToUpdate = @{}
    if ($ToDoIsPushNotificationEnabled -ne $currentValues.ToDoIsPushNotificationEnabled)
    {
        $ToDoParametersToUpdate.Add('isPushNotificationEnabled', $ToDoIsPushNotificationEnabled)
    }
    if ($ToDoIsExternalJoinEnabled -ne $currentValues.ToDoIsExternalJoinEnabled)
    {
        $ToDoParametersToUpdate.Add('isExternalJoinEnabled', $ToDoIsExternalJoinEnabled)
    }
    if ($ToDoIsExternalShareEnabled -ne $currentValues.ToDoIsExternalShareEnabled)
    {
        $ToDoParametersToUpdate.Add('isExternalShareEnabled', $ToDoIsExternalShareEnabled)
    }
    if ($ToDoParametersToUpdate.Keys.Count -gt 0)
    {
        Write-Verbose -Message "Updating the To Do settings with values:$(Convert-M365DscHashtableToString -Hashtable $ToDoParametersToUpdate)"
        Update-M365DSCOrgSettingsToDo -Options $ToDoParametersToUpdate
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $CortanaEnabled,

        [Parameter()]
        [System.Boolean]
        $AppsAndServicesIsOfficeStoreEnabled,

        [Parameter()]
        [System.Boolean]
        $AppsAndServicesIsAppAndServicesTrialEnabled,

        [Parameter()]
        [System.Boolean]
        $DynamicsCustomerVoiceIsRestrictedSurveyAccessEnabled,

        [Parameter()]
        [System.Boolean]
        $DynamicsCustomerVoiceIsRecordIdentityByDefaultEnabled,

        [Parameter()]
        [System.Boolean]
        $DynamicsCustomerVoiceIsInOrgFormsPhishingScanEnabled,

        [Parameter()]
        [System.Boolean]
        $FormsIsExternalSendFormEnabled,

        [Parameter()]
        [System.Boolean]
        $FormsIsExternalShareCollaborationEnabled,

        [Parameter()]
        [System.Boolean]
        $FormsIsExternalShareResultEnabled,

        [Parameter()]
        [System.Boolean]
        $FormsIsExternalShareTemplateEnabled,

        [Parameter()]
        [System.Boolean]
        $FormsIsRecordIdentityByDefaultEnabled,

        [Parameter()]
        [System.Boolean]
        $FormsIsBingImageSearchEnabled,

        [Parameter()]
        [System.Boolean]
        $FormsIsInOrgFormsPhishingScanEnabled,

        [Parameter()]
        [System.Boolean]
        $M365WebEnableUsersToOpenFilesFrom3PStorage,

        [Parameter()]
        [System.Boolean]
        $PlannerAllowCalendarSharing,

        [Parameter()]
        [System.Boolean]
        $MicrosoftVivaBriefingEmail,

        [Parameter()]
        [System.Boolean]
        $ToDoIsPushNotificationEnabled,

        [Parameter()]
        [System.Boolean]
        $ToDoIsExternalJoinEnabled,

        [Parameter()]
        [System.Boolean]
        $ToDoIsExternalShareEnabled,

        [Parameter()]
        [System.Boolean]
        $VivaInsightsWebExperience,

        [Parameter()]
        [System.Boolean]
        $VivaInsightsDigestEmail,

        [Parameter()]
        [System.Boolean]
        $VivaInsightsOutlookAddInAndInlineSuggestions,

        [Parameter()]
        [System.Boolean]
        $VivaInsightsScheduleSendSuggestions,

        [Parameter()]
        [System.Boolean]
        $AdminCenterReportDisplayConcealedNames,

        [Parameter()]
        [System.String]
        [ValidateSet('current', 'monthlyEnterprise', 'semiAnnual')]
        $InstallationOptionsUpdateChannel,

        [Parameter()]
        [System.String[]]
        [ValidateSet('isVisioEnabled', 'isSkypeForBusinessEnabled', 'isProjectEnabled', 'isMicrosoft365AppsEnabled')]
        $InstallationOptionsAppsForWindows,

        [Parameter()]
        [System.String[]]
        [ValidateSet('isSkypeForBusinessEnabled', 'isMicrosoft365AppsEnabled')]
        $InstallationOptionsAppsForMac,

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

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

    Write-Verbose -Message 'Testing configuration for Org Settings.'

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()
    $ValuesToCheck.Remove("MicrosoftVivaBriefingEmail") | Out-Null

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

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
        if ($null -ne $Global:M365DSCExportResourceInstancesCount)
        {
            $Global:M365DSCExportResourceInstancesCount++
        }

        $Params = @{
            IsSingleInstance      = 'Yes'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            Managedidentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
        }

        $Results = Get-TargetResource @Params

        $dscContent = ''
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

function Get-M365DSCO365OrgSettingsPlannerConfig
{
    [CmdletBinding()]
    param()
    $VerbosePreference = 'SilentlyContinue'

    try
    {
        $Uri = $Global:MSCloudLoginConnectionProfile.Tasks.HostUrl + "/taskAPI/tenantAdminSettings/Settings";
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $results = Invoke-RestMethod -ContentType "application/json;odata.metadata=full" `
            -Headers @{"Accept"="application/json"; "Authorization"=$Global:MSCloudLoginConnectionProfile.Tasks.AccessToken; "Accept-Charset"="UTF-8"; "OData-Version"="4.0;NetFx"; "OData-MaxVersion"="4.0;NetFx"} `
            -Method GET `
            $Uri -ErrorAction Stop
        return $results
    }
    catch
    {
        if ($_.Exception.Message -eq 'The request was aborted: Could not create SSL/TLS secure channel.')
        {
            Write-Warning -Message "Could not create SSL/TLS secure channel. Skipping the Planner settings."
        }
        else
        {
            Write-Verbose -Message "Not able to retrieve Office 365 Planner Settings. Please ensure correct permissions have been granted."
            New-M365DSCLogEntry -Message 'Error updating Office 365 Planner Settings' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential
        }

        return $null
    }
}

function Set-M365DSCO365OrgSettingsPlannerConfig
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.Boolean]
        $AllowCalendarSharing
    )
    $VerbosePreference = 'SilentlyContinue'

    $flags = @{
        allowCalendarSharing = $AllowCalendarSharing
    }

    $requestBody = $flags | ConvertTo-Json
    $Uri = $Global:MSCloudLoginConnectionProfile.Tasks.HostUrl + "/taskAPI/tenantAdminSettings/Settings";
    $results = Invoke-RestMethod -ContentType "application/json;odata.metadata=full" `
        -Headers @{"Accept"="application/json"; "Authorization"=$Global:MSCloudLoginConnectionProfile.Tasks.AccessToken; "Accept-Charset"="UTF-8"; "OData-Version"="4.0;NetFx"; "OData-MaxVersion"="4.0;NetFx"} `
        -Method PATCH `
        -Body $requestBody `
        $Uri
}

function Get-M365DSCOrgSettingsInstallationOptions
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $AuthenticationOption
    )
    $VerbosePreference = 'SilentlyContinue'

    try
    {
        $url = $Global:MSCloudLoginConnectionProfile.MicrosoftGraph.ResourceUrl + 'beta/admin/microsoft365Apps/installationOptions'
        $results = Invoke-MgGraphRequest -Method GET -Uri $url
        return $results
    }
    catch
    {
        Write-Verbose -Message "Not able to retrieve Office 365 Apps Installation Options. Please ensure correct permissions have been granted."
        return $null
    }
}

function Update-M365DSCOrgSettingsInstallationOptions
{
    [CmdletBinding()]
    [OutputType([Void])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Options,

        [Parameter(Mandatory = $true)]
        [System.String]
        $AuthenticationOption
    )
    $VerbosePreference = 'SilentlyContinue'

    try
    {
        $url = $Global:MSCloudLoginConnectionProfile.MicrosoftGraph.ResourceUrl + 'beta/admin/microsoft365Apps/installationOptions'
        Invoke-MgGraphRequest -Method PATCH -Uri $url -Body $Options | Out-Null
    }
    catch
    {
        if ($_.Exception.ToString().Contains('Forbidden (Forbidden)'))
        {
            if ($AuthenticationOption -eq 'Credentials')
            {
                $errorMessage = "You don't have the proper permissions to update the Office 365 Apps Installation Options." `
                    + " When using Credentials to authenticate, you need to grant permissions to the Microsoft Graph PowerShell SDK by running" `
                    + " Connect-MgGraph -Scopes OrgSettings-Microsoft365Install.ReadWrite.All"
                Write-Error -Message $errorMessage
            }
        }
    }
}

function Get-M365DSCOrgSettingsForms
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()
    $VerbosePreference = 'SilentlyContinue'

    try
    {
        $url = $Global:MSCloudLoginConnectionProfile.MicrosoftGraph.ResourceUrl + 'beta/admin/forms/settings'
        $results = Invoke-MgGraphRequest -Method GET -Uri $url -ErrorAction Stop
        return $results
    }
    catch
    {
        Write-Verbose -Message "Not able to retrieve O365OrgSettings Forms Settings. Please ensure correct permissions have been granted."
        return $null
    }
}

function Update-M365DSCOrgSettingsForms
{
    [CmdletBinding()]
    [OutputType([Void])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Options
    )
    $VerbosePreference = 'SilentlyContinue'

    try
    {
        Write-Verbose -Message "Updating Forms Settings"
        $url = $Global:MSCloudLoginConnectionProfile.MicrosoftGraph.ResourceUrl + 'beta/admin/forms/settings'
        Invoke-MgGraphRequest -Method PATCH -Uri $url -Body $Options | Out-Null
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error updating O365OrgSettings Forms Settings' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential
    }
}

function Get-M365DSCOrgSettingsDynamicsCustomerVoice
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()
    $VerbosePreference = 'SilentlyContinue'

    try
    {
        $url = $Global:MSCloudLoginConnectionProfile.MicrosoftGraph.ResourceUrl + 'beta/admin/dynamics/customerVoice'
        $results = Invoke-MgGraphRequest -Method GET -Uri $url -ErrorAction Stop
        return $results
    }
    catch
    {
        Write-Verbose -Message "Not able to retrieve O365OrgSettings Dynamics Customer Voice Settings. Please ensure correct permissions have been granted."
        return $null
    }
}

function Update-M365DSCOrgSettingsDynamicsCustomerVoice
{
    [CmdletBinding()]
    [OutputType([Void])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Options
    )
    $VerbosePreference = 'SilentlyContinue'

    try
    {
        $url = $Global:MSCloudLoginConnectionProfile.MicrosoftGraph.ResourceUrl + 'beta/admin/dynamics/customerVoice'
        Invoke-MgGraphRequest -Method PATCH -Uri $url -Body $Options | Out-Null
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error updating O365OrgSettings Dynamics Customer Voice Settings' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential
    }
}

function Get-M365DSCOrgSettingsAppsAndServices
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()
    $VerbosePreference = 'SilentlyContinue'

    try
    {
        $url = $Global:MSCloudLoginConnectionProfile.MicrosoftGraph.ResourceUrl + 'beta/admin/appsAndServices/settings'
        $results = Invoke-MgGraphRequest -Method GET -Uri $url -ErrorAction Stop
        return $results
    }
    catch
    {
        Write-Verbose -Message "Not able to retrieve O365OrgSettings Apps and Services Settings. Please ensure correct permissions have been granted."
        return $null
    }
}

function Update-M365DSCOrgSettingsAppsAndServices
{
    [CmdletBinding()]
    [OutputType([Void])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Options
    )
    $VerbosePreference = 'SilentlyContinue'

    try
    {
        $url = $Global:MSCloudLoginConnectionProfile.MicrosoftGraph.ResourceUrl + 'beta/admin/appsAndServices/settings'
        Invoke-MgGraphRequest -Method PATCH -Uri $url -Body $Options | Out-Null
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error updating O365OrgSettings Apps and Services Settings' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential
    }
}
function Get-M365DSCOrgSettingsToDo
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()
    $VerbosePreference = 'SilentlyContinue'

    try
    {
        $url = $Global:MSCloudLoginConnectionProfile.MicrosoftGraph.ResourceUrl + 'beta/admin/todo/settings'
        $results = Invoke-MgGraphRequest -Method GET -Uri $url -ErrorAction Stop
        return $results
    }
    catch
    {
        Write-Verbose -Message "Not able to retrieve ToDo settings. Please ensure correct permissions have been granted."
        return $null
    }
}

function Update-M365DSCOrgSettingsToDo
{
    [CmdletBinding()]
    [OutputType([Void])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Options
    )
    $VerbosePreference = 'SilentlyContinue'

    try
    {
        $url = $Global:MSCloudLoginConnectionProfile.MicrosoftGraph.ResourceUrl + 'beta/admin/todo/settings'
        Invoke-MgGraphRequest -Method PATCH -Uri $url -Body $Options | Out-Null
    }
    catch
    {
        Write-Verbose -Message "Error: $($_.Exception.Message)"
        New-M365DSCLogEntry -Message 'Error updating O365OrgSettings To Do Settings' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential
    }
}

function Get-M365DSCOrgSettingsAdminCenterReport
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()
    $VerbosePreference = 'SilentlyContinue'

    try
    {
        $url = $Global:MSCloudLoginConnectionProfile.MicrosoftGraph.ResourceUrl + 'beta/admin/reportSettings'
        $results = Invoke-MgGraphRequest -Method GET -Uri $url -ErrorAction Stop
        return $results
    }
    catch
    {
        Write-Verbose -Message "Not able to retrieve Office 365 Report Settings. Please ensure correct permissions have been granted."
        return $null
    }
}

function Update-M365DSCOrgSettingsAdminCenterReport
{
    [CmdletBinding()]
    [OutputType([Void])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Boolean]
        $DisplayConcealedNames
    )
    $VerbosePreference = 'SilentlyContinue'
    $url = $Global:MSCloudLoginConnectionProfile.MicrosoftGraph.ResourceUrl + 'beta/admin/reportSettings'
    $body = @{
        "@odata.context"      = $Global:MSCloudLoginConnectionProfile.MicrosoftGraph.ResourceUrl + 'beta/$metadata#admin/reportSettings/$entity'
        displayConcealedNames = $DisplayConcealedNames
    }
    Invoke-MgGraphRequest -Method PATCH -Uri $url -Body $body | Out-Null
}

Export-ModuleMember -Function *-TargetResource
