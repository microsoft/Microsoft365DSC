Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneWifiConfigurationPolicyMacOS'

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
        [System.Boolean]
        $ConnectAutomatically,

        [Parameter()]
        [System.Boolean]
        $ConnectWhenNetworkNameIsHidden,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceChannel', 'userChannel')]
        $DeploymentChannel,

        [Parameter()]
        [System.Boolean]
        $ForcePreSharedKeyUpdate,

        [Parameter()]
        [System.String]
        $NetworkName,

        [Parameter()]
        [System.String]
        $PreSharedKey,

        [Parameter()]
        [System.String]
        $ProxyAutomaticConfigurationUrl,

        [Parameter()]
        [System.String]
        $ProxyManualAddress,

        [Parameter()]
        [System.Int32]
        $ProxyManualPort,

        [Parameter()]
        [ValidateSet('none', 'manual', 'automatic')]
        [System.String]
        $ProxySettings,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $Ssid,

        [Parameter()]
        [ValidateSet('open', 'wpaPersonal', 'wpaEnterprise', 'wep', 'wpa2Personal', 'wpa2Enterprise')]
        [System.String]
        $WiFiSecurityType,

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

    Write-Verbose -Message "Getting configuration of the Intune Wifi Configuration Policy for MacOS with Id {$Id} and DisplayName {$DisplayName}"

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
            if (-not [string]::IsNullOrEmpty($Id))
            {
                $getValue = Get-MgBetaDeviceManagementDeviceConfiguration -All -Filter "Id eq '$Id'" -ErrorAction SilentlyContinue
            }

            #region resource generator code
            if ($null -eq $getValue)
            {
                $getValue = Get-MgBetaDeviceManagementDeviceConfiguration -All -Filter "DisplayName eq '$($DisplayName -replace "'", "''")' and isof('microsoft.graph.macOSWiFiConfiguration')" -ErrorAction SilentlyContinue
            }
            #endregion

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "No Intune Wifi Configuration Policy for MacOS with Id {$Id} was found"
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }
        $Id = $getValue.Id

        Write-Verbose -Message "Found an Intune Wifi Configuration Policy for MacOS with Id {$Id}"
        $results = @{
            #region resource generator code
            Id                             = $getValue.Id
            Description                    = $getValue.Description
            DisplayName                    = $getValue.DisplayName
            ConnectAutomatically           = $getValue.connectAutomatically
            ConnectWhenNetworkNameIsHidden = $getValue.connectWhenNetworkNameIsHidden
            DeploymentChannel              = $getValue.deploymentChannel
            NetworkName                    = $getValue.networkName
            PreSharedKey                   = $getValue.preSharedKey
            ProxyAutomaticConfigurationUrl = $getValue.proxyAutomaticConfigurationUrl
            ProxyManualAddress             = $getValue.proxyManualAddress
            ProxyManualPort                = $getValue.proxyManualPort
            ProxySettings                  = $getValue.proxySettings
            RoleScopeTagIds                = $getValue.RoleScopeTagIds
            Ssid                           = $getValue.ssid
            WiFiSecurityType               = $getValue.wiFiSecurityType
            Ensure                         = 'Present'
            Credential                     = $Credential
            ApplicationId                  = $ApplicationId
            TenantId                       = $TenantId
            ApplicationSecret              = $ApplicationSecret
            CertificateThumbprint          = $CertificateThumbprint
            CertificatePath                = $CertificatePath
            CertificatePassword            = $CertificatePassword
            ManagedIdentity                = $ManagedIdentity.IsPresent
            AccessTokens                   = $AccessTokens
        }

        $assignmentsValues = Get-MgBetaDeviceManagementDeviceConfigurationAssignment -DeviceConfigurationId $Id
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
        [System.Boolean]
        $ConnectAutomatically,

        [Parameter()]
        [System.Boolean]
        $ConnectWhenNetworkNameIsHidden,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceChannel', 'userChannel')]
        $DeploymentChannel,

        [Parameter()]
        [System.Boolean]
        $ForcePreSharedKeyUpdate,

        [Parameter()]
        [System.String]
        $NetworkName,

        [Parameter()]
        [System.String]
        $PreSharedKey,

        [Parameter()]
        [System.String]
        $ProxyAutomaticConfigurationUrl,

        [Parameter()]
        [System.String]
        $ProxyManualAddress,

        [Parameter()]
        [System.Int32]
        $ProxyManualPort,

        [Parameter()]
        [ValidateSet('none', 'manual', 'automatic')]
        [System.String]
        $ProxySettings,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $Ssid,

        [Parameter()]
        [ValidateSet('open', 'wpaPersonal', 'wpaEnterprise', 'wep', 'wpa2Personal', 'wpa2Enterprise')]
        [System.String]
        $WiFiSecurityType,

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

    if ($ProxySettings -ne 'automatic' -and $ProxyAutomaticConfigurationUrl -ne '')
    {
        throw 'ProxyAutomaticConfigurationUrl must be empty if ProxySettings is not "automatic"'
    }

    if ($WiFiSecurityType -eq 'wpaPersonal' -and [string]::IsNullOrEmpty($PreSharedKey))
    {
        throw 'PreSharedKey is required but was not set.'
    }

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
        Write-Verbose -Message "Creating an Intune Wifi Configuration Policy for MacOS with DisplayName {$DisplayName}"
        $CreateParameters = Rename-M365DSCCimInstanceParameter -Properties $BoundParameters
        $CreateParameters.Remove('Assignments') | Out-Null
        $CreateParameters.Remove('ForcePreSharedKeyUpdate') | Out-Null

        if ($CreateParameters['proxyAutomaticConfigurationUrl'] -eq '')
        {
            $CreateParameters['proxyAutomaticConfigurationUrl'] = $null
        }

        #region resource generator code
        $CreateParameters.Add('@odata.type', '#microsoft.graph.macOSWiFiConfiguration')
        $policy = New-MgBetaDeviceManagementDeviceConfiguration -BodyParameter $CreateParameters
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments

        if ($policy.Id)
        {
            Update-DeviceConfigurationPolicyAssignment `
                -DeviceConfigurationPolicyId $policy.Id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/deviceConfigurations'
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Wifi Configuration Policy for MacOS with Id {$($currentInstance.Id)} and DisplayName {$DisplayName}"
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $BoundParameters
        $UpdateParameters.Remove('Assignments') | Out-Null
        $UpdateParameters.Remove('ForcePreSharedKeyUpdate') | Out-Null
        $UpdateParameters.Remove('Id') | Out-Null

        if ($UpdateParameters['proxyAutomaticConfigurationUrl'] -eq '')
        {
            $UpdateParameters['proxyAutomaticConfigurationUrl'] = $null
        }

        #region resource generator code
        $UpdateParameters.Add('@odata.type', '#microsoft.graph.macOSWiFiConfiguration')
        Update-MgBetaDeviceManagementDeviceConfiguration -BodyParameter $UpdateParameters `
            -DeviceConfigurationId $currentInstance.Id
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceConfigurationPolicyAssignment `
            -DeviceConfigurationPolicyId $currentInstance.Id `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/deviceConfigurations'
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Wifi Configuration Policy for MacOS with Id {$($currentInstance.Id)} and DisplayName {$DisplayName}"
        #region resource generator code
        Remove-MgBetaDeviceManagementDeviceConfiguration -DeviceConfigurationId $currentInstance.Id
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
        [System.Boolean]
        $ConnectAutomatically,

        [Parameter()]
        [System.Boolean]
        $ConnectWhenNetworkNameIsHidden,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceChannel', 'userChannel')]
        $DeploymentChannel,

        [Parameter()]
        [System.Boolean]
        $ForcePreSharedKeyUpdate,

        [Parameter()]
        [System.String]
        $NetworkName,

        [Parameter()]
        [System.String]
        $PreSharedKey,

        [Parameter()]
        [System.String]
        $ProxyAutomaticConfigurationUrl,

        [Parameter()]
        [System.String]
        $ProxyManualAddress,

        [Parameter()]
        [System.Int32]
        $ProxyManualPort,

        [Parameter()]
        [ValidateSet('none', 'manual', 'automatic')]
        [System.String]
        $ProxySettings,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $Ssid,

        [Parameter()]
        [ValidateSet('open', 'wpaPersonal', 'wpaEnterprise', 'wep', 'wpa2Personal', 'wpa2Enterprise')]
        [System.String]
        $WiFiSecurityType,

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

    Write-Verbose -Message "Testing the Intune Wifi Configuration policy for MacOS with Id {$Id} and DisplayName {$DisplayName}"

    if ($ProxySettings -ne 'automatic' -and $ProxyAutomaticConfigurationUrl -ne '')
    {
        throw 'ProxyAutomaticConfigurationUrl must be empty if ProxySettings is not "automatic".'
    }

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $compareParameters = Get-CompareParameters
    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '') `
        @compareParameters
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
        $baseFilter = "isof('microsoft.graph.macOSWiFiConfiguration')"
        if (-not [string]::IsNullOrEmpty($Filter))
        {
            $Filter = "($baseFilter) and ($Filter)"
        }
        else
        {
            $Filter = $baseFilter
        }
        [array]$getValue = Get-MgBetaDeviceManagementDeviceConfiguration -Filter $Filter -All -ErrorAction Stop
        #endregion

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

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('Assignments')

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

function Get-CompareParameters
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    return @{
        ExcludedProperties = @('PreSharedKey')
    }
}

Export-ModuleMember -Function @('*-TargetResource', 'Get-CompareParameters')
