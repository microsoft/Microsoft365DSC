Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADAuthenticationMethodPolicyExternal'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ExcludeTargets,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $IncludeTargets,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $OpenIdConnectSetting,

        [Parameter()]
        [ValidateSet('enabled', 'disabled')]
        [System.String]
        $State,

        [Parameter()]
        [System.String]
        $AppId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,
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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting the Azure AD Authentication Method Policy External with Id {$DisplayName}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.DisplayName -ne $DisplayName)
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

            if (-not [string]::IsNullOrEmpty($DisplayName))
            {
                $response = Invoke-MgGraphRequest -Method Get -Uri ((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + 'beta/policies/authenticationMethodsPolicy/')
                $getValue = $response.authenticationMethodConfigurations | Where-Object -FilterScript { $_.DisplayName -eq $DisplayName }
            }

            #endregion
            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Azure AD Authentication Method Policy External with DisplayName {$DisplayName}"
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }

        Write-Verbose -Message "An Azure AD Authentication Method Policy External with displayName {$DisplayName} was found."

        #region resource generator code
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

            if ($myExcludeTargets.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexExcludeTargets += $myExcludeTargets
            }
        }
        #endregion

        $complexincludeTargets = @()
        foreach ($currentincludeTargets in $getValue.includeTargets)
        {
            $myincludeTargets = [ordered]@{}
            if ($currentIncludeTargets.id -ne 'all_users')
            {
                $myIncludeTargetsDisplayName = Get-M365DSCGroupDisplayNameById -GroupId $currentIncludeTargets.id
                if ($null -eq $myIncludeTargetsDisplayName)
                {
                    continue
                }
                $myincludeTargets.Add('Id', $myIncludeTargetsDisplayName)
            }
            else
            {
                $myIncludeTargets.Add('Id', $currentIncludeTargets.id)
            }

            if ($null -ne $currentincludeTargets.targetType)
            {
                $myincludeTargets.Add('TargetType', $currentincludeTargets.targetType.ToString())
            }

            if ($myincludeTargets.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexincludeTargets += $myincludeTargets
            }
        }

        $complexOpenIdConnectSetting = @{
            clientId     = $getValue.OpenIdConnectSetting.ClientId
            discoveryUrl = $getValue.OpenIdConnectSetting.DiscoveryUrl
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
            ExcludeTargets        = $complexExcludeTargets
            IncludeTargets        = $complexincludeTargets
            OpenIdConnectSetting  = $complexOpenIdConnectSetting
            State                 = $enumState
            AppId                 = $getValue.appId
            DisplayName           = $getValue.displayName
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
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
        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ExcludeTargets,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $IncludeTargets,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $OpenIdConnectSetting,

        [Parameter()]
        [ValidateSet('enabled', 'disabled')]
        [System.String]
        $State,

        [Parameter()]
        [System.String]
        $AppId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting the Azure AD Authentication Method Policy External with Id {$DisplayName}"

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

    $params = ([Hashtable]$BoundParameters).Clone()
    $params = Rename-M365DSCCimInstanceParameter -Properties $params

    Update-M365DSCAuthenticationTargets -Targets $params.ExcludeTargets
    Update-M365DSCAuthenticationTargets -Targets $params.IncludeTargets

    $params.Add('@odata.type', '#microsoft.graph.externalAuthenticationMethodConfiguration')

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating the Azure AD Authentication Method Policy External with name {$DisplayName}"
        $null = New-MgBetaPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -BodyParameter $params
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Azure AD Authentication Method Policy External with name {$($currentInstance.displayName)}"
        $response = Invoke-MgGraphRequest -Method Get -Uri ((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + 'beta/policies/authenticationMethodsPolicy/')
        $getValue = $response.authenticationMethodConfigurations | Where-Object -FilterScript { $_.displayName -eq $currentInstance.displayName }

        $params.Remove('displayName') | Out-Null
        Update-MgBetaPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration `
            -AuthenticationMethodConfigurationId $getValue.Id `
            -BodyParameter $params
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Azure AD Authentication Method Policy External with Id {$($currentInstance.displayName)}"
        $response = Invoke-MgGraphRequest -Method Get -Uri ((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + 'beta/policies/authenticationMethodsPolicy/')
        $getValue = $response.authenticationMethodConfigurations | Where-Object -FilterScript { $_.displayName -eq $currentInstance.displayName }
        Remove-MgBetaPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -AuthenticationMethodConfigurationId $getValue.Id
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        #region resource generator code
        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ExcludeTargets,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $IncludeTargets,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $OpenIdConnectSetting,

        [Parameter()]
        [ValidateSet('enabled', 'disabled')]
        [System.String]
        $State,

        [Parameter()]
        [System.String]
        $AppId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

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
        $desiredType = '#microsoft.graph.externalAuthenticationMethodConfiguration'
        $getPolicy = Invoke-MgGraphRequest -Method Get -Uri ((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + 'beta/policies/authenticationMethodsPolicy/')
        $getValue = $getPolicy.AuthenticationMethodConfigurations | Where-Object -FilterScript { $_.'@odata.type' -eq $desiredType }
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
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.displayName

            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                DisplayName           = $config.displayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params
            if ($null -ne $Results.ExcludeTargets)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.ExcludeTargets `
                    -CIMInstanceName 'AADAuthenticationMethodPolicyExternalExcludeTarget'
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
                    -CIMInstanceName 'AADAuthenticationMethodPolicyExternalIncludeTarget'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.IncludeTargets = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('IncludeTargets') | Out-Null
                }
            }

            if ($null -ne $Results.OpenIdConnectSetting)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.OpenIdConnectSetting `
                    -CIMInstanceName 'AADAuthenticationMethodPolicyExternalOpenIdConnectSetting'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.OpenIdConnectSetting = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('OpenIdConnectSetting') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('ExcludeTargets', 'IncludeTargets', 'OpenIdConnectSetting')

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
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

Export-ModuleMember -Function *-TargetResource
