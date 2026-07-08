Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADAuthenticationMethodPolicyAuthenticator'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FeatureSettings,

        [Parameter()]
        [System.Boolean]
        $IsSoftwareOathEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ExcludeTargets,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $IncludeTargets,

        [Parameter()]
        [ValidateSet('enabled', 'disabled')]
        [System.String]
        $State,
        #endregion

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

    Write-Verbose -Message "Getting the Azure AD Authentication Method Policy with Id {$Id}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Id -ne $Id)
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

            $getValue = $null
            #region resource generator code
            $getValue = Get-MgBetaPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -AuthenticationMethodConfigurationId $Id -ErrorAction SilentlyContinue

            #endregion
            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Azure AD Authentication Method Policy Authenticator with id {$id}"
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Azure AD Authentication Method Policy Authenticator with Id {$Id} was found."

        #region resource generator code
        $complexFeatureSettings = [ordered]@{}

        Write-Verbose 'Processing FeatureSettings > companionAppAllowedState > excludeTarget'
        $complexCompanionAppAllowedState = [ordered]@{}
        $complexExcludeTarget = [ordered]@{}
        if ($getValue.featureSettings.companionAppAllowedState.excludeTarget.id -notmatch 'all_users|00000000-0000-0000-0000-000000000000')
        {
            $myExcludeTargetsDisplayName = Get-M365DSCGroupDisplayNameById -GroupId $getValue.featureSettings.companionAppAllowedState.excludeTarget.id
            if ($null -eq $myExcludeTargetsDisplayName)
            {
                continue
            }
            $complexExcludeTarget.Add('Id', $myExcludeTargetsDisplayName)
        }
        else
        {
            if ($getValue.featureSettings.companionAppAllowedState.excludeTarget.id -eq '00000000-0000-0000-0000-000000000000')
            {
                $complexExcludeTarget.Add('Id', '00000000-0000-0000-0000-000000000000')
            }
            else
            {
                $complexExcludeTarget.Add('Id', 'all_users')
            }
        }

        if ($null -ne $getValue.featureSettings.companionAppAllowedState.excludeTarget.targetType)
        {
            $complexExcludeTarget.Add('TargetType', $getValue.featureSettings.companionAppAllowedState.excludeTarget.targetType.ToString())
        }

        if ($complexExcludeTarget.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexExcludeTarget = $null
        }
        $complexCompanionAppAllowedState.Add('ExcludeTarget', $complexExcludeTarget)

        Write-Verbose 'Processing FeatureSettings > companionAppAllowedState > includeTarget'
        $complexIncludeTarget = [ordered]@{}
        if ($getValue.featureSettings.companionAppAllowedState.includeTarget.id -notmatch 'all_users|00000000-0000-0000-0000-000000000000')
        {
            $myIncludeTargetsDisplayName = Get-M365DSCGroupDisplayNameById -GroupId $getValue.featureSettings.companionAppAllowedState.includeTarget.id
            if ($null -eq $myIncludeTargetsDisplayName)
            {
                continue
            }
            $complexIncludeTarget.Add('Id', $myIncludeTargetsDisplayName)
        }
        else
        {
            if ($getValue.featureSettings.companionAppAllowedState.includeTarget.id -eq '00000000-0000-0000-0000-000000000000')
            {
                $complexIncludeTarget.Add('Id', '00000000-0000-0000-0000-000000000000')
            }
            else
            {
                $complexIncludeTarget.Add('Id', 'all_users')
            }
        }

        if ($null -ne $getValue.featureSettings.companionAppAllowedState.includeTarget.targetType)
        {
            $complexIncludeTarget.Add('TargetType', $getValue.featureSettings.companionAppAllowedState.includeTarget.targetType.ToString())
        }

        if ($complexIncludeTarget.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexIncludeTarget = $null
        }
        $complexCompanionAppAllowedState.Add('IncludeTarget', $complexIncludeTarget)

        Write-Verbose 'Processing FeatureSettings > companionAppAllowedState > state'
        if ($null -ne $getValue.featureSettings.companionAppAllowedState.state)
        {
            $complexCompanionAppAllowedState.Add('State', $getValue.featureSettings.companionAppAllowedState.state.ToString())
        }

        if ($complexCompanionAppAllowedState.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexCompanionAppAllowedState = $null
        }

        $complexFeatureSettings.Add('CompanionAppAllowedState', $complexCompanionAppAllowedState)
        $complexDisplayAppInformationRequiredState = [ordered]@{}

        Write-Verbose 'Processing FeatureSettings > displayAppInformationRequiredState > excludeTarget'
        $complexExcludeTarget = [ordered]@{}
        if ($getValue.featureSettings.displayAppInformationRequiredState.excludeTarget.id -notmatch 'all_users|00000000-0000-0000-0000-000000000000')
        {
            $myExcludeTargetsDisplayName = Get-M365DSCGroupDisplayNameById -GroupId $getValue.featureSettings.displayAppInformationRequiredState.excludeTarget.id
            if ($null -eq $myExcludeTargetsDisplayName)
            {
                continue
            }
            $complexExcludeTarget.Add('Id', $myExcludeTargetsDisplayName)
        }
        else
        {
            if ($getValue.featureSettings.displayAppInformationRequiredState.excludeTarget.id -eq '00000000-0000-0000-0000-000000000000')
            {
                $complexExcludeTarget.Add('Id', '00000000-0000-0000-0000-000000000000')
            }
            else
            {
                $complexExcludeTarget.Add('Id', 'all_users')
            }
        }

        if ($null -ne $getValue.featureSettings.displayAppInformationRequiredState.excludeTarget.targetType)
        {
            $complexExcludeTarget.Add('TargetType', $getValue.featureSettings.displayAppInformationRequiredState.excludeTarget.targetType.ToString())
        }
        if ($complexExcludeTarget.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexExcludeTarget = $null
        }
        $complexDisplayAppInformationRequiredState.Add('ExcludeTarget', $complexExcludeTarget)

        Write-Verbose 'Processing FeatureSettings > displayAppInformationRequiredState > includeTarget'
        $complexIncludeTarget = [ordered]@{}
        if ($getValue.featureSettings.displayAppInformationRequiredState.includeTarget.id -notmatch 'all_users|00000000-0000-0000-0000-000000000000')
        {
            $myIncludeTargetsDisplayName = Get-M365DSCGroupDisplayNameById -GroupId $getValue.featureSettings.displayAppInformationRequiredState.includeTarget.id
            if ($null -eq $myIncludeTargetsDisplayName)
            {
                continue
            }
            $complexIncludeTarget.Add('Id', $myIncludeTargetsDisplayName)
        }
        else
        {
            if ($getValue.featureSettings.displayAppInformationRequiredState.includeTarget.id -eq '00000000-0000-0000-0000-000000000000')
            {
                $complexIncludeTarget.Add('Id', '00000000-0000-0000-0000-000000000000')
            }
            else
            {
                $complexIncludeTarget.Add('Id', 'all_users')
            }
        }

        if ($null -ne $getValue.featureSettings.displayAppInformationRequiredState.includeTarget.targetType)
        {
            $complexIncludeTarget.Add('TargetType', $getValue.featureSettings.displayAppInformationRequiredState.includeTarget.targetType.ToString())
        }

        if ($complexIncludeTarget.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexIncludeTarget = $null
        }
        $complexDisplayAppInformationRequiredState.Add('IncludeTarget', $complexIncludeTarget)

        Write-Verbose 'Processing FeatureSettings > displayAppInformationRequiredState > state'
        if ($null -ne $getValue.featureSettings.displayAppInformationRequiredState.state)
        {
            $complexDisplayAppInformationRequiredState.Add('State', $getValue.featureSettings.displayAppInformationRequiredState.state.ToString())
        }

        if ($complexDisplayAppInformationRequiredState.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexDisplayAppInformationRequiredState = $null
        }

        $complexFeatureSettings.Add('DisplayAppInformationRequiredState', $complexDisplayAppInformationRequiredState)

        Write-Verbose 'Processing FeatureSettings > displayLocationInformationRequiredState > excludeTarget'
        $complexDisplayLocationInformationRequiredState = [ordered]@{}
        $complexExcludeTarget = [ordered]@{}
        if ($getValue.featureSettings.displayLocationInformationRequiredState.excludeTarget.id -notmatch 'all_users|00000000-0000-0000-0000-000000000000')
        {
            $myExcludeTargetsDisplayName = Get-M365DSCGroupDisplayNameById -GroupId $getValue.featureSettings.displayLocationInformationRequiredState.excludeTarget.id
            if ($null -eq $myExcludeTargetsDisplayName)
            {
                continue
            }
            $complexExcludeTarget.Add('Id', $myExcludeTargetsDisplayName)
        }
        else
        {
            if ($getValue.featureSettings.displayLocationInformationRequiredState.excludeTarget.id -eq '00000000-0000-0000-0000-000000000000')
            {
                $complexExcludeTarget.Add('Id', '00000000-0000-0000-0000-000000000000')
            }
            else
            {
                $complexExcludeTarget.Add('Id', 'all_users')
            }
        }

        if ($null -ne $getValue.featureSettings.displayLocationInformationRequiredState.excludeTarget.targetType)
        {
            $complexExcludeTarget.Add('TargetType', $getValue.featureSettings.displayLocationInformationRequiredState.excludeTarget.targetType.ToString())
        }

        if ($complexExcludeTarget.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexExcludeTarget = $null
        }

        $complexDisplayLocationInformationRequiredState.Add('ExcludeTarget', $complexExcludeTarget)

        Write-Verbose 'Processing FeatureSettings > displayLocationInformationRequiredState > includeTarget'
        $complexIncludeTarget = [ordered]@{}
        if ($getValue.featureSettings.displayLocationInformationRequiredState.includeTarget.id -notmatch 'all_users|00000000-0000-0000-0000-000000000000')
        {
            $myIncludeTargetsDisplayName = Get-M365DSCGroupDisplayNameById -GroupId $getValue.featureSettings.displayLocationInformationRequiredState.includeTarget.id
            if ($null -eq $myIncludeTargetsDisplayName)
            {
                continue
            }
            $complexIncludeTarget.Add('Id', $myIncludeTargetsDisplayName)
        }
        else
        {
            if ($getValue.featureSettings.displayLocationInformationRequiredState.includeTarget.id -eq '00000000-0000-0000-0000-000000000000')
            {
                $complexIncludeTarget.Add('Id', '00000000-0000-0000-0000-000000000000')
            }
            else
            {
                $complexIncludeTarget.Add('Id', 'all_users')
            }
        }

        if ($null -ne $getValue.featureSettings.displayLocationInformationRequiredState.includeTarget.targetType)
        {
            $complexIncludeTarget.Add('TargetType', $getValue.featureSettings.displayLocationInformationRequiredState.includeTarget.targetType.ToString())
        }

        if ($complexIncludeTarget.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexIncludeTarget = $null
        }

        $complexDisplayLocationInformationRequiredState.Add('IncludeTarget', $complexIncludeTarget)

        Write-Verbose 'Processing FeatureSettings > displayLocationInformationRequiredState > state'
        if ($null -ne $getValue.featureSettings.displayLocationInformationRequiredState.state)
        {
            $complexDisplayLocationInformationRequiredState.Add('State', $getValue.featureSettings.displayLocationInformationRequiredState.state.ToString())
        }

        if ($complexDisplayLocationInformationRequiredState.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexDisplayLocationInformationRequiredState = $null
        }

        $complexFeatureSettings.Add('DisplayLocationInformationRequiredState', $complexDisplayLocationInformationRequiredState)

        $complexExcludeTargets = @()
        foreach ($currentExcludeTargets in $getValue.ExcludeTargets)
        {
            $myExcludeTargets = [ordered]@{}
            if ($currentExcludeTargets.id -ne 'all_users')
            {
                $myExcludeTargetsDisplayName = Get-M365DSCGroupDisplayNameById -GroupId $currentExcludeTargets.id
                if ($null -eq $myExcludeTargetsDisplayName)
                {
                    continue
                }
                $myExcludeTargets.Add('Id', $myExcludeTargetsDisplayName)
            }
            else
            {
                $myExcludeTargets.Add('Id', $currentExcludeTargets.id)
            }

            if ($null -ne $currentExcludeTargets.targetType)
            {
                $myExcludeTargets.Add('TargetType', $currentExcludeTargets.targetType.ToString())
            }

            if ($myExcludeTargets.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexExcludeTargets += $myExcludeTargets
            }
        }
        #endregion

        $complexIncludeTargets = @()
        foreach ($currentIncludeTargets in $getValue.includeTargets)
        {
            $myIncludeTargets = [ordered]@{}
            if ($currentIncludeTargets.id -ne 'all_users')
            {
                $myIncludeTargetsDisplayName = Get-M365DSCGroupDisplayNameById -GroupId $currentIncludeTargets.id
                if ($null -eq $myIncludeTargetsDisplayName)
                {
                    continue
                }
                $myIncludeTargets.Add('Id', $myIncludeTargetsDisplayName)
            }
            else
            {
                $myIncludeTargets.Add('Id', $currentIncludeTargets.id)
            }

            if ($null -ne $currentIncludeTargets.targetType)
            {
                $myIncludeTargets.Add('TargetType', $currentIncludeTargets.targetType.ToString())
            }

            if ($myIncludeTargets.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexIncludeTargets += $myIncludeTargets
            }
        }

        #region resource generator code
        $enumState = $null
        if ($null -ne $getValue.State)
        {
            $enumState = $getValue.State.ToString()
        }
        #endregion

        $results = @{
            #region resource generator code
            FeatureSettings       = $complexFeatureSettings
            IsSoftwareOathEnabled = $getValue.isSoftwareOathEnabled
            ExcludeTargets        = $complexExcludeTargets
            IncludeTargets        = $complexIncludeTargets
            State                 = $enumState
            Id                    = $getValue.Id
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            CertificatePath       = $CertificatePath
            CertificatePassword   = $CertificatePassword
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
            #endregion
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
        #region resource generator code
        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FeatureSettings,

        [Parameter()]
        [System.Boolean]
        $IsSoftwareOathEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ExcludeTargets,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $IncludeTargets,

        [Parameter()]
        [ValidateSet('enabled', 'disabled')]
        [System.String]
        $State,
        #endregion

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

    Write-Verbose -Message "Setting the Azure AD Authentication Method Policy Authenticator with Id {$Id}"

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

    if ($Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Azure AD Authentication Method Policy Authenticator with Id {$($currentInstance.Id)}"

        $UpdateParameters = ([Hashtable]$BoundParameters).Clone()
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters
        $UpdateParameters.Remove('Id') | Out-Null

        # replace group Displayname with group id
        Update-M365DSCAuthenticationTargets -Targets $UpdateParameters.featureSettings.companionAppAllowedState.includeTarget
        Update-M365DSCAuthenticationTargets -Targets $UpdateParameters.featureSettings.companionAppAllowedState.excludeTarget
        Update-M365DSCAuthenticationTargets -Targets $UpdateParameters.featureSettings.displayAppInformationRequiredState.includeTarget
        Update-M365DSCAuthenticationTargets -Targets $UpdateParameters.featureSettings.displayAppInformationRequiredState.excludeTarget
        Update-M365DSCAuthenticationTargets -Targets $UpdateParameters.featureSettings.displayLocationInformationRequiredState.includeTarget
        Update-M365DSCAuthenticationTargets -Targets $UpdateParameters.featureSettings.displayLocationInformationRequiredState.excludeTarget
        Update-M365DSCAuthenticationTargets -Targets $UpdateParameters.ExcludeTargets
        Update-M365DSCAuthenticationTargets -Targets $UpdateParameters.IncludeTargets

        #region resource generator code
        Write-Verbose -Message "Parameters:`r`n$(ConvertTo-Json $UpdateParameters -Depth 10)"
        $UpdateParameters.Add('@odata.type', '#microsoft.graph.microsoftAuthenticatorAuthenticationMethodConfiguration')
        Update-MgBetaPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration `
            -AuthenticationMethodConfigurationId $currentInstance.Id `
            -BodyParameter $UpdateParameters
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Azure AD Authentication Method Policy Authenticator with Id {$($currentInstance.Id)}"
        #region resource generator code
        Remove-MgBetaPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -AuthenticationMethodConfigurationId $currentInstance.Id
        #endregion
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        #region resource generator code
        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FeatureSettings,

        [Parameter()]
        [System.Boolean]
        $IsSoftwareOathEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ExcludeTargets,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $IncludeTargets,

        [Parameter()]
        [ValidateSet('enabled', 'disabled')]
        [System.String]
        $State,
        #endregion

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

    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '')
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
        #region resource generator code
        [array]$getValue = Get-MgBetaPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration `
            -AuthenticationMethodConfigurationId MicrosoftAuthenticator `
            -ErrorAction Stop | Where-Object -FilterScript { $null -ne $_.Id }
        #endregion

        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
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
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.Id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                Id                    = $config.Id
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params
            if ($null -ne $Results.FeatureSettings)
            {
                $complexMapping = @(
                    @{
                        Name            = 'FeatureSettings'
                        CimInstanceName = 'MicrosoftGraphMicrosoftAuthenticatorFeatureSettings'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'CompanionAppAllowedState'
                        CimInstanceName = 'MicrosoftGraphAuthenticationMethodFeatureConfiguration'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'ExcludeTarget'
                        CimInstanceName = 'AADAuthenticationMethodPolicyAuthenticatorFeatureTarget'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'IncludeTarget'
                        CimInstanceName = 'AADAuthenticationMethodPolicyAuthenticatorFeatureTarget'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'DisplayAppInformationRequiredState'
                        CimInstanceName = 'MicrosoftGraphAuthenticationMethodFeatureConfiguration'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'DisplayLocationInformationRequiredState'
                        CimInstanceName = 'MicrosoftGraphAuthenticationMethodFeatureConfiguration'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.FeatureSettings `
                    -CIMInstanceName 'MicrosoftGraphmicrosoftAuthenticatorFeatureSettings' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.FeatureSettings = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('FeatureSettings') | Out-Null
                }
            }
            if ($null -ne $Results.ExcludeTargets)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.ExcludeTargets `
                    -CIMInstanceName 'AADAuthenticationMethodPolicyAuthenticatorExcludeTarget'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.ExcludeTargets = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('ExcludeTargets') | Out-Null
                }
            }
            if ($null -ne $Results.IncludeTargets)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.IncludeTargets `
                    -CIMInstanceName 'AADAuthenticationMethodPolicyAuthenticatorIncludeTarget'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.IncludeTargets = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('IncludeTargets') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('FeatureSettings', 'ExcludeTargets', 'IncludeTargets')

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

Export-ModuleMember -Function *-TargetResource
