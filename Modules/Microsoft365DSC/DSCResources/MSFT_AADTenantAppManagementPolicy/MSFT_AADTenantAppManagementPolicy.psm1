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
        $IsEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ApplicationRestrictions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ServicePrincipalRestrictions,

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
        $instance = Get-MgBetaPolicyDefaultAppManagementPolicy -ErrorAction SilentlyContinue

        if ($null -eq $instance)
        {
            return $nullResult
        }

        #region ApplicationRestrictions
        $appRestrictionsValue = @{
            passwordCredentials     = @()
            keyCredentials          = @()
        }

        foreach ($passwordCred in $instance.ApplicationRestrictions.PasswordCredentials)
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
            $appRestrictionsValue.passwordCredentials += $newItem
        }

        foreach ($keyCred in $instance.ApplicationRestrictions.KeyCredentials)
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
            $appRestrictionsValue.keyCredentials += $newItem
        }
        #endregion

        #region ServicePrincipalRestrictions
        $spnRestrictionsValue = @{
            passwordCredentials     = @()
            keyCredentials          = @()
        }

        foreach ($passwordCred in $instance.ServicePrincipalRestrictions.PasswordCredentials)
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
            $spnRestrictionsValue.passwordCredentials += $newItem
        }

        foreach ($keyCred in $instance.ServicePrincipalRestrictions.KeyCredentials)
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
            $spnRestrictionsValue.keyCredentials += $newItem
        }
        #endregion

        $results = @{
            DisplayName                  = $instance.DisplayName
            Description                  = $instance.Description
            IsEnabled                    = $instance.IsEnabled
            ApplicationRestrictions      = $appRestrictionsValue
            ServicePrincipalRestrictions = $spnRestrictionsValue
            Ensure                       = 'Present'
            Credential                   = $Credential
            ApplicationId                = $ApplicationId
            TenantId                     = $TenantId
            CertificateThumbprint        = $CertificateThumbprint
            ManagedIdentity              = $ManagedIdentity.IsPresent
            AccessTokens                 = $AccessTokens
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
        $Description,

        [Parameter()]
        [System.Boolean]
        $IsEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ApplicationRestrictions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ServicePrincipalRestrictions,

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
    $appRestrictionsValue = @{
        passwordCredentials = @()
        keyCredentials      = @()
    }

    foreach ($passwordCred in $ApplicationRestrictions.PasswordCredentials)
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
        $appRestrictionsValue.passwordCredentials += $newItem
    }

    foreach ($keyCred in $ApplicationRestrictions.KeyCredentials)
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
        $appRestrictionsValue.keyCredentials += $newItem
    }

    $setParameters.ApplicationRestrictions = $appRestrictionsValue

    $spnRestrictionsValue = @{
        passwordCredentials = @()
        keyCredentials      = @()
    }

    foreach ($passwordCred in $ServicePrincipalRestrictions.PasswordCredentials)
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
        $spnRestrictionsValue.passwordCredentials += $newItem
    }

    foreach ($keyCred in $ServicePrincipalRestrictions.KeyCredentials)
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
        $spnRestrictionsValue.keyCredentials += $newItem
    }

    $setParameters.ServicePrincipalRestrictions = $spnRestrictionsValue

    Write-Verbose -Message "Updating the Default App Management Policy"
    Update-MgBetaPolicyDefaultAppManagementPolicy @setParameters
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
        $IsEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ApplicationRestrictions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ServicePrincipalRestrictions,

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
        [array] $Script:exportedInstances = Get-MgBetaPolicyDefaultAppManagementPolicy -ErrorAction Stop

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
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Results = Get-TargetResource @Params
            if ($null -ne $Results.ApplicationRestrictions)
            {
                $complexMapping = @(
                    @{
                        Name            = 'ApplicationRestrictions'
                        CimInstanceName = 'AADTenantAppManagementPolicyRestrictions'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'PasswordCredentials'
                        CimInstanceName = 'AADTenantAppManagementPolicyRestrictionsCredential'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'KeyCredentials'
                        CimInstanceName = 'AADTenantAppManagementPolicyRestrictionsCredential'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.ApplicationRestrictions `
                    -CIMInstanceName 'AADTenantAppManagementPolicyRestrictions' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.ApplicationRestrictions = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('ApplicationRestrictions') | Out-Null
                }
            }
            if ($null -ne $Results.ServicePrincipalRestrictions)
            {
                $complexMapping = @(
                    @{
                        Name            = 'ServicePrincipalRestrictions'
                        CimInstanceName = 'AADTenantAppManagementPolicyRestrictions'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'PasswordCredentials'
                        CimInstanceName = 'AADTenantAppManagementPolicyRestrictionsCredential'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'KeyCredentials'
                        CimInstanceName = 'AADTenantAppManagementPolicyRestrictionsCredential'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.ServicePrincipalRestrictions `
                    -CIMInstanceName 'AADTenantAppManagementPolicyRestrictions' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.ServicePrincipalRestrictions = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('ServicePrincipalRestrictions') | Out-Null
                }
            }
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('ApplicationRestrictions', 'ServicePrincipalRestrictions', 'KeyCredentials', 'PasswordCredentials')
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
