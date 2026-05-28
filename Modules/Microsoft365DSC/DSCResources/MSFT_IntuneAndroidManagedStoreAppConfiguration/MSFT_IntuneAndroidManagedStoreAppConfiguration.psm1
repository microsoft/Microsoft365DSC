Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneAndroidManagedStoreAppConfiguration'

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
        [System.String[]]
        $targetedMobileApps,

        [Parameter()]
        [System.String]
        $packageId,

        [Parameter()]
        [System.String]
        $payloadJson,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $permissionActions,

        [Parameter()]
        [System.Boolean]
        $appSupportsOemConfig,

        [Parameter()]
        [ValidateSet('default', 'androidWorkProfile', 'androidDeviceOwner')]
        [System.String]
        $profileApplicability,

        [Parameter()]
        [System.Boolean]
        $connectedAppsEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration of the Intune Android Managed Store App Configuration Policy with Id {$Id} and DisplayName {$DisplayName}"

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
            if (-not [string]::IsNullOrWhiteSpace($Id))
            {
                $getValue = Get-MgBetaDeviceAppManagementMobileAppConfiguration -ManagedDeviceMobileAppConfigurationId $Id -ErrorAction SilentlyContinue
            }

            #region resource generator code
            if ($null -eq $getValue)
            {
                $getValue = Get-MgBetaDeviceAppManagementMobileAppConfiguration -Filter "DisplayName eq '$($Displayname -replace "'", "''")' and isof('microsoft.graph.androidManagedStoreAppConfiguration')" -ErrorAction SilentlyContinue
            }
            #endregion

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "No Intune Android Managed Store App Configuration Policy with id {$Id} and display name {$DisplayName} was found"
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }

        Write-Verbose -Message "An Intune Android Managed Store App Configuration Policy with id {$Id}"

        #need to convert dictionary object into a hashtable array so we can work with it
        $complexPermissionActions = @()
        foreach ($setting in $getValue.permissionActions)
        {
            $mySettings = [ordered]@{}
            $mySettings.Add('action', $setting['action'])
            $mySettings.Add('permission', $setting['permission'])

            if ($mySettings.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexPermissionActions += $mySettings
            }
        }

        [System.String[]]$targetedMobileAppsValue = @()
        foreach ($appId in $getValue.TargetedMobileApps)
        {
            $appDetails = Get-MgBetaDeviceAppManagementMobileApp -MobileAppId $appId -ErrorAction SilentlyContinue
            if ($null -eq $appDetails)
            {
                Write-Warning -Message "Could not retrieve details for Targeted Mobile App with id {$appId} targeted by this policy. Skipping it."
            }
            else
            {
                $targetedMobileAppsValue += $appDetails.DisplayName
            }
        }

        $results = @{
            #region resource generator code
            Id                    = $getValue.Id
            Description           = $getValue.Description
            DisplayName           = $getValue.DisplayName
            targetedMobileApps    = $targetedMobileAppsValue
            packageId             = $getValue.packageId
            payloadJson           = $getValue.payloadJson
            appSupportsOemConfig  = $getValue.appSupportsOemConfig
            profileApplicability  = $getValue.profileApplicability
            connectedAppsEnabled  = $getValue.connectedAppsEnabled
            permissionActions     = $complexPermissionActions
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            CertificatePath       = $CertificatePath
            CertificatePassword   = $CertificatePassword
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
        }

        $assignmentsValues = Get-MgBetaDeviceAppManagementMobileAppConfigurationAssignment -ManagedDeviceMobileAppConfigurationId $Results.Id
        $assignmentResult = @()
        if ($assignmentsValues.Count -gt 0)
        {
            $assignmentResult += ConvertFrom-IntunePolicyAssignment `
                -IncludeDeviceFilter:$true `
                -Assignments ($assignmentsValues)
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
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $TargetedMobileApps,

        [Parameter()]
        [System.String]
        $packageId,

        [Parameter()]
        [System.String]
        $payloadJson,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $permissionActions,

        [Parameter()]
        [System.Boolean]
        $appSupportsOemConfig,

        [Parameter()]
        [ValidateSet('default', 'androidWorkProfile', 'androidDeviceOwner')]
        [System.String]
        $profileApplicability,

        [Parameter()]
        [System.Boolean]
        $connectedAppsEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

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

    if ($PSBoundParameters.ContainsKey('TargetedMobileApps'))
    {
        $newTargetedMobileApps = @()
        foreach ($app in $TargetedMobileApps)
        {
            $guid = [System.Guid]::Empty
            if ([System.Guid]::TryParse($app, [ref]$guid))
            {
                $appId = (Get-MgBetaDeviceAppManagementMobileApp -MobileAppId $app -ErrorAction SilentlyContinue).id
                if ($null -eq $appId)
                {
                    throw "Could not find an Android Managed Store App in Intune with the id {$app} that is being targeted by this policy. Please ensure the app exists."
                }
            }
            else
            {
                $appId = (Get-MgBetaDeviceAppManagementMobileApp -Filter "DisplayName eq '$($app -replace "'", "''")' and isof('microsoft.graph.androidManagedStoreApp')").id
                if ($null -eq $appId)
                {
                    throw "Could not find an Android Managed Store App in Intune with the display name {$app} that is being targeted by this policy. Please ensure the app exists."
                }
            }
            $newTargetedMobileApps += $appId
        }
        $PSBoundParameters.Remove('TargetedMobileApps') | Out-Null
        $PSBoundParameters.Add('TargetedMobileApps', $newTargetedMobileApps)
    }

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating the Intune Android Managed Store App Configuration Policy {$DisplayName}"
        $PSBoundParameters.Remove('Assignments') | Out-Null
        $CreateParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
        $CreateParameters = Rename-M365DSCCimInstanceParameter -Properties $CreateParameters
        $CreateParameters.Remove('Id') | Out-Null

        #region resource generator code
        $CreateParameters.Add('@odata.type', '#microsoft.graph.androidManagedStoreAppConfiguration')
        $policy = New-MgBetaDeviceAppManagementMobileAppConfiguration -BodyParameter $CreateParameters
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments

        if ($policy.id)
        {
            Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $policy.id `
                -Targets $assignmentsHash `
                -Repository 'deviceAppManagement/mobileAppConfigurations'
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Android Managed Store App Configuration Policy {$DisplayName}"
        $PSBoundParameters.Remove('Assignments') | Out-Null
        $UpdateParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters
        $UpdateParameters.Remove('Id') | Out-Null

        #region resource generator code
        $UpdateParameters.Add('@odata.type', '#microsoft.graph.androidManagedStoreAppConfiguration')
        Update-MgBetaDeviceAppManagementMobileAppConfiguration -BodyParameter $UpdateParameters `
            -ManagedDeviceMobileAppConfigurationId $currentInstance.Id
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $currentInstance.id `
            -Targets $assignmentsHash `
            -Repository 'deviceAppManagement/mobileAppConfigurations'
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Android Managed Store App Configuration Policy {$DisplayName}"
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
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $targetedMobileApps,

        [Parameter()]
        [System.String]
        $packageId,

        [Parameter()]
        [System.String]
        $payloadJson,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $permissionActions,

        [Parameter()]
        [System.Boolean]
        $appSupportsOemConfig,

        [Parameter()]
        [ValidateSet('default', 'androidWorkProfile', 'androidDeviceOwner')]
        [System.String]
        $profileApplicability,

        [Parameter()]
        [System.Boolean]
        $connectedAppsEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

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
        $baseFilter = "isof('microsoft.graph.androidManagedStoreAppConfiguration')"
        if (-not [System.String]::IsNullOrEmpty($Filter))
        {
            $Filter = "($baseFilter) and ($Filter)"
        }
        else
        {
            $Filter = $baseFilter
        }
        [array]$getValue = Get-MgBetaDeviceAppManagementMobileAppConfiguration -Filter $Filter -All -ErrorAction Stop

        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
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
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $($config.DisplayName)" -DeferWrite
            $params = @{
                Id                    = $config.id
                DisplayName           = $config.DisplayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
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

            if ($null -ne $Results.permissionActions)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.permissionActions `
                    -CIMInstanceName 'MSFT_androidPermissionAction'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.permissionActions = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('permissionActions') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('Assignments', 'permissionActions')

            [void]$dscContent.Append($currentDSCBlock)
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }

        return $dscContent.ToString()
    }
    catch
    {
        if ($_.Exception -like '*401*' -or $_.ErrorDetails.Message -like "*`"ErrorCode`":`"Forbidden`"*" -or `
                $_.Exception -like '*Request not applicable to target tenant*')
        {
            Write-M365DSCHost -Message "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered for Intune."
        }
        else
        {
            New-M365DSCLogEntry -Message 'Error during Export:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential

            throw
        }
    }
}

Export-ModuleMember -Function *-TargetResource
