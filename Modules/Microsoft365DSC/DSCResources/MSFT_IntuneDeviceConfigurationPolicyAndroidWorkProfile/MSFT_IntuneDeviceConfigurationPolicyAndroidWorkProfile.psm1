function Get-TargetResource {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $True)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockFingerprintUnlock,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockTrustAgents,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,


        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Int32]
        $PasswordSignInFailureCountBeforeFactoryReset,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceDefault', 'lowSecurityBiometric', 'required', 'atLeastNumeric', 'numericComplex', 'atLeastAlphabetic', 'atLeastAlphanumeric', 'alphanumericWithSymbols')]
        $PasswordRequiredType,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceDefault', 'preventAny', 'allowPersonalToWork', 'noRestrictions')]
        $WorkProfileDataSharingType,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockNotificationsWhileDeviceLocked,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockAddingAccounts,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBluetoothEnableContactSharing,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockScreenCapture,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockCrossProfileCallerId,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockCamera,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockCrossProfileContactsSearch,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockCrossProfileCopyPaste,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceDefault', 'prompt', 'autoGrant', 'autoDeny')]
        $WorkProfileDefaultAppPermissionPolicy,

        [Parameter()]
        [System.Boolean]
        $WorkProfilePasswordBlockFingerprintUnlock,

        [Parameter()]
        [System.Boolean]
        $WorkProfilePasswordBlockTrustAgents,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinNumericCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinNonLetterCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinLetterCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinLowerCaseCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinUpperCaseCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinSymbolCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordSignInFailureCountBeforeFactoryReset,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceDefault', 'lowSecurityBiometric', 'required', 'atLeastNumeric', 'numericComplex', 'atLeastAlphabetic', 'atLeastAlphanumeric', 'alphanumericWithSymbols')]
        $WorkProfilePasswordRequiredType,

        [Parameter()]
        [System.Boolean]
        $WorkProfileRequirePassword,

        [Parameter()]
        [System.Boolean]
        $SecurityRequireVerifyApps,

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

    Write-Verbose -Message "Checking for the Intune Device Configuration Policy {$DisplayName}"

    $M365DSCConnectionSplat = @{
        Workload = 'MicrosoftGraph'
        InboundParameters = $PSBoundParameters
        ProfileName = 'Beta'
    }
    $ConnectionMode = New-M365DSCConnection @M365DSCConnectionSplat
    $MaximumFunctionCount = 32000
    Select-MGProfile -Name 'Beta' | Out-Null

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $Credential.UserName)
    $data.Add("TenantId", $TenantId)
    $data.Add("ConnectionMode", $ConnectionMode)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullResult = $PSBoundParameters
    $nullResult.Ensure = 'Absent'

    try
    {
        $policy = Get-MGDeviceManagementDeviceConfiguration -Filter "displayName eq '$DisplayName'" `
            -ErrorAction Stop | Where-Object -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.androidWorkProfileGeneralDeviceConfiguration' }

        if ($null -eq $policy)
        {
            Write-Verbose -Message "No Device Configuration Policy {$DisplayName} was found"
            return $nullResult
        }

        Write-Verbose -Message "Found Device Configuration Policy {$DisplayName}"
        return @{
            Description                                                 = $policy.Description
            DisplayName                                                 = $policy.DisplayName
            PasswordBlockFingerprintUnlock                              = $policy.AdditionalProperties.passwordBlockFingerprintUnlock
            PasswordBlockTrustAgents                                    = $policy.AdditionalProperties.passwordBlockTrustAgents
            PasswordExpirationDays                                      = $policy.AdditionalProperties.passwordExpirationDays
            PasswordMinimumLength                                       = $policy.AdditionalProperties.passwordMinimumLength
            PasswordMinutesOfInactivityBeforeScreenTimeout              = $policy.AdditionalProperties.passwordMinutesOfInactivityBeforeScreenTimeout
            PasswordPreviousPasswordBlockCount                          = $policy.AdditionalProperties.passwordPreviousPasswordBlockCount
            PasswordSignInFailureCountBeforeFactoryReset                = $policy.AdditionalProperties.passwordSignInFailureCountBeforeFactoryReset
            PasswordRequiredType                                        = $policy.AdditionalProperties.passwordRequiredType
            WorkProfileDataSharingType                                  = $policy.AdditionalProperties.workProfileDataSharingType
            WorkProfileBlockNotificationsWhileDeviceLocked              = $policy.AdditionalProperties.workProfileBlockAddingAccounts
            WorkProfileBlockAddingAccounts                              = $policy.AdditionalProperties.workProfileBlockAddingAccounts
            WorkProfileBluetoothEnableContactSharing                    = $policy.AdditionalProperties.workProfileBluetoothEnableContactSharing
            WorkProfileBlockScreenCapture                               = $policy.AdditionalProperties.workProfileBlockScreenCapture
            WorkProfileBlockCrossProfileCallerId                        = $policy.AdditionalProperties.workProfileBlockCrossProfileCallerId
            WorkProfileBlockCamera                                      = $policy.AdditionalProperties.workProfileBlockCamera
            WorkProfileBlockCrossProfileContactsSearch                  = $policy.AdditionalProperties.workProfileBlockCrossProfileContactsSearch
            WorkProfileBlockCrossProfileCopyPaste                       = $policy.AdditionalProperties.workProfileBlockCrossProfileCopyPaste
            WorkProfileDefaultAppPermissionPolicy                       = $policy.AdditionalProperties.workProfileDefaultAppPermissionPolicy
            WorkProfilePasswordBlockFingerprintUnlock                   = $policy.AdditionalProperties.workProfilePasswordBlockFingerprintUnlock
            WorkProfilePasswordBlockTrustAgents                         = $policy.AdditionalProperties.workProfilePasswordBlockTrustAgents
            WorkProfilePasswordExpirationDays                           = $policy.AdditionalProperties.workProfilePasswordExpirationDays
            WorkProfilePasswordMinimumLength                            = $policy.AdditionalProperties.workProfilePasswordMinimumLength
            WorkProfilePasswordMinNumericCharacters                     = $policy.AdditionalProperties.workProfilePasswordMinNumericCharacters
            WorkProfilePasswordMinNonLetterCharacters                   = $policy.AdditionalProperties.workProfilePasswordMinNonLetterCharacters
            WorkProfilePasswordMinLetterCharacters                      = $policy.AdditionalProperties.workProfilePasswordMinLetterCharacters
            WorkProfilePasswordMinLowerCaseCharacters                   = $policy.AdditionalProperties.workProfilePasswordMinLowerCaseCharacters
            WorkProfilePasswordMinUpperCaseCharacters                   = $policy.AdditionalProperties.workProfilePasswordMinUpperCaseCharacters
            WorkProfilePasswordMinSymbolCharacters                      = $policy.AdditionalProperties.workProfilePasswordMinSymbolCharacters
            WorkProfilePasswordMinutesOfInactivityBeforeScreenTimeout   = $policy.AdditionalProperties.workProfilePasswordMinutesOfInactivityBeforeScreenTimeout
            WorkProfilePasswordPreviousPasswordBlockCount               = $policy.AdditionalProperties.workProfilePasswordPreviousPasswordBlockCount
            WorkProfilePasswordSignInFailureCountBeforeFactoryReset     = $policy.AdditionalProperties.workProfilePasswordSignInFailureCountBeforeFactoryReset
            WorkProfilePasswordRequiredType                             = $policy.AdditionalProperties.workProfilePasswordRequiredType
            WorkProfileRequirePassword                                  = $policy.AdditionalProperties.workProfileRequirePassword
            SecurityRequireVerifyApps                                   = $policy.AdditionalProperties.securityRequireVerifyApps
            Ensure                                                      = "Present"
            Credential                                                  = $Credential
            ApplicationId                                               = $ApplicationId
            TenantId                                                    = $TenantId
            ApplicationSecret                                           = $ApplicationSecret
            CertificateThumbprint                                       = $CertificateThumbprint
        }
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            $tenantIdValue = $Credential.UserName.Split('@')[1]
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
        [Parameter(Mandatory = $True)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockFingerprintUnlock,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockTrustAgents,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,


        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Int32]
        $PasswordSignInFailureCountBeforeFactoryReset,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceDefault', 'lowSecurityBiometric', 'required', 'atLeastNumeric', 'numericComplex', 'atLeastAlphabetic', 'atLeastAlphanumeric', 'alphanumericWithSymbols')]
        $PasswordRequiredType,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceDefault', 'preventAny', 'allowPersonalToWork', 'noRestrictions')]
        $WorkProfileDataSharingType,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockNotificationsWhileDeviceLocked,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockAddingAccounts,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBluetoothEnableContactSharing,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockScreenCapture,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockCrossProfileCallerId,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockCamera,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockCrossProfileContactsSearch,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockCrossProfileCopyPaste,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceDefault', 'prompt', 'autoGrant', 'autoDeny')]
        $WorkProfileDefaultAppPermissionPolicy,

        [Parameter()]
        [System.Boolean]
        $WorkProfilePasswordBlockFingerprintUnlock,

        [Parameter()]
        [System.Boolean]
        $WorkProfilePasswordBlockTrustAgents,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinNumericCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinNonLetterCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinLetterCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinLowerCaseCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinUpperCaseCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinSymbolCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordSignInFailureCountBeforeFactoryReset,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceDefault', 'lowSecurityBiometric', 'required', 'atLeastNumeric', 'numericComplex', 'atLeastAlphabetic', 'atLeastAlphanumeric', 'alphanumericWithSymbols')]
        $WorkProfilePasswordRequiredType,

        [Parameter()]
        [System.Boolean]
        $WorkProfileRequirePassword,

        [Parameter()]
        [System.Boolean]
        $SecurityRequireVerifyApps,

        [Parameter(Mandatory = $True)]
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

    $M365DSCConnectionSplat = @{
        Workload = 'MicrosoftGraph'
        InboundParameters = $PSBoundParameters
        ProfileName = 'Beta'
    }
    $ConnectionMode = New-M365DSCConnection @M365DSCConnectionSplat
    $MaximumFunctionCount = 32000
    Select-MGProfile -Name 'Beta' | Out-Null

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $Credential.UserName)
    $data.Add("TenantId", $TenantId)
    $data.Add("ConnectionMode", $ConnectionMode)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentPolicy = Get-TargetResource @PSBoundParameters
    $PSBoundParameters.Remove("Ensure") | Out-Null
    $PSBoundParameters.Remove("Credential") | Out-Null
    $PSBoundParameters.Remove("ApplicationId") | Out-Null
    $PSBoundParameters.Remove("TenantId") | Out-Null
    $PSBoundParameters.Remove("ApplicationSecret") | Out-Null
    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Device Configuration Policy {$DisplayName}"
        $PSBoundParameters.Remove('DisplayName') | Out-Null
        $PSBoundParameters.Remove('Description') | Out-Null
        $AdditionalProperties = Get-M365DSCIntuneDeviceConfigurationPolicyAndroidWorkProfileAdditionalProperties -Properties ([System.Collections.Hashtable]$PSBoundParameters)
        New-MGDeviceManagementDeviceConfiguration -DisplayName $DisplayName `
            -Description $Description `
            -AdditionalProperties $AdditionalProperties
    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing Device Configuration Policy {$DisplayName}"
        $configDevicePolicy = Get-MGDeviceManagementDeviceConfiguration `
            -ErrorAction Stop | Where-Object `
            -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.androidWorkProfileGeneralDeviceConfiguration' -and `
                $_.displayName -eq $($DisplayName) }

        $PSBoundParameters.Remove('DisplayName') | Out-Null
        $PSBoundParameters.Remove('Description') | Out-Null
        $AdditionalProperties = Get-M365DSCIntuneDeviceConfigurationPolicyAndroidWorkProfileAdditionalProperties -Properties ([System.Collections.Hashtable]$PSBoundParameters)
        Update-MGDeviceManagementDeviceConfiguration -AdditionalProperties $AdditionalProperties `
            -Description $Description `
            -DeviceConfigurationId $configDevicePolicy.Id
    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Device Configuration Policy {$DisplayName}"
        $configDevicePolicy = Get-MGDeviceManagementDeviceConfiguration `
        -ErrorAction Stop | Where-Object `
        -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.androidWorkProfileGeneralDeviceConfiguration' -and `
            $_.displayName -eq $($DisplayName) }

        Remove-MGDeviceManagementDeviceConfiguration -DeviceConfigurationId $configDevicePolicy.Id
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
        $PasswordBlockFingerprintUnlock,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockTrustAgents,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,


        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Int32]
        $PasswordSignInFailureCountBeforeFactoryReset,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceDefault', 'lowSecurityBiometric', 'required', 'atLeastNumeric', 'numericComplex', 'atLeastAlphabetic', 'atLeastAlphanumeric', 'alphanumericWithSymbols')]
        $PasswordRequiredType,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceDefault', 'preventAny', 'allowPersonalToWork', 'noRestrictions')]
        $WorkProfileDataSharingType,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockNotificationsWhileDeviceLocked,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockAddingAccounts,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBluetoothEnableContactSharing,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockScreenCapture,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockCrossProfileCallerId,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockCamera,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockCrossProfileContactsSearch,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockCrossProfileCopyPaste,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceDefault', 'prompt', 'autoGrant', 'autoDeny')]
        $WorkProfileDefaultAppPermissionPolicy,

        [Parameter()]
        [System.Boolean]
        $WorkProfilePasswordBlockFingerprintUnlock,

        [Parameter()]
        [System.Boolean]
        $WorkProfilePasswordBlockTrustAgents,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinNumericCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinNonLetterCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinLetterCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinLowerCaseCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinUpperCaseCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinSymbolCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordSignInFailureCountBeforeFactoryReset,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceDefault', 'lowSecurityBiometric', 'required', 'atLeastNumeric', 'numericComplex', 'atLeastAlphabetic', 'atLeastAlphanumeric', 'alphanumericWithSymbols')]
        $WorkProfilePasswordRequiredType,

        [Parameter()]
        [System.Boolean]
        $WorkProfileRequirePassword,

        [Parameter()]
        [System.Boolean]
        $SecurityRequireVerifyApps,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $Credential.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    Write-Verbose -Message "Testing configuration of Device Configuration Policy {$DisplayName}"

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

    $M365DSCConnectionSplat = @{
        Workload = 'MicrosoftGraph'
        InboundParameters = $PSBoundParameters
        ProfileName = 'Beta'
    }
    $ConnectionMode = New-M365DSCConnection @M365DSCConnectionSplat
    $MaximumFunctionCount = 32000
    Select-MGProfile -Name 'Beta' | Out-Null

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $Credential.UserName)
    $data.Add("TenantId", $TenantId)
    $data.Add("ConnectionMode", $ConnectionMode)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        [array]$policies = Get-MGDeviceManagementDeviceConfiguration `
            -ErrorAction Stop | Where-Object `
            -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.androidWorkProfileGeneralDeviceConfiguration' }
        $i = 1
        $dscContent = ''
        if ($policies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewLine
        }
        foreach ($policy in $policies)
        {
            Write-Host "    |---[$i/$($policies.Count)] $($policy.DisplayName)" -NoNewline
            $params = @{
                DisplayName           = $policy.DisplayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
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
        Write-Host $_
        if ($_.Exception -like '*401*')
        {
            Write-Host "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered for Intune."
        }
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = $Credential.UserName.Split('@')[1]

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

function Get-M365DSCIntuneDeviceConfigurationPolicyAndroidWorkProfileAdditionalProperties
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Properties
    )

    $results = @{"@odata.type" = "#microsoft.graph.androidWorkProfileGeneralDeviceConfiguration"}
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

