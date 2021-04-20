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
        $passwordRequired,

        [Parameter()]
        [System.String[]]
        $roleScopeTagIds,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceDefault', 'alphabetic', 'alphanumeric', 'alphanumericWithSymbols', 'lowSecurityBiometric', 'numeric', 'numericComplex', 'any')]
        $passwordRequiredType,

        [Parameter()]
        [System.Int32]
        $passwordMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int32]
        $passwordMinimumLength,

        [Parameter()]
        [System.Int32]
        $passwordMinimumLetterCharacters,

        [Parameter()]
        [System.Int32]
        $passwordMinimumLowerCaseCharacters,

        [Parameter()]
        [System.Int32]
        $passwordMinimumNonLetterCharacters,

        [Parameter()]
        [System.Int32]
        $passwordMinimumNumericCharacters,

        [Parameter()]
        [System.Int32]
        $passwordMinimumSymbolCharacters,

        [Parameter()]
        [System.Int32]
        $passwordMinimumUpperCaseCharacters,

        [Parameter()]
        [System.Boolean]
        $storageRequireEncryption,

        [Parameter()]
        [System.Int32]
        $passwordExpirationDays,

        [Parameter()]
        [System.Int32]
        $passwordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Boolean]
        $deviceThreatProtectionEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet('unavailable', 'secured', 'low', 'medium', 'high', 'notSet')]
        $DeviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.String]
        [ValidateSet('unavailable', 'secured', 'low', 'medium', 'high', 'notSet')]
        $advancedThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.String]
        $osMinimumVersion,

        [Parameter()]
        [System.String]
        $osMaximumVersion,

        [Parameter()]
        [System.String]
        $minAndroidSecurityPatchLevel,

        [Parameter()]
        [System.Boolean]
        $securityRequireSafetyNetAttestationBasicIntegrity,

        [Parameter()]
        [System.Boolean]
        $securityRequireSafetyNetAttestationCertifiedDevice,

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

    Write-Verbose -Message "Checking for the Intune Device Owner Device Compliance Android Policy {$DisplayName}"
    $ConnectionMode = New-M365DSCConnection -Platform 'Intune' `
        -InboundParameters $PSBoundParameters

    $nullResult = $PSBoundParameters
    $nullResult.Ensure = 'Absent'
    try
    {
        $devicePolicy = Get-DeviceManagement_DeviceCompliancePolicies `
            -ErrorAction Stop | Where-Object `
            -FilterScript { ($_.deviceCompliancePolicyODataType) -eq 'microsoft.graph.androidDeviceOwnerCompliancePolicy' -and `
                $_.displayName -eq $($DisplayName) }

        if ($null -eq $devicePolicy)
        {
            Write-Verbose -Message "No Android Device Owner Device Compliance Policy with displayName {$DisplayName} was found"
            return $nullResult
        }

        Write-Verbose -Message "Found Android Device Owner Device Compliance Policy with displayName {$DisplayName}"
        $results = @{
            DisplayName                                         = $devicePolicy.displayName
            Description                                         = $devicePolicy.description
            PasswordRequired                                    = $devicePolicy.passwordRequired
            PasswordMinimumLength                               = $devicePolicy.passwordMinimumLength
            PasswordRequiredType                                = $devicePolicy.passwordRequiredType
            RequiredPasswordComplexity                          = $devicePolicy.requiredPasswordComplexity
            PasswordMinutesOfInactivityBeforeLock               = $devicePolicy.passwordMinutesOfInactivityBeforeLock
            PasswordExpirationDays                              = $devicePolicy.passwordExpirationDays
            PasswordPreviousPasswordBlockCount                  = $devicePolicy.passwordPreviousPasswordBlockCount
            PasswordSignInFailureCountBeforeFactoryReset        = $devicePolicy.passwordSignInFailureCountBeforeFactoryReset
            SecurityPreventInstallAppsFromUnknownSources        = $devicePolicy.securityPreventInstallAppsFromUnknownSources
            SecurityDisableUsbDebugging                         = $devicePolicy.securityDisableUsbDebugging
            SecurityRequireVerifyApps                           = $devicePolicy.securityRequireVerifyApps
            DeviceThreatProtectionEnabled                       = $devicePolicy.deviceThreatProtectionEnabled
            DeviceThreatProtectionRequiredSecurityLevel         = $devicePolicy.deviceThreatProtectionRequiredSecurityLevel
            AdvancedThreatProtectionRequiredSecurityLevel       = $devicePolicy.advancedThreatProtectionRequiredSecurityLevel
            SecurityBlockJailbrokenDevices                      = $devicePolicy.securityBlockJailbrokenDevices
            SecurityBlockDeviceAdministratorManagedDevices      = $devicePolicy.securityBlockDeviceAdministratorManagedDevices
            osMinimumVersion                                    = $devicePolicy.osMinimumVersion
            osMaximumVersion                                    = $devicePolicy.osMaximumVersion
            StorageRequireEncryption                            = $devicePolicy.storageRequireEncryption
            SecurityRequireSafetyNetAttestationBasicIntegrity   = $devicePolicy.securityRequireSafetyNetAttestationBasicIntegrity
            SecurityRequireSafetyNetAttestationCertifiedDevice  = $devicePolicy.securityRequireSafetyNetAttestationCertifiedDevice
            SecurityRequireGooglePlayServices                   = $devicePolicy.securityRequireGooglePlayServices
            SecurityRequireUpToDateSecurityProviders            = $devicePolicy.securityRequireUpToDateSecurityProviders
            SecurityRequireCompanyPortalAppIntegrity            = $devicePolicy.securityRequireCompanyPortalAppIntegrity
            ConditionStatementId                                = $devicePolicy.conditionStatementId
            RestrictedApps                                      = $devicePolicy.restrictedApps
            RoleScopeTagIds                                     = $devicePolicy.roleScopeTagIds
            Ensure                                              = 'Present'
            GlobalAdminAccount                                  = $GlobalAdminAccount
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
        $passwordRequired,

        [Parameter()]
        [System.String[]]
        $roleScopeTagIds,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceDefault', 'alphabetic', 'alphanumeric', 'alphanumericWithSymbols', 'lowSecurityBiometric', 'numeric', 'numericComplex', 'any')]
        $passwordRequiredType,

        [Parameter()]
        [System.Int32]
        $passwordMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int32]
        $passwordMinimumLength,

        [Parameter()]
        [System.Int32]
        $passwordMinimumLetterCharacters,

        [Parameter()]
        [System.Int32]
        $passwordMinimumLowerCaseCharacters,

        [Parameter()]
        [System.Int32]
        $passwordMinimumNonLetterCharacters,

        [Parameter()]
        [System.Int32]
        $passwordMinimumNumericCharacters,

        [Parameter()]
        [System.Int32]
        $passwordMinimumSymbolCharacters,

        [Parameter()]
        [System.Int32]
        $passwordMinimumUpperCaseCharacters,

        [Parameter()]
        [System.Boolean]
        $storageRequireEncryption,

        [Parameter()]
        [System.Int32]
        $passwordExpirationDays,

        [Parameter()]
        [System.Int32]
        $passwordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Boolean]
        $deviceThreatProtectionEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet('unavailable', 'secured', 'low', 'medium', 'high', 'notSet')]
        $DeviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.String]
        [ValidateSet('unavailable', 'secured', 'low', 'medium', 'high', 'notSet')]
        $advancedThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.String]
        $osMinimumVersion,

        [Parameter()]
        [System.String]
        $osMaximumVersion,

        [Parameter()]
        [System.String]
        $minAndroidSecurityPatchLevel,

        [Parameter()]
        [System.Boolean]
        $securityRequireSafetyNetAttestationBasicIntegrity,

        [Parameter()]
        [System.Boolean]
        $securityRequireSafetyNetAttestationCertifiedDevice,

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
    Write-Verbose -Message "Intune Device Owner Device Compliance Android Policy {$DisplayName}"

    $ConnectionMode = New-M365DSCConnection -Platform 'Intune' `
        -InboundParameters $PSBoundParameters

    $currentDeviceAndroidPolicy = Get-TargetResource @PSBoundParameters

    $PSBoundParameters.Remove('Ensure')
    $PSBoundParameters.Remove('GlobalAdminAccount')

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

    if ($Ensure -eq 'Present' -and $currentDeviceAndroidPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Intune Android Device Owner Device Compliance Policy {$DisplayName}"
        New-DeviceManagement_DeviceCompliancePolicies -OdataType 'microsoft.graph.androidDeviceOwnerCompliancePolicy' @PSBoundParameters -scheduledActionsForRule $jsonObject
    }
    elseif ($Ensure -eq 'Present' -and $currentDeviceAndroidPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating Intune Android Device Owner Device Compliance Policy {$DisplayName}"
        $configDeviceAndroidPolicy = Get-DeviceManagement_DeviceCompliancePolicies `
            -ErrorAction Stop | Where-Object `
            -FilterScript { ($_.deviceCompliancePolicyODataType) -eq 'microsoft.graph.androidDeviceOwnerCompliancePolicy' -and `
            $_.displayName -eq $($DisplayName) }
        Update-DeviceManagement_DeviceCompliancePolicies -AndroidCompliancePolicy `
            -deviceCompliancePolicyId $configDeviceAndroidPolicy.deviceCompliancePolicyId @PSBoundParameters
    }
    elseif ($Ensure -eq 'Absent' -and $currentDeviceAndroidPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Intune Android Device Owner Device Compliance Policy {$DisplayName}"
        $configDeviceAndroidPolicy = Get-DeviceManagement_DeviceCompliancePolicies `
            -ErrorAction Stop | Where-Object `
            -FilterScript { ($_.deviceCompliancePolicyODataType) -eq 'microsoft.graph.androidDeviceOwnerCompliancePolicy' -and `
            $_.displayName -eq $($DisplayName) }

        Remove-DeviceManagement_DeviceCompliancePolicies -deviceCompliancePolicyId $configDeviceAndroidPolicy.deviceCompliancePolicyId
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
        $passwordRequired,

        [Parameter()]
        [System.String[]]
        $roleScopeTagIds,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceDefault', 'alphabetic', 'alphanumeric', 'alphanumericWithSymbols', 'lowSecurityBiometric', 'numeric', 'numericComplex', 'any')]
        $passwordRequiredType,

        [Parameter()]
        [System.Int32]
        $passwordMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int32]
        $passwordMinimumLength,

        [Parameter()]
        [System.Int32]
        $passwordMinimumLetterCharacters,

        [Parameter()]
        [System.Int32]
        $passwordMinimumLowerCaseCharacters,

        [Parameter()]
        [System.Int32]
        $passwordMinimumNonLetterCharacters,

        [Parameter()]
        [System.Int32]
        $passwordMinimumNumericCharacters,

        [Parameter()]
        [System.Int32]
        $passwordMinimumSymbolCharacters,

        [Parameter()]
        [System.Int32]
        $passwordMinimumUpperCaseCharacters,

        [Parameter()]
        [System.Boolean]
        $storageRequireEncryption,

        [Parameter()]
        [System.Int32]
        $passwordExpirationDays,

        [Parameter()]
        [System.Int32]
        $passwordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Boolean]
        $deviceThreatProtectionEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet('unavailable', 'secured', 'low', 'medium', 'high', 'notSet')]
        $DeviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.String]
        [ValidateSet('unavailable', 'secured', 'low', 'medium', 'high', 'notSet')]
        $advancedThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.String]
        $osMinimumVersion,

        [Parameter()]
        [System.String]
        $osMaximumVersion,

        [Parameter()]
        [System.String]
        $minAndroidSecurityPatchLevel,

        [Parameter()]
        [System.Boolean]
        $securityRequireSafetyNetAttestationBasicIntegrity,

        [Parameter()]
        [System.Boolean]
        $securityRequireSafetyNetAttestationCertifiedDevice,

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
    Write-Verbose -Message "Testing configuration of Intune Android Device Owner Device Compliance Policy {$DisplayName}"

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
        [array]$configDeviceAndroidPolicies = Get-DeviceManagement_DeviceCompliancePolicies `
            -ErrorAction Stop | Where-Object `
            -FilterScript { ($_.deviceCompliancePolicyODataType) -eq 'microsoft.graph.androidDeviceOwnerCompliancePolicy'}
        $i = 1
        $content = ''
        Write-Host "`r`n" -NoNewline
        foreach ($configDeviceAndroidPolicy in $configDeviceAndroidPolicies)
        {
            Write-Host "    |---[$i/$($configDeviceAndroidPolicies.Count)] $($configDeviceAndroidPolicy.displayName)" -NoNewline
            $params = @{
                DisplayName        = $configDeviceAndroidPolicy.displayName
                Ensure             = 'Present'
                GlobalAdminAccount = $GlobalAdminAccount
            }
            $result = Get-TargetResource @params
            $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
            $content += "        IntuneAndroidDeviceOwnerDeviceCompliancePolicy " + (New-Guid).ToString() + "`r`n"
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
