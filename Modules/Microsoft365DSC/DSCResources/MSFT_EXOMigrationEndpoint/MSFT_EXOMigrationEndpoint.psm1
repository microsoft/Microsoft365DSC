Confirm-M365DSCModuleDependency -ModuleName 'MSFT_EXOMigrationEndpoint'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $AcceptUntrustedCertificates,

        [Parameter()]
        [System.String]
        $AppID,

        [Parameter()]
        [System.String]
        $AppSecretKeyVaultUrl,

        [Parameter()]
        [System.String]
        $Authentication,

        [Parameter()]
        [ValidateSet('IMAP', 'ExchangeRemoteMove')]
        [System.String]
        $EndpointType,

        [Parameter()]
        [System.String]
        $ExchangeServer,

        [Parameter()]
        [System.String]
        $MailboxPermission,

        [Parameter()]
        [System.String]
        $MaxConcurrentIncrementalSyncs,

        [Parameter()]
        [System.String]
        $MaxConcurrentMigrations,

        [Parameter()]
        [System.String]
        $NspiServer,

        [Parameter()]
        [System.String]
        $Port,

        [Parameter()]
        [System.String]
        $RemoteServer,

        [Parameter()]
        [System.String]
        $RemoteTenant,

        [Parameter()]
        [System.String]
        $RpcProxyServer,

        [Parameter()]
        [ValidateSet('None', 'Tls', 'Ssl')]
        [System.String]
        $Security,

        [Parameter()]
        [System.String]
        $SourceMailboxLegacyDN,

        [Parameter()]
        [System.String]
        $UseAutoDiscover,

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

    Write-Verbose -Message "Getting Migration Endpoint configuration for $Identity"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Identity -ne $Identity)
        {
            $null = New-M365DSCConnection -Workload 'ExchangeOnline' `
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

            $migrationEndpoint = Get-MigrationEndpoint -Identity $Identity -ErrorAction SilentlyContinue
            if ($null -eq $migrationEndpoint)
            {
                Write-Verbose -Message "Migration Endpoint with Identity $Identity not found"
                return $nullResult
            }
        }
        else
        {
            $migrationEndpoint = $Script:exportedInstance
        }

        Write-Verbose -Message "Migration Endpoint with Identity $($migrationEndpoint.Identity) found."

        $results = @{
            Identity                      = $Identity
            AcceptUntrustedCertificates   = $migrationEndpoint.AcceptUntrustedCertificates
            AppID                         = $migrationEndpoint.AppID
            AppSecretKeyVaultUrl          = $migrationEndpoint.AppSecretKeyVaultUrl
            Authentication                = $migrationEndpoint.Authentication
            EndpointType                  = $migrationEndpoint.EndpointType
            ExchangeServer                = $migrationEndpoint.ExchangeServer
            MailboxPermission             = $migrationEndpoint.MailboxPermission
            MaxConcurrentIncrementalSyncs = $migrationEndpoint.MaxConcurrentIncrementalSyncs
            MaxConcurrentMigrations       = $migrationEndpoint.MaxConcurrentMigrations
            NspiServer                    = $migrationEndpoint.NspiServer
            Port                          = $migrationEndpoint.Port
            RemoteServer                  = $migrationEndpoint.RemoteServer
            RemoteTenant                  = $migrationEndpoint.RemoteTenant
            RpcProxyServer                = $migrationEndpoint.RpcProxyServer
            Security                      = $migrationEndpoint.Security
            SourceMailboxLegacyDN         = $migrationEndpoint.SourceMailboxLegacyDN
            UseAutoDiscover               = $migrationEndpoint.UseAutoDiscover
            Ensure                        = 'Present'
            Credential                    = $Credential
            ApplicationId                 = $ApplicationId
            TenantId                      = $TenantId
            CertificateThumbprint         = $CertificateThumbprint
            ManagedIdentity               = $ManagedIdentity.IsPresent
            AccessTokens                  = $AccessTokens
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
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $AcceptUntrustedCertificates,

        [Parameter()]
        [System.String]
        $AppID,

        [Parameter()]
        [System.String]
        $AppSecretKeyVaultUrl,

        [Parameter()]
        [System.String]
        $Authentication,

        [Parameter()]
        [ValidateSet('IMAP', 'ExchangeRemoteMove')]
        [System.String]
        $EndpointType,

        [Parameter()]
        [System.String]
        $ExchangeServer,

        [Parameter()]
        [System.String]
        $MailboxPermission,

        [Parameter()]
        [System.String]
        $MaxConcurrentIncrementalSyncs,

        [Parameter()]
        [System.String]
        $MaxConcurrentMigrations,

        [Parameter()]
        [System.String]
        $NspiServer,

        [Parameter()]
        [System.String]
        $Port,

        [Parameter()]
        [System.String]
        $RemoteServer,

        [Parameter()]
        [System.String]
        $RemoteTenant,

        [Parameter()]
        [System.String]
        $RpcProxyServer,

        [Parameter()]
        [ValidateSet('None', 'Tls', 'Ssl')]
        [System.String]
        $Security,

        [Parameter()]
        [System.String]
        $SourceMailboxLegacyDN,

        [Parameter()]
        [System.String]
        $UseAutoDiscover,

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

    Write-Verbose -Message "Setting Migration Endpoint configuration for $Identity"

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

    $setParams = ([Hashtable]$PSBoundParameters).Clone()
    $setParams = Remove-M365DSCAuthenticationParameter -BoundParameters $setParams
    $setParams.Remove('RemoteTenant')
    $setParams.Remove('EndpointType')
    $setParams.Remove('UseAutoDiscover')
    $setParams.Add('Confirm', $false)

    $newParams = ([Hashtable]$PSBoundParameters).Clone()
    $newParams = Remove-M365DSCAuthenticationParameter -BoundParameters $newParams
    $newParams.Remove('EndpointType')
    $newParams.Remove('Identity')
    $newParams.Add('Name', $Identity)
    $newParams.Add('Confirm', [Switch]$false)

    if ($EndpointType -eq 'IMAP')
    {
        # Removing mailbox permission parameter as this is valid only for outlook anywhere migration
        $setParams.Remove('MailboxPermission')
        $newParams.Remove('MailboxPermission')

        # adding skip verification switch to skip verifying
        # that the remote server is reachable when creating a migration endpoint.
        $setParams.Add('SkipVerification', [Switch]$true)
        $newParams.Add('SkipVerification', [Switch]$true)

        $newParams.Add('IMAP', [Switch]$true)
    }
    elseif ($EndpointType -eq 'ExchangeRemoteMove')
    {
        # Removing mailbox permission parameter as this is valid only for outlook anywhere migration
        $setParams.Remove('MailboxPermission') | Out-Null
        $newParams.Remove('MailboxPermission') | Out-Null
        $newParams.Remove("AcceptUntrustedCertificates") | Out-Null
        $setParams.Remove("AcceptUntrustedCertificates") | Out-Null

        # adding skip verification switch to skip verifying
        # that the remote server is reachable when creating a migration endpoint.
        $setParams.Add('SkipVerification', [Switch]$true)
        $newParams.Add('SkipVerification', [Switch]$true)

        $newParams.Add('ExchangeRemoteMove', [Switch]$true)
    }

    # add the logic for other endpoint types ('Exchange Remote', 'Outlook Anywhere', 'Google Workspace')

    # CREATE
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new migration endpoint with parameters:`r`n$(ConvertTo-Json $newParams -Depth 10)"
        New-MigrationEndpoint @newParams
    }
    # UPDATE
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating migration endpoint with parameters:`r`n$(ConvertTo-Json $setParams -Depth 10)"
        Set-MigrationEndpoint @setParams
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing migration endpoint with id {$Identity}"
        Remove-MigrationEndpoint -Identity $Identity
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
        $Identity,

        [Parameter()]
        [System.Boolean]
        $AcceptUntrustedCertificates,

        [Parameter()]
        [System.String]
        $AppID,

        [Parameter()]
        [System.String]
        $AppSecretKeyVaultUrl,

        [Parameter()]
        [System.String]
        $Authentication,

        [Parameter()]
        [ValidateSet('IMAP', 'ExchangeRemoteMove')]
        [System.String]
        $EndpointType,

        [Parameter()]
        [System.String]
        $ExchangeServer,

        [Parameter()]
        [System.String]
        $MailboxPermission,

        [Parameter()]
        [System.String]
        $MaxConcurrentIncrementalSyncs,

        [Parameter()]
        [System.String]
        $MaxConcurrentMigrations,

        [Parameter()]
        [System.String]
        $NspiServer,

        [Parameter()]
        [System.String]
        $Port,

        [Parameter()]
        [System.String]
        $RemoteServer,

        [Parameter()]
        [System.String]
        $RemoteTenant,

        [Parameter()]
        [System.String]
        $RpcProxyServer,

        [Parameter()]
        [ValidateSet('None', 'Tls', 'Ssl')]
        [System.String]
        $Security,

        [Parameter()]
        [System.String]
        $SourceMailboxLegacyDN,

        [Parameter()]
        [System.String]
        $UseAutoDiscover,

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

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
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
        [array] $migrationEndpoints = Get-MigrationEndpoint -ErrorAction Stop

        $i = 1
        $dscContent = ''
        if ($migrationEndpoints.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($config in $migrationEndpoints)
        {
            $displayedKey = $config.Identity
            Write-M365DSCHost -Message "    |---[$i/$($migrationEndpoints.Count)] $displayedKey" -DeferWrite
            $params = @{
                Identity              = $config.Identity
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }
            $Script:exportedInstance = $config
            $Results = Get-TargetResource @params
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
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
