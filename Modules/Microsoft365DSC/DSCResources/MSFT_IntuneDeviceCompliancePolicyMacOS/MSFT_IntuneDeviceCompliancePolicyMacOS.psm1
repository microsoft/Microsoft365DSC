function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $PasswordRequired,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockSimple,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumCharacterSetCount,

        [Parameter()]
        [System.String]
        [ValidateSet('DeviceDefault','Alphanumeric','Numeric')]
        $PasswordRequiredType,

        [Parameter()]
        [System.String]
        $OsMinimumVersion,

        [Parameter()]
        [System.String]
        $OsMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $SystemIntegrityProtectionEnabled,

        [Parameter()]
        [System.Boolean]
        $DeviceThreatProtectionEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet('Unavailable','Secured','Low', 'Medium','High','NotSet')]
        $DeviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.Boolean]
        $StorageRequireEncryption,

        [Parameter()]
        [System.Boolean]
        $FirewallEnabled,

        [Parameter()]
        [System.Boolean]
        $FirewallBlockAllIncoming,

        [Parameter()]
        [System.Boolean]
        $FirewallEnableStealthMode,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure,

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
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Checking for the Intune Device Compliance MacOS Policy {$DisplayName}"
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullResult = $PSBoundParameters
    $nullResult.Ensure = 'Absent'
    try
    {
        $devicePolicy = Get-MGDeviceManagementDeviceCompliancePolicy `
            -ErrorAction Stop | Where-Object `
            -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.macOSCompliancePolicy' -and `
            $_.displayName -eq $($DisplayName) }

        if ($null -eq $devicePolicy)
        {
            Write-Verbose -Message "No MacOS Device Compliance Policy with displayName {$DisplayName} was found"
            return $nullResult
        }

        Write-Verbose -Message "Found MacOS Device Compliance Policy with displayName {$DisplayName}"
        $results = @{
            DisplayName                                 = $devicePolicy.DisplayName
            Description                                 = $devicePolicy.Description
            PasswordRequired                            = $devicePolicy.AdditionalProperties.passwordRequired
            PasswordBlockSimple                         = $devicePolicy.AdditionalProperties.passwordBlockSimple
            PasswordExpirationDays                      = $devicePolicy.AdditionalProperties.passwordExpirationDays
            PasswordMinimumLength                       = $devicePolicy.AdditionalProperties.passwordMinimumLength
            PasswordMinutesOfInactivityBeforeLock       = $devicePolicy.AdditionalProperties.passwordMinutesOfInactivityBeforeLock
            PasswordPreviousPasswordBlockCount          = $devicePolicy.AdditionalProperties.passwordPreviousPasswordBlockCount
            PasswordMinimumCharacterSetCount            = $devicePolicy.AdditionalProperties.passwordMinimumCharacterSetCount
            PasswordRequiredType                        = $devicePolicy.AdditionalProperties.passwordRequiredType
            OsMinimumVersion                            = $devicePolicy.AdditionalProperties.osMinimumVersion
            OsMaximumVersion                            = $devicePolicy.AdditionalProperties.osMaximumVersion
            SystemIntegrityProtectionEnabled            = $devicePolicy.AdditionalProperties.systemIntegrityProtectionEnabled
            DeviceThreatProtectionEnabled               = $devicePolicy.AdditionalProperties.deviceThreatProtectionEnabled
            DeviceThreatProtectionRequiredSecurityLevel = $devicePolicy.AdditionalProperties.deviceThreatProtectionRequiredSecurityLevel
            StorageRequireEncryption                    = $devicePolicy.AdditionalProperties.storageRequireEncryption
            FirewallEnabled                             = $devicePolicy.AdditionalProperties.firewallEnabled
            FirewallBlockAllIncoming                    = $devicePolicy.AdditionalProperties.firewallBlockAllIncoming
            FirewallEnableStealthMode                   = $devicePolicy.AdditionalProperties.firewallEnableStealthMode
            Ensure                                      = 'Present'
            Credential                          = $Credential
            ApplicationId                               = $ApplicationId
            TenantId                                    = $TenantId
            ApplicationSecret                           = $ApplicationSecret
            CertificateThumbprint                       = $CertificateThumbprint
        }
        return [System.Collections.Hashtable] $results
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
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
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $PasswordRequired,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockSimple,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumCharacterSetCount,

        [Parameter()]
        [System.String]
        [ValidateSet('DeviceDefault','Alphanumeric','Numeric')]
        $PasswordRequiredType,

        [Parameter()]
        [System.String]
        $OsMinimumVersion,

        [Parameter()]
        [System.String]
        $OsMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $SystemIntegrityProtectionEnabled,

        [Parameter()]
        [System.Boolean]
        $DeviceThreatProtectionEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet('Unavailable','Secured','Low', 'Medium','High','NotSet')]
        $DeviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.Boolean]
        $StorageRequireEncryption,

        [Parameter()]
        [System.Boolean]
        $FirewallEnabled,

        [Parameter()]
        [System.Boolean]
        $FirewallBlockAllIncoming,

        [Parameter()]
        [System.Boolean]
        $FirewallEnableStealthMode,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure,

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
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )


    Write-Verbose -Message "Intune Device Compliance MacOS Policy {$DisplayName}"

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentDeviceMacOsPolicy = Get-TargetResource @PSBoundParameters

    $PSBoundParameters.Remove('Ensure') | Out-Null
    $PSBoundParameters.Remove('Credential') | Out-Null
    $PSBoundParameters.Remove('ApplicationId') | Out-Null
    $PSBoundParameters.Remove('TenantId') | Out-Null
    $PSBoundParameters.Remove('ApplicationSecret') | Out-Null

    $scheduledActionsForRule = @{
        '@odata.type'                 = "#microsoft.graph.deviceComplianceScheduledActionForRule"
        ruleName                      = "PasswordRequired"
        scheduledActionConfigurations = @(
            @{
                "@odata.type"= "#microsoft.graph.deviceComplianceActionItem"
                actionType   =  "block"
            }
        )
    }

    if ($Ensure -eq 'Present' -and $currentDeviceMacOsPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Intune Device Compliance MacOS Policy {$DisplayName}"
        $PSBoundParameters.Remove('DisplayName') | Out-Null
        $PSBoundParameters.Remove('Description') | Out-Null
        $AdditionalProperties = Get-M365DSCIntuneDeviceCompliancePolicyMacOSAdditionalProperties -Properties ([System.Collections.Hashtable]$PSBoundParameters)
        New-MGDeviceManagementDeviceCompliancePolicy -DisplayName $DisplayName `
            -Description $Description `
            -additionalProperties $AdditionalProperties `
            -scheduledActionsForRule $scheduledActionsForRule
    }
    elseif ($Ensure -eq 'Present' -and $currentDeviceMacOsPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating Intune Device Compliance MacOS Policy {$DisplayName}"
        $configDevicePolicy = Get-MGDeviceManagementDeviceCompliancePolicy `
        -ErrorAction Stop | Where-Object `
        -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.macOSCompliancePolicy' -and `
            $_.displayName -eq $($DisplayName) }

        $PSBoundParameters.Remove('DisplayName') | Out-Null
        $PSBoundParameters.Remove('Description') | Out-Null
        $AdditionalProperties = Get-M365DSCIntuneDeviceCompliancePolicyMacOSAdditionalProperties -Properties ([System.Collections.Hashtable]$PSBoundParameters)
        Update-MGDeviceManagementDeviceCompliancePolicy -AdditionalProperties $AdditionalProperties `
            -Description $Description `
            -DeviceCompliancePolicyId $configDevicePolicy.Id
    }
    elseif ($Ensure -eq 'Absent' -and $currentDeviceMacOsPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Intune Device Compliance MacOS Policy {$DisplayName}"
        $configDevicePolicy = Get-MGDeviceManagementDeviceCompliancePolicy `
            -ErrorAction Stop | Where-Object `
            -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.macOSCompliancePolicy' -and `
                $_.displayName -eq $($DisplayName) }

        Remove-MGDeviceManagementDeviceCompliancePolicy -DeviceCompliancePolicyId $configDevicePolicy.Id
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
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $PasswordRequired,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockSimple,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumCharacterSetCount,

        [Parameter()]
        [System.String]
        [ValidateSet('DeviceDefault','Alphanumeric','Numeric')]
        $PasswordRequiredType,

        [Parameter()]
        [System.String]
        $OsMinimumVersion,

        [Parameter()]
        [System.String]
        $OsMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $SystemIntegrityProtectionEnabled,

        [Parameter()]
        [System.Boolean]
        $DeviceThreatProtectionEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet('Unavailable','Secured','Low', 'Medium','High','NotSet')]
        $DeviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.Boolean]
        $StorageRequireEncryption,

        [Parameter()]
        [System.Boolean]
        $FirewallEnabled,

        [Parameter()]
        [System.Boolean]
        $FirewallBlockAllIncoming,

        [Parameter()]
        [System.Boolean]
        $FirewallEnableStealthMode,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure,

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
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of Intune Device Compliance MacOS Policy {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $TestResult"

    return $TestResult
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
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        [array]$configDeviceMacOsPolicies = Get-MGDeviceManagementDeviceCompliancePolicy `
            -ErrorAction Stop | Where-Object `
            -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.macOSCompliancePolicy' }
        $i = 1
        $content = ''
        if ($configDeviceMacOsPolicies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewLine
        }

        foreach ($configDeviceMacOsPolicy in $configDeviceMacOsPolicies)
        {
            Write-Host "    |---[$i/$($configDeviceMacOsPolicies.Count)] $($configDeviceMacOsPolicy.displayName)" -NoNewline
            $params = @{
                DisplayName           = $configDeviceMacOsPolicy.displayName
                Ensure                = 'Present'
                Credential    = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
            }
            $result = Get-TargetResource @params
            $result = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Result
            $content += "        IntuneDeviceCompliancePolicyMacOS " + (New-Guid).ToString() + "`r`n"
            $content += "        {`r`n"
            $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
            $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "Credential"
            $content += "        }`r`n"
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        return $content
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiGreenCheckMark
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return ""
    }
}

function Get-M365DSCIntuneDeviceCompliancePolicyMacOSAdditionalProperties
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Properties
    )

    $results = @{"@odata.type" = "#microsoft.graph.macOSCompliancePolicy"}
    foreach ($property in $properties.Keys)
    {
        if ($property -ne 'Verbose')
        {
            $propertyName = $property[0].ToString().ToLower() + $property.Substring(1, $property.Length - 1)
            $propertyValue = $properties.$property
            $results.Add($propertyName, $propertyValue)
        }
    }
    return $results
}

Export-ModuleMember -Function *-TargetResource
