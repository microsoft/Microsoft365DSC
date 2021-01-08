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
        $PasscodeBlockSimple,

        [Parameter()]
        [System.Int64]
        $PasscodeExpirationDays,

        [Parameter()]
        [System.Int64]
        $PasscodeMinimumLength,

        [Parameter()]
        [System.Int64]
        $PasscodeMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int64]
        $PasscodePreviousPasscodeBlockCount,

        [Parameter()]
        [System.Int64]
        $PasscodeMinimumCharacterSetCount,

        [Parameter()]
        [System.String]
        $PasscodeRequiredType,

        [Parameter()]
        [System.Boolean]
        $PasscodeRequired,

        [Parameter()]
        [System.String]
        $OsMinimumVersion,

        [Parameter()]
        [System.String]
        $OsMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $SecurityBlockJailbrokenDevices,

        [Parameter()]
        [System.Boolean]
        $DeviceThreatProtectionEnabled,

        [Parameter()]
        [System.String]
        $DeviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.Boolean]
        $ManagedEmailProfileRequired,

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
    $data.Add('Resource', $ResourceName)
    $data.Add('Method', $MyInvocation.MyCommand)
    $data.Add('Principal', $GlobalAdminAccount.UserName)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Checking for the Intune Device Compliance iOS Policy {$DisplayName}"
    $ConnectionMode = New-M365DSCConnection -Platform 'Intune' `
        -InboundParameters $PSBoundParameters

    $nullResult = $PSBoundParameters
    $nullResult.Ensure = 'Absent'
    try
    {
        $devicePolicy = Get-DeviceManagement_DeviceCompliancePolicies `
            -ErrorAction Stop | Where-Object `
            -FilterScript { ($_.deviceCompliancePolicyODataType) -eq 'microsoft.graph.iosCompliancePolicy' -and `
                $_.displayName -eq $($DisplayName) }

        if ($null -eq $devicePolicy)
        {
            Write-Verbose -Message "No iOS Device Compliance Policy with displayName {$DisplayName} was found"
            return $nullResult
        }

        Write-Verbose -Message "Found iOS Device Compliance Policy with displayName {$DisplayName}"
        $results = @{
            DisplayName                                 = $devicePolicy.displayName
            Description                                 = $devicePolicy.description
            PasscodeBlockSimple                         = $devicePolicy.PasscodeBlockSimple
            PasscodeExpirationDays                      = $devicePolicy.PasscodeExpirationDays
            PasscodeMinimumLength                       = $devicePolicy.PasscodeMinimumLength
            PasscodeMinutesOfInactivityBeforeLock       = $devicePolicy.PasscodeMinutesOfInactivityBeforeLock
            PasscodePreviousPasscodeBlockCount          = $devicePolicy.PasscodePreviousPasscodeBlockCount
            PasscodeMinimumCharacterSetCount            = $devicePolicy.PasscodeMinimumCharacterSetCount
            PasscodeRequiredType                        = $devicePolicy.PasscodeRequiredType
            PasscodeRequired                            = $devicePolicy.PasscodeRequired
            OsMinimumVersion                            = $devicePolicy.OsMinimumVersion
            OsMaximumVersion                            = $devicePolicy.OsMaximumVersion
            SecurityBlockJailbrokenDevices              = $devicePolicy.SecurityBlockJailbrokenDevices
            DeviceThreatProtectionEnabled               = $devicePolicy.DeviceThreatProtectionEnabled
            DeviceThreatProtectionRequiredSecurityLevel = $devicePolicy.DeviceThreatProtectionRequiredSecurityLevel
            ManagedEmailProfileRequired                 = $devicePolicy.ManagedEmailProfileRequired
            Ensure                                      = 'Present'
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
        $PasscodeBlockSimple,

        [Parameter()]
        [System.Int64]
        $PasscodeExpirationDays,

        [Parameter()]
        [System.Int64]
        $PasscodeMinimumLength,

        [Parameter()]
        [System.Int64]
        $PasscodeMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int64]
        $PasscodePreviousPasscodeBlockCount,

        [Parameter()]
        [System.Int64]
        $PasscodeMinimumCharacterSetCount,

        [Parameter()]
        [System.String]
        $PasscodeRequiredType,

        [Parameter()]
        [System.Boolean]
        $PasscodeRequired,

        [Parameter()]
        [System.String]
        $OsMinimumVersion,

        [Parameter()]
        [System.String]
        $OsMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $SecurityBlockJailbrokenDevices,

        [Parameter()]
        [System.Boolean]
        $DeviceThreatProtectionEnabled,

        [Parameter()]
        [System.String]
        $DeviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.Boolean]
        $ManagedEmailProfileRequired,

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
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    Write-Verbose -Message "Intune Device Compliance iOS Policy {$DisplayName}"

    $ConnectionMode = New-M365DSCConnection -Platform 'Intune' `
        -InboundParameters $PSBoundParameters

    $currentDeviceiOsPolicy = Get-TargetResource @PSBoundParameters

    $PSBoundParameters.Remove('Ensure')
    $PSBoundParameters.Remove('$GlobalAdminAccount')

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

    if ($Ensure -eq 'Present' -and $currentDeviceiOsPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Intune Device Compliance iOS Policy {$DisplayName}"
        New-DeviceManagement_DeviceCompliancePolicies -iosCompliancePolicy @PSBoundParameters -scheduledActionsForRule $jsonObject
    }
    elseif ($Ensure -eq 'Present' -and $currentDeviceiOsPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating Intune Device Compliance iOS Policy {$DisplayName}"
        $configDeviceiOsPolicy = Get-DeviceManagement_DeviceCompliancePolicies `
            -ErrorAction Stop | Where-Object `
            -FilterScript { ($_.deviceCompliancePolicyODataType) -eq 'microsoft.graph.iosCompliancePolicy' -and `
            $_.displayName -eq $($DisplayName) }
        Update-DeviceManagement_DeviceCompliancePolicies -iosCompliancePolicy `
            -deviceCompliancePolicyId $configDeviceiOsPolicy.deviceCompliancePolicyId @PSBoundParameters
    }
    elseif ($Ensure -eq 'Absent' -and $currentDeviceiOsPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Intune Device Compliance iOS Policy {$DisplayName}"
        $configDeviceiOsPolicy = Get-DeviceManagement_DeviceCompliancePolicies `
            -ErrorAction Stop | Where-Object `
            -FilterScript { ($_.deviceCompliancePolicyODataType) -eq 'microsoft.graph.iosCompliancePolicy' -and `
            $_.displayName -eq $($DisplayName) }

        Remove-DeviceManagement_DeviceCompliancePolicies -deviceCompliancePolicyId $configDeviceiOsPolicy.deviceCompliancePolicyId
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
        $PasscodeBlockSimple,

        [Parameter()]
        [System.Int64]
        $PasscodeExpirationDays,

        [Parameter()]
        [System.Int64]
        $PasscodeMinimumLength,

        [Parameter()]
        [System.Int64]
        $PasscodeMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int64]
        $PasscodePreviousPasscodeBlockCount,

        [Parameter()]
        [System.Int64]
        $PasscodeMinimumCharacterSetCount,

        [Parameter()]
        [System.String]
        $PasscodeRequiredType,

        [Parameter()]
        [System.Boolean]
        $PasscodeRequired,

        [Parameter()]
        [System.String]
        $OsMinimumVersion,

        [Parameter()]
        [System.String]
        $OsMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $SecurityBlockJailbrokenDevices,

        [Parameter()]
        [System.Boolean]
        $DeviceThreatProtectionEnabled,

        [Parameter()]
        [System.String]
        $DeviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.Boolean]
        $ManagedEmailProfileRequired,

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
    Write-Verbose -Message "Testing configuration of Intune Device Compliance iOS Policy {$DisplayName}"

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
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'Intune' `
        -InboundParameters $PSBoundParameters

    try
    {
        [array]$configDeviceiOsPolicies = Get-DeviceManagement_DeviceCompliancePolicies `
            -ErrorAction Stop | Where-Object `
            -FilterScript { ($_.deviceCompliancePolicyODataType) -eq 'microsoft.graph.iosCompliancePolicy'}
        $i = 1
        $content = ''
        Write-Host "`r`n" -NoNewline
        foreach ($configDeviceiOsPolicy in $configDeviceiOsPolicies)
        {
            Write-Host "    |---[$i/$($configDeviceiOsPolicies.Count)] $($configDeviceiOsPolicy.displayName)" -NoNewline
            $params = @{
                DisplayName        = $configDeviceiOsPolicy.displayName
                Ensure             = 'Present'
                GlobalAdminAccount = $GlobalAdminAccount
            }
            $result = Get-TargetResource @params
            $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
            $content += "        IntuneDeviceCompliancePolicyiOs " + (New-Guid).ToString() + "`r`n"
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
