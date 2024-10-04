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
        [ValidateSet('IMAP')]
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

    New-M365DSCConnection -Workload 'ExchangeOnline' `
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
            $migrationEndpoint = $Script:exportedInstances | Where-Object -FilterScript {$_.Identity -eq $Identity}
        }
        else
        {
            $migrationEndpoint = Get-MigrationEndpoint -Identity $Identity -ErrorAction Stop
        }
        if ($null -eq $migrationEndpoint)
        {
            return $nullResult
        }

        $results = @{
            Identity                       = $Identity
            AcceptUntrustedCertificates    = $migrationEndpoint.AcceptUntrustedCertificates
            AppID                          = $migrationEndpoint.AppID
            AppSecretKeyVaultUrl           = $migrationEndpoint.AppSecretKeyVaultUrl
            Authentication                 = $migrationEndpoint.Authentication
            EndpointType                   = $migrationEndpoint.EndpointType
            ExchangeServer                 = $migrationEndpoint.ExchangeServer
            MailboxPermission              = $migrationEndpoint.MailboxPermission
            MaxConcurrentIncrementalSyncs  = $migrationEndpoint.MaxConcurrentIncrementalSyncs
            MaxConcurrentMigrations        = $migrationEndpoint.MaxConcurrentMigrations
            NspiServer                     = $migrationEndpoint.NspiServer
            Port                           = $migrationEndpoint.Port
            RemoteServer                   = $migrationEndpoint.RemoteServer
            RemoteTenant                   = $migrationEndpoint.RemoteTenant
            RpcProxyServer                 = $migrationEndpoint.RpcProxyServer
            Security                       = $migrationEndpoint.Security
            SourceMailboxLegacyDN          = $migrationEndpoint.SourceMailboxLegacyDN
            UseAutoDiscover                = $migrationEndpoint.UseAutoDiscover
            Ensure                         = 'Present'
            Credential                     = $Credential
            ApplicationId                  = $ApplicationId
            TenantId                       = $TenantId
            CertificateThumbprint          = $CertificateThumbprint
            ManagedIdentity                = $ManagedIdentity.IsPresent
            AccessTokens                   = $AccessTokens
        }

        return [System.Collections.Hashtable] $results
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
        [ValidateSet('IMAP')]
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

    $setParams = [System.Collections.Hashtable]($PSBoundParameters)
    $setParams = Remove-M365DSCAuthenticationParameter -BoundParameters $setParams
    $setParams.Remove('RemoteTenant')
    $setParams.Remove('EndpointType')
    $setParams.Remove('UseAutoDiscover')
    $setParams.Add('Confirm', $false)

    $newParams = [System.Collections.Hashtable]($PSBoundParameters)
    $newParams = Remove-M365DSCAuthenticationParameter -BoundParameters $newParams
    $newParams.Remove('EndpointType')
    $newParams.Remove('Identity')
    $newParams.Add('Name', $Identity)
    $newParams.Add('Confirm', [Switch]$false)

    if ($EndpointType -eq "IMAP")
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

    # add the logic for other endpoint types ('Exchange Remote', 'Outlook Anywhere', 'Google Workspace')

    # CREATE
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        New-MigrationEndpoint @newParams
    }
    # UPDATE
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Set-MigrationEndpoint @setParams
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
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
        [ValidateSet('IMAP')]
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

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $testResult"

    return $testResult
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
        $Script:ExportMode = $true
        [array] $Script:exportedInstances = Get-MigrationEndpoint -ErrorAction Stop

        $i = 1
        $dscContent = ''
        if ($Script:exportedInstances.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($config in $Script:exportedInstances)
        {
            $displayedKey = $config.Identity
            Write-Host "    |---[$i/$($Script:exportedInstances.Count)] $displayedKey" -NoNewline
            $params = @{
                Identity              = $config.Identity
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

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
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
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
