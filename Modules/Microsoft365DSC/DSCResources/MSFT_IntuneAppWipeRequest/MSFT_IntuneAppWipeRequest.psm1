function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
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
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Wipe,

        [Parameter()]
        [System.String]
        $createdDateTime,

        [Parameter()]
        [System.String]
        $lastSyncDateTime,

        [Parameter()]
        [System.String]
        $applicationVersion,

        [Parameter()]
        [System.String]
        $managementSdkVersion,

        [Parameter()]
        [System.String]
        $platformVersion,

        [Parameter()]
        [Switch]
        $deviceType,

        [Parameter()]
        [System.String]
        $deviceTag,

        [Parameter()]
        [System.String]
        $deviceName,

        [Parameter()]
        [System.String]
        $managedDeviceId,

        [Parameter()]
        [System.String]
        $azureADDeviceId,

        [Parameter()]
        [System.String]
        $deviceModel,

        [Parameter()]
        [System.String]
        $deviceManufacturer,

        [Parameter()]
        [System.String[]]
        $flaggedReasons,

        [Parameter()]
        [System.String]
        $userId,

        [Parameter()]
        [System.String]
        $id,

        [Parameter()]
        [System.String]
        $version,

        [Parameter()]
        [System.String]
        $patchVersion,

        [Parameter()]
        [System.Collections.Hashtable]
        $appIdentifier,

        [Parameter()]
        [System.String]
        $operationsContext,

        [Parameter()]
        [System.Collections.Hashtable[]]
        $operations
    )

    New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters | Out-Null

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
    try
    {
        if ($null -ne $Script:exportedInstances -and $Script:ExportMode)
        {
           $instance = $Script:exportedInstances | Where-Object -FilterScript {$_.Wipe -eq $Wipe}
        }
        else
        {
            $instance = Get-MgBetaDeviceAppManagementManagedAppRegistration -ManagedAppRegistrationId $id -ErrorAction Stop
        }
        if ($null -eq $instance)
        {
            return $nullResult
        }

        $results = @{
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
            Id                    = $instance.id
            UserId                = $instance.userId
            CreatedDateTime       = $instance.createdDateTime
            LastSyncDateTime      = $instance.lastSyncDateTime
            ApplicationVersion    = $instance.applicationVersion
            ManagementSdkVersion  = $instance.managementSdkVersion
            PlatformVersion       = $instance.platformVersion
            DeviceType            = $instance.deviceType
            DeviceTag             = $instance.deviceTag
            DeviceName            = $instance.deviceName
            ManagedDeviceId       = $instance.managedDeviceId
            AzureADDeviceId       = $instance.azureADDeviceId
            DeviceModel           = $instance.deviceModel
            DeviceManufacturer    = $instance.deviceManufacturer
            FlaggedReasons        = $instance.flaggedReasons
            Version               = $instance.version
            PatchVersion          = $instance.patchVersion
            AppIdentifier         = $instance.appIdentifier.packageId
            OperationsContext     = $instance."operations@odata.context"
            Operations            = $instance.operations
        }
        return [System.Collections.Hashtable] $results
    }
    catch
    {
        Write-Verbose -Message $_
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
        [System.String]
        $Wipe,

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
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens,

        [Parameter()]
        [System.String]
        $deviceTag,

        [Parameter()]
        [System.String]
        $deviceName,

        [Parameter()]
        [System.String]
        $version,

        [Parameter()]
        [System.String]
        $patchVersion,

        [Parameter()]
        [System.Collections.Hashtable]
        $appIdentifier
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

    $setParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    # CREATE
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        New-MgBetaDeviceAppManagementTargetedManagedAppConfiguration -Id $Wipe `
        -DisplayName $deviceName `
        -Description $deviceTag `
        -ApplicationVersion $applicationVersion `
        -ManagementSdkVersion $managementSdkVersion `
        -PlatformVersion $platformVersion `
        -PatchVersion $patchVersion `
        @SetParameters
    }

    # UPDATE
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Update-MgBetaDeviceAppManagementTargetedManagedAppConfiguration -TargetedManagedAppConfigurationId $currentInstance.Wipe `
        -DisplayName $deviceName `
        -Description $deviceTag `
        -ApplicationVersion $applicationVersion `
        -ManagementSdkVersion $managementSdkVersion `
        -PlatformVersion $platformVersion `
        -PatchVersion $patchVersion `
        @SetParameters
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Remove-MgBetaDeviceAppManagementTargetedManagedAppConfiguration -TargetedManagedAppConfigurationId $currentInstance.Id `
        @SetParameters
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
        $Wipe,

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
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Wipe,

        [Parameter()]
        [System.String]
        $createdDateTime,

        [Parameter()]
        [System.String]
        $lastSyncDateTime,

        [Parameter()]
        [System.String]
        $applicationVersion,

        [Parameter()]
        [System.String]
        $managementSdkVersion,

        [Parameter()]
        [System.String]
        $platformVersion,

        [Parameter()]
        [Switch]
        $deviceType,

        [Parameter()]
        [System.String]
        $deviceTag,

        [Parameter()]
        [System.String]
        $deviceName,

        [Parameter()]
        [System.String]
        $managedDeviceId,

        [Parameter()]
        [System.String]
        $azureADDeviceId,

        [Parameter()]
        [System.String]
        $deviceModel,

        [Parameter()]
        [System.String]
        $deviceManufacturer,

        [Parameter()]
        [System.String[]]
        $flaggedReasons,

        [Parameter()]
        [System.String]
        $userId,

        [Parameter()]
        [System.String]
        $id,

        [Parameter()]
        [System.String]
        $version,

        [Parameter()]
        [System.String]
        $patchVersion,

        [Parameter()]
        [System.Collections.Hashtable]
        $appIdentifier,

        [Parameter()]
        [System.String]
        $operationsContext,

        [Parameter()]
        [System.Collections.Hashtable[]]
        $operations
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

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).Clone()

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens,

        [Parameter()]
        [System.String]
        $deviceTag,

        [Parameter()]
        [System.String]
        $deviceName,

        [Parameter()]
        [System.String]
        $version,

        [Parameter()]
        [System.String]
        $patchVersion,

        [Parameter()]
        [System.Collections.Hashtable]
        $appIdentifier
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
        $Script:ExportMode = $true
        [array] $Script:exportedInstances = Get-MgBetaDeviceAppManagementTargetedManagedAppConfiguration -ErrorAction Stop

        $i = 1
        $dscContent = ''
        if ($Script:exportedInstances.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($config in $Script:exportedInstances)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.Id
            Write-Host "    |---[$i/$($Script:exportedInstances.Count)] $displayedKey" -NoNewline
            $params = @{
                PrimaryKey            = $config.Wipe
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
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
