Confirm-M365DSCModuleDependency -ModuleName 'MSFT_EXOOutboundConnector'

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
        $AllAcceptedDomains,

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
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.Boolean]
        $IsTransportRuleScoped,

        [Parameter()]
        [System.String[]]
        $RecipientDomains = @(),

        [Parameter()]
        [System.Boolean]
        $RouteAllMessagesViaOnPremises,

        [Parameter()]
        [System.Boolean]
        $SenderRewritingEnabled,

        [Parameter()]
        [System.String[]]
        $SmartHosts = @(),

        [Parameter()]
        [System.Boolean]
        $TestMode,

        [Parameter()]
        [System.String]
        $TlsDomain,

        [Parameter()]
        [ValidateSet('EncryptionOnly', 'CertificateValidation', 'DomainValidation')]
        [System.String]
        $TlsSettings,

        [Parameter()]
        [System.Boolean]
        $UseMxRecord,

        [Parameter()]
        [System.String[]]
        $ValidationRecipients = @(),

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

    Write-Verbose -Message "Getting configuration of OutBoundConnector for $($Identity)"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Identity -ne $Identity)
        {
            $null = New-M365DSCConnection -Workload 'ExchangeOnline' `
                -InboundParameters $PSBoundParameters

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

            $OutBoundConnector = Get-OutBoundConnector -Identity $Identity -IncludeTestModeConnectors:$true -ErrorAction SilentlyContinue
            if ($null -eq $OutBoundConnector)
            {
                Write-Verbose -Message "OutBoundConnector $($Identity) does not exist."
                return $nullReturn
            }
        }
        else
        {
            $OutBoundConnector = $Script:exportedInstance
        }

        Write-Verbose -Message "OutBoundConnector with Identity $($OutBoundConnector.Identity) found"

        $ConnectorSourceValue = $OutBoundConnector.ConnectorSource
        if ($ConnectorSourceValue -eq 'AdminUI' -or `
                [System.String]::IsNullOrEmpty($ConnectorSourceValue))
        {
            $ConnectorSourceValue = 'Default'
        }

        $result = @{
            Identity                      = $Identity
            AllAcceptedDomains            = $OutBoundConnector.AllAcceptedDomains
            CloudServicesMailEnabled      = $OutBoundConnector.CloudServicesMailEnabled
            Comment                       = $OutBoundConnector.Comment
            ConnectorSource               = $ConnectorSourceValue
            ConnectorType                 = $OutBoundConnector.ConnectorType
            Enabled                       = $OutBoundConnector.Enabled
            IsTransportRuleScoped         = $OutBoundConnector.IsTransportRuleScoped
            RecipientDomains              = $OutBoundConnector.RecipientDomains
            RouteAllMessagesViaOnPremises = $OutBoundConnector.RouteAllMessagesViaOnPremises
            SenderRewritingEnabled        = $OutBoundConnector.SenderRewritingEnabled
            SmartHosts                    = $OutBoundConnector.SmartHosts
            TestMode                      = $OutBoundConnector.TestMode
            TlsDomain                     = $OutBoundConnector.TlsDomain
            TlsSettings                   = $OutBoundConnector.TlsSettings
            UseMxRecord                   = $OutBoundConnector.UseMxRecord
            ValidationRecipients          = $OutBoundConnector.ValidationRecipients
            Credential                    = $Credential
            Ensure                        = 'Present'
            ApplicationId                 = $ApplicationId
            CertificateThumbprint         = $CertificateThumbprint
            CertificatePath               = $CertificatePath
            CertificatePassword           = $CertificatePassword
            ManagedIdentity               = $ManagedIdentity.IsPresent
            TenantId                      = $TenantId
            AccessTokens                  = $AccessTokens
        }

        return $result
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
        $AllAcceptedDomains,

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
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.Boolean]
        $IsTransportRuleScoped,

        [Parameter()]
        [System.String[]]
        $RecipientDomains = @(),

        [Parameter()]
        [System.Boolean]
        $RouteAllMessagesViaOnPremises,

        [Parameter()]
        [System.Boolean]
        $SenderRewritingEnabled,

        [Parameter()]
        [System.String[]]
        $SmartHosts = @(),

        [Parameter()]
        [System.Boolean]
        $TestMode,

        [Parameter()]
        [System.String]
        $TlsDomain,

        [Parameter()]
        [ValidateSet('EncryptionOnly', 'CertificateValidation', 'DomainValidation')]
        [System.String]
        $TlsSettings,

        [Parameter()]
        [System.Boolean]
        $UseMxRecord,

        [Parameter()]
        [System.String[]]
        $ValidationRecipients = @(),

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

    Write-Verbose -Message "Setting configuration of OutBoundConnector for $($Identity)"

    $null = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $OutBoundConnectors = Get-OutBoundConnector
    $OutBoundConnector = $OutBoundConnectors | Where-Object -FilterScript { $_.Identity -eq $Identity }
    $OutBoundConnectorParams = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($Ensure -eq 'Present' -and $null -eq $OutBoundConnector)
    {
        Write-Verbose -Message "Creating OutBoundConnector $($Identity)."
        $OutBoundConnectorParams.Add('Name', $Identity)
        $OutBoundConnectorParams.Remove('Identity') | Out-Null
        $OutBoundConnectorParams.Remove('ValidationRecipients') | Out-Null
        New-OutBoundConnector @OutBoundConnectorParams

        if ($null -ne $ValidationRecipients)
        {
            Write-Verbose -Message 'Updating ValidationRecipients'
            Set-OutboundConnector -Identity $Identity -ValidationRecipients $ValidationRecipients -Confirm:$false
        }
    }
    elseif ($Ensure -eq 'Present' -and $null -ne $OutBoundConnector)
    {
        Write-Verbose -Message "Setting OutBoundConnector $($Identity) with values: $(Convert-M365DscHashtableToString -Hashtable $OutBoundConnectorParams)"
        Set-OutBoundConnector @OutBoundConnectorParams -Confirm:$false
    }
    elseif ($Ensure -eq 'Absent' -and $null -ne $OutBoundConnector)
    {
        Write-Verbose -Message "Removing OutBoundConnector $($Identity)"
        Remove-OutBoundConnector -Identity $Identity -Confirm:$false
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
        $AllAcceptedDomains,

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
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.Boolean]
        $IsTransportRuleScoped,

        [Parameter()]
        [System.String[]]
        $RecipientDomains = @(),

        [Parameter()]
        [System.Boolean]
        $RouteAllMessagesViaOnPremises,

        [Parameter()]
        [System.Boolean]
        $SenderRewritingEnabled,

        [Parameter()]
        [System.String[]]
        $SmartHosts = @(),

        [Parameter()]
        [System.Boolean]
        $TestMode,

        [Parameter()]
        [System.String]
        $TlsDomain,

        [Parameter()]
        [ValidateSet('EncryptionOnly', 'CertificateValidation', 'DomainValidation')]
        [System.String]
        $TlsSettings,

        [Parameter()]
        [System.Boolean]
        $UseMxRecord,

        [Parameter()]
        [System.String[]]
        $ValidationRecipients = @(),

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
        -InboundParameters $PSBoundParameters

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
        [array]$OutboundConnectors = Get-OutboundConnector -IncludeTestModeConnectors:$true -ErrorAction Stop
        if ($OutBoundConnectors.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        $dscContent = [System.Text.StringBuilder]::new()
        $i = 1
        foreach ($OutboundConnector in $OutboundConnectors)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($OutboundConnectors.Length)] $($OutboundConnector.Identity)" -DeferWrite

            $Params = @{
                Identity              = $OutboundConnector.Identity
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
                AccessTokens          = $AccessTokens
            }
            $Script:exportedInstance = $OutboundConnector
            $Results = Get-TargetResource @Params
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            [void]$dscContent.Append($currentDSCBlock)
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            $i++
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
