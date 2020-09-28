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
        [System.String]
        $DiscoveryEndpoint,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String[]]
        $TargetAddressDomains = @(),

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

    Write-Verbose -Message "Getting configuration of IntraOrganizationConnector for $($Identity)"

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
        $IntraOrganizationConnectors = Get-IntraOrganizationConnector -ErrorAction Stop

        $IntraOrganizationConnector = $IntraOrganizationConnectors | Where-Object -FilterScript { $_.Identity -eq $Identity }
        if ($null -eq $IntraOrganizationConnector)
        {
            Write-Verbose -Message "IntraOrganizationConnector $($Identity) does not exist."
            return $nullReturn
        }
        else
        {
            $result = @{
                Identity             = $Identity
                DiscoveryEndpoint    = $IntraOrganizationConnector.DiscoveryEndpoint.ToString()
                Enabled              = $IntraOrganizationConnector.Enabled
                TargetAddressDomains = $IntraOrganizationConnector.TargetAddressDomains
                GlobalAdminAccount   = $GlobalAdminAccount
                Ensure               = 'Present'
            }

            Write-Verbose -Message "Found IntraOrganizationConnector $($Identity)"
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
        [System.String]
        $DiscoveryEndpoint,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String[]]
        $TargetAddressDomains = @(),

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

    Write-Verbose -Message "Setting configuration of IntraOrganizationConnector for $($Identity)"

    $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $IntraOrganizationConnectors = Get-IntraOrganizationConnector
    $IntraOrganizationConnector = $IntraOrganizationConnectors | Where-Object -FilterScript { $_.Identity -eq $Identity }
    $IntraOrganizationConnectorParams = $PSBoundParameters
    $IntraOrganizationConnectorParams.Remove('Ensure') | Out-Null
    $IntraOrganizationConnectorParams.Remove('GlobalAdminAccount') | Out-Null

    if (('Present' -eq $Ensure ) -and ($null -eq $IntraOrganizationConnector))
    {
        Write-Verbose -Message "Creating IntraOrganizationConnector $($Identity)."
        $IntraOrganizationConnectorParams.Add("Name", $Identity)
        $IntraOrganizationConnectorParams.Remove('Identity') | Out-Null
        New-IntraOrganizationConnector @IntraOrganizationConnectorParams
    }
    elseif (('Present' -eq $Ensure ) -and ($Null -ne $IntraOrganizationConnector))
    {
        Write-Verbose -Message "Setting IntraOrganizationConnector $($Identity) with values: $(Convert-M365DscHashtableToString -Hashtable $IntraOrganizationConnectorParams)"
        Set-IntraOrganizationConnector @IntraOrganizationConnectorParams -Confirm:$false
    }
    elseif (('Absent' -eq $Ensure ) -and ($null -ne $IntraOrganizationConnector))
    {
        Write-Verbose -Message "Removing IntraOrganizationConnector $($Identity)"
        Remove-IntraOrganizationConnector -Identity $Identity -Confirm:$false
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
        [System.String]
        $DiscoveryEndpoint,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String[]]
        $TargetAddressDomains = @(),

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

    Write-Verbose -Message "Testing configuration of IntraOrganizationConnector for $($Identity)"

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
        [array]$IntraOrganizationConnectors = Get-IntraOrganizationConnector -ErrorAction Stop
        $dscContent = ""

        if ($IntraOrganizationConnectors.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else {
            Write-Host "`r`n" -NoNewLine
        }
        $i = 1
        foreach ($IntraOrganizationConnector in $IntraOrganizationConnectors)
        {
            Write-Host "    |---[$i/$($IntraOrganizationConnectors.length)] $($IntraOrganizationConnector.Identity)" -NoNewLine

            $Params = @{
                Identity              = $IntraOrganizationConnector.Identity
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
