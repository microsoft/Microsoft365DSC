Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneAppProtectionPolicyWindows10'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [ValidateSet('allApps','none')]
        [System.String]
        $AllowedInboundDataTransferSources,

        [Parameter()]
        [ValidateSet('anyDestinationAnySource','none')]
        [System.String]
        $AllowedOutboundClipboardSharingLevel,

        [Parameter()]
        [ValidateSet('allApps','none')]
        [System.String]
        $AllowedOutboundDataTransferDestinations,

        [Parameter()]
        [ValidateSet('block','wipe','warn','blockWhenSettingIsSupported')]
        [System.String]
        $AppActionIfUnableToAuthenticateUser,

        [Parameter()]
        [ValidateSet('notConfigured','secured','low','medium','high')]
        [System.String]
        $MaximumAllowedDeviceThreatLevel,

        [Parameter()]
        [System.String]
        $MaximumRequiredOsVersion,

        [Parameter()]
        [System.String]
        $MaximumWarningOsVersion,

        [Parameter()]
        [System.String]
        $MaximumWipeOsVersion,

        [Parameter()]
        [System.String]
        $MinimumRequiredAppVersion,

        [Parameter()]
        [System.String]
        $MinimumRequiredOsVersion,

        [Parameter()]
        [System.String]
        $MinimumRequiredSdkVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningAppVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningOsVersion,

        [Parameter()]
        [System.String]
        $MinimumWipeAppVersion,

        [Parameter()]
        [System.String]
        $MinimumWipeOsVersion,

        [Parameter()]
        [System.String]
        $MinimumWipeSdkVersion,

        [Parameter()]
        [ValidateSet('block','wipe','warn','blockWhenSettingIsSupported')]
        [System.String]
        $MobileThreatDefenseRemediationAction,

        [Parameter()]
        [System.String]
        $PeriodOfflineBeforeAccessCheck,

        [Parameter()]
        [System.String]
        $PeriodOfflineBeforeWipeIsEnforced,

        [Parameter()]
        [System.Boolean]
        $PrintBlocked,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter()]
        [System.String[]]
        $Apps,
        #endregion

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

    Write-Verbose -Message "Getting configuration for the Intune App Protection Policy for Windows10 with Id {$Id} and DisplayName {$DisplayName}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.DisplayName -ne $DisplayName)
        {

            $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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

            $nullResult = $PSBoundParameters
            $nullResult.Ensure = 'Absent'

            $getValue = $null

            #region resource generator code
            if (-not [System.String]::IsNullOrEmpty($Id))
            {
                $getValue = Get-MgBetaDeviceAppManagementWindowsManagedAppProtection -WindowsManagedAppProtectionId $Id -ErrorAction SilentlyContinue
            }

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune App Protection Policy for Windows10 with Id {$Id}"

                if (-not [System.String]::IsNullOrEmpty($DisplayName))
                {
                    $getValue = Get-MgBetaDeviceAppManagementWindowsManagedAppProtection `
                        -Filter "DisplayName eq '$($DisplayName -replace "'", "''")'" `
                        -ErrorAction SilentlyContinue
                }
            }
            #endregion
            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune App Protection Policy for Windows10 with DisplayName {$DisplayName}."
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune App Protection Policy for Windows10 with Id {$Id} and DisplayName {$DisplayName} was found"

        $policyApps = Get-MgBetaDeviceAppManagementWindowsManagedAppProtectionApp -WindowsManagedAppProtectionId $Id
        $appsArray = @()
        foreach ($app in $policyApps)
        {
            $appsArray += $app.MobileAppIdentifier.AdditionalProperties.windowsAppId
        }

        #region resource generator code
        $enumAllowedInboundDataTransferSources = $null
        if ($null -ne $getValue.allowedInboundDataTransferSources)
        {
            $enumAllowedInboundDataTransferSources = $getValue.allowedInboundDataTransferSources.ToString()
        }

        $enumAllowedOutboundClipboardSharingLevel = $null
        if ($null -ne $getValue.allowedOutboundClipboardSharingLevel)
        {
            $enumAllowedOutboundClipboardSharingLevel = $getValue.allowedOutboundClipboardSharingLevel.ToString()
        }

        $enumAllowedOutboundDataTransferDestinations = $null
        if ($null -ne $getValue.allowedOutboundDataTransferDestinations)
        {
            $enumAllowedOutboundDataTransferDestinations = $getValue.allowedOutboundDataTransferDestinations.ToString()
        }

        $enumAppActionIfUnableToAuthenticateUser = $null
        if ($null -ne $getValue.appActionIfUnableToAuthenticateUser)
        {
            $enumAppActionIfUnableToAuthenticateUser = $getValue.appActionIfUnableToAuthenticateUser.ToString()
        }

        $enumMaximumAllowedDeviceThreatLevel = $null
        if ($null -ne $getValue.maximumAllowedDeviceThreatLevel)
        {
            $enumMaximumAllowedDeviceThreatLevel = $getValue.maximumAllowedDeviceThreatLevel.ToString()
        }

        $enumMobileThreatDefenseRemediationAction = $null
        if ($null -ne $getValue.mobileThreatDefenseRemediationAction)
        {
            $enumMobileThreatDefenseRemediationAction = $getValue.mobileThreatDefenseRemediationAction.ToString()
        }
        #endregion

        $results = @{
            #region resource generator code
            AllowedInboundDataTransferSources       = $enumAllowedInboundDataTransferSources
            AllowedOutboundClipboardSharingLevel    = $enumAllowedOutboundClipboardSharingLevel
            AllowedOutboundDataTransferDestinations = $enumAllowedOutboundDataTransferDestinations
            AppActionIfUnableToAuthenticateUser     = $enumAppActionIfUnableToAuthenticateUser
            Apps                                    = $appsArray
            MaximumAllowedDeviceThreatLevel         = $enumMaximumAllowedDeviceThreatLevel
            MaximumRequiredOsVersion                = $getValue.maximumRequiredOsVersion
            MaximumWarningOsVersion                 = $getValue.maximumWarningOsVersion
            MaximumWipeOsVersion                    = $getValue.maximumWipeOsVersion
            MinimumRequiredAppVersion               = $getValue.minimumRequiredAppVersion
            MinimumRequiredOsVersion                = $getValue.minimumRequiredOsVersion
            MinimumRequiredSdkVersion               = $getValue.minimumRequiredSdkVersion
            MinimumWarningAppVersion                = $getValue.minimumWarningAppVersion
            MinimumWarningOsVersion                 = $getValue.minimumWarningOsVersion
            MinimumWipeAppVersion                   = $getValue.minimumWipeAppVersion
            MinimumWipeOsVersion                    = $getValue.minimumWipeOsVersion
            MinimumWipeSdkVersion                   = $getValue.minimumWipeSdkVersion
            MobileThreatDefenseRemediationAction    = $enumMobileThreatDefenseRemediationAction
            PeriodOfflineBeforeAccessCheck          = [System.Xml.XmlConvert]::ToString($getValue.periodOfflineBeforeAccessCheck)
            PeriodOfflineBeforeWipeIsEnforced       = [System.Xml.XmlConvert]::ToString($getValue.periodOfflineBeforeWipeIsEnforced)
            PrintBlocked                            = $getValue.printBlocked
            Description                             = $getValue.Description
            DisplayName                             = $getValue.DisplayName
            RoleScopeTagIds                         = $getValue.RoleScopeTagIds
            Id                                      = $getValue.Id
            Ensure                                  = 'Present'
            Credential                              = $Credential
            ApplicationId                           = $ApplicationId
            TenantId                                = $TenantId
            ApplicationSecret                       = $ApplicationSecret
            CertificateThumbprint                   = $CertificateThumbprint
            ManagedIdentity                         = $ManagedIdentity.IsPresent
            #endregion
        }
        $assignmentsValues = Get-MgBetaDeviceAppManagementWindowsManagedAppProtectionAssignment -WindowsManagedAppProtectionId $Id
        $assignmentResult = @()
        if ($assignmentsValues.Count -gt 0)
        {
            $assignmentResult += ConvertFrom-IntunePolicyAssignment -Assignments $assignmentsValues -IncludeDeviceFilter $true
        }
        $results.Add('Assignments', $assignmentResult)

        return $results
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        #region resource generator code
        [Parameter()]
        [ValidateSet('allApps','none')]
        [System.String]
        $AllowedInboundDataTransferSources,

        [Parameter()]
        [ValidateSet('anyDestinationAnySource','none')]
        [System.String]
        $AllowedOutboundClipboardSharingLevel,

        [Parameter()]
        [ValidateSet('allApps','none')]
        [System.String]
        $AllowedOutboundDataTransferDestinations,

        [Parameter()]
        [ValidateSet('block','wipe','warn','blockWhenSettingIsSupported')]
        [System.String]
        $AppActionIfUnableToAuthenticateUser,

        [Parameter()]
        [ValidateSet('notConfigured','secured','low','medium','high')]
        [System.String]
        $MaximumAllowedDeviceThreatLevel,

        [Parameter()]
        [System.String]
        $MaximumRequiredOsVersion,

        [Parameter()]
        [System.String]
        $MaximumWarningOsVersion,

        [Parameter()]
        [System.String]
        $MaximumWipeOsVersion,

        [Parameter()]
        [System.String]
        $MinimumRequiredAppVersion,

        [Parameter()]
        [System.String]
        $MinimumRequiredOsVersion,

        [Parameter()]
        [System.String]
        $MinimumRequiredSdkVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningAppVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningOsVersion,

        [Parameter()]
        [System.String]
        $MinimumWipeAppVersion,

        [Parameter()]
        [System.String]
        $MinimumWipeOsVersion,

        [Parameter()]
        [System.String]
        $MinimumWipeSdkVersion,

        [Parameter()]
        [ValidateSet('block','wipe','warn','blockWhenSettingIsSupported')]
        [System.String]
        $MobileThreatDefenseRemediationAction,

        [Parameter()]
        [System.String]
        $PeriodOfflineBeforeAccessCheck,

        [Parameter()]
        [System.String]
        $PeriodOfflineBeforeWipeIsEnforced,

        [Parameter()]
        [System.Boolean]
        $PrintBlocked,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter()]
        [System.String[]]
        $Apps,
        #endregion

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

    Write-Verbose -Message "Setting configuration of the Intune App Protection Policy for Windows10 with Id {$Id} and DisplayName {$DisplayName}"

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
    $boundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune App Protection Policy for Windows10 with DisplayName {$DisplayName}"
        $boundParameters.Remove("Assignments") | Out-Null

        $createParameters = ([Hashtable]$boundParameters).Clone()
        $createParameters = Rename-M365DSCCimInstanceParameter -Properties $createParameters
        $createParameters.Remove('Id') | Out-Null

        if ($createParameters.ContainsKey('Apps'))
        {
            $targetApps = @()
            foreach ($app in $createParameters.Apps)
            {
                $targetApps += @{
                    mobileAppIdentifier = @{
                        '@odata.type' = '#microsoft.graph.windowsAppIdentifier'
                        windowsAppId   = $app
                    }
                }
            }
            $createParameters.Remove('Apps') | Out-Null
            $createParameters.Add('Apps', $targetApps)
        }

        #region resource generator code
        $createParameters.Add('@odata.type', '#microsoft.graph.windowsManagedAppProtection')
        $policy = New-MgBetaDeviceAppManagementWindowsManagedAppProtection -BodyParameter $createParameters

        if ($policy.Id)
        {
            $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
            Update-DeviceConfigurationPolicyAssignment `
                -DeviceConfigurationPolicyId $policy.Id `
                -Targets $assignmentsHash `
                -Repository 'deviceAppManagement/windowsManagedAppProtections'
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune App Protection Policy for Windows10 with Id {$($currentInstance.Id)}"
        $boundParameters.Remove("Assignments") | Out-Null

        $updateParameters = ([Hashtable]$boundParameters).Clone()
        $updateParameters = Rename-M365DSCCimInstanceParameter -Properties $updateParameters
        $updateParameters.Remove('Id') | Out-Null

        #region resource generator code
        if ($updateParameters.ContainsKey('Apps'))
        {
            $targetApps = @()
            foreach ($app in $updateParameters.Apps)
            {
                $targetApps += @{
                    mobileAppIdentifier = @{
                        '@odata.type' = '#microsoft.graph.windowsAppIdentifier'
                        windowsAppId   = $app
                    }
                }
            }
            $targetAppsBody = @{
                appGroupType = 'selectedPublicApps'
                apps = $targetApps
            }
            $updateParameters.Remove('Apps') | Out-Null
            Invoke-MgGraphRequest -Method POST `
                -Uri "beta/deviceAppManagement/windowsManagedAppProtections('$($currentInstance.Id)')/targetApps" `
                -Body $($targetAppsBody | ConvertTo-Json -Depth 10)
        }
        Update-MgBetaDeviceAppManagementWindowsManagedAppProtection `
            -WindowsManagedAppProtectionId $currentInstance.Id `
            -BodyParameter $updateParameters

        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceConfigurationPolicyAssignment `
            -DeviceConfigurationPolicyId $currentInstance.Id `
            -Targets $assignmentsHash `
            -Repository 'deviceAppManagement/windowsManagedAppProtections'
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune App Protection Policy for Windows10 with Id {$($currentInstance.Id)}"
        #region resource generator code
        Remove-MgBetaDeviceAppManagementWindowsManagedAppProtection -WindowsManagedAppProtectionId $currentInstance.Id
        #endregion
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        #region resource generator code
        [Parameter()]
        [ValidateSet('allApps','none')]
        [System.String]
        $AllowedInboundDataTransferSources,

        [Parameter()]
        [ValidateSet('anyDestinationAnySource','none')]
        [System.String]
        $AllowedOutboundClipboardSharingLevel,

        [Parameter()]
        [ValidateSet('allApps','none')]
        [System.String]
        $AllowedOutboundDataTransferDestinations,

        [Parameter()]
        [ValidateSet('block','wipe','warn','blockWhenSettingIsSupported')]
        [System.String]
        $AppActionIfUnableToAuthenticateUser,

        [Parameter()]
        [ValidateSet('notConfigured','secured','low','medium','high')]
        [System.String]
        $MaximumAllowedDeviceThreatLevel,

        [Parameter()]
        [System.String]
        $MaximumRequiredOsVersion,

        [Parameter()]
        [System.String]
        $MaximumWarningOsVersion,

        [Parameter()]
        [System.String]
        $MaximumWipeOsVersion,

        [Parameter()]
        [System.String]
        $MinimumRequiredAppVersion,

        [Parameter()]
        [System.String]
        $MinimumRequiredOsVersion,

        [Parameter()]
        [System.String]
        $MinimumRequiredSdkVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningAppVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningOsVersion,

        [Parameter()]
        [System.String]
        $MinimumWipeAppVersion,

        [Parameter()]
        [System.String]
        $MinimumWipeOsVersion,

        [Parameter()]
        [System.String]
        $MinimumWipeSdkVersion,

        [Parameter()]
        [ValidateSet('block','wipe','warn','blockWhenSettingIsSupported')]
        [System.String]
        $MobileThreatDefenseRemediationAction,

        [Parameter()]
        [System.String]
        $PeriodOfflineBeforeAccessCheck,

        [Parameter()]
        [System.String]
        $PeriodOfflineBeforeWipeIsEnforced,

        [Parameter()]
        [System.Boolean]
        $PrintBlocked,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter()]
        [System.String[]]
        $Apps,
        #endregion

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

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
                                         -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '')
    return $result
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [System.String]
        $Filter,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        #region resource generator code
        [array]$getValue = Get-MgBetaDeviceAppManagementWindowsManagedAppProtection `
            -Filter $Filter `
            -All `
            -ErrorAction Stop
        #endregion

        $i = 1
        $dscContent = ''
        if ($getValue.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($config in $getValue)
        {
            $displayedKey = $config.Id
            if (-not [System.String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            elseif (-not [System.String]::IsNullOrEmpty($config.name))
            {
                $displayedKey = $config.name
            }
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                Id                    = $config.Id
                DisplayName           = $config.DisplayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params

            if ($Results.Assignments)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.Assignments -CIMInstanceName DeviceManagementConfigurationPolicyAssignments
                if ($complexTypeStringResult)
                {
                    $Results.Assignments = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Assignments') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('Assignments')
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        return $dscContent
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

Export-ModuleMember -Function *-TargetResource
