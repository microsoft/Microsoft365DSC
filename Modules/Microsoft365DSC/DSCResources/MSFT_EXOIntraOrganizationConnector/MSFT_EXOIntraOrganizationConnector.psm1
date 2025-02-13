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
        [System.String]
        $TargetSharingEpr,

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
        $IntraOrganizationConnectors = Get-IntraOrganizationConnector -ErrorAction Stop

        $IntraOrganizationConnector = $IntraOrganizationConnectors | Where-Object -FilterScript { $_.Identity -eq $Identity }
        if ($null -eq $IntraOrganizationConnector)
        {
            Write-Verbose -Message "IntraOrganizationConnector $($Identity) does not exist."
            return $nullReturn
        }
        else
        {
            $DiscoveryEndpointValue = $IntraOrganizationConnector.DiscoveryEndpoint.ToString()
            if (-not $DiscoveryEndpointValue.EndsWith('/'))
            {
                $DiscoveryEndpointValue += '/'
            }
            if ($IntraOrganizationConnector.TargetSharingEpr)
            {
                $TargetSharingEprValue = $IntraOrganizationConnector.TargetSharingEpr.AbsoluteUri.ToString()
            }
            else
            {
                $TargetSharingEprValue = ''
            }
            $result = @{
                Identity              = $Identity
                DiscoveryEndpoint     = $IntraOrganizationConnector.DiscoveryEndpoint.ToString()
                Enabled               = $IntraOrganizationConnector.Enabled
                TargetAddressDomains  = $IntraOrganizationConnector.TargetAddressDomains
                TargetSharingEpr      = $TargetSharingEprValue
                Credential            = $Credential
                Ensure                = 'Present'
                ApplicationId         = $ApplicationId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
                Managedidentity       = $ManagedIdentity.IsPresent
                TenantId              = $TenantId
                AccessTokens          = $AccessTokens
            }

            Write-Verbose -Message "Found IntraOrganizationConnector $($Identity)"
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
        [System.String]
        $DiscoveryEndpoint,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String[]]
        $TargetAddressDomains = @(),

        [Parameter()]
        [System.String]
        $TargetSharingEpr,

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
    $IntraOrganizationConnectorParams.Remove('ManagedIdentity') | Out-Null
    $IntraOrganizationConnectorParams.Remove('AccessTokens') | Out-Null

    if (('Present' -eq $Ensure ) -and ($null -eq $IntraOrganizationConnector))
    {
        Write-Verbose -Message "Creating IntraOrganizationConnector $($Identity)."
        $IntraOrganizationConnectorParams.Add('Name', $Identity)
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
        [System.String]
        $TargetSharingEpr,

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

    Write-Verbose -Message "Testing configuration of IntraOrganizationConnector for $($Identity)"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters

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
        [array]$IntraOrganizationConnectors = Get-IntraOrganizationConnector -ErrorAction Stop
        $dscContent = ''

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
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-Host "    |---[$i/$($IntraOrganizationConnectors.length)] $($IntraOrganizationConnector.Identity)" -NoNewline

            $Params = @{
                Identity              = $IntraOrganizationConnector.Identity
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
