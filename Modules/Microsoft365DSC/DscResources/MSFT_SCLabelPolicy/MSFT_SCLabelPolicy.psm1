Confirm-M365DSCModuleDependency -ModuleName 'MSFT_SCLabelPolicy'

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
        $Comment,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AdvancedSettings,

        [Parameter()]
        [System.String[]]
        $Labels,

        [Parameter()]
        [System.String[]]
        $ExchangeLocation,

        [Parameter()]
        [System.String[]]
        $ExchangeLocationException,

        [Parameter()]
        [System.String[]]
        $ModernGroupLocation,

        [Parameter()]
        [System.String[]]
        $ModernGroupLocationException,

        [Parameter()]
        [System.String[]]
        $AddLabels,

        [Parameter()]
        [System.String[]]
        $AddExchangeLocation,

        [Parameter()]
        [System.String[]]
        $AddExchangeLocationException,

        [Parameter()]
        [System.String[]]
        $AddModernGroupLocation,

        [Parameter()]
        [System.String[]]
        $AddModernGroupLocationException,

        [Parameter()]
        [System.String[]]
        $RemoveLabels,

        [Parameter()]
        [System.String[]]
        $RemoveExchangeLocation,

        [Parameter()]
        [System.String[]]
        $RemoveExchangeLocationException,

        [Parameter()]
        [System.String[]]
        $RemoveModernGroupLocation,

        [Parameter()]
        [System.String[]]
        $RemoveModernGroupLocationException,

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

    Write-Verbose -Message "Getting configuration of Sensitivity Label Policy for $Name"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Name -ne $Name)
        {
            if ($PSBoundParameters.ContainsKey('Labels') -and `
                ($PSBoundParameters.ContainsKey('AddLabels') -or $PSBoundParameters.ContainsKey('RemoveLabels')))
            {
                throw 'You cannot use the Labels parameter and the AddLabels or RemoveLabels parameters at the same time.'
            }

            if ($PSBoundParameters.ContainsKey('AddLabels') -and $PSBoundParameters.ContainsKey('RemoveLabels'))
            {
                # Check if AddLabels and RemoveLabels contain the same labels
                [array]$diff = Compare-Object -ReferenceObject $AddLabels -DifferenceObject $RemoveLabels -ExcludeDifferent -IncludeEqual
                if ($diff.Count -gt 0)
                {
                    throw 'Parameters AddLabels and RemoveLabels cannot contain the same labels. Make sure labels are not present in both parameters.'
                }
            }

            $null = New-M365DSCConnection -Workload 'SecurityComplianceCenter' `
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

            $nullReturn = $PSBoundParameters
            $nullReturn.Ensure = 'Absent'

            try
            {
                $policy = Invoke-M365DSCCommand -ScriptBlock { Get-LabelPolicy -Identity $Name -ErrorAction Stop } -SuppressNotFoundError
            }
            catch
            {
                throw $_
            }

            if ($null -eq $policy)
            {
                Write-Verbose -Message "Sensitivity label policy $($Name) does not exist."
                return $nullReturn
            }
        }
        else
        {
            $policy = $Script:exportedInstance
        }

        if ($null -ne $policy.Settings)
        {
            Write-Verbose -Message 'Converting Settings'
            $advancedSettingsValue = Convert-StringToAdvancedSettings -AdvancedSettings $policy.Settings
        }

        Write-Verbose "Found existing Sensitivity Label policy $($Name)"
        $result = @{
            Name                         = $policy.Name
            Comment                      = $policy.Comment
            AdvancedSettings             = $advancedSettingsValue
            Credential                   = $Credential
            ApplicationId                = $ApplicationId
            TenantId                     = $TenantId
            CertificateThumbprint        = $CertificateThumbprint
            CertificatePath              = $CertificatePath
            CertificatePassword          = $CertificatePassword
            Ensure                       = 'Present'
            Labels                       = $policy.Labels
            ExchangeLocation             = Get-M365DSCArrayFromProperty -PropertyValue $policy.ExchangeLocation.Name -ElementType ([System.String])
            ExchangeLocationException    = Get-M365DSCArrayFromProperty -PropertyValue $policy.ExchangeLocationException.Name -ElementType ([System.String])
            ModernGroupLocation          = Get-M365DSCArrayFromProperty -PropertyValue $policy.ModernGroupLocation.Name -ElementType ([System.String])
            ModernGroupLocationException = Get-M365DSCArrayFromProperty -PropertyValue $policy.ModernGroupLocationException.Name -ElementType ([System.String])
            AccessTokens                 = $AccessTokens
        }

        return $result
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
        $Comment,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AdvancedSettings,

        [Parameter()]
        [System.String[]]
        $Labels,

        [Parameter()]
        [System.String[]]
        $ExchangeLocation,

        [Parameter()]
        [System.String[]]
        $ExchangeLocationException,

        [Parameter()]
        [System.String[]]
        $ModernGroupLocation,

        [Parameter()]
        [System.String[]]
        $ModernGroupLocationException,

        [Parameter()]
        [System.String[]]
        $AddLabels,

        [Parameter()]
        [System.String[]]
        $AddExchangeLocation,

        [Parameter()]
        [System.String[]]
        $AddExchangeLocationException,

        [Parameter()]
        [System.String[]]
        $AddModernGroupLocation,

        [Parameter()]
        [System.String[]]
        $AddModernGroupLocationException,

        [Parameter()]
        [System.String[]]
        $RemoveLabels,

        [Parameter()]
        [System.String[]]
        $RemoveExchangeLocation,

        [Parameter()]
        [System.String[]]
        $RemoveExchangeLocationException,

        [Parameter()]
        [System.String[]]
        $RemoveModernGroupLocation,

        [Parameter()]
        [System.String[]]
        $RemoveModernGroupLocationException,

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

    Write-Verbose -Message "Setting configuration of Sensitivity label policy for $Name"

    if ($PSBoundParameters.ContainsKey('Labels') -and `
        ($PSBoundParameters.ContainsKey('AddLabels') -or $PSBoundParameters.ContainsKey('RemoveLabels')))
    {
        throw 'You cannot use the Labels parameter and the AddLabels or RemoveLabels parameters at the same time.'
    }

    if ($PSBoundParameters.ContainsKey('AddLabels') -and $PSBoundParameters.ContainsKey('RemoveLabels'))
    {
        # Check if AddLabels and RemoveLabels contain the same labels
        [array]$diff = Compare-Object -ReferenceObject $AddLabels -DifferenceObject $RemoveLabels -ExcludeDifferent -IncludeEqual
        if ($diff.Count -gt 0)
        {
            throw 'Parameters AddLabels and RemoveLabels cannot contain the same labels. Make sure labels are not present in both parameters.'
        }
    }

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

    $CurrentPolicy = Get-TargetResource @PSBoundParameters
    $boundParams = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    foreach ($locationProperty in @('ModernGroupLocation', 'ModernGroupLocationException', 'ExchangeLocation', 'ExchangeLocationException'))
    {
        if (-not $PSBoundParameters.ContainsKey($locationProperty))
        {
            continue
        }

        $desiredLocations = $PSBoundParameters[$locationProperty]
        $currentLocations = $CurrentPolicy.$locationProperty

        [array]$diffs = Compare-Object `
            -ReferenceObject @($currentLocations | Where-Object { $null -ne $_ }) `
            -DifferenceObject @($desiredLocations | Where-Object { $null -ne $_ })
        if ($diffs.Count -gt 0)
        {
            $add = @()
            $remove = @()
            foreach ($diff in $diffs)
            {
                if ($diff.SideIndicator -eq '<=')
                {
                    Write-Verbose "Removing $locationProperty $($diff.InputObject) from policy $Name."
                    $remove += $diff.InputObject
                }
                elseif ($diff.SideIndicator -eq '=>')
                {
                    Write-Verbose "Adding $locationProperty $($diff.InputObject) to policy $Name."
                    $add += $diff.InputObject
                }
            }

            if ($add.Count -gt 0)
            {
                $boundParams["Add$locationProperty"] = $add
            }

            if ($remove.Count -gt 0)
            {
                $boundParams["Remove$locationProperty"] = $remove
            }
        }
        $boundParams.Remove($locationProperty) | Out-Null
    }

    if ($Ensure -eq 'Present' -and $CurrentPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose "Creating new Sensitivity label policy '$Name'."
        $CreationParams = $boundParams

        if ($PSBoundParameters.ContainsKey('AdvancedSettings'))
        {
            $advanced = Convert-CIMToAdvancedSettings -AdvancedSettings $AdvancedSettings
            $CreationParams['AdvancedSettings'] = $advanced
        }

        if ($PSBoundParameters.ContainsKey('AddLabels'))
        {
            $CreationParams['Labels'] = $AddLabels
        }
        $CreationParams.Remove('AddLabels') | Out-Null
        $CreationParams.Remove('RemoveLabels') | Out-Null

        # Remove parameters not used in New-LabelPolicy
        $CreationParams.Remove('AddExchangeLocation') | Out-Null
        $CreationParams.Remove('AddExchangeLocationException') | Out-Null
        $CreationParams.Remove('AddModernGroupLocation') | Out-Null
        $CreationParams.Remove('AddModernGroupLocationException') | Out-Null
        $CreationParams.Remove('RemoveExchangeLocation') | Out-Null
        $CreationParams.Remove('RemoveExchangeLocationException') | Out-Null
        $CreationParams.Remove('RemoveModernGroupLocation') | Out-Null
        $CreationParams.Remove('RemoveModernGroupLocationException') | Out-Null

        try
        {
            New-LabelPolicy @CreationParams
        }
        catch
        {
            Write-Warning "New-LabelPolicy is not available in tenant $($Credential.UserName.Split('@')[1]): $_"
        }
        try
        {
            Start-Sleep 5
            Write-Verbose "Updating Sensitivity label policy '$Name' settings."
            $SetParams = $boundParams

            if ($PSBoundParameters.ContainsKey('AdvancedSettings'))
            {
                $advanced = Convert-CIMToAdvancedSettings -AdvancedSettings $AdvancedSettings
                $SetParams['AdvancedSettings'] = $advanced
            }

            #Remove unused parameters for Set-Label cmdlet
            $SetParams.Remove('Name') | Out-Null
            $SetParams.Remove('ExchangeLocationException') | Out-Null
            $SetParams.Remove('ExchangeLocation') | Out-Null
            $SetParams.Remove('ModernGroupLocation') | Out-Null
            $SetParams.Remove('ModernGroupLocationException') | Out-Null

            # Labels are already set during creation, removing parameters
            $SetParams.Remove('Labels') | Out-Null
            $SetParams.Remove('AddLabels') | Out-Null
            $SetParams.Remove('RemoveLabels') | Out-Null

            Set-LabelPolicy @SetParams -Identity $Name
        }
        catch
        {
            Write-Warning "Set-LabelPolicy is not available in tenant $($Credential.UserName.Split('@')[1]): $_"
        }
    }
    elseif ($Ensure -eq 'Present' -and $CurrentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose "Updating existing Sensitivity label policy '$Name'."
        $SetParams = $boundParams

        if ($PSBoundParameters.ContainsKey('AdvancedSettings'))
        {
            $advanced = Convert-CIMToAdvancedSettings -AdvancedSettings $AdvancedSettings
            $SetParams['AdvancedSettings'] = $advanced
        }

        if ($PSBoundParameters.ContainsKey('Labels'))
        {
            [array]$diffs = Compare-Object -ReferenceObject $CurrentPolicy.Labels -DifferenceObject $Labels
            if ($diffs.Count -gt 0)
            {
                $add = @()
                $remove = @()
                foreach ($diff in $diffs)
                {
                    if ($diff.SideIndicator -eq '<=')
                    {
                        Write-Verbose "Removing label $($diff.InputObject) from policy $Name."
                        $remove += $diff.InputObject
                    }
                    elseif ($diff.SideIndicator -eq '=>')
                    {
                        Write-Verbose "Adding label $($diff.InputObject) to policy $Name."
                        $add += $diff.InputObject
                    }
                }

                if ($add.Count -gt 0)
                {
                    $SetParams['AddLabels'] = $add
                }

                if ($remove.Count -gt 0)
                {
                    $SetParams['RemoveLabels'] = $remove
                }
            }
            $SetParams.Remove('Labels') | Out-Null
        }

        #Remove unused parameters for Set-Label cmdlet
        $SetParams.Remove('Name') | Out-Null
        $SetParams.Remove('ExchangeLocationException') | Out-Null
        $SetParams.Remove('ExchangeLocation') | Out-Null
        $SetParams.Remove('ModernGroupLocation') | Out-Null
        $SetParams.Remove('ModernGroupLocationException') | Out-Null

        try
        {
            Set-LabelPolicy @SetParams -Identity $Name
        }
        catch
        {
            Write-Warning "Set-LabelPolicy is not available in tenant $($Credential.UserName.Split('@')[1]): $_"
        }
    }
    elseif ($Ensure -eq 'Absent' -and $CurrentPolicy.Ensure -eq 'Present')
    {
        # If the label exists and it shouldn't, simply remove it;Need to force deletoion
        Write-Verbose -Message "Deleting Sensitivity label policy $Name."

        try
        {
            Remove-LabelPolicy -Identity $Name -Confirm:$false
        }
        catch
        {
            Write-Warning "Remove-LabelPolicy is not available in tenant $($Credential.UserName.Split('@')[1]): $_"
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
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AdvancedSettings,

        [Parameter()]
        [System.String[]]
        $Labels,

        [Parameter()]
        [System.String[]]
        $ExchangeLocation,

        [Parameter()]
        [System.String[]]
        $ExchangeLocationException,

        [Parameter()]
        [System.String[]]
        $ModernGroupLocation,

        [Parameter()]
        [System.String[]]
        $ModernGroupLocationException,

        [Parameter()]
        [System.String[]]
        $AddLabels,

        [Parameter()]
        [System.String[]]
        $AddExchangeLocation,

        [Parameter()]
        [System.String[]]
        $AddExchangeLocationException,

        [Parameter()]
        [System.String[]]
        $AddModernGroupLocation,

        [Parameter()]
        [System.String[]]
        $AddModernGroupLocationException,

        [Parameter()]
        [System.String[]]
        $RemoveLabels,

        [Parameter()]
        [System.String[]]
        $RemoveExchangeLocation,

        [Parameter()]
        [System.String[]]
        $RemoveExchangeLocationException,

        [Parameter()]
        [System.String[]]
        $RemoveModernGroupLocation,

        [Parameter()]
        [System.String[]]
        $RemoveModernGroupLocationException,

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

    Write-Verbose -Message "Testing configuration of Sensitivity label for $Name"
    $CurrentValues = Get-TargetResource @PSBoundParameters

    $ValuesToCheck = ([Hashtable]$PSBoundParameters).Clone()
    $ValuesToCheck.Remove('AddLabels') | Out-Null
    $ValuesToCheck.Remove('AddExchangeLocation') | Out-Null
    $ValuesToCheck.Remove('AddExchangeLocationException') | Out-Null
    $ValuesToCheck.Remove('AddModernGroupLocation') | Out-Null
    $ValuesToCheck.Remove('AddModernGroupLocationException') | Out-Null
    $ValuesToCheck.Remove('RemoveLabels') | Out-Null
    $ValuesToCheck.Remove('RemoveExchangeLocation') | Out-Null
    $ValuesToCheck.Remove('RemoveExchangeLocationException') | Out-Null
    $ValuesToCheck.Remove('RemoveModernGroupLocation') | Out-Null
    $ValuesToCheck.Remove('RemoveModernGroupLocationException') | Out-Null

    if ($null -ne $AdvancedSettings)
    {
        $TestAdvancedSettings = Test-AdvancedSettings -DesiredProperty $AdvancedSettings -CurrentProperty $CurrentValues.AdvancedSettings
        if ($false -eq $TestAdvancedSettings)
        {
            return $false
        }
        $ValuesToCheck.Remove('AdvancedSettings') | Out-Null
    }

    $locationDriftProperties = @{
        ModernGroupLocation          = @{ Add = $AddModernGroupLocation;          Remove = $RemoveModernGroupLocation;          Desired = $ModernGroupLocation }
        ModernGroupLocationException = @{ Add = $AddModernGroupLocationException; Remove = $RemoveModernGroupLocationException; Desired = $ModernGroupLocationException }
        ExchangeLocation             = @{ Add = $AddExchangeLocation;             Remove = $RemoveExchangeLocation;             Desired = $ExchangeLocation }
        ExchangeLocationException    = @{ Add = $AddExchangeLocationException;    Remove = $RemoveExchangeLocationException;    Desired = $ExchangeLocationException }
    }

    foreach ($locationProperty in $locationDriftProperties.Keys)
    {
        $entry = $locationDriftProperties[$locationProperty]
        if ($null -eq $entry.Desired -and $null -eq $entry.Add -and $null -eq $entry.Remove)
        {
            continue
        }

        $configData = New-PolicyData -configData $entry.Desired `
            -currentData $CurrentValues.$locationProperty `
            -removedData $entry.Remove `
            -additionalData $entry.Add

        if ($null -eq $configData -and $null -ne $CurrentValues.$locationProperty -and $null -ne $entry.Remove)
        {
            return $false
        }

        $current = @($CurrentValues.$locationProperty | Where-Object { $null -ne $_ -and '' -ne $_ })
        $expected = @($configData | Where-Object { $null -ne $_ -and '' -ne $_ })

        if ($current.Count -ne $expected.Count -or `
            ($expected.Count -gt 0 -and `
                (Compare-Object -ReferenceObject $current -DifferenceObject $expected).Count -gt 0))
        {
            Write-Verbose -Message "$locationProperty drift detected on policy $Name. Current: $($current -join ', '); Expected: $($expected -join ', ')"
            return $false
        }

        $ValuesToCheck.Remove("Remove$locationProperty") | Out-Null
        $ValuesToCheck.Remove("Add$locationProperty") | Out-Null
        $ValuesToCheck.Remove($locationProperty) | Out-Null
    }

    if ($null -ne $RemoveLabels -or $null -ne $AddLabels -or $null -ne $Labels)
    {
        $configData = New-PolicyData -configData $Labels -currentData $CurrentValues.Labels `
            -removedData $RemoveLabels -additionalData $AddLabels

        if ($null -ne $configData)
        {
            $ValuesToCheck['Labels'] = $configData
        }

        if ($null -eq $configData -and $null -ne $CurrentValues.Labels `
                -and $null -ne $RemoveLabels)
        {
            return $false
        }
        $ValuesToCheck.Remove('RemoveLabels') | Out-Null
        $ValuesToCheck.Remove('AddLabels') | Out-Null
        $ValuesToCheck.Remove('Labels') | Out-Null
    }

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

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

    $ConnectionMode = New-M365DSCConnection -Workload 'SecurityComplianceCenter' `
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
        [array]$policies = Get-LabelPolicy -ErrorAction Stop -WarningAction Ignore

        $dscContent = [System.Text.StringBuilder]::new()
        $i = 1
        if ($policies.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($policy in $policies)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($policies.Count)] $($policy.Name)" -DeferWrite

            $Script:exportedInstance = $policy
            $Results = Get-TargetResource @PSBoundParameters -Name $policy.Name

            if ($null -ne $Results.AdvancedSettings)
            {
                $complexMapping = @(
                    @{
                        Name            = 'AdvancedSettings'
                        CimInstanceName = 'MSFT_SCLabelSetting'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.AdvancedSettings `
                    -CIMInstanceName 'MSFT_SCLabelSetting' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.AdvancedSettings = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('AdvancedSettings') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('AdvancedSettings')

            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            [void]$dscContent.Append($currentDSCBlock)
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
        }
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
    return $dscContent.ToString()
}

function Convert-StringToAdvancedSettings
{
    [CmdletBinding()]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String[]]
        $AdvancedSettings
    )

    $settings = @()
    $labelLookup = $null
    foreach ($setting in $AdvancedSettings)
    {
        Write-Verbose -Message "SETTING: $setting"
        $settingString = $setting.Replace('[', '').Replace(']', '')
        $settingKey = $settingString.Split(',')[0]

        if ($settingKey -ne 'displayname')
        {
            $startPos = $settingString.IndexOf(',', 0) + 1
            $valueString = $settingString.Substring($startPos, $settingString.Length - $startPos).Trim()
            if ($valueString -like '*,*')
            {
                $values = $valueString -split ','
            }
            else
            {
                $values = $valueString
            }

            if ($settingKey -like '*defaultlabel*')
            {
                if ($values -ne 'None')
                {
                    if ($null -eq $labelLookup)
                    {
                        $labelLookup = @{}
                        foreach ($lbl in (Get-Label -ErrorAction SilentlyContinue))
                        {
                            if ($null -ne $lbl.ImmutableId)
                            {
                                $labelLookup[$lbl.ImmutableId.ToString()] = $lbl.DisplayName
                            }
                        }
                    }

                    $resolved = $labelLookup[$values.ToString()]
                    if (-not [System.String]::IsNullOrEmpty($resolved))
                    {
                        $values = $resolved
                    }
                }
            }

            $entry = [ordered]@{
                Key   = $settingKey
                Value = $values
            }
            $settings += $entry
        }
    }

    return $settings
}

function Convert-CIMToAdvancedSettings
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AdvancedSettings
    )

    $entry = [PSCustomObject]@{}
    foreach ($obj in $AdvancedSettings)
    {
        $settingsValues = ''
        if ($obj.Key -like '*defaultlabel*')
        {
            if ($obj.Value -ne 'None')
            {
                $label = Get-Label | Where-Object -FilterScript { $_.DisplayName -eq $obj.Value }
                if ($null -eq $label)
                {
                    Write-Error -Message "Label {$($obj.value)} doesn't exist. Please define the Sensitivy label first before trying to assign it to a policy."
                }
                else
                {
                    $settingsValues = $label.ImmutableId.ToString()
                }
            }
            else
            {
                $settingsValues = 'None'
            }
        }
        else
        {
            foreach ($objVal in $obj.Value)
            {
                $settingsValues += $objVal
                $settingsValues += ','
            }
        }
        $entry | Add-Member -MemberType NoteProperty -Name $obj.Key -Value $settingsValues.TrimEnd(',') -Force
    }

    return $entry
}

function Test-AdvancedSettings
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter (Mandatory = $true)]
        $DesiredProperty,

        [Parameter (Mandatory = $true)]
        $CurrentProperty
    )

    $foundSettings = $true
    foreach ($desiredSetting in $DesiredProperty)
    {
        $foundKey = $CurrentProperty | Where-Object { $_.Key -eq $desiredSetting.Key }
        if ($null -ne $foundKey)
        {
            $checkValue = $desiredSetting.Value
            if ($checkValue.GetType().BaseType -eq 'array' -or $checkValue.GetType().Name -contains 'string[]')
            {
                $checkValue = $desiredSetting.Value[0]
            }
            if ($foundKey.Value.ToString() -ne $checkValue.ToString())
            {
                $foundSettings = $false
                break
            }
        }
    }

    Write-Verbose -Message "Test AdvancedSettings returned {$foundSettings}"
    return $foundSettings
}

function New-PolicyData
{
    [CmdletBinding()]
    [OutputType([System.Collections.ArrayList])]
    param
    (
        [Parameter()]
        $configData,

        [Parameter()]
        $currentData,

        [Parameter()]
        $removedData,

        [Parameter()]
        $additionalData
    )

    $desiredData = [System.Collections.ArrayList]::new()
    foreach ($currItem in $currentData)
    {
        if (!$desiredData.Contains($currItem))
        {
            $desiredData.Add($currItem) | Out-Null
        }
    }

    foreach ($currItem in $configData)
    {
        if (!$desiredData.Contains("$curritem"))
        {
            $desiredData.Add($currItem) | Out-Null
        }
    }

    foreach ($currItem in $removedData)
    {
        $desiredData.Remove($currItem) | Out-Null
    }

    foreach ($currItem in $additionalData)
    {
        if (!$desiredData.Contains("$curritem"))
        {
            $desiredData.Add($currItem) | Out-Null
        }
    }

    return $desiredData
}

Export-ModuleMember -Function *-TargetResource
