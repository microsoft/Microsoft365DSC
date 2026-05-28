Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneVPNConfigurationPolicyIOS'

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
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $connectionName,

        [Parameter()]
        [ValidateSet('ciscoAnyConnect', 'pulseSecure', 'f5EdgeClient', 'dellSonicWallMobileConnect', 'checkPointCapsuleVpn', 'customVpn', 'ciscoIPSec', 'citrix', 'ciscoAnyConnectV2', 'paloAltoGlobalProtect', 'zscalerPrivateAccess', 'f5Access2018', 'citrixSso', 'paloAltoGlobalProtectV2', 'ikEv2', 'alwaysOn', 'microsoftTunnel', 'netMotionMobility', 'microsoftProtect')]
        [System.String]
        $connectionType,

        [Parameter()]
        [System.Boolean]
        $enableSplitTunneling,

        [Parameter()]
        [ValidateSet('certificate', 'usernameAndPassword', 'sharedSecret', 'derivedCredential', 'azureAD')]
        [System.String]
        $authenticationMethod,

        [Parameter()]
        [System.string[]]
        $safariDomains,

        [Parameter()]
        [System.string[]]
        $associatedDomains,

        [Parameter()]
        [System.string[]]
        $excludedDomains,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $proxyServer,

        [Parameter()]
        [System.Boolean]
        $optInToDeviceIdSharing,

        [Parameter()]
        [System.string[]]
        $excludeList, #not on https://learn.microsoft.com/en-us/graph/api/resources/intune-deviceconfig-applevpnconfiguration?view=graph-rest-beta , but property is in the object

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $server,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $customData,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $customKeyValueData,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $onDemandRules,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $targetedMobileApps,

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
        $AccessTokens,

        #latest updates
        [Parameter()]
        [System.UInt32]
        $version,

        [Parameter()]
        [System.String]
        $loginGroupOrDomain,

        [Parameter()]
        [System.String]
        $role,

        [Parameter()]
        [System.String]
        $realm,

        [Parameter()]
        [System.String]
        $identifier,

        [Parameter()]
        [System.Boolean]
        $enablePerApp,

        [Parameter()]
        [ValidateSet('notConfigured', 'appProxy', 'packetTunnel')]
        [System.String]
        $providerType,

        [Parameter()]
        [System.Boolean]
        $disableOnDemandUserOverride,

        [Parameter()]
        [System.Boolean]
        $disconnectOnIdle,

        [Parameter()]
        [System.UInt32]
        $disconnectOnIdleTimerInSeconds,

        [Parameter()]
        [System.String]
        $microsoftTunnelSiteId,

        [Parameter()]
        [System.String]
        $cloudName,

        [Parameter()]
        [System.Boolean]
        $strictEnforcement,

        [Parameter()]
        [System.String]
        $userDomain
    )

    Write-Verbose -Message "Getting configuration of the Intune VPN Policy for iOS with Id {$Id} and DisplayName {$DisplayName}"

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
                $getValue = Get-MgBetaDeviceManagementDeviceConfiguration -All -Filter "Id eq '$Id'" -ErrorAction SilentlyContinue
            }

            #region resource generator code
            if ($null -eq $getValue)
            {
                $getValue = Get-MgBetaDeviceManagementDeviceConfiguration -All -Filter "DisplayName eq '$($Displayname -replace "'", "''")' and isof('microsoft.graph.iosVpnConfiguration')" -ErrorAction SilentlyContinue
            }
            #endregion

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "No Intune VPN Policy for iOS with Id {$Id} was found"
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }
        $Id = $getValue.Id

        Write-Verbose -Message "An Intune VPN Policy for iOS with id {$Id} and DisplayName {$DisplayName} was found"

        $complexServer = $null
        if ($null -ne $getValue.server)
        {
            $complexServer = @{
                address = $getValue.server.address
                description = $getValue.server.description
                isDefaultServer = $getValue.server.isDefaultServer
            }
        }
        if ($complexServer.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexServer = $null
        }

        $complexProxyServer = $null
        if ($null -ne $getValue.proxyServer)
        {
            $complexProxyServer = @{
                automaticConfigurationScriptUrl = $getValue.proxyServer.automaticConfigurationScriptUrl
                address = $getValue.proxyServer.address
                port = $getValue.proxyServer.port
            }
        }
        if ($complexProxyServer.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexProxyServer = $null
        }

        $complexCustomData = @()
        foreach ($value in $getValue.customData)
        {
            $myCustomdata = [ordered]@{}
            $myCustomdata.Add('key', $value.key)
            $myCustomdata.Add('value', $value.value)
            if ($myCustomdata.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexCustomData += $myCustomdata
            }
        }

        $complexCustomKeyValueData = @()
        foreach ($value in $getValue.customKeyValueData)
        {
            $myCVdata = [ordered]@{}
            $myCVdata.Add('name', $value.name)
            $myCVdata.Add('value', $value.value)
            if ($myCVdata.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexCustomKeyValueData += $myCVdata
            }
        }

        $complexTargetedMobileApps = @()
        foreach ($value in $getValue.targetedMobileApps)
        {
            $myTMAdata = [ordered]@{}
            $myTMAdata.Add('name', $value.name)
            $myTMAdata.Add('publisher', $value.publisher)
            $myTMAdata.Add('appStoreUrl', $value.appStoreUrl)
            $myTMAdata.Add('appId', $value.appId)
            if ($myTMAdata.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexTargetedMobileApps += $myTMAdata
            }
        }

        $results = @{
            #region resource generator code
            Id                             = $getValue.Id
            Description                    = $getValue.Description
            DisplayName                    = $getValue.DisplayName
            RoleScopeTagIds                = $getValue.RoleScopeTagIds
            connectionName                 = $getValue.connectionName
            connectionType                 = $getValue.connectionType
            enableSplitTunneling           = $getValue.enableSplitTunneling
            authenticationMethod           = $getValue.authenticationMethod
            safariDomains                  = $getValue.safariDomains
            associatedDomains              = $getValue.associatedDomains
            excludedDomains                = $getValue.excludedDomains
            optInToDeviceIdSharing         = $getValue.optInToDeviceIdSharing
            excludeList                    = $getValue.excludeList
            server                         = [array]$complexServer
            customData                     = $complexCustomData #$getValue.customData
            customKeyValueData             = $complexCustomKeyValueData #$getValue.customKeyValueData
            onDemandRules                  = $getValue.onDemandRules
            proxyServer                    = [array]$complexProxyServer
            targetedMobileApps             = $complexTargetedMobileApps #$getValue.targetedMobileApps
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
            loginGroupOrDomain             = $getValue.loginGroupOrDomain
            role                           = $getValue.role
            realm                          = $getValue.realm
            identifier                     = $getValue.identifier
            enablePerApp                   = $getValue.enablePerApp
            providerType                   = $getValue.providerType
            disableOnDemandUserOverride    = $getValue.disableOnDemandUserOverride
            disconnectOnIdle               = $getValue.disconnectOnIdle
            disconnectOnIdleTimerInSeconds = $getValue.disconnectOnIdleTimerInSeconds
            microsoftTunnelSiteId          = $getValue.microsoftTunnelSiteId
            cloudName                      = $getValue.cloudName
            strictEnforcement              = $getValue.strictEnforcement
            userDomain                     = $getValue.userDomain

        }

        $assignmentsValues = Get-MgBetaDeviceManagementDeviceConfigurationAssignment -DeviceConfigurationId $Results.Id
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
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $connectionName,

        [Parameter()]
        [ValidateSet('ciscoAnyConnect', 'pulseSecure', 'f5EdgeClient', 'dellSonicWallMobileConnect', 'checkPointCapsuleVpn', 'customVpn', 'ciscoIPSec', 'citrix', 'ciscoAnyConnectV2', 'paloAltoGlobalProtect', 'zscalerPrivateAccess', 'f5Access2018', 'citrixSso', 'paloAltoGlobalProtectV2', 'ikEv2', 'alwaysOn', 'microsoftTunnel', 'netMotionMobility', 'microsoftProtect')]
        [System.String]
        $connectionType,

        [Parameter()]
        [System.Boolean]
        $enableSplitTunneling,

        [Parameter()]
        [ValidateSet('certificate', 'usernameAndPassword', 'sharedSecret', 'derivedCredential', 'azureAD')]
        [System.String]
        $authenticationMethod,

        [Parameter()]
        [System.string[]]
        $safariDomains,

        [Parameter()]
        [System.string[]]
        $associatedDomains,

        [Parameter()]
        [System.string[]]
        $excludedDomains,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $proxyServer,

        [Parameter()]
        [System.Boolean]
        $optInToDeviceIdSharing,

        [Parameter()]
        [System.string[]]
        $excludeList, #not on https://learn.microsoft.com/en-us/graph/api/resources/intune-deviceconfig-applevpnconfiguration?view=graph-rest-beta , but property is in the object

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $server,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $customData,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $customKeyValueData,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $onDemandRules,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $targetedMobileApps,

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
        $AccessTokens,

        #latest updates
        [Parameter()]
        [System.UInt32]
        $version,

        [Parameter()]
        [System.String]
        $loginGroupOrDomain,

        [Parameter()]
        [System.String]
        $role,

        [Parameter()]
        [System.String]
        $realm,

        [Parameter()]
        [System.String]
        $identifier,

        [Parameter()]
        [System.Boolean]
        $enablePerApp,

        [Parameter()]
        [ValidateSet('notConfigured', 'appProxy', 'packetTunnel')]
        [System.String]
        $providerType,

        [Parameter()]
        [System.Boolean]
        $disableOnDemandUserOverride,

        [Parameter()]
        [System.Boolean]
        $disconnectOnIdle,

        [Parameter()]
        [System.UInt32]
        $disconnectOnIdleTimerInSeconds,

        [Parameter()]
        [System.String]
        $microsoftTunnelSiteId,

        [Parameter()]
        [System.String]
        $cloudName,

        [Parameter()]
        [System.Boolean]
        $strictEnforcement,

        [Parameter()]
        [System.String]
        $userDomain
    )

    Write-Verbose -Message "Setting configuration of the Intune VPN Configuration Policy for iOS with Id {$Id} and DisplayName {$DisplayName}"

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

    if ($BoundParameters.ContainsKey('proxyServer') -and $proxyServer.Count -gt 0)
    {
        $BoundParameters.Remove('proxyServer') | Out-Null
        $BoundParameters.Add('proxyServer', $proxyServer[0])
    }
    if ($BoundParameters.ContainsKey('server') -and $server.Count -gt 0)
    {
        $BoundParameters.Remove('server') | Out-Null
        $BoundParameters.Add('server', $server[0])
    }
    if ($BoundParameters.ContainsKey('customKeyValueData'))
    {
        $BoundParameters.Remove('customKeyValueData') | Out-Null
        $newCustomKeyValueData = @()
        foreach ($item in $customKeyValueData)
        {
            $newCustomKeyValueData += @{
                '@odata.type' = '#microsoft.graph.keyValuePair'
                name = $item.name
                value = $item.value
            }
        }
        $BoundParameters.Add('customKeyValueData', $newCustomKeyValueData)
    }

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating {$DisplayName}"
        $BoundParameters.Remove('Assignments') | Out-Null
        $CreateParameters = ([Hashtable]$BoundParameters).Clone()
        $CreateParameters = Rename-M365DSCCimInstanceParameter -Properties $CreateParameters
        $CreateParameters.Remove('Id') | Out-Null

        #region resource generator code
        $CreateParameters.Add('@odata.type', '#microsoft.graph.iosVpnConfiguration')
        $policy = New-MgBetaDeviceManagementDeviceConfiguration -BodyParameter $CreateParameters
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments

        if ($policy.id)
        {
            Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $policy.id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/deviceConfigurations'
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating {$DisplayName}"

        $BoundParameters.Remove('Assignments') | Out-Null
        $UpdateParameters = ([Hashtable]$BoundParameters).Clone()
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters
        $UpdateParameters.Remove('Id') | Out-Null

        #region resource generator code
        $UpdateParameters.Add('@odata.type', '#microsoft.graph.iosVpnConfiguration')
        Update-MgBetaDeviceManagementDeviceConfiguration -BodyParameter $UpdateParameters `
            -DeviceConfigurationId $currentInstance.Id
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $currentInstance.Id `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/deviceConfigurations'
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing {$DisplayName}"
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
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $connectionName,

        [Parameter()]
        [ValidateSet('ciscoAnyConnect', 'pulseSecure', 'f5EdgeClient', 'dellSonicWallMobileConnect', 'checkPointCapsuleVpn', 'customVpn', 'ciscoIPSec', 'citrix', 'ciscoAnyConnectV2', 'paloAltoGlobalProtect', 'zscalerPrivateAccess', 'f5Access2018', 'citrixSso', 'paloAltoGlobalProtectV2', 'ikEv2', 'alwaysOn', 'microsoftTunnel', 'netMotionMobility', 'microsoftProtect')]
        [System.String]
        $connectionType,

        [Parameter()]
        [System.Boolean]
        $enableSplitTunneling,

        [Parameter()]
        [ValidateSet('certificate', 'usernameAndPassword', 'sharedSecret', 'derivedCredential', 'azureAD')]
        [System.String]
        $authenticationMethod,

        [Parameter()]
        [System.string[]]
        $safariDomains,

        [Parameter()]
        [System.string[]]
        $associatedDomains,

        [Parameter()]
        [System.string[]]
        $excludedDomains,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $proxyServer,

        [Parameter()]
        [System.Boolean]
        $optInToDeviceIdSharing,

        [Parameter()]
        [System.string[]]
        $excludeList, #not on https://learn.microsoft.com/en-us/graph/api/resources/intune-deviceconfig-applevpnconfiguration?view=graph-rest-beta , but property is in the object

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $server,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $customData,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $customKeyValueData,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $onDemandRules,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $targetedMobileApps,

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
        $AccessTokens,

        [Parameter()]
        [System.UInt32]
        $version,

        [Parameter()]
        [System.String]
        $loginGroupOrDomain,

        [Parameter()]
        [System.String]
        $role,

        [Parameter()]
        [System.String]
        $realm,

        [Parameter()]
        [System.String]
        $identifier,

        [Parameter()]
        [System.Boolean]
        $enablePerApp,

        [Parameter()]
        [ValidateSet('notConfigured', 'appProxy', 'packetTunnel')]
        [System.String]
        $providerType,

        [Parameter()]
        [System.Boolean]
        $disableOnDemandUserOverride,

        [Parameter()]
        [System.Boolean]
        $disconnectOnIdle,

        [Parameter()]
        [System.UInt32]
        $disconnectOnIdleTimerInSeconds,

        [Parameter()]
        [System.String]
        $microsoftTunnelSiteId,

        [Parameter()]
        [System.String]
        $cloudName,

        [Parameter()]
        [System.Boolean]
        $strictEnforcement,

        [Parameter()]
        [System.String]
        $userDomain
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
        $baseFilter = "isof('microsoft.graph.iosVpnConfiguration')"
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

            if ($null -ne $Results.server)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.server `
                    -CIMInstanceName 'MicrosoftGraphvpnServer' #MSFT_MicrosoftGraphVpnServer
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.server = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('server') | Out-Null
                }
            }

            if ($null -ne $Results.onDemandRules)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.onDemandRules `
                    -CIMInstanceName 'MSFT_DeviceManagementConfigurationPolicyVpnOnDemandRule' #MSFT_DeviceManagementConfigurationPolicyVpnOnDemandRule
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.onDemandRules = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('onDemandRules') | Out-Null
                }
            }

            if ($null -ne $Results.proxyServer)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.proxyServer `
                    -CIMInstanceName 'MSFT_MicrosoftvpnProxyServer'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.proxyServer = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('proxyServer') | Out-Null
                }
            }

            if ($null -ne $Results.customData)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.customData `
                    -CIMInstanceName 'MSFT_CustomData'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.customData = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('customData') | Out-Null
                }
            }

            if ($null -ne $Results.customKeyValueData)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.customKeyValueData `
                    -CIMInstanceName 'MSFT_customKeyValueData'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.customKeyValueData = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('customKeyValueData') | Out-Null
                }
            }

            if ($null -ne $Results.targetedMobileApps)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.targetedMobileApps `
                    -CIMInstanceName 'MSFT_targetedMobileApps'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.targetedMobileApps = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('targetedMobileApps') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('server', 'onDemandRules', 'proxyServer', 'customData', 'customKeyValueData', 'targetedMobileApps', 'Assignments')

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
