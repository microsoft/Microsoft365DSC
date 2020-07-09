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

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of OutBoundConnector for $($Identity)"

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $OutBoundConnectors = Get-OutBoundConnector

    $OutBoundConnector = $OutBoundConnectors | Where-Object -FilterScript { $_.Identity -eq $Identity }
    if ($null -eq $OutBoundConnector)
    {
        Write-Verbose -Message "OutBoundConnector $($Identity) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
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

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of OutBoundConnector for $($Identity)"

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

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

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of OutBoundConnector for $($Identity)"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

    $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
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
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    $InformationPreference = "Continue"
    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline `
        -ErrorAction SilentlyContinue

    [array]$OutboundConnectors = Get-OutboundConnector
    $content = ""
    $i = 1
    foreach ($OutboundConnector in $OutboundConnectors)
    {
        Write-Information "    [$i/$($OutboundConnectors.length)] $($OutboundConnector.Identity)"

        $Params = @{
            Identity           = $OutboundConnector.Identity
            GlobalAdminAccount = $GlobalAdminAccount
        }

        $result = Get-TargetResource @Params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content += "        EXOOutboundConnector " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $content += "        }`r`n"
        $i++
    }
    return $content
}
Export-ModuleMember -Function *-TargetResource
