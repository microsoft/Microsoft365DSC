Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneDeviceConfigurationVpnPolicyWindows10'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AssociatedApps,

        [Parameter()]
        [ValidateSet('certificate', 'usernameAndPassword', 'customEapXml', 'derivedCredential')]
        [System.String]
        $AuthenticationMethod,

        [Parameter()]
        [ValidateSet('pulseSecure', 'f5EdgeClient', 'dellSonicWallMobileConnect', 'checkPointCapsuleVpn', 'automatic', 'ikEv2', 'l2tp', 'pptp', 'citrix', 'paloAltoGlobalProtect', 'ciscoAnyConnect', 'unknownFutureValue', 'microsoftTunnel')]
        [System.String]
        $ConnectionType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $CryptographySuite,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DnsRules,

        [Parameter()]
        [System.String[]]
        $DnsSuffixes,

        [Parameter()]
        [System.String]
        $EapXml,

        [Parameter()]
        [System.Boolean]
        $EnableAlwaysOn,

        [Parameter()]
        [System.Boolean]
        $EnableConditionalAccess,

        [Parameter()]
        [System.Boolean]
        $EnableDeviceTunnel,

        [Parameter()]
        [System.Boolean]
        $EnableDnsRegistration,

        [Parameter()]
        [System.Boolean]
        $EnableSingleSignOnWithAlternateCertificate,

        [Parameter()]
        [System.Boolean]
        $EnableSplitTunneling,

        [Parameter()]
        [System.String]
        $MicrosoftTunnelSiteId,

        [Parameter()]
        [System.Boolean]
        $OnlyAssociatedAppsCanUseConnection,

        [Parameter()]
        [ValidateSet('user', 'device', 'autoPilotDevice')]
        [System.String]
        $ProfileTarget,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ProxyServer,

        [Parameter()]
        [System.Boolean]
        $RememberUserCredentials,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Routes,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $SingleSignOnEku,

        [Parameter()]
        [System.String]
        $SingleSignOnIssuerHash,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $TrafficRules,

        [Parameter()]
        [System.String[]]
        $TrustedNetworkDomains,

        [Parameter()]
        [System.String]
        $WindowsInformationProtectionDomain,

        [Parameter()]
        [System.String]
        $ConnectionName,

        [Parameter()]
        [System.String]
        $CustomXml,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ServerCollection,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

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

    Write-Verbose -Message "Getting configuration of the Intune Device Configuration Vpn Policy for Windows10 with Id {$Id} and DisplayName {$DisplayName}"

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
            if (-not [string]::IsNullOrEmpty($Id))
            {
                $getValue = Get-MgBetaDeviceManagementDeviceConfiguration -All -Filter "Id eq '$Id'" -ErrorAction SilentlyContinue
            }

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Device Configuration Vpn Policy for Windows10 with Id {$Id}"

                if (-not [string]::IsNullOrEmpty($DisplayName))
                {
                    $getValue = Get-MgBetaDeviceManagementDeviceConfiguration `
                        -All `
                        -Filter "DisplayName eq '$($DisplayName -replace "'", "''")' and isof('microsoft.graph.windows10VpnConfiguration')" `
                        -ErrorAction SilentlyContinue
                }
            }
            #endregion
            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Device Configuration Vpn Policy for Windows10 with DisplayName {$DisplayName}"
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Device Configuration Vpn Policy for Windows10 with Id {$Id} and DisplayName {$DisplayName} was found."

        #region resource generator code
        $complexAssociatedApps = @()
        foreach ($currentassociatedApps in $getValue.associatedApps)
        {
            $myassociatedApps = [ordered]@{}
            if ($null -ne $currentassociatedApps.appType)
            {
                $myassociatedApps.Add('AppType', $currentassociatedApps.appType.ToString())
            }
            $myassociatedApps.Add('Identifier', $currentassociatedApps.identifier)
            if ($myassociatedApps.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexAssociatedApps += $myassociatedApps
            }
        }

        $complexCryptographySuite = [ordered]@{}
        if ($null -ne $getValue.cryptographySuite.authenticationTransformConstants)
        {
            $complexCryptographySuite.Add('AuthenticationTransformConstants', $getValue.cryptographySuite.authenticationTransformConstants.ToString())
        }
        if ($null -ne $getValue.cryptographySuite.cipherTransformConstants)
        {
            $complexCryptographySuite.Add('CipherTransformConstants', $getValue.cryptographySuite.cipherTransformConstants.ToString())
        }
        if ($null -ne $getValue.cryptographySuite.dhGroup)
        {
            $complexCryptographySuite.Add('DhGroup', $getValue.cryptographySuite.dhGroup.ToString())
        }
        if ($null -ne $getValue.cryptographySuite.encryptionMethod)
        {
            $complexCryptographySuite.Add('EncryptionMethod', $getValue.cryptographySuite.encryptionMethod.ToString())
        }
        if ($null -ne $getValue.cryptographySuite.integrityCheckMethod)
        {
            $complexCryptographySuite.Add('IntegrityCheckMethod', $getValue.cryptographySuite.integrityCheckMethod.ToString())
        }
        if ($null -ne $getValue.cryptographySuite.pfsGroup)
        {
            $complexCryptographySuite.Add('PfsGroup', $getValue.cryptographySuite.pfsGroup.ToString())
        }
        if ($complexCryptographySuite.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexCryptographySuite = $null
        }

        $complexDnsRules = @()
        foreach ($currentdnsRules in $getValue.dnsRules)
        {
            $mydnsRules = [ordered]@{}
            $mydnsRules.Add('AutoTrigger', $currentdnsRules.autoTrigger)
            $mydnsRules.Add('Name', $currentdnsRules.name)
            $mydnsRules.Add('Persistent', $currentdnsRules.persistent)
            $mydnsRules.Add('ProxyServerUri', $currentdnsRules.proxyServerUri)
            $mydnsRules.Add('Servers', $currentdnsRules.servers)
            if ($mydnsRules.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexDnsRules += $mydnsRules
            }
        }

        $complexProxyServer = [ordered]@{}
        $complexProxyServer.Add('BypassProxyServerForLocalAddress', $getValue.proxyServer.bypassProxyServerForLocalAddress)
        $complexProxyServer.Add('Address', $getValue.proxyServer.address)
        $complexProxyServer.Add('AutomaticConfigurationScriptUrl', $getValue.proxyServer.automaticConfigurationScriptUrl)
        $complexProxyServer.Add('Port', $getValue.proxyServer.port)
        $complexProxyServer.Add('AutomaticallyDetectProxySettings', $getValue.proxyServer.automaticallyDetectProxySettings)
        if ($null -ne $getValue.proxyServer.'@odata.type')
        {
            $complexProxyServer.Add('odataType', $getValue.proxyServer.'@odata.type'.ToString())
        }
        if ($complexProxyServer.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexProxyServer = $null
        }

        $complexRoutes = @()
        foreach ($currentroutes in $getValue.routes)
        {
            $myroutes = [ordered]@{}
            $myroutes.Add('DestinationPrefix', $currentroutes.destinationPrefix)
            $myroutes.Add('PrefixSize', $currentroutes.prefixSize)
            if ($myroutes.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexRoutes += $myroutes
            }
        }

        $complexSingleSignOnEku = [ordered]@{}
        $complexSingleSignOnEku.Add('Name', $getValue.singleSignOnEku.name)
        $complexSingleSignOnEku.Add('ObjectIdentifier', $getValue.singleSignOnEku.objectIdentifier)
        if ($complexSingleSignOnEku.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexSingleSignOnEku = $null
        }

        $complexTrafficRules = @()
        foreach ($currenttrafficRules in $getValue.trafficRules)
        {
            $mytrafficRules = [ordered]@{}
            $mytrafficRules.Add('AppId', $currenttrafficRules.appId)
            if ($null -ne $currenttrafficRules.appType)
            {
                $mytrafficRules.Add('AppType', $currenttrafficRules.appType.ToString())
            }
            $mytrafficRules.Add('Claims', $currenttrafficRules.claims)
            $complexLocalAddressRanges = @()
            foreach ($currentLocalAddressRanges in $currenttrafficRules.localAddressRanges)
            {
                $myLocalAddressRanges = [ordered]@{}
                $myLocalAddressRanges.Add('LowerAddress', $currentLocalAddressRanges.lowerAddress)
                $myLocalAddressRanges.Add('UpperAddress', $currentLocalAddressRanges.upperAddress)
                $myLocalAddressRanges.Add('CidrAddress', $currentLocalAddressRanges.cidrAddress)
                if ($null -ne $currentLocalAddressRanges.'@odata.type')
                {
                    $myLocalAddressRanges.Add('odataType', $currentLocalAddressRanges.'@odata.type'.ToString())
                }
                if ($myLocalAddressRanges.values.Where({ $null -ne $_ }).Count -gt 0)
                {
                    $complexLocalAddressRanges += $myLocalAddressRanges
                }
            }
            $mytrafficRules.Add('LocalAddressRanges', $complexLocalAddressRanges)
            $complexLocalPortRanges = @()
            foreach ($currentLocalPortRanges in $currenttrafficRules.localPortRanges)
            {
                $myLocalPortRanges = [ordered]@{}
                $myLocalPortRanges.Add('LowerNumber', $currentLocalPortRanges.lowerNumber)
                $myLocalPortRanges.Add('UpperNumber', $currentLocalPortRanges.upperNumber)
                if ($myLocalPortRanges.values.Where({ $null -ne $_ }).Count -gt 0)
                {
                    $complexLocalPortRanges += $myLocalPortRanges
                }
            }
            $mytrafficRules.Add('LocalPortRanges', $complexLocalPortRanges)
            $mytrafficRules.Add('Name', $currenttrafficRules.name)
            $mytrafficRules.Add('Protocols', $currenttrafficRules.protocols)
            $complexRemoteAddressRanges = @()
            foreach ($currentRemoteAddressRanges in $currenttrafficRules.remoteAddressRanges)
            {
                $myRemoteAddressRanges = [ordered]@{}
                $myRemoteAddressRanges.Add('LowerAddress', $currentRemoteAddressRanges.lowerAddress)
                $myRemoteAddressRanges.Add('UpperAddress', $currentRemoteAddressRanges.upperAddress)
                $myRemoteAddressRanges.Add('CidrAddress', $currentRemoteAddressRanges.cidrAddress)
                if ($null -ne $currentRemoteAddressRanges.'@odata.type')
                {
                    $myRemoteAddressRanges.Add('odataType', $currentRemoteAddressRanges.'@odata.type'.ToString())
                }
                if ($myRemoteAddressRanges.values.Where({ $null -ne $_ }).Count -gt 0)
                {
                    $complexRemoteAddressRanges += $myRemoteAddressRanges
                }
            }
            $mytrafficRules.Add('RemoteAddressRanges', $complexRemoteAddressRanges)
            $complexRemotePortRanges = @()
            foreach ($currentRemotePortRanges in $currenttrafficRules.remotePortRanges)
            {
                $myRemotePortRanges = [ordered]@{}
                $myRemotePortRanges.Add('LowerNumber', $currentRemotePortRanges.lowerNumber)
                $myRemotePortRanges.Add('UpperNumber', $currentRemotePortRanges.upperNumber)
                if ($myRemotePortRanges.values.Where({ $null -ne $_ }).Count -gt 0)
                {
                    $complexRemotePortRanges += $myRemotePortRanges
                }
            }
            $mytrafficRules.Add('RemotePortRanges', $complexRemotePortRanges)
            if ($null -ne $currenttrafficRules.routingPolicyType)
            {
                $mytrafficRules.Add('RoutingPolicyType', $currenttrafficRules.routingPolicyType.ToString())
            }
            if ($null -ne $currenttrafficRules.vpnTrafficDirection)
            {
                $mytrafficRules.Add('VpnTrafficDirection', $currenttrafficRules.vpnTrafficDirection.ToString())
            }
            if ($mytrafficRules.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexTrafficRules += $mytrafficRules
            }
        }

        $complexServers = @()
        foreach ($currentservers in $getValue.servers)
        {
            $myservers = [ordered]@{}
            $myservers.Add('Address', $currentservers.address)
            $myservers.Add('Description', $currentservers.description)
            $myservers.Add('IsDefaultServer', $currentservers.isDefaultServer)
            if ($myservers.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexServers += $myservers
            }
        }
        #endregion

        #region resource generator code
        $enumAuthenticationMethod = $null
        if ($null -ne $getValue.authenticationMethod)
        {
            $enumAuthenticationMethod = $getValue.authenticationMethod.ToString()
        }

        $enumConnectionType = $null
        if ($null -ne $getValue.connectionType)
        {
            $enumConnectionType = $getValue.connectionType.ToString()
        }

        $enumProfileTarget = $null
        if ($null -ne $getValue.profileTarget)
        {
            $enumProfileTarget = $getValue.profileTarget.ToString()
        }
        #endregion

        $results = @{
            #region resource generator code
            AssociatedApps                             = $complexAssociatedApps
            AuthenticationMethod                       = $enumAuthenticationMethod
            ConnectionType                             = $enumConnectionType
            CryptographySuite                          = $complexCryptographySuite
            DnsRules                                   = $complexDnsRules
            DnsSuffixes                                = $getValue.dnsSuffixes
            EapXml                                     = $getValue.eapXml
            EnableAlwaysOn                             = $getValue.enableAlwaysOn
            EnableConditionalAccess                    = $getValue.enableConditionalAccess
            EnableDeviceTunnel                         = $getValue.enableDeviceTunnel
            EnableDnsRegistration                      = $getValue.enableDnsRegistration
            EnableSingleSignOnWithAlternateCertificate = $getValue.enableSingleSignOnWithAlternateCertificate
            EnableSplitTunneling                       = $getValue.enableSplitTunneling
            MicrosoftTunnelSiteId                      = $getValue.microsoftTunnelSiteId
            OnlyAssociatedAppsCanUseConnection         = $getValue.onlyAssociatedAppsCanUseConnection
            ProfileTarget                              = $enumProfileTarget
            ProxyServer                                = $complexProxyServer
            RememberUserCredentials                    = $getValue.rememberUserCredentials
            Routes                                     = $complexRoutes
            SingleSignOnEku                            = $complexSingleSignOnEku
            SingleSignOnIssuerHash                     = $getValue.singleSignOnIssuerHash
            TrafficRules                               = $complexTrafficRules
            TrustedNetworkDomains                      = $getValue.trustedNetworkDomains
            WindowsInformationProtectionDomain         = $getValue.windowsInformationProtectionDomain
            ConnectionName                             = $getValue.connectionName
            CustomXml                                  = $getValue.customXml
            ServerCollection                           = $complexServers
            Description                                = $getValue.Description
            DisplayName                                = $getValue.DisplayName
            Id                                         = $getValue.Id
            RoleScopeTagIds                            = $getValue.RoleScopeTagIds
            Ensure                                     = 'Present'
            Credential                                 = $Credential
            ApplicationId                              = $ApplicationId
            TenantId                                   = $TenantId
            ApplicationSecret                          = $ApplicationSecret
            CertificateThumbprint                      = $CertificateThumbprint
            CertificatePath                            = $CertificatePath
            CertificatePassword                        = $CertificatePassword
            ManagedIdentity                            = $ManagedIdentity.IsPresent
            AccessTokens                               = $AccessTokens
            #endregion
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
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AssociatedApps,

        [Parameter()]
        [ValidateSet('certificate', 'usernameAndPassword', 'customEapXml', 'derivedCredential')]
        [System.String]
        $AuthenticationMethod,

        [Parameter()]
        [ValidateSet('pulseSecure', 'f5EdgeClient', 'dellSonicWallMobileConnect', 'checkPointCapsuleVpn', 'automatic', 'ikEv2', 'l2tp', 'pptp', 'citrix', 'paloAltoGlobalProtect', 'ciscoAnyConnect', 'unknownFutureValue', 'microsoftTunnel')]
        [System.String]
        $ConnectionType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $CryptographySuite,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DnsRules,

        [Parameter()]
        [System.String[]]
        $DnsSuffixes,

        [Parameter()]
        [System.String]
        $EapXml,

        [Parameter()]
        [System.Boolean]
        $EnableAlwaysOn,

        [Parameter()]
        [System.Boolean]
        $EnableConditionalAccess,

        [Parameter()]
        [System.Boolean]
        $EnableDeviceTunnel,

        [Parameter()]
        [System.Boolean]
        $EnableDnsRegistration,

        [Parameter()]
        [System.Boolean]
        $EnableSingleSignOnWithAlternateCertificate,

        [Parameter()]
        [System.Boolean]
        $EnableSplitTunneling,

        [Parameter()]
        [System.String]
        $MicrosoftTunnelSiteId,

        [Parameter()]
        [System.Boolean]
        $OnlyAssociatedAppsCanUseConnection,

        [Parameter()]
        [ValidateSet('user', 'device', 'autoPilotDevice')]
        [System.String]
        $ProfileTarget,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ProxyServer,

        [Parameter()]
        [System.Boolean]
        $RememberUserCredentials,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Routes,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $SingleSignOnEku,

        [Parameter()]
        [System.String]
        $SingleSignOnIssuerHash,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $TrafficRules,

        [Parameter()]
        [System.String[]]
        $TrustedNetworkDomains,

        [Parameter()]
        [System.String]
        $WindowsInformationProtectionDomain,

        [Parameter()]
        [System.String]
        $ConnectionName,

        [Parameter()]
        [System.String]
        $CustomXml,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ServerCollection,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

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
    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $keyToRename = @{
        'odataType'        = '@odata.type'
        'ServerCollection' = 'servers'
    }
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Device Configuration Vpn Policy for Windows10 with DisplayName {$DisplayName}"
        $BoundParameters.Remove('Assignments') | Out-Null

        $CreateParameters = ([Hashtable]$BoundParameters).Clone()
        $CreateParameters = Rename-M365DSCCimInstanceParameter -Properties $CreateParameters -KeyMapping $keyToRename
        $CreateParameters.Remove('Id') | Out-Null

        #region resource generator code
        $CreateParameters.Add('@odata.type', '#microsoft.graph.windows10VpnConfiguration')
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
        Write-Verbose -Message "Updating the Intune Device Configuration Vpn Policy for Windows10 with Id {$($currentInstance.Id)}"
        $BoundParameters.Remove('Assignments') | Out-Null

        $UpdateParameters = ([Hashtable]$BoundParameters).Clone()
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters -KeyMapping $keyToRename
        $UpdateParameters.Remove('Id') | Out-Null

        #region resource generator code
        $UpdateParameters.Add('@odata.type', '#microsoft.graph.windows10VpnConfiguration')
        Update-MgBetaDeviceManagementDeviceConfiguration `
            -DeviceConfigurationId $currentInstance.Id `
            -BodyParameter $UpdateParameters
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceConfigurationPolicyAssignment `
            -DeviceConfigurationPolicyId $currentInstance.id `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/deviceConfigurations'
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Device Configuration Vpn Policy for Windows10 with Id {$($currentInstance.Id)}"
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
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AssociatedApps,

        [Parameter()]
        [ValidateSet('certificate', 'usernameAndPassword', 'customEapXml', 'derivedCredential')]
        [System.String]
        $AuthenticationMethod,

        [Parameter()]
        [ValidateSet('pulseSecure', 'f5EdgeClient', 'dellSonicWallMobileConnect', 'checkPointCapsuleVpn', 'automatic', 'ikEv2', 'l2tp', 'pptp', 'citrix', 'paloAltoGlobalProtect', 'ciscoAnyConnect', 'unknownFutureValue', 'microsoftTunnel')]
        [System.String]
        $ConnectionType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $CryptographySuite,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DnsRules,

        [Parameter()]
        [System.String[]]
        $DnsSuffixes,

        [Parameter()]
        [System.String]
        $EapXml,

        [Parameter()]
        [System.Boolean]
        $EnableAlwaysOn,

        [Parameter()]
        [System.Boolean]
        $EnableConditionalAccess,

        [Parameter()]
        [System.Boolean]
        $EnableDeviceTunnel,

        [Parameter()]
        [System.Boolean]
        $EnableDnsRegistration,

        [Parameter()]
        [System.Boolean]
        $EnableSingleSignOnWithAlternateCertificate,

        [Parameter()]
        [System.Boolean]
        $EnableSplitTunneling,

        [Parameter()]
        [System.String]
        $MicrosoftTunnelSiteId,

        [Parameter()]
        [System.Boolean]
        $OnlyAssociatedAppsCanUseConnection,

        [Parameter()]
        [ValidateSet('user', 'device', 'autoPilotDevice')]
        [System.String]
        $ProfileTarget,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ProxyServer,

        [Parameter()]
        [System.Boolean]
        $RememberUserCredentials,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Routes,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $SingleSignOnEku,

        [Parameter()]
        [System.String]
        $SingleSignOnIssuerHash,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $TrafficRules,

        [Parameter()]
        [System.String[]]
        $TrustedNetworkDomains,

        [Parameter()]
        [System.String]
        $WindowsInformationProtectionDomain,

        [Parameter()]
        [System.String]
        $ConnectionName,

        [Parameter()]
        [System.String]
        $CustomXml,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ServerCollection,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

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
        $baseFilter = "isof('microsoft.graph.windows10VpnConfiguration')"
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

            $displayedKey = $config.Id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
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
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params
            if ($null -ne $Results.AssociatedApps)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.AssociatedApps `
                    -CIMInstanceName 'MicrosoftGraphwindows10AssociatedApps'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.AssociatedApps = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('AssociatedApps') | Out-Null
                }
            }
            if ($null -ne $Results.CryptographySuite)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.CryptographySuite `
                    -CIMInstanceName 'MicrosoftGraphcryptographySuite'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.CryptographySuite = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('CryptographySuite') | Out-Null
                }
            }
            if ($null -ne $Results.DnsRules)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.DnsRules `
                    -CIMInstanceName 'MicrosoftGraphvpnDnsRule'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.DnsRules = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('DnsRules') | Out-Null
                }
            }
            if ($null -ne $Results.ProxyServer)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.ProxyServer `
                    -CIMInstanceName 'MicrosoftGraphwindows10VpnProxyServer'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.ProxyServer = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('ProxyServer') | Out-Null
                }
            }
            if ($null -ne $Results.Routes)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.Routes `
                    -CIMInstanceName 'MicrosoftGraphvpnRoute'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.Routes = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Routes') | Out-Null
                }
            }
            if ($null -ne $Results.SingleSignOnEku)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.SingleSignOnEku `
                    -CIMInstanceName 'MicrosoftGraphextendedKeyUsage'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.SingleSignOnEku = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('SingleSignOnEku') | Out-Null
                }
            }
            if ($null -ne $Results.TrafficRules)
            {
                $complexMapping = @(
                    @{
                        Name            = 'TrafficRules'
                        CimInstanceName = 'MicrosoftGraphVpnTrafficRule'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'LocalAddressRanges'
                        CimInstanceName = 'MicrosoftGraphIPv4Range'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'LocalPortRanges'
                        CimInstanceName = 'MicrosoftGraphNumberRange'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'RemoteAddressRanges'
                        CimInstanceName = 'MicrosoftGraphIPv4Range'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'RemotePortRanges'
                        CimInstanceName = 'MicrosoftGraphNumberRange'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.TrafficRules `
                    -CIMInstanceName 'MicrosoftGraphvpnTrafficRule' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.TrafficRules = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('TrafficRules') | Out-Null
                }
            }
            if ($null -ne $Results.ServerCollection)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.ServerCollection `
                    -CIMInstanceName 'MicrosoftGraphvpnServer'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.ServerCollection = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('ServerCollection') | Out-Null
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
                -Credential $Credential `
                -NoEscape @('AssociatedApps', 'CryptographySuite', 'DnsRules', 'ProxyServer', 'Routes',
                'SingleSignOnEku', 'TrafficRules', 'ServerCollection', 'Assignments')

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

Export-ModuleMember -Function *-TargetResource, *
