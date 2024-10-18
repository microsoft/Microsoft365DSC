function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.Boolean]
        $isSingleInstance,

        [Parameter()]
        [System.Boolean]
        $enableDeviceGroupMembershipReport,

        [Parameter()]
        [System.Boolean]
        $androidDeviceAdministratorEnrollmentEnabled,

        [Parameter()]
        [System.Boolean]
        $enhancedJailBreak,

        [Parameter()]
        [System.Boolean]
        $enableAutopilotDiagnostics,

        [Parameter()]
        [System.UInt32]
        $deviceComplianceCheckinThresholdDays,

        [Parameter()]
        [System.UInt32]
        $deviceInactivityBeforeRetirementInDay,

        [Parameter()]
        [System.Boolean]
        $isScheduledActionEnabled,

        [Parameter()]
        [System.Boolean]
        $enableLogCollection,

        [Parameter()]
        [System.Boolean]
        $secureByDefault,

        [Parameter()]
        [System.Boolean]
        $enableEnhancedTroubleshootingExperience,

        [Parameter()]
        [System.Boolean]
        $ignoreDevicesForUnsupportedSettingsEnabled,

        [Parameter()]
        [System.String]
        $derivedCredentialProvider,

        [Parameter()]
        [System.String]
        $derivedCredentialUrl,

        [Parameter()]
        [System.Boolean]
        $m365AppDiagnosticsEnabled,
        #endregion

        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
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

    try
    {

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

        $nullResult = $PSBoundParameters
        $nullResult.Ensure = 'Absent'

        $getValue = $null
        #region resource generator code
        $getValue = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/beta/deviceManagement/settings" -Method GET -ErrorAction SilentlyContinue

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Intune Device Management Setting..."
        } else {
            Write-Verbose -Message "An Intune Device Management Setting was found"
        }

        $results = @{
            isSingleInstance                                = $true
            EnableDeviceGroupMembershipReport               = $getValue.enableDeviceGroupMembershipReport
            androidDeviceAdministratorEnrollmentEnabled     = $getValue.androidDeviceAdministratorEnrollmentEnabled
            enhancedJailBreak                               = $getValue.enhancedJailBreak
            enableAutopilotDiagnostics                      = $getValue.enableAutopilotDiagnostics
            deviceComplianceCheckinThresholdDays            = $getValue.deviceComplianceCheckinThresholdDays
            deviceInactivityBeforeRetirementInDay           = $getValue.deviceInactivityBeforeRetirementInDay
            isScheduledActionEnabled                        = $getValue.isScheduledActionEnabled
            enableLogCollection                             = $getValue.enableLogCollection
            secureByDefault                                 = $getValue.secureByDefault
            derivedCredentialUrl                            = $getValue.derivedCredentialUrl
            enableEnhancedTroubleshootingExperience         = $getValue.enableEnhancedTroubleshootingExperience
            ignoreDevicesForUnsupportedSettingsEnabled      = $getValue.ignoreDevicesForUnsupportedSettingsEnabled
            derivedCredentialProvider                       = $getValue.derivedCredentialProvider
            m365AppDiagnosticsEnabled                       = $getValue.m365AppDiagnosticsEnabled

            Ensure                                          = 'Present'
            Credential                                      = $Credential
            ApplicationId                                   = $ApplicationId
            TenantId                                        = $TenantId
            ApplicationSecret                               = $ApplicationSecret
            CertificateThumbprint                           = $CertificateThumbprint
            ManagedIdentity                                 = $ManagedIdentity.IsPresent
            AccessTokens                                    = $AccessTokens
        }
        
        return [System.Collections.Hashtable] $results
    }
    catch
    {
        Write-Verbose -Message "Error retrieving data: $_"
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
        #region resource generator code
        [Parameter()]
        [System.Boolean]
        $isSingleInstance,

        [Parameter()]
        [System.Boolean]
        $enableDeviceGroupMembershipReport,

        [Parameter()]
        [System.Boolean]
        $androidDeviceAdministratorEnrollmentEnabled,

        [Parameter()]
        [System.Boolean]
        $enhancedJailBreak,

        [Parameter()]
        [System.Boolean]
        $enableAutopilotDiagnostics,

        [Parameter()]
        [System.UInt32]
        $deviceComplianceCheckinThresholdDays,

        [Parameter()]
        [System.UInt32]
        $deviceInactivityBeforeRetirementInDay,

        [Parameter()]
        [System.Boolean]
        $isScheduledActionEnabled,

        [Parameter()]
        [System.Boolean]
        $enableLogCollection,

        [Parameter()]
        [System.Boolean]
        $secureByDefault,

        [Parameter()]
        [System.Boolean]
        $enableEnhancedTroubleshootingExperience,

        [Parameter()]
        [System.Boolean]
        $ignoreDevicesForUnsupportedSettingsEnabled,

        [Parameter()]
        [System.String]
        $derivedCredentialProvider,

        [Parameter()]
        [System.String]
        $derivedCredentialUrl,

        [Parameter()]
        [System.Boolean]
        $m365AppDiagnosticsEnabled,
        #endregion

        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentInstance = Get-TargetResource @PSBoundParameters

    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters


    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Device Management with DisplayName {$DisplayName}"

        $createParameters = ([Hashtable]$BoundParameters).Clone()
        $createParameters = Rename-M365DSCCimInstanceParameter -Properties $createParameters

        $keys = (([Hashtable]$createParameters).Clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $createParameters.$key -and $createParameters.$key.GetType().Name -like '*CimInstance*')
            {
                $createParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $createParameters.$key
            }
        }

        $createParameters.Add("@odata.type", "microsoft.graph.deviceManagementSettings")
        if ($createParameters.ContainsKey('IsSingleInstance'))
        {
            $createParameters.Remove('IsSingleInstance')
        }
        if ($createParameters.ContainsKey('ensure'))
        {
            $createParameters.Remove('ensure')
        }

        $body = @{
            "settings" = $createParameters
        } | ConvertTo-Json

        # write the settings to the device management
        $CreateSettings = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/beta/deviceManagement" -Method PATCH -Body $body -ErrorAction SilentlyContinue 
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Device Management settings"

        $updateParameters = ([Hashtable]$BoundParameters).Clone()
        $updateParameters = Rename-M365DSCCimInstanceParameter -Properties $updateParameters

        $keys = (([Hashtable]$updateParameters).Clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $pdateParameters.$key -and $updateParameters.$key.GetType().Name -like '*CimInstance*')
            {
                $updateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $updateParameters.
            }
        }

        #region resource generator code
        $updateParameters.Add("@odata.type", "microsoft.graph.deviceManagementSettings")
        if ($updateParameters.ContainsKey('IsSingleInstance'))
        {
            $updateParameters.Remove('IsSingleInstance')
        }
        if ($updateParameters.ContainsKey('ensure'))
        {
            $updateParameters.Remove('ensure')
        }
        $body = @{
            "settings" = $updateParameters
        } | ConvertTo-Json

        $UpdateSettings = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/beta/deviceManagement" -Method PATCH -Body $body -ErrorAction SilentlyContinue 
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Device Management Settings can not be absent"
        #region resource generator code
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
        [System.Boolean]
        $isSingleInstance,
        
        [Parameter()]
        [System.Boolean]
        $enableDeviceGroupMembershipReport,

        [Parameter()]
        [System.Boolean]
        $androidDeviceAdministratorEnrollmentEnabled,

        [Parameter()]
        [System.Boolean]
        $enhancedJailBreak,

        [Parameter()]
        [System.Boolean]
        $enableAutopilotDiagnostics,

        [Parameter()]
        [System.UInt32]
        $deviceComplianceCheckinThresholdDays,

        [Parameter()]
        [System.UInt32]
        $deviceInactivityBeforeRetirementInDay,

        [Parameter()]
        [System.Boolean]
        $isScheduledActionEnabled,

        [Parameter()]
        [System.Boolean]
        $enableLogCollection,

        [Parameter()]
        [System.Boolean]
        $secureByDefault,

        [Parameter()]
        [System.Boolean]
        $enableEnhancedTroubleshootingExperience,

        [Parameter()]
        [System.Boolean]
        $ignoreDevicesForUnsupportedSettingsEnabled,

        [Parameter()]
        [System.String]
        $derivedCredentialProvider,

        [Parameter()]
        [System.String]
        $derivedCredentialUrl,

        [Parameter()]
        [System.Boolean]
        $m365AppDiagnosticsEnabled,
        #endregion

        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of the Intune Device Management Settings"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()

    if ($CurrentValues.Ensure -ne $Ensure)
    {
        Write-Verbose -Message "Test-TargetResource returned $false"
        return $false
    }
    $testResult = $true

    #Compare Cim instances
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
                break
            }

            $ValuesToCheck.Remove($key) | Out-Null
        }
    }

    $ValuesToCheck = Remove-M365DSCAuthenticationParameter -BoundParameters $ValuesToCheck

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    if ($testResult)
    {
        $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
            -Source $($MyInvocation.MyCommand.Source) `
            -DesiredValues $PSBoundParameters `
            -ValuesToCheck $ValuesToCheck.Keys
    }

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

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph'`
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
        [array]$getValue = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/beta/deviceManagement/settings" -Method GET `
            -ErrorAction Stop
        #endregion

        $i = 1
        $dscContent = ''
        if ($getValue.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($config in $getValue)
        {
            $displayedKey = "settings"
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            elseif (-not [string]::IsNullOrEmpty($config.name))
            {
                $displayedKey = "settings"
            }
            Write-Host "    |---[$i/$($getValue.Count)] $displayedKey" -NoNewline
            $params = @{
                Ensure = 'Present'
                Credential = $Credential
                ApplicationId = $ApplicationId
                TenantId = $TenantId
                ApplicationSecret = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity = $ManagedIdentity.IsPresent
                AccessTokens = $AccessTokens
            }

            $Results = Get-TargetResource @Params

            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results

            if ($null -eq $Results.enableDeviceGroupMembershipReport)
            {
                $Results.Remove('enableDeviceGroupMembershipReport') | Out-Null
            }
            if ($null -eq $Results.androidDeviceAdministratorEnrollmentEnabled)
            {
                $Results.Remove('androidDeviceAdministratorEnrollmentEnabled') | Out-Null
            }
            if ($null -eq $Results.enhancedJailBreak)
            {
                $Results.Remove('enhancedJailBreak') | Out-Null
            }
            if ($null -eq $Results.enableAutopilotDiagnostics)
            {
                $Results.Remove('enableAutopilotDiagnostics') | Out-Null
            }
            if ($null -eq $Results.deviceComplianceCheckinThresholdDays)
            {
                $Results.Remove('deviceComplianceCheckinThresholdDays') | Out-Null
            }
            if ($null -eq $Results.deviceInactivityBeforeRetirementInDay)
            {
                $Results.Remove('deviceInactivityBeforeRetirementInDay') | Out-Null
            }
            if ($null -eq $Results.isScheduledActionEnabled)
            {
                $Results.Remove('isScheduledActionEnabled') | Out-Null
            }
            if ($null -eq $Results.enableLogCollection)
            {
                $Results.Remove('enableLogCollection') | Out-Null
            }
            if ($null -eq $Results.secureByDefault)
            {
                $Results.Remove('secureByDefault') | Out-Null
            }
            if ($null -eq $Results.derivedCredentialUrl)
            {
                $Results.Remove('derivedCredentialUrl') | Out-Null
            }
            if ($null -eq $Results.enableEnhancedTroubleshootingExperience)
            {
                $Results.Remove('enableEnhancedTroubleshootingExperience') | Out-Null
            }
            if ($null -eq $Results.ignoreDevicesForUnsupportedSettingsEnabled)
            {
                $Results.Remove('ignoreDevicesForUnsupportedSettingsEnabled') | Out-Null
            }
            if ($null -eq $Results.derivedCredentialProvider)
            {
                $Results.Remove('derivedCredentialProvider') | Out-Null
            }
            if ($null -eq $Results.m365AppDiagnosticsEnabled)
            {
                $Results.Remove('m365AppDiagnosticsEnabled') | Out-Null
            }
            if ($null -eq $Results.IsSingleInstance)
            {
                $Results['IsSingleInstance'] = $true
            }

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
        Write-Host "Error during Export: $_"
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
