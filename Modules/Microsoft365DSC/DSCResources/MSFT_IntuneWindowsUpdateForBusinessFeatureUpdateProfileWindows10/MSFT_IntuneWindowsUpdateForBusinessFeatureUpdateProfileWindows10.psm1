function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $FeatureUpdateVersion,

        [Parameter()]
        [System.Boolean]
        $InstallFeatureUpdatesOptional,

        [Parameter()]
        [System.Boolean]
        $InstallLatestWindows10OnWindows11IneligibleDevice,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $RolloutSettings,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
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
        $getValue = Get-MgBetaDeviceManagementWindowsFeatureUpdateProfile -WindowsFeatureUpdateProfileId $Id  -ErrorAction SilentlyContinue

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Intune Windows Update For Business Feature Update Profile for Windows10 with Id {$Id}"

            if (-Not [string]::IsNullOrEmpty($DisplayName))
            {
                $getValue = Get-MgBetaDeviceManagementWindowsFeatureUpdateProfile `
                    -All `
                    -ErrorAction SilentlyContinue | Where-Object `
                    -FilterScript {
                        $_.DisplayName -eq $DisplayName
                    }
            }
        }
        #endregion
        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Intune Windows Update For Business Feature Update Profile for Windows10 with DisplayName {$DisplayName}"
            return $nullResult
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Windows Update For Business Feature Update Profile for Windows10 with Id {$Id} and DisplayName {$DisplayName} was found."

        #region resource generator code
        $complexRolloutSettings = @{}
        if ($null -ne $getValue.RolloutSettings.offerEndDateTimeInUTC)
        {
            $complexRolloutSettings.Add('OfferEndDateTimeInUTC', ([DateTimeOffset]$getValue.RolloutSettings.offerEndDateTimeInUTC).ToString('o'))
        }
        $complexRolloutSettings.Add('OfferIntervalInDays', $getValue.RolloutSettings.offerIntervalInDays)
        if ($null -ne $getValue.RolloutSettings.offerStartDateTimeInUTC)
        {
            $complexRolloutSettings.Add('OfferStartDateTimeInUTC', ([DateTimeOffset]$getValue.RolloutSettings.offerStartDateTimeInUTC).ToString('o'))
        }
        if ($complexRolloutSettings.values.Where({ $null -ne $_ }).count -eq 0)
        {
            $complexRolloutSettings = $null
        }
        #endregion

        $results = @{
            #region resource generator code
            Description                                       = $getValue.Description
            DisplayName                                       = $getValue.DisplayName
            FeatureUpdateVersion                              = $getValue.FeatureUpdateVersion
            InstallFeatureUpdatesOptional                     = $getValue.InstallFeatureUpdatesOptional
            InstallLatestWindows10OnWindows11IneligibleDevice = $getValue.InstallLatestWindows10OnWindows11IneligibleDevice
            RolloutSettings                                   = $complexRolloutSettings
            Id                                                = $getValue.Id
            Ensure                                            = 'Present'
            Credential                                        = $Credential
            ApplicationId                                     = $ApplicationId
            TenantId                                          = $TenantId
            ApplicationSecret                                 = $ApplicationSecret
            CertificateThumbprint                             = $CertificateThumbprint
            ManagedIdentity                                   = $ManagedIdentity.IsPresent
            AccessTokens                                      = $AccessTokens
            #endregion
        }

        $assignmentsValues = Get-MgBetaDeviceManagementWindowsFeatureUpdateProfileAssignment -WindowsFeatureUpdateProfileId $Id
        $assignmentResult = @()
        if ($assignmentsValues.Count -gt 0)
        {
            $assignmentResult += ConvertFrom-IntunePolicyAssignment `
                                -IncludeDeviceFilter:$true `
                                -Assignments ($assignmentsValues)
        }
        $results.Add('Assignments', $assignmentResult)

        return [System.Collections.Hashtable] $results
    }
    catch
    {
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
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $FeatureUpdateVersion,

        [Parameter()]
        [System.Boolean]
        $InstallFeatureUpdatesOptional,

        [Parameter()]
        [System.Boolean]
        $InstallLatestWindows10OnWindows11IneligibleDevice,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $RolloutSettings,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
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

    # Rollout is not "As soon as possible"
    if ($null -ne $RolloutSettings)
    {
        # Rollout is either "On a specific date" or "gradually"
        if (-not [string]::IsNullOrEmpty($RolloutSettings.OfferStartDateTimeInUTC))
        {
            $currentTime = Get-Date
            $offerStartDate = [datetime]::Parse($RolloutSettings.OfferStartDateTimeInUTC)
            # Rollout is "On a specific date"
            if (-not [string]::IsNullOrEmpty($RolloutSettings.OfferEndDateTimeInUTC))
            {
                $offerEndDate = [datetime]::Parse($RolloutSettings.OfferEndDateTimeInUTC)
                if ($offerEndDate -lt $offerStartDate.AddDays(1))
                {
                    throw 'OfferEndDateTimeInUTC must be greater than OfferStartDateTimeInUTC + 1 day.'
                }

                if ($offerEndDate -le $currentTime)
                {
                    throw 'OfferEndDateTimeInUTC must be greater than the current time.'
                }
            }
        }
    }

    $currentInstance = Get-TargetResource @PSBoundParameters
    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($null -eq $RolloutSettings)
    {
        $BoundParameters.RolloutSettings = @{
            OfferStartDateTimeInUTC = $null
            OfferEndDateTimeInUTC = $null
            OfferIntervalInDays = $null
        }
    }

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Windows Update For Business Feature Update Profile for Windows10 with DisplayName {$DisplayName}"
        $BoundParameters.Remove('Assignments') | Out-Null

        if ($null -ne $RolloutSettings)
        {
            if (-not [string]::IsNullOrEmpty($RolloutSettings.OfferStartDateTimeInUTC))
            {
                $minTimeForAvailable = $currentTime
                $newOfferStartDate = $offerStartDate
                if ($offerStartDate -lt $minTimeForAvailable)
                {
                    $newOfferStartDate = $minTimeForAvailable
                    $BoundParameters.RolloutSettings.OfferStartDateTimeInUTC = $newOfferStartDate.ToString('yyyy-MM-ddTHH:mm:ss.fffZ')
                }

                if (-not [string]::IsNullOrEmpty($RolloutSettings.OfferEndDateTimeInUTC))
                {
                    # If an end date is configured, then the start date must be at least the current time + 2 days
                    $minTimeForAvailable = $currentTime.AddDays(2)
                    if ($newOfferStartDate -lt $minTimeForAvailable)
                    {
                        Write-Verbose -Message 'OfferStartDateTimeInUTC must be at least the current time + 2 days, adjusting it...'
                        $newOfferStartDate = $minTimeForAvailable
                        $BoundParameters.RolloutSettings.OfferStartDateTimeInUTC = $newOfferStartDate.ToString('yyyy-MM-ddTHH:mm:ss.fffZ')
                    }

                    if ($offerEndDate -lt $newOfferStartDate.AddDays(1))
                    {
                        throw 'OfferEndDateTimeInUTC must be greater than OfferStartDateTimeInUTC + 1 day.'
                    }

                    if ($RolloutSettings.OfferIntervalInDays -gt ($offerEndDate - $newOfferStartDate).Days)
                    {
                        throw 'OfferIntervalInDays must be less than or equal to the difference between OfferEndDateTimeInUTC and OfferStartDateTimeInUTC in days.'
                    }
                }
            }
        }

        $CreateParameters = ([Hashtable]$BoundParameters).Clone()
        $CreateParameters = Rename-M365DSCCimInstanceParameter -Properties $CreateParameters
        $CreateParameters.Remove('Id') | Out-Null

        $keys = (([Hashtable]$CreateParameters).Clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $CreateParameters.$key -and $CreateParameters.$key.GetType().Name -like '*cimInstance*')
            {
                $CreateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $CreateParameters.$key
            }
        }

        #region resource generator code
        $policy = New-MgBetaDeviceManagementWindowsFeatureUpdateProfile -BodyParameter $CreateParameters

        if ($policy.Id)
        {
            $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
            Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $policy.Id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/windowsFeatureUpdateProfiles'
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Windows Update For Business Feature Update Profile for Windows10 with Id {$($currentInstance.Id)}"
        $BoundParameters.Remove('Assignments') | Out-Null
        $BoundParameters.Remove('InstallLatestWindows10OnWindows11IneligibleDevice') | Out-Null

        if ($null -ne $RolloutSettings)
        {
            if (-not [string]::IsNullOrEmpty($RolloutSettings.OfferStartDateTimeInUTC))
            {
                $minTimeForAvailable = $currentTime
                if (-not [string]::IsNullOrEmpty($currentInstance.RolloutSettings.OfferStartDateTimeInUTC))
                {
                    $currentOfferDate = [datetime]::Parse($currentInstance.RolloutSettings.OfferStartDateTimeInUTC)
                }
                else
                {
                    $currentOfferDate = [datetime]::MinValue
                }
                $newOfferStartDate = $offerStartDate

                # If the configured start date is different from the current start date but less than the current time, we use the current start date
                if ($offerStartDate -ne $currentOfferDate -and $offerStartDate -lt $minTimeForAvailable)
                {
                    if ($currentOfferDate -eq [datetime]::MinValue)
                    {
                        $newOfferStartDate = $minTimeForAvailable
                        $currentOfferDate = $minTimeForAvailable
                    }
                    else
                    {
                        $newOfferStartDate = $currentOfferDate
                    }
                    $BoundParameters.RolloutSettings.OfferStartDateTimeInUTC = $newOfferStartDate.ToString('yyyy-MM-ddTHH:mm:ss.fffZ')
                }

                if (-not [string]::IsNullOrEmpty($RolloutSettings.OfferEndDateTimeInUTC))
                {
                    # If an end date is configured, then the start date must be at least the current time + 2 days
                    $offerEndDate = [datetime]::Parse($RolloutSettings.OfferEndDateTimeInUTC)
                    $minTimeForAvailable = $currentTime.AddDays(2)
                    if ($newOfferStartDate -lt $minTimeForAvailable)
                    {
                        Write-Verbose -Message 'OfferStartDateTimeInUTC must be at least the current time + 2 days, adjusting it...'
                        $newOfferStartDate = $minTimeForAvailable
                        $BoundParameters.RolloutSettings.OfferStartDateTimeInUTC = $newOfferStartDate.ToString('yyyy-MM-ddTHH:mm:ss.fffZ')
                    }

                    if ($offerEndDate -lt $newOfferStartDate.AddDays(1))
                    {
                        throw 'OfferEndDateTimeInUTC must be greater than OfferStartDateTimeInUTC + 1 day.'
                    }

                    if ($RolloutSettings.OfferIntervalInDays -gt ($offerEndDate - $newOfferStartDate).Days)
                    {
                        throw 'OfferIntervalInDays must be less than or equal to the difference between OfferEndDateTimeInUTC and OfferStartDateTimeInUTC in days.'
                    }
                }
            }
        }

        $UpdateParameters = ([Hashtable]$BoundParameters).Clone()
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters
        $UpdateParameters.Remove('Id') | Out-Null

        $keys = (([Hashtable]$UpdateParameters).Clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $UpdateParameters.$key -and $UpdateParameters.$key.GetType().Name -like '*cimInstance*')
            {
                $UpdateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $UpdateParameters.$key
            }
        }

        #region resource generator code
        Update-MgBetaDeviceManagementWindowsFeatureUpdateProfile  `
            -WindowsFeatureUpdateProfileId $currentInstance.Id `
            -BodyParameter $UpdateParameters

        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $currentInstance.id `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/windowsFeatureUpdateProfiles'
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Windows Update For Business Feature Update Profile for Windows10 with Id {$($currentInstance.Id)}"
        #region resource generator code
        Remove-MgBetaDeviceManagementWindowsFeatureUpdateProfile -WindowsFeatureUpdateProfileId $currentInstance.Id
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
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $FeatureUpdateVersion,

        [Parameter()]
        [System.Boolean]
        $InstallFeatureUpdatesOptional,

        [Parameter()]
        [System.Boolean]
        $InstallLatestWindows10OnWindows11IneligibleDevice,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $RolloutSettings,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
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

    Write-Verbose -Message "Testing configuration of the Intune Windows Update For Business Feature Update Profile for Windows10 with Id {$Id} and DisplayName {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).Clone()
    $testResult = $true

    # Cannot be changed after creation
    $ValuesToCheck.Remove('InstallLatestWindows10OnWindows11IneligibleDevice') | Out-Null

    #Compare Cim instances
    foreach ($key in $PSBoundParameters.Keys)
    {
        if ($key -eq 'RolloutSettings')
        {
            continue
        }

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

    if (-not $testResult)
    {
        Write-Verbose -Message "Test-TargetResource returned $false"
        return $false
    }

    if (($null -eq $RolloutSettings -and $null -ne $CurrentValues.RolloutSettings) -or `
        ($null -ne $RolloutSettings -and $null -eq $CurrentValues.RolloutSettings))
    {
        Write-Verbose -Message 'RolloutSettings is null in either the desired configuration or the current configuration.'
        Write-Verbose -Message "Test-TargetResource returned $false"
        return $false
    }

    $currentTime = Get-Date
    [datetime]$offerStartDate = [datetime]::MinValue
    [datetime]$offerEndDate = [datetime]::MinValue
    [datetime]::TryParse($RolloutSettings.OfferStartDateTimeInUTC, [ref]$offerStartDate) | Out-Null
    [datetime]::TryParse($RolloutSettings.OfferEndDateTimeInUTC, [ref]$offerEndDate) | Out-Null
    if ($CurrentValues.Ensure -ne $Ensure)
    {
        if ($Ensure -eq 'Present')
        {
            if (($offerStartDate -ne [datetime]::MinValue -and $offerStartDate -lt $currentTime) `
                    -and ($offerEndDate -ne [datetime]::MinValue -and $offerEndDate -lt $currentTime))
            {
                Write-Verbose -Message "Start and end time are in the past, skip the configuration."
                Write-Verbose -Message "Test-TargetResource returned $true"
                return $true
            }
        }

        Write-Verbose -Message "Test-TargetResource returned $false"
        return $false
    }

    [datetime]$currentOfferStartDate = [datetime]::MinValue
    [datetime]$currentOfferEndDate = [datetime]::MinValue
    [datetime]::TryParse($CurrentValues.RolloutSettings.OfferStartDateTimeInUTC, [ref]$currentOfferStartDate) | Out-Null
    [datetime]::TryParse($CurrentValues.RolloutSettings.OfferEndDateTimeInUTC, [ref]$currentOfferEndDate) | Out-Null
    if (($offerEndDate -eq [datetime]::MinValue -and $currentOfferEndDate -ne [datetime]::MinValue) -or `
        ($offerEndDate -ne [datetime]::MinValue -and $currentOfferEndDate -eq [datetime]::MinValue))
    {
        Write-Verbose -Message 'OfferEndDateTimeInUTC is null in either the desired configuration or the current configuration.'
        Write-Verbose -Message "Test-TargetResource returned $false"
        return $false
    }

    if ($offerStartDate -ne [datetime]::MinValue -and $currentOfferStartDate -ne [datetime]::MinValue)
    {
        if ($offerStartDate -ne $currentOfferStartDate `
                -and $offerStartDate -gt $currentTime)
        {
            Write-Verbose -Message 'OfferStartDateTimeInUTC is different from current.'
            $testResult = $false
        }

        if ($testResult -and $offerEndDate -ne [datetime]::MinValue -and $currentOfferEndDate -ne [datetime]::MinValue)
        {
            if ($offerStartDate -ne $currentOfferStartDate `
                -and $offerStartDate -gt $currentTime `
                -and $offerStartDate -lt $currentTime.AddDays(2))
            {
                Write-Verbose -Message 'OfferStartDateTimeInUTC must be greater than the current time + 2 days to be changable if OfferEndDateTimeInUTC is specified, resetting testResult to true.'
                $testResult = $true
            }

            if ($offerEndDate -ne $currentOfferEndDate `
                    -and $offerEndDate -gt $currentTime `
                    -and $offerEndDate -gt $offerStartDate)
            {
                Write-Verbose -Message 'OfferEndDateTimeInUTC is different from current.'
                $testResult = $false
            }

            if ($testResult -and $RolloutSettings.OfferIntervalInDays -ne $CurrentValues.RolloutSettings.OfferIntervalInDays)
            {
                Write-Verbose -Message 'OfferIntervalInDays is different from current.'
                $testResult = $false
            }
        }
    }
    $ValuesToCheck.Remove('RolloutSettings') | Out-Null
    $ValuesToCheck.Remove('Id') | Out-Null

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
        # Filter not supported on this resource
        # [array]$getValue = Get-MgBetaDeviceManagementWindowsFeatureUpdateProfile -Filter $Filter -All -ErrorAction Stop
        if (-not [string]::IsNullOrEmpty($Filter))
        {
            Write-Warning -Message "Microsoft Graph filter is not supported on this resource. Only best-effort filtering using startswith, endswith and contains is supported."
            $complexFunctions = Get-ComplexFunctionsFromFilterQuery -FilterQuery $Filter
            $Filter = Remove-ComplexFunctionsFromFilterQuery -FilterQuery $Filter
        }
        [array]$getValue = Get-MgBetaDeviceManagementWindowsFeatureUpdateProfile -All -ErrorAction Stop
        $getValue = Find-GraphDataUsingComplexFunctions -ComplexFunctions $complexFunctions -Policies $getValue
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
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.Id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }

            Write-Host "    |---[$i/$($getValue.Count)] $displayedKey" -NoNewline
            $params = @{
                Id                    = $config.Id
                DisplayName           = $config.displayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            if ( $null -ne $Results.RolloutSettings)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.RolloutSettings `
                    -CIMInstanceName 'MicrosoftGraphWindowsUpdateRolloutSettings'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.RolloutSettings = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('RolloutSettings') | Out-Null
                }
            }
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
                -Credential $Credential
            if ($Results.RolloutSettings)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'RolloutSettings' -IsCIMArray:$False
            }
            if ($Results.Assignments)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'Assignments' -IsCIMArray:$true
            }
            #removing trailing commas and semi colons between items of an array of cim instances added by Convert-DSCStringParamToVariable
            $currentDSCBlock = $currentDSCBlock.replace( "    ,`r`n" , "    `r`n" )
            $currentDSCBlock = $currentDSCBlock.replace( "`r`n;`r`n" , "`r`n" )
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
        if ($_.Exception -like '*401*' -or $_.ErrorDetails.Message -like "*`"ErrorCode`":`"Forbidden`"*" -or `
        $_.Exception -like "*Request not applicable to target tenant*")
        {
            Write-Host "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered for Intune."
        }
        else
        {
            Write-Host $Global:M365DSCEmojiRedX

            New-M365DSCLogEntry -Message 'Error during Export:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential
        }

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
