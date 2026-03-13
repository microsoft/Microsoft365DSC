Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneCorporateDeviceIdentifier'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Devices,

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
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration of the Intune Corporate Device Identifier"

    try
    {
        $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters

        #Ensure the proper dependencies are installed in the current environment.
        Confirm-M365DSCDependencies

        #region Telemetry
        $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
        $CommandName = $MyInvocation.MyCommand
        $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
            -CommandName $CommandName `
            -Parameters $PSBoundParameters
        Add-M365DSCTelemetryEvent -Data $data
        #endregion

        $nullResult = $PSBoundParameters
        $nullResult.Ensure = 'Absent'
        $nullResult.Devices = @()

        # Get all imported device identities from Intune
        $uri = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + 'beta/deviceManagement/importedDeviceIdentities'
        $allDevices = @()

        do
        {
            $response = Invoke-MgGraphRequest -Method GET -Uri $uri
            if ($null -ne $response.value)
            {
                $allDevices += $response.value
            }
            $uri = $response.'@odata.nextLink'
        } while ($null -ne $uri)

        if ($allDevices.Count -eq 0)
        {
            Write-Verbose -Message 'No corporate device identifiers found in Intune'
            return $nullResult
        }

        Write-Verbose -Message "Found $($allDevices.Count) corporate device identifiers in Intune"

        # Convert to CIM instances
        $deviceArray = @()
        foreach ($device in $allDevices)
        {
            $deviceHash = @{
                Id                         = $device.id
                importedDeviceIdentifier   = $device.importedDeviceIdentifier
                importedDeviceIdentityType = $device.importedDeviceIdentityType
                Description                = $device.description
                Platform                   = if ($device.platform)
                {
                    $device.platform.ToLower()
                }
                else
                {
                    $null
                }
            }
            $deviceArray += $deviceHash
        }

        $results = @{
            IsSingleInstance      = 'Yes'
            Devices               = $deviceArray
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
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

        return $nullResult
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Devices,

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
        $AccessTokens
    )
    $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $desiredParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $desiredParameters.Remove('IsSingleInstance') | Out-Null

    # Get current state
    $currentInstance = Get-TargetResource @PSBoundParameters

    if ($Ensure -eq 'Present')
    {
        # Convert CIM instances to hashtables for comparison
        $desiredDevices = @()
        if ($null -ne $Devices)
        {
            foreach ($device in $Devices)
            {
                $desiredDevices += @{
                    importedDeviceIdentifier   = if ($device.importedDeviceIdentifier) { $device.importedDeviceIdentifier.Trim() } else { $null }
                    importedDeviceIdentityType = if ($device.importedDeviceIdentityType) { $device.importedDeviceIdentityType } else { $null }
                    description                = $device.description
                    platform                   = if ($device.platform) { $device.platform.ToLower() } else { $null }
                }
            }
        }

        $currentDevices = @()
        if ($null -ne $currentInstance.Devices)
        {
            foreach ($device in $currentInstance.Devices)
            {
                $currentDevices += @{
                    Id                         = $device.Id
                    importedDeviceIdentifier   = if ($device.importedDeviceIdentifier) { $device.importedDeviceIdentifier.Trim() } else { $null }
                    importedDeviceIdentityType = if ($device.importedDeviceIdentityType) { $device.importedDeviceIdentityType } else { $null }
                    description                = $device.description
                    platform                   = if ($device.platform) { $device.platform.ToLower() } else { $null }
                }
            }
        }

        # Find devices to ADD (in desired but not in current)
        $devicesToAdd = @()
        foreach ($desiredDevice in $desiredDevices)
        {
            $found = $false
            foreach ($currentDevice in $currentDevices)
            {
                if (Compare-DeviceIdentifier -Device1 $desiredDevice -Device2 $currentDevice)
                {
                    $found = $true
                    break
                }
            }
            if (-not $found)
            {
                $devicesToAdd += $desiredDevice
            }
        }

        # Find devices to REMOVE (in current but not in desired)
        $devicesToRemove = @()
        foreach ($currentDevice in $currentDevices)
        {
            $found = $false
            foreach ($desiredDevice in $desiredDevices)
            {
                if (Compare-DeviceIdentifier -Device1 $currentDevice -Device2 $desiredDevice)
                {
                    $found = $true
                    break
                }
            }
            if (-not $found)
            {
                $devicesToRemove += $currentDevice
            }
        }

        # Add new devices
        if ($devicesToAdd.Count -gt 0)
        {
            Write-Verbose -Message "Adding $($devicesToAdd.Count) device identifier(s) to Intune"

            $importList = @()
            foreach ($device in $devicesToAdd)
            {
                $deviceToImport = @{}

                if (-not [System.String]::IsNullOrEmpty($device.importedDeviceIdentifier))
                {
                    $deviceToImport.importedDeviceIdentifier = $device.importedDeviceIdentifier
                }
                if (-not [System.String]::IsNullOrEmpty($device.importedDeviceIdentityType))
                {
                    $deviceToImport.importedDeviceIdentityType = $device.importedDeviceIdentityType
                }
                if (-not [System.String]::IsNullOrEmpty($device.description))
                {
                    $deviceToImport.description = $device.description
                }
                if (-not [System.String]::IsNullOrEmpty($device.platform))
                {
                    $deviceToImport.platform = $device.platform
                }

                $importList += $deviceToImport
            }

            $uri = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + 'beta/deviceManagement/importedDeviceIdentities/importDeviceIdentityList'
            $body = @{
                overwriteImportedDeviceIdentities = $false
                importedDeviceIdentities          = $importList
            }

            try
            {
                Invoke-MgGraphRequest -Method POST -Uri $uri -Body ($body | ConvertTo-Json -Depth 10)
                Write-Verbose -Message "Successfully added $($devicesToAdd.Count) device identifier(s)"
            }
            catch
            {
                Write-Verbose -Message "Error adding device identifiers: $($_.Exception.Message)"
                throw
            }
        }

        # Remove devices not in desired state
        if ($devicesToRemove.Count -gt 0)
        {
            Write-Verbose -Message "Removing $($devicesToRemove.Count) device identifier(s) from Intune"

            foreach ($device in $devicesToRemove)
            {
                $uri = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/deviceManagement/importedDeviceIdentities/$($device.Id)"

                try
                {
                    Invoke-MgGraphRequest -Method DELETE -Uri $uri
                    Write-Verbose -Message "Successfully removed device identifier with Id: $($device.Id)"
                }
                catch
                {
                    Write-Verbose -Message "Error removing device identifier with Id $($device.Id): $($_.Exception.Message)"
                    throw
                }
            }
        }

        if ($devicesToAdd.Count -eq 0 -and $devicesToRemove.Count -eq 0)
        {
            Write-Verbose -Message 'No changes needed - current state matches desired state'
        }
    }
    elseif ($Ensure -eq 'Absent')
    {
        # Remove ALL identifiers
        if ($null -ne $currentInstance.Devices -and $currentInstance.Devices.Count -gt 0)
        {
            Write-Verbose -Message "Removing all $($currentInstance.Devices.Count) device identifier(s) from Intune"

            foreach ($device in $currentInstance.Devices)
            {
                $uri = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/deviceManagement/importedDeviceIdentities/$($device.Id)"
                try
                {
                    Invoke-MgGraphRequest -Method DELETE -Uri $uri
                    Write-Verbose -Message "Successfully removed device identifier with Id: $($device.Id)"
                }
                catch
                {
                    Write-Verbose -Message "Error removing device identifier with Id $($device.Id): $($_.Exception.Message)"
                    throw
                }
            }
        }
        else
        {
            Write-Verbose -Message 'No device identifiers to remove'
        }
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Devices,

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
        $AccessTokens
    )

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
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
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        if ($null -ne $Global:M365DSCExportResourceInstancesCount)
        {
            $Global:M365DSCExportResourceInstancesCount++
        }

        $params = @{
            IsSingleInstance      = 'Yes'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
        }

        $Results = Get-TargetResource @Params

        if ($Results.Ensure -eq 'Present' -and $null -ne $Results.Devices -and $Results.Devices.Count -gt 0)
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
            Write-M365DSCHost -Message "    |---[1/1] Corporate Device Identifiers ($($Results.Devices.Count) devices)" -CommitWrite

            # Handle complex type conversion for Devices array
            if ($Results.Devices)
            {
                $complexMapping = @(
                    @{
                        Name            = 'Devices'
                        CimInstanceName = 'MSFT_IntuneDeviceIdentifier'
                        IsRequired      = $False
                    }
                )

                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.Devices `
                    -CIMInstanceName 'MSFT_IntuneDeviceIdentifier' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.Devices = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Devices') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('Devices')

            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName

            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            return $currentDSCBlock
        }
        else
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            return ''
        }
    }
    catch
    {
        Write-M365DSCHost -Message $Global:M365DSCEmojiRedX -CommitWrite

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

#region Helper Functions
function Compare-DeviceIdentifier
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Device1,

        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Device2
    )

    # Match on importedDeviceIdentifier and importedDeviceIdentityType if both have them
    if (-not [System.String]::IsNullOrEmpty($Device1.importedDeviceIdentifier) -and
        -not [System.String]::IsNullOrEmpty($Device2.importedDeviceIdentifier))
    {
        # Case-insensitive comparison for device identifiers
        $identifierMatch = ($Device1.importedDeviceIdentifier.ToLower() -eq $Device2.importedDeviceIdentifier.ToLower())

        # Also check type if both have it
        if (-not [System.String]::IsNullOrEmpty($Device1.importedDeviceIdentityType) -and
            -not [System.String]::IsNullOrEmpty($Device2.importedDeviceIdentityType))
        {
            return ($identifierMatch -and ($Device1.importedDeviceIdentityType -eq $Device2.importedDeviceIdentityType))
        }

        return $identifierMatch
    }

    # If we can't determine a match, consider them different
    return $false
}
#endregion

Export-ModuleMember -Function *-TargetResource
