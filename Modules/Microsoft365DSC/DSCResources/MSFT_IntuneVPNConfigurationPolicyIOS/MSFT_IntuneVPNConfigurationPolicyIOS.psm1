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
                $getValue = Get-MgBetaDeviceManagementDeviceConfiguration -All -Filter "DisplayName eq '$($Displayname -replace "'", "''")'" -ErrorAction SilentlyContinue | Where-Object `
                    -FilterScript {
                        $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.iosVpnConfiguration' `
                    }
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

        $complexServers = @()
        foreach ($currentservers in $getValue.AdditionalProperties.server)
        {
            $myservers = [ordered]@{}
            $myservers.Add('address', $currentservers.address)
            $myservers.Add('description', $currentservers.description)
            $myservers.Add('isDefaultServer', $currentservers.isDefaultServer)
            if ($myservers.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexServers += $myservers
            }
        }

        $complexProxyServers = @()
        foreach ($currentservers in $getValue.AdditionalProperties.proxyServer)
        {
            $myservers = [ordered]@{}
            $myservers.Add('automaticConfigurationScriptUrl', $currentservers.automaticConfigurationScriptUrl)
            $myservers.Add('address', $currentservers.address)
            $myservers.Add('port', $currentservers.port)
            if ($myservers.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexProxyServers += $myservers
            }
        }

        $complexCustomData = @()
        foreach ($value in $getValue.AdditionalProperties.customData)
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
        foreach ($value in $getValue.AdditionalProperties.customKeyValueData)
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
        foreach ($value in $getValue.AdditionalProperties.targetedMobileApps)
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
            connectionName                 = $getValue.AdditionalProperties.connectionName
            connectionType                 = $getValue.AdditionalProperties.connectionType
            enableSplitTunneling           = $getValue.AdditionalProperties.enableSplitTunneling
            authenticationMethod           = $getValue.AdditionalProperties.authenticationMethod
            safariDomains                  = $getValue.AdditionalProperties.safariDomains
            associatedDomains              = $getValue.AdditionalProperties.associatedDomains
            excludedDomains                = $getValue.AdditionalProperties.excludedDomains
            optInToDeviceIdSharing         = $getValue.AdditionalProperties.optInToDeviceIdSharing
            excludeList                    = $getValue.AdditionalProperties.excludeList
            server                         = $complexServers
            customData                     = $complexCustomData #$getValue.AdditionalProperties.customData
            customKeyValueData             = $complexCustomKeyValueData #$getValue.AdditionalProperties.customKeyValueData
            onDemandRules                  = $getValue.AdditionalProperties.onDemandRules
            proxyServer                    = $complexProxyServers
            targetedMobileApps             = $complexTargetedMobileApps #$getValue.AdditionalProperties.targetedMobileApps
            Ensure                         = 'Present'
            Credential                     = $Credential
            ApplicationId                  = $ApplicationId
            TenantId                       = $TenantId
            ApplicationSecret              = $ApplicationSecret
            CertificateThumbprint          = $CertificateThumbprint
            ManagedIdentity                = $ManagedIdentity.IsPresent
            AccessTokens                   = $AccessTokens
            version                        = $getValue.AdditionalProperties.version
            loginGroupOrDomain             = $getValue.AdditionalProperties.loginGroupOrDomain
            role                           = $getValue.AdditionalProperties.role
            realm                          = $getValue.AdditionalProperties.realm
            identifier                     = $getValue.AdditionalProperties.identifier
            enablePerApp                   = $getValue.AdditionalProperties.enablePerApp
            providerType                   = $getValue.AdditionalProperties.providerType
            disableOnDemandUserOverride    = $getValue.AdditionalProperties.disableOnDemandUserOverride
            disconnectOnIdle               = $getValue.AdditionalProperties.disconnectOnIdle
            disconnectOnIdleTimerInSeconds = $getValue.AdditionalProperties.disconnectOnIdleTimerInSeconds
            microsoftTunnelSiteId          = $getValue.AdditionalProperties.microsoftTunnelSiteId
            cloudName                      = $getValue.AdditionalProperties.cloudName
            strictEnforcement              = $getValue.AdditionalProperties.strictEnforcement
            userDomain                     = $getValue.AdditionalProperties.userDomain

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

    #proxy and server values need converting before new- / update- cmdlets will accept parameters
    #creating hashtables now for use later in both present/present and present/absent blocks
    $allTargetValues = Convert-M365DscHashtableToString -Hashtable $BoundParameters

    if ($allTargetValues -match '\bserver=\(\{([^\)]+)\}\)')
    {
        $serverBlock = $matches[1]
    }

    $serverHashtable = @{}
    $serverBlock -split ';' | ForEach-Object {
        if ($_ -match '^(.*?)=(.*)$')
        {
            $key = $matches[1].Trim()
            $value = $matches[2].Trim()
            $serverHashtable[$key] = $value
        }
    }
    if ($allTargetValues -match '\bproxyServer=\(\{([^\)]+)\}\)')
    {
        $proxyBlock = $matches[1]
    }

    $proxyHashtable = @{}
    $proxyBlock -split ';' | ForEach-Object {
        if ($_ -match '^(.*?)=(.*)$')
        {
            $key = $matches[1].Trim()
            $value = $matches[2].Trim()
            $proxyHashtable[$key] = $value
        }
    }

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating {$DisplayName}"
        $BoundParameters.Remove('Assignments') | Out-Null
        $CreateParameters = ([Hashtable]$BoundParameters).Clone()
        $CreateParameters = Rename-M365DSCCimInstanceParameter -Properties $CreateParameters
        $AdditionalProperties = Get-M365DSCAdditionalProperties -Properties ($CreateParameters)

        foreach ($key in $AdditionalProperties.keys)
        {
            if ($key -ne '@odata.type')
            {
                $keyName = $key.Substring(0, 1).ToUpper() + $key.Substring(1, $key.Length - 1)
                $CreateParameters.Remove($keyName)
            }
        }
        $CreateParameters.Remove('Id') | Out-Null

        if ($AdditionalProperties.server)
        {
            $AdditionalProperties.Remove('server') #this is not in a format Update-MgBetaDeviceManagementDeviceConfiguration will accept
            $AdditionalProperties.Add('server', $serverHashtable) #replaced with the hashtable we created earlier
        }
        if ($AdditionalProperties.proxyServer)
        {
            $AdditionalProperties.Remove('proxyServer') #this is not in a format Update-MgBetaDeviceManagementDeviceConfiguration will accept
            $AdditionalProperties.Add('proxyServer', $proxyHashtable) #replaced with the hashtable we created earlier
        }

        $CreateParameters.Add('AdditionalProperties', $AdditionalProperties)

        #region resource generator code
        $policy = New-MgBetaDeviceManagementDeviceConfiguration @CreateParameters
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
        $AdditionalProperties = Get-M365DSCAdditionalProperties -Properties ($UpdateParameters)

        foreach ($key in $AdditionalProperties.keys)
        {
            if ($key -ne '@odata.type')
            {
                $keyName = $key.Substring(0, 1).ToUpper() + $key.Substring(1, $key.Length - 1)
                $UpdateParameters.Remove($keyName)
            }
        }
        $UpdateParameters.Remove('Id') | Out-Null

        if ($AdditionalProperties)
        {

            if ($AdditionalProperties.server)
            {
                $AdditionalProperties.Remove('server') #this is not in a format Update-MgBetaDeviceManagementDeviceConfiguration will accept
                $AdditionalProperties.Add('server', $serverHashtable) #replaced with the hashtable we created earlier
            }
            if ($AdditionalProperties.proxyServer)
            {
                $AdditionalProperties.Remove('proxyServer') #this is not in a format Update-MgBetaDeviceManagementDeviceConfiguration will accept
                $AdditionalProperties.Add('proxyServer', $proxyHashtable) #replaced with the hashtable we created earlier
            }

            #add the additional properties to the updateparameters
            $UpdateParameters.Add('AdditionalProperties', $AdditionalProperties)
        }

        #region resource generator code
        Update-MgBetaDeviceManagementDeviceConfiguration @UpdateParameters `
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
        [array]$getValue = Get-MgBetaDeviceManagementDeviceConfiguration -Filter $Filter -All `
            -ErrorAction Stop | Where-Object `
            -FilterScript {
                $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.iosVpnConfiguration' `
        }
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

function Get-M365DSCAdditionalProperties
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Properties
    )

    $additionalProperties = @(
        'connectionName'
        'connectionType'
        'enableSplitTunneling'
        'authenticationMethod'
        'enablePerApp'
        'safariDomains'
        'associatedDomains'
        'excludedDomains'
        'disableOnDemandUserOverride'
        'disconnectOnIdle'
        'proxyServer'
        'optInToDeviceIdSharing'
        'excludeList'
        'microsoftTunnelSiteId'
        'server'
        'customData'
        'customKeyValueData'
        'onDemandRules'
        'targetedMobileApps'
        'version'
        'loginGroupOrDomain'
        'role'
        'realm'
        'identifier'
        'providerType'
        'disconnectOnIdleTimerInSeconds'
        'cloudName'
        'strictEnforcement'
        'userDomain'
    )

    $results = @{'@odata.type' = '#microsoft.graph.iosVpnConfiguration' }
    $cloneProperties = $Properties.Clone()
    foreach ($property in $cloneProperties.Keys)
    {
        if ($property -in ($additionalProperties) )
        {
            $propertyName = $property[0].ToString().ToLower() + $property.Substring(1, $property.Length - 1)
            if ($properties.$property -and $properties.$property.GetType().FullName -like '*CIMInstance*')
            {
                if ($properties.$property.GetType().FullName -like '*[[\]]')
                {
                    $array = @()
                    foreach ($item in $properties.$property)
                    {
                        $array += Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
                    }
                    $propertyValue = $array
                }
                else
                {
                    $propertyValue = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $properties.$property
                }

            }
            else
            {
                $propertyValue = $properties.$property
            }

            $results.Add($propertyName, $propertyValue)
        }
    }
    if ($results.Count -eq 1)
    {
        return $null
    }
    return $results
}

Export-ModuleMember -Function *-TargetResource
