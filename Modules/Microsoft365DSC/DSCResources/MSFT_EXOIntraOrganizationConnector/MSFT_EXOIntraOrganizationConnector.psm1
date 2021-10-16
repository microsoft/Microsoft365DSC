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
        $CertificatePassword
    )
    Write-Verbose -Message "Getting configuration of IntraOrganizationConnector for $($Identity)"

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
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

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
                Identity              = $Identity
                DiscoveryEndpoint     = $IntraOrganizationConnector.DiscoveryEndpoint.ToString()
                Enabled               = $IntraOrganizationConnector.Enabled
                TargetAddressDomains  = $IntraOrganizationConnector.TargetAddressDomains
                Credential            = $Credential
                Ensure                = 'Present'
                ApplicationId         = $ApplicationId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
                TenantId              = $TenantId
            }

            Write-Verbose -Message "Found IntraOrganizationConnector $($Identity)"
            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
            return $result
        }
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
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
        $CertificatePassword
    )
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Setting configuration of IntraOrganizationConnector for $($Identity)"

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $IntraOrganizationConnectors = Get-IntraOrganizationConnector
    $IntraOrganizationConnector = $IntraOrganizationConnectors | Where-Object -FilterScript { $_.Identity -eq $Identity }
    $IntraOrganizationConnectorParams = [System.Collections.Hashtable]($PSBoundParameters)
    $IntraOrganizationConnectorParams.Remove('Ensure') | Out-Null
    $IntraOrganizationConnectorParams.Remove('Credential') | Out-Null
    $IntraOrganizationConnectorParams.Remove('ApplicationId') | Out-Null
    $IntraOrganizationConnectorParams.Remove('TenantId') | Out-Null
    $IntraOrganizationConnectorParams.Remove('CertificateThumbprint') | Out-Null
    $IntraOrganizationConnectorParams.Remove('CertificatePath') | Out-Null
    $IntraOrganizationConnectorParams.Remove('CertificatePassword') | Out-Null

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
        $CertificatePassword
    )
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of IntraOrganizationConnector for $($Identity)"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('CertificateThumbprint') | Out-Null
    $ValuesToCheck.Remove('CertificatePath') | Out-Null
    $ValuesToCheck.Remove('CertificatePassword') | Out-Null

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
        $CertificatePassword
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        [array]$IntraOrganizationConnectors = Get-IntraOrganizationConnector -ErrorAction Stop
        $dscContent = ""

        if ($IntraOrganizationConnectors.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        $i = 1
        foreach ($IntraOrganizationConnector in $IntraOrganizationConnectors)
        {
            Write-Host "    |---[$i/$($IntraOrganizationConnectors.length)] $($IntraOrganizationConnector.Identity)" -NoNewline

            $Params = @{
                Identity              = $IntraOrganizationConnector.Identity
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                CertificatePath       = $CertificatePath
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
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return ""
    }
}
Export-ModuleMember -Function *-TargetResource
