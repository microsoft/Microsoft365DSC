Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADAuthenticationMethodPolicyFido2'

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
        [System.Boolean]
        $IsAttestationEnforced,

        [Parameter()]
        [System.Boolean]
        $IsSelfServiceRegistrationAllowed,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $KeyRestrictions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ExcludeTargets,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $IncludeTargets,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $PasskeyProfiles,

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

    Write-Verbose -Message "Getting the Azure AD Authentication Method Policy Fido2 with Id {$Id}"

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
                Write-Verbose -Message "Could not find an Azure AD Authentication Method Policy Fido2 with id {$id}"
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Azure AD Authentication Method Policy Fido2 with Id {$Id} was found."

        #region resource generator code
        Write-Verbose 'Processing KeyRestrictions'
        $complexKeyRestrictions = [ordered]@{}
        $complexKeyRestrictions.Add('AaGuids', $getValue.keyRestrictions.aaGuids)
        if ($null -ne $getValue.keyRestrictions.enforcementType)
        {
            $complexKeyRestrictions.Add('EnforcementType', $getValue.keyRestrictions.enforcementType.ToString())
        }
        $complexKeyRestrictions.Add('IsEnforced', $getValue.keyRestrictions.isEnforced)
        if ($complexKeyRestrictions.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexKeyRestrictions = $null
        }

        Write-Verbose 'Processing ExcludeTargets'
        $complexExcludeTargets = @()
        foreach ($currentExcludeTargets in $getValue.excludeTargets)
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

            if ($null -ne $currentExcludeTargets.isRegistrationRequired)
            {
                $myExcludeTargets.Add('IsRegistrationRequired', [System.Convert]::ToBoolean($currentExcludeTargets.isRegistrationRequired))
            }

            if ($null -ne $currentExcludeTargets.allowedPasskeyProfiles)
            {
                $myExcludeTargets.Add('AllowedPasskeyProfiles', [string[]]$currentExcludeTargets.allowedPasskeyProfiles)
            }

            if ($myExcludeTargets.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexExcludeTargets += $myExcludeTargets
            }
        }
        #endregion

        Write-Verbose 'Processing IncludeTargets'
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

            if ($null -ne $currentIncludeTargets.isRegistrationRequired)
            {
                $myIncludeTargets.Add('IsRegistrationRequired', [System.Convert]::ToBoolean($currentIncludeTargets.isRegistrationRequired))
            }

            if ($null -ne $currentIncludeTargets.allowedPasskeyProfiles)
            {
                $myIncludeTargets.Add('AllowedPasskeyProfiles', [string[]]$currentIncludeTargets.allowedPasskeyProfiles)
            }

            if ($myIncludeTargets.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexIncludeTargets += $myIncludeTargets
            }
        }

        Write-Verbose 'Processing Passkey profiles'
        $complexPasskeyProfiles = @()
        foreach ($currentPasskeyProfiles in $getValue.passkeyProfiles){
            $myPasskeyProfiles = @{}
            $myPasskeyProfiles.Add('Id', $currentPasskeyProfiles.id)
            $myPasskeyProfiles.Add('Name', $currentPasskeyProfiles.name)
            if ($null -ne $currentPasskeyProfiles.passkeyTypes)
            {
                # Convert array to single comma-separated string if needed
                if ($currentPasskeyProfiles.passkeyTypes -is [Array])
                {
                    $myPasskeyProfiles.Add('PasskeyTypes', $currentPasskeyProfiles.passkeyTypes -join ',')
                }
                else
                {
                    $myPasskeyProfiles.Add('PasskeyTypes', $currentPasskeyProfiles.passkeyTypes)
                }
            }
            if ($null -ne $currentPasskeyProfiles.attestationEnforcement)
            {
                $myPasskeyProfiles.Add('AttestationEnforcement', $currentPasskeyProfiles.attestationEnforcement.ToString())
            }
            if ($null -ne $currentPasskeyProfiles.keyRestrictions)
            {
                $KeyRestrictionsForProfile = @{
                    AaGuids = $currentPasskeyProfiles.keyRestrictions.aaGuids
                    IsEnforced = $currentPasskeyProfiles.keyRestrictions.isEnforced
                }
                if ($null -ne $currentPasskeyProfiles.keyRestrictions.enforcementType)
                {
                    $KeyRestrictionsForProfile['EnforcementType'] = $currentPasskeyProfiles.keyRestrictions.enforcementType.ToString()
                }
                $myPasskeyProfiles.Add('KeyRestrictions', $KeyRestrictionsForProfile)
            }
            if ($myPasskeyProfiles.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexPasskeyProfiles += $myPasskeyProfiles
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
            IsAttestationEnforced            = $getValue.isAttestationEnforced
            IsSelfServiceRegistrationAllowed = $getValue.isSelfServiceRegistrationAllowed
            KeyRestrictions                  = $complexKeyRestrictions
            ExcludeTargets                   = $complexExcludeTargets
            IncludeTargets                   = $complexIncludeTargets
            PasskeyProfiles                  = $complexPasskeyProfiles
            State                            = $enumState
            Id                               = $getValue.Id
            Ensure                           = 'Present'
            Credential                       = $Credential
            ApplicationId                    = $ApplicationId
            TenantId                         = $TenantId
            ApplicationSecret                = $ApplicationSecret
            CertificateThumbprint            = $CertificateThumbprint
            CertificatePath                  = $CertificatePath
            CertificatePassword              = $CertificatePassword
            ManagedIdentity                  = $ManagedIdentity.IsPresent
            AccessTokens                     = $AccessTokens
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
        [System.Boolean]
        $IsAttestationEnforced,

        [Parameter()]
        [System.Boolean]
        $IsSelfServiceRegistrationAllowed,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $KeyRestrictions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ExcludeTargets,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $IncludeTargets,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $PasskeyProfiles,

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

    Write-Verbose -Message "Setting the Azure AD Authentication Method Policy Fido2 with Id {$Id}"

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
        Write-Verbose -Message "Updating the Azure AD Authentication Method Policy Fido2 with Id {$($currentInstance.Id)}"

        $UpdateParameters = ([Hashtable]$BoundParameters).Clone()
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters

        Update-M365DSCAuthenticationTargets -Targets $UpdateParameters.ExcludeTargets
        Update-M365DSCAuthenticationTargets -Targets $UpdateParameters.IncludeTargets

        if ($UpdateParameters.ContainsKey('PasskeyProfiles'))
        {
            # Ensure passkeyTypes is handled as a single string value for API compatibility
            foreach ($profile in $UpdateParameters.PasskeyProfiles)
            {
                if ($null -ne $profile.passkeyTypes -and $profile.passkeyTypes -is [Array])
                {
                    $profile.passkeyTypes = $profile.passkeyTypes -join ','
                }
            }
        }

        #region resource generator code
        Write-Verbose -Message "Parameters:`r`n$(ConvertTo-Json $UpdateParameters -Depth 10)"
        $UpdateParameters.Add('@odata.type', '#microsoft.graph.fido2AuthenticationMethodConfiguration')
        Update-MgBetaPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration `
            -AuthenticationMethodConfigurationId $currentInstance.Id `
            -BodyParameter $UpdateParameters
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Azure AD Authentication Method Policy Fido2 with Id {$($currentInstance.Id)}"
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
        [System.Boolean]
        $IsAttestationEnforced,

        [Parameter()]
        [System.Boolean]
        $IsSelfServiceRegistrationAllowed,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $KeyRestrictions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ExcludeTargets,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $IncludeTargets,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $PasskeyProfiles,

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
            -AuthenticationMethodConfigurationId Fido2 `
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
            if ($null -ne $Results.KeyRestrictions)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.KeyRestrictions `
                    -CIMInstanceName 'MicrosoftGraphFido2KeyRestrictions'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.KeyRestrictions = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('KeyRestrictions') | Out-Null
                }
            }
            if ($null -ne $Results.ExcludeTargets)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.ExcludeTargets `
                    -CIMInstanceName 'AADAuthenticationMethodPolicyFido2ExcludeTarget'
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
                    -CIMInstanceName 'AADAuthenticationMethodPolicyFido2IncludeTarget'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.IncludeTargets = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('IncludeTargets') | Out-Null
                }
            }
            if ($null -ne $Results.PasskeyProfiles)
            {
                $complexMapping = @(
                    @{
                        Name            = 'PasskeyProfiles'
                        CimInstanceName = 'AADAuthenticationMethodPolicyFido2PasskeyProfile'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'KeyRestrictions'
                        CimInstanceName = 'MicrosoftGraphFido2KeyRestrictions'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.PasskeyProfiles `
                    -CIMInstanceName 'AADAuthenticationMethodPolicyFido2PasskeyProfile' `
                    -ComplexTypeMapping $complexMapping `
                    -Whitespace ''
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.PasskeyProfiles = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('PasskeyProfiles') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('KeyRestrictions', 'ExcludeTargets', 'IncludeTargets', 'PasskeyProfiles') `

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
