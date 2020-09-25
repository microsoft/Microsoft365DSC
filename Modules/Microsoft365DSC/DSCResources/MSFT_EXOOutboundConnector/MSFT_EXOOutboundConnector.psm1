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
        [System.String[]]
        $SmartHosts = @(),

        [Parameter()]
        [System.Boolean]
        $TestMode,

        [Parameter()]
        [System.String[]]
        $TlsDomain = @(),

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
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

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
        $CertificatePassword
    )

    Write-Verbose -Message "Getting configuration of OutBoundConnector for $($Identity)"

    if ($Global:CurrentModeIsExport)
    {
        $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters `
            -SkipModuleReload $true
    }
    else
    {
        $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters
    }
    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'
    try
    {
        $OutBoundConnectors = Get-OutBoundConnector -ErrorAction Stop

        $OutBoundConnector = $OutBoundConnectors | Where-Object -FilterScript { $_.Identity -eq $Identity }
        if ($null -eq $OutBoundConnector)
        {
            Write-Verbose -Message "OutBoundConnector $($Identity) does not exist."
            return $nullReturn
        }
        else
        {
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
                ConnectorSource               = $ConnectorSource
                ConnectorType                 = $OutBoundConnector.ConnectorType
                Enabled                       = $OutBoundConnector.Enabled
                IsTransportRuleScoped         = $OutBoundConnector.IsTransportRuleScoped
                RecipientDomains              = $OutBoundConnector.RecipientDomains
                RouteAllMessagesViaOnPremises = $OutBoundConnector.RouteAllMessagesViaOnPremises
                SmartHosts                    = $OutBoundConnector.SmartHosts
                TestMode                      = $OutBoundConnector.TestMode
                TlsDomain                     = $OutBoundConnector.TlsDomain
                TlsSettings                   = $OutBoundConnector.TlsSettings
                UseMxRecord                   = $OutBoundConnector.UseMxRecord
                ValidationRecipients          = $OutBoundConnector.ValidationRecipients
                GlobalAdminAccount            = $GlobalAdminAccount
                Ensure                        = 'Present'
            }

            Write-Verbose -Message "Found OutBoundConnector $($Identity)"
            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
            return $result
        }
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
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
        [System.String[]]
        $SmartHosts = @(),

        [Parameter()]
        [System.Boolean]
        $TestMode,

        [Parameter()]
        [System.String[]]
        $TlsDomain = @(),

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
        $GlobalAdminAccount,

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
        $CertificatePassword
    )

    Write-Verbose -Message "Setting configuration of OutBoundConnector for $($Identity)"

    $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $OutBoundConnectors = Get-OutBoundConnector
    $OutBoundConnector = $OutBoundConnectors | Where-Object -FilterScript { $_.Identity -eq $Identity }
    $OutBoundConnectorParams = $PSBoundParameters
    $OutBoundConnectorParams.Remove('Ensure') | Out-Null
    $OutBoundConnectorParams.Remove('GlobalAdminAccount') | Out-Null


    if (('Present' -eq $Ensure ) -and ($null -eq $OutBoundConnector))
    {
        Write-Verbose -Message "Creating OutBoundConnector $($Identity)."
        $OutBoundConnectorParams.Add("Name", $Identity)
        $OutBoundConnectorParams.Remove('Identity') | Out-Null
        $OutBoundConnectorParams.Remove("ValidationRecipients") | Out-Null
        New-OutBoundConnector @OutBoundConnectorParams
    }
    elseif (('Present' -eq $Ensure ) -and ($Null -ne $OutBoundConnector))
    {
        Write-Verbose -Message "Setting OutBoundConnector $($Identity) with values: $(Convert-M365DscHashtableToString -Hashtable $OutBoundConnectorParams)"
        Set-OutBoundConnector @OutBoundConnectorParams -Confirm:$false
    }
    elseif (('Absent' -eq $Ensure ) -and ($null -ne $OutBoundConnector))
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
        [System.String[]]
        $SmartHosts = @(),

        [Parameter()]
        [System.Boolean]
        $TestMode,

        [Parameter()]
        [System.String[]]
        $TlsDomain = @(),

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
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

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
        $CertificatePassword
    )

    Write-Verbose -Message "Testing configuration of OutBoundConnector for $($Identity)"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

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
        $GlobalAdminAccount,

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
        $CertificatePassword
    )
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

    try
    {
        [array]$OutboundConnectors = Get-OutboundConnector -ErrorAction Stop
        if ($OutBoundConnectors.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewLine
        }
        $dscContent = ""
        $i = 1
        foreach ($OutboundConnector in $OutboundConnectors)
        {
            Write-Host "    |---[$i/$($OutboundConnectors.Length)] $($OutboundConnector.Identity)" -NoNewLine

            $Params = @{
                Identity              = $OutboundConnector.Identity
                GlobalAdminAccount    = $GlobalAdminAccount
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                CertificatePath       = $CertificatePath
            }
            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $dscContent += Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -GlobalAdminAccount $GlobalAdminAccount
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
        }
        return $dscContent
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return ""
    }
}
Export-ModuleMember -Function *-TargetResource
