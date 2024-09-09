function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Yes')]
        $IsSingleInstance,

        [Parameter()]
        [System.UInt32]
        $LockoutThreshold,

        [Parameter()]
        [System.UInt32]
        $LockoutDurationInSeconds,

        [Parameter()]
        [System.Boolean]
        $EnableBannedPasswordCheck,

        [Parameter()]
        [System.String[]]
        $BannedPasswordList,

        [Parameter()]
        [System.Boolean]
        $EnableBannedPasswordCheckOnPremises,

        [Parameter()]
        [validateset('Enforced', 'Audit')]
        [System.String]
        $BannedPasswordCheckOnPremisesMode,

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

    Write-Verbose -Message 'Getting configuration of AzureAD Password Rule Settings'
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

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'
    try
    {
        $Policy = Get-MgBetaDirectorySetting -All | Where-Object -FilterScript { $_.DisplayName -eq 'Password Rule Settings' }

        if ($null -eq $Policy)
        {
            return $nullReturn
        }
        else
        {
            Write-Verbose -Message 'Found existing AzureAD DirectorySetting for Password Rule Settings'
            $valueBannedPasswordCheckOnPremisesMode   = $Policy.Values | Where-Object -FilterScript {$_.Name -eq 'BannedPasswordCheckOnPremisesMode'}
            $valueEnableBannedPasswordCheckOnPremises = $Policy.Values | Where-Object -FilterScript {$_.Name -eq 'EnableBannedPasswordCheckOnPremises'}
            $valueEnableBannedPasswordCheck           = $Policy.Values | Where-Object -FilterScript {$_.Name -eq 'EnableBannedPasswordCheck'}
            $valueLockoutDurationInSeconds            = $Policy.Values | Where-Object -FilterScript {$_.Name -eq 'LockoutDurationInSeconds'}
            $valueLockoutThreshold                    = $Policy.Values | Where-Object -FilterScript {$_.Name -eq 'LockoutThreshold'}
            $valueBannedPasswordList                  = $Policy.Values | Where-Object -FilterScript {$_.Name -eq 'BannedPasswordList'}

            $result = @{
                IsSingleInstance                = 'Yes'
                BannedPasswordCheckOnPremisesMode   = $valueBannedPasswordCheckOnPremisesMode.Value
                EnableBannedPasswordCheckOnPremises = [Boolean]::Parse($valueEnableBannedPasswordCheckOnPremises.Value)
                EnableBannedPasswordCheck           = [Boolean]::Parse($valueEnableBannedPasswordCheck.Value)
                LockoutDurationInSeconds            = $valueLockoutDurationInSeconds.Value
                LockoutThreshold                    = $valueLockoutThreshold.Value
                BannedPasswordList                  = $valueBannedPasswordList.Value -split "`t" # list is tab-delimited
                Ensure                          = 'Present'
                ApplicationId                   = $ApplicationId
                TenantId                        = $TenantId
                ApplicationSecret               = $ApplicationSecret
                CertificateThumbprint           = $CertificateThumbprint
                Credential                      = $Credential
                Managedidentity                 = $ManagedIdentity.IsPresent
                AccessTokens                    = $AccessTokens
            }

            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
            return $result
        }
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $nullReturn
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Yes')]
        $IsSingleInstance,

        [Parameter()]
        [System.UInt32]
        $LockoutThreshold,

        [Parameter()]
        [System.UInt32]
        $LockoutDurationInSeconds,

        [Parameter()]
        [System.Boolean]
        $EnableBannedPasswordCheck,

        [Parameter()]
        [System.String[]]
        $BannedPasswordList,

        [Parameter()]
        [System.Boolean]
        $EnableBannedPasswordCheckOnPremises,

        [Parameter()]
        [validateset('Enforced', 'Audit')]
        [System.String]
        $BannedPasswordCheckOnPremisesMode,

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

    Write-Verbose -Message 'Setting configuration of Azure AD Password Rule Settings'

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

    $currentPolicy = Get-TargetResource @PSBoundParameters

    # Policy should exist but it doesn't
    $needToUpdate = $false
    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        #$template = Get-MgBetaDirectorySettingTemplate -All | Where-Object -FilterScript {$_.Displayname -eq 'Password Rule Settings'}
        $Policy = New-MgBetaDirectorySetting -TemplateId '5cf42378-d67d-4f36-ba46-e8b86229381d' | Out-Null
        $needToUpdate = $true
    }

    $Policy = Get-MgBetaDirectorySetting -All | Where-Object -FilterScript { $_.DisplayName -eq 'Password Rule Settings' }

    if (($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present') -or $needToUpdate)
    {
        $index = 0
        foreach ($property in $Policy.Values)
        {
            if ($property.Name -eq 'LockoutThreshold')
            {
                $entry = $Policy.Values | Where-Object -FilterScript {$_.Name -eq $property.Name}
                $entry.Value = $LockoutThreshold
            }
            elseif ($property.Name -eq 'LockoutDurationInSeconds')
            {
                $entry = $Policy.Values | Where-Object -FilterScript {$_.Name -eq $property.Name}
                $entry.Value = $LockoutDurationInSeconds
            }
            elseif ($property.Value -eq 'EnableBannedPasswordCheck')
            {
                $entry = $Policy.Values | Where-Object -FilterScript {$_.Name -eq $property.Name}
                $entry.Value = [System.Boolean]$EnableBannedPasswordCheck
            }
            elseif ($property.Value -eq 'BannedPasswordList')
            {
                $entry = $Policy.Values | Where-Object -FilterScript {$_.Name -eq $property.Name}
                $entry.Value = $BannedPasswordList -join "`t"
            }
            elseif ($property.Value -eq 'EnableBannedPasswordCheckOnPremises')
            {
                $entry = $Policy.Values | Where-Object -FilterScript {$_.Name -eq $property.Name}
                $entry.Value = [System.Boolean]$EnableBannedPasswordCheckOnPremises
            }
            elseif ($property.Value -eq 'BannedPasswordCheckOnPremisesMode')
            {
                $entry = $Policy.Values | Where-Object -FilterScript {$_.Name -eq $property.Name}
                $entry.Value = $BannedPasswordCheckOnPremisesMode
            }
            $index++
        }

        Write-Verbose -Message "Updating Policy's Values with $($Policy.Values | Out-String)"
        Update-MgBetaDirectorySetting -DirectorySettingId $Policy.id -Values $Policy.Values | Out-Null
    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "An existing Directory Setting entry exists, and we don't allow to have it removed."
        throw 'The AADPasswordRuleSettings resource cannot delete existing Directory Setting entries. Please specify Present.'
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
        [ValidateSet('Yes')]
        $IsSingleInstance,

        [Parameter()]
        [System.UInt32]
        $LockoutThreshold,

        [Parameter()]
        [System.UInt32]
        $LockoutDurationInSeconds,

        [Parameter()]
        [System.Boolean]
        $EnableBannedPasswordCheck,

        [Parameter()]
        [System.String[]]
        $BannedPasswordList,

        [Parameter()]
        [System.Boolean]
        $EnableBannedPasswordCheckOnPremises,

        [Parameter()]
        [validateset('Enforced', 'Audit')]
        [System.String]
        $BannedPasswordCheckOnPremisesMode,

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

    Write-Verbose -Message 'Testing configuration of AzureAD Password Rule Settings'

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters

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

        $Params = @{
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            IsSingleInstance      = 'Yes'
            ApplicationSecret     = $ApplicationSecret
            Credential            = $Credential
            Managedidentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
        }
        $dscContent = ''
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
        Write-Host $Global:M365DSCEmojiGreenCheckMark
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
