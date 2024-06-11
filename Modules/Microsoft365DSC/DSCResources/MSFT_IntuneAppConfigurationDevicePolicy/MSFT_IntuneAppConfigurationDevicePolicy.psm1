function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.Boolean]
        $ConnectedAppsEnabled,

        [Parameter()]
        [System.String]
        $PackageId,

        [Parameter()]
        [System.String]
        $PayloadJson,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $PermissionActions,

        [Parameter()]
        [ValidateSet('default','androidWorkProfile','androidDeviceOwner')]
        [System.String]
        $ProfileApplicability,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $EncodedSettingXml,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Settings,

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
        [System.String[]]
        $TargetedMobileApps,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

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
        $getValue = Get-MgBetaDeviceAppManagementMobileAppConfiguration -ManagedDeviceMobileAppConfigurationId $Id  -ErrorAction SilentlyContinue

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Intune App Configuration Device Policy with Id {$Id}"

            if (-Not [string]::IsNullOrEmpty($DisplayName))
            {
                $getValue = Get-MgBetaDeviceAppManagementMobileAppConfiguration `
                    -Filter "DisplayName eq '$DisplayName'" `
                    -ErrorAction SilentlyContinue
            }
        }
        #endregion
        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Intune App Configuration Device Policy with DisplayName {$DisplayName}"
            return $nullResult
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune App Configuration Device Policy with Id {$Id} and DisplayName {$DisplayName} was found."

        #region resource generator code
        $complexPermissionActions = @()
        foreach ($currentpermissionActions in $getValue.AdditionalProperties.permissionActions)
        {
            $mypermissionActions = @{}
            if ($null -ne $currentpermissionActions.action)
            {
                $mypermissionActions.Add('Action', $currentpermissionActions.action.toString())
            }
            $mypermissionActions.Add('Permission', $currentpermissionActions.permission)
            if ($mypermissionActions.values.Where({$null -ne $_}).count -gt 0)
            {
                $complexPermissionActions += $mypermissionActions
            }
        }

        $complexSettings = @()
        foreach ($currentsettings in $getValue.AdditionalProperties.settings)
        {
            $mysettings = @{}
            $mysettings.Add('AppConfigKey', $currentsettings.appConfigKey)
            if ($null -ne $currentsettings.appConfigKeyType)
            {
                $mysettings.Add('AppConfigKeyType', $currentsettings.appConfigKeyType.toString())
            }
            $mysettings.Add('AppConfigKeyValue', $currentsettings.appConfigKeyValue)
            if ($mysettings.values.Where({$null -ne $_}).count -gt 0)
            {
                $complexSettings += $mysettings
            }
        }
        #endregion

        #region resource generator code
        $enumProfileApplicability = $null
        if ($null -ne $getValue.AdditionalProperties.profileApplicability)
        {
            $enumProfileApplicability = $getValue.AdditionalProperties.profileApplicability.ToString()
        }
        #endregion

        $platform = 'android'
        if ($null -ne $getValue.AdditionalProperties.encodedSettingXml -or $null -ne $getValue.AdditionalProperties.settings)
        {
            $platform = 'ios'
        }

        $targetedApps = @()
        foreach ($targetedApp in $getValue.TargetedMobileApps)
        {
            $app = Get-MgBetaDeviceAppManagementMobileApp -MobileAppId $targetedApp
            if ($platform -eq 'android')
            {
                $targetedApps += $app.AdditionalProperties.packageId
            }
            else
            {
                $targetedApps += $app.AdditionalProperties.bundleId
            }
        }

        $payloadJson = $null
        if (-not [System.String]::IsNullOrEmpty($getValue.AdditionalProperties.payloadJson))
        {
            $payloadJson = [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($getValue.AdditionalProperties.payloadJson))
        }

        $results = @{
            #region resource generator code
            ConnectedAppsEnabled  = $getValue.AdditionalProperties.connectedAppsEnabled
            PackageId             = $getValue.AdditionalProperties.packageId
            PayloadJson           = $payloadJson
            PermissionActions     = $complexPermissionActions
            ProfileApplicability  = $enumProfileApplicability
            EncodedSettingXml     = $getValue.AdditionalProperties.encodedSettingXml
            Settings              = $complexSettings
            Description           = $getValue.Description
            DisplayName           = $getValue.DisplayName
            RoleScopeTagIds       = $getValue.RoleScopeTagIds
            TargetedMobileApps    = $targetedApps
            Id                    = $getValue.Id
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            #endregion
        }
        $assignmentsValues = Get-MgBetaDeviceAppManagementMobileAppConfigurationAssignment -ManagedDeviceMobileAppConfigurationId $Id

        $assignmentResult = @()
        if ($assignmentsValues.Count -gt 0)
        {
            $assignmentResult += ConvertFrom-IntunePolicyAssignment -Assignments $assignmentsValues -IncludeDeviceFilter $true
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
        [System.Boolean]
        $ConnectedAppsEnabled,

        [Parameter()]
        [System.String]
        $PackageId,

        [Parameter()]
        [System.String]
        $PayloadJson,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $PermissionActions,

        [Parameter()]
        [ValidateSet('default','androidWorkProfile','androidDeviceOwner')]
        [System.String]
        $ProfileApplicability,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $EncodedSettingXml,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Settings,

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
        [System.String[]]
        $TargetedMobileApps,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

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

    $currentInstance = Get-TargetResource @PSBoundParameters

    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $platform = 'android'
    if ($BoundParameters.ContainsKey('EncodedSettingXml') -or $BoundParameters.ContainsKey('Settings'))
    {
        $platform = 'ios'
    }

    if (-not [System.String]::IsNullOrEmpty($BoundParameters.PayloadJson))
    {
        $BoundParameters.PayloadJson = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($BoundParameters.PayloadJson))
    }

    $mobileApps = Get-MgBetaDeviceAppManagementMobileApp -All
    $targetedApps = @()
    foreach ($targetedApp in $TargetedMobileApps)
    {
        $app = $mobileApps | Where-Object -FilterScript {
            ($platform -eq 'android' -and $_.AdditionalProperties.packageId -eq $targetedApp -and $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.androidManagedStoreApp') -or `
            ($platform -eq 'ios' -and $_.AdditionalProperties.bundleId -eq $targetedApp)
        }

        if ($null -eq $app)
        {
            throw "Could not find a mobile app with packageId or bundleId {$targetedApp}"
        }
        $targetedApps += $app.Id
    }
    $BoundParameters.TargetedMobileApps = $targetedApps

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune App Configuration Device Policy with DisplayName {$DisplayName}"
        $BoundParameters.Remove("Assignments") | Out-Null

        $CreateParameters = ([Hashtable]$BoundParameters).clone()
        $CreateParameters = Rename-M365DSCCimInstanceParameter -Properties $CreateParameters
        $CreateParameters.Remove('Id') | Out-Null
        if ($platform -eq 'android')
        {
            $CreateParameters.Add('@odata.type', '#microsoft.graph.androidManagedStoreAppConfiguration')
            $CreateParameters.Add('appSupportsOemConfig', $false)
        }
        else
        {
            $CreateParameters.Add('@odata.type', '#microsoft.graph.iosMobileAppConfiguration')
        }

        $keys = (([Hashtable]$CreateParameters).clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $CreateParameters.$key -and $CreateParameters.$key.getType().Name -like '*cimInstance*')
            {
                $CreateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $CreateParameters.$key
            }
        }
        #region resource generator code
        $policy = New-MgBetaDeviceAppManagementMobileAppConfiguration -BodyParameter $CreateParameters
        $assignmentsHash = @()
        foreach ($assignment in $Assignments)
        {
            $assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }

        if ($policy.Id)
        {
            Update-DeviceConfigurationPolicyAssignment `
                -DeviceConfigurationPolicyId "$($policy.Id)/microsoft.graph.managedDeviceMobileAppConfiguration" `
                -Targets $assignmentsHash `
                -Repository 'deviceAppManagement/mobileAppConfigurations'
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune App Configuration Device Policy with Id {$($currentInstance.Id)}"
        $BoundParameters.Remove("Assignments") | Out-Null

        $UpdateParameters = ([Hashtable]$BoundParameters).clone()
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters
        $UpdateParameters.Remove('Id') | Out-Null

        if ($platform -eq 'android')
        {
            $UpdateParameters.Add('@odata.type', '#microsoft.graph.androidManagedStoreAppConfiguration')
        }
        else
        {
            $UpdateParameters.Add('@odata.type', '#microsoft.graph.iosMobileAppConfiguration')
        }

        $keys = (([Hashtable]$UpdateParameters).clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $UpdateParameters.$key -and $UpdateParameters.$key.getType().Name -like '*cimInstance*')
            {
                $UpdateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $UpdateParameters.$key
            }
        }
        #region resource generator code
        Update-MgBetaDeviceAppManagementMobileAppConfiguration  `
            -ManagedDeviceMobileAppConfigurationId $currentInstance.Id `
            -BodyParameter $UpdateParameters

        $assignmentsHash = @()
        foreach ($assignment in $Assignments)
        {
            $assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $assignment
        }
        Update-DeviceConfigurationPolicyAssignment `
            -DeviceConfigurationPolicyId "$($currentInstance.Id)/microsoft.graph.managedDeviceMobileAppConfiguration" `
            -Targets $assignmentsHash `
            -Repository 'deviceAppManagement/mobileAppConfigurations'
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune App Configuration Device Policy with Id {$($currentInstance.Id)}"
        #region resource generator code
        Remove-MgBetaDeviceAppManagementMobileAppConfiguration -ManagedDeviceMobileAppConfigurationId $currentInstance.Id
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
        $ConnectedAppsEnabled,

        [Parameter()]
        [System.String]
        $PackageId,

        [Parameter()]
        [System.String]
        $PayloadJson,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $PermissionActions,

        [Parameter()]
        [ValidateSet('default','androidWorkProfile','androidDeviceOwner')]
        [System.String]
        $ProfileApplicability,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $EncodedSettingXml,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Settings,

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
        [System.String[]]
        $TargetedMobileApps,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

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

    Write-Verbose -Message "Testing configuration of the Intune App Configuration Device Policy with Id {$Id} and DisplayName {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).Clone()

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
        if ($source.GetType().Name -like '*CimInstance*')
        {
            $source = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $source

            if ($key -eq "Assignments")
            {
                $testResult = Compare-M365DSCIntunePolicyAssignment -Source $source -Target $target
            }
            else
            {
                $testResult = Compare-M365DSCComplexObject -Source ($source) -Target ($target)
            }

            if (-not $testResult) { break }

            $ValuesToCheck.Remove($key) | Out-Null
        }
    }

    $ValuesToCheck.Remove('Id') | Out-Null
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
        [array]$getValue = Get-MgBetaDeviceAppManagementMobileAppConfiguration `
            -Filter $Filter `
            -All `
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
            $displayedKey = $config.Id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            Write-Host "    |---[$i/$($getValue.Count)] $displayedKey" -NoNewline
            $params = @{
                Id                    = $config.Id
                DisplayName           =  $config.DisplayName
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
            if ($null -ne $Results.PermissionActions)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.PermissionActions `
                    -CIMInstanceName 'MicrosoftGraphandroidPermissionAction'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.PermissionActions = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('PermissionActions') | Out-Null
                }
            }
            if ($null -ne $Results.Settings)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.Settings `
                    -CIMInstanceName 'MicrosoftGraphappConfigurationSettingItem'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.Settings = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Settings') | Out-Null
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
            if ($Results.PermissionActions)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "PermissionActions" -isCIMArray:$True
            }
            if ($Results.Settings)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "Settings" -isCIMArray:$True
            }
            if ($Results.Assignments)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "Assignments" -isCIMArray:$true
            }

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
