Confirm-M365DSCModuleDependency -ModuleName 'MSFT_EXOIntraOrganizationConnector'

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

            $IntraOrganizationConnector = Get-IntraOrganizationConnector -Identity $Identity -ErrorAction SilentlyContinue
            if ($null -eq $IntraOrganizationConnector)
            {
                Write-Verbose -Message "IntraOrganizationConnector $($Identity) does not exist."
                return $nullReturn
            }
        }
        else
        {
            $IntraOrganizationConnector = $Script:exportedInstance
        }

        Write-Verbose -Message "Found IntraOrganizationConnector $($Identity)"

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
            ManagedIdentity       = $ManagedIdentity.IsPresent
            TenantId              = $TenantId
            AccessTokens          = $AccessTokens
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

    $null = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $IntraOrganizationConnectors = Get-IntraOrganizationConnector
    $IntraOrganizationConnector = $IntraOrganizationConnectors | Where-Object -FilterScript { $_.Identity -eq $Identity }
    $IntraOrganizationConnectorParams = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($IntraOrganizationConnectorParams.TargetSharingEpr -eq '')
    {
        $IntraOrganizationConnectorParams.TargetSharingEpr = $null
    }
    if (('Present' -eq $Ensure ) -and ($null -eq $IntraOrganizationConnector))
    {
        Write-Verbose -Message "Creating IntraOrganizationConnector $($Identity) with:`r`n $(ConvertTo-Json $IntraOrganizationConnectorParams -Depth 10)"
        $IntraOrganizationConnectorParams.Add('Name', $Identity)
        $IntraOrganizationConnectorParams.Remove('Identity') | Out-Null
        New-IntraOrganizationConnector @IntraOrganizationConnectorParams
    }
    elseif (('Present' -eq $Ensure ) -and ($null -ne $IntraOrganizationConnector))
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
        [array]$IntraOrganizationConnectors = Get-IntraOrganizationConnector -ErrorAction Stop
        $dscContent = ''

        if ($IntraOrganizationConnectors.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        $i = 1
        foreach ($IntraOrganizationConnector in $IntraOrganizationConnectors)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($IntraOrganizationConnectors.Length)] $($IntraOrganizationConnector.Identity)" -DeferWrite

            $Params = @{
                Identity              = $IntraOrganizationConnector.Identity
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
                AccessTokens          = $AccessTokens
            }
            $Script:exportedInstance = $IntraOrganizationConnector
            $Results = Get-TargetResource @Params
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            $i++
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
