function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $IsSingleInstance = 'Yes',

        [Parameter()]
        [System.Boolean]
        $DLPUserRiskSync,

        [Parameter()]
        [System.Boolean]
        $OptInIRMDataExport,

        [Parameter()]
        [System.Boolean]
        $RaiseAuditAlert,

        ##TODO - Add the list of Parameters

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

    ##TODO - Replace the workload by the one associated to your resource
    New-M365DSCConnection -Workload 'Workload' `
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
    $nullResult.Ensure = 'Absent'
    try
    {
        $instance = Get-InsiderRiskPolicy -ErrorAction Stop
        $tenantSettings = ConvertFrom-Json $instance.TenantSettings

        $results = @{
            IsSingleInstance                          = 'Yes'
            DLPUserRiskSync                           = [Boolean]$tenantSettings.FeatureSettings.DLPUserRiskSync
            OptInIRMDataExport                        = [Boolean]$tenantSettings.FeatureSettings.OptInIRMDataExport
            RaiseAuditAlert                           = [Boolean]$tenantSettings.FeatureSettings.RaiseAuditAlert
            FileVolCutoffLimits                       = $tenantSettings.IntelligentDetections.FileVolCutoffLimits
            AlertVolume                               = $tenantSettings.IntelligentDetections.AlertVolume
            AnomalyDetections                         = [Boolean]$tenantSettings.Indicators.AnomalyDetections
            CopyToPersonalCloud                       = [Boolean]$tenantSettings.Indicators.
            CopyToUSB                                 = [Boolean]$tenantSettings.Indicators.
            CumulativeExfiltrationDetector            = [Boolean]$tenantSettings.Indicators.
            EmailExternal                             = [Boolean]$tenantSettings.Indicators.
            EmployeeAccessedEmployeePatientData       = [Boolean]$tenantSettings.Indicators.
            EmployeeAccessedFamilyData                = [Boolean]$tenantSettings.Indicators.
            EmployeeAccessedHighVolumePatientData     = [Boolean]$tenantSettings.Indicators.
            EmployeeAccessedNeighbourData             = [Boolean]$tenantSettings.Indicators.
            EmployeeAccessedRestrictedData            = [Boolean]$tenantSettings.Indicators.
            EpoBrowseToChildAbuseSites                = [Boolean]$tenantSettings.Indicators.
            EpoBrowseToCriminalActivitySites          = [Boolean]$tenantSettings.Indicators.
            EpoBrowseToCultSites                      = [Boolean]$tenantSettings.Indicators.
            EpoBrowseToGamblingSites                  = [Boolean]$tenantSettings.Indicators.
            EpoBrowseToHackingSites                   = [Boolean]$tenantSettings.Indicators.
            EpoBrowseToHateIntoleranceSites           = [Boolean]$tenantSettings.Indicators.
            EpoBrowseToIllegalSoftwareSites           = [Boolean]$tenantSettings.Indicators.
            EpoBrowseToKeyloggerSites                 = [Boolean]$tenantSettings.Indicators.
            EpoBrowseToLlmSites                       = [Boolean]$tenantSettings.Indicators.
            EpoBrowseToMalwareSites                   = [Boolean]$tenantSettings.Indicators.
            EpoBrowseToPhishingSites                  = [Boolean]$tenantSettings.Indicators.
            EpoBrowseToPornographySites               = [Boolean]$tenantSettings.Indicators.
            EpoBrowseToUnallowedDomain                = [Boolean]$tenantSettings.Indicators.
            EpoBrowseToViolenceSites                  = [Boolean]$tenantSettings.Indicators.
            EpoCopyToClipboardFromSensitiveFile       = [Boolean]$tenantSettings.Indicators.
            EpoCopyToNetworkShare                     = [Boolean]$tenantSettings.Indicators.
            EpoFileArchived                           = [Boolean]$tenantSettings.Indicators.
            EpoFileCopiedToRemoteDesktopSession       = [Boolean]$tenantSettings.Indicators.
            EpoFileDeleted                            = [Boolean]$tenantSettings.Indicators.
            EpoFileDownloadedFromBlacklistedDomain    = [Boolean]$tenantSettings.Indicators.
            EpoFileDownloadedFromEnterpriseDomain     = [Boolean]$tenantSettings.Indicators.
            EpoFileRenamed                            = [Boolean]$tenantSettings.Indicators.
            EpoFileStagedToCentralLocation            = [Boolean]$tenantSettings.Indicators.
            EpoHiddenFileCreated                      = [Boolean]$tenantSettings.Indicators.
            EpoRemovableMediaMount                    = [Boolean]$tenantSettings.Indicators.
            EpoSensitiveFileRead                      = [Boolean]$tenantSettings.Indicators.
            Mcas3rdPartyAppDownload                   = [Boolean]$tenantSettings.Indicators.
            Mcas3rdPartyAppFileDelete                 = [Boolean]$tenantSettings.Indicators.
            Mcas3rdPartyAppFileSharing                = [Boolean]$tenantSettings.Indicators.
            McasActivityFromInfrequentCountry         = [Boolean]$tenantSettings.Indicators.
            McasImpossibleTravel                      = [Boolean]$tenantSettings.Indicators.
            McasMultipleFailedLogins                  = [Boolean]$tenantSettings.Indicators.
            McasMultipleStorageDeletion               = [Boolean]$tenantSettings.Indicators.
            McasMultipleVMCreation                    = [Boolean]$tenantSettings.Indicators.
            McasMultipleVMDeletion                    = [Boolean]$tenantSettings.Indicators.
            McasSuspiciousAdminActivities             = [Boolean]$tenantSettings.Indicators.
            McasSuspiciousCloudCreation               = [Boolean]$tenantSettings.Indicators.
            McasSuspiciousCloudTrailLoggingChange     = [Boolean]$tenantSettings.Indicators.
            McasTerminatedEmployeeActivity            = [Boolean]$tenantSettings.Indicators.
            OdbDownload                               = [Boolean]$tenantSettings.Indicators.
            OdbSyncDownload                           = [Boolean]$tenantSettings.Indicators.
            PeerCumulativeExfiltrationDetector        = [Boolean]$tenantSettings.Indicators.
            PhysicalAccess                            = [Boolean]$tenantSettings.Indicators.
            PotentialHighImpactUser                   = [Boolean]$tenantSettings.Indicators.
            Print                                     = [Boolean]$tenantSettings.Indicators.
            PriorityUserGroupMember                   = [Boolean]$tenantSettings.Indicators.
            SecurityAlertDefenseEvasion               = [Boolean]$tenantSettings.Indicators.
            SecurityAlertUnwantedSoftware             = [Boolean]$tenantSettings.Indicators.
            SpoAccessRequest                          = [Boolean]$tenantSettings.Indicators.
            SpoApprovedAccess                         = [Boolean]$tenantSettings.Indicators.
            SpoDownload                               = [Boolean]$tenantSettings.Indicators.
            SpoDownloadV2                             = [Boolean]$tenantSettings.Indicators.
            SpoFileAccessed                           = [Boolean]$tenantSettings.Indicators.
            SpoFileDeleted                            = [Boolean]$tenantSettings.Indicators.SpoFileDeleted
            SpoFileDeletedFromFirstStageRecycleBin    = [Boolean]$tenantSettings.Indicators.SpoFileDeletedFromFirstStageRecycleBin
            SpoFileDeletedFromSecondStageRecycleBin   = [Boolean]$tenantSettings.Indicators.SpoFileDeletedFromSecondStageRecycleBin
            SpoFileLabelDowngraded                    = [Boolean]$tenantSettings.Indicators.SpoFileLabelDowngraded
            SpoFileLabelRemoved                       = [Boolean]$tenantSettings.Indicators.SpoFileLabelRemoved
            SpoFileSharing                            = [Boolean]$tenantSettings.Indicators.SpoFileSharing
            SpoFolderDeleted                          = [Boolean]$tenantSettings.Indicators.SpoFolderDeleted
            SpoFolderDeletedFromFirstStageRecycleBin  = [Boolean]$tenantSettings.Indicators.SpoFolderDeletedFromFirstStageRecycleBin
            SpoFolderDeletedFromSecondStageRecycleBin = [Boolean]$tenantSettings.Indicators.SpoFolderDeletedFromSecondStageRecycleBin
            SpoFolderSharing                          = [Boolean]$tenantSettings.Indicators.SpoFolderSharing
            SpoSiteExternalUserAdded                  = [Boolean]$tenantSettings.Indicators.SpoSiteExternalUserAdded
            SpoSiteInternalUserAdded                  = [Boolean]$tenantSettings.Indicators.SpoSiteInternalUserAdded
            SpoSiteLabelRemoved                       = [Boolean]$tenantSettings.Indicators.SpoSiteLabelRemoved
            SpoSiteSharing                            = [Boolean]$tenantSettings.Indicators.SpoSiteSharing
            SpoSyncDownload                           = [Boolean]$tenantSettings.Indicators.SpoSyncDownload
            TeamsChannelFileSharedExternal            = [Boolean]$tenantSettings.Indicators.TeamsChannelFileSharedExternal
            TeamsChannelMemberAddedExternal           = [Boolean]$tenantSettings.Indicators.TeamsChannelMemberAddedExternal
            TeamsChatFileSharedExternal               = [Boolean]$tenantSettings.Indicators.TeamsChatFileSharedExternal
            TeamsFileDownload                         = [Boolean]$tenantSettings.Indicators.TeamsFileDownload
            TeamsFolderSharedExternal                 = [Boolean]$tenantSettings.Indicators.TeamsFolderSharedExternal
            TeamsMemberAddedExternal                  = [Boolean]$tenantSettings.Indicators.TeamsMemberAddedExternal
            TeamsSensitiveMessage                     = [Boolean]$tenantSettings.Indicators.TeamsSensitiveMessage
            UserHistory                               = [Boolean]$tenantSettings.Indicators.UserHistory
            Credential                                = $Credential
            ApplicationId                             = $ApplicationId
            TenantId                                  = $TenantId
            CertificateThumbprint                     = $CertificateThumbprint
            ManagedIdentity                           = $ManagedIdentity.IsPresent
            AccessTokens                              = $AccessTokens
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
        ##TODO - Replace the PrimaryKey
        [Parameter(Mandatory = $true)]
        [System.String]
        $PrimaryKey,

        ##TODO - Add the list of Parameters

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

    $currentInstance = Get-TargetResource @PSBoundParameters

    $setParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    # CREATE
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        ##TODO - Replace by the New cmdlet for the resource
        New-Cmdlet @SetParameters
    }
    # UPDATE
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        ##TODO - Replace by the Update/Set cmdlet for the resource
        Set-cmdlet @SetParameters
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        ##TODO - Replace by the Remove cmdlet for the resource
        Remove-cmdlet @SetParameters
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        ##TODO - Replace the PrimaryKey
        [Parameter(Mandatory = $true)]
        [System.String]
        $PrimaryKey,

        ##TODO - Add the list of Parameters

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

    $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $testResult"

    return $testResult
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

    ##TODO - Replace workload
    $ConnectionMode = New-M365DSCConnection -Workload 'Workload' `
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
        ##TODO - Replace Get-Cmdlet by the cmdlet to retrieve all instances
        [array] $Script:exportedInstances = Get-Cmdlet -ErrorAction Stop

        $i = 1
        $dscContent = ''
        if ($Script:exportedInstances.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($config in $Script:exportedInstances)
        {
            $displayedKey = $config.Id
            Write-Host "    |---[$i/$($Script:exportedInstances.Count)] $displayedKey" -NoNewline
            $params = @{
                ##TODO - Specify the Primary Key
                #PrimaryKey            = $config.PrimaryKey
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Results = Get-TargetResource @Params
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
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
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

Export-ModuleMember -Function *-TargetResource
