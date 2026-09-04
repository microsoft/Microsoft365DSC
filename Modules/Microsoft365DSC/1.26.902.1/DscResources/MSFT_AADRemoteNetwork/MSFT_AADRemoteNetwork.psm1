Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADRemoteNetwork'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Region,

        [Parameter()]
        [System.String[]]
        $ForwardingProfiles,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DeviceLinks,

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

    Write-Verbose -Message "Getting configuration for the AAD Network Access Forwarding Profile with Id {$Id} and Name {$Name}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Id -ne $Id)
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
                $getValue = Get-MgBetaNetworkAccessConnectivityRemoteNetwork -RemoteNetworkId $Id -ErrorAction SilentlyContinue
            }

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Azure AD Remote Network with Id {$Id}"

                if (-not [System.String]::IsNullOrEmpty($Name))
                {
                    $getValue = Get-MgBetaNetworkAccessConnectivityRemoteNetwork -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq $Name }
                }
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }
        #endregion
        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Azure AD Remote Network with Name {$Name}."
            return $nullResult
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Azure AD Remote Network with Id {$Id} and Name {$Name} was found"

        #region resource generator code
        $forwardingProfilesList = @()
        foreach ($forwardingProfile in $getValue.ForwardingProfiles)
        {
            $forwardingProfilesList += $forwardingProfile.Name
        }

        $complexDeviceLinks = Get-MicrosoftGraphRemoteNetworkDeviceLinksHashtable -DeviceLinks $getValue.DeviceLinks
        #endregion

        $results = @{
            Id                    = $getValue.Id
            Name                  = $getValue.Name
            Region                = $getValue.Region
            ForwardingProfiles    = [Array]$forwardingProfilesList
            DeviceLinks           = [Array]$complexDeviceLinks
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            CertificatePath       = $CertificatePath
            CertificatePassword   = $CertificatePassword
            ManagedIdentity       = $ManagedIdentity.IsPresent
        }

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
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Region,

        [Parameter()]
        [System.String[]]
        $ForwardingProfiles,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DeviceLinks,

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

    # creating the device links property
    $deviceLinksHashtable = Rename-M365DSCCimInstanceParameter -Properties $BoundParameters.DeviceLinks

    #creating the forwarding policies list by getting the ids
    $allForwardingProfiles = Get-MgBetaNetworkAccessForwardingProfile
    $forwardingProfilesList = @()
    foreach ($profileName in $BoundParameters.ForwardingProfiles)
    {
        $matchedProfile = $allForwardingProfiles | Where-Object { $_.Name -eq $profileName }
        $forwardingProfilesList += @{
            id = $matchedProfile.Id
        }
    }

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Azure AD Remote Network with Name {$Name}"
        $params = @{
            name               = $BoundParameters.Name
            region             = $BoundParameters.Region
            deviceLinks        = [Array]$deviceLinksHashtable
            forwardingProfiles = [Array]$forwardingProfilesList
        }

        New-MgBetaNetworkAccessConnectivityRemoteNetwork -BodyParameter $params
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Azure AD Remote Network with Id {$($currentInstance.Id)}"
        $currentRemoteNetwork = Get-MgBetaNetworkAccessConnectivityRemoteNetwork -RemoteNetworkId $currentInstance.Id

        #removing the old device links
        foreach ($deviceLinkItem in $currentRemoteNetwork.DeviceLinks)
        {
            Remove-MgBetaNetworkAccessConnectivityRemoteNetworkDeviceLink -RemoteNetworkId $currentInstance.Id -DeviceLinkId $deviceLinkItem.Id
        }
        # updating the list of device links
        foreach ($deviceLinkItem in $deviceLinksHashtable)
        {
            Write-Verbose "Device Link Hashtable: $deviceLinksItem"
            New-MgBetaNetworkAccessConnectivityRemoteNetworkDeviceLink -RemoteNetworkId $currentInstance.Id -BodyParameter $deviceLinkItem
        }

        # removing forwarding profiles
        $params = @{
            '@context' = '#$delta'
            value      = @(@{})
        }
        Invoke-MgGraphRequest -Uri "$((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl)beta/networkAccess/connectivity/remoteNetworks/$($currentInstance.Id)/forwardingProfiles" -Method Patch -Body $params

        #adding forwarding profiles if required
        if ($forwardingProfilesList.Count -gt 0)
        {
            $params = @{
                '@context' = '#$delta'
                value      = $forwardingProfilesList
            }
            Invoke-MgGraphRequest -Uri "$((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl)beta/networkAccess/connectivity/remoteNetworks/$($currentInstance.Id)/forwardingProfiles" -Method Patch -Body $params
        }
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Azure AD Remote Network with Id {$($currentInstance.Id)}"
        #region resource generator code
        Remove-MgBetaNetworkAccessConnectivityRemoteNetwork -RemoteNetworkId $currentInstance.Id
        #endregion
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Region,

        [Parameter()]
        [System.String[]]
        $ForwardingProfiles,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DeviceLinks,

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
        [array]$getValue = Get-MgBetaNetworkAccessConnectivityRemoteNetwork `
            -Filter $Filter `
            -All `
            -ErrorAction Stop
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
            if (-not [String]::IsNullOrEmpty($config.Name))
            {
                $displayedKey = $config.Name
            }
            elseif (-not [string]::IsNullOrEmpty($config.name))
            {
                $displayedKey = $config.name
            }
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                Id                    = $config.Id
                Name                  = $config.Name
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

            if ($null -ne $Results.DeviceLinks)
            {
                $complexMapping = @(
                    @{
                        Name            = 'DeviceLinks'
                        CimInstanceName = 'AADRemoteNetworkDeviceLink'
                        IsRequired      = $False
                    },
                    @{
                        Name            = 'BgpConfiguration'
                        CimInstanceName = 'AADRemoteNetworkDeviceLinkbgpConfiguration'
                        IsRequired      = $False
                    },
                    @{
                        Name            = 'RedundancyConfiguration'
                        CimInstanceName = 'AADRemoteNetworkDeviceLinkRedundancyConfiguration'
                        IsRequired      = $False
                    },
                    @{
                        Name            = 'TunnelConfiguration'
                        CimInstanceName = 'AADRemoteNetworkDeviceLinkTunnelConfiguration'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.DeviceLinks `
                    -CIMInstanceName 'AADRemoteNetworkDeviceLink' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.DeviceLinks = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('DeviceLinks') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('DeviceLinks')

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
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

function Get-MicrosoftGraphRemoteNetworkDeviceLinksHashtable
{
    [CmdletBinding()]
    [OutputType([System.Collections.ArrayList])]
    param
    (
        [Parameter()]
        [System.Collections.ArrayList]
        $DeviceLinks
    )

    $newDeviceLinks = @()

    foreach ($deviceLink in $DeviceLinks)
    {
        $newDeviceLink = @{}

        # Add main properties only if they are not null
        if ($deviceLink.Name)
        {
            $newDeviceLink['Name'] = $deviceLink.Name
        }
        if ($deviceLink.IpAddress)
        {
            $newDeviceLink['IPAddress'] = $deviceLink.IpAddress
        }
        if ($deviceLink.BandwidthCapacityInMbps)
        {
            $newDeviceLink['BandwidthCapacityInMbps'] = $deviceLink.BandwidthCapacityInMbps
        }
        if ($deviceLink.DeviceVendor)
        {
            $newDeviceLink['DeviceVendor'] = $deviceLink.DeviceVendor
        }

        # BGP Configuration
        if ($deviceLink.BgpConfiguration)
        {
            $bgpConfig = @{}
            if ($deviceLink.BgpConfiguration.Asn)
            {
                $bgpConfig['Asn'] = $deviceLink.BgpConfiguration.Asn
            }
            if ($deviceLink.BgpConfiguration.LocalIPAddress)
            {
                $bgpConfig['LocalIPAddress'] = $deviceLink.BgpConfiguration.LocalIPAddress
            }
            if ($deviceLink.BgpConfiguration.PeerIPAddress)
            {
                $bgpConfig['PeerIPAddress'] = $deviceLink.BgpConfiguration.PeerIPAddress
            }

            if ($bgpConfig.Count -gt 0)
            {
                $newDeviceLink['BgpConfiguration'] = $bgpConfig
            }
        }

        # Redundancy Configuration
        if ($deviceLink.RedundancyConfiguration)
        {
            $redundancyConfig = @{}
            if ($deviceLink.RedundancyConfiguration.RedundancyTier)
            {
                $redundancyConfig['RedundancyTier'] = $deviceLink.RedundancyConfiguration.RedundancyTier
            }
            if ($deviceLink.RedundancyConfiguration.ZoneLocalIPAddress)
            {
                $redundancyConfig['ZoneLocalIPAddress'] = $deviceLink.RedundancyConfiguration.ZoneLocalIPAddress
            }

            if ($redundancyConfig.Count -gt 0)
            {
                $newDeviceLink['RedundancyConfiguration'] = $redundancyConfig
            }
        }

        # Tunnel Configuration
        if ($deviceLink.TunnelConfiguration)
        {
            $tunnelConfig = @{}
            if ($deviceLink.TunnelConfiguration.PreSharedKey)
            {
                $tunnelConfig['PreSharedKey'] = $deviceLink.TunnelConfiguration.PreSharedKey
            }
            if ($deviceLink.TunnelConfiguration.ZoneRedundancyPreSharedKey)
            {
                $tunnelConfig['ZoneRedundancyPreSharedKey'] = $deviceLink.TunnelConfiguration.ZoneRedundancyPreSharedKey
            }

            # Additional Properties
            if ($deviceLink.TunnelConfiguration)
            {
                if ($deviceLink.TunnelConfiguration.saLifeTimeSeconds)
                {
                    $tunnelConfig['SaLifeTimeSeconds'] = $deviceLink.TunnelConfiguration.saLifeTimeSeconds
                }
                if ($deviceLink.TunnelConfiguration.ipSecEncryption)
                {
                    $tunnelConfig['IPSecEncryption'] = $deviceLink.TunnelConfiguration.ipSecEncryption
                }
                if ($deviceLink.TunnelConfiguration.ipSecIntegrity)
                {
                    $tunnelConfig['IPSecIntegrity'] = $deviceLink.TunnelConfiguration.ipSecIntegrity
                }
                if ($deviceLink.TunnelConfiguration.ikeEncryption)
                {
                    $tunnelConfig['IKEEncryption'] = $deviceLink.TunnelConfiguration.ikeEncryption
                }
                if ($deviceLink.TunnelConfiguration.ikeIntegrity)
                {
                    $tunnelConfig['IKEIntegrity'] = $deviceLink.TunnelConfiguration.ikeIntegrity
                }
                if ($deviceLink.TunnelConfiguration.dhGroup)
                {
                    $tunnelConfig['DHGroup'] = $deviceLink.TunnelConfiguration.dhGroup
                }
                if ($deviceLink.TunnelConfiguration.pfsGroup)
                {
                    $tunnelConfig['PFSGroup'] = $deviceLink.TunnelConfiguration.pfsGroup
                }
                if ($deviceLink.TunnelConfiguration['@odata.type'])
                {
                    $tunnelConfig['ODataType'] = $deviceLink.TunnelConfiguration['@odata.type']
                }
            }

            if ($tunnelConfig.Count -gt 0)
            {
                $newDeviceLink['TunnelConfiguration'] = $tunnelConfig
            }
        }

        # Add the device link to the collection if it has any properties
        if ($newDeviceLink.Count -gt 0)
        {
            $newDeviceLinks += $newDeviceLink
        }
    }

    return $newDeviceLinks
}

Export-ModuleMember -Function *-TargetResource
