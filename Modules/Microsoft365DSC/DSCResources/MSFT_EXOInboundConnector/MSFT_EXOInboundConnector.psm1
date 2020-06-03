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
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of InboundConnector for $($Identity)"

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $InboundConnectors = Get-InboundConnector

    $InboundConnector = $InboundConnectors | Where-Object -FilterScript { $_.Identity -eq $Identity }
    if ($null -eq $InboundConnector)
    {
        Write-Verbose -Message "InboundConnector $($Identity) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
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
            Enabled                      = $InboundConnector.Enabled
            RequireTls                   = $InboundConnector.RequireTls
            RestrictDomainsToCertificate = $InboundConnector.RestrictDomainsToCertificate
            RestrictDomainsToIPAddresses = $InboundConnector.RestrictDomainsToIPAddresses
            SenderDomains                = $InboundConnector.SenderDomains
            SenderIPAddresses            = $InboundConnector.SenderIPAddresses
            TlsSenderCertificateName     = $InboundConnector.TlsSenderCertificateName
            TreatMessagesAsInternal      = $InboundConnector.TreatMessagesAsInternal
            GlobalAdminAccount           = $GlobalAdminAccount
            Ensure                       = 'Present'
        }

        Write-Verbose -Message "Found InboundConnector $($Identity)"
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
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of InboundConnector for $($Identity)"

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $InboundConnectors = Get-InboundConnector
    $InboundConnector = $InboundConnectors | Where-Object -FilterScript { $_.Identity -eq $Identity }
    $InboundConnectorParams = $PSBoundParameters
    $InboundConnectorParams.Remove('Ensure') | Out-Null
    $InboundConnectorParams.Remove('GlobalAdminAccount') | Out-Null

    if (('Present' -eq $Ensure ) -and ($null -eq $InboundConnector))
    {
        Write-Verbose -Message "Creating InboundConnector $($Identity)."
        $InboundConnectorParams.Add("Name", $Identity)
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
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of InboundConnector for $($Identity)"

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

    [array]$InboundConnectors = Get-InboundConnector
    $content = ""
    $i = 1
    foreach ($InboundConnector in $InboundConnectors)
    {
        Write-Information "    [$i/$($InboundConnectors.length)] $($InboundConnector.Identity)"

        $Params = @{
            Identity           = $InboundConnector.Identity
            GlobalAdminAccount = $GlobalAdminAccount
        }

        $result = Get-TargetResource @Params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content += "        EXOInboundConnector " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $content += "        }`r`n"
        $i++
    }
    return $content
}
Export-ModuleMember -Function *-TargetResource
