Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADAuthenticationMethodPolicyX509'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AuthenticationModeConfiguration,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CertificateUserBindings,

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

        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
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

    Write-Verbose -Message "Getting the Azure AD Authentication Method Policy X509 with Id {$Id}"

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
                Write-Verbose -Message "Could not find an Azure AD Authentication Method Policy X509 with id {$id}"
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Azure AD Authentication Method Policy X509 with Id {$Id} was found."

        #region resource generator code
        $complexAuthenticationModeConfiguration = [ordered]@{}
        $complexRules = @()
        if ($getValue.AdditionalProperties.authenticationModeConfiguration.rules.Length -ne 0)
        {
            foreach ($currentRules in $getValue.AdditionalProperties.authenticationModeConfiguration.rules)
            {
                $myRules = [ordered]@{}
                $myRules.Add('Identifier', $currentRules.identifier)
                if ($null -ne $currentRules.x509CertificateAuthenticationMode)
                {
                    $myRules.Add('X509CertificateAuthenticationMode', $currentRules.x509CertificateAuthenticationMode.ToString())
                }
                if ($null -ne $currentRules.x509CertificateRuleType)
                {
                    $myRules.Add('X509CertificateRuleType', $currentRules.x509CertificateRuleType.ToString())
                }
                if ($myRules.values.Where({ $null -ne $_ }).Count -gt 0 -and $myRules.Keys.Length -gt 0)
                {
                    $complexRules += $myRules
                }
                if ($complexRules.Length -le 0)
                {
                    $complexRules = $null
                }
                $complexAuthenticationModeConfiguration.Add('Rules', $complexRules)
            }
        }
        else
        {
            $complexAuthenticationModeConfiguration.Add('Rules', @())
        }

        if ($null -ne $getValue.AdditionalProperties.authenticationModeConfiguration.x509CertificateAuthenticationDefaultMode)
        {
            $complexAuthenticationModeConfiguration.Add('X509CertificateAuthenticationDefaultMode', $getValue.AdditionalProperties.authenticationModeConfiguration.x509CertificateAuthenticationDefaultMode.ToString())
        }
        if ($complexAuthenticationModeConfiguration.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexAuthenticationModeConfiguration = $null
        }

        $complexCertificateUserBindings = @()
        foreach ($currentcertificateUserBindings in $getValue.AdditionalProperties.certificateUserBindings)
        {
            $mycertificateUserBindings = [ordered]@{}
            $mycertificateUserBindings.Add('Priority', $currentcertificateUserBindings.priority)
            $mycertificateUserBindings.Add('UserProperty', $currentcertificateUserBindings.userProperty)
            $mycertificateUserBindings.Add('X509CertificateField', $currentcertificateUserBindings.x509CertificateField)
            if ($mycertificateUserBindings.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexCertificateUserBindings += $mycertificateUserBindings
            }
        }

        Write-Verbose 'Processing ExcludeTargets'
        $complexExcludeTargets = @()
        foreach ($currentExcludeTargets in $getValue.excludeTargets)
        {
            $myExcludeTargets = [ordered]@{}
            if ($currentExcludeTargets.id -ne 'all_users')
            {
                try
                {
                    $myExcludeTargetsDisplayName = Get-MgGroup -GroupId $currentExcludeTargets.id -ErrorAction Stop
                    $myExcludeTargets.Add('Id', $myExcludeTargetsDisplayName.DisplayName)
                }
                catch
                {
                    $message = "Could not find a group with id $($currentExcludeTargets.id) specified in ExcludeTargets. Skipping group!"
                    New-M365DSCLogEntry -Message $message `
                        -Exception $_ `
                        -Source $($MyInvocation.MyCommand.Source) `
                        -TenantId $TenantId `
                        -Credential $Credential
                    continue
                }
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

        Write-Verbose 'Processing IncludeTargets'
        $complexIncludeTargets = @()
        foreach ($currentIncludeTargets in $getValue.AdditionalProperties.includeTargets)
        {
            $myIncludeTargets = [ordered]@{}
            if ($currentIncludeTargets.id -ne 'all_users')
            {
                try
                {
                    $myIncludeTargetsDisplayName = Get-MgGroup -GroupId $currentIncludeTargets.id -ErrorAction Stop
                    $myIncludeTargets.Add('Id', $myIncludeTargetsDisplayName.DisplayName)
                }
                catch
                {
                    $message = "Could not find a group with id $($currentIncludeTargets.id) specified in IncludeTargets. Skipping group!"
                    New-M365DSCLogEntry -Message $message `
                        -Exception $_ `
                        -Source $($MyInvocation.MyCommand.Source) `
                        -TenantId $TenantId `
                        -Credential $Credential
                    continue
                }
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
                $myIncludeTargets.Add('isRegistrationRequired', [Boolean]$currentIncludeTargets.isRegistrationRequired)
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
            AuthenticationModeConfiguration = $complexAuthenticationModeConfiguration
            CertificateUserBindings         = $complexCertificateUserBindings
            ExcludeTargets                  = $complexExcludeTargets
            IncludeTargets                  = $complexIncludeTargets
            State                           = $enumState
            Id                              = $getValue.Id
            Ensure                          = 'Present'
            Credential                      = $Credential
            ApplicationId                   = $ApplicationId
            TenantId                        = $TenantId
            ApplicationSecret               = $ApplicationSecret
            CertificateThumbprint           = $CertificateThumbprint
            ManagedIdentity                 = $ManagedIdentity.IsPresent
            AccessTokens                    = $AccessTokens
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
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AuthenticationModeConfiguration,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CertificateUserBindings,

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
        [System.String]
        [ValidateSet('Absent', 'Present')]
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

    Write-Verbose -Message "Setting the Azure AD Authentication Method Policy X509 with Id {$Id}"

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
        Write-Verbose -Message "Updating the Azure AD Authentication Method Policy X509 with Id {$($currentInstance.Id)}"

        $UpdateParameters = ([Hashtable]$BoundParameters).Clone()
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters

        $UpdateParameters.Remove('Id') | Out-Null

        $keys = (([Hashtable]$UpdateParameters).Clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $UpdateParameters.$key -and $UpdateParameters.$key.GetType().Name -like '*cimInstance*')
            {
                $UpdateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $UpdateParameters.$key
            }
            if ($key -eq 'ExcludeTargets' -or $key -eq 'IncludeTargets')
            {
                $i = 0
                foreach ($entry in $UpdateParameters.$key)
                {
                    if ($entry.id -notmatch '^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$|all_users')
                    {
                        $Filter = "DisplayName eq '$($entry.id -replace "'", "''")'"
                        Write-Verbose -Message "Retrieving {$key} Group with DisplayName {$($entry.id)}"
                        $GroupInstance = Get-MgGroup -Filter $Filter -ErrorAction SilentlyContinue
                        if ($null -ne $GroupInstance)
                        {
                            Write-Verbose -Message "Found {$key} Group {$($GroupInstance.id.ToString())}"
                            $UpdateParameters.$key[$i].id = $GroupInstance.id.ToString()
                        }
                    }
                    $i++
                }
            }
        }
        #region resource generator code
        $UpdateParameters.Add('@odata.type', '#microsoft.graph.x509CertificateAuthenticationMethodConfiguration')
        Write-Verbose -Message "Updating with Values: $(Convert-M365DscHashtableToString -Hashtable $UpdateParameters)"
        Update-MgBetaPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration `
            -AuthenticationMethodConfigurationId $currentInstance.Id `
            -BodyParameter $UpdateParameters
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Azure AD Authentication Method Policy X509 with Id {$($currentInstance.Id)}"
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
        $AuthenticationModeConfiguration,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CertificateUserBindings,

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
        [System.String]
        [ValidateSet('Absent', 'Present')]
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
        [array]$getValue = Get-MgBetaPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration `
            -AuthenticationMethodConfigurationId X509Certificate `
            -ErrorAction Stop | Where-Object -FilterScript { $null -ne $_.Id }
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
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params
            if ($null -ne $Results.AuthenticationModeConfiguration)
            {
                $complexMapping = @(
                    @{
                        Name            = 'AuthenticationModeConfiguration'
                        CimInstanceName = 'MicrosoftGraphX509CertificateAuthenticationModeConfiguration'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'Rules'
                        CimInstanceName = 'MicrosoftGraphX509CertificateRule'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.AuthenticationModeConfiguration `
                    -CIMInstanceName 'MicrosoftGraphx509CertificateAuthenticationModeConfiguration' `
                    -ComplexTypeMapping $complexMapping

                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.AuthenticationModeConfiguration = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('AuthenticationModeConfiguration') | Out-Null
                }
            }
            if ($null -ne $Results.CertificateUserBindings)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.CertificateUserBindings `
                    -CIMInstanceName 'MicrosoftGraphx509CertificateUserBinding'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.CertificateUserBindings = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('CertificateUserBindings') | Out-Null
                }
            }
            if ($null -ne $Results.ExcludeTargets)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.ExcludeTargets `
                    -CIMInstanceName 'AADAuthenticationMethodPolicyX509ExcludeTarget'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
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
                    -CIMInstanceName 'AADAuthenticationMethodPolicyX509IncludeTarget'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
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
                -NoEscape @('AuthenticationModeConfiguration', 'CertificateUserBindings', 'ExcludeTargets', 'IncludeTargets')

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
