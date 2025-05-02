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
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $IsEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $Restrictions,

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
        $AccessTokens
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
            $instance = $Script:exportedInstances | Where-Object -FilterScript {$_.Id -eq $Id}
        }
        else
        {
            if (-not [System.String]::IsNullOrEmpty($Id))
            {
                $instance = Get-MgBetaPolicyAppManagementPolicy -AppManagementPolicyId $Id `
                                                                -ErrorAction SilentlyContinue
            }
            else
            {
                $instance = Get-MgBetaPolicyAppManagementPolicy | Where-Object -FilterScript {$_.DisplayName -eq $DisplayName}
            }

        }
        if ($null -eq $instance)
        {
            return $nullResult
        }

        $restrictionsValue = @{
            passwordCredentials     = @()
            keyCredentials          = @()
        }

        foreach ($passwordCred in $instance.Restrictions.PasswordCredentials)
        {
            $newItem = @{
                restrictForAppsCreatedAfterDateTime = $passwordCred.RestrictForAppsCreatedAfterDateTime.ToString()
                restrictionType                     = $passwordCred.RestrictionType
                state                               = $passwordCred.State
            }
            if ($null -ne $passwordCred.MaxLifetime)
            {
                $iso8601Duration = "P{0}DT{1}H{2}M{3}S" -f $passwordCred.MaxLifetime.Days, $passwordCred.MaxLifetime.Hours, $passwordCred.MaxLifetime.Minutes, $passwordCred.MaxLifetime.Seconds
                $newItem.Add('maxLifetime', $iso8601Duration)
            }
            $restrictionsValue.passwordCredentials += $newItem
        }

        foreach ($keyCred in $instance.Restrictions.KeyCredentials)
        {
            $newItem = @{
                restrictForAppsCreatedAfterDateTime = $keyCred.RestrictForAppsCreatedAfterDateTime.ToString()
                restrictionType                     = $keyCred.RestrictionType
                state                               = $keyCred.State
            }
            if ($null -ne $keyCred.MaxLifetime)
            {
                $iso8601Duration = "P{0}DT{1}H{2}M{3}S" -f $keyCred.MaxLifetime.Days, $keyCred.MaxLifetime.Hours, $keyCred.MaxLifetime.Minutes, $keyCred.MaxLifetime.Seconds
                $newItem.Add('maxLifetime', $iso8601Duration)
            }
            $restrictionsValue.keyCredentials += $newItem
        }

        $results = @{
            DisplayName           = $instance.DisplayName
            Id                    = $instance.Id
            Description           = $instance.Description
            IsEnabled             = $instance.IsEnabled
            Restrictions          = $restrictionsValue
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
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
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $IsEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $Restrictions,

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

    $currentInstance = Get-TargetResource @PSBoundParameters

    $setParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    $restrictionsValue = @{
        passwordCredentials = @()
        keyCredentials      = @()
    }

    foreach ($passwordCred in $currentInstance.Restrictions.PasswordCredentials)
        {
            $newItem = @{
                restrictForAppsCreatedAfterDateTime = [System.DateTime]::Parse($passwordCred.RestrictForAppsCreatedAfterDateTime)
                restrictionType                     = $passwordCred.RestrictionType
                state                               = $passwordCred.State
            }
            if ($null -ne $passwordCred.MaxLifetime)
            {
                $newItem.Add('maxLifetime', $passwordCred.MaxLifetime.ToString())
            }
            $restrictionsValue.passwordCredentials += $newItem
        }

        foreach ($keyCred in $currentInstance.Restrictions.KeyCredentials)
        {
            $newItem = @{
                restrictForAppsCreatedAfterDateTime = [System.DateTime]::Parse($keyCred.RestrictForAppsCreatedAfterDateTime)
                restrictionType                     = $keyCred.RestrictionType
                state                               = $keyCred.State
            }
            if ($null -ne $keyCred.MaxLifetime)
            {
                $newItem.Add('maxLifetime', $keyCred.MaxLifetime.ToString())
            }
            $restrictionsValue.keyCredentials += $newItem
        }

    $setParameters.Restrictions = $restrictionsValue

    # CREATE
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new App Management Policy {$DisplayName} with:`r`n$(ConvertTo-Json $setParameters -Depth 10)"
        New-MgBetaPolicyAppManagementPolicy @SetParameters
    }
    # UPDATE
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating App Management Policy {$DisplayName} with:`r`n$(ConvertTo-Json $setParameters -Depth 10)"
        Update-MgBetaPolicyAppManagementPolicy @SetParameters -AppManagementPolicyId $currentInstance.Id
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing App Management Policy {$DisplayName}"
        Remove-MgBetaPolicyAppManagementPolicy -AppManagementPolicyId $currentInstance.Id
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
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $IsEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $Restrictions,

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

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).Clone()
    $testTargetResource = $true

    #Compare Cim instances
    foreach ($key in $PSBoundParameters.Keys)
    {
        $source = $PSBoundParameters.$key
        $target = $CurrentValues.$key
        if ($null -ne $source -and $source.GetType().Name -like '*CimInstance*')
        {
            if (-not ($source.GetType().Name -eq 'CimInstance[]' -and $source.Count -eq 0))
            {
                $testResult = Compare-M365DSCComplexObject `
                    -Source ($source) `
                    -Target ($target)

                if (-not $testResult)
                {
                    Write-Verbose "TestResult returned False for $source"
                    $testTargetResource = $false
                }
                else
                {
                    $ValuesToCheck.Remove($key) | Out-Null
                }
            }
            else
            {
                $ValuesToCheck.Remove($key) | Out-Null
            }
        }
    }
    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $testResult"
    if (-not $TestResult)
    {
        $testTargetResource = $false
    }

    return $testTargetResource
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
        [array] $Script:exportedInstances = Get-MgBetaPolicyAppManagementPolicy -ErrorAction Stop

        $i = 1
        $dscContent = ''
        if ($Script:exportedInstances.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($config in $Script:exportedInstances)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.DisplayName
            Write-M365DSCHost -Message "    |---[$i/$($Script:exportedInstances.Count)] $displayedKey" -DeferWrite
            $params = @{
                DisplayName           = $config.DisplayName
                Id                    = $config.Id
                Description           = $config.Description
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Results = Get-TargetResource @Params
            if ($null -ne $Results.Restrictions)
            {
                $complexMapping = @(
                    @{
                        Name            = 'Restrictions'
                        CimInstanceName = 'AADAppManagementPolicyRestrictions'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'PasswordCredentials'
                        CimInstanceName = 'AADAppManagementPolicyRestrictionsCredential'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'KeyCredentials'
                        CimInstanceName = 'AADAppManagementPolicyRestrictionsCredential'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.Restrictions `
                    -CIMInstanceName 'AADAppManagementPolicyRestrictions' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.Restrictions = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Restrictions') | Out-Null
                }
            }
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('Restrictions', 'KeyCredentials', 'PasswordCredentials')
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
