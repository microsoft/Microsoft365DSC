Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADTenantAppManagementPolicy'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter()]
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

        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

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

    Write-Verbose -Message "Getting configuration for the AAD Tenant App Management Policy with DisplayName {$DisplayName}"

    try
    {
        if (-not $Script:exportedInstance)
        {
            $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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
            $nullResult.Ensure = 'Absent'

            $instance = Get-MgBetaPolicyDefaultAppManagementPolicy -ErrorAction SilentlyContinue

            if ($null -eq $instance)
            {
                return $nullResult
            }
        }
        else
        {
            $instance = $Script:exportedInstance
        }

        #region ApplicationRestrictions
        $appRestrictionsValue = @{
            passwordCredentials = @()
            keyCredentials      = @()
        }

        foreach ($passwordCred in $instance.ApplicationRestrictions.PasswordCredentials)
        {
            $newItem = [ordered]@{
                restrictForAppsCreatedAfterDateTime = $passwordCred.RestrictForAppsCreatedAfterDateTime.ToString("o")
                restrictionType                     = $passwordCred.RestrictionType
                state                               = $passwordCred.State
            }
            if ($null -ne $passwordCred.MaxLifetime)
            {
                $newItem.Add('maxLifetime', $passwordCred.MaxLifetime)
            }
            $appRestrictionsValue.passwordCredentials += $newItem
        }

        foreach ($keyCred in $instance.ApplicationRestrictions.KeyCredentials)
        {
            $newItem = [ordered]@{
                restrictForAppsCreatedAfterDateTime = $keyCred.RestrictForAppsCreatedAfterDateTime.ToString("o")
                restrictionType                     = $keyCred.RestrictionType
                state                               = $keyCred.State
            }
            if ($null -ne $keyCred.MaxLifetime)
            {
                $newItem.Add('maxLifetime', $keyCred.MaxLifetime)
            }
            if ($null -ne $keyCred.CertificateBasedApplicationConfigurationIds -and $keyCred.CertificateBasedApplicationConfigurationIds.Count -gt 0)
            {
                $newItem.Add('certificateBasedApplicationConfigurationIds', [System.String[]]$keyCred.CertificateBasedApplicationConfigurationIds)
            }
            $appRestrictionsValue.keyCredentials += $newItem
        }
        #endregion

        #region ServicePrincipalRestrictions
        $spnRestrictionsValue = [ordered]@{
            passwordCredentials = @()
            keyCredentials      = @()
        }

        foreach ($passwordCred in $instance.ServicePrincipalRestrictions.PasswordCredentials)
        {
            $newItem = [ordered]@{
                restrictForAppsCreatedAfterDateTime = $passwordCred.RestrictForAppsCreatedAfterDateTime.ToString("o")
                restrictionType                     = $passwordCred.RestrictionType
                state                               = $passwordCred.State
            }
            if ($null -ne $passwordCred.MaxLifetime)
            {
                $newItem.Add('maxLifetime', $passwordCred.MaxLifetime)
            }
            $spnRestrictionsValue.passwordCredentials += $newItem
        }

        foreach ($keyCred in $instance.ServicePrincipalRestrictions.KeyCredentials)
        {
            $newItem = [ordered]@{
                restrictForAppsCreatedAfterDateTime = $keyCred.RestrictForAppsCreatedAfterDateTime.ToString("o")
                restrictionType                     = $keyCred.RestrictionType
                state                               = $keyCred.State
            }
            if ($null -ne $keyCred.MaxLifetime)
            {
                $newItem.Add('maxLifetime', $keyCred.MaxLifetime)
            }
            if ($null -ne $keyCred.CertificateBasedApplicationConfigurationIds -and $keyCred.CertificateBasedApplicationConfigurationIds.Count -gt 0)
            {
                $newItem.Add('certificateBasedApplicationConfigurationIds', [System.String[]]$keyCred.CertificateBasedApplicationConfigurationIds)
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
            IsSingleInstance             = 'Yes'
            Credential                   = $Credential
            ApplicationId                = $ApplicationId
            TenantId                     = $TenantId
            CertificateThumbprint        = $CertificateThumbprint
            CertificatePath              = $CertificatePath
            CertificatePassword          = $CertificatePassword
            ManagedIdentity              = $ManagedIdentity.IsPresent
            AccessTokens                 = $AccessTokens
        }
        return $results
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
        [Parameter()]
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

        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

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

    Write-Verbose -Message "Setting configuration of Default App Management Policy"

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

    $null = Get-TargetResource @PSBoundParameters

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
        if ($null -ne $keyCred.CertificateBasedApplicationConfigurationIds -and $keyCred.CertificateBasedApplicationConfigurationIds.Count -gt 0)
        {
            $newItem.Add('certificateBasedApplicationConfigurationIds', [System.String[]]$keyCred.CertificateBasedApplicationConfigurationIds)
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
        if ($null -ne $keyCred.CertificateBasedApplicationConfigurationIds -and $keyCred.CertificateBasedApplicationConfigurationIds.Count -gt 0)
        {
            $newItem.Add('certificateBasedApplicationConfigurationIds', [System.String[]]$keyCred.CertificateBasedApplicationConfigurationIds)
        }
        $spnRestrictionsValue.keyCredentials += $newItem
    }

    $setParameters.ServicePrincipalRestrictions = $spnRestrictionsValue
    $setParameters.Remove('IsSingleInstance') | Out-Null

    Write-Verbose -Message 'Updating the Default App Management Policy'
    Update-MgBetaPolicyDefaultAppManagementPolicy -BodyParameter $setParameters
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter()]
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

        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

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

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $compareParameters = Get-CompareParameters
    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '') `
        @compareParameters
    return $result
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
        [array] $exportedInstances = Get-MgBetaPolicyDefaultAppManagementPolicy -ErrorAction Stop

        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
        if ($exportedInstances.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($config in $exportedInstances)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.DisplayName
            Write-M365DSCHost -Message "    |---[$i/$($exportedInstances.Count)] $displayedKey" -DeferWrite
            $params = @{
                IsSingleInstance      = 'Yes'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $config
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
            [void]$dscContent.Append($currentDSCBlock)
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        return $dscContent.ToString()
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
}

function Get-CompareParameters
{
    return @{
        PostProcessing = {
            param($DesiredValues, $CurrentValues, $ValuesToCheck, $ignore)
            foreach ($keyCred in $DesiredValues.ApplicationRestrictions.KeyCredentials)
            {
                if (-not [System.String]::IsNullOrWhiteSpace($keyCred.MaxLifetime))
                {
                    $keyCred.MaxLifetime = $keyCred.MaxLifetime.Replace("T0H0M0S", "")
                }
            }
            foreach ($passwordCred in $DesiredValues.ApplicationRestrictions.PasswordCredentials)
            {
                if (-not [System.String]::IsNullOrWhiteSpace($passwordCred.MaxLifetime))
                {
                    $passwordCred.MaxLifetime = $passwordCred.MaxLifetime.Replace("T0H0M0S", "")
                }
            }
            foreach ($keyCred in $DesiredValues.ServicePrincipalRestrictions.KeyCredentials)
            {
                if (-not [System.String]::IsNullOrWhiteSpace($keyCred.MaxLifetime))
                {
                    $keyCred.MaxLifetime = $keyCred.MaxLifetime.Replace("T0H0M0S", "")
                }
            }
            foreach ($passwordCred in $DesiredValues.ServicePrincipalRestrictions.PasswordCredentials)
            {
                if (-not [System.String]::IsNullOrWhiteSpace($passwordCred.MaxLifetime))
                {
                    $passwordCred.MaxLifetime = $passwordCred.MaxLifetime.Replace("T0H0M0S", "")
                }
            }
            foreach ($keyCred in $CurrentValues.ApplicationRestrictions.KeyCredentials)
            {
                if (-not [System.String]::IsNullOrWhiteSpace($keyCred.MaxLifetime))
                {
                    $keyCred.MaxLifetime = $keyCred.MaxLifetime.Replace("T0H0M0S", "")
                }
            }
            foreach ($passwordCred in $CurrentValues.ApplicationRestrictions.PasswordCredentials)
            {
                if (-not [System.String]::IsNullOrWhiteSpace($passwordCred.MaxLifetime))
                {
                    $passwordCred.MaxLifetime = $passwordCred.MaxLifetime.Replace("T0H0M0S", "")
                }
            }
            foreach ($keyCred in $CurrentValues.ServicePrincipalRestrictions.KeyCredentials)
            {
                if (-not [System.String]::IsNullOrWhiteSpace($keyCred.MaxLifetime))
                {
                    $keyCred.MaxLifetime = $keyCred.MaxLifetime.Replace("T0H0M0S", "")
                }
            }
            foreach ($passwordCred in $CurrentValues.ServicePrincipalRestrictions.PasswordCredentials)
            {
                if (-not [System.String]::IsNullOrWhiteSpace($passwordCred.MaxLifetime))
                {
                    $passwordCred.MaxLifetime = $passwordCred.MaxLifetime.Replace("T0H0M0S", "")
                }
            }
            return [System.Tuple[Hashtable, Hashtable, Hashtable]]::new($DesiredValues, $CurrentValues, $ValuesToCheck)
        }
    }
}

Export-ModuleMember -Function @('*-TargetResource', 'Get-CompareParameters')
