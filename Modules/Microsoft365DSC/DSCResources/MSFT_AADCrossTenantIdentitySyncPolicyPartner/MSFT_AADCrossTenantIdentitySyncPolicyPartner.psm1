Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADCrossTenantIdentitySyncPolicyPartner'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CrossTenantAccessPolicyConfigurationPartnerTenantId,

        [Parameter(Mandatory = $true)]
        [System.Boolean]
        $IsSyncAllowed,

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

    Write-Verbose -Message "Getting Cross-Tenant Identity Sync Policy for Tenant {$CrossTenantAccessPolicyConfigurationPartnerTenantId}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.TenantId -ne $CrossTenantAccessPolicyConfigurationPartnerTenantId)
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

            $instance = Get-MgBetaPolicyCrossTenantAccessPolicyPartnerIdentitySynchronization `
                -CrossTenantAccessPolicyConfigurationPartnerTenantId $CrossTenantAccessPolicyConfigurationPartnerTenantId `
                -ErrorAction SilentlyContinue

            if ($null -eq $instance)
            {
                Write-Verbose -Message "No AAD Cross Tenant Identity Sync Policy Partner for TenantId {$CrossTenantAccessPolicyConfigurationPartnerTenantId} found."
                return $nullResult
            }
        }
        else
        {
            $instance = $Script:exportedInstance
        }

        $results = @{
            DisplayName                                         = $instance.DisplayName
            CrossTenantAccessPolicyConfigurationPartnerTenantId = $instance.TenantId
            IsSyncAllowed                                       = $instance.userSyncInbound.IsSyncAllowed
            Ensure                                              = 'Present'
            Credential                                          = $Credential
            ApplicationId                                       = $ApplicationId
            TenantId                                            = $TenantId
            CertificateThumbprint                               = $CertificateThumbprint
            CertificatePath                                     = $CertificatePath
            CertificatePassword                                 = $CertificatePassword
            ManagedIdentity                                     = $ManagedIdentity.IsPresent
            AccessTokens                                        = $AccessTokens
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $CrossTenantAccessPolicyConfigurationPartnerTenantId,

        [Parameter(Mandatory = $true)]
        [System.Boolean]
        $IsSyncAllowed,

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

    $currentInstance = Get-TargetResource @PSBoundParameters
    # CREATE
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        $params = @{
            displayName     = $DisplayName
            userSyncInbound = @{
                isSyncAllowed = $IsSyncAllowed
            }
        }
        Write-Verbose -Message "Creating Cross-Tenant Identity Sync Policy for Tenant {$CrossTenantAccessPolicyConfigurationPartnerTenantId} with:`r`n$(ConvertTo-Json $params -Depth 10)"
        Set-MgBetaPolicyCrossTenantAccessPolicyPartnerIdentitySynchronization -BodyParameter $params `
            -CrossTenantAccessPolicyConfigurationPartnerTenantId $CrossTenantAccessPolicyConfigurationPartnerTenantId
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        $params = @{
            displayName     = $DisplayName
            userSyncInbound = @{
                isSyncAllowed = $IsSyncAllowed
            }
        }
        $body = $params | ConvertTo-Json -Depth 10
        Write-Verbose -Message "Updating Cross-Tenant Identity Sync Policy for Tenant {$CrossTenantAccessPolicyConfigurationPartnerTenantId} with:`r`n$body"
        Invoke-MgGraphRequest 'PATCH' `
            -Uri "/beta/policies/crossTenantAccessPolicy/partners/$($CrossTenantAccessPolicyConfigurationPartnerTenantId)/identitySynchronization" `
            -Body $body -ErrorAction Stop | Out-Null
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Cross-Tenant Identity Sync Policy for Tenant {$CrossTenantAccessPolicyConfigurationPartnerTenantId}"
        Remove-MgBetaPolicyCrossTenantAccessPolicyPartnerIdentitySynchronization `
            -CrossTenantAccessPolicyConfigurationPartnerTenantId $CrossTenantAccessPolicyConfigurationPartnerTenantId -ErrorAction Stop
    }
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $CrossTenantAccessPolicyConfigurationPartnerTenantId,

        [Parameter(Mandatory = $true)]
        [System.Boolean]
        $IsSyncAllowed,

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
        $policyPartners = Get-MgBetaPolicyCrossTenantAccessPolicyPartner `
            -All `
            -Filter $Filter `
            -ErrorAction Stop
        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
        if ($policyPartners.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($partner in $policyPartners)
        {
            $config = $null
            try
            {
                $config = Get-MgBetaPolicyCrossTenantAccessPolicyPartnerIdentitySynchronization `
                    -CrossTenantAccessPolicyConfigurationPartnerTenantId $partner.TenantId `
                    -ErrorAction Stop
            }
            catch
            {
                Write-M365DSCHost -Message "    |---[$i/$($policyPartners.Count)] $($partner.TenantId)$Global:M365DSCEmojiRedX" -CommitWrite
                New-M365DSCLogEntry -Message 'Error during Export:' `
                    -Exception $_ `
                    -Source $($MyInvocation.MyCommand.Source) `
                    -TenantId $TenantId `
                    -Credential $Credential
                $i++
                continue
            }

            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.DisplayName
            Write-M365DSCHost -Message "    |---[$i/$($policyPartners.Count)] $displayedKey" -DeferWrite
            $params = @{
                DisplayName                                         = $config.DisplayName
                CrossTenantAccessPolicyConfigurationPartnerTenantId = $partner.TenantId
                IsSyncAllowed                                       = $config.userSyncInbound.IsSyncAllowed
                Ensure                                              = 'Present'
                Credential                                          = $Credential
                ApplicationId                                       = $ApplicationId
                TenantId                                            = $TenantId
                CertificateThumbprint                               = $CertificateThumbprint
                ManagedIdentity                                     = $ManagedIdentity.IsPresent
                AccessTokens                                        = $AccessTokens
            }

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
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
