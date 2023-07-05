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
        [ValidateSet('certificate','usernameAndPassword','customEapXml','derivedCredential')]
        [System.String]
        $AuthenticationMethod,

        [Parameter()]
        [ValidateSet('pulseSecure','f5EdgeClient','dellSonicWallMobileConnect','checkPointCapsuleVpn','automatic','ikEv2','l2tp','pptp','citrix','paloAltoGlobalProtect','ciscoAnyConnect','unknownFutureValue','microsoftTunnel')]
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
        [ValidateSet('user','device','autoPilotDevice')]
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
        $ManagedIdentity
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
        $getValue = Get-MgBetaDeviceManagementDeviceConfiguration -DeviceConfigurationId $Id  -ErrorAction SilentlyContinue

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Intune Device Configuration Vpn Policy for Windows10 with Id {$Id}"

            if (-Not [string]::IsNullOrEmpty($DisplayName))
            {
                $getValue = Get-MgBetaDeviceManagementDeviceConfiguration `
                    -Filter "DisplayName eq '$DisplayName'" `
                    -ErrorAction SilentlyContinue | Where-Object `
                    -FilterScript { `
                        $_.AdditionalProperties.'@odata.type' -eq "#microsoft.graph.windows10VpnConfiguration" `
                    }
            }
        }
        #endregion
        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Intune Device Configuration Vpn Policy for Windows10 with DisplayName {$DisplayName}"
            return $nullResult
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Device Configuration Vpn Policy for Windows10 with Id {$Id} and DisplayName {$DisplayName} was found."

        #region resource generator code
        $complexAssociatedApps = @()
        foreach ($currentassociatedApps in $getValue.AdditionalProperties.associatedApps)
        {
            $myassociatedApps = @{}
            if ($null -ne $currentassociatedApps.appType)
            {
                $myassociatedApps.Add('AppType', $currentassociatedApps.appType.toString())
            }
            $myassociatedApps.Add('Identifier', $currentassociatedApps.identifier)
            if ($myassociatedApps.values.Where({$null -ne $_}).count -gt 0)
            {
                $complexAssociatedApps += $myassociatedApps
            }
        }

        $complexCryptographySuite = @{}
        if ($null -ne $getValue.AdditionalProperties.cryptographySuite.authenticationTransformConstants)
        {
            $complexCryptographySuite.Add('AuthenticationTransformConstants', $getValue.AdditionalProperties.cryptographySuite.authenticationTransformConstants.toString())
        }
        if ($null -ne $getValue.AdditionalProperties.cryptographySuite.cipherTransformConstants)
        {
            $complexCryptographySuite.Add('CipherTransformConstants', $getValue.AdditionalProperties.cryptographySuite.cipherTransformConstants.toString())
        }
        if ($null -ne $getValue.AdditionalProperties.cryptographySuite.dhGroup)
        {
            $complexCryptographySuite.Add('DhGroup', $getValue.AdditionalProperties.cryptographySuite.dhGroup.toString())
        }
        if ($null -ne $getValue.AdditionalProperties.cryptographySuite.encryptionMethod)
        {
            $complexCryptographySuite.Add('EncryptionMethod', $getValue.AdditionalProperties.cryptographySuite.encryptionMethod.toString())
        }
        if ($null -ne $getValue.AdditionalProperties.cryptographySuite.integrityCheckMethod)
        {
            $complexCryptographySuite.Add('IntegrityCheckMethod', $getValue.AdditionalProperties.cryptographySuite.integrityCheckMethod.toString())
        }
        if ($null -ne $getValue.AdditionalProperties.cryptographySuite.pfsGroup)
        {
            $complexCryptographySuite.Add('PfsGroup', $getValue.AdditionalProperties.cryptographySuite.pfsGroup.toString())
        }
        if ($complexCryptographySuite.values.Where({$null -ne $_}).count -eq 0)
        {
            $complexCryptographySuite = $null
        }

        $complexDnsRules = @()
        foreach ($currentdnsRules in $getValue.AdditionalProperties.dnsRules)
        {
            $mydnsRules = @{}
            $mydnsRules.Add('AutoTrigger', $currentdnsRules.autoTrigger)
            $mydnsRules.Add('Name', $currentdnsRules.name)
            $mydnsRules.Add('Persistent', $currentdnsRules.persistent)
            $mydnsRules.Add('ProxyServerUri', $currentdnsRules.proxyServerUri)
            $mydnsRules.Add('Servers', $currentdnsRules.servers)
            if ($mydnsRules.values.Where({$null -ne $_}).count -gt 0)
            {
                $complexDnsRules += $mydnsRules
            }
        }

        $complexProxyServer = @{}
        $complexProxyServer.Add('BypassProxyServerForLocalAddress', $getValue.AdditionalProperties.proxyServer.bypassProxyServerForLocalAddress)
        $complexProxyServer.Add('Address', $getValue.AdditionalProperties.proxyServer.address)
        $complexProxyServer.Add('AutomaticConfigurationScriptUrl', $getValue.AdditionalProperties.proxyServer.automaticConfigurationScriptUrl)
        $complexProxyServer.Add('Port', $getValue.AdditionalProperties.proxyServer.port)
        $complexProxyServer.Add('AutomaticallyDetectProxySettings', $getValue.AdditionalProperties.proxyServer.automaticallyDetectProxySettings)
        if ($null -ne $getValue.AdditionalProperties.proxyServer.'@odata.type')
        {
            $complexProxyServer.Add('odataType', $getValue.AdditionalProperties.proxyServer.'@odata.type'.toString())
        }
        if ($complexProxyServer.values.Where({$null -ne $_}).count -eq 0)
        {
            $complexProxyServer = $null
        }

        $complexRoutes = @()
        foreach ($currentroutes in $getValue.AdditionalProperties.routes)
        {
            $myroutes = @{}
            $myroutes.Add('DestinationPrefix', $currentroutes.destinationPrefix)
            $myroutes.Add('PrefixSize', $currentroutes.prefixSize)
            if ($myroutes.values.Where({$null -ne $_}).count -gt 0)
            {
                $complexRoutes += $myroutes
            }
        }

        $complexSingleSignOnEku = @{}
        $complexSingleSignOnEku.Add('Name', $getValue.AdditionalProperties.singleSignOnEku.name)
        $complexSingleSignOnEku.Add('ObjectIdentifier', $getValue.AdditionalProperties.singleSignOnEku.objectIdentifier)
        if ($complexSingleSignOnEku.values.Where({$null -ne $_}).count -eq 0)
        {
            $complexSingleSignOnEku = $null
        }

        $complexTrafficRules = @()
        foreach ($currenttrafficRules in $getValue.AdditionalProperties.trafficRules)
        {
            $mytrafficRules = @{}
            $mytrafficRules.Add('AppId', $currenttrafficRules.appId)
            if ($null -ne $currenttrafficRules.appType)
            {
                $mytrafficRules.Add('AppType', $currenttrafficRules.appType.toString())
            }
            $mytrafficRules.Add('Claims', $currenttrafficRules.claims)
            $complexLocalAddressRanges = @()
            foreach ($currentLocalAddressRanges in $currenttrafficRules.localAddressRanges)
            {
                $myLocalAddressRanges = @{}
                $myLocalAddressRanges.Add('LowerAddress', $currentLocalAddressRanges.lowerAddress)
                $myLocalAddressRanges.Add('UpperAddress', $currentLocalAddressRanges.upperAddress)
                $myLocalAddressRanges.Add('CidrAddress', $currentLocalAddressRanges.cidrAddress)
                if ($null -ne $currentLocalAddressRanges.'@odata.type')
                {
                    $myLocalAddressRanges.Add('odataType', $currentLocalAddressRanges.'@odata.type'.toString())
                }
                if ($myLocalAddressRanges.values.Where({$null -ne $_}).count -gt 0)
                {
                    $complexLocalAddressRanges += $myLocalAddressRanges
                }
            }
            $mytrafficRules.Add('LocalAddressRanges',$complexLocalAddressRanges)
            $complexLocalPortRanges = @()
            foreach ($currentLocalPortRanges in $currenttrafficRules.localPortRanges)
            {
                $myLocalPortRanges = @{}
                $myLocalPortRanges.Add('LowerNumber', $currentLocalPortRanges.lowerNumber)
                $myLocalPortRanges.Add('UpperNumber', $currentLocalPortRanges.upperNumber)
                if ($myLocalPortRanges.values.Where({$null -ne $_}).count -gt 0)
                {
                    $complexLocalPortRanges += $myLocalPortRanges
                }
            }
            $mytrafficRules.Add('LocalPortRanges',$complexLocalPortRanges)
            $mytrafficRules.Add('Name', $currenttrafficRules.name)
            $mytrafficRules.Add('Protocols', $currenttrafficRules.protocols)
            $complexRemoteAddressRanges = @()
            foreach ($currentRemoteAddressRanges in $currenttrafficRules.remoteAddressRanges)
            {
                $myRemoteAddressRanges = @{}
                $myRemoteAddressRanges.Add('LowerAddress', $currentRemoteAddressRanges.lowerAddress)
                $myRemoteAddressRanges.Add('UpperAddress', $currentRemoteAddressRanges.upperAddress)
                $myRemoteAddressRanges.Add('CidrAddress', $currentRemoteAddressRanges.cidrAddress)
                if ($null -ne $currentRemoteAddressRanges.'@odata.type')
                {
                    $myRemoteAddressRanges.Add('odataType', $currentRemoteAddressRanges.'@odata.type'.toString())
                }
                if ($myRemoteAddressRanges.values.Where({$null -ne $_}).count -gt 0)
                {
                    $complexRemoteAddressRanges += $myRemoteAddressRanges
                }
            }
            $mytrafficRules.Add('RemoteAddressRanges',$complexRemoteAddressRanges)
            $complexRemotePortRanges = @()
            foreach ($currentRemotePortRanges in $currenttrafficRules.remotePortRanges)
            {
                $myRemotePortRanges = @{}
                $myRemotePortRanges.Add('LowerNumber', $currentRemotePortRanges.lowerNumber)
                $myRemotePortRanges.Add('UpperNumber', $currentRemotePortRanges.upperNumber)
                if ($myRemotePortRanges.values.Where({$null -ne $_}).count -gt 0)
                {
                    $complexRemotePortRanges += $myRemotePortRanges
                }
            }
            $mytrafficRules.Add('RemotePortRanges',$complexRemotePortRanges)
            if ($null -ne $currenttrafficRules.routingPolicyType)
            {
                $mytrafficRules.Add('RoutingPolicyType', $currenttrafficRules.routingPolicyType.toString())
            }
            if ($null -ne $currenttrafficRules.vpnTrafficDirection)
            {
                $mytrafficRules.Add('VpnTrafficDirection', $currenttrafficRules.vpnTrafficDirection.toString())
            }
            if ($mytrafficRules.values.Where({$null -ne $_}).count -gt 0)
            {
                $complexTrafficRules += $mytrafficRules
            }
        }

        $complexServers = @()
        foreach ($currentservers in $getValue.AdditionalProperties.servers)
        {
            $myservers = @{}
            $myservers.Add('Address', $currentservers.address)
            $myservers.Add('Description', $currentservers.description)
            $myservers.Add('IsDefaultServer', $currentservers.isDefaultServer)
            if ($myservers.values.Where({$null -ne $_}).count -gt 0)
            {
                $complexServers += $myservers
            }
        }
        #endregion

        #region resource generator code
        $enumAuthenticationMethod = $null
        if ($null -ne $getValue.AdditionalProperties.authenticationMethod)
        {
            $enumAuthenticationMethod = $getValue.AdditionalProperties.authenticationMethod.ToString()
        }

        $enumConnectionType = $null
        if ($null -ne $getValue.AdditionalProperties.connectionType)
        {
            $enumConnectionType = $getValue.AdditionalProperties.connectionType.ToString()
        }

        $enumProfileTarget = $null
        if ($null -ne $getValue.AdditionalProperties.profileTarget)
        {
            $enumProfileTarget = $getValue.AdditionalProperties.profileTarget.ToString()
        }
        #endregion

        $results = @{
            #region resource generator code
            AssociatedApps                             = $complexAssociatedApps
            AuthenticationMethod                       = $enumAuthenticationMethod
            ConnectionType                             = $enumConnectionType
            CryptographySuite                          = $complexCryptographySuite
            DnsRules                                   = $complexDnsRules
            DnsSuffixes                                = $getValue.AdditionalProperties.dnsSuffixes
            EapXml                                     = $getValue.AdditionalProperties.eapXml
            EnableAlwaysOn                             = $getValue.AdditionalProperties.enableAlwaysOn
            EnableConditionalAccess                    = $getValue.AdditionalProperties.enableConditionalAccess
            EnableDeviceTunnel                         = $getValue.AdditionalProperties.enableDeviceTunnel
            EnableDnsRegistration                      = $getValue.AdditionalProperties.enableDnsRegistration
            EnableSingleSignOnWithAlternateCertificate = $getValue.AdditionalProperties.enableSingleSignOnWithAlternateCertificate
            EnableSplitTunneling                       = $getValue.AdditionalProperties.enableSplitTunneling
            MicrosoftTunnelSiteId                      = $getValue.AdditionalProperties.microsoftTunnelSiteId
            OnlyAssociatedAppsCanUseConnection         = $getValue.AdditionalProperties.onlyAssociatedAppsCanUseConnection
            ProfileTarget                              = $enumProfileTarget
            ProxyServer                                = $complexProxyServer
            RememberUserCredentials                    = $getValue.AdditionalProperties.rememberUserCredentials
            Routes                                     = $complexRoutes
            SingleSignOnEku                            = $complexSingleSignOnEku
            SingleSignOnIssuerHash                     = $getValue.AdditionalProperties.singleSignOnIssuerHash
            TrafficRules                               = $complexTrafficRules
            TrustedNetworkDomains                      = $getValue.AdditionalProperties.trustedNetworkDomains
            WindowsInformationProtectionDomain         = $getValue.AdditionalProperties.windowsInformationProtectionDomain
            ConnectionName                             = $getValue.AdditionalProperties.connectionName
            CustomXml                                  = $getValue.AdditionalProperties.customXml
            ServerCollection                           = $complexServers
            Description                                = $getValue.Description
            DisplayName                                = $getValue.DisplayName
            Id                                         = $getValue.Id
            Ensure                                     = 'Present'
            Credential                                 = $Credential
            ApplicationId                              = $ApplicationId
            TenantId                                   = $TenantId
            ApplicationSecret                          = $ApplicationSecret
            CertificateThumbprint                      = $CertificateThumbprint
            Managedidentity                            = $ManagedIdentity.IsPresent
            #endregion
        }
        $assignmentsValues = Get-MgBetaDeviceManagementDeviceConfigurationAssignment -DeviceConfigurationId $Id
        $assignmentResult = @()
        foreach ($assignmentEntry in $AssignmentsValues)
        {
            $assignmentValue = @{
                dataType = $assignmentEntry.Target.AdditionalProperties.'@odata.type'
                deviceAndAppManagementAssignmentFilterType = $(if ($null -ne $assignmentEntry.Target.DeviceAndAppManagementAssignmentFilterType)
                    {$assignmentEntry.Target.DeviceAndAppManagementAssignmentFilterType.ToString()})
                deviceAndAppManagementAssignmentFilterId = $assignmentEntry.Target.DeviceAndAppManagementAssignmentFilterId
                groupId = $assignmentEntry.Target.AdditionalProperties.groupId
            }
            $assignmentResult += $assignmentValue
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
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AssociatedApps,

        [Parameter()]
        [ValidateSet('certificate','usernameAndPassword','customEapXml','derivedCredential')]
        [System.String]
        $AuthenticationMethod,

        [Parameter()]
        [ValidateSet('pulseSecure','f5EdgeClient','dellSonicWallMobileConnect','checkPointCapsuleVpn','automatic','ikEv2','l2tp','pptp','citrix','paloAltoGlobalProtect','ciscoAnyConnect','unknownFutureValue','microsoftTunnel')]
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
        [ValidateSet('user','device','autoPilotDevice')]
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
        $ManagedIdentity
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
        Write-Verbose -Message "Creating an Intune Device Configuration Vpn Policy for Windows10 with DisplayName {$DisplayName}"
        $BoundParameters.Remove("Assignments") | Out-Null

        $CreateParameters = ([Hashtable]$BoundParameters).clone()
        $CreateParameters = Rename-M365DSCCimInstanceParameter -Properties $CreateParameters
        $CreateParameters.Remove('Id') | Out-Null

        $keys = (([Hashtable]$CreateParameters).clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $CreateParameters.$key -and $CreateParameters.$key.getType().Name -like '*cimInstance*')
            {
                $CreateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $CreateParameters.$key
            }
        }
        #region resource generator code
        $CreateParameters.Add("@odata.type", "#microsoft.graph.windows10VpnConfiguration")
        $policy = New-MgBetaDeviceManagementDeviceConfiguration -BodyParameter $CreateParameters
        $assignmentsHash = @()
        foreach ($assignment in $Assignments)
        {
            $assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }

        if ($policy.id)
        {
            Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId  $policy.id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/deviceConfigurations'
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Device Configuration Vpn Policy for Windows10 with Id {$($currentInstance.Id)}"
        $BoundParameters.Remove("Assignments") | Out-Null

        $UpdateParameters = ([Hashtable]$BoundParameters).clone()
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters

        $UpdateParameters.Remove('Id') | Out-Null

        $keys = (([Hashtable]$UpdateParameters).clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $UpdateParameters.$key -and $UpdateParameters.$key.getType().Name -like '*cimInstance*')
            {
                $UpdateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $UpdateParameters.$key
            }
        }
        #region resource generator code
        $UpdateParameters.Add("@odata.type", "#microsoft.graph.windows10VpnConfiguration")
        Update-MgBetaDeviceManagementDeviceConfiguration  `
            -DeviceConfigurationId $currentInstance.Id `
            -BodyParameter $UpdateParameters
        $assignmentsHash = @()
        foreach ($assignment in $Assignments)
        {
            $assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }
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
        [ValidateSet('certificate','usernameAndPassword','customEapXml','derivedCredential')]
        [System.String]
        $AuthenticationMethod,

        [Parameter()]
        [ValidateSet('pulseSecure','f5EdgeClient','dellSonicWallMobileConnect','checkPointCapsuleVpn','automatic','ikEv2','l2tp','pptp','citrix','paloAltoGlobalProtect','ciscoAnyConnect','unknownFutureValue','microsoftTunnel')]
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
        [ValidateSet('user','device','autoPilotDevice')]
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
        $ManagedIdentity
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

    Write-Verbose -Message "Testing configuration of the Intune Device Configuration Vpn Policy for Windows10 with Id {$Id} and DisplayName {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()

    if ($CurrentValues.Ensure -ne $PSBoundParameters.Ensure)
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
        if ($source.getType().Name -like '*CimInstance*')
        {
            $source = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $source

            $testResult = Compare-M365DSCComplexObject `
                -Source ($source) `
                -Target ($target)

            if (-Not $testResult)
            {
                $testResult = $false
                break
            }

            $ValuesToCheck.Remove($key) | Out-Null
        }
    }

    $ValuesToCheck.remove('Id') | Out-Null
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null

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
        $ManagedIdentity
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
        [array]$getValue = Get-MgBetaDeviceManagementDeviceConfiguration `
            -All `
            -ErrorAction Stop | Where-Object `
            -FilterScript { `
                $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.windows10VpnConfiguration' `
            }
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
                Id = $config.Id
                DisplayName           =  $config.DisplayName
                Ensure = 'Present'
                Credential = $Credential
                ApplicationId = $ApplicationId
                TenantId = $TenantId
                ApplicationSecret = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                Managedidentity = $ManagedIdentity.IsPresent
            }

            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            if ($null -ne $Results.AssociatedApps)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.AssociatedApps `
                    -CIMInstanceName 'MicrosoftGraphwindows10AssociatedApps'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
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
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
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
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
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
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
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
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
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
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
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
                        Name = 'TrafficRules'
                        CimInstanceName = 'MicrosoftGraphVpnTrafficRule'
                        IsRequired = $False
                    }
                    @{
                        Name = 'LocalAddressRanges'
                        CimInstanceName = 'MicrosoftGraphIPv4Range'
                        IsRequired = $False
                    }
                    @{
                        Name = 'LocalPortRanges'
                        CimInstanceName = 'MicrosoftGraphNumberRange'
                        IsRequired = $False
                    }
                    @{
                        Name = 'RemoteAddressRanges'
                        CimInstanceName = 'MicrosoftGraphIPv4Range'
                        IsRequired = $False
                    }
                    @{
                        Name = 'RemotePortRanges'
                        CimInstanceName = 'MicrosoftGraphNumberRange'
                        IsRequired = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.TrafficRules `
                    -CIMInstanceName 'MicrosoftGraphvpnTrafficRule' `
                    -ComplexTypeMapping $complexMapping

                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
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
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
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
                -Credential $Credential
            if ($Results.AssociatedApps)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "AssociatedApps" -isCIMArray:$True
            }
            if ($Results.CryptographySuite)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "CryptographySuite" -isCIMArray:$False
            }
            if ($Results.DnsRules)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "DnsRules" -isCIMArray:$True
            }
            if ($Results.ProxyServer)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "ProxyServer" -isCIMArray:$False
            }
            if ($Results.Routes)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "Routes" -isCIMArray:$True
            }
            if ($Results.SingleSignOnEku)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "SingleSignOnEku" -isCIMArray:$False
            }
            if ($Results.TrafficRules)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "TrafficRules" -isCIMArray:$True
            }
            if ($Results.ServerCollection)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "ServerCollection" -isCIMArray:$True
            }
            if ($Results.Assignments)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "Assignments" -isCIMArray:$true
            }
            #removing trailing commas and semi colons between items of an array of cim instances added by Convert-DSCStringParamToVariable
            $currentDSCBlock = $currentDSCBlock.replace("    ,`r`n" , "    `r`n" )
            $currentDSCBlock = $currentDSCBlock.replace("`r`n;`r`n" , "`r`n" )
            $currentDSCBlock = $currentDSCBlock.replace("`r`n,`r`n" , "`r`n" )
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
        if ($_.Exception -like '*401*' -or $_.ErrorDetails.Message -like "*`"ErrorCode`":`"Forbidden`"*")
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

function Update-DeviceConfigurationPolicyAssignment
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $DeviceConfigurationPolicyId,

        [Parameter()]
        [Array]
        $Targets,

        [Parameter()]
        [System.String]
        $Repository = 'deviceManagement/configurationPolicies',

        [Parameter()]
        [ValidateSet('v1.0','beta')]
        [System.String]
        $APIVersion = 'beta'
    )
    try
    {
        $deviceManagementPolicyAssignments = @()
        $Uri = "https://graph.microsoft.com/$APIVersion/$Repository/$DeviceConfigurationPolicyId/assign"

        foreach ($target in $targets)
        {
            $formattedTarget = @{"@odata.type" = $target.dataType}
            if ($target.groupId)
            {
                $formattedTarget.Add('groupId',$target.groupId)
            }
            if ($target.collectionId)
            {
                $formattedTarget.Add('collectionId',$target.collectionId)
            }
            if ($target.deviceAndAppManagementAssignmentFilterType)
            {
                $formattedTarget.Add('deviceAndAppManagementAssignmentFilterType',$target.deviceAndAppManagementAssignmentFilterType)
            }
            if ($target.deviceAndAppManagementAssignmentFilterId)
            {
                $formattedTarget.Add('deviceAndAppManagementAssignmentFilterId',$target.deviceAndAppManagementAssignmentFilterId)
            }
            $deviceManagementPolicyAssignments += @{'target' = $formattedTarget}
        }
        $body = @{'assignments' = $deviceManagementPolicyAssignments} | ConvertTo-Json -Depth 20
        #write-verbose -Message $body
        Invoke-MgGraphRequest -Method POST -Uri $Uri -Body $body -ErrorAction Stop
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error updating data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $null
    }
}
function Rename-M365DSCCimInstanceParameter
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable], [System.Collections.Hashtable[]])]
    param(
        [Parameter(Mandatory = 'true')]
        $Properties
    )

    $keyToRename = @{
        'odataType' = '@odata.type'
        'ServerCollection' = 'servers'
    }

    $result = $Properties

    $type = $Properties.getType().FullName

    #region Array
    if ($type -like '*[[\]]')
    {
        $values = @()
        foreach ($item in $Properties)
        {
            $values += Rename-M365DSCCimInstanceParameter $item
        }
        $result = $values

        return , $result
    }
    #endregion

    #region Single
    if ($type -like '*Hashtable')
    {
        $result = ([Hashtable]$Properties).clone()
    }
    if ($type -like '*CimInstance*' -or $type -like '*Hashtable*' -or $type -like '*Object*')
    {
        $hashProperties = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $result
        $keys = ($hashProperties.clone()).keys
        foreach ($key in $keys)
        {
            $keyName = $key.substring(0, 1).tolower() + $key.substring(1, $key.length - 1)
            if ($key -in $keyToRename.Keys)
            {
                $keyName = $keyToRename.$key
            }

            $property = $hashProperties.$key
            if ($null -ne $property)
            {
                $hashProperties.Remove($key)
                $hashProperties.add($keyName, (Rename-M365DSCCimInstanceParameter $property))
            }
        }
        $result = $hashProperties
    }
    return $result
    #endregion
}

function Get-M365DSCDRGComplexTypeToHashtable
{
    [CmdletBinding()]
    [OutputType([hashtable], [hashtable[]])]
    param(
        [Parameter()]
        $ComplexObject
    )

    if ($null -eq $ComplexObject)
    {
        return $null
    }

    if ($ComplexObject.gettype().fullname -like '*[[\]]')
    {
        $results = @()

        foreach ($item in $ComplexObject)
        {
            if ($item)
            {
                $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
                $results += $hash
            }
        }

        # PowerShell returns all non-captured stream output, not just the argument of the return statement.
        #An empty array is mangled into $null in the process.
        #However, an array can be preserved on return by prepending it with the array construction operator (,)
        return , [hashtable[]]$results
    }

    if ($ComplexObject.getType().fullname -like '*Dictionary*')
    {
        $results = @{}

        $ComplexObject = [hashtable]::new($ComplexObject)
        $keys = $ComplexObject.Keys
        foreach ($key in $keys)
        {
            if ($null -ne $ComplexObject.$key)
            {
                $keyName = $key

                $keyType = $ComplexObject.$key.gettype().fullname

                if ($keyType -like '*CimInstance*' -or $keyType -like '*Dictionary*' -or $keyType -like 'Microsoft.Graph.PowerShell.Models.*' -or $keyType -like '*[[\]]')
                {
                    $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject.$key

                    $results.Add($keyName, $hash)
                }
                else
                {
                    $results.Add($keyName, $ComplexObject.$key)
                }
            }
        }
        return [hashtable]$results
    }

    $results = @{}

    if ($ComplexObject.getType().Fullname -like '*hashtable')
    {
        $keys = $ComplexObject.keys
    }
    else
    {
        $keys = $ComplexObject | Get-Member | Where-Object -FilterScript { $_.MemberType -eq 'Property' }
    }

    foreach ($key in $keys)
    {
        $keyName = $key
        if ($ComplexObject.getType().Fullname -notlike '*hashtable')
        {
            $keyName = $key.Name
        }

        if ($null -ne $ComplexObject.$keyName)
        {
            $keyType = $ComplexObject.$keyName.gettype().fullname
            if ($keyType -like '*CimInstance*' -or $keyType -like '*Dictionary*' -or $keyType -like 'Microsoft.Graph.PowerShell.Models.*')
            {
                $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject.$keyName

                $results.Add($keyName, $hash)
            }
            else
            {
                $results.Add($keyName, $ComplexObject.$keyName)
            }
        }
    }
    return [hashtable]$results
}

<#
    Use ComplexTypeMapping to overwrite the type of nested CIM
    Example
    $complexMapping=@(
                    @{
                        Name="ApprovalStages"
                        CimInstanceName="MSFT_MicrosoftGraphapprovalstage1"
                        IsRequired=$false
                    }
                    @{
                        Name="PrimaryApprovers"
                        CimInstanceName="MicrosoftGraphuserset"
                        IsRequired=$false
                    }
                    @{
                        Name="EscalationApprovers"
                        CimInstanceName="MicrosoftGraphuserset"
                        IsRequired=$false
                    }
                )
    With
    Name: the name of the parameter to be overwritten
    CimInstanceName: The type of the CIM instance (can include or not the prefix MSFT_)
    IsRequired: If isRequired equals true, an empty hashtable or array will be returned. Some of the Graph parameters are required even though they are empty
#>
function Get-M365DSCDRGComplexTypeToString
{
    [CmdletBinding()]
    param(
        [Parameter()]
        $ComplexObject,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CIMInstanceName,

        [Parameter()]
        [Array]
        $ComplexTypeMapping,

        [Parameter()]
        [System.String]
        $Whitespace = '',

        [Parameter()]
        [System.uint32]
        $IndentLevel = 3,

        [Parameter()]
        [switch]
        $isArray = $false
    )

    if ($null -eq $ComplexObject)
    {
        return $null
    }

    $indent = ''
    for ($i = 0; $i -lt $IndentLevel ; $i++)
    {
        $indent += '    '
    }
    #If ComplexObject  is an Array
    if ($ComplexObject.GetType().FullName -like '*[[\]]')
    {
        $currentProperty = @()
        $IndentLevel++
        foreach ($item in $ComplexObject)
        {
            $splat = @{
                'ComplexObject'   = $item
                'CIMInstanceName' = $CIMInstanceName
                'IndentLevel'     = $IndentLevel
            }
            if ($ComplexTypeMapping)
            {
                $splat.add('ComplexTypeMapping', $ComplexTypeMapping)
            }

            $currentProperty += Get-M365DSCDRGComplexTypeToString -isArray:$true @splat
        }

        # PowerShell returns all non-captured stream output, not just the argument of the return statement.
        #An empty array is mangled into $null in the process.
        #However, an array can be preserved on return by prepending it with the array construction operator (,)
        return , $currentProperty
    }

    $currentProperty = ''
    if ($isArray)
    {
        $currentProperty += "`r`n"
        $currentProperty += $indent
    }

    $CIMInstanceName = $CIMInstanceName.replace('MSFT_', '')
    $currentProperty += "MSFT_$CIMInstanceName{`r`n"
    $IndentLevel++
    $indent = ''
    for ($i = 0; $i -lt $IndentLevel ; $i++)
    {
        $indent += '    '
    }
    $keyNotNull = 0

    if ($ComplexObject.Keys.count -eq 0)
    {
        return $null
    }

    foreach ($key in $ComplexObject.Keys)
    {
        if ($null -ne $ComplexObject.$key)
        {
            $keyNotNull++
            if ($ComplexObject.$key.GetType().FullName -like 'Microsoft.Graph.PowerShell.Models.*' -or $key -in $ComplexTypeMapping.Name)
            {
                $hashPropertyType = $ComplexObject[$key].GetType().Name.tolower()

                $isArray = $false
                if ($ComplexObject[$key].GetType().FullName -like '*[[\]]')
                {
                    $isArray = $true
                }
                #overwrite type if object defined in mapping complextypemapping
                if ($key -in $ComplexTypeMapping.Name)
                {
                    $hashPropertyType = ([Array]($ComplexTypeMapping | Where-Object -FilterScript { $_.Name -eq $key }).CimInstanceName)[0]
                    $hashProperty = $ComplexObject[$key]
                }
                else
                {
                    $hashProperty = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject[$key]
                }

                if (-not $isArray)
                {
                    $currentProperty += $indent + $key + ' = '
                }

                if ($isArray -and $key -in $ComplexTypeMapping.Name)
                {
                    if ($ComplexObject.$key.count -gt 0)
                    {
                        $currentProperty += $indent + $key + ' = '
                        $currentProperty += '@('
                    }
                }

                if ($isArray)
                {
                    $IndentLevel++
                    foreach ($item in $ComplexObject[$key])
                    {
                        if ($ComplexObject.$key.GetType().FullName -like 'Microsoft.Graph.PowerShell.Models.*')
                        {
                            $item = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
                        }
                        $nestedPropertyString = Get-M365DSCDRGComplexTypeToString `
                            -ComplexObject $item `
                            -CIMInstanceName $hashPropertyType `
                            -IndentLevel $IndentLevel `
                            -ComplexTypeMapping $ComplexTypeMapping `
                            -IsArray:$true
                        if ([string]::IsNullOrWhiteSpace($nestedPropertyString))
                        {
                            $nestedPropertyString = "@()`r`n"
                        }
                        $currentProperty += $nestedPropertyString
                    }
                    $IndentLevel--
                }
                else
                {
                    $nestedPropertyString = Get-M365DSCDRGComplexTypeToString `
                        -ComplexObject $hashProperty `
                        -CIMInstanceName $hashPropertyType `
                        -IndentLevel $IndentLevel `
                        -ComplexTypeMapping $ComplexTypeMapping
                    if ([string]::IsNullOrWhiteSpace($nestedPropertyString))
                    {
                        $nestedPropertyString = "`$null`r`n"
                    }
                    $currentProperty += $nestedPropertyString
                }
                if ($isArray)
                {
                    if ($ComplexObject.$key.count -gt 0)
                    {
                        $currentProperty += $indent
                        $currentProperty += ')'
                        $currentProperty += "`r`n"
                    }
                }
                $isArray = $PSBoundParameters.IsArray
            }
            else
            {
                $currentProperty += Get-M365DSCDRGSimpleObjectTypeToString -Key $key -Value $ComplexObject[$key] -Space ($indent)
            }
        }
        else
        {
            $mappedKey = $ComplexTypeMapping | Where-Object -FilterScript { $_.name -eq $key }

            if ($mappedKey -and $mappedKey.isRequired)
            {
                if ($mappedKey.isArray)
                {
                    $currentProperty += "$indent$key = @()`r`n"
                }
                else
                {
                    $currentProperty += "$indent$key = `$null`r`n"
                }
            }
        }
    }
    $indent = ''
    for ($i = 0; $i -lt $IndentLevel - 1 ; $i++)
    {
        $indent += '    '
    }
    $currentProperty += "$indent}"
    if ($isArray -or $IndentLevel -gt 4)
    {
        $currentProperty += "`r`n"
    }

    #Indenting last parenthese when the cim instance is an array
    if ($IndentLevel -eq 5)
    {
        $indent = ''
        for ($i = 0; $i -lt $IndentLevel - 2 ; $i++)
        {
            $indent += '    '
        }
        $currentProperty += $indent
    }

    $emptyCIM = $currentProperty.replace(' ', '').replace("`r`n", '')
    if ($emptyCIM -eq "MSFT_$CIMInstanceName{}")
    {
        $currentProperty = $null
    }
    return $currentProperty
}

Function Get-M365DSCDRGSimpleObjectTypeToString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.String]
        $Key,

        [Parameter(Mandatory = 'true')]
        $Value,

        [Parameter()]
        [System.String]
        $Space = '                '

    )

    $returnValue = ''
    switch -Wildcard ($Value.GetType().Fullname )
    {
        '*.Boolean'
        {
            $returnValue = $Space + $Key + " = `$" + $Value.ToString() + "`r`n"
        }
        '*.String'
        {
            if ($key -eq '@odata.type')
            {
                $key = 'odataType'
            }
            $returnValue = $Space + $Key + " = '" + $Value + "'`r`n"
        }
        '*.DateTime'
        {
            $returnValue = $Space + $Key + " = '" + $Value + "'`r`n"
        }
        '*[[\]]'
        {
            $returnValue = $Space + $key + ' = @('
            $whitespace = ''
            $newline = ''
            if ($Value.count -gt 1)
            {
                $returnValue += "`r`n"
                $whitespace = $Space + '    '
                $newline = "`r`n"
            }
            foreach ($item in ($Value | Where-Object -FilterScript { $null -ne $_ }))
            {
                switch -Wildcard ($item.GetType().Fullname)
                {
                    '*.String'
                    {
                        $returnValue += "$whitespace'$item'$newline"
                    }
                    '*.DateTime'
                    {
                        $returnValue += "$whitespace'$item'$newline"
                    }
                    Default
                    {
                        $returnValue += "$whitespace$item$newline"
                    }
                }
            }
            if ($Value.count -gt 1)
            {
                $returnValue += "$Space)`r`n"
            }
            else
            {
                $returnValue += ")`r`n"

            }
        }
        Default
        {
            $returnValue = $Space + $Key + ' = ' + $Value + "`r`n"
        }
    }
    return $returnValue
}

function Compare-M365DSCComplexObject
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param(
        [Parameter()]
        $Source,
        [Parameter()]
        $Target
    )

    #Comparing full objects
    if ($null -eq $Source -and $null -eq $Target)
    {
        return $true
    }

    $sourceValue = ''
    $targetValue = ''
    if (($null -eq $Source) -xor ($null -eq $Target))
    {
        if ($null -eq $Source)
        {
            $sourceValue = 'Source is null'
        }

        if ($null -eq $Target)
        {
            $targetValue = 'Target is null'
        }
        Write-Verbose -Message "Configuration drift - Complex object: {$sourceValue$targetValue}"
        return $false
    }

    if ($Source.getType().FullName -like '*CimInstance[[\]]' -or $Source.getType().FullName -like '*Hashtable[[\]]')
    {
        if ($source.count -ne $target.count)
        {
            Write-Verbose -Message "Configuration drift - The complex array have different number of items: Source {$($source.count)} Target {$($target.count)}"
            return $false
        }
        if ($source.count -eq 0)
        {
            return $true
        }

        foreach ($item in $Source)
        {
            $hashSource = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
            foreach ($targetItem in $Target)
            {
                $compareResult = Compare-M365DSCComplexObject `
                    -Source $hashSource `
                    -Target $targetItem

                if ($compareResult)
                {
                    break
                }
            }

            if (-not $compareResult)
            {
                Write-Verbose -Message 'Configuration drift - The complex array items are not identical'
                return $false
            }
        }
        return $true
    }

    $keys = $Source.Keys | Where-Object -FilterScript { $_ -ne 'PSComputerName' }
    foreach ($key in $keys)
    {
        #Matching possible key names between Source and Target
        $skey = $key
        $tkey = $key

        $sourceValue = $Source.$key
        $targetValue = $Target.$tkey
        #One of the item is null and not the other
        if (($null -eq $Source.$key) -xor ($null -eq $Target.$tkey))
        {

            if ($null -eq $Source.$key)
            {
                $sourceValue = 'null'
            }

            if ($null -eq $Target.$tkey)
            {
                $targetValue = 'null'
            }

            #Write-Verbose -Message "Configuration drift - key: $key Source {$sourceValue} Target {$targetValue}"
            return $false
        }

        #Both keys aren't null or empty
        if (($null -ne $Source.$key) -and ($null -ne $Target.$tkey))
        {
            if ($Source.$key.getType().FullName -like '*CimInstance*' -or $Source.$key.getType().FullName -like '*hashtable*')
            {
                #Recursive call for complex object
                $compareResult = Compare-M365DSCComplexObject `
                    -Source (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Source.$key) `
                    -Target $Target.$tkey

                if (-not $compareResult)
                {
                    #Write-Verbose -Message "Configuration drift - complex object key: $key Source {$sourceValue} Target {$targetValue}"
                    return $false
                }
            }
            else
            {
                #Simple object comparison
                $referenceObject = $Target.$tkey
                $differenceObject = $Source.$key

                #Identifying date from the current values
                $targetType = ($Target.$tkey.getType()).Name
                if ($targetType -like '*Date*')
                {
                    $compareResult = $true
                    $sourceDate = [DateTime]$Source.$key
                    if ($sourceDate -ne $targetType)
                    {
                        $compareResult = $null
                    }
                }
                else
                {
                    $compareResult = Compare-Object `
                        -ReferenceObject ($referenceObject) `
                        -DifferenceObject ($differenceObject)
                }

                if ($null -ne $compareResult)
                {
                    #Write-Verbose -Message "Configuration drift - simple object key: $key Source {$sourceValue} Target {$targetValue}"
                    return $false
                }
            }
        }
    }
    return $true
}

function Convert-M365DSCDRGComplexTypeToHashtable
{
    [CmdletBinding()]
    [OutputType([hashtable], [hashtable[]])]
    param(
        [Parameter(Mandatory = 'true')]
        $ComplexObject
    )

    if ($ComplexObject.getType().Fullname -like '*[[\]]')
    {
        $results = @()
        foreach ($item in $ComplexObject)
        {
            $hash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
            $results += $hash
        }

        #Write-Verbose -Message ("Convert-M365DSCDRGComplexTypeToHashtable >>> results: "+(convertTo-JSON $results -Depth 20))
        # PowerShell returns all non-captured stream output, not just the argument of the return statement.
        #An empty array is mangled into $null in the process.
        #However, an array can be preserved on return by prepending it with the array construction operator (,)
        return , [hashtable[]]$results
    }
    $hashComplexObject = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject

    if ($null -ne $hashComplexObject)
    {
        $results = $hashComplexObject.clone()
        $keys = $hashComplexObject.Keys | Where-Object -FilterScript { $_ -ne 'PSComputerName' }
        foreach ($key in $keys)
        {
            if ($hashComplexObject[$key] -and $hashComplexObject[$key].getType().Fullname -like '*CimInstance*')
            {
                $results[$key] = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $hashComplexObject[$key]
            }
            else
            {
                $propertyName = $key[0].ToString().ToLower() + $key.Substring(1, $key.Length - 1)
                $propertyValue = $results[$key]
                $results.remove($key) | Out-Null
                $results.add($propertyName, $propertyValue)
            }
        }
    }
    return [hashtable]$results
}

Export-ModuleMember -Function *-TargetResource,*
