function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $EnhancedBiometricsState,

        [Parameter()]
        [System.Int32]
        $EnhancedSignInSecurity,

        [Parameter()]
        [System.Int32]
        $PinExpirationInDays,

        [Parameter()]
        [ValidateSet('allowed','required','disallowed')]
        [System.String]
        $PinLowercaseCharactersUsage,

        [Parameter()]
        [System.Int32]
        $PinMaximumLength,

        [Parameter()]
        [System.Int32]
        $PinMinimumLength,

        [Parameter()]
        [System.Int32]
        $PinPreviousBlockCount,

        [Parameter()]
        [ValidateSet('allowed','required','disallowed')]
        [System.String]
        $PinSpecialCharactersUsage,

        [Parameter()]
        [ValidateSet('allowed','required','disallowed')]
        [System.String]
        $PinUppercaseCharactersUsage,

        [Parameter()]
        [System.Boolean]
        $RemotePassportEnabled,

        [Parameter()]
        [System.Boolean]
        $SecurityDeviceRequired,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $SecurityKeyForSignIn,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $State,

        [Parameter()]
        [System.Boolean]
        $UnlockWithBiometricsEnabled,
        #endregion

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

    Write-Verbose -Message "Getting configuration for the Intune Windows Hello For Business Global Policy"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.DisplayName -ne $DisplayName)
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

            #region resource generator code
            $getValue = Get-MgBetaDeviceManagementDeviceEnrollmentConfiguration `
                -ErrorAction SilentlyContinue | Where-Object `
                -FilterScript {
                    $_.AdditionalProperties.'@odata.type' -eq "#microsoft.graph.deviceEnrollmentWindowsHelloForBusinessConfiguration"
                }
            #endregion
        }
        else
        {
            $getValue = $Script:exportedInstance
        }

        Write-Verbose -Message "An Intune Windows Hello For Business Global Policy was found"

        #region resource generator code
        $enumEnhancedBiometricsState = $null
        if ($null -ne $getValue.AdditionalProperties.enhancedBiometricsState)
        {
            $enumEnhancedBiometricsState = $getValue.AdditionalProperties.enhancedBiometricsState.ToString()
        }

        $enumPinLowercaseCharactersUsage = $null
        if ($null -ne $getValue.AdditionalProperties.pinLowercaseCharactersUsage)
        {
            $enumPinLowercaseCharactersUsage = $getValue.AdditionalProperties.pinLowercaseCharactersUsage.ToString()
        }

        $enumPinSpecialCharactersUsage = $null
        if ($null -ne $getValue.AdditionalProperties.pinSpecialCharactersUsage)
        {
            $enumPinSpecialCharactersUsage = $getValue.AdditionalProperties.pinSpecialCharactersUsage.ToString()
        }

        $enumPinUppercaseCharactersUsage = $null
        if ($null -ne $getValue.AdditionalProperties.pinUppercaseCharactersUsage)
        {
            $enumPinUppercaseCharactersUsage = $getValue.AdditionalProperties.pinUppercaseCharactersUsage.ToString()
        }

        $enumSecurityKeyForSignIn = $null
        if ($null -ne $getValue.AdditionalProperties.securityKeyForSignIn)
        {
            $enumSecurityKeyForSignIn = $getValue.AdditionalProperties.securityKeyForSignIn.ToString()
        }

        $enumState = $null
        if ($null -ne $getValue.AdditionalProperties.state)
        {
            $enumState = $getValue.AdditionalProperties.state.ToString()
        }
        #endregion

        $results = @{
            #region resource generator code
            IsSingleInstance                  = 'Yes'
            EnhancedBiometricsState           = $enumEnhancedBiometricsState
            EnhancedSignInSecurity            = $getValue.AdditionalProperties.enhancedSignInSecurity
            PinExpirationInDays               = $getValue.AdditionalProperties.pinExpirationInDays
            PinLowercaseCharactersUsage       = $enumPinLowercaseCharactersUsage
            PinMaximumLength                  = $getValue.AdditionalProperties.pinMaximumLength
            PinMinimumLength                  = $getValue.AdditionalProperties.pinMinimumLength
            PinPreviousBlockCount             = $getValue.AdditionalProperties.pinPreviousBlockCount
            PinSpecialCharactersUsage         = $enumPinSpecialCharactersUsage
            PinUppercaseCharactersUsage       = $enumPinUppercaseCharactersUsage
            RemotePassportEnabled             = $getValue.AdditionalProperties.remotePassportEnabled
            SecurityDeviceRequired            = $getValue.AdditionalProperties.securityDeviceRequired
            SecurityKeyForSignIn              = $enumSecurityKeyForSignIn
            State                             = $enumState
            UnlockWithBiometricsEnabled       = $getValue.AdditionalProperties.unlockWithBiometricsEnabled
            Credential                        = $Credential
            ApplicationId                     = $ApplicationId
            TenantId                          = $TenantId
            ApplicationSecret                 = $ApplicationSecret
            CertificateThumbprint             = $CertificateThumbprint
            ManagedIdentity                   = $ManagedIdentity.IsPresent
            #endregion
        }

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
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $EnhancedBiometricsState,

        [Parameter()]
        [System.Int32]
        $EnhancedSignInSecurity,

        [Parameter()]
        [System.Int32]
        $PinExpirationInDays,

        [Parameter()]
        [ValidateSet('allowed','required','disallowed')]
        [System.String]
        $PinLowercaseCharactersUsage,

        [Parameter()]
        [System.Int32]
        $PinMaximumLength,

        [Parameter()]
        [System.Int32]
        $PinMinimumLength,

        [Parameter()]
        [System.Int32]
        $PinPreviousBlockCount,

        [Parameter()]
        [ValidateSet('allowed','required','disallowed')]
        [System.String]
        $PinSpecialCharactersUsage,

        [Parameter()]
        [ValidateSet('allowed','required','disallowed')]
        [System.String]
        $PinUppercaseCharactersUsage,

        [Parameter()]
        [System.Boolean]
        $RemotePassportEnabled,

        [Parameter()]
        [System.Boolean]
        $SecurityDeviceRequired,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $SecurityKeyForSignIn,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $State,

        [Parameter()]
        [System.Boolean]
        $UnlockWithBiometricsEnabled,
        #endregion

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

    Write-Verbose -Message "Setting configuration of the Intune Windows Hello For Business Global Policy"

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

    Write-Verbose -Message "Updating the Intune Windows Hello For Business Global Policy"

    $updateParameters = ([Hashtable]$BoundParameters).Clone()
    $updateParameters = Rename-M365DSCCimInstanceParameter -Properties $updateParameters

    $keys = (([Hashtable]$updateParameters).Clone()).Keys
    foreach ($key in $keys)
    {
        if ($null -ne $pdateParameters.$key -and $updateParameters.$key.GetType().Name -like '*CimInstance*')
        {
            $updateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $updateParameters.DeviceEnrollmentConfigurationId
        }
    }

    #region resource generator code
    $UpdateParameters.Add("@odata.type", "#microsoft.graph.deviceEnrollmentWindowsHelloForBusinessConfiguration")
    $policy = Get-MgBetaDeviceManagementDeviceEnrollmentConfiguration | Where-Object -FilterScript {
            $_.AdditionalProperties.'@odata.type' -eq "#microsoft.graph.deviceEnrollmentWindowsHelloForBusinessConfiguration"
        }
    Update-MgBetaDeviceManagementDeviceEnrollmentConfiguration `
        -DeviceEnrollmentConfigurationId $policy.Id `
        -BodyParameter $UpdateParameters
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        #region resource generator code
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $EnhancedBiometricsState,

        [Parameter()]
        [System.Int32]
        $EnhancedSignInSecurity,

        [Parameter()]
        [System.Int32]
        $PinExpirationInDays,

        [Parameter()]
        [ValidateSet('allowed','required','disallowed')]
        [System.String]
        $PinLowercaseCharactersUsage,

        [Parameter()]
        [System.Int32]
        $PinMaximumLength,

        [Parameter()]
        [System.Int32]
        $PinMinimumLength,

        [Parameter()]
        [System.Int32]
        $PinPreviousBlockCount,

        [Parameter()]
        [ValidateSet('allowed','required','disallowed')]
        [System.String]
        $PinSpecialCharactersUsage,

        [Parameter()]
        [ValidateSet('allowed','required','disallowed')]
        [System.String]
        $PinUppercaseCharactersUsage,

        [Parameter()]
        [System.Boolean]
        $RemotePassportEnabled,

        [Parameter()]
        [System.Boolean]
        $SecurityDeviceRequired,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $SecurityKeyForSignIn,

        [Parameter()]
        [ValidateSet('notConfigured','enabled','disabled')]
        [System.String]
        $State,

        [Parameter()]
        [System.Boolean]
        $UnlockWithBiometricsEnabled,
        #endregion

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

    Write-Verbose -Message "Testing configuration of the Intune Windows Hello For Business Global Policy"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).Clone()
    $testResult = $true

    #Compare Cim instances
    foreach ($key in $PSBoundParameters.Keys)
    {
        $source = $PSBoundParameters.$key
        $target = $CurrentValues.$key
        if ($null -ne $source -and $source.GetType().Name -like '*CimInstance*')
        {
            $testResult = Compare-M365DSCComplexObject `
                -Source ($source) `
                -Target ($target)

            if (-not $testResult)
            {
                break
            }

            $ValuesToCheck.Remove($key) | Out-Null
        }
    }

    $ValuesToCheck = Remove-M365DSCAuthenticationParameter -BoundParameters $ValuesToCheck

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
        [array]$getValue = Get-MgBetaDeviceManagementDeviceEnrollmentConfiguration `
            -ErrorAction Stop | Where-Object `
            -FilterScript {
                $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.deviceEnrollmentWindowsHelloForBusinessConfiguration'
            }
        #endregion

        $i = 1
        $dscContent = ''
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
            $displayedKey = $config.Id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            elseif (-not [string]::IsNullOrEmpty($config.name))
            {
                $displayedKey = $config.name
            }
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                IsSingleInstance = 'Yes'
                Credential = $Credential
                ApplicationId = $ApplicationId
                TenantId = $TenantId
                ApplicationSecret = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity = $ManagedIdentity.IsPresent
                AccessTokens = $AccessTokens
            }

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        return $dscContent
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

Export-ModuleMember -Function *-TargetResource
