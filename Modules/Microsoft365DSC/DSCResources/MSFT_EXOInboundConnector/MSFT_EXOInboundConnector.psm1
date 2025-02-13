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
        [System.String[]]
        $AssociatedAcceptedDomains = @(),

        [Parameter()]
        [System.Boolean]
        $CloudServicesMailEnabled,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [ValidateSet('Default', 'Migrated', 'HybridWizard')]
        [System.String]
        $ConnectorSource,

        [Parameter()]
        [ValidateSet('OnPremises', 'Partner')]
        [System.String]
        $ConnectorType,

        [Parameter()]
        [System.String[]]
        $EFSkipIPs = @(),

        [Parameter()]
        [System.Boolean]
        $EFSkipLastIP,

        [Parameter()]
        [System.String[]]
        $EFUsers = @(),

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.Boolean]
        $RequireTls,

        [Parameter()]
        [System.Boolean]
        $RestrictDomainsToCertificate,

        [Parameter()]
        [System.Boolean]
        $RestrictDomainsToIPAddresses,

        [Parameter()]
        [System.String[]]
        $SenderDomains = @(),

        [Parameter()]
        [System.String[]]
        $SenderIPAddresses = @(),

        [Parameter()]
        [System.String]
        $TlsSenderCertificateName,

        [Parameter()]
        [System.Boolean]
        $TreatMessagesAsInternal,

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
    Write-Verbose -Message "Getting configuration of InboundConnector for $($Identity)"

    if ($Global:CurrentModeIsExport)
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters `
            -SkipModuleReload $true
    }
    else
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters
    }

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'

    try
    {
        $InboundConnectors = Get-InboundConnector -ErrorAction Stop

        $InboundConnector = $InboundConnectors | Where-Object -FilterScript { $_.Identity -eq $Identity }
        if ($null -eq $InboundConnector)
        {
            Write-Verbose -Message "InboundConnector $($Identity) does not exist."
            return $nullReturn
        }
        else
        {
            $ConnectorSourceValue = $InboundConnector.ConnectorSource
            if ($ConnectorSourceValue -eq 'AdminUI')
            {
                $ConnectorSourceValue = 'Default'
            }
            $result = @{
                Identity                     = $Identity
                AssociatedAcceptedDomains    = $InboundConnector.AssociatedAcceptedDomains
                CloudServicesMailEnabled     = $InboundConnector.CloudServicesMailEnabled
                Comment                      = $InboundConnector.Comment
                ConnectorSource              = $ConnectorSourceValue
                ConnectorType                = $InboundConnector.ConnectorType
                EFSkipIPs                    = $InboundConnector.EFSkipIPs
                EFSkipLastIP                 = $InboundConnector.EFSkipLastIP
                EFUsers                      = $InboundConnector.EFUsers
                Enabled                      = $InboundConnector.Enabled
                RequireTls                   = $InboundConnector.RequireTls
                RestrictDomainsToCertificate = $InboundConnector.RestrictDomainsToCertificate
                RestrictDomainsToIPAddresses = $InboundConnector.RestrictDomainsToIPAddresses
                SenderDomains                = $InboundConnector.SenderDomains
                SenderIPAddresses            = $InboundConnector.SenderIPAddresses
                TlsSenderCertificateName     = $InboundConnector.TlsSenderCertificateName
                TreatMessagesAsInternal      = $InboundConnector.TreatMessagesAsInternal
                Credential                   = $Credential
                Ensure                       = 'Present'
                ApplicationId                = $ApplicationId
                CertificateThumbprint        = $CertificateThumbprint
                CertificatePath              = $CertificatePath
                CertificatePassword          = $CertificatePassword
                Managedidentity              = $ManagedIdentity.IsPresent
                TenantId                     = $TenantId
                AccessTokens                 = $AccessTokens
            }

            Write-Verbose -Message "Found InboundConnector $($Identity)"
            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
            return $result
        }
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $nullReturn
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
        [System.String[]]
        $AssociatedAcceptedDomains = @(),

        [Parameter()]
        [System.Boolean]
        $CloudServicesMailEnabled,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [ValidateSet('Default', 'Migrated', 'HybridWizard')]
        [System.String]
        $ConnectorSource,

        [Parameter()]
        [ValidateSet('OnPremises', 'Partner')]
        [System.String]
        $ConnectorType,

        [Parameter()]
        [System.String[]]
        $EFSkipIPs = @(),

        [Parameter()]
        [System.Boolean]
        $EFSkipLastIP,

        [Parameter()]
        [System.String[]]
        $EFUsers = @(),

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.Boolean]
        $RequireTls,

        [Parameter()]
        [System.Boolean]
        $RestrictDomainsToCertificate,

        [Parameter()]
        [System.Boolean]
        $RestrictDomainsToIPAddresses,

        [Parameter()]
        [System.String[]]
        $SenderDomains = @(),

        [Parameter()]
        [System.String[]]
        $SenderIPAddresses = @(),

        [Parameter()]
        [System.String]
        $TlsSenderCertificateName,

        [Parameter()]
        [System.Boolean]
        $TreatMessagesAsInternal,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Setting configuration of InboundConnector for $($Identity)"

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $InboundConnectors = Get-InboundConnector
    $InboundConnector = $InboundConnectors | Where-Object -FilterScript { $_.Identity -eq $Identity }
    $InboundConnectorParams = [System.Collections.Hashtable]($PSBoundParameters)
    $InboundConnectorParams.Remove('Ensure') | Out-Null
    $InboundConnectorParams.Remove('Credential') | Out-Null
    $InboundConnectorParams.Remove('ApplicationId') | Out-Null
    $InboundConnectorParams.Remove('TenantId') | Out-Null
    $InboundConnectorParams.Remove('CertificateThumbprint') | Out-Null
    $InboundConnectorParams.Remove('CertificatePath') | Out-Null
    $InboundConnectorParams.Remove('CertificatePassword') | Out-Null
    $InboundConnectorParams.Remove('ManagedIdentity') | Out-Null
    $InboundConnectorParams.Remove('AccessTokens') | Out-Null

    if (('Present' -eq $Ensure ) -and ($null -eq $InboundConnector))
    {
        Write-Verbose -Message "Creating InboundConnector $($Identity)."
        $InboundConnectorParams.Add('Name', $Identity)
        $InboundConnectorParams.Remove('Identity') | Out-Null
        New-InboundConnector @InboundConnectorParams
    }
    elseif (('Present' -eq $Ensure ) -and ($Null -ne $InboundConnector))
    {
        Write-Verbose -Message "Setting InboundConnector $($Identity) with values: $(Convert-M365DscHashtableToString -Hashtable $InboundConnectorParams)"
        Set-InboundConnector @InboundConnectorParams -Confirm:$false
    }
    elseif (('Absent' -eq $Ensure ) -and ($null -ne $InboundConnector))
    {
        Write-Verbose -Message "Removing InboundConnector $($Identity)"
        Remove-InboundConnector -Identity $Identity -Confirm:$false
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
        [System.String[]]
        $AssociatedAcceptedDomains = @(),

        [Parameter()]
        [System.Boolean]
        $CloudServicesMailEnabled,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [ValidateSet('Default', 'Migrated', 'HybridWizard')]
        [System.String]
        $ConnectorSource,

        [Parameter()]
        [ValidateSet('OnPremises', 'Partner')]
        [System.String]
        $ConnectorType,

        [Parameter()]
        [System.String[]]
        $EFSkipIPs = @(),

        [Parameter()]
        [System.Boolean]
        $EFSkipLastIP,

        [Parameter()]
        [System.String[]]
        $EFUsers = @(),

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.Boolean]
        $RequireTls,

        [Parameter()]
        [System.Boolean]
        $RestrictDomainsToCertificate,

        [Parameter()]
        [System.Boolean]
        $RestrictDomainsToIPAddresses,

        [Parameter()]
        [System.String[]]
        $SenderDomains = @(),

        [Parameter()]
        [System.String[]]
        $SenderIPAddresses = @(),

        [Parameter()]
        [System.String]
        $TlsSenderCertificateName,

        [Parameter()]
        [System.Boolean]
        $TreatMessagesAsInternal,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of InboundConnector for $($Identity)"

    #check syntax of SenderDomains parameter
    $senderDomains = @()
    foreach ($domain in $PSBoundParameters.SenderDomains)
    {
        if ($domain -notlike 'smtp:*')
        {
            $senderDomains += 'smtp:' + $domain + ';1'
        }
        else
        {
            $senderDomains += $domain
        }
    }

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    if ($senderDomains.Length -gt 0)
    {
        $ValuesToCheck.SenderDomains = $senderDomains
    }

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $($TestResult)"

    return $TestResult
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
    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    try
    {
        [array]$InboundConnectors = Get-InboundConnector -ErrorAction Stop
        $dscContent = ''

        if ($InboundConnectors.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        $i = 1
        foreach ($InboundConnector in $InboundConnectors)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-Host "    |---[$i/$($InboundConnectors.Length)] $($InboundConnector.Identity)" -NoNewline

            $Params = @{
                Identity              = $InboundConnector.Identity
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                Managedidentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
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
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
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
