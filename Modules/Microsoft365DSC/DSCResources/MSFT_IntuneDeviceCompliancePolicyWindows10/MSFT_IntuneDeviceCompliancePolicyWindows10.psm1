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
        [System.Boolean]
        $PasswordRequiredToUnlockFromIdle,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumCharacterSetCount,

        [Parameter()]
        [System.String]
        [ValidateSet('DeviceDefault', 'Alphanumeric', 'Numeric')]
        $PasswordRequiredType,

        [Parameter()]
        [System.Int32]
        $RequireHealthyDeviceReport,

        [Parameter()]
        [System.String]
        $OsMinimumVersion,

        [Parameter()]
        [System.String]
        $OsMaximumVersion,

        [Parameter()]
        [System.String]
        $MobileOsMinimumVersion,

        [Parameter()]
        [System.String]
        $MobileOsMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $EarlyLaunchAntiMalwareDriverEnabled,

        [Parameter()]
        [System.Boolean]
        $BitLockerEnabled,

        [Parameter()]
        [System.Boolean]
        $SecureBootEnabled,

        [Parameter()]
        [System.Boolean]
        $CodeIntegrityEnabled,

        [Parameter()]
        [System.Boolean]
        $StorageRequireEncryption,

        [Parameter()]
        [System.Boolean]
        $ActiveFirewallRequired,

        [Parameter()]
        [System.String]
        $DefenderVersion,

        [Parameter()]
        [System.Boolean]
        $SignatureOutOfDate,

        [Parameter()]
        [System.Boolean]
        $RTPEnabled,

        [Parameter()]
        [System.Boolean]
        $AntivirusRequired,

        [Parameter()]
        [System.Boolean]
        $AntiSpywareRequired,

        [Parameter()]
        [System.Boolean]
        $DeviceThreatProtectionEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet('Unavailable', 'Secured', 'Low', 'Medium', 'High', 'NotSet')]
        $DeviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.Boolean]
        $ConfigurationManagerComplianceRequired,

        [Parameter()]
        [System.Boolean]
        $TPMRequired,

        [Parameter()]
        [System.String]
        $DeviceCompliancePolicyScript,

        [Parameter()]
        [System.Array]
        $ValidOperatingSystemBuildRanges,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Checking for the Intune Device Compliance Windows 10 Policy {$DisplayName}"
    $ConnectionMode = New-M365DSCConnection -Platform 'Intune' `
        -InboundParameters $PSBoundParameters

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    $data.Add("ConnectionMode", $ConnectionMode)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullResult = $PSBoundParameters
    $nullResult.Ensure = 'Absent'
    try
    {
        $devicePolicy = Get-IntuneDeviceCompliancePolicy `
            -ErrorAction Stop | Where-Object `
            -FilterScript { ($_.deviceCompliancePolicyODataType) -eq 'microsoft.graph.windows10CompliancePolicy' -and `
                $_.displayName -eq $($DisplayName) }

        if ($null -eq $devicePolicy)
        {
            Write-Verbose -Message "No Windows 10 Device Compliance Policy with displayName {$DisplayName} was found"
            return $nullResult
        }

        Write-Verbose -Message "Found Windows 10 Device Compliance Policy with displayName {$DisplayName}"
        $results = @{
            DisplayName                                 = $devicePolicy.DisplayName
            Description                                 = $devicePolicy.Description
            PasswordRequired                            = $devicePolicy.PasswordRequired
            PasswordBlockSimple                         = $devicePolicy.PasswordBlockSimple
            PasswordRequiredToUnlockFromIdle            = $devicePolicy.PasswordRequiredToUnlockFromIdle
            PasswordMinutesOfInactivityBeforeLock       = $devicePolicy.PasswordMinutesOfInactivityBeforeLock
            PasswordExpirationDays                      = $devicePolicy.PasswordExpirationDays
            PasswordMinimumLength                       = $devicePolicy.PasswordMinimumLength
            PasswordMinimumCharacterSetCount            = $devicePolicy.PasswordMinimumCharacterSetCount
            PasswordRequiredType                        = $devicePolicy.PasswordRequiredType
            PasswordPreviousPasswordBlockCount          = $devicePolicy.PasswordPreviousPasswordBlockCount
            RequireHealthyDeviceReport                  = $devicePolicy.RequireHealthyDeviceReport
            OsMinimumVersion                            = $devicePolicy.OsMinimumVersion
            OsMaximumVersion                            = $devicePolicy.OsMaximumVersion
            MobileOsMinimumVersion                      = $devicePolicy.MobileOsMinimumVersion
            MobileOsMaximumVersion                      = $devicePolicy.MobileOsMaximumVersion
            EarlyLaunchAntiMalwareDriverEnabled         = $devicePolicy.EarlyLaunchAntiMalwareDriverEnabled
            BitLockerEnabled                            = $devicePolicy.BitLockerEnabled
            SecureBootEnabled                           = $devicePolicy.SecureBootEnabled
            CodeIntegrityEnabled                        = $devicePolicy.CodeIntegrityEnabled
            StorageRequireEncryption                    = $devicePolicy.StorageRequireEncryption
            ActiveFirewallRequired                      = $devicePolicy.ActiveFirewallRequired
            DefenderEnabled                             = $devicePolicy.DefenderEnabled
            DefenderVersion                             = $devicePolicy.DefenderVersion
            SignatureOutOfDate                          = $devicePolicy.SignatureOutOfDate
            RTPEnabled                                  = $devicePolicy.RTPEnabled
            AntivirusRequired                           = $devicePolicy.AntivirusRequired
            AntiSpywareRequired                         = $devicePolicy.AntiSpywareRequired
            DeviceThreatProtectionEnabled               = $devicePolicy.DeviceThreatProtectionEnabled
            DeviceThreatProtectionRequiredSecurityLevel = $devicePolicy.DeviceThreatProtectionRequiredSecurityLevel
            ConfigurationManagerComplianceRequired      = $devicePolicy.ConfigurationManagerComplianceRequired
            TPMRequired                                 = $devicePolicy.TPMRequired
            DeviceCompliancePolicyScript                = $devicePolicy.DeviceCompliancePolicyScript
            ValidOperatingSystemBuildRanges             = $devicePolicy.ValidOperatingSystemBuildRanges
            GlobalAdminAccount                          = $GlobalAdminAccount
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
            elseif ($null -ne $GlobalAdminAccount)
            {
                $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
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
        [System.Boolean]
        $PasswordRequiredToUnlockFromIdle,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumCharacterSetCount,

        [Parameter()]
        [System.String]
        [ValidateSet('DeviceDefault', 'Alphanumeric', 'Numeric')]
        $PasswordRequiredType,

        [Parameter()]
        [System.Int32]
        $RequireHealthyDeviceReport,

        [Parameter()]
        [System.String]
        $OsMinimumVersion,

        [Parameter()]
        [System.String]
        $OsMaximumVersion,

        [Parameter()]
        [System.String]
        $MobileOsMinimumVersion,

        [Parameter()]
        [System.String]
        $MobileOsMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $EarlyLaunchAntiMalwareDriverEnabled,

        [Parameter()]
        [System.Boolean]
        $BitLockerEnabled,

        [Parameter()]
        [System.Boolean]
        $SecureBootEnabled,

        [Parameter()]
        [System.Boolean]
        $CodeIntegrityEnabled,

        [Parameter()]
        [System.Boolean]
        $StorageRequireEncryption,

        [Parameter()]
        [System.Boolean]
        $ActiveFirewallRequired,

        [Parameter()]
        [System.String]
        $DefenderVersion,

        [Parameter()]
        [System.Boolean]
        $SignatureOutOfDate,

        [Parameter()]
        [System.Boolean]
        $RTPEnabled,

        [Parameter()]
        [System.Boolean]
        $AntivirusRequired,

        [Parameter()]
        [System.Boolean]
        $AntiSpywareRequired,

        [Parameter()]
        [System.Boolean]
        $DeviceThreatProtectionEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet('Unavailable', 'Secured', 'Low', 'Medium', 'High', 'NotSet')]
        $DeviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.Boolean]
        $ConfigurationManagerComplianceRequired,

        [Parameter()]
        [System.Boolean]
        $TPMRequired,

        [Parameter()]
        [System.String]
        $DeviceCompliancePolicyScript,

        [Parameter()]
        [System.Array]
        $ValidOperatingSystemBuildRanges,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )


    Write-Verbose -Message "Intune Device Compliance Windows 10 Policy {$DisplayName}"

    $ConnectionMode = New-M365DSCConnection -Platform 'Intune' `
        -InboundParameters $PSBoundParameters

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    $data.Add("ConnectionMode", $ConnectionMode)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentDeviceWindows10Policy = Get-TargetResource @PSBoundParameters

    $PSBoundParameters.Remove('Ensure') | Out-Null
    $PSBoundParameters.Remove('GlobalAdminAccount') | Out-Null

    $jsonParams = @"
{
    "@odata.type": "#microsoft.graph.deviceComplianceScheduledActionForRule",
    "ruleName": "PasswordRequired",
    "scheduledActionConfigurations":[
        {"actionType": "block"}
    ]
}
"@
    $jsonObject = $jsonParams | ConvertFrom-Json

    if ($Ensure -eq 'Present' -and $currentDeviceWindows10Policy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Intune Device Compliance Windows 10 Policy {$DisplayName}"
        New-IntuneDeviceCompliancePolicy -ODataType 'microsoft.graph.windows10CompliancePolicy' @PSBoundParameters -scheduledActionsForRule $jsonObject
    }
    elseif ($Ensure -eq 'Present' -and $currentDeviceWindows10Policy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating Intune Device Compliance Windows 10 Policy {$DisplayName}"
        $configDeviceWindows10Policy = Get-IntuneDeviceCompliancePolicy `
            -ErrorAction Stop | Where-Object `
            -FilterScript { ($_.deviceCompliancePolicyODataType) -eq 'microsoft.graph.windows10CompliancePolicy' -and `
                $_.displayName -eq $($DisplayName) }
        Update-IntuneDeviceCompliancePolicy -ODataType 'microsoft.graph.windows10CompliancePolicy' `
            -deviceCompliancePolicyId $configDeviceWindows10Policy.Id @PSBoundParameters
    }
    elseif ($Ensure -eq 'Absent' -and $currentDeviceWindows10Policy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Intune Device Compliance Windows 10 Policy {$DisplayName}"
        $configDeviceWindows10Policy = Get-IntuneDeviceCompliancePolicy `
            -ErrorAction Stop | Where-Object `
            -FilterScript { ($_.deviceCompliancePolicyODataType) -eq 'microsoft.graph.windows10CompliancePolicy' -and `
                $_.displayName -eq $($DisplayName) }

        Remove-IntuneDeviceCompliancePolicy -deviceCompliancePolicyId $configDeviceWindows10Policy.Id
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
        [System.Boolean]
        $PasswordRequiredToUnlockFromIdle,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumCharacterSetCount,

        [Parameter()]
        [System.String]
        [ValidateSet('DeviceDefault', 'Alphanumeric', 'Numeric')]
        $PasswordRequiredType,

        [Parameter()]
        [System.Int32]
        $RequireHealthyDeviceReport,

        [Parameter()]
        [System.String]
        $OsMinimumVersion,

        [Parameter()]
        [System.String]
        $OsMaximumVersion,

        [Parameter()]
        [System.String]
        $MobileOsMinimumVersion,

        [Parameter()]
        [System.String]
        $MobileOsMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $EarlyLaunchAntiMalwareDriverEnabled,

        [Parameter()]
        [System.Boolean]
        $BitLockerEnabled,

        [Parameter()]
        [System.Boolean]
        $SecureBootEnabled,

        [Parameter()]
        [System.Boolean]
        $CodeIntegrityEnabled,

        [Parameter()]
        [System.Boolean]
        $StorageRequireEncryption,

        [Parameter()]
        [System.Boolean]
        $ActiveFirewallRequired,

        [Parameter()]
        [System.String]
        $DefenderVersion,

        [Parameter()]
        [System.Boolean]
        $SignatureOutOfDate,

        [Parameter()]
        [System.Boolean]
        $RTPEnabled,

        [Parameter()]
        [System.Boolean]
        $AntivirusRequired,

        [Parameter()]
        [System.Boolean]
        $AntiSpywareRequired,

        [Parameter()]
        [System.Boolean]
        $DeviceThreatProtectionEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet('Unavailable', 'Secured', 'Low', 'Medium', 'High', 'NotSet')]
        $DeviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.Boolean]
        $ConfigurationManagerComplianceRequired,

        [Parameter()]
        [System.Boolean]
        $TPMRequired,

        [Parameter()]
        [System.String]
        $DeviceCompliancePolicyScript,

        [Parameter()]
        [System.Array]
        $ValidOperatingSystemBuildRanges,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of Intune Device Compliance Windows 10 Policy {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

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
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    $ConnectionMode = New-M365DSCConnection -Platform 'Intune' `
        -InboundParameters $PSBoundParameters

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    $data.Add("ConnectionMode", $ConnectionMode)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        [array]$configDeviceWindowsPolicies = Get-IntuneDeviceCompliancePolicy `
            -ErrorAction Stop | Where-Object `
            -FilterScript { ($_.deviceCompliancePolicyODataType) -eq 'microsoft.graph.windows10CompliancePolicy' }
        $i = 1
        $content = ''
        Write-Host "`r`n" -NoNewline

        foreach ($configDeviceWindowsPolicy in $configDeviceWindowsPolicies)
        {
            Write-Host "    |---[$i/$($configDeviceWindowsPolicies.Count)] $($configDeviceWindowsPolicy.displayName)" -NoNewline
            $params = @{
                DisplayName        = $configDeviceWindowsPolicy.displayName
                Ensure             = 'Present'
                GlobalAdminAccount = $GlobalAdminAccount
            }
            $result = Get-TargetResource @params
            $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
            $content += "        IntuneDeviceCompliancePolicyWindows10 " + (New-Guid).ToString() + "`r`n"
            $content += "        {`r`n"
            $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
            $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
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
            elseif ($null -ne $GlobalAdminAccount)
            {
                $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
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

Export-ModuleMember -Function *-TargetResource
