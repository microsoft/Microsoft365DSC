function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $AdvancedClassificationEnabled,

        [Parameter()]
        [System.Boolean]
        $AuditFileActivity,

        [Parameter()]
        [System.Boolean]
        $BandwidthLimitEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $BusinessJustificationList,

        [Parameter()]
        [System.String]
        $CloudAppMode,

        [Parameter()]
        [System.String[]]
        $CloudAppRestrictionList,

        [Parameter()]
        [System.UInt32]
        $CustomBusinessJustificationNotification,

        [Parameter()]
        [System.UInt32]
        $DailyBandwidthLimitInMB,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DLPAppGroups,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DLPNetworkShareGroups,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DLPPrinterGroups,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DLPRemovableMediaGroups,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $EvidenceStoreSettings,

        [Parameter()]
        [System.Boolean]
        $FileCopiedToCloudFullUrlEnabled,

        [Parameter()]
        [System.Boolean]
        $IncludePredefinedUnallowedBluetoothApps,

        [Parameter()]
        [System.Boolean]
        $MacDefaultPathExclusionsEnabled,

        [Parameter()]
        [System.String[]]
        $MacPathExclusion,

        [Parameter()]
        [System.Boolean]
        $NetworkPathEnforcementEnabled,

        [Parameter()]
        [System.String]
        $NetworkPathExclusion,

        [Parameter()]
        [System.String[]]
        $PathExclusion,

        [Parameter()]
        [System.Boolean]
        $serverDlpEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $SiteGroups,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $UnallowedApp,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $UnallowedCloudSyncApp,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $UnallowedBluetoothApp,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $UnallowedBrowser,

        [Parameter()]
        [System.String[]]
        $VPNSettings,

        [Parameter()]
        [System.Boolean]
        $EnableLabelCoauth,

        [Parameter()]
        [System.Boolean]
        $EnableSpoAipMigration,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $QuarantineParameters,

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    New-M365DSCConnection -Workload 'SecurityComplianceCenter' `
        -InboundParameters $PSBoundParameters | Out-Null

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullResult = $PSBoundParameters
    try
    {
        $instance = Get-PolicyConfig -ErrorAction Stop
        $EndpointDlpGlobalSettingsValue = ConvertFrom-Json $instance.EndpointDlpGlobalSettings
        $DlpPrinterGroupsObject = ConvertFrom-Json $instance.DlpPrinterGroups
        $DlpAppGroupsObject = ConvertFrom-Json $instance.DlpAppGroups
        $SiteGroupsObject = ConvertFrom-Json $instance.SiteGroups
        $DLPRemovableMediaGroupsObject = ConvertFrom-Json $instance.DLPRemovableMediaGroups
        $DlpNetworkShareGroupsObject = ConvertFrom-Json $instance.DlpNetworkShareGroups

        # AdvancedClassificationEnabled
        $AdvancedClassificationEnabledValue = $false # default value
        $valueToParse =($EndpointDlpGlobalSettingsValue | Where-Object { $_.Setting -eq 'AdvancedClassificationEnabled' }).Value
        if (-not [System.String]::IsNullOrEmpty($valueToParse))
        {
            $AdvancedClassificationEnabledValue = [Boolean]::Parse($valueToParse)
        }

        # BandwidthLimitEnabled
        $valueToParse = ($EndpointDlpGlobalSettingsValue | Where-Object { $_.Setting -eq 'BandwidthLimitEnabled' }).Value
        $BandwidthLimitEnabledValue = $true #default value
        if (-not [System.String]::IsNullOrEmpty($valueToParse))
        {
            $BandwidthLimitEnabledValue = [Boolean]::Parse($valueToParse)
        }

        # DailyBandwidthLimitInMB
        $DailyBandwidthLimitInMBValue = 1000 # default value
        $valueToParse = ($EndpointDlpGlobalSettingsValue | Where-Object { $_.Setting -eq 'DailyBandwidthLimitInMB' }).Value
        if (-not [System.String]::IsNullOrEmpty($valueToParse))
        {
            $DailyBandwidthLimitInMBValue = [UInt32]::Parse($valueToParse)
        }

        # PathExclusion
        $PathExclusionValue = @()
        $valueToParse = ($EndpointDlpGlobalSettingsValue | Where-Object { $_.Setting -eq 'PathExclusion' }).Value
        if (-not [System.String]::IsNullOrEmpty($valueToParse))
        {
            $PathExclusionValue = [Array]($valueToParse)
        }

        # MacPathExclusion
        $MacPathExclusionValue = @()
        $valueToParse = ($EndpointDlpGlobalSettingsValue | Where-Object { $_.Setting -eq 'MacPathExclusion' }).Value
        if (-not [System.String]::IsNullOrEmpty($valueToParse))
        {
            $MacPathExclusionValue = [Array]($valueToParse)
        }

        # MacDefaultPathExclusionsEnabled
        $MacDefaultPathExclusionsEnabledValue = $true # default value
        $valueToParse = ($EndpointDlpGlobalSettingsValue | Where-Object { $_.Setting -eq 'MacDefaultPathExclusionsEnabled' }).Value
        if (-not [System.String]::IsNullOrEmpty($valueToParse))
        {
            $MacDefaultPathExclusionsEnabledValue = [Boolean]::Parse($valueToParse)
        }

        #EvidenceStoreSettings
        $entry = $EndpointDlpGlobalSettingsValue | Where-Object { $_.Setting -eq 'EvidenceStoreSettings' }
        if ($null -ne $entry)
        {
            $entry = ConvertFrom-Json $entry.Value
            $EvidenceStoreSettingsValue = @{
                FileEvidenceIsEnabled = $entry.FileEvidenceIsEnabled
                NumberOfDaysToRetain  = [Uint32]$entry.NumberOfDaysToRetain
                StorageAccounts       = [Array]$entry.StorageAccounts
                Store                 = $entry.Store
            }
        }

        # NetworkPathEnforcementEnabled
        $valueToParse = ($EndpointDlpGlobalSettingsValue | Where-Object { $_.Setting -eq 'NetworkPathEnforcementEnabled' }).Value
        $NetworkPathEnforcementEnabledValue = $false # default value
        if (-not [System.String]::IsNullOrEmpty($valueToParse))
        {
            $NetworkPathEnforcementEnabledValue = [Boolean]::Parse($valueToParse)
        }

        # NetworkPathExclusion
        $NetworkPathExclusionValue = ($EndpointDlpGlobalSettingsValue | Where-Object { $_.Setting -eq 'NetworkPathExclusion' }).Value

        # DlpAppGroups
        $DlpAppGroupsValue = @()
        foreach ($group in $DlpAppGroupsObject)
        {
            $entry = @{
                Name        = $group.Name
                Id          = $group.Id
                Description = $group.Description
                Apps        = @()
            }

            foreach ($appEntry in $group.Apps)
            {
                $app = @{
                    ExecutableName = $appEntry.ExecutableName
                    Name           = $appEntry.Name
                    Quarantine     = [Boolean]::Parse($appEntry.Quarantine)
                }
                $entry.Apps += $app
            }
            $DlpAppGroupsValue += $entry
        }

        # UnallowedApp
        $entries = [Array]($EndpointDlpGlobalSettingsValue | Where-Object { $_.Setting -eq 'UnallowedApp' })
        $UnallowedAppValue = @()
        foreach ($entry in $entries)
        {
            $current = @{
                Value      = $entry.Value
                Executable = $entry.Executable
            }
            $UnallowedAppValue += $current
        }

        # UnallowedCloudSyncApp
        $entries = [Array]($EndpointDlpGlobalSettingsValue | Where-Object { $_.Setting -eq 'UnallowedCloudSyncApp' })
        $UnallowedCloudSyncAppValue = @()
        foreach ($entry in $entries)
        {
            $current = @{
                Value      = $entry.Value
                Executable = $entry.Executable
            }
            $UnallowedCloudSyncAppValue += $current
        }

        # IncludePredefinedUnallowedBluetoothApps
        $valueToParse = ($EndpointDlpGlobalSettingsValue | Where-Object { $_.Setting -eq 'IncludePredefinedUnallowedBluetoothApps' }).Value
        $IncludePredefinedUnallowedBluetoothAppsValue = $true # default value
        if (-not [System.String]::IsNullOrEMpty($valueToParse))
        {
            $IncludePredefinedUnallowedBluetoothAppsValue = [Boolean]::Parse($valueToParse)
        }

        # UnallowedBluetoothApp
        $entries = [Array]($EndpointDlpGlobalSettingsValue | Where-Object { $_.Setting -eq 'UnallowedBluetoothApp' })
        $UnallowedBluetoothAppValue = @()
        foreach ($entry in $entries)
        {
            $current = @{
                Value      = $entry.Value
                Executable = $entry.Executable
            }
            $UnallowedBluetoothAppValue += $current
        }

        # UnallowedBrowser
        $entries = [Array]($EndpointDlpGlobalSettingsValue | Where-Object { $_.Setting -eq 'UnallowedBrowser' })
        $UnallowedBrowserValue = @()
        foreach ($entry in $entries)
        {
            $current = @{
                Value      = $entry.Value
                Executable = $entry.Executable
            }
            $UnallowedBrowserValue += $current
        }

        # CloudAppMode
        $CloudAppModeValue = ($EndpointDlpGlobalSettingsValue | Where-Object { $_.Setting -eq 'CloudAppMode' }).Value

        # CloudAppRestrictionList
        $CloudAppRestrictionListValue = @()
        $valueToParse = ($EndpointDlpGlobalSettingsValue | Where-Object { $_.Setting -eq 'CloudAppRestrictionList' }).Value
        if (-not [System.String]::IsNullOrEmpty($valueToParse))
        {
            $CloudAppRestrictionListValue = [Array]($valueToParse)
        }

        # SiteGroups
        $SiteGroupsValue = @()
        foreach ($siteGroup in $SiteGroupsObject)
        {
            $entry = @{
                Id   = $siteGroup.Id
                Name = $siteGroup.Name
            }

            $addresses = @()
            foreach ($address in $siteGroup.Addresses)
            {
                $addresses += @{
                    MatchType    = $address.MatchType
                    Url          = $address.Url
                    AddressLower = $address.AddressLower
                    AddressUpper = $address.AddressUpper
                }
            }
            $entry.Add('Addresses', $addresses)
            $SiteGroupsValue += $entry
        }

        # CustomBusinessJustificationNotification
        $CustomBusinessJustificationNotificationValue = [Uint32]($EndpointDlpGlobalSettingsValue | Where-Object { $_.Setting -eq 'CustomBusinessJustificationNotification' }).Value

        if (-not [System.String]::IsNullOrEmpty($EndpointDlpGlobalSettingsValue.Setting))
        {
            $entities = $EndpointDlpGlobalSettingsValue | Where-Object -FilterScript { $_.Setting -eq 'BusinessJustificationList' }

            # BusinessJustificationList
            if ($null -ne $entities)
            {
                $entities = ConvertFrom-Json ($entities.value)
                $BusinessJustificationListValue = @()
                foreach ($entity in $entities)
                {
                    $current = @{
                        Id                = $entity.Id
                        Enable            = [Boolean]$entity.Enable
                        justificationText = $entity.justificationText
                    }
                    $BusinessJustificationListValue += $current
                }
            }

            # serverDlpEnabled
            $serverDlpEnabledValue = $false #default value
            $valueToParse = ($EndpointDlpGlobalSettingsValue | Where-Object { $_.Setting -eq 'serverDlpEnabled' }).Value
            if (-not [System.String]::IsNullOrEmpty($valueToParse))
            {
                $serverDlpEnabledValue = [Boolean]::Parse($valueToParse)
            }

            # AuditFileActivity
            $AuditFileActivityValue = $false # default value
            $valueToParse = ($EndpointDlpGlobalSettingsValue | Where-Object { $_.Setting -eq 'AuditFileActivity' }).Value
            if (-not [System.String]::IsNullOrEmpty($valueToParse))
            {
                $AuditFileActivityValue = [Boolean]::Parse($valueToParse)
            }

            # VPNSettings
            $entity = $EndpointDlpGlobalSettingsValue | Where-Object { $_.Setting -eq 'VPNSettings' }
            if ($null -ne $entity)
            {
                $entity = ConvertFrom-Json ($entity.value)
                $VPNSettingsValue = [Array]$entity.serverAddress
            }
        }
        else
        {
            $BusinessJustificationListValue = @()
            $serverDlpEnabledValue = $false
            $AuditFileActivityValue = $false
            $VPNSettingsValue = @()
        }

        # DlpPrinterGroups
        $DlpPrinterGroupsValue = @()
        foreach ($group in $DlpPrinterGroupsObject.groups)
        {
            $entry = @{
                groupName = $group.groupName
                groupId   = $group.groupId
            }

            $printers = @()
            foreach ($printer in $group.printers)
            {
                $current = @{
                    universalPrinter = [Boolean]$printer.universalPrinter
                    usbPrinter       = [Boolean]$printer.usbPrinter
                    usbPrinterId     = $printer.usbPrinterPID
                    name             = $printer.name
                    alias            = $printer.alias
                    usbPrinterVID    = $printer.usbPrinterVID
                    ipRange          = @{
                        fromAddress = $printer.ipRange.from
                        toAddress   = $printer.ipRange.to
                    }
                    corporatePrinter = [Boolean]$printer.CorporatePrinter
                    printToLocal     = [Boolean]$printer.printToLocal
                    printToFile      = [Boolean]$printer.printToFile
                }

                $printers += $current
            }
            $entry.Add('printers', $printers)
            $DlpPrinterGroupsValue += $entry
        }

        # DLPRemovableMediaGroups
        $DLPRemovableMediaGroupsValue = @()
        foreach ($group in $DLPRemovableMediaGroupsObject.groups)
        {
            $entry = @{
                groupName = $group.groupName
            }

            $medias = @()
            foreach ($media in $group.removableMedia)
            {
                $current = @{
                    deviceId          = $media.deviceId
                    removableMediaVID = $media.removableMediaVID
                    name              = $media.name
                    alias             = $media.alias
                    removableMediaPID = $media.removableMediaPID
                    instancePathId    = $media.instancePathId
                    serialNumberId    = $media.serialNumberId
                    hardwareId        = $media.hardwareId
                }
                $medias += $current
            }
            $entry.Add('removableMedia', $medias)

            $DLPRemovableMediaGroupsValue += $entry
        }

        # DlpNetworkShareGroups
        $DlpNetworkShareGroupsValue = @()
        foreach ($group in $DlpNetworkShareGroupsObject.groups)
        {
            $entry = @{
                groupName    = $group.groupName
                groupId      = $group.groupId
                networkPaths = [Array]$group.networkPaths
            }
            $DlpNetworkShareGroupsValue += $entry
        }

        $QuarantineParametersValue = $null
        if ($null -ne ($EndpointDlpGlobalSettingsValue | Where-Object { $_.Setting -eq 'QuarantineParameters' }))
        {
            $quarantineInfo = [Array]($EndpointDlpGlobalSettingsValue | Where-Object { $_.Setting -eq 'QuarantineParameters' }).Value
            $quarantineInfo = ConvertFrom-Json $quarantineInfo[0]
            $QuarantineParametersValue = @{
                EnableQuarantineForCloudSyncApps = $quarantineInfo.EnableQuarantineForCloudSyncApps
                QuarantinePath                   = $quarantineInfo.QuarantinePath
                MacQuarantinePath                = $quarantineInfo.MacQuarantinePath
                ShouldReplaceFile                = $quarantineInfo.ShouldReplaceFile
                FileReplacementText              = $quarantineInfo.FileReplacementText
            }
        }

        #EnableLabelCoauthValue
        $EnableLabelCoauthValue = $false # default value
        if (-not [System.String]::IsNullOrEmpty($instance.EnableLabelCoauth))
        {
            $EnableLabelCoauthValue = $instance.EnableLabelCoauth
        }

        #FileCopiedToCloudFullUrlEnabledValue
        $FileCopiedToCloudFullUrlEnabledValue = $false
        $valueToParse = ($EndpointDlpGlobalSettingsValue | Where-Object { $_.Setting -eq 'FileCopiedToCloudFullUrlEnabled' }).Value
        if (-not [System.String]::IsNullOrEmpty($valueToParse))
        {
            $FileCopiedToCloudFullUrlEnabledValue = [Boolean]::Parse($valueToParse)
        }

        $results = @{
            IsSingleInstance                        = 'Yes'
            AdvancedClassificationEnabled           = $AdvancedClassificationEnabledValue
            BandwidthLimitEnabled                   = $BandwidthLimitEnabledValue
            FileCopiedToCloudFullUrlEnabled         = $FileCopiedToCloudFullUrlEnabledValue
            DailyBandwidthLimitInMB                 = $DailyBandwidthLimitInMBValue
            PathExclusion                           = $PathExclusionValue
            MacPathExclusion                        = $MacPathExclusionValue
            MacDefaultPathExclusionsEnabled         = $MacDefaultPathExclusionsEnabledValue
            EvidenceStoreSettings                   = $EvidenceStoreSettingsValue
            NetworkPathEnforcementEnabled           = $NetworkPathEnforcementEnabledValue
            NetworkPathExclusion                    = $NetworkPathExclusionValue
            DLPAppGroups                            = $DlpAppGroupsValue
            UnallowedApp                            = $UnallowedAppValue
            UnallowedCloudSyncApp                   = $UnallowedCloudSyncAppValue
            IncludePredefinedUnallowedBluetoothApps = $IncludePredefinedUnallowedBluetoothAppsValue
            UnallowedBluetoothApp                   = $UnallowedBluetoothAppValue
            UnallowedBrowser                        = $UnallowedBrowserValue
            CloudAppMode                            = $CloudAppModeValue
            CloudAppRestrictionList                 = $CloudAppRestrictionListValue
            SiteGroups                              = $SiteGroupsValue
            CustomBusinessJustificationNotification = $CustomBusinessJustificationNotificationValue
            BusinessJustificationList               = $BusinessJustificationListValue
            ServerDlpEnabled                        = $serverDlpEnabledValue
            AuditFileActivity                       = $AuditFileActivityValue
            DLPPrinterGroups                        = $DlpPrinterGroupsValue
            DLPRemovableMediaGroups                 = $DLPRemovableMediaGroupsValue
            DLPNetworkShareGroups                   = $DlpNetworkShareGroupsValue
            VPNSettings                             = $VPNSettingsValue
            EnableLabelCoauth                       = $EnableLabelCoauthValue
            EnableSpoAipMigration                   = $instance.EnableSpoAipMigration
            QuarantineParameters                    = $QuarantineParametersValue
            Credential                              = $Credential
            ApplicationId                           = $ApplicationId
            TenantId                                = $TenantId
            CertificateThumbprint                   = $CertificateThumbprint
            ManagedIdentity                         = $ManagedIdentity.IsPresent
            AccessTokens                            = $AccessTokens
        }
        return [System.Collections.Hashtable] $results
    }
    catch
    {
        Write-Verbose -Message $_
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $nullResult
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $AdvancedClassificationEnabled,

        [Parameter()]
        [System.Boolean]
        $AuditFileActivity,

        [Parameter()]
        [System.Boolean]
        $BandwidthLimitEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $BusinessJustificationList,

        [Parameter()]
        [System.String]
        $CloudAppMode,

        [Parameter()]
        [System.String[]]
        $CloudAppRestrictionList,

        [Parameter()]
        [System.UInt32]
        $CustomBusinessJustificationNotification,

        [Parameter()]
        [System.UInt32]
        $DailyBandwidthLimitInMB,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DLPAppGroups,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DLPNetworkShareGroups,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DLPPrinterGroups,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DLPRemovableMediaGroups,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $EvidenceStoreSettings,

        [Parameter()]
        [System.Boolean]
        $FileCopiedToCloudFullUrlEnabled,

        [Parameter()]
        [System.Boolean]
        $IncludePredefinedUnallowedBluetoothApps,

        [Parameter()]
        [System.Boolean]
        $MacDefaultPathExclusionsEnabled,

        [Parameter()]
        [System.String[]]
        $MacPathExclusion,

        [Parameter()]
        [System.Boolean]
        $NetworkPathEnforcementEnabled,

        [Parameter()]
        [System.String]
        $NetworkPathExclusion,

        [Parameter()]
        [System.String[]]
        $PathExclusion,

        [Parameter()]
        [System.Boolean]
        $serverDlpEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $SiteGroups,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $UnallowedApp,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $UnallowedCloudSyncApp,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $UnallowedBluetoothApp,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $UnallowedBrowser,

        [Parameter()]
        [System.String[]]
        $VPNSettings,

        [Parameter()]
        [System.Boolean]
        $EnableLabelCoauth,

        [Parameter()]
        [System.Boolean]
        $EnableSpoAipMigration,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $QuarantineParameters,

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    New-M365DSCConnection -Workload 'SecurityComplianceCenter' `
        -InboundParameters $PSBoundParameters | Out-Null

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $SiteGroupsValue = @()
    foreach ($site in $SiteGroups)
    {
        $entry = @{
            Name        = $site.Name
            Description = $site.Description
        }

        $addressesValue = @()
        foreach ($address in $site.Addresses)
        {
            $addressesValue += @{
                MatchType    = $address.MatchType
                Url          = $address.Url
                AddressLower = $address.AddressLower
                AddressUpper = $address.AddressUpper
            }
        }

        $entry.Add('Addresses', (ConvertTo-Json $addressesValue -Compress -Depth 10))
        $SiteGroupsValue += $entry
    }

    $EndpointDlpGlobalSettingsValue = @()
    if ($null -ne $AdvancedClassificationEnabled)
    {
        $EndpointDlpGlobalSettingsValue += @{
            Setting = 'AdvancedClassificationEnabled'
            Value   = "$($AdvancedClassificationEnabled.ToString().ToLower())"
        }
    }

    if ($null -ne $BandwidthLimitEnabled)
    {
        $EndpointDlpGlobalSettingsValue += @{
            Setting = 'BandwidthLimitEnabled'
            Value   = "$($BandwidthLimitEnabled.ToString().ToLower())"
        }
    }

    if ($null -ne $DailyBandwidthLimitInMB -and $BandwidthLimitEnabled)
    {
        $EndpointDlpGlobalSettingsValue += @{
            Setting = 'DailyBandwidthLimitInMB'
            Value   = "$($DailyBandwidthLimitInMB.ToString().ToLower())"
        }
    }

    if ($null -ne $EvidenceStoreSettings)
    {
        $entry += @{
            Setting = 'EvidenceStoreSettings'
            Value   = @{
                FileEvidenceIsEnabled = $EvidenceStoreSettings.FileEvidenceIsEnabled
                Store                 = $EvidenceStoreSettings.Store
                NumberOfDaysToRetain  = $EvidenceStoreSettings.NumberOfDaysToRetain
            }
        }

        $StorageAccountsValue = @()
        foreach ($storageAccount in $EvidenceStoreSettings.StorageAccounts)
        {
            $StorageAccountsValue += @{
                Name    = $storageAccount.Name
                BlobUri = $storageAccount.BlobUri
            }
        }
        $entry.Value.Add('StorageAccounts', $StorageAccountsValue)
        $entry.Value = ConvertTo-Json $entry.Value -Depth 10 -Compress

        $EndpointDlpGlobalSettingsValue += $entry
    }

    if ($null -ne $MacDefaultPathExclusionsEnabled)
    {
        $EndpointDlpGlobalSettingsValue += @{
            Setting = 'MacDefaultPathExclusionsEnabled'
            Value   = "$($MacDefaultPathExclusionsEnabled.ToString().ToLower())"
        }
    }

    foreach ($path in $PathExclusion)
    {
        $EndpointDlpGlobalSettingsValue += @{
            Setting = 'PathExclusion'
            Value   = "$($path.ToString())"
        }
    }

    foreach ($path in $MacPathExclusion)
    {
        $EndpointDlpGlobalSettingsValue += @{
            Setting = 'MacPathExclusion'
            Value   = "$($path.ToString())"
        }
    }

    foreach ($app in $UnallowedApp)
    {
        $EndpointDlpGlobalSettingsValue += @{
            Setting    = 'UnallowedApp'
            Value      = "$($app.Value.ToString())"
            Executable = "$($app.Executable.ToString())"
        }
    }

    foreach ($app in $UnallowedCloudSyncApp)
    {
        $EndpointDlpGlobalSettingsValue += @{
            Setting    = 'UnallowedCloudSyncApp'
            Value      = "$($app.Value.ToString())"
            Executable = "$($app.Executable.ToString())"
        }
    }

    if ($null -ne $NetworkPathEnforcementEnabled)
    {
        $EndpointDlpGlobalSettingsValue += @{
            Setting = 'NetworkPathEnforcementEnabled'
            Value   = "$($NetworkPathEnforcementEnabled.ToString().ToLower())"
        }
    }

    if ($null -ne $NetworkPathExclusion)
    {
        $EndpointDlpGlobalSettingsValue += @{
            Setting = 'NetworkPathExclusion'
            Value   = "$($NetworkPathExclusion.ToString())"
        }
    }

    if ($null -ne $QuarantineParameters)
    {
        $entry = @{
            Setting = 'QuarantineParameters'
            Value   = @{
                EnableQuarantineForCloudSyncApps = $QuarantineParameters.EnableQuarantineForCloudSyncApps
                QuarantinePath                   = $QuarantineParameters.QuarantinePath
                MacQuarantinePath                = $QuarantineParameters.MacQuarantinePath
                ShouldReplaceFile                = $QuarantineParameters.ShouldReplaceFile
                FileReplacementText              = $QuarantineParameters.FileReplacementText
            }
        }
        $entry.Value = (ConvertTo-Json $entry.Value -Depth 10 -Compress)
        $EndpointDlpGlobalSettingsValue += $entry
    }

    if ($null -ne $IncludePredefinedUnallowedBluetoothApps)
    {
        $EndpointDlpGlobalSettingsValue += @{
            Setting = 'IncludePredefinedUnallowedBluetoothApps'
            Value   = "$($IncludePredefinedUnallowedBluetoothApps.ToString())"
        }
    }

    foreach ($app in  $UnallowedBluetoothApp)
    {
        $EndpointDlpGlobalSettingsValue += @{
            Setting    = 'UnallowedBluetoothApp'
            Value      = "$($app.Value.ToString())"
            Executable = "$($app.Executable.ToString())"
        }
    }

    foreach ($app in  $UnallowedBrowser)
    {
        $EndpointDlpGlobalSettingsValue += @{
            Setting    = 'UnallowedBrowser'
            Value      = "$($app.Value.ToString())"
            Executable = "$($app.Executable.ToString())"
        }
    }

    foreach ($domain in  $CloudAppRestrictionList)
    {
        $EndpointDlpGlobalSettingsValue += @{
            Setting = 'CloudAppRestrictionList'
            Value   = "$($domain.ToString())"
        }
    }

    if (-not [System.String]::IsNullOrEmpty($CloudAppMode))
    {
        $EndpointDlpGlobalSettingsValue += @{
            Setting = 'CloudAppMode'
            Value   = "$($CloudAppMode.ToString())"
        }
    }

    if ($null -ne $CustomBusinessJustificationNotification)
    {
        $EndpointDlpGlobalSettingsValue += @{
            Setting = 'CustomBusinessJustificationNotification'
            Value   = "$($CustomBusinessJustificationNotification.ToString())"
        }
    }

    if ($null -ne $BusinessJustificationList)
    {
        $valueEntry = @()
        foreach ($justification in $BusinessJustificationList)
        {
            $valueEntry += @{
                Id                = $justification.Id
                Enable            = $justification.Enable
                justificationText = @($justification.justificationText)
            }
        }

        $entry = @{
            Setting = 'BusinessJustificationList'
            Value   = (ConvertTo-Json $valueEntry -Depth 10 -Compress)
        }
        $EndpointDlpGlobalSettingsValue += $entry
    }

    if ($null -ne $VPNSettings)
    {
        $entry = @{
            Setting = 'VPNSettings'
            Value   = @{
                serverAddress = @()
            }
        }
        foreach ($vpnAddress in $VPNSettings)
        {
            $entry.Value.serverAddress += $vpnAddress
        }
        $EndpointDlpGlobalSettingsValue += $entry
    }

    if ($null -ne $serverDlpEnabled)
    {
        $EndpointDlpGlobalSettingsValue += @{
            Setting = 'serverDlpEnabled'
            Value   = "$($serverDlpEnabled.ToString().ToLower())"
        }
    }

    if ($null -ne $AuditFileActivity)
    {
        $EndpointDlpGlobalSettingsValue += @{
            Setting = 'AuditFileActivity'
            Value   = "$($AuditFileActivity.ToString().ToLower())"
        }
    }

    $DLPAppGroupsValue = @()
    foreach ($group in $DLPAppGroups)
    {
        $entry = @{
            Name        = "$($group.Name.ToString())"
            Description = "$($group.Description.ToString())"
        }

        $appsValues = @()
        foreach ($app in $group.Apps)
        {
            $appsValues += @{
                Name           = $app.Name
                ExecutableName = $app.ExecutableName
                Quarantine     = $app.Quarantine
            }
        }
        $entry.Add('Apps', (ConvertTo-Json $appsValues -Depth 10 -Compress))
        $DLPAppGroupsValue += $entry
    }

    $DlpPrinterGroupsValue = @{
        groups = @()
    }
    $groupCount = 0
    foreach ($group in $DLPPrinterGroups)
    {
        $entry = @{
            groupName = "$($group.groupName.ToString())"
            printers  = @()
        }

        foreach ($printer in $group.printers)
        {
            $entry.printers += @{
                alias            = $printer.alias
                name             = $printer.name
                usbPrinterPID    = $printer.usbPrinterId
                usbPrinterVID    = $printer.usbPrinterVID
                universalPrinter = "$($printer.universalPrinter.Tostring().ToLower())"
                corporatePrinter = "$($printer.corporatePrinter.Tostring().ToLower())"
                printToFile      = "$($printer.printToFile.Tostring().ToLower())"
                printToLocal     = "$($printer.printToLocal.Tostring().ToLower())"
                ipRange          = @(
                    @{
                        from = $printer.ipRange.fromAddress
                        to   = $printer.ipRange.toAddress
                    }
                )
            }
        }
        $DlpPrinterGroupsValue.groups += $entry
        $groupCount++
    }
    if ($groupCount -eq 0)
    {
        $DlpPrinterGroupsValue = $null
    }

    $DLPRemovableMediaGroupsValue = @{
        groups = @()
    }
    $groupCount = 0
    foreach ($group in $DLPRemovableMediaGroups)
    {
        $entry = @{
            groupName      = $group.groupName
            removableMedia = @(
            )
        }

        foreach ($media in $group.removableMedia)
        {
            $entry.removableMedia += @{
                alias             = $media.alias
                name              = $media.name
                removableMediaPID = $media.removableMediaPID
                removableMediaVID = $media.removableMediaVID
                serialNumberId    = $media.serialNumberId
                deviceId          = $media.deviceId
                instancePathId    = $media.instancePathId
                hardwareId        = $media.hardwareId
            }
        }
        $DLPRemovableMediaGroupsValue.groups += $entry
        $groupCount++
    }
    if ($groupCount -eq 0)
    {
        $DLPRemovableMediaGroupsValue = $null
    }

    $params = @{
        SiteGroups                = $SiteGroupsValue
        EnableLabelCoauth         = $EnableLabelCoauth
        DlpAppGroups              = $DLPAppGroupsValue
        DlpPrinterGroups          = ConvertTo-Json $DlpPrinterGroupsValue -Depth 10 -Compress
        DLPRemovableMediaGroups   = ConvertTo-Json $DLPRemovableMediaGroupsValue -Depth 10 -Compress
        EndpointDlpGlobalSettings = $EndpointDlpGlobalSettingsValue
    }
    $CurrentPolicyConfig = Get-TargetResource @PSBoundParameters
    if ($EnableSpoAipMigration -ne $CurrentPolicyConfig.EnableSpoAipMigration)
    {
        $params.Add("EnableSpoAipMigration", $EnableSpoAipMigration)
    }
    Write-Verbose -Message "Updating policy config with values:`r`n$(Convert-M365DscHashtableToString -Hashtable $params)"
    Set-PolicyConfig @params
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $AdvancedClassificationEnabled,

        [Parameter()]
        [System.Boolean]
        $AuditFileActivity,

        [Parameter()]
        [System.Boolean]
        $BandwidthLimitEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $BusinessJustificationList,

        [Parameter()]
        [System.String]
        $CloudAppMode,

        [Parameter()]
        [System.String[]]
        $CloudAppRestrictionList,

        [Parameter()]
        [System.UInt32]
        $CustomBusinessJustificationNotification,

        [Parameter()]
        [System.UInt32]
        $DailyBandwidthLimitInMB,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DLPAppGroups,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DLPNetworkShareGroups,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DLPPrinterGroups,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DLPRemovableMediaGroups,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $EvidenceStoreSettings,

        [Parameter()]
        [System.Boolean]
        $FileCopiedToCloudFullUrlEnabled,

        [Parameter()]
        [System.Boolean]
        $IncludePredefinedUnallowedBluetoothApps,

        [Parameter()]
        [System.Boolean]
        $MacDefaultPathExclusionsEnabled,

        [Parameter()]
        [System.String[]]
        $MacPathExclusion,

        [Parameter()]
        [System.Boolean]
        $NetworkPathEnforcementEnabled,

        [Parameter()]
        [System.String]
        $NetworkPathExclusion,

        [Parameter()]
        [System.String[]]
        $PathExclusion,

        [Parameter()]
        [System.Boolean]
        $serverDlpEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $SiteGroups,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $UnallowedApp,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $UnallowedCloudSyncApp,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $UnallowedBluetoothApp,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $UnallowedBrowser,

        [Parameter()]
        [System.String[]]
        $VPNSettings,

        [Parameter()]
        [System.Boolean]
        $EnableLabelCoauth,

        [Parameter()]
        [System.Boolean]
        $EnableSpoAipMigration,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $QuarantineParameters,

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).Clone()

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    #Compare Cim instances
    $testResult = $true
    $testTargetResource = $true
    foreach ($key in $PSBoundParameters.Keys)
    {
        $source = $PSBoundParameters.$key
        $target = $CurrentValues.$key
        if ($null -ne $source -and $source.GetType().Name -like '*CimInstance*')
        {
            $testResult = Compare-M365DSCComplexObject `
                -Source ($source) `
                -Target ($target)

            if (-not $testResult)
            {
                $testTargetResource = $false
                break
            }

            $ValuesToCheck.Remove($key) | Out-Null
        }
    }

    $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    if (-not $testResult)
    {
        $testTargetResource = $false
    }
    Write-Verbose -Message "Test-TargetResource returned $testTargetResource"
    return $testTargetResource
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

    $ConnectionMode = New-M365DSCConnection -Workload 'SecurityComplianceCenter' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        $Script:ExportMode = $true
        $params = @{
            IsSingleInstance      = 'Yes'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
        }
        if ($null -ne $Global:M365DSCExportResourceInstancesCount)
        {
            $Global:M365DSCExportResourceInstancesCount++
        }
        $Results = Get-TargetResource @Params
        if ($null -ne $Results.BusinessJustificationList -and $Results.BusinessJustificationList.Length -gt 0)
        {
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                -ComplexObject $Results.BusinessJustificationList `
                -CIMInstanceName 'PolicyConfigBusinessJustificationList'
            if (-not [String]::IsNullOrEmpty($complexTypeStringResult))
            {
                $Results.BusinessJustificationList = $complexTypeStringResult
            }
            else
            {
                $Results.Remove('BusinessJustificationList') | Out-Null            }
        }

        if ($null -ne $Results.DLPAppGroups -and $Results.DLPAppGroups.Length -gt 0)
        {
            $complexTypeMapping = @(
                @{
                    Name            = 'DLPAppGroups'
                    CimInstanceName = 'PolicyConfigDLPAppGroups'
                },
                @{
                    Name            = 'Apps'
                    CimInstanceName = 'PolicyConfigDLPApp'
                    IsArray         = $true
                }
            )

            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                -ComplexObject $Results.DLPAppGroups `
                -CIMInstanceName 'PolicyConfigDLPAppGroups' `
                -ComplexTypeMapping $complexTypeMapping
            if (-not [String]::IsNullOrEmpty($complexTypeStringResult))
            {
                $Results.DLPAppGroups = $complexTypeStringResult
            }
            else
            {
                $Results.Remove('DLPAppGroups') | Out-Null
            }
        }

        if ($null -ne $Results.DLPNetworkShareGroups -and $Results.DLPNetworkShareGroups.Length -gt 0)
        {
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                -ComplexObject $Results.DLPNetworkShareGroups `
                -CIMInstanceName 'PolicyConfigDLPNetworkShareGroups'
            if (-not [String]::IsNullOrEmpty($complexTypeStringResult))
            {
                $Results.DLPNetworkShareGroups = $complexTypeStringResult
            }
            else
            {
                $Results.Remove('DLPNetworkShareGroups') | Out-Null
            }
        }

        if ($null -ne $Results.DLPPrinterGroups -and $Results.DLPPrinterGroups.Length -gt 0)
        {
            $complexTypeMapping = @(
                @{
                    Name            = 'DLPPrinterGroups'
                    CimInstanceName = 'PolicyConfigDLPPrinterGroups'
                },
                @{
                    Name            = 'printers'
                    CimInstanceName = 'PolicyConfigPrinter'
                    IsArray         = $true
                },
                @{
                    Name            = 'ipRange'
                    CimInstanceName = 'PolicyConfigIPRange'
                }
            )
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                -ComplexObject $Results.DLPPrinterGroups `
                -CIMInstanceName 'PolicyConfigDLPPrinterGroups' `
                -ComplexTypeMapping $complexTypeMapping
            if (-not [String]::IsNullOrEmpty($complexTypeStringResult))
            {
                $Results.DLPPrinterGroups = $complexTypeStringResult
            }
            else
            {
                $Results.Remove('DLPPrinterGroups') | Out-Null
            }
        }

        if ($null -ne $Results.DLPRemovableMediaGroups -and $Results.DLPRemovableMediaGroups.Length -gt 0)
        {
            $complexTypeMapping = @(
                @{
                    Name            = 'DLPRemovableMediaGroups'
                    CimInstanceName = 'PolicyConfigDLPRemovableMediaGroups'
                },
                @{
                    Name            = 'removableMedia'
                    CimInstanceName = 'PolicyConfigRemovableMedia'
                    IsArray         = $true
                }
            )

            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                -ComplexObject $Results.DLPRemovableMediaGroups `
                -CIMInstanceName 'PolicyConfigDLPRemovableMediaGroups' `
                -ComplexTypeMapping $complexTypeMapping
            if (-not [String]::IsNullOrEmpty($complexTypeStringResult))
            {
                $Results.DLPRemovableMediaGroups = $complexTypeStringResult
            }
            else
            {
                $Results.Remove('DLPRemovableMediaGroups') | Out-Null
            }
        }

        if ($null -ne $Results.EvidenceStoreSettings)
        {
            $complexTypeMapping = @(
                @{
                    Name            = 'EvidenceStoreSettings'
                    CimInstanceName = 'PolicyConfigEvidenceStoreSettings'
                },
                @{
                    Name            = 'StorageAccounts'
                    CimInstanceName = 'PolicyConfigStorageAccount'
                    IsArray         = $true
                }
            )

            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                -ComplexObject $Results.EvidenceStoreSettings `
                -CIMInstanceName 'PolicyConfigEvidenceStoreSettings' `
                -ComplexTypeMapping $complexTypeMapping
            if (-not [String]::IsNullOrEmpty($complexTypeStringResult))
            {
                $Results.EvidenceStoreSettings = $complexTypeStringResult
            }
            else
            {
                $Results.Remove('EvidenceStoreSettings') | Out-Null
            }
        }

        if ($null -ne $Results.SiteGroups -and $Results.SiteGroups.Length -gt 0)
        {
            $complexTypeMapping = @(
                @{
                    Name            = 'SiteGroups'
                    CimInstanceName = 'PolicyConfigDLPSiteGroups'
                },
                @{
                    Name            = 'Addresses'
                    CimInstanceName = 'PolicyConfigSiteGroupAddress'
                    IsArray         = $true
                }
            )

            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                -ComplexObject $Results.SiteGroups `
                -CIMInstanceName 'PolicyConfigDLPSiteGroups' `
                -ComplexTypeMapping $complexTypeMapping
            if (-not [String]::IsNullOrEmpty($complexTypeStringResult))
            {
                $Results.SiteGroups = $complexTypeStringResult
            }
            else
            {
                $Results.Remove('SiteGroups') | Out-Null
            }
        }

        if ($null -ne $Results.UnallowedApp -and -not [System.String]::IsNullOrEmpty($Results.UnallowedApp))
        {
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                -ComplexObject $Results.UnallowedApp `
                -CIMInstanceName 'PolicyConfigApp'
            if (-not [String]::IsNullOrEmpty($complexTypeStringResult))
            {
                $Results.UnallowedApp = $complexTypeStringResult
            }
            else
            {
                $Results.Remove('UnallowedApp') | Out-Null
            }
        }

        if ($null -ne $Results.UnallowedCloudSyncApp -and -not [System.String]::IsNullOrEmpty($Results.UnallowedCloudSyncApp))
        {
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                -ComplexObject $Results.UnallowedCloudSyncApp `
                -CIMInstanceName 'PolicyConfigApp'
            if (-not [String]::IsNullOrEmpty($complexTypeStringResult))
            {
                $Results.UnallowedCloudSyncApp = $complexTypeStringResult
            }
            else
            {
                $Results.Remove('UnallowedCloudSyncApp') | Out-Null
            }
        }

        if ($null -ne $Results.UnallowedBluetoothApp -and -not [System.String]::IsNullOrEmpty($Results.UnallowedBluetoothApp))
        {
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                -ComplexObject $Results.UnallowedBluetoothApp `
                -CIMInstanceName 'PolicyConfigApp'
            if (-not [String]::IsNullOrEmpty($complexTypeStringResult))
            {
                $Results.UnallowedBluetoothApp = $complexTypeStringResult
            }
            else
            {
                $Results.Remove('UnallowedBluetoothApp') | Out-Null
            }
        }

        if ($null -ne $Results.UnallowedBrowser -and -not [System.String]::IsNullOrEmpty($Results.UnallowedBrowser))
        {
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                -ComplexObject $Results.UnallowedBrowser `
                -CIMInstanceName 'PolicyConfigApp'
            if (-not [String]::IsNullOrEmpty($complexTypeStringResult))
            {
                $Results.UnallowedBrowser = $complexTypeStringResult
            }
            else
            {
                $Results.Remove('UnallowedBrowser') | Out-Null
            }
        }

        if ($null -ne $Results.QuarantineParameters -and -not [System.String]::IsNullOrEmpty($Results.QuarantineParameters))
        {
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                -ComplexObject $Results.QuarantineParameters `
                -CIMInstanceName 'PolicyConfigQuarantineParameters'
            if (-not [String]::IsNullOrEmpty($complexTypeStringResult))
            {
                $Results.QuarantineParameters = $complexTypeStringResult
            }
            else
            {
                $Results.Remove('QuarantineParameters') | Out-Null
            }
        }

        $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
            -ConnectionMode $ConnectionMode `
            -ModulePath $PSScriptRoot `
            -Results $Results `
            -Credential $Credential `
            -NoEscape @('QuarantineParameters', 'BusinessJustificationList', 'DLPAppGroups', 'DLPNetworkShareGroups',
                'DLPPrinterGroups', 'DLPRemovableMediaGroups', 'SiteGroups', 'UnallowedApp', 'UnallowedCloudSyncApp',
                'UnallowedBluetoothApp', 'UnallowedBrowser', 'EvidenceStoreSettings')

        $dscContent += $currentDSCBlock
        Save-M365DSCPartialExport -Content $currentDSCBlock `
            -FileName $Global:PartialExportFileName
        Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite

        return $dscContent
    }
    catch
    {
        Write-M365DSCHost -Message $Global:M365DSCEmojiRedX -CommitWrite

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
